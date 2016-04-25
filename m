Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33264 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbcDYEGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 00:06:38 -0400
Received: by mail-io0-f196.google.com with SMTP id x35so10225950ioi.0
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 21:06:37 -0700 (PDT)
Received: from berrier.lan (75-162-111-89.slkc.qwest.net. [75.162.111.89])
        by smtp.googlemail.com with ESMTPSA id fm1sm8152990igb.1.2016.04.24.21.06.35
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 24 Apr 2016 21:06:36 -0700 (PDT)
Date: Sun, 24 Apr 2016 22:06:33 -0600
From: Wade Berrier <wberrier@gmail.com>
To: linux-media@vger.kernel.org
Subject: mceusb xhci issue?
Message-ID: <20160425040632.GD15140@berrier.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a mceusb compatible transceiver that only seems to work with
certain computers.  I'm testing this on centos7 (3.10.0) and fedora23
(4.4.7).

The only difference I can see is that the working computer shows
"using uhci_hcd" and the non working shows "using xhci_hcd".

Here's the dmesg output of the non-working version:

---------------------

[  217.951079] usb 1-5: new full-speed USB device number 10 using xhci_hcd
[  218.104087] usb 1-5: device descriptor read/64, error -71
[  218.371010] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x1 has an invalid bInterval 0, changing to 32
[  218.371019] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x81 has an invalid bInterval 0, changing to 32
[  218.373591] usb 1-5: New USB device found, idVendor=1784, idProduct=0006
[  218.373600] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  218.373605] usb 1-5: Product: eHome Infrared Transceiver
[  218.373608] usb 1-5: Manufacturer: TopSeed Technology Corp.
[  218.373611] usb 1-5: SerialNumber: TS004RrP
[  218.376082] Registered IR keymap rc-rc6-mce
[  218.376277] input: Media Center Ed. eHome Infrared Remote Transceiver (1784:0006) as /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/rc/rc0/input13
[  218.376387] rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0006) as /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/rc/rc0
[  218.377439] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input14
[  218.377733] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[  218.508970] mceusb 1-5:1.0: Registered TopSeed Technology Corp. eHome Infrared Transceiver with mce emulator interface version 1
[  218.508976] mceusb 1-5:1.0: 2 tx ports (0x0 cabled) and 2 rx sensors (0x0 active)

---------------------

and the working version:

---------------------

[  407.226018] usb 2-2: new full-speed USB device number 3 using uhci_hcd
[  412.329019] usb 2-2: device descriptor read/64, error -110
[  412.578054] usb 2-2: config 1 interface 0 altsetting 0 endpoint 0x1 has an invalid bInterval 0, changing to 32
[  412.578540] usb 2-2: config 1 interface 0 altsetting 0 endpoint 0x81 has an invalid bInterval 0, changing to 32
[  412.613053] usb 2-2: New USB device found, idVendor=1784, idProduct=0006
[  412.613542] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  412.614172] usb 2-2: Product: eHome Infrared Transceiver
[  412.615060] usb 2-2: Manufacturer: TopSeed Technology Corp.
[  412.615930] usb 2-2: SerialNumber: TS004RrP
[  412.624068] Registered IR keymap rc-rc6-mce
[  412.624672] input: Media Center Ed. eHome Infrared Remote Transceiver (1784:0006) as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/rc/rc0/input22
[  412.625404] rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0006) as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/rc/rc0
[  412.626251] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input23
[  412.627627] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[  412.782038] mceusb 2-2:1.0: Registered TopSeed Technology Corp. eHome Infrared Transceiver with mce emulator interface version 1
[  412.782594] mceusb 2-2:1.0: 2 tx ports (0x0 cabled) and 2 rx sensors (0x1 active)

---------------------

It seems like there's been some similar history with this driver:

https://patchwork.linuxtv.org/patch/21648/

Any suggestions?  Where to go from here? Any tips or workarounds would
be appreciated.

Thanks,

Wade

P.S. some notes about leading up to this was posted on the lirc
mailing list:

https://sourceforge.net/p/lirc/mailman/message/35036744/
https://sourceforge.net/p/lirc/mailman/message/35038602/
