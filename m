Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0DFO0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 10:26:39 -0400
Message-ID: <4BBB449B.3000207@infradead.org>
Date: Tue, 06 Apr 2010 11:26:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] Teach drivers/media/IR/ir-raw-event.c to use durations
References: <20100406104410.710253548@hardeman.nu> <20100406104811.GA6414@hardeman.nu>
In-Reply-To: <20100406104811.GA6414@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Tue, 6 Apr 2010 12:48:11 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline; filename=use-pulse-space-timings-in-ir-raw

Thunderbird 2 really don't like this. It considers the entire body as a file, and
refuses to quote it.

> drivers/media/IR/ir-raw-event.c is currently written with the assumption that
> all "raw" hardware will generate events only on state change (i.e. when
> a pulse or space starts).
> 
> However, some hardware (like mceusb, probably the most popular IR receiver
> out there) only generates duration data (and that data is buffered so using
> any kind of timing on the data is futile).

Am I understanding right and this hardware is not capable of indicating if the 
event is a pulse or a space? It seems hard to auto-detect what is pulse or space,
but IMO such code should belong to mceusb driver and not to the decoders.

Based on the code changes you did, I suspect that one of the things the hardware
provides is a "machine reset" state, right? If you just need to add a code to reset
the state machines, this could be done as easily as adding an event at kfifo with
IR_STOP_EVENT. A three line addition at the decoders event handler would be enough
to use it to reset the state machine:

	if (ev->type & IR_STOP_EVENT) {
		data->state = STATE_INACTIVE;
		return;
	}

This event were not added yet, since no hardware currently ported needs it. Eventually,
we may rename it to IR_RESET_STATE, if you think it is clearer.

> This patch (which is not tested since I haven't yet converted a driver for
> any of my hardware to ir-core yet, will do soon) is a RFC on my proposed
> interface change...once I get the green light on the interface change itself
> I'll make sure that the decoders actually work :)

Yes, better to discuss before changing everything ;)

> The rc5 decoder has also gained rc5x support and the use of kfifo's for
> intermediate storage is gone (since there is no need for it).

The RC-5X addition is welcome, but the better is to add it as a separate patch. 

I won't comment every single bits of the change, since we're more interested on the conceptual
aspects.

> -int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)

Don't remove the raw_event_store. It is needed by the hardware that gets events from
IRQ/polling. For sure another interface is needed, for the cases where the hardware pass their
own time measure, like cx18 (http://linuxtv.org/hg/~awalls/cx23885-ir2/rev/2cfef53b95a2).

For those, we need something like:

int ir_raw_event_time_store(struct input_dev *input_dev, enum raw_event_type type, u32 nsecs)

Where, instead of using ktime_get_ts(), it will use the timing provided by the hardware.

>  
> -int ir_raw_event_handle(struct input_dev *input_dev)
> +/**
> + * ir_raw_event_edge() - notify raw ir decoders of the start of a pulse/space
> + * @input_dev:	the struct input_dev device descriptor
> + * @type:	the type of the event that has occurred
> + *
> + * This routine is used to notify the raw ir decoders on the beginning of an
> + * ir pulse or space (or the start/end of ir reception). This is used by
> + * hardware which does not provide durations directly but only interrupts
> + * (or similar events) on state change.
> + */
> +void ir_raw_event_edge(struct input_dev *input_dev, enum raw_event_type type)
>  {
> -	struct ir_input_dev		*ir = input_get_drvdata(input_dev);
> -	int				rc;
> -	struct ir_raw_event		ev;
> -	int 				len, i;
> -
> -	/*
> -	 * Store the events into a temporary buffer. This allows calling more than
> -	 * one decoder to deal with the received data
> -	 */
> -	len = kfifo_len(&ir->raw->kfifo) / sizeof(ev);
> -	if (!len)
> -		return 0;

The removal of kfifo is not a good idea. On several drivers, the event is generated during
IRQ time, or on a very expensive polling loop. So, buffering is needed to release the
IRQ as soon as possible and not adding too much processing during polling.

> -
> -	for (i = 0; i < len; i++) {
> -		rc = kfifo_out(&ir->raw->kfifo, &ev, sizeof(ev));
> -		if (rc != sizeof(ev)) {
> -			IR_dprintk(1, "overflow error: received %d instead of %zd\n",
> -				   rc, sizeof(ev));
> -			return -EINVAL;
> -		}
> -		IR_dprintk(2, "event type %d, time before event: %07luus\n",
> -			ev.type, (ev.delta.tv_nsec + 500) / 1000);
> -		rc = RUN_DECODER(decode, input_dev, &ev);
> -	}
> +	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
> +	ktime_t			now;
> +	s64			delta; /* us */
> +
> +	if (!ir->raw)
> +		return;
>  
> -	/*
> -	 * Call all ir decoders. This allows decoding the same event with
> -	 * more than one protocol handler.
> -	 */
> +	now = ktime_get();
> +	delta = ktime_us_delta(now, ir->raw->last_event);


This won't work, in the cases where the hardware is providing its own timings.

>  
> -	return rc;
> +	/* Check for a long duration since last event or if we're
> +	   being called for the first time */
> +	if (delta > USEC_PER_SEC || !ir->raw->last_type)
> +		type |= IR_START_EVENT;

The "long duration" concept would be better implemented at the driver, since it may
vary with the IR carrier and with the protocol details.

> +
> +	if (type & IR_START_EVENT)
> +		ir_raw_event_reset(input_dev);
> +	else if (ir->raw->last_type & IR_SPACE)
> +		ir_raw_event_duration(input_dev, (int)-delta);
> +	else if (ir->raw->last_type & IR_PULSE)
> +		ir_raw_event_duration(input_dev, (int)delta);

Please, don't use a signal to identify between pulse and space. The IR decoding logic
is tricky enough. Just pass the type to the decoder and let it explicitly check if it is
pulse or space.


> Index: ir/drivers/media/IR/ir-nec-decoder.c
> ===================================================================
> --- ir.orig/drivers/media/IR/ir-nec-decoder.c	2010-04-06 12:16:27.000000000 +0200
> +++ ir/drivers/media/IR/ir-nec-decoder.c	2010-04-06 12:17:08.860846045 +0200
> @@ -14,22 +14,25 @@
>  
>  #include <media/ir-core.h>
>  
> +/*
> + * Regarding NEC_HEADER_MARK: some NEC remotes use 16, some 8,
> + * some receivers are also good at missing part of the first pulse.
> + */

The NEC decoder improvements should be on a separate patch.

>  #define NEC_NBITS		32
> -#define NEC_UNIT		559979 /* ns */
> -#define NEC_HEADER_MARK		(16 * NEC_UNIT)
> -#define NEC_HEADER_SPACE	(8 * NEC_UNIT)
> -#define NEC_REPEAT_SPACE	(4 * NEC_UNIT)
> -#define NEC_MARK		(NEC_UNIT)
> -#define NEC_0_SPACE		(NEC_UNIT)
> -#define NEC_1_SPACE		(3 * NEC_UNIT)
> +#define NEC_UNIT		562	/* us */

Why changing to microseconds? ktime_t also handles time on nanosseconds.

> +#define NEC_HEADER_MARK		6
> +#define NEC_HEADER_SPACE	-8
> +#define NEC_REPEAT_SPACE	-4
> +#define NEC_MARK		1
> +#define NEC_0_SPACE		-1
> +#define NEC_1_SPACE		-3

Those negative values here is really weird... I can't stop thinking on time 
travels, when I see a negative time ;)

Seriously, this change obfuscates the logic, as it is using the mantissa of a number
to indicate a time duration, and the signal to indicate the presence or absence of
a carrier. Encoding two different measures into a number is not a good thing. I used
to do such tricks when programming in Z80 assembly, back on eighties, basically
due to the absolute lack of enough memory on those machines with a few kilobytes of RAM.
After a few weeks, returning back to the same code to fix were really hard. We don't have
such memory constraints anymore. So, let's keep the code as clearer as possible.

-

I've stripped the decoders code, since they're basically implementing the architectural
changes you're proposing Let's first finish the discussions about the changes.

Btw, I noticed that you've added some improvements to the decoders, like the
changes to support RC-5X. The better is to send it as a separate patch, due to a few reasons:

	- RC-5X addition has nothing to do with "Teach drivers/media/IR/ir-raw-event.c
to use durations" (the subject of this RFC patch);

	- Bigger patches have more chances of getting nacked, since they touch on more parts
of the code. So, you'll need to rework more code;

	- The addition of RC-5X shouldn't break RC-5. By having it as a separate patch,
it is easier to test the changes;

	- If later discovered a regression, it would be easier to bisect and see if the
changes were introduced by RC-5X or by the architectural changes, if the changes are broken
into two patches.

> -static unsigned int ir_rc5_remote_gap = 888888;

The idea of static int is that, on saa7134, this value can be adjustable from userspace.
probably, some hardware use a non-standard carrier, so we'll need to export it also
via sysfs, to avoid regressions.

-- 
Cheers,
Mauro
