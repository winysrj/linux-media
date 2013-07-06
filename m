Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38233 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3GFEoT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jul 2013 00:44:19 -0400
Received: by mail-pd0-f173.google.com with SMTP id v14so2491546pde.4
        for <linux-media@vger.kernel.org>; Fri, 05 Jul 2013 21:44:19 -0700 (PDT)
Received: from [192.168.0.11] (203-97-162-140.cable.paradise.net.nz. [203.97.162.140])
        by mx.google.com with ESMTPSA id z19sm11251467paf.12.2013.07.05.21.44.16
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 05 Jul 2013 21:44:18 -0700 (PDT)
Message-ID: <51D7A09E.3030809@gmail.com>
Date: Sat, 06 Jul 2013 16:44:14 +1200
From: p doole <pdoole@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: EM28xx - STLabs USB video capture - almost there but no audio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've been trying to get an STLabs USB video capture device working. I've 
got the video working but am stuck on the audio.  I followed this thread 
from the archives http://en.it-usenet.org/thread/18550/25190/  which 
helped with the video.  As you can see below the audio isn't (or 
possibly is?) detected properly.  Installing the device in Windows it 
works but the provided software is rubbish and there's a lag in the 
audio. While running the device in Linux I can see under the sound 
settings, input, the "Line In USB 2861 Device" input level fluctuates as 
you'd expect when there's a video being played so I figure sound is 
coming from the device.  However I can't get any sound in the resulting 
file using mplayer with various settings tried.  I've also tried tvtime 
with no luck.  Hopefully I'm missing something obvious.

I'm running linux mint 15.  Any suggestions or advice gratefully received.
Oh and 1st post so please let me know if there's anything I should do 
differently/better  :)

desktop ~ $  lsusb
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 003: ID eb1a:5051 eMPIA Technology, Inc.
Bus 002 Device 004: ID 05e3:0723 Genesys Logic, Inc. GL827L SD/MMC/MS 
Flash Card Reader
Bus 002 Device 005: ID 046d:0802 Logitech, Inc. Webcam C200

desktop ~ $ dmesg | grep em2
[    6.202180] em28xx: New device  USB 2861 Device @ 480 Mbps 
(eb1a:5051, interface 0, class 0)
[    6.202184] em28xx: Video interface 0 found: isoc
[    6.204840] em28xx: chip ID is em2860
[    6.343008] em2860 #0: i2c eeprom 00: 1a eb 67 95 1a eb 51 50 50 00 
20 03 6a 20 8a 04
[    6.343016] em2860 #0: i2c eeprom 10: 00 00 24 57 06 02 00 00 00 00 
00 00 00 00 00 00
[    6.343022] em2860 #0: i2c eeprom 20: 02 00 01 00 f0 10 01 00 b8 00 
00 00 5b 00 00 00
[    6.343028] em2860 #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 
00 00 00 00 00 00
[    6.343034] em2860 #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 c4 00 00
[    6.343039] em2860 #0: i2c eeprom 50: 00 a2 00 87 81 00 00 00 00 00 
00 00 00 00 00 00
[    6.343045] em2860 #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
20 03 55 00 53 00
[    6.343051] em2860 #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 
31 00 20 00 44 00
[    6.343056] em2860 #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 
04 03 30 00 65 00
[    6.343062] em2860 #0: i2c eeprom 90: 65 00 65 00 65 00 00 00 00 00 
00 00 00 00 00 00
[    6.343068] em2860 #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[    6.343073] em2860 #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[    6.343079] em2860 #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[    6.343084] em2860 #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[    6.343090] em2860 #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[    6.343096] em2860 #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[    6.343103] em2860 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x11b79572
[    6.343104] em2860 #0: EEPROM info:
[    6.343105] em2860 #0:     No audio on board.
[    6.343106] em2860 #0:     500mA max power
[    6.343107] em2860 #0:     Table at offset 0x00, strings=0x0000, 
0x0000, 0x0000
[    6.343110] em2860 #0: Identified as EM2860/TVP5150 Reference Design 
(card=29)
[    6.543923] tvp5150 7-005c: chip found @ 0xb8 (em2860 #0)
[    6.643904] em2860 #0: Config register raw data: 0x50
[    6.667401] em2860 #0: AC97 vendor ID = 0x83847650
[    6.679765] em2860 #0: AC97 features = 0x6a90
[    6.679768] em2860 #0: Empia 202 AC97 audio processor detected
[    9.298579] em2860 #0: v4l2 driver version 0.2.0
[   11.210059] em2860 #0: V4L2 video device registered as video0
[   11.210063] em2860 #0: V4L2 VBI device registered as vbi0
[   11.210065] em2860 #0: analog set to isoc mode.
[   11.214055] usbcore: registered new interface driver em28xx

Cheers fil.

