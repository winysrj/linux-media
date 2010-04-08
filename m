Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44845 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756170Ab0DHA1t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 20:27:49 -0400
Subject: Re: [RFC] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Andy Walls <awalls@md.metrocast.net>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <20100407114234.GA3476@hardeman.nu>
References: <20100406104410.710253548@hardeman.nu>
	 <20100406104811.GA6414@hardeman.nu> <4BBB449B.3000207@infradead.org>
	 <1270635607.3021.222.camel@palomino.walls.org>
	 <20100407114234.GA3476@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 20:28:10 -0400
Message-Id: <1270686490.3798.41.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-04-07 at 13:42 +0200, David Härdeman wrote:
> On Wed, Apr 07, 2010 at 06:20:07AM -0400, Andy Walls wrote:
> > On Tue, 2010-04-06 at 11:26 -0300, Mauro Carvalho Chehab wrote:
> > > I won't comment every single bits of the change, since we're more 
> > > interested on the conceptual
> > > aspects.
> > > 
> > > > -int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)
> > > 
> > > Don't remove the raw_event_store. It is needed by the hardware that gets events from
> > > IRQ/polling. For sure another interface is needed, for the cases where the hardware pass their
> > > own time measure, like cx18 (http://linuxtv.org/hg/~awalls/cx23885-ir2/rev/2cfef53b95a2).
> > > 
> > > For those, we need something like:
> > > 
> > > int ir_raw_event_time_store(struct input_dev *input_dev, enum raw_event_type type, u32 nsecs)
> > > 
> > > Where, instead of using ktime_get_ts(), it will use the timing provided by the hardware.
> > 
> > Just to clarify what Conexant hardware, and my current driver for it, is
> > capable of:
> > 
> > 1. It provides raw pulse (and space) width measurements.
> > 
> > 2. Those measurements can have very high resoltuion (~37 ns IIRC) or
> > very low resolution (usec or msec IIRC) depending on how the hardware
> > clock dividers are set up.
> > 
> > 3. The hardware provides a timeout when the measurment timer overflows,
> > meaning that no edge happened for a very long time.  This generates a
> > special "overflow" measurment value and a receiver timeout interrupt.
> > 
> > 4. The hardware has an 8 measurement deep FIFO, which the driver starts
> > to drain whenever it is half full (i.e. pulse measurement data is
> > delayed).  This happens in response to a hardware FIFO service request
> > interrupt.
> > 
> > 5. The hardware FIFO is drained by the driver whenever an interrupt is
> > received and the available measruement data is placed into a kfifo().
> > This will then signal a work handler that it has work to do.
> > 
> > 6. Measurements are scaled to standard time units (i.e. ns) by the
> > driver when they are read out of the kfifo() by a work handler.  (No
> > sense in doing time conversions in an interrupt handler).
> > 
> > 7. The work handler then begins passing whatever measurements it has,
> > one at a time, over to a pulse stream decoder.
> > 
> > 8. If the pulse stream decoder actually decodes something, it is passed
> > over to the input subsystem.
> > 
> > I suspect this device's behavior is much closer to what the MCE-USB
> > device does, than the raw GPIO handlers, but I don't really know the
> > MCE-USB.
> 
> This sounds very similar to winbond-cir (the hardware parts that is, 
> basically until and including item 5, line 1). The mceusb HW does 
> something similar...it sends usb packets with a couple of pulse/space 
> duration measurements (of 50us resolution IIRC)...and it automatically 
> enters an inactive state after 10000 us of silence.
> 
> The ir_raw_event_duration() function of my patch is intended for exactly 
> this kind of hardware (which I mentioned in my reply to Mauro which I 
> just sent out).
> 
> The question is though, is the kfifo and work handler really 
> necessary?

Yes.  I like to keep hard IRQ handler durations as short as possible. 

This CX2388[58] PCIe IRQ is raised not only for IR, but for the rest of
the bridge chip functions too.  The IR irq handling is just one of the
functions that may need service and video related functions are really
more important.

This Conexant IR hardware is used on the CX2388[58], CX23418,
CX2584[0123], and CX2310[123]. Right now I only have the driver
implemented for the CX23888 and a test implementation for the CX23885.
But I plan to have a somewhat common code base working for all the chips
eventually.  I think it is better to go with a slightly more complicated
handoff for reading IR pulses with a deferred work handler, than to
degrade the hard IRQ handler peformance for all of these drivers.  The
CX23418 is really a pain about it's IRQ handler timeline.


BTW, the ns unit of resolution we have in the kernel so far is likely
due to me.  I have hardware that can report measurements with a
resolution of (2 * 4)/108MHz = 74 ns, so I just settled on ns as the
basic time unit.  I think it's overkill too for existing protocols.  It
is however nice for measuring and characterizing noise in the
environment (something that an enduser will never need) or investigating
an unknown protocol.

Regards,
Andy


