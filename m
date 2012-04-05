Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46964 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751905Ab2DEFza (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 01:55:30 -0400
Content-Type: text/plain; charset="utf-8"
Date: Thu, 05 Apr 2012 07:55:26 +0200
From: wiekaltheut@gmx.de
Message-ID: <20120405055526.10110@gmx.net>
MIME-Version: 1.0
Subject: Terratec Cinergy HTC Stick, drxk: SCU_RESULT_INVPAR
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to get my Terratec Cinergy HTC Stick to cooperate with Linux 3.3. It is going to be detected correctly, the requested firmware file dvb-usb-terratec-h5-drxk.fw is the one avaiable on [1].
At the moment, I only can test DVB-C. Which seems to work, from time to time. I can tune to some
channels, the most channels are not working. When hitting a non working one, I get something like "drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params", as could be seen in the dmesg output. The device seems to be ok, at least with the Windows driver.

How can I debug this?


Thanks.
Steve.

[1] http://www.linuxtv.org/downloads/firmware/#7

== dmesg output ==
[   82.768242] usb 1-6: new high-speed USB device number 3 using ehci_hcd
[   82.902484] usb 1-6: New USB device found, idVendor=0ccd, idProduct=00b2
[   82.902502] usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[   82.902515] usb 1-6: Product: Cinergy_HTC_Stick
[   82.902525] usb 1-6: Manufacturer: TERRATEC
[   82.902535] usb 1-6: SerialNumber: 02?TERRATE
[   83.159089] IR NEC protocol handler initialized
[   83.165677] IR RC5(x) protocol handler initialized
[   83.181250] IR RC6 protocol handler initialized
[   83.199170] em28xx: New device TERRATEC Cinergy_HTC_Stick @ 480 Mbps (0ccd:00b2, interface 0, class 0)
[   83.199182] em28xx: Audio Vendor Class interface 0 found
[   83.199188] em28xx: Video interface 0 found
[   83.199193] em28xx: DVB interface 0 found
[   83.199736] em28xx #0: chip ID is em2884
[   83.201072] IR JVC protocol handler initialized
[   83.206244] IR Sony protocol handler initialized
[   83.214044] IR SANYO protocol handler initialized
[   83.219177] IR MCE Keyboard/mouse protocol handler initialized
[   83.225775] lirc_dev: IR Remote Control driver registered, major 251 
[   83.228931] IR LIRC bridge handler initialized
[   83.257485] em28xx #0: Identified as Terratec Cinergy HTC Stick (card=82)
[   83.267576] i2c-core: driver [tuner] using legacy suspend method
[   83.267586] i2c-core: driver [tuner] using legacy resume method
[   83.308536] Chip ID is not zero. It is not a TEA5767
[   83.308568] tuner 14-0060: Tuner -1 found with type(s) Radio TV.
[   83.308591] tuner 14-0060: tuner type not set
[   83.308767] em28xx #0: Config register raw data: 0xbd
[   83.308777] em28xx #0: I2S Audio (5 sample rates)
[   83.308786] em28xx #0: No AC97 audio processor
[   83.336125] em28xx #0: v4l2 driver version 0.1.3
[   83.336150] tuner 14-0060: tuner type not set
[   83.366997] em28xx #0: V4L2 video device registered as video1
[   83.367148] usbcore: registered new interface driver em28xx
[   83.387234] em28xx-audio.c: probing for em28xx Audio Vendor Class
[   83.387244] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[   83.387251] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
[   83.389287] Em28xx: Initialized (Em28xx Audio Extension) extension
[   84.203927] drxk: status = 0x639260d9
[   84.203948] drxk: detected a drx-3926k, spin A3, xtal 20.250 MHz
[   85.526425] DRXK driver version 0.9.4300
[   85.540783] drxk: frontend initialized.
[   87.293767] DVB: registering new adapter (em28xx #0)
[   87.293788] DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
[   87.298706] em28xx #0: Successfully loaded em28xx-dvb
[   87.298737] Em28xx: Initialized (Em28xx dvb Extension) extension
[  223.421599] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  223.421622] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[  237.329309] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  237.329331] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[  299.973528] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  299.973550] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[  428.985300] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  428.985316] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[  485.533707] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  485.533730] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[  496.741663] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  496.741686] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[  639.765595] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  639.765622] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........

-- 
NEU: FreePhone 3-fach-Flat mit kostenlosem Smartphone!                                  
Jetzt informieren: http://mobile.1und1.de/?ac=OM.PW.PW003K20328T7073a
