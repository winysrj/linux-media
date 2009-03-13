Return-path: <linux-media-owner@vger.kernel.org>
Received: from rolfschumacher.eu ([195.8.233.65]:37494 "EHLO august.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbZCMArR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 20:47:17 -0400
Received: from [192.168.1.2] (HSI-KBW-078-043-156-228.hsi4.kabel-badenwuerttemberg.de [78.43.156.228])
	(Authenticated sender: rolf)
	by august.de (Postfix) with ESMTPA id A18BF1FE22
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 01:47:13 +0100 (CET)
Message-ID: <49B9AD11.9060601@august.de>
Date: Fri, 13 Mar 2009 01:47:13 +0100
From: Rolf Schumacher <mailinglist@august.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: getting started
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

make in v4l-dvb worked without error, produced a lot of .ko files in v4l.
sudo make install worked without errors, too.

reconnecting the TechnoTrend CT 3650 CI, with dmesg I got

---
usb 4-2: USB disconnect, address 3
usb 4-2: new high speed USB device using ehci_hcd and address 6
usb 4-2: configuration #1 chosen from 1 choice
usb 4-2: New USB device found, idVendor=0b48, idProduct=300d
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 4-2: Product: TT-USB2.0
usb 4-2: Manufacturer: TechnoTrend
usb 4-2: SerialNumber: LHKAMG
---

and thought, dvb_usb_ttusb2 would be the driver to load.

However, neither /dev/dvb0 nor /dev/video0 appeared following "sudo
modprobe dvb_usb_ttusb2".
Restart of linux did not help and did not reload dvb_usb_ttusb2.

I know it worked once but forgot, how.
And it seems that it works with some others:

http://www.linuxtv.org/pipermail/linux-dvb/2008-August/027804.html

How to determine what driver I need?
Do I need firmware?

Rolf
