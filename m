Return-path: <linux-media-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:60614 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZHNFMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2009 01:12:49 -0400
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-media@vger.kernel.org
Subject: Re: KWorld UB435-Q support?
Date: Thu, 13 Aug 2009 23:12:49 -0600
Cc: Jarod Wilson <jarod@wilsonet.com>
References: <200908122253.12021.tfjellstrom@shaw.ca> <88086BD2-53BB-4095-A927-0DFB25F8BD59@wilsonet.com>
In-Reply-To: <88086BD2-53BB-4095-A927-0DFB25F8BD59@wilsonet.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908132312.50010.tfjellstrom@shaw.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu August 13 2009, Jarod Wilson wrote:
> On Aug 13, 2009, at 12:53 AM, Thomas Fjellstrom wrote:
> > I stupidly bought the KWorld UB435-Q usb ATSC tuner thinking it was
> > supported
> > under linux, and it turns out it isn't. I'm wondering what it would
> > take to
> > get it supported. It seems like all of the main chips it uses are
> > supported,
> > but the glue code is missing.
> >
> > I have some C (10 years) programming experience, and have wanted to
> > contribute
> > to the linux kernel for quite a while, now I have a good excuse ;)
> >
> > Would anyone be willing to point me in the right direction?
>
> The UB435-Q is a rebadge of the revision B 340U, which is an em2870
> bridge, lgdt3304 demodulator and an nxp tda18271hd/c2 tuner. Its got
> the same device ID and everything. I've got a rev A 340U, the only
> difference being that it has an nxp tda18271hd/c1 tuner (also same
> device ID). I *had* it working just fine until the stick up and died
> on me, before I could push the code for merge, but its still floating
> about. It wasn't quite working with a c2 device, but that could have
> been a device problem (these are quite franky, cheap and poorly made
> devices, imo). It could also be that the code ate both sticks and will
> pickle yours as well.
>
> With that caveat emptor, here's where the tree that should at least
> get you 95% of the way there with that stick resides:
>
> http://www.kernellabs.com/hg/~mkrufky/lgdt3304-3/
>
> The last two patches are the relevant ones. They add lgdt3304 demod
> support to the lgdt3305 driver (because the current lgdt3304 driver
> is, um, lacking) and then add the bits to wire up the stick.

Hi, thanks for the tips. I've applied the last two patches to v4l "tip", a few 
hunks failed, but I managed to apply them by hand, though possibly not 
correctly as I can't seem to find a program that thinks the /dev/video0 device 
that pops up is valid. One app claims there is no input on /dev/video0, and 
others just get "select timeouts" and such (also errors regarding formats and 
whatnot).

Upon inserting the stick I get the following from dmesg:

[68582.498964] em28xx: New device USB 2870 Device @ 480 Mbps (1b80:a340, 
interface 0, class 0)
[68582.499243] em28xx #0: chip ID is em2870
[68582.627112] em28xx #0: i2c eeprom 00: 1a eb 67 95 80 1b 40 a3 c0 13 6b 10 
6a 22 00 00
[68582.627134] em28xx #0: i2c eeprom 10: 00 00 04 57 00 0d 00 00 00 00 00 00 
00 00 00 00
[68582.627153] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00 00 00 
5b 1c c0 00
[68582.627173] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 
00 00 00 00
[68582.627192] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627211] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627229] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 
55 00 53 00
[68582.627249] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 
20 00 44 00
[68582.627268] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 
00 00 00 00
[68582.627287] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627306] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627325] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627344] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627362] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627381] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627400] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[68582.627422] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2888a312
[68582.627426] em28xx #0: EEPROM info:
[68582.627430] em28xx #0:   No audio on board.
[68582.627433] em28xx #0:   500mA max power
[68582.627438] em28xx #0:   Table at 0x04, strings=0x226a, 0x0000, 0x0000
[68582.628230] em28xx #0: Identified as KWorld PlusTV 340U (ATSC) (card=72)
[68582.628239] em28xx #0: v4l2 driver version 0.1.2
[68582.633740] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[68582.633783] usbcore: registered new interface driver em28xx
[68582.633789] em28xx driver loaded
[68582.711423] tda18271 3-0060: creating new instance
[68582.713367] TDA18271HD/C2 detected @ 3-0060
[68582.944857] DVB: registering new adapter (em28xx #0)
[68582.944865] DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3304 
VSB/QAM Frontend)...
[68582.945500] Successfully loaded em28xx-dvb
[68582.945504] Em28xx: Initialized (Em28xx dvb Extension) extension
...
[69539.736866] tda18271: performing RF tracking filter calibration
[69542.492537] tda18271: RF tracking filter calibration complete

and this is what I get from mplayer (one of the more verbose players I found)

Selected device: KWorld PlusTV 340U (ATSC)
 Capabilites:  video capture  read/write  streaming
 supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 = 
NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = PAL-M; 
11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 = SECAM-B; 16 = SECAM-G; 
17 = S$
 inputs:
 Current input: 0
 Current format: YUYV
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl enum input failed: Invalid argument
Selected input hasn't got a tuner!
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
...
4l2: select timeout
v4l2: 0 frames successfully processed, 1 frames dropped.
Exiting... (Quit)

So clearly something is amiss.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
