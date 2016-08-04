var electron = require('electron');
var app = electron.app;
var BrowserWindow = electron.BrowserWindow;

function createWindow() {
  var win = new BrowserWindow({width: 600, height: 400});

  win.loadURL(`file://${__dirname}/index.html`);

  win.on('closed', () => {
    win = null;
  });
}

app.on('ready', createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (win === null) {
    createWindow();
  }
});
