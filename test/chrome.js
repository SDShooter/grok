const { Browser, Builder, By } = require("selenium-webdriver");
const chrome = require("selenium-webdriver/chrome");

async function runSelenium() {
  let options = new chrome.Options();
  options.addArguments("--headless=new"); // Runs browser without GUI

  let driver = new Builder()
    .forBrowser(Browser.CHROME)
    .setChromeOptions(options.addArguments("--headless=new"))
    .build();

  try {
    await driver.get("https://google.com");
    let title = await driver.getTitle();
    console.log("Page title is:", title);
  } finally {
    await driver.quit();
  }
}

runSelenium();
