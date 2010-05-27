Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54810 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab0E0Ikf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 04:40:35 -0400
Received: by wyb29 with SMTP id 29so3940210wyb.19
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 01:40:34 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 27 May 2010 10:40:33 +0200
Message-ID: <AANLkTimMo8dZGLQrJ4ItNchvMR1j7ONZGpeqk9YHEHFx@mail.gmail.com>
Subject: Disable IR receiver on DVB-T stick
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, I buy the "KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)" DVB-T
tuner, it works well on Debian Squeeze (2.6.32 kernel). This is the
dmesg message on plug:

$ dmesg
...
[  224.756123] usb 1-3: new high speed USB device using ehci_hcd and address 5
[  224.892142] usb 1-3: New USB device found, idVendor=1b80, idProduct=e399
[  224.892159] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  224.892171] usb 1-3: Product: DVB-T 2
[  224.892180] usb 1-3: Manufacturer: Afatech
[  224.892792] usb 1-3: configuration #1 chosen from 1 choice
[  225.152632] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T
399U)' in cold state, will try to load a firmware
[  225.152654] usb 1-3: firmware: requesting dvb-usb-af9015.fw
[  225.228940] usbcore: registered new interface driver hiddev
[  225.256581] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[  225.325149] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T
399U)' in warm state.
[  225.326874] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  225.327404] DVB: registering new adapter (KWorld PlusTV Dual DVB-T
Stick (DVB-T 399U))
[  227.680270] af9015: recv bulk message failed:-110
[  227.783746] af9013: firmware version:4.95.0
[  227.788384] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
[  227.817455] MXL5005S: Attached at address 0xc6
[  227.817470] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  227.818025] DVB: registering new adapter (KWorld PlusTV Dual DVB-T
Stick (DVB-T 399U))
[  228.545013] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
[  228.547638] af9013: firmware version:4.95.0
[  228.559259] DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
[  228.559787] MXL5005S: Attached at address 0xc6
[  228.564303] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input12
[  228.564739] dvb-usb: schedule remote query interval to 150 msecs.
[  228.564752] dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)
successfully initialized and connected.
[  228.696081] input: Afatech DVB-T 2 as
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3:1.1/input/input13
[  228.696848] generic-usb 0003:1B80:E399.0002: input,hidraw1: USB HID
v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:1d.7-3/input1
[  228.696961] usbcore: registered new interface driver usbhid
[  228.697228] usbcore: registered new interface driver dvb_usb_af9015
[  228.698570] usbhid: v2.6:USB HID core driver

I have two questions:

1. Is possible to disable the IR receiver? I use an other IR receiver
for my remote.
2. Is the dmesg OK? I have this error message: "af9015: recv bulk
message failed:-110" I must worry about it? I don't understand it.

The linuxtv.org wiki is outdated for this device:
http://www.linuxtv.org/wiki/index.php/KWorld_USB_Dual_DVB-T_TV_Stick_%28DVB-T_399U%29

I want to contribute with it, I don't write very good english and I
don't know what info put there. Can someone help with this?

Thanks and regards.

-- 
Josu Lazkano
