Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:60072 "EHLO
	v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbcAEKYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 05:24:32 -0500
Received: from [192.168.0.3] (tobbe.lan [192.168.0.3])
	by gammdatan.lan (8.15.2/8.14.7) with ESMTP id u05AOTCM005177
	for <linux-media@vger.kernel.org>; Tue, 5 Jan 2016 11:24:29 +0100
To: linux-media@vger.kernel.org
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Subject: TT USB CT2-4650 CI with new product id
Message-ID: <568B99E4.4080204@mbox200.swipnet.se>
Date: Tue, 5 Jan 2016 11:24:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

i just bought a new CT2-4650 dvb usb device for use with dvb-t2.
i picked this since it was supposed to be already working with the built 
in drivers in the kernel, but that is not the case.

as far as i can tell it is the module dvb-usb-dvbsky that is supposed to 
be loaded for this device.

after checking the source and the output of lsusb the device i have 
appears to have a new product id that the drivers dont yet support :(

top few lines of output from lsusb -v:
----
Bus 006 Device 003: ID 0b48:3015 TechnoTrend AG
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0b48 TechnoTrend AG
   idProduct          0x3015
   bcdDevice            0.00
   iManufacturer           1 CityCom GmbH
   iProduct                2 TechnoTrend USB2.0
----

the only id number i can find in the source for CT2_4650_CI is 0x3012 
and not 0x3015

any idea what to do?
