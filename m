Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1K83L8-0008Pf-5M
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 03:17:01 +0200
From: Andy Walls <awalls@radix.net>
To: hermann pitton <hermann-pitton@arcor.de>
In-Reply-To: <1213573393.2683.85.camel@pc10.localdom.local>
References: <de8cad4d0806150505k6b865dedq359d278ab467c801@mail.gmail.com>
	<1213567472.3173.50.camel@palomino.walls.org>
	<1213573393.2683.85.camel@pc10.localdom.local>
Date: Sun, 15 Jun 2008 21:17:07 -0400
Message-Id: <1213579027.3164.36.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 - dmesg errors and ir transmit
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mon, 2008-06-16 at 01:43 +0200, hermann pitton wrote:
> Hi,
> 
> Am Sonntag, den 15.06.2008, 18:04 -0400 schrieb Andy Walls:
> > On Sun, 2008-06-15 at 08:05 -0400, Brandon Jenkins wrote:

> > > Also, I have noticed a new message in dmesg indicating that ir
> > > transmitters may now be accessible? Is there anything I need to do to
> > > make use of them?
> > > 
> > > tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter
> > 
> > The IR on the HVR-1600 (a Zilog Z8F0811 microcontroller) is very much
> > like that of the PVR-150.  From what I can tell, it even appears to be
> > at the same i2c address. 
> > 
> > This previous message also indicates the PVR-150/500 IR is very similar
> > to the HVR-1600:
> > http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023532.html
> > 
> > 
> > Right now the cx18 driver has omitted some code present in ivtv related
> > to explicit reset of the IR microcontroller.  It shouldn't be hard to
> > add back that reset code,  if needed. 
> > 
> > I haven't had a chance to try the IR blaster out yet (it was on my todo
> > list before Feb 2009).  "Mark's brain dump" has a modified lirc package
> > for the PVR-150 IR blaster:
> > 
> > http://www.blushingpenguin.com/mark/blog/?p=24
> > http://charles.hopto.org/blog/?p=24
> > 
> > It's probably a good starting point.  There are likely to be differences
> > though, as the cx23418 has 2 I2C buses where the cx23416 only has 1 I2C
> > bus.
> > 
> > It looks like you're blazing a trail, as I can't find any documentation
> > on the 'net by anyone who has done this with a HVR-1600.  If lirc_i2c,
> > available with the normal lirc distribution for IR receive, can detect
> > the Z8F0811, you've probably got a good start.
> > 
> > Regards,
> > Andy
> > 
> > > Thanks!
> > > 
> > > Brandon
> > 
> 
> just a note, have been there already coming from other stuff to it,
> but don't remember the details off hand.
> 
> http://marc.info/?l=linux-video&m=119705840327989&w=2
> 
> and following.

Hermann,

Thanks.  More information is always good.


Hermann and Brandon,

I have done some research, (at least one version of) the PVR-150 and the
HVR-1600 both appear to use the Zilog Z8F0811 microcontroller.  The
lirc_pvr150 module probably has a good chance of working for IR Tx with
the HVR-1600.

I have just examined the lirc_pvr150 code, the kernel i2c-core, the cx18
and ivtv code.  Changes will be needed in:

1. lirc_pvr150.c
	- add request_module("cx18") near the end

	- change the explicit call to ivtv_reset_ir_gpio() to a 
		cx18 equivalent or somehow change to an ioctl()
		so that the code is more flexible.
	(Note that the cx18 i2c_adapter callback data has a 
	 different structure than ivtv to include not only the
	 card handle (struct ivtv/cx18 *), but also the i2c bus index)
	(Note that this module directly calls an ivtv module function:
	 not a very clean interface.)

	- change the struct ivtv declaration to a struct cx18

	- maybe some other stuff that all looks straightforward
	
2. cx18 driver:
	- port the ivtv_reset_ir_gpio() to cx18-gpio.c but using the
		struct cx18_i2c_callback_data * as the input argument.

	- add back the (private) ioctl() that also resets the IR chip

	- perhaps modify the cx18's "read/modify/write" strategy for i2c
		bus registers to "read mirrored copy/modify/write" to
		avoid PCI bus read aborts from trashing CX23418 I2C
		registers

I'll add the reset code to the cx18-i2c repository I have at linuxtv.org
when I get the chance.

I am at a loss to describe the lirc_pvr150.c code.  I don't quite
understand all the firmware "magic" going on in the code.  The scripts
in lirc/tools/pvr150 help a little.  I'd want to make as few changes as
possible to lirc_pvr150.c and hope it works.


> I was under the impression we have already duplicate code?

Almost duplicate.  In the initial port from ivtv to cx18, Hans left out
the CX23415 decoder code and the (ugly?) things which may not have been
needed or used.  We'll add those back in as needed.

It already appears necessary to add Zilog IR chip reset (and GPIO audio
mux switching) back into the cx18 driver.  But I'd like a cleaner
interface to the IR chip reset functions in the long run.

-Andy

> Cheers,
> Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
