Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45607 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757327Ab0DHAnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 20:43:47 -0400
Subject: Re: [RFC2] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Andy Walls <awalls@md.metrocast.net>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <20100407201835.GA8438@hardeman.nu>
References: <20100407201835.GA8438@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 20:44:03 -0400
Message-Id: <1270687443.3798.49.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-04-07 at 22:18 +0200, David Härdeman wrote:
> drivers/media/IR/ir-raw-event.c is currently written with the assumption 
> that all "raw" hardware will generate events only on state change (i.e.  
> when a pulse or space starts).
> 
> However, some hardware (like mceusb, probably the most popular IR receiver
> out there) only generates duration data (and that data is buffered so using
> any kind of timing on the data is futile).
> 
> Furthermore, using signed int's to represent pulse/space durations in ms
> is a well-known approach to anyone with experience in writing ir decoders.
> 
> This patch (which has been tested this time) is still a RFC on my proposed
> interface changes.
> 
> Changes since last version:
> 
> o RC5x and NECx support no longer added in patch (separate patches to follow)
> 
> o The use of a kfifo has been left given feedback from Jon, Andy, Mauro
> 
> o The RX decoding is now handled via a workqueue (I can break that up into a
>   separate patch later, but I think it helps the discussion to have it in for
>   now), with inspiration from Andy's code.

I haven't looked at your patches yet (sorry, busy month for me), but I'd
like to explain my motivation for a workqueue and you can see if the
rationale fits here:


I did the heavy lifting for IR Rx from integrated IR controllers in a
workqueue to keep hard IRQ handlers for video bridge chips as short as
possible.  Getting the hard IRQ handler done in the minimum amount of
time and PCI MMIO cycles was the objective.

Video buffer DMA done IRQ's a much more improtant than dawdling with IR.
The work queue can take as long as it needs to decode IR pulses (convert
timebase, parallel decode, or FFT for all I cared) and generate an input
keypress. :)

Regards,
Andy



> o Separate reset operations are no longer added to decoders, a duration of
>   zero is instead used to signal a reset (which allows the reset request to
>   be inserted into the kfifo).
> 
> o Not sent using quilt...Mauro, does it still trip up your MUA?
> 
> Not changed:
> 
> o int's are still used to represent pulse/space durations in ms. Mauro and I
>   seem to disagree on this one but I'm right :)
> 
> Index: ir/drivers/media/IR/ir-raw-event.c
> ===================================================================
> --- ir.orig/drivers/media/IR/ir-raw-event.c	2010-04-06 12:16:27.000000000 +0200
> +++ ir/drivers/media/IR/ir-raw-event.c	2010-04-07 21:32:13.961850481 +0200
> @@ -15,13 +15,14 @@
>  #include <media/ir-core.h>
>  #include <linux/workqueue.h>
>  #include <linux/spinlock.h>
> +#include <linux/sched.h>
>  
>  /* Define the max number of bit transitions per IR keycode */
>  #define MAX_IR_EVENT_SIZE	256
>  
>  /* Used to handle IR raw handler extensions */
>  static LIST_HEAD(ir_raw_handler_list);
> -static spinlock_t ir_raw_handler_lock;
> +static DEFINE_SPINLOCK(ir_raw_handler_lock);
>  
>  /**
>   * RUN_DECODER()	- runs an operation on all IR decoders
> @@ -53,19 +54,30 @@
>  /* Used to load the decoders */
>  static struct work_struct wq_load;
>  
> +static void ir_raw_event_work(struct work_struct *work)
> +{
> +	int d;
> +	struct ir_raw_event_ctrl *raw =
> +		container_of(work, struct ir_raw_event_ctrl, rx_work);
> +
> +	while (kfifo_out(&raw->kfifo, &d, sizeof(d)) == sizeof(d))
> +		RUN_DECODER(decode, raw->input_dev, d);
> +}
> +
>  int ir_raw_event_register(struct input_dev *input_dev)
>  {
>  	struct ir_input_dev *ir = input_get_drvdata(input_dev);
> -	int rc, size;
> +	int rc;
>  
>  	ir->raw = kzalloc(sizeof(*ir->raw), GFP_KERNEL);
>  	if (!ir->raw)
>  		return -ENOMEM;
>  
> -	size = sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE * 2;
> -	size = roundup_pow_of_two(size);
> +	ir->raw->input_dev = input_dev;
> +	INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
>  
> -	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
> +	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(int) * MAX_IR_EVENT_SIZE,
> +			 GFP_KERNEL);
>  	if (rc < 0) {
>  		kfree(ir->raw);
>  		ir->raw = NULL;
> @@ -91,6 +103,7 @@
>  	if (!ir->raw)
>  		return;
>  
> +	cancel_work_sync(&ir->raw->rx_work);
>  	RUN_DECODER(raw_unregister, input_dev);
>  
>  	kfifo_free(&ir->raw->kfifo);
> @@ -99,74 +112,85 @@
>  }
>  EXPORT_SYMBOL_GPL(ir_raw_event_unregister);
>  
> -int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)
> +/**
> + * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
> + * @input_dev:	the struct input_dev device descriptor
> + * @duration:	duration of the pulse or space
> + *
> + * This routine passes a pulse/space duration to the raw ir decoding state
> + * machines. Pulses are signalled as positive values and spaces as negative
> + * values. A zero value will reset the decoding state machines.
> + */
> +int ir_raw_event_store(struct input_dev *input_dev, int duration)
>  {
> -	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
> -	struct timespec		ts;
> -	struct ir_raw_event	event;
> -	int			rc;
> +	struct ir_input_dev *ir = input_get_drvdata(input_dev);
>  
>  	if (!ir->raw)
>  		return -EINVAL;
>  
> -	event.type = type;
> -	event.delta.tv_sec = 0;
> -	event.delta.tv_nsec = 0;
> +	if (kfifo_in(&ir->raw->kfifo, &duration, sizeof(duration)) != sizeof(duration))
> +		return -ENOMEM;
>  
> -	ktime_get_ts(&ts);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ir_raw_event_store);
>  
> -	if (timespec_equal(&ir->raw->last_event, &event.delta))
> -		event.type |= IR_START_EVENT;
> -	else
> -		event.delta = timespec_sub(ts, ir->raw->last_event);
> +/**
> + * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
> + * @input_dev:	the struct input_dev device descriptor
> + * @type:	the type of the event that has occurred
> + *
> + * This routine is used to notify the raw ir decoders on the beginning of an
> + * ir pulse or space (or the start/end of ir reception). This is used by
> + * hardware which does not provide durations directly but only interrupts
> + * (or similar events) on state change.
> + */
> +int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type)
> +{
> +	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
> +	ktime_t			now;
> +	s64			delta; /* us */
> +	int			rc = 0;
>  
> -	memcpy(&ir->raw->last_event, &ts, sizeof(ts));
> +	if (!ir->raw)
> +		return -EINVAL;
>  
> -	if (event.delta.tv_sec) {
> -		event.type |= IR_START_EVENT;
> -		event.delta.tv_sec = 0;
> -		event.delta.tv_nsec = 0;
> -	}
> +	now = ktime_get();
> +	delta = ktime_us_delta(now, ir->raw->last_event);
>  
> -	kfifo_in(&ir->raw->kfifo, &event, sizeof(event));
> +	/* Are we called for the first time? */
> +	if (!ir->raw->last_type)
> +		type |= IR_START_EVENT;
> +
> +	if (type & IR_START_EVENT)
> +		ir_raw_event_reset(input_dev);
> +	else if (ir->raw->last_type & IR_SPACE)
> +		rc = ir_raw_event_store(input_dev, (int)-delta);
> +	else if (ir->raw->last_type & IR_PULSE)
> +		rc = ir_raw_event_store(input_dev, (int)delta);
> +	else
> +		return 0;
>  
> +	ir->raw->last_event = now;
> +	ir->raw->last_type = type;
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(ir_raw_event_store);
> +EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
>  
> -int ir_raw_event_handle(struct input_dev *input_dev)
> +/**
> + * ir_raw_event_handle() - schedules the decoding of stored ir data
> + * @input_dev:	the struct input_dev device descriptor
> + *
> + * This routine will signal the workqueue to start decoding stored ir data.
> + */
> +void ir_raw_event_handle(struct input_dev *input_dev)
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
> +	struct ir_input_dev *ir = input_get_drvdata(input_dev);
>  
> -	/*
> -	 * Call all ir decoders. This allows decoding the same event with
> -	 * more than one protocol handler.
> -	 */
> +	if (!ir->raw)
> +		return;
>  
> -	return rc;
> +	schedule_work(&ir->raw->rx_work);
>  }
>  EXPORT_SYMBOL_GPL(ir_raw_event_handle);
>  
> @@ -205,8 +229,6 @@
>  
>  void ir_raw_init(void)
>  {
> -	spin_lock_init(&ir_raw_handler_lock);
> -
>  #ifdef MODULE
>  	INIT_WORK(&wq_load, init_decoders);
>  	schedule_work(&wq_load);
> Index: ir/include/media/ir-core.h
> ===================================================================
> --- ir.orig/include/media/ir-core.h	2010-04-06 12:16:27.000000000 +0200
> +++ ir/include/media/ir-core.h	2010-04-07 18:17:53.524850074 +0200
> @@ -57,14 +57,12 @@
>  	void		(*close)(void *priv);
>  };
>  
> -struct ir_raw_event {
> -	struct timespec		delta;	/* Time spent before event */
> -	enum raw_event_type	type;	/* event type */
> -};
> -
>  struct ir_raw_event_ctrl {
> -	struct kfifo			kfifo;		/* fifo for the pulse/space events */
> -	struct timespec			last_event;	/* when last event occurred */
> +	struct work_struct		rx_work;	/* for the rx decoding workqueue */
> +	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
> +	ktime_t				last_event;	/* when last event occurred */
> +	enum raw_event_type		last_type;	/* last event type */
> +	struct input_dev		*input_dev;	/* pointer to the parent input_dev */
>  };
>  
>  struct ir_input_dev {
> @@ -89,8 +87,7 @@
>  struct ir_raw_handler {
>  	struct list_head list;
>  
> -	int (*decode)(struct input_dev *input_dev,
> -		      struct ir_raw_event *ev);
> +	int (*decode)(struct input_dev *input_dev, int duration);
>  	int (*raw_register)(struct input_dev *input_dev);
>  	int (*raw_unregister)(struct input_dev *input_dev);
>  };
> @@ -146,8 +143,13 @@
>  /* Routines from ir-raw-event.c */
>  int ir_raw_event_register(struct input_dev *input_dev);
>  void ir_raw_event_unregister(struct input_dev *input_dev);
> -int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type);
> -int ir_raw_event_handle(struct input_dev *input_dev);
> +void ir_raw_event_handle(struct input_dev *input_dev);
> +int ir_raw_event_store(struct input_dev *input_dev, int duration);
> +int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
> +static inline void ir_raw_event_reset(struct input_dev *dev) {
> +	ir_raw_event_store(input_dev, 0);
> +	ir_raw_event_handle(input_dev);
> +}
>  int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
>  void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
>  void ir_raw_init(void);
> Index: ir/drivers/media/IR/ir-nec-decoder.c
> ===================================================================
> --- ir.orig/drivers/media/IR/ir-nec-decoder.c	2010-04-06 12:16:27.000000000 +0200
> +++ ir/drivers/media/IR/ir-nec-decoder.c	2010-04-07 18:32:10.892853025 +0200
> @@ -13,23 +13,23 @@
>   */
>  
>  #include <media/ir-core.h>
> +#include <linux/bitrev.h>
>  
>  #define NEC_NBITS		32
> -#define NEC_UNIT		559979 /* ns */
> -#define NEC_HEADER_MARK		(16 * NEC_UNIT)
> -#define NEC_HEADER_SPACE	(8 * NEC_UNIT)
> -#define NEC_REPEAT_SPACE	(4 * NEC_UNIT)
> -#define NEC_MARK		(NEC_UNIT)
> -#define NEC_0_SPACE		(NEC_UNIT)
> -#define NEC_1_SPACE		(3 * NEC_UNIT)
> +#define NEC_UNIT		562	/* us */
> +#define NEC_HEADER_MARK		16
> +#define NEC_HEADER_SPACE	-8
> +#define NEC_REPEAT_SPACE	-4
> +#define NEC_MARK		1
> +#define NEC_0_SPACE		-1
> +#define NEC_1_SPACE		-3
>  
>  /* Used to register nec_decoder clients */
>  static LIST_HEAD(decoder_list);
> -static spinlock_t decoder_lock;
> +static DEFINE_SPINLOCK(decoder_lock);
>  
>  enum nec_state {
>  	STATE_INACTIVE,
> -	STATE_HEADER_MARK,
>  	STATE_HEADER_SPACE,
>  	STATE_MARK,
>  	STATE_SPACE,
> @@ -37,13 +37,6 @@
>  	STATE_TRAILER_SPACE,
>  };
>  
> -struct nec_code {
> -	u8	address;
> -	u8	not_address;
> -	u8	command;
> -	u8	not_command;
> -};
> -
>  struct decoder_data {
>  	struct list_head	list;
>  	struct ir_input_dev	*ir_dev;
> @@ -51,7 +44,7 @@
>  
>  	/* State machine control */
>  	enum nec_state		state;
> -	struct nec_code		nec_code;
> +	u32			nec_bits;
>  	unsigned		count;
>  };
>  
> @@ -62,7 +55,6 @@
>   *
>   * Returns the struct decoder_data that corresponds to a device
>   */
> -
>  static struct decoder_data *get_decoder_data(struct  ir_input_dev *ir_dev)
>  {
>  	struct decoder_data *data = NULL;
> @@ -123,20 +115,20 @@
>  	.attrs	= decoder_attributes,
>  };
>  
> -
>  /**
>   * ir_nec_decode() - Decode one NEC pulse or space
>   * @input_dev:	the struct input_dev descriptor of the device
> - * @ev:		event array with type/duration of pulse/space
> + * @duration:	duration in us of pulse/space
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_nec_decode(struct input_dev *input_dev,
> -			 struct ir_raw_event *ev)
> +static int ir_nec_decode(struct input_dev *input_dev, int duration)
>  {
>  	struct decoder_data *data;
>  	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
> -	int bit, last_bit;
> +	int d;
> +	u32 scancode;
> +	u8 address, not_address, command, not_command;
>  
>  	data = get_decoder_data(ir_dev);
>  	if (!data)
> @@ -145,150 +137,106 @@
>  	if (!data->enabled)
>  		return 0;
>  
> -	/* Except for the initial event, what matters is the previous bit */
> -	bit = (ev->type & IR_PULSE) ? 1 : 0;
> -
> -	last_bit = !bit;
> -
> -	/* Discards spurious space last_bits when inactive */
> -
> -	/* Very long delays are considered as start events */
> -	if (ev->delta.tv_nsec > NEC_HEADER_MARK + NEC_HEADER_SPACE - NEC_UNIT / 2)
> +	if (duration == 0) {
>  		data->state = STATE_INACTIVE;
> +		return 0;
> +	}
>  
> -	if (ev->type & IR_START_EVENT)
> -		data->state = STATE_INACTIVE;
> +	d = DIV_ROUND_CLOSEST(abs(duration), NEC_UNIT);
> +	if (duration < 0)
> +		d = -d;
> +
> +	IR_dprintk(2, "NEC decode started at state %d (%i units, %ius)\n",
> +		   data->state, d, duration);
>  
>  	switch (data->state) {
> -	case STATE_INACTIVE:
> -		if (!bit)		/* PULSE marks the start event */
> -			return 0;
>  
> -		data->count = 0;
> -		data->state = STATE_HEADER_MARK;
> -		memset (&data->nec_code, 0, sizeof(data->nec_code));
> -		return 0;
> -	case STATE_HEADER_MARK:
> -		if (!last_bit)
> -			goto err;
> -		if (ev->delta.tv_nsec < NEC_HEADER_MARK - 6 * NEC_UNIT)
> -			goto err;
> -		data->state = STATE_HEADER_SPACE;
> +	case STATE_INACTIVE:
> +		if (d == NEC_HEADER_MARK) {
> +			data->count = 0;
> +			data->state = STATE_HEADER_SPACE;
> +		}
>  		return 0;
> +
>  	case STATE_HEADER_SPACE:
> -		if (last_bit)
> -			goto err;
> -		if (ev->delta.tv_nsec >= NEC_HEADER_SPACE - NEC_UNIT / 2) {
> +		if (d == NEC_HEADER_SPACE) {
>  			data->state = STATE_MARK;
>  			return 0;
> -		}
> -
> -		if (ev->delta.tv_nsec >= NEC_REPEAT_SPACE - NEC_UNIT / 2) {
> +		} else if (d == NEC_REPEAT_SPACE) {
>  			ir_repeat(input_dev);
>  			IR_dprintk(1, "Repeat last key\n");
>  			data->state = STATE_TRAILER_MARK;
>  			return 0;
>  		}
> -		goto err;
> +		break;
> +
>  	case STATE_MARK:
> -		if (!last_bit)
> -			goto err;
> -		if ((ev->delta.tv_nsec > NEC_MARK + NEC_UNIT / 2) ||
> -		    (ev->delta.tv_nsec < NEC_MARK - NEC_UNIT / 2))
> -			goto err;
> -		data->state = STATE_SPACE;
> -		return 0;
> +		if (d == NEC_MARK) {
> +			data->state = STATE_SPACE;
> +			return 0;
> +		}
> +		break;
> +
>  	case STATE_SPACE:
> -		if (last_bit)
> -			goto err;
> +		if (d != NEC_0_SPACE && d != NEC_1_SPACE)
> +			break;
>  
> -		if ((ev->delta.tv_nsec >= NEC_0_SPACE - NEC_UNIT / 2) &&
> -		    (ev->delta.tv_nsec < NEC_0_SPACE + NEC_UNIT / 2))
> -			bit = 0;
> -		else if ((ev->delta.tv_nsec >= NEC_1_SPACE - NEC_UNIT / 2) &&
> -		         (ev->delta.tv_nsec < NEC_1_SPACE + NEC_UNIT / 2))
> -			bit = 1;
> -		else {
> -			IR_dprintk(1, "Decode failed at %d-th bit (%s) @%luus\n",
> -				data->count,
> -				last_bit ? "pulse" : "space",
> -				(ev->delta.tv_nsec + 500) / 1000);
> +		data->nec_bits <<= 1;
> +		if (d == NEC_1_SPACE)
> +			data->nec_bits |= 1;
> +		data->count++;
>  
> -			goto err2;
> +		if (data->count != NEC_NBITS) {
> +			data->state = STATE_MARK;
> +			return 0;
>  		}
>  
> -		/* Ok, we've got a valid bit. proccess it */
> -		if (bit) {
> -			int shift = data->count;
> -
> -			/*
> -			 * NEC transmit bytes on this temporal order:
> -			 * address | not address | command | not command
> -			 */
> -			if (shift < 8) {
> -				data->nec_code.address |= 1 << shift;
> -			} else if (shift < 16) {
> -				data->nec_code.not_address |= 1 << (shift - 8);
> -			} else if (shift < 24) {
> -				data->nec_code.command |= 1 << (shift - 16);
> -			} else {
> -				data->nec_code.not_command |= 1 << (shift - 24);
> -			}
> +		address     = bitrev8((data->nec_bits >> 24) & 0xff);
> +		not_address = bitrev8((data->nec_bits >> 16) & 0xff);
> +		command	    = bitrev8((data->nec_bits >>  8) & 0xff);
> +		not_command = bitrev8((data->nec_bits >>  0) & 0xff);
> +
> +		if ((command ^ not_command) != 0xff) {
> +			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
> +				   data->nec_bits);
> +			break;
>  		}
> -		if (++data->count == NEC_NBITS) {
> -			u32 scancode;
> -			/*
> -			 * Fixme: may need to accept Extended NEC protocol?
> -			 */
> -			if ((data->nec_code.command ^ data->nec_code.not_command) != 0xff)
> -				goto checksum_err;
> -
> -			if ((data->nec_code.address ^ data->nec_code.not_address) != 0xff) {
> -				/* Extended NEC */
> -				scancode = data->nec_code.address << 16 |
> -					   data->nec_code.not_address << 8 |
> -					   data->nec_code.command;
> -				IR_dprintk(1, "NEC scancode 0x%06x\n", scancode);
> -			} else {
> -				/* normal NEC */
> -				scancode = data->nec_code.address << 8 |
> -					   data->nec_code.command;
> -				IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
> -			}
> -			ir_keydown(input_dev, scancode, 0);
>  
> -			data->state = STATE_TRAILER_MARK;
> -		} else
> -			data->state = STATE_MARK;
> +		if ((address ^ not_address) != 0xff) {
> +			/* Extended NEC */
> +			scancode = address     << 16 |
> +				   not_address <<  8 |
> +				   command;
> +			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
> +		} else {
> +			/* normal NEC */
> +			scancode = address << 8 | command;
> +			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
> +		}
> +
> +		ir_keydown(input_dev, scancode, 0);
> +		data->state = STATE_TRAILER_MARK;
>  		return 0;
> +
>  	case STATE_TRAILER_MARK:
> -		if (!last_bit)
> -			goto err;
> -		data->state = STATE_TRAILER_SPACE;
> -		return 0;
> +		if (d > 0) {
> +			data->state = STATE_TRAILER_SPACE;
> +			return 0;
> +		}
> +		break;
> +
>  	case STATE_TRAILER_SPACE:
> -		if (last_bit)
> -			goto err;
> -		data->state = STATE_INACTIVE;
> -		return 0;
> -	}
> +		if (d < 0) {
> +			data->state = STATE_INACTIVE;
> +			return 0;
> +		}
>  
> -err:
> -	IR_dprintk(1, "NEC decoded failed at state %d (%s) @ %luus\n",
> -		   data->state,
> -		   bit ? "pulse" : "space",
> -		   (ev->delta.tv_nsec + 500) / 1000);
> -err2:
> -	data->state = STATE_INACTIVE;
> -	return -EINVAL;
> +		break;
> +	}
>  
> -checksum_err:
> +	IR_dprintk(1, "NEC decode failed at state %d (%i units, %ius)\n",
> +		   data->state, d, duration);
>  	data->state = STATE_INACTIVE;
> -	IR_dprintk(1, "NEC checksum error: received 0x%02x%02x%02x%02x\n",
> -		   data->nec_code.address,
> -		   data->nec_code.not_address,
> -		   data->nec_code.command,
> -		   data->nec_code.not_command);
>  	return -EINVAL;
>  }
>  
> Index: ir/drivers/media/IR/ir-rc5-decoder.c
> ===================================================================
> --- ir.orig/drivers/media/IR/ir-rc5-decoder.c	2010-04-06 12:16:51.784849187 +0200
> +++ ir/drivers/media/IR/ir-rc5-decoder.c	2010-04-07 21:34:14.816870395 +0200
> @@ -15,31 +15,22 @@
>  /*
>   * This code only handles 14 bits RC-5 protocols. There are other variants
>   * that use a different number of bits. This is currently unsupported
> - * It considers a carrier of 36 kHz, with a total of 14 bits, where
> - * the first two bits are start bits, and a third one is a filing bit
>   */
>  
>  #include <media/ir-core.h>
>  
> -static unsigned int ir_rc5_remote_gap = 888888;
> -
> -#define RC5_NBITS		14
> -#define RC5_BIT			(ir_rc5_remote_gap * 2)
> -#define RC5_DURATION		(ir_rc5_remote_gap * RC5_NBITS)
> +#define RC5_UNIT		889 /* us */
> +#define	RC5_BITS		14
>  
>  /* Used to register rc5_decoder clients */
>  static LIST_HEAD(decoder_list);
> -static spinlock_t decoder_lock;
> +static DEFINE_SPINLOCK(decoder_lock);
>  
>  enum rc5_state {
>  	STATE_INACTIVE,
> -	STATE_MARKSPACE,
> -	STATE_TRAILER,
> -};
> -
> -struct rc5_code {
> -	u8	address;
> -	u8	command;
> +	STATE_BIT_START,
> +	STATE_BIT_END,
> +	STATE_FINISHED,
>  };
>  
>  struct decoder_data {
> @@ -49,8 +40,9 @@
>  
>  	/* State machine control */
>  	enum rc5_state		state;
> -	struct rc5_code		rc5_code;
> -	unsigned		code, elapsed, last_bit, last_code;
> +	u32			rc5_bits;
> +	int			last_delta;
> +	unsigned		count;
>  };
>  
> 
> @@ -122,18 +114,19 @@
>  };
>  
>  /**
> - * handle_event() - Decode one RC-5 pulse or space
> + * ir_rc5_decode() - Decode one RC-5 pulse or space
>   * @input_dev:	the struct input_dev descriptor of the device
> - * @ev:		event array with type/duration of pulse/space
> + * @duration:	duration of pulse/space
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_rc5_decode(struct input_dev *input_dev,
> -			struct ir_raw_event *ev)
> +static int ir_rc5_decode(struct input_dev *input_dev, int duration)
>  {
>  	struct decoder_data *data;
>  	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
> -	int is_pulse, scancode, delta, toggle;
> +	u8 command, system, toggle;
> +	u32 scancode;
> +	int d;
>  
>  	data = get_decoder_data(ir_dev);
>  	if (!data)
> @@ -142,79 +135,86 @@
>  	if (!data->enabled)
>  		return 0;
>  
> -	delta = DIV_ROUND_CLOSEST(ev->delta.tv_nsec, ir_rc5_remote_gap);
> +	if (duration == 0) {
> +		data->state = STATE_INACTIVE;
> +		return 0;
> +	}
>  
> -	/* The duration time refers to the last bit time */
> -	is_pulse = (ev->type & IR_PULSE) ? 1 : 0;
> +	d = DIV_ROUND_CLOSEST(abs(duration), RC5_UNIT);
> +	if (duration < 0)
> +		d = -d;
> +
> +again:
> +	IR_dprintk(2, "RC5 decode started at state %i (%i units, %ius)\n",
> +		   data->state, d, duration);
>  
> -	/* Very long delays are considered as start events */
> -	if (delta > RC5_DURATION || (ev->type & IR_START_EVENT))
> -		data->state = STATE_INACTIVE;
> +	if (d == 0 && data->state != STATE_FINISHED)
> +		return 0;
>  
>  	switch (data->state) {
> +
>  	case STATE_INACTIVE:
> -	IR_dprintk(2, "currently inative. Start bit (%s) @%uus\n",
> -		   is_pulse ? "pulse" : "space",
> -		   (unsigned)(ev->delta.tv_nsec + 500) / 1000);
> -
> -		/* Discards the initial start space */
> -		if (!is_pulse)
> -			goto err;
> -		data->code = 1;
> -		data->last_bit = 1;
> -		data->elapsed = 0;
> -		memset(&data->rc5_code, 0, sizeof(data->rc5_code));
> -		data->state = STATE_MARKSPACE;
> -		return 0;
> -	case STATE_MARKSPACE:
> -		if (delta != 1)
> -			data->last_bit = data->last_bit ? 0 : 1;
> +		if ((d == 1) || (d == 2)) {
> +			data->state = STATE_BIT_START;
> +			data->count = 1;
> +			d--;
> +			goto again;
> +		}
> +		break;
>  
> -		data->elapsed += delta;
> +	case STATE_BIT_START:
> +		if (abs(d) == 1) {
> +			data->rc5_bits <<= 1;
> +			if (d == -1)
> +				data->rc5_bits |= 1;
> +			data->count++;
> +			data->last_delta = d;
> +
> +			/*
> +			 * If the last bit is zero, a space will "merge"
> +			 * with the silence after the command.
> +			 */
> +			if ((data->count == data->wanted_bits) && (d == 1))
> +				data->state = STATE_FINISHED;
> +			else
> +				data->state = STATE_BIT_END;
>  
> -		if ((data->elapsed % 2) == 1)
>  			return 0;
> +		}
> +		break;
>  
> -		data->code <<= 1;
> -		data->code |= data->last_bit;
> -
> -		/* Fill the 2 unused bits at the command with 0 */
> -		if (data->elapsed / 2 == 6)
> -			data->code <<= 2;
> -
> -		if (data->elapsed >= (RC5_NBITS - 1) * 2) {
> -			scancode = data->code;
> -
> -			/* Check for the start bits */
> -			if ((scancode & 0xc000) != 0xc000) {
> -				IR_dprintk(1, "Code 0x%04x doesn't have two start bits. It is not RC-5\n", scancode);
> -				goto err;
> -			}
> -
> -			toggle = (scancode & 0x2000) ? 1 : 0;
> -
> -			if (scancode == data->last_code) {
> -				IR_dprintk(1, "RC-5 repeat\n");
> -				ir_repeat(input_dev);
> -			} else {
> -				data->last_code = scancode;
> -				scancode &= 0x1fff;
> -				IR_dprintk(1, "RC-5 scancode 0x%04x\n", scancode);
> -
> -				ir_keydown(input_dev, scancode, 0);
> -			}
> -			data->state = STATE_TRAILER;
> +	case STATE_BIT_END:
> +		/* delta and last_delta signedness must differ */
> +		if (d * data->last_delta < 0) {
> +			if (data->count == RC5_BITS)
> +				data->state = STATE_FINISHED;
> +			else
> +				data->state = STATE_BIT_START;
> +
> +			if (d > 0)
> +				d--;
> +			else if (d < 0)
> +				d++;
> +			goto again;
>  		}
> -		return 0;
> -	case STATE_TRAILER:
> +		break;
> +
> +	case STATE_FINISHED:
> +		command  = (data->rc5_bits & 0x0003F) >> 0;
> +		system   = (data->rc5_bits & 0x007C0) >> 6;
> +		toggle   = (data->rc5_bits & 0x00800) ? 1 : 0;
> +		command += (data->rc5_bits & 0x01000) ? 0 : 0x40;
> +		scancode = system << 8 | command;
> +
> +		IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
> +			   scancode, toggle);
> +		ir_keydown(input_dev, scancode, toggle);
>  		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> -err:
> -	IR_dprintk(1, "RC-5 decoded failed at %s @ %luus\n",
> -		   is_pulse ? "pulse" : "space",
> -		   (ev->delta.tv_nsec + 500) / 1000);
> +	IR_dprintk(1, "RC5 decode failed at state %i (%i units, %ius)\n",
> +		   data->state, d, duration);
>  	data->state = STATE_INACTIVE;
>  	return -EINVAL;
>  }
> Index: ir/drivers/media/video/saa7134/saa7134-input.c
> ===================================================================
> --- ir.orig/drivers/media/video/saa7134/saa7134-input.c	2010-04-06 12:30:16.428854774 +0200
> +++ ir/drivers/media/video/saa7134/saa7134-input.c	2010-04-07 18:05:27.756852639 +0200
> @@ -1021,7 +1021,7 @@
>  	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
>  	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
>  	space = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
> -	ir_raw_event_store(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
> +	ir_raw_event_store_edge(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
>  
> 
>  	/*
> 
> -- 
> David Härdeman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

