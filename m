Return-path: <linux-media-owner@vger.kernel.org>
Received: from server2.tcghosting.com ([168.93.115.130]:36246 "EHLO
	server2.tcghosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbbIAUMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2015 16:12:47 -0400
Received: from h69-130-139-79.prsstn.broadband.dynamic.tds.net ([69.130.139.79]:59051 helo=[192.168.1.100])
	by server2.tcghosting.com with esmtpa (Exim 4.85)
	(envelope-from <ron@tallent.ws>)
	id 1ZWrvC-0002IB-6d
	for linux-media@vger.kernel.org; Tue, 01 Sep 2015 15:12:46 -0500
Message-ID: <1441138364.2642.1.camel@Amy>
Subject: em28xx: new board id [1f4d:1abe]
From: Ronald Tallent <ron@tallent.ws>
To: linux-media@vger.kernel.org
Date: Tue, 01 Sep 2015 15:12:44 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

I've tested my USB easycap device (Geniatech iGrabber) in Ubuntu
14.04.

Make: Geniatech
Model: iGrabber for MAC
Vendor/Product ID: [1f4d:1abe]
Product website: www.geniatech.com/pa/igrabber.asp

Tests Made:
- Audio Capture [worked]
- Video Capture [device not detected]
- DVB [does not have DVB]

Tested by:
ron@tallent.ws


Detailed information on device and system below for reference:

uname -a:
3.13.0-62-generic #102-Ubuntu SMP Tue Aug 11 14:29:36 UTC 2015 x86_64 
x86_64 x86_64 GNU/Linux

dmesg:
[] usb 3-3.3: new high-speed USB device number 8 using xhci_hcd
[] usb 3-3.3: New USB device found, idVendor=1f4d, idProduct=1abe
[] usb 3-3.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[] usb 3-3.3: Product: USB Device
[] usbcore: registered new interface driver snd-usb-audio

lsusb:
Bus 003 Device 008: ID 1f4d:1abe G-Tek Electronics Group 

Hardware: 
Opened the case and found the following text printed on the board:
   HandyCap
   v1.51
   2007-4-24

Three chips on board are:
1: empia
   EM2860
   P8367-010
   201036-01AG

2: Trident
   SAA7113H
   C2P409.00 02
   A5G11152

3: eMPIA
   Technology
   EMP202
   UT11958
   1027


