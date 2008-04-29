Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TNnBcQ028387
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 19:49:11 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TNmXdu012504
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 19:48:33 -0400
From: Andy Walls <awalls@radix.net>
To: Marc Randolph <mrandtx@yahoo.com>
In-Reply-To: <88771.83842.qm@web83107.mail.mud.yahoo.com>
References: <88771.83842.qm@web83107.mail.mud.yahoo.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 29 Apr 2008 19:47:48 -0400
Message-Id: <1209512868.5699.32.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: MCE TV Philips 7135 Cardbus don't work
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

On Tue, 2008-04-29 at 16:20 -0700, Marc Randolph wrote:
> --- Emilio Lazo Zaia <emiliolazozaia@gmail.com> wrote:
> 
> > Hello,
> > 
> > I have purchased a "MCE TV Philips 7135 Cardbus" and I'm to set it up.
> > When I plug it, the module saa7134 is being loaded and dmesg says:
> > 
> > ï»¿pccard: CardBus card inserted into slot 0
> > Linux video capture interface: v2.00
> > saa7130/34: v4l2 driver version 0.2.14 loaded
> > PCI: Enabling device 0000:06:00.0 (0000 -> 0002)
> > ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> > saa7133[0]: found at 0000:06:00.0, rev: 209, irq: 17, latency: 0, mmio:
> > 0x54000000
> > PCI: Setting latency timer of device 0000:06:00.0 to 64
> > saa7133[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
> > [card=0,autodetected]
> > saa7133[0]: board init: gpio is e2c0c0
> > saa7133[0]: Huh, no eeprom present (err=-5)?
> > saa7133[0]: registered device video0 [v4l2]
> > saa7133[0]: registered device vbi0
> 
> Howdy Emilio,
> 
> Google gives a ton of hits on that very unique error message.  I assume you
> already did this:
> 
> "try to pass newi2c=1 or newi2c=0 to the ivtv module. Add it to
> /etc/modprobe.conf (or /etc/modules.d/ivtv if you are an gentoo user).
> 
> options ivtv newi2c=1
> 
> If setting this works please report it to the ivtv-devel mailing list."
> 
> Copied from
> http://ivtvdriver.org/index.php/Troubleshooting#Error:_Huh.2C_no_eeprom_present_.28err.3D-121.29.3F
> 

Marc,

Good reasoning, but as it happens, this error message is not quite
unique.  The ivtv/tveeprom modules will additionally gripe about "not a
Hauppauge EEPROM".  The ivtv/tveeprom modules will usually return -121
corresponding to -EREMOTEIO.

Emilio,

This card is handled by the saa7134, module, not the ivtv module, so
newi2c doesn't apply.

"Huh, no eeprom present" in this case is being emitted by the saa7134
module itself and not the tveeprom module that ivtv uses.

"err=-5" is -EIO, referring to an I2C bus error with the i2c bus of the
saa7133.

With the saa7134 module "/sbin/modinfo" has two interesting options:
i2c_scan and i2c_debug which you may wish to try.

Regards,
Andy

> Good luck,
> 
>    Marc
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
