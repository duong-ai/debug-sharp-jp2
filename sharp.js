import { readFileSync } from "fs";
import sharp from "sharp";

const buffer = readFileSync("image.jp2");

const main = async () => {
  let res;
  try {
    res = await sharp(buffer)
      .toColourspace("lch")
      .extractChannel(0)
      .raw()
      .toBuffer({ resolveWithObject: true });
    console.log(res);
  } catch (error) {
    console.error(error);
  }
};

main();
