Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44851 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0ENPuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 11:50:13 -0400
Received: by fxm6 with SMTP id 6so1641017fxm.19
        for <linux-media@vger.kernel.org>; Fri, 14 May 2010 08:50:12 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 May 2010 17:50:12 +0200
Message-ID: <AANLkTil-SJThXIvMMR2IoRv4_SQfgTHCJBC6PHbnk7EV@mail.gmail.com>
Subject: dvb-s device help
From: meri zak <meri.zakos@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

can someone help me for this hardware (elgato eyetv sat); a dvb-s usb device

http://www.elgato.com/elgato/int/mainmenu/products/tuner/EyeTV-Sat/product3.fr.html


I think it's terratec S7 reconditionned but with the mantis driver i
can't make it recognize by my linux system. I used the last kernel
stable release and the last v4l.

here the log when i connect the device.

you can see the device is not referenced by the lsusb command. and the
ID device is 0fd9:002a.

thank you for your help and excuse my english.

Zak

 usb 2-4: USB disconnect, address 2

[11614.465030] usb 2-4: new high speed USB device using ehci_hcd and address 6
[11614.918072] usb 2-4: New USB device found, idVendor=0fd9, idProduct=002a
[11614.918430] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[11614.918777] usb 2-4: Product: EyeTV Sat
[11614.919117] usb 2-4: Manufacturer: Elgato Systems
[11614.919469] usb 2-4: SerialNumber: 0008CA1E6FCB

here the lsusb out command
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 006: ID 0fd9:002a
Bus 002 Device 003: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Bus 002 Device 004: ID 192f:0416 Avago Technologies, Pte.
Bus 002 Device 005: ID 04f2:0404 Chicony Electronics Co., Ltd
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 008 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
