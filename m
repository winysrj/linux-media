Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:57444 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaLaR07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Dec 2014 12:26:59 -0500
Received: by mail-la0-f54.google.com with SMTP id pv20so13659503lab.41
        for <linux-media@vger.kernel.org>; Wed, 31 Dec 2014 09:26:57 -0800 (PST)
MIME-Version: 1.0
From: gichangA <gichanga@gmail.com>
Date: Wed, 31 Dec 2014 20:26:37 +0300
Message-ID: <CA+CwJfz9umE7+kn49tCgQM3v37xZ9JAWvMwVGT6wFCeHYeU4mw@mail.gmail.com>
Subject: Board not discovered
To: =?UTF-8?Q?=E2=80=8BV4L_Mailing_List?= <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear V4L Mailing list,

Plugged in my board and it wasn't identified correctly. Did a dmesg
and got the output as below.

(I've confirmed the board as EM2860 with saa711X, but unloading driver
and reloading and selecting card=19 (rmmod em28xx followed by modprob
em28xx card=19) doesn't seen to be working, and w_scan or dbvscan
fails [or is this board not dvb capable?])

Thanks in advance.....

Board eeprom hash is 0x8f597549
[    6.717993] em28xx #0: Board i2c devicelist hash is 0x4bc40080
[    6.724239] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[    6.732563] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[    6.737977] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[    6.744336] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[    6.749895] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[    6.755220] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[    6.758795] em28xx #0:     card=5 -> MSI VOX USB 2.0
[    6.765777] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[    6.771439] em28xx #0:     card=7 -> Leadtek Winfast USB II
[    6.776843] em28xx #0:     card=8 -> Kworld USB2800
[    6.782477] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/1
00/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 /
Plextor ConvertX PX-AV100U
[    6.797788] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[    6.801433] em28xx #0:     card=11 -> Terratec Hybrid XS
[    6.807030] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[    6.812341] em28xx #0:     card=13 -> Terratec Prodigy XS
[    6.817595] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[    6.826531] em28xx #0:     card=15 -> V-Gear PocketTV
[    6.830786] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[    6.836633] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[    6.842619] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[    6.848711] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[    6.855110] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[    6.860919] em28xx #0:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[    6.868665] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[    6.875533] em28xx #0:     card=23 -> Huaqi DLCW-130
[    6.880482] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[    6.886263] em28xx #0:     card=25 -> Gadmei UTV310
[    6.891025] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0

[    6.910572] em28xx #0: Your board has no unique USB ID and thus
need a hint to be d



Best Wishes,
Moses gichangA
