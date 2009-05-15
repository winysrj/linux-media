Return-path: <linux-media-owner@vger.kernel.org>
Received: from judo.dreamhost.com ([66.33.216.100]:52608 "EHLO
	judo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZEONve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 09:51:34 -0400
Received: from smarty.dreamhost.com (smarty.dreamhost.com [208.113.175.8])
	by judo.dreamhost.com (Postfix) with ESMTP id A44EE48EE26
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 06:22:44 -0700 (PDT)
Received: from slippy.dreamhost.com (slippy.dreamhost.com [75.119.220.6])
	by smarty.dreamhost.com (Postfix) with ESMTP id 3639CEE265
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 06:21:39 -0700 (PDT)
Date: Fri, 15 May 2009 15:21:39 +0200
From: Bartosz Cisek <bartoszcisek@bartoszcisek.pl>
To: linux-media@vger.kernel.org
Subject: saa7130 unstable video
Message-ID: <20090515132138.GA6452@bartoszcisek.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have cheap Chinese noname card with 8 Philips 7130 chips, without
eeprom. It's dedicated to CCTV. Has no tv tuner, and I don't need sound. 

Card looks exacly like http://www.cn-dvr.net/products/enproducts76.html and AOP-8008A from
http://www.bttv-gallery.de/

I tried modprobe with all posible (1,154) card types, and tested each with "mplayer tv://". 
Some of them worked "a bit" but image was unstable and colors were substituted. It's hard 
to describe in detail so I grabbed a few seconds. Image quality is unacceptable for 
surveillance purpouse

http://bartoszcisek.pl/saa7130-sample1.avi (11MB)
http://bartoszcisek.pl/saa7130-sample2.avi (13MB)

My first thoughts were that there is a lack synchronisation, because image is shifted 
and moving. 

Card producer wrote that it has onboard x264 compression, maybe I use wrong codec for 
mplayer? I tryed x264 but it made only worse, there was no image at all. 

I've never done any linux driver coding. Can you please advise me how to start? maybe 
I don't have to code and it's just a matter of configuration?

Below I submit logs from lspci, dmesg and mplayer. Camera is OK as I checked it 
previously on bt878A card.

Thanks in advance for any hints,

regards

Bartek

tower:~# lspci -vnn -s 02:0f.0
02:0f.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Video Broadcast Decoder [1131:7130] (rev 01)
        Subsystem: Philips Semiconductors Device [1131:0000]
        Flags: bus master, medium devsel, latency 32, IRQ 17
        Memory at e2007000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [40] Power Management version 1
        Kernel modules: saa7134

dmesg:

saa7130[7]: found at 0000:02:0f.0, rev: 1, irq: 17, latency: 32, mmio: 0xe2007000
saa7134: <rant>
saa7134:  Congratulations!  Your TV card vendor saved a few
saa7134:  cents for a eeprom, thus your pci board has no
saa7134:  subsystem ID and I can't identify it automatically
saa7134: </rant>
saa7134: I feel better now.  Ok, here are the good news:
saa7134: You can use the card=<nr> insmod option to specify
saa7134: which board do you have.  The list:
saa7134:   card=0 -> UNKNOWN/GENERIC
saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 1131:2001

[here was list of cards]

saa7134:   card=154 -> Avermedia AVerTV GO 007 FM Plus          1461:f31d
saa7130[7]: subsystem: 1131:0000, board: UNKNOWN/GENERIC [card=0,autodetected]
saa7130[7]: board init: gpio is 18e00
IRQ 17/saa7130[7]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[7]: Huh, no eeprom present (err=-5)?
saa7130[7]: registered device video7 [v4l2]
saa7130[7]: registered device vbi7

Mplayer:

MPlayer dev-SVN-r26940
CPU: AMD Athlon(tm) XP 3200+ (Family: 6, Model: 10, Stepping: 0)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 0
Compiled with runtime CPU detection.
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Beholder BeholdTV 403
 Tuner cap: STEREO LANG1 LANG2
 Tuner rxs: MONO
 Capabilites:  video capture  video overlay  VBI capture device  tuner  read/write  streaming
 supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 = PAL; 5 = PAL-BG; 6 = PAL-H; 7 = PAL-I; 8 = PAL-DK; 9 = PAL-M; 10 = PAL-N; 11 = PAL-Nc; 12 = PAL-60; 13 = SECAM; 14 = SECAM-B; 15 = SECAM-G; 16 = SECAM-H; 17 = SECAM-DK; 18 = SECAM-L; 19 = SECAM-Lc;
 inputs: 0 = S-Video; 1 = Composite1; 2 = Television;
 Current input: 0
 Current format: BGR24
v4l2: current audio mode is : MONO
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
[VO_TDFXFB] This driver only supports the 3Dfx Banshee, Voodoo3 and Voodoo 5.
s3fb: 4 bpp output is not supported
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 640 x 480 (preferred colorspace: Planar YV12)
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO: [xv] 640x480 => 640x480 Planar YV12
[VO_XV] Shared memory not supported
Reverting to normal Xv.
[VO_XV] Shared memory not supported
Reverting to normal Xv.
Selected video codec: [rawyv12] vfm: raw (RAW YV12)
==========================================================================
Audio: no sound
Starting playback...
v4l2: 106 frames successfully processed, -105 frames dropped.

Exiting... (Quit)

-- 
Bartosz Cisek
< bartoszcisek [ at ] bartoszcisek.pl >
