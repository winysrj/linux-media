Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51J4EXI000929
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 15:04:14 -0400
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.121])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51J3gZK014610
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 15:03:42 -0400
Date: Sun, 1 Jun 2008 14:03:28 -0500
From: David Engel <david@istwok.net>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080601190328.GA23388@opus.istwok.net>
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
	<37219a840806010018m342ff1bh394248e62e0a8807@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840806010018m342ff1bh394248e62e0a8807@mail.gmail.com>
Cc: video4linux-list@redhat.com, Jason Pontious <jpontious@gmail.com>
Subject: Re: Kworld 115-No Analog Channels
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

On Sun, Jun 01, 2008 at 03:18:45AM -0400, Michael Krufky wrote:
> On Fri, May 30, 2008 at 10:58 AM, David Engel <david@istwok.net> wrote:
> > I ran into a similar (probably the same) problem last week.  My search
> > of the list archives revealed a known tuner detection regression in
> > 2.6.25.  It's supposed to be fixed in Mercurial but I didn't test it
> > because it was simpler to just go back to 2.6.24.x.  I don't know why
> > the fix hasn't made it into 2.6.25.x yet.
> 
> Which fix?  What problem does it fix?  More details, please :-)

When I ran into the problem last week, I went searching and ran across
this thread:

https://www.redhat.com/mailman/private/video4linux-list/2008-April/msg00221.html

I don't know if any of the posted patches or changes that eventually
went into mercurial fixed my problem or not.  Downgrading to 2.6.24.7
did fix the problem for me.  Since the above thread looked like the
same problem as mine, I figured I'd stick with 2.6.24.x until it got
fixed in 2.6.25.x or 2.6.26 comes out.

Here are the details concerning my problem.  When running 2.6.25.4,
analog capture on a Kworld ATSC 115 doesn't work with tvtime reporting
no signal.  Here is a snippet of my boot log with 2.6.25.4:

May 25 12:54:50 opus kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
May 25 12:54:50 opus kernel: ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
May 25 12:54:50 opus kernel: ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
May 25 12:54:50 opus kernel: saa7133[0]: found at 0000:01:08.0, rev: 209, irq: 16, latency: 255, mmio: 0xfdeff000
May 25 12:54:50 opus kernel: saa7133[0]: subsystem: 17de:7352, board: Kworld ATSC110/115 [card=90,insmod option]
May 25 12:54:50 opus kernel: saa7133[0]: board init: gpio is 100
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 00: de 17 52 73 ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 12:54:50 opus kernel: usb 2-9: new low speed USB device using ohci_hcd and address 2
May 25 12:54:50 opus kernel: saa7133[0]: registered device video0 [v4l2]
May 25 12:54:50 opus kernel: saa7133[0]: registered device vbi0
May 25 12:54:50 opus kernel: ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
May 25 12:54:50 opus kernel: ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [AAZA] -> GSI 22 (level, low) -> IRQ 22
May 25 12:54:50 opus kernel: PCI: Setting latency timer of device 0000:00:06.1 to 64
May 25 12:54:50 opus kernel: hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
May 25 12:54:50 opus kernel: usb 2-9: configuration #1 chosen from 1 choice
May 25 12:54:50 opus kernel: usbcore: registered new interface driver hiddev
May 25 12:54:50 opus kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.0/input/input5
May 25 12:54:50 opus kernel: input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-9
May 25 12:54:50 opus kernel: usbcore: registered new interface driver usbhid
May 25 12:54:50 opus kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
May 25 12:54:50 opus kernel: nxt200x: NXT2004 Detected
May 25 12:54:50 opus kernel: DVB: registering new adapter (saa7133[0])
May 25 12:54:50 opus kernel: DVB: registering frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
May 25 12:54:50 opus kernel: nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
May 25 12:54:50 opus kernel: nxt2004: Waiting for firmware upload(2)...
May 25 12:54:50 opus kernel: Adding 2000084k swap on /dev/sda2.  Priority:-1 extents:1 across:2000084k
May 25 12:54:50 opus kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
May 25 12:54:50 opus kernel: EXT3 FS on sda1, internal journal
May 25 12:54:50 opus kernel: nxt2004: Firmware upload complete

Manually specifying the tuner type when loading the saa7134 module
makes no difference.

Booting with 2.6.24.7 fixes the problem.  Here is a snippet of the
boot log with 2.6.24.7:

May 25 14:01:27 opus kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
May 25 14:01:27 opus kernel: forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:e0:4d:1a:27:30
May 25 14:01:27 opus kernel: forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
May 25 14:01:27 opus kernel: ACPI: PCI Interrupt Link [APCF] enabled at IRQ 20
May 25 14:01:27 opus kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 20 (level, low) -> IRQ 19
May 25 14:01:27 opus kernel: PCI: Setting latency timer of device 0000:00:02.0 to 64
May 25 14:01:27 opus kernel: ohci_hcd 0000:00:02.0: OHCI Host Controller
May 25 14:01:27 opus kernel: ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
May 25 14:01:27 opus kernel: ohci_hcd 0000:00:02.0: irq 19, io mem 0xfe02f000
May 25 14:01:27 opus kernel: usb usb1: configuration #1 chosen from 1 choice
May 25 14:01:27 opus kernel: hub 1-0:1.0: USB hub found
May 25 14:01:27 opus kernel: hub 1-0:1.0: 10 ports detected
May 25 14:01:27 opus kernel: ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
May 25 14:01:27 opus kernel: ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 16
May 25 14:01:27 opus kernel: PCI: Setting latency timer of device 0000:00:02.1 to 64
May 25 14:01:27 opus kernel: ehci_hcd 0000:00:02.1: EHCI Host Controller
May 25 14:01:27 opus kernel: ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
May 25 14:01:27 opus kernel: ehci_hcd 0000:00:02.1: debug port 1
May 25 14:01:27 opus kernel: PCI: cache line size of 64 is not supported by device 0000:00:02.1
May 25 14:01:27 opus kernel: ehci_hcd 0000:00:02.1: irq 16, io mem 0xfe02e000
May 25 14:01:27 opus kernel: ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 25 14:01:27 opus kernel: usb usb2: configuration #1 chosen from 1 choice
May 25 14:01:27 opus kernel: hub 2-0:1.0: USB hub found
May 25 14:01:27 opus kernel: hub 2-0:1.0: 10 ports detected
May 25 14:01:27 opus kernel: ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
May 25 14:01:27 opus kernel: ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 20
May 25 14:01:27 opus kernel: saa7133[0]: found at 0000:01:08.0, rev: 209, irq: 20, latency: 255, mmio: 0xfdeff000
May 25 14:01:27 opus kernel: saa7133[0]: subsystem: 17de:7352, board: Kworld ATSC110/115 [card=90,autodetected]
May 25 14:01:27 opus kernel: saa7133[0]: board init: gpio is 100
May 25 14:01:27 opus kernel: saa7133[0]: i2c eeprom 00: de 17 52 73 ff ff ff ff ff ff ff ff ff ff ff ff
May 25 14:01:27 opus kernel: saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 14:01:27 opus kernel: saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 14:01:27 opus kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 14:01:27 opus kernel: saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 14:01:27 opus kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 14:01:27 opus kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 14:01:27 opus kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 25 14:01:27 opus kernel: tuner 2-0061: chip found @ 0xc2 (saa7133[0])
May 25 14:01:27 opus kernel: tuner-simple 2-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
May 25 14:01:27 opus kernel: tuner 2-0061: type set to Philips TUV1236D AT
May 25 14:01:27 opus kernel: tuner-simple 2-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
May 25 14:01:27 opus kernel: tuner 2-0061: type set to Philips TUV1236D AT
May 25 14:01:27 opus kernel: saa7133[0]: registered device video0 [v4l2]
May 25 14:01:27 opus kernel: saa7133[0]: registered device vbi0
May 25 14:01:27 opus kernel: ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
May 25 14:01:27 opus kernel: ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [AAZA] -> GSI 22 (level, low) -> IRQ 17
May 25 14:01:27 opus kernel: PCI: Setting latency timer of device 0000:00:06.1 to 64
May 25 14:01:27 opus kernel: hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
May 25 14:01:27 opus kernel: nxt200x: NXT2004 Detected
May 25 14:01:27 opus kernel: DVB: registering new adapter (saa7133[0])
May 25 14:01:27 opus kernel: DVB: registering frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
May 25 14:01:27 opus kernel: nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
May 25 14:01:27 opus kernel: nxt2004: Waiting for firmware upload(2)...
May 25 14:01:27 opus kernel: usb 1-9: new low speed USB device using ohci_hcd and address 2
May 25 14:01:27 opus kernel: usb 1-9: configuration #1 chosen from 1 choice
May 25 14:01:27 opus kernel: usbcore: registered new interface driver hiddev
May 25 14:01:27 opus kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.0/usb1/1-9/1-9:1.0/input/input5
May 25 14:01:27 opus kernel: input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-9
May 25 14:01:27 opus kernel: usbcore: registered new interface driver usbhid
May 25 14:01:27 opus kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
May 25 14:01:27 opus kernel: nxt2004: Firmware upload complete
May 25 14:01:27 opus kernel: nxt200x: Timeout waiting for nxt2004 to init.

Notice the additional log entries regarding the tuner detection.

FWIW, I have another system with 2 KWorld ATSC 115s.  That system has
always had issues with tuner detection no what kernel I use.
Depending on which PCI slots I place the cards in, I either get 0 or 1
tuners detected, but never 2.  I posted about that problem several
months ago, but never got a response from anyone.

David
-- 
David Engel
david@istwok.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
