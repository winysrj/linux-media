Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:60242 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab0DAOEu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 10:04:50 -0400
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 105854C8166
	for <linux-media@vger.kernel.org>; Thu,  1 Apr 2010 16:04:44 +0200 (CEST)
Received: from [192.168.0.10] (unknown [78.243.40.12])
	by smtp4-g21.free.fr (Postfix) with ESMTP id E73F74C812D
	for <linux-media@vger.kernel.org>; Thu,  1 Apr 2010 16:04:41 +0200 (CEST)
Message-ID: <4BB4A7F9.7010301@free.fr>
Date: Thu, 01 Apr 2010 16:04:41 +0200
From: moebius <moebius1@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: terratec grabby sound problem
References: <4B7BB7CF.7000208@free.fr>
In-Reply-To: <4B7BB7CF.7000208@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bonjour,

No progress at all
I've tried to download last version from mercurial repository 
(compilation problem with firedtv module -> I've disabled it) succeded 
and installed it but with no change

dmesg :

[   42.660031] usb 1-3: new high speed USB device using ehci_hcd and 
address 4
[   42.800792] usb 1-3: configuration #1 chosen from 1 choice
[   42.801021] usb 1-3: USB disconnect, address 4
[   42.879676] Linux video capture interface: v2.00
[   42.906374] usbcore: registered new interface driver em28xx
[   42.906378] em28xx driver loaded
[   42.928142] usbcore: registered new interface driver snd-usb-audio
[   43.080026] usb 1-3: new high speed USB device using ehci_hcd and 
address 5
[   43.221001] usb 1-3: configuration #1 chosen from 1 choice
[   43.221464] em28xx: New device TerraTec Electronic GmbH TerraTec 
Grabby @ 480 Mbps (0ccd:0096, interface 0, class 0)
[   43.221529] em28xx #0: chip ID is em2860
[   43.349095] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 96 00 50 00 
11 03 9e 22 6a 34
[   43.349105] em28xx #0: i2c eeprom 10: 00 00 06 57 06 02 00 00 00 00 
00 00 00 00 00 00
[   43.349114] em28xx #0: i2c eeprom 20: 02 00 01 00 f0 10 01 00 00 00 
00 00 5b 00 00 00
[   43.349122] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 
00 00 00 00 00 00
[   43.349131] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   43.349139] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   43.349147] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
34 03 54 00 65 00
[   43.349155] em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00 
63 00 20 00 45 00
[   43.349163] em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00 
6f 00 6e 00 69 00
[   43.349172] em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00 
48 00 00 00 22 03
[   43.349180] em28xx #0: i2c eeprom a0: 54 00 65 00 72 00 72 00 61 00 
54 00 65 00 63 00
[   43.349188] em28xx #0: i2c eeprom b0: 20 00 47 00 72 00 61 00 62 00 
62 00 79 00 00 00
[   43.349196] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   43.349204] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   43.349212] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   43.349221] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   43.349230] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x77daab95
[   43.349232] em28xx #0: EEPROM info:
[   43.349234] em28xx #0:	AC97 audio (5 sample rates)
[   43.349235] em28xx #0:	500mA max power
[   43.349237] em28xx #0:	Table at 0x06, strings=0x229e, 0x346a, 0x0000
[   43.350216] em28xx #0: Identified as Terratec Grabby (card=67)
[   43.716653] saa7115 4-0025: saa7113 found (1f7113d0e100000) @ 0x4a 
(em28xx #0)
[   44.425751] em28xx #0: Config register raw data: 0x50
[   44.449762] em28xx #0: AC97 vendor ID = 0x83847652
[   44.460767] em28xx #0: AC97 features = 0x6a90
[   44.460770] em28xx #0: Sigmatel audio processor detected(stac 9752)
[   44.920523] em28xx #0: v4l2 driver version 0.1.2
[   45.848116] em28xx #0: V4L2 video device registered as video0
[   45.848120] em28xx #0: V4L2 VBI device registered as vbi0
[   45.848165] em28xx audio device (0ccd:0096): interface 1, class 1
[   85.500023] Clocksource tsc unstable (delta = -187803515 ns)

mplayer code and result :

  sudo nice --10 mplayer tv:// -tv 
norm=pal:device=/dev/video0:mjpeg:decimation=1:immediatemode=0:amode=1:forceaudio:alsa:buffersize=32 
-vf pp=l5
MPlayer SVN-r29237-4.4.1 (C) 2000-2009 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote 
control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
  name: Video 4 Linux 2 input
  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
  comment: first try, more to come ;-)
Selected device: Terratec Grabby
  Capabilites:  video capture  VBI capture device  audio  read/write 
streaming
  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 
= NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = 
PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 = SECAM-B; 
16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 = SECAM-Lc;
  inputs: 0 = Composite1; 1 = S-Video;
  Current input: 0
  Current format: YUYV
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
   MJP: width 704 height 576
Selected input hasn't got a tuner!
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
[VO_TDFXFB] Can't open /dev/fb0: No such file or directory.
[VO_3DFX] Unable to open /dev/3dfx.
Opening video filter: [pp=l5]
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 704 x 576 (preferred colorspace: Packed YUY2)
[PP] Using external postprocessing filter, max q = 6.
Could not find matching colorspace - retrying with -vf scale...
Opening video filter: [scale]
VDec: using Packed YUY2 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
SwScaler: reducing / aligning filtersize 1 -> 4
     Last message repeated 1 times
SwScaler: reducing / aligning filtersize 1 -> 1
SwScaler: reducing / aligning filtersize 9 -> 8
[swscaler @ 0x93b9cf0]BICUBIC scaler, from yuyv422 to yuv420p using MMX2
[swscaler @ 0x93b9cf0]using 4-tap MMX scaler for horizontal luminance 
scaling
[swscaler @ 0x93b9cf0]using 4-tap MMX scaler for horizontal chrominance 
scaling
[swscaler @ 0x93b9cf0]using 1-tap MMX "scaler" for vertical scaling 
(YV12 like)
[swscaler @ 0x93b9cf0]704x576 -> 704x576
VO: [xv] 704x576 => 704x576 Planar YV12
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
==========================================================================
Opening audio decoder: [pcm] Uncompressed PCM audio decoder
AUDIO: 44100 Hz, 2 ch, s16le, 1411.2 kbit/100.00% (ratio: 176400->176400)
Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
==========================================================================
[pulse] working around probably broken pause functionality,
         see http://www.pulseaudio.org/ticket/440
AO: [pulse] 44100Hz 2ch s16le (2 bytes per sample)
Starting playback...
v4l2: 2134 frames successfully processed, -1 frames dropped.0.1% 0 0

Exiting... (Quit)

  well, don't know how to make it work well

cordialement,


Le 17/02/2010 10:33, moebius a écrit :
> Bonjour,
>
> I've bought a terratec grabby device but I've experimented some audio
> problems with it
> I run an ubuntu karmic (9.10) distri and use mplayer/mencoder to see and
> capture vhs pal stuff. (.....)
