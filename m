Return-path: <linux-media-owner@vger.kernel.org>
Received: from p600.netmaster.dk ([217.157.54.18]:45850 "EHLO
	p600.netmaster.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab2ILPmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:42:49 -0400
Message-ID: <5050AC4A.8070003@netmaster.dk>
Date: Wed, 12 Sep 2012 17:37:46 +0200
From: Thomas Seilund <tps@netmaster.dk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: hdpvr and HD PVR 2 Gaming Edition from Haoppauge
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I just bought the HD PVR 2 Gaming Edition from Hauppauge.

It there any change this device will be supported by the hdpvr kernel 
driver. (Or any other driver for that matter!)

When I insert the device only the usb module reacts. The hdpvr module is 
not loaded.

Then I updated the product id in the hdpvr module and now the hdpvr 
driver is loaded. but I get device init failed

I added this code:

- I patched hdpvr.h and added #define HD_PVR_PRODUCT_ID5      0xe502
- I patched hdpvr-core.c and added { USB_DEVICE(HD_PVR_VENDOR_ID, 
HD_PVR_PRODUCT_ID5) }

Now the driver sees the device but I get this in the dmesg when I attach 
the device:

[  201.311799] usb 2-1.2: new high-speed USB device number 5 using ehci_hcd
[  201.436217] hdpvr 2-1.2:1.0: unexpected answer of status request, len 
-32
[  201.436226] hdpvr 2-1.2:1.0: device init failed
[  201.436308] hdpvr: probe of 2-1.2:1.0 failed with error -12
[  201.436353] usbcore: registered new interface driver hdpvr

I looked closer at the driver code but this is way over my head!

I can make the device work on Windows.

Any help would be greatly appreciated.

Thanks

Thomas S
