Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7H1tr7m018193
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 21:55:53 -0400
Received: from web34503.mail.mud.yahoo.com (web34503.mail.mud.yahoo.com
	[66.163.178.169])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7H1sNUj011403
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 21:54:23 -0400
Date: Sat, 16 Aug 2008 18:54:17 -0700 (PDT)
From: Carlos Limarino <climarino@yahoo.com.ar>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <474079.21637.qm@web34503.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Subject: Help needed to add support for the card Compro VideoMate X50
	(CX88/XC2028)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi, 

I'm trying to add support for a CX23880 based card that uses the Xceive 2028 tuner. Support for this tuner was recently added to the kernel, I tried using similar cards already supported by the driver. The results were:

using card=62 (PowerColor RA330)

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
cx88[0]: subsystem: 185b:e000, board: PowerColor RA330 [card=62,insmod option]
cx88[0]: TV tuner type 71, Radio tuner type 0
tuner' 2-0061: chip found @ 0xc2 (cx88[0])
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
cx88 IR (PowerColor RA330): unknown key: key=0x3f raw=0x3f down=1
cx88 IR (PowerColor RA330): unknown key: key=0x3f raw=0x3f down=0
input: cx88 IR (PowerColor RA330) as /devices/pci0000:00/0000:00:10.0/0000:02:09.0/input/input6
cx88[0]/0: found at 0000:02:09.0, rev: 5, irq: 17, latency: 32, mmio: 0xfc000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
firmware: requesting xc3028-v27.fw
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: i2c output error: rc = -121 (should be 64)
xc2028 2-0061: -121 returned from send
xc2028 2-0061: Error -22 while loading base firmware
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: i2c output error: rc = -121 (should be 64)
xc2028 2-0061: -121 returned from send
xc2028 2-0061: Error -22 while loading base firmware
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: Loading firmware for type=FM (400), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback

using card=61 (Winfast TV2000 XP Global)

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
cx88[0]: subsystem: 185b:e000, board: Winfast TV2000 XP Global [card=61,insmod option]
cx88[0]: TV tuner type 71, Radio tuner type 0
tuner' 2-0061: chip found @ 0xc2 (cx88[0])
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
cx88[0]/0: found at 0000:02:09.0, rev: 5, irq: 17, latency: 32, mmio: 0xfc000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
firmware: requesting xc3028-v27.fw
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
i2c-adapter i2c-2: sendbytes: NAK bailout.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
i2c-adapter i2c-2: sendbytes: NAK bailout.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
i2c-adapter i2c-2: sendbytes: NAK bailout.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
cx88[0]: Calling XC2028/3028 callback
xc2028 2-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
i2c-adapter i2c-2: sendbytes: NAK bailout.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware

Developers of the CX18 driver found a similar problem with some cards, it seems that the pin that is used to reset the tuner changes from card to card:

http://www.gossamer-threads.com/lists/ivtv/devel/38594

Since I don't have much knowledge about driver programming, I can't find something similar to 'xceive_pin' to change & test. I would greatly appreciate any help with this.

Thank you!



      Yahoo! Cocina
Recetas prácticas y comida saludable
http://ar.mujer.yahoo.com/cocina/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
