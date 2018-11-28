Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:42076 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbeK2Ezg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 23:55:36 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 434pCl41xTz1qxQP
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2018 18:53:07 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 434pCl3xtSz1qrnX
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2018 18:53:07 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id JaIHPA06M_IW for <linux-media@vger.kernel.org>;
        Wed, 28 Nov 2018 18:53:06 +0100 (CET)
Received: from [192.168.178.40] (ppp-93-104-116-152.dynamic.mnet-online.de [93.104.116.152])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2018 18:53:06 +0100 (CET)
Reply-To: uwe.gottschling@bayern-mail.de
To: linux-media@vger.kernel.org
From: Uwe Gottschling <uwe.gottschling@bayern-mail.de>
Subject: TERRATEC GRABSTER AV 350 doesn't work correctly ID 0ccd:0084 TerraTec
 Electronic GmbH
Message-ID: <5ad33351-af39-bd25-0083-f98f1fe30a3d@bayern-mail.de>
Date: Wed, 28 Nov 2018 18:53:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Linux folks,


I tried to get a Terratec Grabster AV 350 working, but unfortunately, it doesn't work correctly.
The software capture stop if i connect a video sourve to composite input.Sound doesn't work.
I checked it with V4L2 Test Bench.


Using UBUNTU 18.04.1. LTS


uwe@Uwe-Desktop-PC:~$ lsusb | grep 0ccd
Bus 001 Device 002: ID 0ccd:0084 TerraTec Electronic GmbH


uwe@Uwe-Desktop-PC:~$ dmesg | grep em28xx
[   32.591964] em28xx 1-2:1.0: New device  Grabster AV 350 @ 480 Mbps (0ccd:0084, interface 0, class 0)
[   32.591969] em28xx 1-2:1.0: Video interface 0 found: isoc
[   32.592157] em28xx 1-2:1.0: chip ID is em2860
[   32.830192] em28xx 1-2:1.0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x618085a2
[   32.830194] em28xx 1-2:1.0: EEPROM info:
[   32.830195] em28xx 1-2:1.0: 	AC97 audio (5 sample rates)
[   32.830196] em28xx 1-2:1.0: 	500mA max power
[   32.830198] em28xx 1-2:1.0: 	Table at offset 0x04, strings=0x226a, 0x0000, 0x0000
[   32.830200] em28xx 1-2:1.0: Identified as Terratec AV350 (card=68)
[   32.830201] em28xx 1-2:1.0: analog set to isoc mode.
[   32.830301] em28xx 1-2:1.1: audio device (0ccd:0084): interface 1, class 1
[   32.830313] em28xx 1-2:1.2: audio device (0ccd:0084): interface 2, class 1
[   32.830333] usbcore: registered new interface driver em28xx
[   33.096988] em28xx 1-2:1.0: Registering V4L2 extension
[   36.241433] em28xx 1-2:1.0: Config register raw data: 0x50
[   36.277286] em28xx 1-2:1.0: AC97 vendor ID = 0x83847650
[   36.293792] em28xx 1-2:1.0: AC97 features = 0x6a90
[   36.293793] em28xx 1-2:1.0: Empia 202 AC97 audio processor detected
[   42.692268] em28xx 1-2:1.0: V4L2 video device registered as video0
[   42.692271] em28xx 1-2:1.0: V4L2 VBI device registered as vbi0
[   42.692274] em28xx 1-2:1.0: V4L2 extension successfully initialized
[   42.692275] em28xx: Registered (Em28xx v4l2 Extension) extension


uwe@Uwe-Desktop-PC:~$ mplayer tv:// -tv driver=v4l2:norm=pal:device=/dev/video0
MPlayer 1.3.0 (Debian), built with gcc-7 (C) 2000-2016 MPlayer Team
do_connect: could not connect to socket
connect: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
  name: Video 4 Linux 2 input
  author: Martin Olschewski<olschewski@zpr.uni-koeln.de>
  comment: first try, more to come ;-)
Selected device: Terratec AV350
  Capabilities:  video capture  VBI capture device  audio  read/write  streaming
  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 = SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 = SECAM-Lc;
  inputs: 0 = Composite; 1 = S-Video;
  Current input: 0
  Current format: YUYV
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
Selected input hasn't got a tuner!
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
Movie-Aspect is undefined - no prescaling applied.
VO: [vdpau] 640x480 => 640x480 Packed YUY2
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
Starting playback...
V:   0.0   6/  6 ??% ??% ??,?% 0 0
v4l2: select timeout
V:   0.0   8/  8 ??% ??% ??,?% 0 0
v4l2: select timeout
V:   0.0  10/ 10 ??% ??% ??,?% 0 0
v4l2: select timeout
V:   0.0  12/ 12 ??% ??% ??,?% 0 0
v4l2: select timeout
V:   0.0  14/ 14 ??% ??% ??,?% 0 0
v4l2: select timeout


MPlayer interrupted by signal 2 in module: video_read_frame
V:   0.0  15/ 15 ??% ??% ??,?% 0 0
v4l2: select timeout
v4l2: 0 frames successfully processed, 1 frames dropped.

Exiting... (Quit)

Do you have an idea, what the issue.

Kind regards,

Uwe
