Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51KmNO3000832
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 16:48:23 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51Kluls027031
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 16:47:57 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <37219a840806011210h6c7b55b0tc4bcfec1bcf3ad9b@mail.gmail.com>
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
	<37219a840806010018m342ff1bh394248e62e0a8807@mail.gmail.com>
	<20080601190328.GA23388@opus.istwok.net>
	<37219a840806011210h6c7b55b0tc4bcfec1bcf3ad9b@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 01 Jun 2008 22:46:20 +0200
Message-Id: <1212353180.3512.13.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Jason Pontious <jpontious@gmail.com>,
	David Engel <david@istwok.net>
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

Mike,

Am Sonntag, den 01.06.2008, 15:10 -0400 schrieb Michael Krufky:
> David,
> 
> On Sun, Jun 1, 2008 at 3:03 PM, David Engel <david@istwok.net> wrote:
> > On Sun, Jun 01, 2008 at 03:18:45AM -0400, Michael Krufky wrote:
> >> On Fri, May 30, 2008 at 10:58 AM, David Engel <david@istwok.net> wrote:
> >> > I ran into a similar (probably the same) problem last week.  My search
> >> > of the list archives revealed a known tuner detection regression in
> >> > 2.6.25.  It's supposed to be fixed in Mercurial but I didn't test it
> >> > because it was simpler to just go back to 2.6.24.x.  I don't know why
> >> > the fix hasn't made it into 2.6.25.x yet.
> >>
> >> Which fix?  What problem does it fix?  More details, please :-)
> >
> > When I ran into the problem last week, I went searching and ran across
> > this thread:
> >
> > https://www.redhat.com/mailman/private/video4linux-list/2008-April/msg00221.html
> 
> This is in the private archives...  Do you have a link from gmane or
> some other public archive?

it is the first posting from Ian Pickworth there, followed by an reply
by me, since Ian helped on several cx88 norm setting issues and also
with the tda9887 radio support, you might not remember anymore, but to
leave him without reply is beyond my scope.

The bug was confirmed then by Gert, who did the initial empress encoder
support.

However, Mauro fixed the eeprom detection then within all that immense
traffic and work during the last merge window open.

Remaining serious issues are, since 2.6.25 the users can't select the
PAL/SECAM subnorms anymore after the ioctl2 conversion, which is an
extremely bad idea on saa713x, and further it is more improved on 2.6.26
now, that they are not even to set the tuner type anymore, without to
change it in the source, which is another extremely bad idea, as I
posted several times.

I don't blame anyone, Hartmut and me were also too much focused on the
outstanding DVB-S stuff that time and did not care much about analog,
but the driver is in serious troubles now and I'm a little bit grumpy,
or at least not in the mood to explain again and again were we are ...

Cheers,
Hermann

> > I don't know if any of the posted patches or changes that eventually
> > went into mercurial fixed my problem or not.  Downgrading to 2.6.24.7
> > did fix the problem for me.  Since the above thread looked like the
> > same problem as mine, I figured I'd stick with 2.6.24.x until it got
> > fixed in 2.6.25.x or 2.6.26 comes out.
> >
> > Here are the details concerning my problem.  When running 2.6.25.4,
> > analog capture on a Kworld ATSC 115 doesn't work with tvtime reporting
> > no signal.  Here is a snippet of my boot log with 2.6.25.4:
> >
> > May 25 12:54:50 opus kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
> > May 25 12:54:50 opus kernel: ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> > May 25 12:54:50 opus kernel: ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
> > May 25 12:54:50 opus kernel: saa7133[0]: found at 0000:01:08.0, rev: 209, irq: 16, latency: 255, mmio: 0xfdeff000
> > May 25 12:54:50 opus kernel: saa7133[0]: subsystem: 17de:7352, board: Kworld ATSC110/115 [card=90,insmod option]
> > May 25 12:54:50 opus kernel: saa7133[0]: board init: gpio is 100
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 00: de 17 52 73 ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > May 25 12:54:50 opus kernel: usb 2-9: new low speed USB device using ohci_hcd and address 2
> > May 25 12:54:50 opus kernel: saa7133[0]: registered device video0 [v4l2]
> > May 25 12:54:50 opus kernel: saa7133[0]: registered device vbi0
> > May 25 12:54:50 opus kernel: ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> > May 25 12:54:50 opus kernel: ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [AAZA] -> GSI 22 (level, low) -> IRQ 22
> > May 25 12:54:50 opus kernel: PCI: Setting latency timer of device 0000:00:06.1 to 64
> > May 25 12:54:50 opus kernel: hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> > May 25 12:54:50 opus kernel: usb 2-9: configuration #1 chosen from 1 choice
> > May 25 12:54:50 opus kernel: usbcore: registered new interface driver hiddev
> > May 25 12:54:50 opus kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.0/input/input5
> > May 25 12:54:50 opus kernel: input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-9
> > May 25 12:54:50 opus kernel: usbcore: registered new interface driver usbhid
> > May 25 12:54:50 opus kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> > May 25 12:54:50 opus kernel: nxt200x: NXT2004 Detected
> > May 25 12:54:50 opus kernel: DVB: registering new adapter (saa7133[0])
> > May 25 12:54:50 opus kernel: DVB: registering frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
> > May 25 12:54:50 opus kernel: nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
> > May 25 12:54:50 opus kernel: nxt2004: Waiting for firmware upload(2)...
> > May 25 12:54:50 opus kernel: Adding 2000084k swap on /dev/sda2.  Priority:-1 extents:1 across:2000084k
> > May 25 12:54:50 opus kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
> > May 25 12:54:50 opus kernel: EXT3 FS on sda1, internal journal
> > May 25 12:54:50 opus kernel: nxt2004: Firmware upload complete
> >
> > Manually specifying the tuner type when loading the saa7134 module
> > makes no difference.
> 
> Under 2.6.25, can you confirm whether or not the "tuner" module is
> actually loaded?  If it is loaded, can you do:
> 
> modprobe -r tuner
> modprobe -r tuner-simple
> modprobe tuner-simple debug=1
> modprobe tuner debug=1
> 
> ...then test again and show the dmesg logs.
> 
> Regards,
> 
> Mike
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
