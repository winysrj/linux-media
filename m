Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:52512 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZKPCBf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 21:01:35 -0500
Received: by ey-out-2122.google.com with SMTP id 9so1786368eyd.19
        for <linux-media@vger.kernel.org>; Sun, 15 Nov 2009 18:01:40 -0800 (PST)
MIME-Version: 1.0
From: Piero Terzulli <pierigno@gmail.com>
Date: Mon, 16 Nov 2009 03:01:20 +0100
Message-ID: <492564760911151801k536539acw5550735ce97e5ca5@mail.gmail.com>
Subject: AverTV TwinStar support
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi all,

I've recently bought an Avermedia Twinstar usb device and I'm trying
to make it work on linux.
Unfortunately, my system doesn't recognize it (i'm running sabayon
linux with 2.6.31 kernel).
Taking a look inside it seems the card  is based on a AF9035B-N2 chip,
maybe incompatible with the AF9015 driver.

Here is my lsusb output, hope it helps to get this device supported.

# lsusb
usb 1-6: new high speed USB device using ehci_hcd and address 5
usb 1-6: New USB device found, idVendor=07ca, idProduct=0825
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6: Product: A825
usb 1-6: Manufacturer: AVerMedia TECHNOLOGIES, Inc.
usb 1-6: SerialNumber: 3018704000300
usb 1-6: configuration #1 chosen from 1 choice


PS: at this this link afatech claims there is support for linux
http://www.ite.com.tw/EN/products_more.aspx?CategoryID=6&ID=15,63


thanks for all the hard work

Pierangelo Terzulli
