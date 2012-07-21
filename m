Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43219 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2GUPcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 11:32:21 -0400
Received: by wgbdr13 with SMTP id dr13so4533828wgb.1
        for <linux-media@vger.kernel.org>; Sat, 21 Jul 2012 08:32:19 -0700 (PDT)
Message-ID: <500ACB80.9080500@gmail.com>
Date: Sat, 21 Jul 2012 17:32:16 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Firmware in da wonderland
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This one speak for itself;
…
usb 1-1: new high-speed USB device number 8 using ehci_hcd
usb 1-1: New USB device found, idVendor=0ccd, idProduct=0097
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: USB2.0 DVB-T TV Stick
usb 1-1: Manufacturer: NEWMI
usb 1-1: SerialNumber: 010101010600001
dvb-usb: found a 'TerraTec Cinergy T Stick RC' in cold state, will try
to load a firmware
dvb-usb: did not find the firmware file. (dvb-usb-af9015.fw) Please see
linux/Documentation/dvb/ for more details on firmware-problems. (-2)
dvb_usb_af9015: probe of 1-1:1.0 failed with error -2
input: NEWMI USB2.0 DVB-T TV Stick as
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1:1.1/input/input18
generic-usb 0003:0CCD:0097.0007: input,hidraw6: USB HID v1.01 Keyboard
[NEWMI USB2.0 DVB-T TV Stick] on usb-0000:00:04.1-1/input1
…
FW path:
/usr/lib/firmware/dvb-usb-af9015.fw
Is it somehow related to Fedora UsrMove!?
Or Fedora itself :)

Ciao Bella,
poma
