Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m761qXaK001432
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 21:52:33 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m761pxQK031967
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 21:51:59 -0400
From: Andy Walls <awalls@radix.net>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <489501BB.3070309@hauppauge.com>
References: <1217712326.2699.84.camel@morgan.walls.org>
	<489501BB.3070309@hauppauge.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 21:46:47 -0400
Message-Id: <1217987207.5252.21.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "ivtv-users@ivtvdriver.org" <ivtv-users@ivtvdriver.org>,
	"ivtv-devel@ivtvdriver.org" <ivtv-devel@ivtvdriver.org>
Subject: Re: cx18: Possible causal realtionship for HVR-1600 I2C errors
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

> Andy Walls wrote:
> > Quite a few HVR-1600 users have reported cx18 driver I2C related
> > problems usually with the following errors present:
> >
> >    tveeprom 1-0050: Huh, no eeprom present (err=-121)?
> >    tveeprom 1-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.
> >
> >    s5h1409_readreg: readreg error (ret == -121)
> >    cx18: frontend initialization failed
> >    cx18-0: DVB failed to register
> >
> > and an unusable HVR-1600/CX23418 under linux.
> >
> >
> > On the surface the problem appeared to be related to the devices on the
> > I2C buses of the HVR-1600.  Given the data from a number of user reports
> > piling up, I think I can say that it's likely a PCI v2.2 or earlier bus
> > problem with the CX23418 under linux.  The I2C bus errors appear to be
> > just a symptom of a larger underlying problem.
> >


> > 2. A CX23418 based card working properly or not under Linux (or Windows)
> > in a machine with a PCI v2.2 or earlier chipset.

A Status update on this.  I am happy(?) to report that I can reproduce
this problem myself now on an old machine with an Intel 82801AA
Southbridge with the Conexant Raptor PAL/SECAM card installed:

Aug  5 21:17:39 arabian kernel: Linux video capture interface: v2.00
Aug  5 21:17:39 arabian kernel: cx18:  Start initialization, version 1.0.0
Aug  5 21:17:39 arabian kernel: cx18-0: Initializing card #0
Aug  5 21:17:39 arabian kernel: cx18-0: Autodetected Conexant Raptor PAL/SECAM card
Aug  5 21:17:39 arabian kernel: cx18-0 info: base addr: 0xf8000000
Aug  5 21:17:39 arabian kernel: cx18-0 info: Enabling pci device
Aug  5 21:17:39 arabian kernel: ACPI: PCI Interrupt 0000:01:03.0[A] -> Link [LNKD] -> GSI 9 (level, low) -> IR
Q 9
Aug  5 21:17:39 arabian kernel: cx18-0 info: cx23418 (rev 0) at 01:03.0, irq: 9, latency: 64, memory: 0xf80000
00
Aug  5 21:17:39 arabian kernel: cx18-0 info: attempting ioremap at 0xf8000000 len 0x04000000
Aug  5 21:17:39 arabian kernel: cx18-0: cx23418 revision 01010000 (B)
Aug  5 21:17:40 arabian kernel: cx18-0 info: GPIO initial dir: 0000ffff/0000ffff out: 00000000/00000000
Aug  5 21:17:40 arabian kernel: cx18-0 info: activating i2c...
Aug  5 21:17:40 arabian kernel: cx18-0 i2c: i2c init
Aug  5 21:17:40 arabian kernel: cx180 i2c: cx18_setscl: On entry CX18_REG_I2C_1_WR = 0x7
Aug  5 21:17:40 arabian kernel: cx18-0 warning: cx18_setscl: On entry read value (0x7) and previously written value (0x21c0b) upper bytes differ. Using previous value as it should be correct.
Aug  5 21:17:40 arabian kernel: cx180 i2c: cx18_setscl: Wrote    CX18_REG_I2C_1_WR = 0x21c0b
Aug  5 21:17:40 arabian kernel: cx180 i2c: cx18_setscl: Readback CX18_REG_I2C_1_WR = 0x7
Aug  5 21:17:40 arabian kernel: cx18-0 warning: cx18_setscl: On exit readback value (0x7) and written value (0x21c0b) upper bytes differ
Aug  5 21:17:40 arabian kernel: cx180 i2c: cx18_setsda: On entry CX18_REG_I2C_1_WR = 0x7


This should hopefully speed resolution of the CX23418 I2C problems under
Linux with older systems.  I'm sure I won't be able to get too far
towards resolution before 25 Aug, due to a busy upcoming personal
schedule.  

This is a step forward so at least I won't have to bother users with the
sometimes painful iterative troubleshooting.  To all the cx18 users who
have patiently provided data at my request on this problem so far, thank
you.

Regards,
Andy






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
