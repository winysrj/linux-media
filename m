Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61340 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbZLFDVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 22:21:49 -0500
Received: by yxe17 with SMTP id 17so3097806yxe.33
        for <linux-media@vger.kernel.org>; Sat, 05 Dec 2009 19:21:56 -0800 (PST)
Message-ID: <4B1B2353.9030604@voltagex.org>
Date: Sun, 06 Dec 2009 14:21:55 +1100
From: Adam Baxter <voltagex@voltagex.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AF9035 USB2 DVB-T device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,
I see some work has been done on the AF9015 driver, but I've found yet 
another variant.
It was branded "WandTV".

|[ 3531.496078] usb 1-4: new high speed USB device using ehci_hcd and 
address 15
[ 3531.634713] usb 1-4: New USB device found, idVendor=15a4, idProduct=1001
[ 3531.634777] usb 1-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 3531.634832] usb 1-4: Product: AF9035A USB Device
[ 3531.634875] usb 1-4: Manufacturer: Afa Technologies Inc.
[ 3531.634922] usb 1-4: SerialNumber: AF0102020700001
[ 3531.635169] usb 1-4: configuration #1 chosen from 1 choice
[ 3531.644931] input: Afa Technologies Inc. AF9035A USB Device as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4:1.1/input/input9
[ 3531.645175] generic-usb 0003:15A4:1001.0005: input,hidraw0: USB HID 
v1.01 Keyboard [Afa Technologies Inc. AF9035A USB Device] on 
usb-0000:00:1d.7-4/input1|

Any ideas where to start? The main variation seems to be the firmware 
(on Windows), but I'm not experienced enough to fire up usbsnoop.

Thanks,
Adam Baxter

