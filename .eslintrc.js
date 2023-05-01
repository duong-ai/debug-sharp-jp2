module.exports = {
    env: {
        browser: true,
        es2021: true,
    },
    extends: "eslint:recommended",
    overrides: [
        {
            files: ["sharp.js"],
        },
    ],
    parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
    },
    rules: {},
};
