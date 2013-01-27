Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38147 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab3A0XOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 18:14:39 -0500
Received: by mail-lb0-f176.google.com with SMTP id s4so3108275lbc.21
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2013 15:14:37 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Jan 2013 00:14:37 +0100
Message-ID: <CALGqSbsA9fUCVcBf3F_r7O-CbLPnjj==voy5sZ8Nf8f1MLPT9w@mail.gmail.com>
Subject: HI
From: Igor Stamatovski <stamatovski@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Im trying to use ADS tech instantFM music USB card.

dmesg reports this after machine reset (USB stays on machine)

[    6.387624] USB radio driver for Si470x FM Radio Receivers, Version 1.0.10
[    6.930228] radio-si470x 1-1.2:1.2: DeviceID=0xffff ChipID=0xffff
[    7.172429] radio-si470x 1-1.2:1.2: software version 0, hardware version 7
[    7.355485] radio-si470x 1-1.2:1.2: This driver is known to work
with software version 7,
[    7.532554] radio-si470x 1-1.2:1.2: but the device has software version 0.
[    7.644091] radio-si470x 1-1.2:1.2: If you have some trouble using
this driver,
[    7.728735] radio-si470x 1-1.2:1.2: please report to V4L ML at
linux-media@vger.kernel.org
[    7.840415] usbcore: registered new interface driver radio-si470x
[    8.465398] usbcore: registered new interface driver snd-usb-audio

i can note the deviceID and ChipID are not recognised but still some
modules load for the card...

after reinsert same USB card reports this

[  102.460158] usb 1-1.2: USB disconnect, device number 4
[  102.464721] radio-si470x 1-1.2:1.2: si470x_set_report:
usb_control_msg returned -19
[  106.535669] usb 1-1.2: new full-speed USB device number 6 using dwc_otg
[  106.638514] usb 1-1.2: New USB device found, idVendor=06e1, idProduct=a155
[  106.638545] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  106.638562] usb 1-1.2: Product: ADS InstantFM Music
[  106.638576] usb 1-1.2: Manufacturer: ADS TECH
[  106.644537] radio-si470x 1-1.2:1.2: DeviceID=0x1242 ChipID=0x0a0f
[  106.645257] radio-si470x 1-1.2:1.2: software version 0, hardware version 7
[  106.645288] radio-si470x 1-1.2:1.2: This driver is known to work
with software version 7,
[  106.645306] radio-si470x 1-1.2:1.2: but the device has software version 0.
[  106.645321] radio-si470x 1-1.2:1.2: If you have some trouble using
this driver,
[  106.645337] radio-si470x 1-1.2:1.2: please report to V4L ML at
linux-media@vger.kernel.org

the radio can scan local radios and create config file with the radio
application.
using arecord piped to aplay does nothing.

i wanted to know how do i update software version 0 to software
version 7 and try this driver?

Thanks
