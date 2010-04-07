Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:41160 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0DGLJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 07:09:14 -0400
Date: Wed, 7 Apr 2010 13:09:08 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	jarod@wilsonet.com, jonsmirl@gmail.com
Subject: Re: [RFC] Teach drivers/media/IR/ir-raw-event.c to use durations
Message-ID: <20100407110908.GC3029@hardeman.nu>
References: <20100406104410.710253548@hardeman.nu>
 <20100406104811.GA6414@hardeman.nu>
 <4BBB449B.3000207@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BBB449B.3000207@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 06, 2010 at 11:26:35AM -0300, Mauro Carvalho Chehab wrote:
> Hi David,
> 
> Em Tue, 6 Apr 2010 12:48:11 +0200
> David Härdeman <david@hardeman.nu> escreveu:
> 
> > Content-Type: text/plain; charset=us-ascii
> > Content-Disposition: inline; filename=use-pulse-space-timings-in-ir-raw
> 
> Thunderbird 2 really don't like this. It considers the entire body as a file, and
> refuses to quote it.

Never had people complain when I use quilt before but I'll see what I 
can do.

> > drivers/media/IR/ir-raw-event.c is currently written with the assumption that
> > all "raw" hardware will generate events only on state change (i.e. when
> > a pulse or space starts).
> > 
> > However, some hardware (like mceusb, probably the most popular IR receiver
> > out there) only generates duration data (and that data is buffered so using
> > any kind of timing on the data is futile).
> 
> Am I understanding right and this hardware is not capable of indicating if the 
> event is a pulse or a space? It seems hard to auto-detect what is pulse or space,
> but IMO such code should belong to mceusb driver and not to the decoders.

No, the driver for mceusb sends a usb packet which contains a couple of 
pulse/space durations in the form of signed integers representing pulse 
(positive) and space (negative) durations in microseconds. It's a pretty 
common arrangement. winbond-cir also has a mode (which is the one I'm 
planning on using in the future) where pulse/space durations are 
accumulated in the UART buffer and an IRQ is generated once the buffer 
level reaches a threshold.

> Based on the code changes you did, I suspect that one of the things the hardware
> provides is a "machine reset" state, right? If you just need to add a code to reset
> the state machines, this could be done as easily as adding an event at kfifo with
> IR_STOP_EVENT. A three line addition at the decoders event handler would be enough
> to use it to reset the state machine:
> 
> 	if (ev->type & IR_STOP_EVENT) {
> 		data->state = STATE_INACTIVE;
> 		return;
> 	}
> 
> This event were not added yet, since no hardware currently ported needs it. Eventually,
> we may rename it to IR_RESET_STATE, if you think it is clearer.

Not a particular state per se, I just added a function which the 
hardware can use to reset the state machines when necessary (think 
hardware reset, suspend/resume, switching from RX to TX and back again, 
etc).

I think this:

	/* Hardware has been reset, notify ir-core */
	ir_raw_event_reset(input_dev);

is a hell lot clearer than this (your current code):

	/* Hardware has been reset, notify ir-core */
	rc = ir_raw_event_store(input_dev, IR_STOP_EVENT);
	if (rc) {
		/* Uh oh, what do we do now? */
		...
	}
	rc = ir_raw_event_handle(input_dev);
	if (rc) {
		/* Not again... */
		...
	}

> > This patch (which is not tested since I haven't yet converted a 
> > driver for
> > any of my hardware to ir-core yet, will do soon) is a RFC on my proposed
> > interface change...once I get the green light on the interface change itself
> > I'll make sure that the decoders actually work :)
> 
> Yes, better to discuss before changing everything ;)
>
> > The rc5 decoder has also gained rc5x support and the use of kfifo's 
> > for
> > intermediate storage is gone (since there is no need for it).
> 
> The RC-5X addition is welcome, but the better is to add it as a separate patch. 

Using durations (instead of a combination of struct timespec and enum 
raw_event_type) as the argument to the decoder necessitates rewriting 
most of the decoders, so it seemed like a good time to add it. RC5X or 
not will anyway only mean a couple of lines of difference but I can send 
it as a separate patch if that helps you.
 
> I won't comment every single bits of the change, since we're more interested on the conceptual
> aspects.
> 
> > -int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)
> 
> Don't remove the raw_event_store. It is needed by the hardware that gets events from
> IRQ/polling.

See the comments for kfifo below.

> For sure another interface is needed, for the cases where the hardware 
> pass their
> own time measure, like cx18 (http://linuxtv.org/hg/~awalls/cx23885-ir2/rev/2cfef53b95a2).
> 
> For those, we need something like:
> 
> int ir_raw_event_time_store(struct input_dev *input_dev, enum raw_event_type type, u32 nsecs)
> 
> Where, instead of using ktime_get_ts(), it will use the timing provided by the hardware.

Um, this sounds exactly like ir_raw_event_duration() which was the main 
point of my patch.
 
> >  
> > -int ir_raw_event_handle(struct input_dev *input_dev)
> > +/**
> > + * ir_raw_event_edge() - notify raw ir decoders of the start of a pulse/space
> > + * @input_dev:	the struct input_dev device descriptor
> > + * @type:	the type of the event that has occurred
> > + *
> > + * This routine is used to notify the raw ir decoders on the beginning of an
> > + * ir pulse or space (or the start/end of ir reception). This is used by
> > + * hardware which does not provide durations directly but only interrupts
> > + * (or similar events) on state change.
> > + */
> > +void ir_raw_event_edge(struct input_dev *input_dev, enum raw_event_type type)
> >  {
> > -	struct ir_input_dev		*ir = input_get_drvdata(input_dev);
> > -	int				rc;
> > -	struct ir_raw_event		ev;
> > -	int 				len, i;
> > -
> > -	/*
> > -	 * Store the events into a temporary buffer. This allows calling more than
> > -	 * one decoder to deal with the received data
> > -	 */
> > -	len = kfifo_len(&ir->raw->kfifo) / sizeof(ev);
> > -	if (!len)
> > -		return 0;
> 
> The removal of kfifo is not a good idea. On several drivers, the event is generated during
> IRQ time, or on a very expensive polling loop. So, buffering is needed to release the
> IRQ as soon as possible and not adding too much processing during polling.

Have you seen any real case where this is a problem or is this just 
conjecture on your behalf? I've written ir decoders for embedded 
hardware which pass the "event" (duration) through the state machines 
directly and it works great on hardware with a fraction of the computing 
power compared to the machines you're using.

The state machines shouldn't have to do much more than rounding of the 
duration followed by a couple of integer comparisons (and possibly some 
bitops). I fail to see how using a kfifo would provide any real 
improvement.
 
> > -
> > -	for (i = 0; i < len; i++) {
> > -		rc = kfifo_out(&ir->raw->kfifo, &ev, sizeof(ev));
> > -		if (rc != sizeof(ev)) {
> > -			IR_dprintk(1, "overflow error: received %d instead of %zd\n",
> > -				   rc, sizeof(ev));
> > -			return -EINVAL;
> > -		}
> > -		IR_dprintk(2, "event type %d, time before event: %07luus\n",
> > -			ev.type, (ev.delta.tv_nsec + 500) / 1000);
> > -		rc = RUN_DECODER(decode, input_dev, &ev);
> > -	}
> > +	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
> > +	ktime_t			now;
> > +	s64			delta; /* us */
> > +
> > +	if (!ir->raw)
> > +		return;
> >  
> > -	/*
> > -	 * Call all ir decoders. This allows decoding the same event with
> > -	 * more than one protocol handler.
> > -	 */
> > +	now = ktime_get();
> > +	delta = ktime_us_delta(now, ir->raw->last_event);
> 
> 
> This won't work, in the cases where the hardware is providing its own 
> timings.

Again, see ir_raw_event_duration()
 
> >  
> > -	return rc;
> > +	/* Check for a long duration since last event or if we're
> > +	   being called for the first time */
> > +	if (delta > USEC_PER_SEC || !ir->raw->last_type)
> > +		type |= IR_START_EVENT;
> 
> The "long duration" concept would be better implemented at the driver, since it may
> vary with the IR carrier and with the protocol details.

Now you're criticizing your own code...this was one of the few concepts 
I carried over from your original code. Specifically, ir-raw-event.c, 
lines 116 - 129 from your current tree:

	ktime_get_ts(&ts);

	if (timespec_equal(&ir->raw->last_event, &event.delta))
		event.type |= IR_START_EVENT;
	else
		event.delta = timespec_sub(ts, ir->raw->last_event);

	memcpy(&ir->raw->last_event, &ts, sizeof(ts));

	if (event.delta.tv_sec) {
		event.type |= IR_START_EVENT;
		event.delta.tv_sec = 0;
		event.delta.tv_nsec = 0;
	}

(Note the check on event.delta.tv_sec)

> > +
> > +	if (type & IR_START_EVENT)
> > +		ir_raw_event_reset(input_dev);
> > +	else if (ir->raw->last_type & IR_SPACE)
> > +		ir_raw_event_duration(input_dev, (int)-delta);
> > +	else if (ir->raw->last_type & IR_PULSE)
> > +		ir_raw_event_duration(input_dev, (int)delta);
> 
> Please, don't use a signal to identify between pulse and space. The IR decoding logic
> is tricky enough. Just pass the type to the decoder and let it explicitly check if it is
> pulse or space.

No idea what you mean here. Why would it be clearer to put the 
equivalent code in every single decoder instead of adding it once to the 
place which calls the decoders?
 
> > Index: ir/drivers/media/IR/ir-nec-decoder.c
> > ===================================================================
> > --- ir.orig/drivers/media/IR/ir-nec-decoder.c	2010-04-06 12:16:27.000000000 +0200
> > +++ ir/drivers/media/IR/ir-nec-decoder.c	2010-04-06 12:17:08.860846045 +0200
> > @@ -14,22 +14,25 @@
> >  
> >  #include <media/ir-core.h>
> >  
> > +/*
> > + * Regarding NEC_HEADER_MARK: some NEC remotes use 16, some 8,
> > + * some receivers are also good at missing part of the first pulse.
> > + */
> 
> The NEC decoder improvements should be on a separate patch.

They can't since the entire patch is about changing the core raw logic 
over to primarily use durations, which means the existing nec and rc5 
decoders need to change in the same patch or bisectability will be 
broken.
 
> >  #define NEC_NBITS		32
> > -#define NEC_UNIT		559979 /* ns */
> > -#define NEC_HEADER_MARK		(16 * NEC_UNIT)
> > -#define NEC_HEADER_SPACE	(8 * NEC_UNIT)
> > -#define NEC_REPEAT_SPACE	(4 * NEC_UNIT)
> > -#define NEC_MARK		(NEC_UNIT)
> > -#define NEC_0_SPACE		(NEC_UNIT)
> > -#define NEC_1_SPACE		(3 * NEC_UNIT)
> > +#define NEC_UNIT		562	/* us */
> 
> Why changing to microseconds? ktime_t also handles time on nanosseconds.

Interesting question but you managed to turn it on its head. Why not use 
femtoseconds? Because it's complete and utter overkill. Not a single IR 
protocol needs that kind of precision. Both LIRC and the Microsoft IR 
API's are based on microseconds. Programmable IR hardware (like the 
Philips Pronto) is based on microseconds. The proper question to ask is 
why you'd use nanoseconds...

> > +#define NEC_HEADER_MARK		6
> > +#define NEC_HEADER_SPACE	-8
> > +#define NEC_REPEAT_SPACE	-4
> > +#define NEC_MARK		1
> > +#define NEC_0_SPACE		-1
> > +#define NEC_1_SPACE		-3
> 
> Those negative values here is really weird... I can't stop thinking on time 
> travels, when I see a negative time ;)

Better get used to it, if you're going to maintain ir-core you're going 
to see it in mailing list discussions once ir-core gains a userbase.

> Seriously, this change obfuscates the logic, as it is using the mantissa of a number
> to indicate a time duration, and the signal to indicate the presence or absence of
> a carrier. Encoding two different measures into a number is not a good thing. I used
> to do such tricks when programming in Z80 assembly, back on eighties, basically
> due to the absolute lack of enough memory on those machines with a few kilobytes of RAM.
> After a few weeks, returning back to the same code to fix were really hard. We don't have
> such memory constraints anymore. So, let's keep the code as clearer as possible.

Describing a received ir signal as a number of signed integers 
describing the duration of pulses (positive) and spaces (negative) in 
microseconds is pretty much standard (to the extent that any standard 
exists) in any discussion of IR protocols.

The decoders Jon Smirl implemented used signed integers, the decoders 
I've implemented use signed integers. Microsoft's IR API uses signed 
integers. LIRC uses signed integers (kinda, 23 bits of microsecond 
duration, one bit for pulse or space - as far as I can remember from 
LIRC_MODE_MODE2). Other projects also use it (e.g. the developers of 
decodeir.dll which is probably one of the most used IR API's on the MS 
platform outside of Microsoft's own API).

Instead you want to go with a model where you pass in total three 
arguments to the decoders (struct timespec with nsec and sec + enum 
type). I do not understand how you would consider this clearer or 
better.

> I've stripped the decoders code, since they're basically implementing 
> the architectural
> changes you're proposing Let's first finish the discussions about the changes.
> 
> Btw, I noticed that you've added some improvements to the decoders, like the
> changes to support RC-5X. The better is to send it as a separate patch, due to a few reasons:
> 
> 	- RC-5X addition has nothing to do with "Teach drivers/media/IR/ir-raw-event.c
> to use durations" (the subject of this RFC patch);
> 
> 	- Bigger patches have more chances of getting nacked, since they touch on more parts
> of the code. So, you'll need to rework more code;
> 
> 	- The addition of RC-5X shouldn't break RC-5. By having it as a separate patch,
> it is easier to test the changes;
> 
> 	- If later discovered a regression, it would be easier to bisect and see if the
> changes were introduced by RC-5X or by the architectural changes, if the changes are broken
> into two patches.
> 

I've already addressed RC5X above.

> > -static unsigned int ir_rc5_remote_gap = 888888;
> 
> The idea of static int is that, on saa7134, this value can be adjustable from userspace.
> probably, some hardware use a non-standard carrier, so we'll need to export it also
> via sysfs, to avoid regressions.

The decoders in my patch have a +/-50% tolerance for pulse/space unit 
durations, if it turns out to be insufficient, then it's time to look at 
solutions, doing it now is premature.

-- 
David Härdeman
