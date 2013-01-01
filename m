Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:54286 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3AAXOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 18:14:51 -0500
Received: by mail-la0-f44.google.com with SMTP id fr10so5330817lab.17
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 15:14:49 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 2 Jan 2013 07:14:49 +0800
Message-ID: <CACJzANdJXV72pqHzT1Y7R6KbKGMZZqULrWRvTnQQD7vi6j3GYQ@mail.gmail.com>
Subject: Problem with 187f:0202(Siano Mobile Silicon Nice) not automatically
 load smsdvb
From: =?UTF-8?B?5p6X5Y2a5LuB?= <pika1021@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I tried to make a DVB-T reciever which uses ID 187f:0202(Siano Mobile
Silicon Nice) work on my linux machine(Ubuntu 12.10 x86 32bit 3.5.x
kernel) and eventually found that only manually load 'smsdvb' module
make the dvb device create (it won't create if just plug-in the
hardware)

Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.458196] usb 2-1.2: new
high-speed USB device number 21 using ehci_hcd
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544329] usb 2-1.2: New USB
device found, idVendor=187f, idProduct=0202
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544335] usb 2-1.2: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544340] usb 2-1.2: Product:
MDTV Receiver
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544343] usb 2-1.2:
Manufacturer: MDTV Receiver
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5820.177202]
smscore_set_device_mode: firmware download success:
dvb_nova_12mhz_b0.inp
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5820.180521] usbcore: registered
new interface driver smsusb

** % sudo modprobe smsdvb **

Dec 31 10:03:12 SSD-Vubuntu kernel: [ 5923.043199] DVB: registering
new adapter (Siano Nice Digital Receiver)
Dec 31 10:03:12 SSD-Vubuntu kernel: [ 5923.043502] usb 2-1.2: DVB:
registering adapter 0 frontend 0 (Siano Mobile Digital MDTV
Receiver)...

Here is another card having the similar issue
http://www.linuxtv.org/wiki/index.php/Smart_Plus

I tried to contact smsusb module's author (uris@siano-ms.com) but the
address is broken now...

Sincerely,
Henry Lin <pika1021@gmail.com>
