Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:33226 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZKAIwF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Nov 2009 03:52:05 -0500
Message-ID: <4AED4C3B.3020706@email.cz>
Date: Sun, 01 Nov 2009 09:52:11 +0100
From: Martin Rod <martin.rod@email.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: MSI StarCam Racer - No valid video chain found
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I use MSI StarCam Racer  on Debian Linux Lenny 2.6.26-1-686 and video 
works without problem:

usb 4-4: New USB device found, idVendor=0c45, idProduct=62e0
usb 4-4: New USB device strings: Mfr=2, Product=1,SerialNumber=0
usb 4-4: Product: USB 2.0 Camera
usb 4-4: Manufacturer: Sonix Technology Co., Ltd.

I  plan use this camera on OpenWrt, (UBNT Router Station, kernel 
2.6.30.9) and kernel didn't open this device:

Linux video capture interface: v2.00
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
usb 1-1: new high speed USB device using ar71xx-ehci and address 2
usb 1-1: configuration #1 chosen from 1 choice
uvcvideo: Found UVC 1.00 device USB 2.0 Camera (0c45:62e0)
uvcvideo: No valid video chain found.

Do you have any idea?

Thanks and best regards,

Martin







