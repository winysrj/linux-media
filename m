Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m8L1oEWm004870
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 21:50:14 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m8L1nseI013206
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 21:49:55 -0400
From: Andy Walls <awalls@radix.net>
To: Dale Pontius <DEPontius@edgehp.net>
In-Reply-To: <48D4D5FE.60507@edgehp.net>
References: <48D4D5FE.60507@edgehp.net>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 21:43:47 -0400
Message-Id: <1221961427.6151.43.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: HVR-1600 - unable to find tuner
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

On Sat, 2008-09-20 at 06:52 -0400, Dale Pontius wrote:

> A week back I posted a "newby question," and eventually it became
> apparent that I can't find my tuner.

>  I loaded the module with:
> "modprobe cx18 mmio_ndelay=61"

You can always try higher numbers to see if things get better at some
higher value.  Use multiples of 30.3.


> The results of dmesg:
> cx18:  Start initialization, version 1.0.0
> cx18-0: Initializing card #0
> cx18-0: Autodetected Hauppauge card
> ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
> cx18-0: Unreasonably low latency timer, setting to 64 (was 32)
> cx18-0: cx23418 revision 01010000 (B)
> tveeprom 6-0050: Hauppauge model 74041, rev C6B2, serial# 3334244
> tveeprom 6-0050: MAC address is 00-0D-FE-32-E0-64
> tveeprom 6-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
> tveeprom 6-0050: TV standards NTSC(M) (eeprom 0x08)
> tveeprom 6-0050: audio processor is CX23418 (idx 38)
> tveeprom 6-0050: decoder processor is CX23418 (idx 31)
> tveeprom 6-0050: has no radio, has IR receiver, has IR transmitter
> cx18-0: Autodetected Hauppauge HVR-1600
> cx18-0: VBI is not yet supported
> cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> cx18-0: Disabled encoder IDX device
> cx18-0: Registered device video1 for encoder MPEG (2 MB)
> DVB: registering new adapter (cx18)
> MXL5005S: Attached at address 0x63
> DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
> cx18-0: DVB Frontend registered
> cx18-0: Registered device video32 for encoder YUV (2 MB)
> cx18-0: Registered device video24 for encoder PCM audio (1 MB)
> cx18-0: Initialized card #0: Hauppauge HVR-1600
> cx18:  End initialization

Just FYI, the CX23418 has 2 I2C masters built into it, so it contributes
two new, separate i2c buses to your system.  In this case i2c-6 and
i2c-7 are the two buses on your system.

The two I2C devices that correspond to the analog NTSC tuner (a
mixer/osc chip and an IF demodulator chip) should be on the second i2c
bus (i2c-7 or cx18 i2c driver #0-1).  All the other devices are on the
first i2c bus.



> Then thinking about the i2c problems, and not easily finding any sort
> of "i2c-explorer" or "lsi2c"

For a handy i2c explorer tool you can use i2cdetect from the lm_sensors
or i2c-tools package.  You must also have the i2c-dev module built.
Modprobe the i2c-dev module, have i2cdetect list the buses, then run
i2cdetect to probe all the addresses on the i2c buses of the cx18 based
card.  Analog tuner mixer/osc chips will show up in the low 0x60's
(0x60, 0x61 IIRC).



> I understand that both tuners are supposed to be attached to the i2c
> bus of the cx18, and it's pretty clear that the ATSC/QAM tuner is
> there. But other than the "video4linux:video1" I don't see
> anything that smacks of the NTSC tuner.
> 
> Can someone tell me what this is supposed to look like,

The init messages in dmesg for my HVR-1600 MCE shows the mixer/osc is at
0x61 (0xc2) and the IF demodulator is at 0x43 (0x86) and that they are
both on the second i2c bus: cx18 #0-1:

tuner 1-0043: chip found @ 0x86 (cx18 i2c driver #0-1)
tda9887 1-0043: creating new instance
tda9887 1-0043: tda988[5/6/7] found
tuner 1-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 43 (Philips NTSC MK3 (FM1236MK3 or
FM1236/F))

The MCE version has a tda9887 IF demodulator which supports FM radio.
Your non-MCE card, without FM radio, may have something a little
different for an IF demodulator chip.




>  or suggest a next step in finding my tuner?

1. Make sure you have tuner modules installed somewhere
under /lib/modules (i.e. tuner.ko, tuner-simple.ko, etc.)

2. Turn on some debugging in /etc/modprobe.conf:

	options tuner debug=1 show_i2c=1
	options tuner-simple debug=1
	options cx18 debug=67
	
and see, if on module load, something obviously looks wrong.

3. You can increase the msecs_asserted and msecs_recovery in
linux/drivers/media/video/cx18/cx18-cards.c and the mdelays() in
linux/drivers/media/video/cx18/cx18-i2c.c to some ridiculously high
numbers (e.g. 100 msec) to make sure everything connected to the I2C
buses gets reset.  (Obviously rebuild and reinstall the cx18.ko module.)

4. As I mentioned before, you may just need to set the mmio_ndelay
number higher.  From my observations, the CX23418 appears to have a
problem when accessing one set of its registers and then jumping to
access registers in a different part of its register address space with
no "dead time" in between.  The control registers for the first and
second I2C bus masters are about 64k apart, and, of course, accessed
almost back to back during module initialization.  The mmio_ndelay
parameter adds in the "dead time" the CX23418 occasionally seems to
need.


Good luck.

Andy

> Thanks,
> Dale Pontius

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
