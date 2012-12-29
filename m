Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm21-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.137]:20332 "EHLO
	nm21-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab2L2PZT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 10:25:19 -0500
Message-ID: <1356794363.41004.YahooMailNeo@web161606.mail.bf1.yahoo.com>
Date: Sat, 29 Dec 2012 07:19:23 -0800 (PST)
From: georgi gonev <gonev2001@yahoo.com>
Reply-To: georgi gonev <gonev2001@yahoo.com>
Subject: Gigabyte U8000-RH dvb-t tunner problem
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi guy's,

I have some problem with my new Gigabyte U8000-RH hybrid DVB-T and Analogue USB device.

My idea is to use this dvb-t tuner together with my Raspberry Pi, XBMC and tvheadend.

But now I try to use tuner in my notebook with Fedora 17 and kernel 3.6.10-2.fc17.x86_64
The device I thing is running correctly using the following instruction:

1)http://www.linuxtv.org/wiki/index.php/Gigabyte_U8000-RH
2)http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028

I had firmware for DiBcom 7000PC DVB-T demodulator (dvb-usb-dib0700-1.20.fw) and only build the firmware for the XCeive xc2028/xc3028 tuner (xc3028-v27.fw):

# In order to use, you need to:
#       1) Download the windows driver with something like:
#               wget http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
#               ( find here: http://cdn.pinnaclesys.com/SupportFiles/PCTV%20Drivers/ReadmePCTV.htm )
#       2) Extract the file hcw85bda.sys from the zip into the current dir:
#               unzip -j HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys
#       3) Download the extract script
#               wget http://linuxtv.org/hg/v4l-dvb/raw-file/3919b17dc88e/linux/Documentation/video4linux/extract_xc3028.pl
#       3) run the script:
#               perl extract_xc3028.pl
#       4) copy the generated file:
#               sudo cp xc3028-v27.fw /lib/firmware

After that plug the device and result is this:

# lsusb
Bus 002 Device 004: ID 1044:7002 Chu Yuen Enterprise Co., Ltd Gigabyte U8000 DVB-T tuner

# dmesg
[19378.803038] usb 2-2: new high-speed USB device number 5 using ehci_hcd
[19378.917940] usb 2-2: New USB device found, idVendor=1044, idProduct=7002
[19378.917947] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[19378.917952] usb 2-2: Product: U8000
[19378.917957] usb 2-2: Manufacturer: GIGABYTE
[19378.917961] usb 2-2: SerialNumber: 000GA1000100065
[19378.918688] dvb-usb: found a 'Gigabyte U8000-RH' in cold state, will try to load a firmware
[19408.947281] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[19409.149523] dib0700: firmware started successfully.
[19409.650179] dvb-usb: found a 'Gigabyte U8000-RH' in warm state.
[19409.650284] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[19409.650421] DVB: registering new adapter (Gigabyte U8000-RH)
[19409.870156] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[19409.870328] xc2028 7-0061: creating new instance
[19409.870333] xc2028 7-0061: type set to XCeive xc2028/xc3028 tuner
[19409.870343] dvb-usb: Gigabyte U8000-RH successfully initialized and connected.
[19409.871587] xc2028 7-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7

# ls -l /dev/dvb/adapter0/
total 0
crw-rw----+ 1 root video 212, 0 Dec 29 16:25 demux0
crw-rw----+ 1 root video 212, 1 Dec 29 16:25 dvr0
crw-rw----+ 1 root video 212, 3 Dec 29 16:25 frontend0
crw-rw----+ 1 root video 212, 2 Dec 29 16:25 net0


OK...and now when I try to watch tv with kaffeine for example, I see this error in the dmesg:

[19865.904923] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.904923]
[19865.904931] xc2028 7-0061: Loading firmware for type=D2620 DTV8 (208), id 0000000000000000.
[19865.909805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.909805]
[19865.914677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.914677]
[19865.918803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.918803]
[19865.926801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.926801]
[19865.934799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.934799]
[19865.943177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.943177]
[19865.947298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.947298]
[19865.951428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.951428]
[19865.959425] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.959425]
[19865.963550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.963550]
[19865.969551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.969551]
[19865.973675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.973675]
[19865.981675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.981675]
[19865.985800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.985800]
[19865.989925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.989925]
[19865.996802] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19865.996802]
[19866.000923] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19866.000923]
[19866.005054] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19866.005054]
[19866.009174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19866.009174]
[19866.014051] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
[19866.014051]
[19866.014057] xc2028 7-0061: Loading SCODE for type=DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0000000000000000.

I find some solutions about this error's:

echo option dvb-usb disable_rc_polling=1 >> /etc/modprobe.d/options.conf

but I dont know, the device not work correctly again. When I run to watch tv again from kaffeine, first 5 or 10 seconds the pictures is excellent, and after that the channels is with bad quality. When i search channel, some time get all channel, some time part of them.

