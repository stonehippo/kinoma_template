# kinoma_template
A simple project template for updating the (now defunct) Kinoma Element.

## Rationale

Since the [Kinoma](https://kinoma.com) product line is pretty much dead, I've dumped the Kinoma Code IDE. But I've still got one of the Kinoma Element devices, so I might still play with it from time to time. Fortunately, the device itself has pretty everything that is needed to do development on it.

## Project Files

There are a few files that are needed to run applications on the Kinoma Element

- application.xml
- main.js

Both of these end up in the `k0` directory on the local filesystem.

Sample application.xml:

```
<?xml version="1.0" encoding="utf-8"?><application xmlns="http://www.kinoma.com/kpr/application/1" id="MyApp" program="src/main" title="MyApp"></application>
```

Sample main.js, using the application framework (does nothing!)

```
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

This will deploy the content of `src` to a Kinoma Element.

## Useful links (while they last)

- [Programmer's Guide to Kinoma Element](http://kinoma.com/develop/documentation/element/)
- [Kinoma example code](http://kinoma.com/develop/samples/)
- [KinomaJS Blocks (Blockly IDE)](https://kinomajsblocks.appspot.com/static/index.html#) - I used this to reverse engineer the upload process for apps
