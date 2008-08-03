Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m732g1ZJ002108
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 22:42:01 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m732fb0x008778
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 22:41:38 -0400
From: Andy Walls <awalls@radix.net>
To: Steven Toth <stoth@hauppauge.com>
In-Reply-To: <489501BB.3070309@hauppauge.com>
References: <1217712326.2699.84.camel@morgan.walls.org>
	<489501BB.3070309@hauppauge.com>
Content-Type: text/plain
Date: Sat, 02 Aug 2008 22:36:21 -0400
Message-Id: <1217730981.5348.101.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"ivtv-users@ivtvdriver.org" <ivtv-users@ivtvdriver.org>,
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


> > I'd be interested in additional reports of:
> >
> > 1. Errors I made in the above collected data.
> >
> > 2. A CX23418 based card working properly or not under Linux (or Windows)
> > in a machine with a PCI v2.2 or earlier chipset.
> >
> > 3. The differences between PCI v2.2 and v2.3 that would cause PC v2.2
> > host writes to a PCI v2.3 device to fail or for reads to return bogus
> > values (i.e. reading back 0x7 after a value of 0x21c0b was just
> > written.)?
> >
> > 4. If anyone knows what magical tweak Windows or the Hauppauge HVR-1600
> > Windows driver is making to get the HVR-1600 working with (at least) the
> > VIA VT8363 & VT82C686.
> >   
> I suggested to Hans a while ago (irc) that if the gpio register 
> definition was incorrect, and the linux driver was writing to the wrong 
> register to bring the demod's in and out of reset, then a floating gpio 
> at a different address might cause the demod to go into reset and the 
> tuner access to be blocked. This would likely be platform specific and 
> power related.
> 
> Check this.

Steve,

Thanks, I will talk with Hans to verify the GPIO pins.  The best that I
know is that the comment block at the top os cx18-gpio.c is the correct
definition:

/*
 * HVR-1600 GPIO pins, courtesy of Hauppauge:
 *
 * gpio0: zilog ir process reset pin
 * gpio1: zilog programming pin (you should never use this)
 * gpio12: cx24227 reset pin
 * gpio13: cs5345 reset pin
*/

That the HVR-1600 entries in cx18-cards.c match that comment:

	.gpio_init.initial_value = 0x3001,
        .gpio_init.direction = 0x3001,
        .gpio_i2c_slave_reset = {
                .active_lo_mask = 0x3001,
                .msecs_asserted = 10,
                .msecs_recovery = 40,
                .ir_reset_mask  = 0x0001,
        },

and I wrote a reset function to assert the reset lines and wait for the
recovery period.

The Zilog programming pin is, I assume, the DBG pin of the Z8F0811 and
is an open collector/drain pin according to Zilog data sheets.  I've
assumed it's wired to a pull-up on the HVR-1600 and doesn't need to
driven by the CX23418.




> Also, Hauppauge do not have PCI v2.2 tech support calls that I'm aware 
> of - meaning either we're not hearing about them - or the problem is 
> specific to the linux driver.

I have one user reporting it doesn't work under linux, but does under XP
on a PCI v2.2 system; so that's consistent with your observations about
possibly being specific to linux.


The really strange case that let me know it likely wasn't a GPIO pin or
stuck I2C bus slave problem was Gerhard's and Matt's reports of
readback's from the I2C control registers being just plain wrong.
Here's an excerpt from Gerhard's log file:

Jul 19 12:23:01 wittregr-pvr kernel: [12569.016045] cx18:  Start initialization, version 1.0.0
Jul 19 12:23:01 wittregr-pvr kernel: [12569.016905] cx18-0: Initializing card #0
Jul 19 12:23:01 wittregr-pvr kernel: [12569.016923] cx18-0: Autodetected Hauppauge card
Jul 19 12:23:01 wittregr-pvr kernel: [12569.019858] cx18-0: cx23418 revision 01010000 (B)
Jul 19 12:23:02 wittregr-pvr kernel: [12569.092391] cx18-0 i2c: i2c init
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839087] cx180 i2c: cx18_setscl: On entry CX18_REG_I2C_1_WR = 0x7
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839093] cx18-0 warning: cx18_setscl: On entry read value (0x7) and previously written value (0x21c0b) upper bytes differ. Using previous value as it should be correct.
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839100] cx180 i2c: cx18_setscl: Wrote    CX18_REG_I2C_1_WR = 0x21c0b
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839265] cx180 i2c: cx18_setscl: Readback CX18_REG_I2C_1_WR = 0x7
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839270] cx18-0 warning: cx18_setscl: On exit readback value (0x7) and written value (0x21c0b) upper bytes differ
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839276] cx180 i2c: cx18_setsda: On entry CX18_REG_I2C_1_WR = 0x7
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839281] cx18-0 warning: cx18_setsda: On entry read value (0x7) and previously written value (0x21c0b) upper bytes differ. Using previous value as it should be correct.
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839287] cx180 i2c: cx18_setsda: Wrote    CX18_REG_I2C_1_WR = 0x21c0b
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839452] cx180 i2c: cx18_setsda: Readback CX18_REG_I2C_1_WR = 0x7
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839457] cx18-0 warning: cx18_setsda: On exit readback value (0x7) and written value (0x21c0b) upper bytes differ
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839956] cx180 i2c: cx18_setscl: On entry CX18_REG_I2C_2_WR = 0x7
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839961] cx18-0 warning: cx18_setscl: On entry read value (0x7) and previously written value (0x21c0b) upper bytes differ. Using previous value as it should be correct.
Jul 19 12:23:02 wittregr-pvr kernel: [12569.839967] cx180 i2c: cx18_setscl: Wrote    CX18_REG_I2C_2_WR = 0x21c0b
Jul 19 12:23:02 wittregr-pvr kernel: [12569.840307] cx180 i2c: cx18_setscl: Readback CX18_REG_I2C_2_WR = 0x7
Jul 19 12:23:02 wittregr-pvr kernel: [12569.840312] cx18-0 warning: cx18_setscl: On exit readback value (0x7) and written value (0x21c0b) upper bytes differ
Jul 19 12:23:02 wittregr-pvr kernel: [12569.840482] cx180 i2c: cx18_setsda: On entry CX18_REG_I2C_2_WR = 0x7
Jul 19 12:23:02 wittregr-pvr kernel: [12569.840488] cx18-0 warning: cx18_setsda: On entry read value (0x7) and previously written value (0x21c0b) upper bytes differ. Using previous value as it should be correct.
Jul 19 12:23:02 wittregr-pvr kernel: [12569.840493] cx180 i2c: cx18_setsda: Wrote    CX18_REG_I2C_2_WR = 0x21c0b
Jul 19 12:23:02 wittregr-pvr kernel: [12569.840822] cx180 i2c: cx18_setsda: Readback CX18_REG_I2C_2_WR = 0x7
Jul 19 12:23:02 wittregr-pvr kernel: [12569.840827] cx18-0 warning: cx18_setsda: On exit readback value (0x7) and written value (0x21c0b) upper bytes differ


The value just written to the registers (0x21c0b) is not the value read
back (0x7).  The PCI bus ordering rules for bridges and devices are
supposed to guarantee that the readback value will be the value from the
register after the write has occurred or 0xffffffff on a PCI bus error.

There was a case where one user (I can't remember who) had one set of
CX23418 I2C control registers respond properly, but the other set, 64 kB
away, responded as above: reading back 0x7 from the WR register and 0xf
for the RD register.


I have toyed with the idea that the I2C block within the CX23418 wasn't
being reset properly, but the one case where one I2C master appeared to
work while the other didn't threw some doubt on that.

Regards,
Andy

> - Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
