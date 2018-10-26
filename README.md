# Kinoma Element Project Template

_Warning: This is code for a product that is no longer available! Don't bother trying to find a Kinoma product: they were cool but there's better choices out there now. I suggest taking a look at [Moddable](http://moddable.com). That's the team that developed the Kinoma product line, and they've continued the work on the XS JavaScript runtime and hardware support._

A simple project template for updating the (now defunct) Kinoma Element.

## Rationale

Since the [Kinoma](https://kinoma.com) product line is pretty much dead, I've dumped the Kinoma Code IDE. But I've still got a Kinoma Element device, so I might still play with it from time to time. Fortunately, the device itself has pretty much everything that is needed to do development on it.

## Getting Set Up

You really don't need much to work with the Kinoma Element. They did have an IDE available, but most of what it provided was visualizations of things you can access in other ways.

There are a few things that you'll need or want if you're going to use this project:

- A Kinoma Element
- `deploy.sh` depends on curl
- A decent code editor. I like [VSCode](https://code.visualstudio.com)
- `telnet` can be useful if you want to connect to the console
- `tftp` is also useful if you want to upload files (only to the `k3` filesystem, though)

## Project Files

There are a few files that are needed to run applications on the Kinoma Element

- application.xml
- main.js

Both of these end up in the `k0` directory on the local filesystem.

Sample application.xml:

```xml
<?xml version="1.0" encoding="utf-8"?>
<application xmlns="http://www.kinoma.com/kpr/application/1" id="MyApp" program="src/main" title="MyApp"></application>
```

Sample main.js, using the application framework (does nothing!)

```js
export default {
    onLaunch() {
    },
    onQuit() {
    }
};
```

**Note: the Element seems to follow strict rules for ES6, so include semicolons or you'll get errors!**

## Upload and launch

Here's the sequence of commands to upload and start a new application as cURL commands. `[host]` here can be either the IP address (e.g. `192.168.1.100`) or the mDNS name of the device (e.g. `myKinoma.local`).

```sh
# disconnect from the device if already connected
curl -X PUT \
  http://[host]:10000/disconnect \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: text/plain'

# upload the application.xml for the app
curl -X POST \
  'http://[host]:10000/upload?path=applications/MyApp/src/application.xml&temporary=false' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: text/plain' \
  -d @application.xml

# upload the application file for the app
curl -X POST \
  'http://[host]:10000/upload?path=applications/MyApp/src/main.js&temporary=false' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: text/plain' \
  -d @main.js

# start the app; "app_name" should be the same as the app id in application.xml
curl -X PUT \
  'http://[host]:10000/launch?id=MyApp&file=main.js' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: text/plain'
```

For convenience sake, I've wrapped all of this in `deploy.sh`, which works like this:

```sh
$ ./deploy.sh 192.168.1.100 MyApp

// silently deploys the app via cURL
```

This will deploy the contents of `src` to a Kinoma Element.

## Connecting to Kinoma Element

There are a few useful ways to connect directly to a Kinoma Element. Note that you can connect via the DHCP-assigned IP address (e.g. 192.160.0.100) or mDNS locally advertised hostname (e.g `kinomaElement.local`).

### Telnet

Connects to the console of the Element, so that you can monitor programs and send commands.

```sh
$ telnet [IP address] 2323
```

or 

```sh
$ telnet [hostname].local 2323
```

### TFTP

Connects to the Element for file upload/download from the `k3` partition.

```sh
$ tftp -a [IP address] 6969
```

or

```sh
$ tftp -a [hostname].local 6969
```

### HTTP

It is also possible to send data and commands to the element via HTTP. This is how files get deployed to the device. See `deploy.sh` for an example of how this is done.

## Useful links (while they last)

- [Programmer's Guide to Kinoma Element](http://kinoma.com/develop/documentation/element/)
- [Using the Pins Module to Interact with Sensors on Kinoma Element](http://kinoma.com/develop/documentation/element-pins-module/)
- [Programming with Hardware Pins for Kinoma Element](http://kinoma.com/develop/documentation/element-bll/)
- [Kinoma example code](http://kinoma.com/develop/samples/)
- [KinomaJS Blocks (Blockly IDE)](https://kinomajsblocks.appspot.com/static/index.html#) - I used this to reverse engineer the upload process for apps

*Update 10/2018:* Most of the links above are dead; they point to the [Kinoma GitHub](https://github.com/Kinoma/) repositories now. Blocks still works, but I have to imagine it will come down sometime soon.
