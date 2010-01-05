Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.59.93.47.78.clients.your-server.de ([78.47.93.59]:39734
	"EHLO sanguine.eifelfeten.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab0AEJQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 04:16:13 -0500
Subject: em28xx: New device request and tvp5150 distortion issues when
 capturing from vcr
From: Michael =?ISO-8859-1?Q?R=FCttgers?= <ich@michael-ruettgers.de>
To: linux-media@vger.kernel.org
Cc: devin.heitmueller@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 09:40:04 +0100
Message-ID: <1262680804.26250.10.camel@wi-289.weiss.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

a year ago I bought a device named "Hama Video Editor", which was not
(and is not yet) supported by the em28xx driver.
So I played around with the card parameter and got the device basically
working with card=38.
Basically working means, that I had a distortion when capturing old
VHS-Tapes from my old vcr.

The problem can be seen here:
http://www.michael-ruettgers.de/em28xx/test.avi

A few weeks ago I started tracking down the reason for this issue with
the help of Devin.
Wondering, that the device works perfectly in Windows, I compared the
i2c commands, that programmed the register of the tvp5150 in Windows.

Finally I got the device working properly, setting the "TV/VCR" option
in the register "Operation Mode Controls Register" at address 02h
manually to "Automatic mode determined by the internal detection
circuit. (default)":

000109:  OUT: 000000 ms 107025 ms 40 02 00 00 b8 00 02 00 >>>  02 00

After programming this register, the distortion issue disappeared.

So my conclusion was, that the TV/VCR detection mode is forced to
TV-mode in the em28xx, which could have been verified by a look into the
debug output using the parameter reg_debug=1:

OUT: 40 02 00 00 b8 00 02 00 >>> 02 30

Bit 4, 5 are used for setting the TV/VCR mode:

Description in the Spec:
> TV/VCR mode
>   00 = Automatic mode determined by the internal detection circuit.
(default)
>   01 = Reserved
>   10 = VCR (nonstandard video) mode
>   11 = TV (standard video) mode
> With automatic detection enabled, unstable or nonstandard syncs on the
input video forces the detector into the VCR
> mode. This turns off the comb filters and turns on the chroma trap
filter.

Thus far the tvp5150 distortion issues when capturing from vcr.

-----------

The device not supported yet but mostly working with card=38 has the
following features:

1 Button
1 LED
1 S-VHS input
1 Composite video input (Chinch) 
1 Stereo audio input (2 x Chinch)

The inputs are matched correctly to the video sources in a viewer-app
(S-VHS -> S-VHS, Composite -> Composite1).


It's product name is "Hama USB 2.0 Video Editor":
http://www.hama.de/portal/articleId*139673/action*2563


This board has no unique USB ID but could be detected by its i2c
devicelist hash "0x77800080":

> [  119.160182] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0,
class 0)
> [  119.160297] em28xx #0: chip ID is em2860
> [  119.283595] em28xx #0: board has no eeprom
> [  119.300289] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
> [  119.323789] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
> [  119.332914] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
> [  119.332917] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
> [  119.332919] em28xx #0: Please send an email with this log to: 
> [  119.332920] em28xx #0: V4L Mailing List
<linux-media@vger.kernel.org>
> [  119.332922] em28xx #0: Board eeprom hash is 0x00000000
> [  119.332924] em28xx #0: Board i2c devicelist hash is 0x77800080

This board seem to be branded under another name in Austria:
http://lists-archives.org/video4linux/27246-empia-device-without-unique-usb-id-or-eeprom.html

On Mon, Apr 20, 2009 at 9:06 AM, Anthony Hogan <anthony-v4l@xxxxxxxxxxx>
wrote:
> Aldi (Supermarket chain) Fission (home brand) USB hi-speed dvd maker
> Aldi Product number/SKU: 6675
> Model Number: DK-8703
> Composite + SVHS video input
> Stereo line-level audio input
> Single button, single LED
> No FCC ID (intended for Australian/European market, only has CE and
"Tick" mark)

-----------

I would appreciate to see this device beeing detected and working
correctly for capturing even from a vcr with weak sync signals.

Thanks.

Regards,

Michael Rüttgers

