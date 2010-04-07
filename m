Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:62779 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab0DGNLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 09:11:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100407114234.GA3476@hardeman.nu>
References: <20100406104410.710253548@hardeman.nu>
	 <20100406104811.GA6414@hardeman.nu> <4BBB449B.3000207@infradead.org>
	 <1270635607.3021.222.camel@palomino.walls.org>
	 <20100407114234.GA3476@hardeman.nu>
Date: Wed, 7 Apr 2010 09:11:51 -0400
Message-ID: <j2g9e4733911004070611je836445apb6527b4e2d8137fb@mail.gmail.com>
Subject: Re: [RFC] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Jon Smirl <jonsmirl@gmail.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I had to rework this portion of code several times in the IR code I posted.

I had the core provide input_ir_queue() which was legal to call from
interrupt context. Calling from interrupt context was an important
aspect I missed in the first versions. I made this a common routine so
that the code didn't get copied into all of the drivers. This code
should have used kfifo but I didn't know about kfifo.

>>The question is though, is the kfifo and work handler really
necessary?

Yes, otherwise it will get duplicated into all of the drivers that run
in interrupt context like this GPIO one. Put this common code into the
core so that the individual drivers writers don't mess it up.

void input_ir_queue(struct input_dev *dev, int sample)
{
	unsigned int next;

	spin_lock(dev->ir->queue.lock);
	dev->ir->queue.samples[dev->ir->queue.head] = sample;
	next = dev->ir->queue.head + 1;
	dev->ir->queue.head = (next >= MAX_SAMPLES ? 0 : next);
	spin_unlock(dev->ir->queue.lock);

	schedule_work(&dev->ir->work);
}

My GPIO implementation simply call input_it_queue() with the timing
data. I collapsed multiple long space interrupts into one very long
space. If you are using protocol engines, there is no need to detect
the long trailing space. The protocol engine will trigger on the last
pulse of the signal.

On the other hand, LIRC in user space needs the last long space to
know when to flush the buffer from kernel space into user space. The
timeout for this flush should be implemented in the LIRC compatibility
driver, not ir-core. In this case my GPIO driver doesn't ever generate
an event for the long space at the end of the message (because it
doesn't end). Instead the LIRC compatibility layer should start a
timer and flush when no data has been received for 200ms or whatever.

static irqreturn_t dpeak_ir_irq(int irq, void *_ir)
{
	struct ir_gpt *ir_gpt = _ir;
	int sample, count, delta, bit, wrap;

	sample = in_be32(&ir_gpt->regs->status);
	out_be32(&ir_gpt->regs->status, 0xF);

	count = sample >> 16;
	wrap = (sample >> 12) & 7;
	bit = (sample >> 8) & 1;

	delta = count - ir_gpt->previous;
	delta += wrap * 0x10000;

	ir_gpt->previous = count;

	if (bit)
		delta = -delta;

	input_ir_queue(ir_gpt->input, delta);

	return IRQ_HANDLED;
}

For MSMCE I converted their format back into simple delays and fed it
into input_ir_queue(). This was not done in interrupt context because
of the way USB works. input_ir_queue() doesn't care - it works
correctly when called from either context.

				if (ir->last.command == 0x80) {
					bit = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
					delta = (ir->buf_in[i] & MCE_PULSE_MASK) * MCE_TIME_BASE;

					if ((ir->buf_in[i] & MCE_PULSE_MASK) == 0x7f) {
						if (ir->last.bit == bit)
							ir->last.delta += delta;
						else {
							ir->last.delta = delta;
							ir->last.bit = bit;
						}
						continue;
					}
					delta += ir->last.delta;
					ir->last.delta = 0;
					ir->last.bit = bit;

					dev_dbg(&ir->usbdev->dev, "bit %d delta %d\n", bit, delta);
					if (bit)
						delta = -delta;

					input_ir_queue(ir->input, delta);
				}

These delay messages are then fed into the protocol engines which
process the pulses in parallel. Processing in parallel works, because
that's how IR receivers work. When you shine a remote on an equipment
rack, all of the equipment sees the command in parallel. The protocols
are designed so that parallel decode works properly.

-- 
Jon Smirl
jonsmirl@gmail.com
