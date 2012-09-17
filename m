Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp24.services.sfr.fr ([93.17.128.81]:53760 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2IQRjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 13:39:48 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2418.sfr.fr (SMTP Server) with ESMTP id DC6ED7000C43
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 19:29:04 +0200 (CEST)
Received: from [192.168.1.11] (210.134.137.88.rev.sfr.net [88.137.134.210])
	by msfrf2418.sfr.fr (SMTP Server) with ESMTP id A90B6700015D
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 19:29:04 +0200 (CEST)
Message-ID: <50575DDC.8020805@free.fr>
Date: Mon, 17 Sep 2012 19:29:00 +0200
From: Damien Bally <biribi@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cinergy T Stick Dual RC (rev. 2)
Content-Type: multipart/mixed;
 boundary="------------070204040408020104020702"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070204040408020104020702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello

I bought this card because it is supported since kernel 2.6.37 according 
to this page :

http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_Dual_RC

As it it was not recognized by OpenSuse 11.4 (the kernel just sees a 
keyboard) I googled a while and found that rev.2 was not (and noticed 
the little sticker on my device confirming it).

According to this page : 
http://ein-eike.de/2012/08/07/terratec-cinergy-t-stick-dual-rc-revision-2 the 
device contains it9133 and it9137 chips which are supported since 3.4 
kernels. So I patched and compiled successfully the last linux-media 
sources and intalled the adhoc firmwares.

It seems to work quite well with VDR : I managed to record 
simultaneously 2 streams on different transponders while watching live 
TV, but I haven't yet tested the remote control part.

Damien




--------------070204040408020104020702
Content-Type: text/x-patch;
 name="it913x.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="it913x.c.patch"

--- it913x.c.orig	2012-09-17 19:04:59.819197365 +0200
+++ it913x.c	2012-09-14 00:18:42.371616299 +0200
@@ -773,6 +773,9 @@
 	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006,
 		&it913x_properties, "ITE 9135(9006) Generic",
 			RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC,
+		&it913x_properties, "ITE 9135(9006) Generic",
+			RC_MAP_IT913X_V1) },
 	{}		/* Terminating entry */
 };
 

--------------070204040408020104020702
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-terratec-cinergy-dual.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-terratec-cinergy-dual.txt"

[ 2686.477020] usb 2-1: new high speed USB device using ehci_hcd and address 3
[ 2686.595464] usb 2-1: New USB device found, idVendor=0ccd, idProduct=0099
[ 2686.595467] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2686.595470] usb 2-1: Product: DVB-T TV Stick
[ 2686.595472] usb 2-1: Manufacturer: ITE Technologies, Inc.
[ 2686.598080] it913x: Chip Version=01 Chip Type=9135
[ 2686.598187] input: ITE Technologies, Inc. DVB-T TV Stick as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.1/input/input7
[ 2686.598275] generic-usb 0003:0CCD:0099.0002: input,hidraw0: USB HID v1.01 Keyboard [ITE Technologies, Inc. DVB-T TV Stick] on usb-0000:00:1d.7-1/input1
[ 2686.599660] it913x: Remote HID mode NOT SUPPORTED
[ 2686.600145] it913x: Dual mode=3 Tuner Type=0
[ 2686.704201] it913x: Chip Version=01 Chip Type=9135
[ 2686.706070] usb 2-1: dvb_usbv2: found a 'ITE 9135(9006) Generic' in cold state
[ 2686.707314] usb 2-1: dvb_usbv2: downloading firmware from file 'dvb-usb-it9135-01.fw'
[ 2686.707694] it913x: FRM Starting Firmware Download
[ 2687.408601] it913x: FRM Firmware Download Completed - Resetting Device
[ 2687.440973] it913x: Chip Version=01 Chip Type=9135
[ 2687.441348] it913x: Firmware Version 204869120
[ 2687.509095] usb 2-1: dvb_usbv2: found a 'ITE 9135(9006) Generic' in warm state
[ 2687.509147] usb 2-1: dvb_usbv2: will pass the complete MPEG2 transport stream to the software demuxer
[ 2687.509362] DVB: registering new adapter (ITE 9135(9006) Generic)
[ 2687.513588] it913x-fe: ADF table value	:00
[ 2687.517338] it913x-fe: Crystal Frequency :12000000 Adc Frequency :20250000 ADC X2: 01
[ 2687.557833] it913x-fe: Tuner LNA type :38
[ 2687.610078] DVB: registering adapter 0 frontend 0 (ITE 9135(9006) Generic_1)...
[ 2687.610133] usb 2-1: dvb_usbv2: will pass the complete MPEG2 transport stream to the software demuxer
[ 2687.610331] DVB: registering new adapter (ITE 9135(9006) Generic)
[ 2687.624700] it913x-fe: ADF table value	:00
[ 2687.649447] it913x-fe: Crystal Frequency :12000000 Adc Frequency :20250000 ADC X2: 01
[ 2687.905914] it913x-fe: Tuner LNA type :38
[ 2688.212137] DVB: registering adapter 1 frontend 0 (ITE 9135(9006) Generic_2)...
[ 2688.212208] usb 2-1: dvb_usbv2: 'ITE 9135(9006) Generic' successfully initialized and connected


--------------070204040408020104020702--
