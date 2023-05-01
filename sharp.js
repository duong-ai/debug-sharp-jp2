import { readFileSync } from "fs";
import sharp from "sharp";

const buffer = readFileSync("image.jp2");

const main = async () => {
  try {
    const convertedJpeg = await convertToJpeg(buffer);
    console.log(convertedJpeg);
  } catch (error) {
    console.error(error);
  }
};

main();

async function getLuminance(buffer) {
  const { data, info } = await sharp(buffer)
    .toColourspace("lch")
    .extractChannel(0)
    .raw()
    .toBuffer({ resolveWithObject: true });

  const { channels } = await sharp(data, { raw: info }).stats();
  return channels[0]
}

async function convertToJpeg(buffer, monochrome, hasForeignObject, file) {
  let image = sharp(buffer).removeAlpha()

  //Extract min and maximum luminance levels
  let { min, max } = await getLuminance(buffer)

  if (min !== 0) {
    // Image luminance range has been modified by radiologist since xray haves a relative scale
    // remove added luminance
    buffer = await image.modulate({
      lightness: -min
    }).toBuffer()

    // Update min and max luminance levels
    const luminance = await getLuminance(buffer)
    max = luminance.max
    min = luminance.min

    image = sharp(buffer)
  }

  // Normalise based on luminance range
  buffer = await image.modulate({
    brightness: 100 / (max - min),
    lightness: -min
  }).toBuffer()

  image = sharp(buffer)

  /**
   * Normalise 98% of pixels across the 0-255 range
   * this clips all pixels above the 98% threshold to 255 greyscale
   * whic is the same as 100 on the luminance scale
   * This is for xray images which have a respective scale
   */
  image = image.normalise({ lowerBin: 0, upperBin: 98 })

  if (monochrome) {
    image = image.negate()
  }

  return image.jpeg({
    quality: 99
  }).toBuffer()
}