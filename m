Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43738 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449Ab0DGKTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 06:19:49 -0400
Subject: Re: [RFC] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <4BBB449B.3000207@infradead.org>
References: <20100406104410.710253548@hardeman.nu>
	 <20100406104811.GA6414@hardeman.nu>  <4BBB449B.3000207@infradead.org>
Content-Type: text/plain
Date: Wed, 07 Apr 2010 06:20:07 -0400
Message-Id: <1270635607.3021.222.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-04-06 at 11:26 -0300, Mauro Carvalho Chehab wrote:
> Hi David,
> 

> I won't comment every single bits of the change, since we're more interested on the conceptual
> aspects.
> 
> > -int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)
> 
> Don't remove the raw_event_store. It is needed by the hardware that gets events from
> IRQ/polling. For sure another interface is needed, for the cases where the hardware pass their
> own time measure, like cx18 (http://linuxtv.org/hg/~awalls/cx23885-ir2/rev/2cfef53b95a2).
> 
> For those, we need something like:
> 
> int ir_raw_event_time_store(struct input_dev *input_dev, enum raw_event_type type, u32 nsecs)
> 
> Where, instead of using ktime_get_ts(), it will use the timing provided by the hardware.

Just to clarify what Conexant hardware, and my current driver for it, is
capable of:

1. It provides raw pulse (and space) width measurements.

2. Those measurements can have very high resoltuion (~37 ns IIRC) or
very low resolution (usec or msec IIRC) depending on how the hardware
clock dividers are set up.

3. The hardware provides a timeout when the measurment timer overflows,
meaning that no edge happened for a very long time.  This generates a
special "overflow" measurment value and a receiver timeout interrupt.

4. The hardware has an 8 measurement deep FIFO, which the driver starts
to drain whenever it is half full (i.e. pulse measurement data is
delayed).  This happens in response to a hardware FIFO service request
interrupt.

5. The hardware FIFO is drained by the driver whenever an interrupt is
received and the available measruement data is placed into a kfifo().
This will then signal a work handler that it has work to do.

6. Measurements are scaled to standard time units (i.e. ns) by the
driver when they are read out of the kfifo() by a work handler.  (No
sense in doing time conversions in an interrupt handler).

7. The work handler then begins passing whatever measurements it has,
one at a time, over to a pulse stream decoder.

8. If the pulse stream decoder actually decodes something, it is passed
over to the input subsystem.

I suspect this device's behavior is much closer to what the MCE-USB
device does, than the raw GPIO handlers, but I don't really know the
MCE-USB.

Regards,
Andy

