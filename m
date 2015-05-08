Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35756 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbEHKU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 06:20:56 -0400
Received: by widdi4 with SMTP id di4so23996838wid.0
        for <linux-media@vger.kernel.org>; Fri, 08 May 2015 03:20:55 -0700 (PDT)
Message-ID: <554C8E04.5090007@gmail.com>
Date: Fri, 08 May 2015 12:20:52 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>
Subject: dvb_usb_af9015: command failed=1 - stable: 4.0.2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


[    0.000000] Linux version 4.0.2-200.fc21.x86_64 ...

[    0.870875] usb 1-2: new high-speed USB device number 2 using ehci-pci
[    0.990286] usb 1-2: New USB device found, idVendor=15a4, idProduct=9016
[    0.992575] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    0.994859] usb 1-2: Product: DVB-T 2

[    1.001398] usb 1-2: Manufacturer: Afatech
[    1.003555] usb 1-2: SerialNumber: 010101010600001
[    1.009194] Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 10 -> 7
[    1.011694] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb1/1-2/1-2:1.1/0003:15A4:9016.0001/input/input5
[    1.066814] hid-generic 0003:15A4:9016.0001: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2/input1

[   11.997119] usb 1-2: dvb_usb_v2: found a 'Afatech AF9015 reference design' in warm state
[   12.206778] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   12.207412] DVB: registering new adapter (Afatech AF9015 reference design)

[   12.286137] i2c i2c-13: af9013: firmware version 5.1.0.0
[   12.289121] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
[   12.343650] mxl5007t 13-00c0: creating new instance
[   12.346003] mxl5007t_get_chip_id: unknown rev (3f)
[   12.346156] mxl5007t_get_chip_id: MxL5007T detected @ 13-00c0
[   12.350371] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   12.350649] DVB: registering new adapter (Afatech AF9015 reference design)
[   12.553632] i2c i2c-13: af9013: found a 'Afatech AF9013' in warm state
[   12.557256] i2c i2c-13: af9013: firmware version 5.1.0.0
[   12.563779] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
[   12.564554] mxl5007t 13-00c0: attaching existing instance
[   12.567004] usb 1-2: dvb_usb_af9015: command failed=1
[   12.567555] mxl5007t_soft_reset: 521: failed!
[   12.569745] mxl5007t_attach: error -121 on line 907
[   12.571231] usbcore: registered new interface driver dvb_usb_af9015


$ lsdvb

		lsdvb: Simple utility to list PCI/PCIe DVB devices
		Version: 0.0.4
		Copyright (C) Manu Abraham
$ 

