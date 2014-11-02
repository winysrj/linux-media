Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43078 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKBLq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Nov 2014 06:46:28 -0500
Date: Sun, 2 Nov 2014 09:46:21 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH 3/7] [media] cx231xx: Cleanup printk at the driver
Message-ID: <20141102094621.2ec45338@recife.lan>
In-Reply-To: <5454E7A8.40707@iki.fi>
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
	<c347502e632c69c80dcf5d4df1396cb59973af2f.1414849031.git.mchehab@osg.samsung.com>
	<5454E7A8.40707@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 01 Nov 2014 16:01:12 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 11/01/2014 03:38 PM, Mauro Carvalho Chehab wrote:
> > There are lots of debug printks printed with pr_info. Also, the
> > printk's data are not too coherent:
> >
> > - there are duplicated driver name at the print format;
> > - function name format string differs from function to function;
> > - long strings broken into multiple lines;
> > - some printks just produce ugly reports, being almost useless
> >    as-is.
> >
> > Do a cleanup on that.
> >
> > Still, there are much to be done in order to do a better printk
> > job on this driver, but, at least it will now be a way less
> > verbose, if debug printks are disabled, and some logs might
> > actually be useful.
> 
> As you do that kind of cleanup, why don't just use a bit more time and 
> do it properly using dev_foo() logging. Basically all device drivers 
> should use dev_foo() logging, it prints module name, bus number etc. 
> automatically in a standard manner. pr_foo() is worse, which should be 
> only used for cases where pointer to device is not available (like library).

I did the conversion. It now prints:

Load time:

[  608.359255] usb 1-2: New device Conexant Corporation Polaris AV Capturb @ 480 Mbps (1554:5010) with 7 interfaces
[  608.360009] usb 1-2: Identified as Pixelview PlayTV USB Hybrid (card=10)
[  608.363129] i2c i2c-8: Added multiplexed i2c bus 10
[  608.363201] i2c i2c-8: Added multiplexed i2c bus 11
[  608.560247] cx25840 7-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0-0)
[  610.968904] cx25840 7-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
[  611.041317] Chip ID is not zero. It is not a TEA5767
[  611.041351] tuner 9-0060: Tuner -1 found with type(s) Radio TV.
[  611.041429] tda18271 9-0060: creating new instance
[  611.044096] TDA18271HD/C2 detected @ 9-0060
[  611.239460] tda18271: performing RF tracking filter calibration
[  612.800569] tda18271: RF tracking filter calibration complete
[  612.835365] usb 1-2: v4l2 driver version 0.0.3
[  613.055006] usb 1-2: Registered video device video0 [v4l2]
[  613.055461] usb 1-2: Registered VBI device vbi0
[  613.110279] Registered IR keymap rc-pixelview-002t
[  613.110574] input: i2c IR (Pixelview PlayTV USB Hy as /devices/virtual/rc/rc0/input12
[  613.111398] rc0: i2c IR (Pixelview PlayTV USB Hy as /devices/virtual/rc/rc0
[  613.111409] ir-kbd-i2c: i2c IR (Pixelview PlayTV USB Hy detected at i2c-9/9-0030/ir0 [cx231xx #0-2]
[  613.111444] usb 1-2: video EndPoint Addr 0x84, Alternate settings: 5
[  613.111454] usb 1-2: VBI EndPoint Addr 0x85, Alternate settings: 2
[  613.111465] usb 1-2: sliced CC EndPoint Addr 0x86, Alternate settings: 2
[  613.111474] usb 1-2: TS EndPoint Addr 0x81, Alternate settings: 6
[  613.111654] usbcore: registered new interface driver cx231xx
[  613.136510] usb 1-2: audio EndPoint Addr 0x83, Alternate settings: 3
[  613.136521] usb 1-2: Cx231xx Audio Extension initialized
[  613.199085] usb 1-2: dvb_init: looking for demod on i2c bus: 9
[  613.232349] i2c i2c-11: Detected a Fujitsu mb86a20s frontend
[  613.232385] tda18271 9-0060: attaching existing instance
[  613.232392] DVB: registering new adapter (cx231xx #0)
[  613.232402] usb 1-2: DVB: registering adapter 0 frontend 0 (Fujitsu mb86A20s)...
[  613.234528] usb 1-2: Successfully loaded cx231xx-dvb
[  613.234618] usb 1-2: Cx231xx dvb Extension initialized

We might eventually get rid of some messages there, like changing
the USB interface settings detection messages to debug for video, vbi,
sliced CC, TS and audio, but this is a potential source of problems,
if it got mis-detected. So, I would keep it there for now.

If i2c_scan, it will also show:

[  608.371656] usb 1-2: i2c scan: found device @ port 0 addr 0x40  [???]
[  608.374750] usb 1-2: i2c scan: found device @ port 0 addr 0x60  [colibri]
[  608.378433] usb 1-2: i2c scan: found device @ port 0 addr 0x88  [hammerhead]
[  608.380226] usb 1-2: i2c scan: found device @ port 0 addr 0x98  [???]
[  608.405747] usb 1-2: i2c scan: found device @ port 3 addr 0xa0  [eeprom]
[  608.422310] usb 1-2: i2c scan: found device @ port 2 addr 0x60  [colibri]
[  608.430229] usb 1-2: i2c scan: found device @ port 2 addr 0xc0  [tuner]
[  608.438793] usb 1-2: i2c scan: found device @ port 4 addr 0x20  [demod]

At remove time, it will print:

[  919.440166] usb 1-2: Cx231xx dvb Extension removed
[  936.428407] usb 1-2: Cx231xx Audio Extension removed
[  936.433072] usbcore: deregistering interface driver cx231xx
[  936.433112] usb 1-2: V4L2 device vbi0 deregistered
[  936.433244] usb 1-2: V4L2 device video0 deregistered
[  936.433505] tda18271 9-0060: destroying instance

I'm posting the patches.

Regards,
Mauro
