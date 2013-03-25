Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:52516 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3CYRH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 13:07:57 -0400
Received: by mail-ee0-f42.google.com with SMTP id b47so3450136eek.29
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 10:07:56 -0700 (PDT)
Date: Mon, 25 Mar 2013 19:08:46 +0200
From: Timo Teras <timo.teras@iki.fi>
To: linux-media@vger.kernel.org
Subject: Terratec Grabby hwrev 2
Message-ID: <20130325190846.3250fe98@vostro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just bought a Terratec Grabby hardware revision 2 in hopes that it
would work on my linux box.

But alas, I got only sound working. It seems that analog video picture
grabbing does not work.

I tried kernels 3.4.34-grsec, 3.7.1 (vanilla), 3.8.2-grsec and
3.9.0-rc4 (vanilla). And all fail the same way - no video data received.

The USB ID is same as on the revision 1 board:
Bus 005 Device 002: ID 0ccd:0096 TerraTec Electronic GmbH

And it is properly detected as Grabby.

It seems that the videobuf2 changes for 3.9.0-rc4 resulted in better
debug logging, and it implies that the application (ffmpeg 1.1.4) is
behaving well: all buffers are allocated, mmapped, queued, streamon
called. But no data is received from the dongle. I also tested mencoder
and it fails in similar manner.

Dmesg (on 3.9.0-rc4) tells after module load the following:
 
[ 1249.600246] em28xx: New device TerraTec Electronic GmbH TerraTec Grabby @ 480 Mbps (0ccd:0096, inte
rface 0, class 0)
[ 1249.600258] em28xx: Video interface 0 found: isoc
[ 1249.600264] em28xx: DVB interface 0 found: isoc
[ 1249.600443] em28xx: chip ID is em2860
[ 1249.715053] em2860 #0: i2c eeprom 00: 1a eb 67 95 cd 0c 96 00 50 00 11 03 9c 20 6a 32
[ 1249.715084] em2860 #0: i2c eeprom 10: 00 00 06 57 0e 02 00 00 00 00 00 00 00 00 00 00
[ 1249.715110] em2860 #0: i2c eeprom 20: 02 00 01 00 f0 10 01 00 00 00 00 00 5b 00 00 00
[ 1249.715136] em2860 #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[ 1249.715161] em2860 #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1249.715186] em2860 #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1249.715211] em2860 #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 54 00 65 00
[ 1249.715235] em2860 #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00 63 00 20 00 45 00
[ 1249.715261] em2860 #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00 69 00
[ 1249.715286] em2860 #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00 48 00 20 03 54 00
[ 1249.715311] em2860 #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
[ 1249.715336] em2860 #0: i2c eeprom b0: 47 00 72 00 61 00 62 00 62 00 79 00 48 00 00 00
[ 1249.715361] em2860 #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1249.715385] em2860 #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1249.715410] em2860 #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1249.715435] em2860 #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1249.715464] em2860 #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xd3498090
[ 1249.715470] em2860 #0: EEPROM info:
[ 1249.715475] em2860 #0:       AC97 audio (5 sample rates)
[ 1249.715480] em2860 #0:       500mA max power
[ 1249.715487] em2860 #0:       Table at 0x06, strings=0x209c, 0x326a, 0x0000
[ 1249.715495] em2860 #0: Identified as Terratec Grabby (card=67)
[ 1250.058076] em2860 #0: Config register raw data: 0x50
[ 1250.076845] em2860 #0: AC97 vendor ID = 0x60f160f1
[ 1250.086814] em2860 #0: AC97 features = 0x60f1
[ 1250.086822] em2860 #0: Unknown AC97 audio processor detected!
[ 1251.116646] em2860 #0: v4l2 driver version 0.1.3
[ 1251.891145] em2860 #0: V4L2 video device registered as video0
[ 1251.891155] em2860 #0: V4L2 VBI device registered as vbi0
[ 1251.891161] em2860 #0: analog set to isoc mode.
[ 1251.891167] em2860 #0: dvb set to isoc mode.
[ 1251.910649] usbcore: registered new interface driver em28xx

Any suggestions how to debug/fix this?

Thanks,
 Timo
