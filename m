Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51830 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0DFKsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 06:48:16 -0400
Date: Tue, 6 Apr 2010 12:48:11 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: mchehab@infradead.org
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC] Teach drivers/media/IR/ir-raw-event.c to use durations
Message-ID: <20100406104811.GA6414@hardeman.nu>
References: <20100406104410.710253548@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=use-pulse-space-timings-in-ir-raw
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/IR/ir-raw-event.c is currently written with the assumption that
all "raw" hardware will generate events only on state change (i.e. when
a pulse or space starts).

However, some hardware (like mceusb, probably the most popular IR receiver
out there) only generates duration data (and that data is buffered so using
any kind of timing on the data is futile).

This patch (which is not tested since I haven't yet converted a driver for
any of my hardware to ir-core yet, will do soon) is a RFC on my proposed
interface change...once I get the green light on the interface change itself
I'll make sure that the decoders actually work :)

The rc5 decoder has also gained rc5x support and the use of kfifo's for
intermediate storage is gone (since there is no need for it).

diffstat:
 drivers/media/IR/ir-nec-decoder.c           |  229 +++++++++++-----------------
 drivers/media/IR/ir-raw-event.c             |  143 ++++++++---------
 drivers/media/IR/ir-rc5-decoder.c           |  204 +++++++++++++++---------
 drivers/media/video/saa7134/saa7134-input.c |    4 
 include/media/ir-core.h                     |   18 --
 5 files changed, 291 insertions(+), 307 deletions(-)



Index: ir/drivers/media/IR/ir-raw-event.c
===================================================================
--- ir.orig/drivers/media/IR/ir-raw-event.c	2010-04-06 12:16:27.000000000 +0200
+++ ir/drivers/media/IR/ir-raw-event.c	2010-04-06 12:17:08.856877124 +0200
@@ -15,13 +15,11 @@
 #include <media/ir-core.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
-
-/* Define the max number of bit transitions per IR keycode */
-#define MAX_IR_EVENT_SIZE	256
+#include <linux/sched.h>
 
 /* Used to handle IR raw handler extensions */
 static LIST_HEAD(ir_raw_handler_list);
-static spinlock_t ir_raw_handler_lock;
+static DEFINE_SPINLOCK(ir_raw_handler_lock);
 
 /**
  * RUN_DECODER()	- runs an operation on all IR decoders
@@ -56,25 +54,14 @@
 int ir_raw_event_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	int rc, size;
+	int rc;
 
 	ir->raw = kzalloc(sizeof(*ir->raw), GFP_KERNEL);
 	if (!ir->raw)
 		return -ENOMEM;
 
-	size = sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE * 2;
-	size = roundup_pow_of_two(size);
-
-	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
-	if (rc < 0) {
-		kfree(ir->raw);
-		ir->raw = NULL;
-		return rc;
-	}
-
 	rc = RUN_DECODER(raw_register, input_dev);
 	if (rc < 0) {
-		kfifo_free(&ir->raw->kfifo);
 		kfree(ir->raw);
 		ir->raw = NULL;
 		return rc;
@@ -93,82 +80,84 @@
 
 	RUN_DECODER(raw_unregister, input_dev);
 
-	kfifo_free(&ir->raw->kfifo);
 	kfree(ir->raw);
 	ir->raw = NULL;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_unregister);
 
-int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)
+/**
+ * ir_raw_event_reset() - resets the raw decoding state machines
+ * @input_dev:	the struct input_dev device descriptor
+ *
+ * This routine resets the raw ir decoding state machines, useful e.g. when
+ * a timeout occurs or when resetting the hardware.
+ */
+void ir_raw_event_reset(struct input_dev *input_dev)
 {
-	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
-	struct timespec		ts;
-	struct ir_raw_event	event;
-	int			rc;
-
-	if (!ir->raw)
-		return -EINVAL;
-
-	event.type = type;
-	event.delta.tv_sec = 0;
-	event.delta.tv_nsec = 0;
-
-	ktime_get_ts(&ts);
-
-	if (timespec_equal(&ir->raw->last_event, &event.delta))
-		event.type |= IR_START_EVENT;
-	else
-		event.delta = timespec_sub(ts, ir->raw->last_event);
-
-	memcpy(&ir->raw->last_event, &ts, sizeof(ts));
+	RUN_DECODER(reset, input_dev);
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_reset);
 
-	if (event.delta.tv_sec) {
-		event.type |= IR_START_EVENT;
-		event.delta.tv_sec = 0;
-		event.delta.tv_nsec = 0;
-	}
+/**
+ * ir_raw_event_duration() - pass a pulse/space duration to the raw ir decoders
+ * @input_dev:	the struct input_dev device descriptor
+ * @duration:	duration of the pulse or space
+ *
+ * This routine passes a pulse/space duration to the raw ir decoding state
+ * machines. Pulses are signalled as positive values and spaces as negative
+ * values.
+ */
+void ir_raw_event_duration(struct input_dev *input_dev, int duration)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
 
-	kfifo_in(&ir->raw->kfifo, &event, sizeof(event));
+	if (!ir->raw || duration == 0)
+		return;
 
-	return rc;
+	RUN_DECODER(decode, input_dev, duration);
 }
-EXPORT_SYMBOL_GPL(ir_raw_event_store);
+EXPORT_SYMBOL_GPL(ir_raw_event_duration);
 
-int ir_raw_event_handle(struct input_dev *input_dev)
+/**
+ * ir_raw_event_edge() - notify raw ir decoders of the start of a pulse/space
+ * @input_dev:	the struct input_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine is used to notify the raw ir decoders on the beginning of an
+ * ir pulse or space (or the start/end of ir reception). This is used by
+ * hardware which does not provide durations directly but only interrupts
+ * (or similar events) on state change.
+ */
+void ir_raw_event_edge(struct input_dev *input_dev, enum raw_event_type type)
 {
-	struct ir_input_dev		*ir = input_get_drvdata(input_dev);
-	int				rc;
-	struct ir_raw_event		ev;
-	int 				len, i;
-
-	/*
-	 * Store the events into a temporary buffer. This allows calling more than
-	 * one decoder to deal with the received data
-	 */
-	len = kfifo_len(&ir->raw->kfifo) / sizeof(ev);
-	if (!len)
-		return 0;
-
-	for (i = 0; i < len; i++) {
-		rc = kfifo_out(&ir->raw->kfifo, &ev, sizeof(ev));
-		if (rc != sizeof(ev)) {
-			IR_dprintk(1, "overflow error: received %d instead of %zd\n",
-				   rc, sizeof(ev));
-			return -EINVAL;
-		}
-		IR_dprintk(2, "event type %d, time before event: %07luus\n",
-			ev.type, (ev.delta.tv_nsec + 500) / 1000);
-		rc = RUN_DECODER(decode, input_dev, &ev);
-	}
+	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
+	ktime_t			now;
+	s64			delta; /* us */
+
+	if (!ir->raw)
+		return;
 
-	/*
-	 * Call all ir decoders. This allows decoding the same event with
-	 * more than one protocol handler.
-	 */
+	now = ktime_get();
+	delta = ktime_us_delta(now, ir->raw->last_event);
 
-	return rc;
+	/* Check for a long duration since last event or if we're
+	   being called for the first time */
+	if (delta > USEC_PER_SEC || !ir->raw->last_type)
+		type |= IR_START_EVENT;
+
+	if (type & IR_START_EVENT)
+		ir_raw_event_reset(input_dev);
+	else if (ir->raw->last_type & IR_SPACE)
+		ir_raw_event_duration(input_dev, (int)-delta);
+	else if (ir->raw->last_type & IR_PULSE)
+		ir_raw_event_duration(input_dev, (int)delta);
+	else
+		return;
+
+	ir->raw->last_event = now;
+	ir->raw->last_type = type;
 }
-EXPORT_SYMBOL_GPL(ir_raw_event_handle);
+EXPORT_SYMBOL_GPL(ir_raw_event_edge);
 
 /*
  * Extension interface - used to register the IR decoders
Index: ir/include/media/ir-core.h
===================================================================
--- ir.orig/include/media/ir-core.h	2010-04-06 12:16:27.000000000 +0200
+++ ir/include/media/ir-core.h	2010-04-06 12:17:08.856877124 +0200
@@ -57,14 +57,9 @@
 	void		(*close)(void *priv);
 };
 
-struct ir_raw_event {
-	struct timespec		delta;	/* Time spent before event */
-	enum raw_event_type	type;	/* event type */
-};
-
 struct ir_raw_event_ctrl {
-	struct kfifo			kfifo;		/* fifo for the pulse/space events */
-	struct timespec			last_event;	/* when last event occurred */
+	ktime_t				last_event;	/* when last event occurred */
+	enum raw_event_type		last_type;	/* last event type */
 };
 
 struct ir_input_dev {
@@ -89,8 +84,8 @@
 struct ir_raw_handler {
 	struct list_head list;
 
-	int (*decode)(struct input_dev *input_dev,
-		      struct ir_raw_event *ev);
+	int (*decode)(struct input_dev *input_dev, int duration);
+	int (*reset)(struct input_dev *input_dev);
 	int (*raw_register)(struct input_dev *input_dev);
 	int (*raw_unregister)(struct input_dev *input_dev);
 };
@@ -146,8 +141,9 @@
 /* Routines from ir-raw-event.c */
 int ir_raw_event_register(struct input_dev *input_dev);
 void ir_raw_event_unregister(struct input_dev *input_dev);
-int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type);
-int ir_raw_event_handle(struct input_dev *input_dev);
+void ir_raw_event_reset(struct input_dev *input_dev);
+void ir_raw_event_duration(struct input_dev *input_dev, int duration);
+void ir_raw_event_edge(struct input_dev *input_dev, enum raw_event_type type);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
Index: ir/drivers/media/IR/ir-nec-decoder.c
===================================================================
--- ir.orig/drivers/media/IR/ir-nec-decoder.c	2010-04-06 12:16:27.000000000 +0200
+++ ir/drivers/media/IR/ir-nec-decoder.c	2010-04-06 12:17:08.860846045 +0200
@@ -14,22 +14,25 @@
 
 #include <media/ir-core.h>
 
+/*
+ * Regarding NEC_HEADER_MARK: some NEC remotes use 16, some 8,
+ * some receivers are also good at missing part of the first pulse.
+ */
 #define NEC_NBITS		32
-#define NEC_UNIT		559979 /* ns */
-#define NEC_HEADER_MARK		(16 * NEC_UNIT)
-#define NEC_HEADER_SPACE	(8 * NEC_UNIT)
-#define NEC_REPEAT_SPACE	(4 * NEC_UNIT)
-#define NEC_MARK		(NEC_UNIT)
-#define NEC_0_SPACE		(NEC_UNIT)
-#define NEC_1_SPACE		(3 * NEC_UNIT)
+#define NEC_UNIT		562	/* us */
+#define NEC_HEADER_MARK		6
+#define NEC_HEADER_SPACE	-8
+#define NEC_REPEAT_SPACE	-4
+#define NEC_MARK		1
+#define NEC_0_SPACE		-1
+#define NEC_1_SPACE		-3
 
 /* Used to register nec_decoder clients */
 static LIST_HEAD(decoder_list);
-static spinlock_t decoder_lock;
+static DEFINE_SPINLOCK(decoder_lock);
 
 enum nec_state {
 	STATE_INACTIVE,
-	STATE_HEADER_MARK,
 	STATE_HEADER_SPACE,
 	STATE_MARK,
 	STATE_SPACE,
@@ -37,11 +40,14 @@
 	STATE_TRAILER_SPACE,
 };
 
-struct nec_code {
-	u8	address;
-	u8	not_address;
-	u8	command;
-	u8	not_command;
+union nec_code {
+	struct {
+		u8 address;
+		u8 not_address;
+		u8 command;
+		u8 not_command;
+	} parts;
+	u32 bits;
 };
 
 struct decoder_data {
@@ -51,7 +57,7 @@
 
 	/* State machine control */
 	enum nec_state		state;
-	struct nec_code		nec_code;
+	union nec_code		nec_code;
 	unsigned		count;
 };
 
@@ -62,7 +68,6 @@
  *
  * Returns the struct decoder_data that corresponds to a device
  */
-
 static struct decoder_data *get_decoder_data(struct  ir_input_dev *ir_dev)
 {
 	struct decoder_data *data = NULL;
@@ -123,20 +128,30 @@
 	.attrs	= decoder_attributes,
 };
 
+static int ir_nec_reset(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct decoder_data *data;
+
+	data = get_decoder_data(ir_dev);
+	if (data)
+		data->state = STATE_INACTIVE;
+	return 0;
+}
 
 /**
  * ir_nec_decode() - Decode one NEC pulse or space
  * @input_dev:	the struct input_dev descriptor of the device
- * @ev:		event array with type/duration of pulse/space
+ * @duration:	duration in us of pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_nec_decode(struct input_dev *input_dev,
-			 struct ir_raw_event *ev)
+static int ir_nec_decode(struct input_dev *input_dev, int duration)
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int bit, last_bit;
+	int d;
+	u32 scancode;
 
 	data = get_decoder_data(ir_dev);
 	if (!data)
@@ -145,150 +160,93 @@
 	if (!data->enabled)
 		return 0;
 
-	/* Except for the initial event, what matters is the previous bit */
-	bit = (ev->type & IR_PULSE) ? 1 : 0;
-
-	last_bit = !bit;
-
-	/* Discards spurious space last_bits when inactive */
-
-	/* Very long delays are considered as start events */
-	if (ev->delta.tv_nsec > NEC_HEADER_MARK + NEC_HEADER_SPACE - NEC_UNIT / 2)
-		data->state = STATE_INACTIVE;
-
-	if (ev->type & IR_START_EVENT)
-		data->state = STATE_INACTIVE;
+	d = DIV_ROUND_CLOSEST(abs(duration), NEC_UNIT);
+	if (duration < 0)
+		d = -d;
 
 	switch (data->state) {
-	case STATE_INACTIVE:
-		if (!bit)		/* PULSE marks the start event */
-			return 0;
 
-		data->count = 0;
-		data->state = STATE_HEADER_MARK;
-		memset (&data->nec_code, 0, sizeof(data->nec_code));
-		return 0;
-	case STATE_HEADER_MARK:
-		if (!last_bit)
-			goto err;
-		if (ev->delta.tv_nsec < NEC_HEADER_MARK - 6 * NEC_UNIT)
-			goto err;
-		data->state = STATE_HEADER_SPACE;
+	case STATE_INACTIVE:
+		if (d > NEC_HEADER_MARK) {
+			data->count = 0;
+			data->state = STATE_HEADER_SPACE;
+		}
 		return 0;
+
 	case STATE_HEADER_SPACE:
-		if (last_bit)
-			goto err;
-		if (ev->delta.tv_nsec >= NEC_HEADER_SPACE - NEC_UNIT / 2) {
+		if (d == NEC_HEADER_SPACE) {
 			data->state = STATE_MARK;
 			return 0;
-		}
-
-		if (ev->delta.tv_nsec >= NEC_REPEAT_SPACE - NEC_UNIT / 2) {
+		} else if (d == NEC_REPEAT_SPACE) {
 			ir_repeat(input_dev);
 			IR_dprintk(1, "Repeat last key\n");
 			data->state = STATE_TRAILER_MARK;
 			return 0;
 		}
-		goto err;
-	case STATE_MARK:
-		if (!last_bit)
-			goto err;
-		if ((ev->delta.tv_nsec > NEC_MARK + NEC_UNIT / 2) ||
-		    (ev->delta.tv_nsec < NEC_MARK - NEC_UNIT / 2))
-			goto err;
-		data->state = STATE_SPACE;
-		return 0;
-	case STATE_SPACE:
-		if (last_bit)
-			goto err;
-
-		if ((ev->delta.tv_nsec >= NEC_0_SPACE - NEC_UNIT / 2) &&
-		    (ev->delta.tv_nsec < NEC_0_SPACE + NEC_UNIT / 2))
-			bit = 0;
-		else if ((ev->delta.tv_nsec >= NEC_1_SPACE - NEC_UNIT / 2) &&
-		         (ev->delta.tv_nsec < NEC_1_SPACE + NEC_UNIT / 2))
-			bit = 1;
-		else {
-			IR_dprintk(1, "Decode failed at %d-th bit (%s) @%luus\n",
-				data->count,
-				last_bit ? "pulse" : "space",
-				(ev->delta.tv_nsec + 500) / 1000);
+		break;
 
-			goto err2;
+	case STATE_MARK:
+		if (d == NEC_MARK) {
+			data->state = STATE_SPACE;
+			return 0;
 		}
+		break;
 
-		/* Ok, we've got a valid bit. proccess it */
-		if (bit) {
-			int shift = data->count;
-
-			/*
-			 * NEC transmit bytes on this temporal order:
-			 * address | not address | command | not command
-			 */
-			if (shift < 8) {
-				data->nec_code.address |= 1 << shift;
-			} else if (shift < 16) {
-				data->nec_code.not_address |= 1 << (shift - 8);
-			} else if (shift < 24) {
-				data->nec_code.command |= 1 << (shift - 16);
-			} else {
-				data->nec_code.not_command |= 1 << (shift - 24);
+	case STATE_SPACE:
+		if (d == NEC_0_SPACE || d == NEC_1_SPACE) {
+			data->nec_code.bits <<= 1;
+			if (d == NEC_1_SPACE)
+				data->nec_code.bits |= 1;
+			data->count++;
+
+			if (data->count != NEC_NBITS)
+				return 0;
+
+			if ((data->nec_code.parts.command ^ data->nec_code.parts.not_command) != 0xff) {
+				IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
+					   data->nec_code.bits);
+				goto out;
 			}
-		}
-		if (++data->count == NEC_NBITS) {
-			u32 scancode;
-			/*
-			 * Fixme: may need to accept Extended NEC protocol?
-			 */
-			if ((data->nec_code.command ^ data->nec_code.not_command) != 0xff)
-				goto checksum_err;
 
-			if ((data->nec_code.address ^ data->nec_code.not_address) != 0xff) {
+			if ((data->nec_code.parts.address ^ data->nec_code.parts.not_address) != 0xff) {
 				/* Extended NEC */
-				scancode = data->nec_code.address << 16 |
-					   data->nec_code.not_address << 8 |
-					   data->nec_code.command;
-				IR_dprintk(1, "NEC scancode 0x%06x\n", scancode);
+				scancode = data->nec_code.bits >> 8;
+				IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
 			} else {
 				/* normal NEC */
-				scancode = data->nec_code.address << 8 |
-					   data->nec_code.command;
+				scancode = data->nec_code.parts.address << 8 |
+					   data->nec_code.parts.command;
 				IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
 			}
 			ir_keydown(input_dev, scancode, 0);
-
 			data->state = STATE_TRAILER_MARK;
-		} else
-			data->state = STATE_MARK;
-		return 0;
+			return 0;
+		}
+
+		IR_dprintk(1, "Decode failed at %d-th bit (%i units, %ius)\n",
+			   data->count, d, duration);
+		goto out;
+
 	case STATE_TRAILER_MARK:
-		if (!last_bit)
-			goto err;
-		data->state = STATE_TRAILER_SPACE;
-		return 0;
+		if (d > 0) {
+			data->state = STATE_TRAILER_SPACE;
+			return 0;
+		}
+		break;
+
 	case STATE_TRAILER_SPACE:
-		if (last_bit)
-			goto err;
-		data->state = STATE_INACTIVE;
-		return 0;
-	}
+		if (d < 0) {
+			data->state = STATE_INACTIVE;
+			return 0;
+		}
 
-err:
-	IR_dprintk(1, "NEC decoded failed at state %d (%s) @ %luus\n",
-		   data->state,
-		   bit ? "pulse" : "space",
-		   (ev->delta.tv_nsec + 500) / 1000);
-err2:
-	data->state = STATE_INACTIVE;
-	return -EINVAL;
+		break;
+	}
 
-checksum_err:
+	IR_dprintk(1, "NEC decode failed at state %d (%i units, %ius)\n",
+		   data->state, d, duration);
+out:
 	data->state = STATE_INACTIVE;
-	IR_dprintk(1, "NEC checksum error: received 0x%02x%02x%02x%02x\n",
-		   data->nec_code.address,
-		   data->nec_code.not_address,
-		   data->nec_code.command,
-		   data->nec_code.not_command);
 	return -EINVAL;
 }
 
@@ -337,6 +295,7 @@
 }
 
 static struct ir_raw_handler nec_handler = {
+	.reset		= ir_nec_reset,
 	.decode		= ir_nec_decode,
 	.raw_register	= ir_nec_register,
 	.raw_unregister	= ir_nec_unregister,
Index: ir/drivers/media/IR/ir-rc5-decoder.c
===================================================================
--- ir.orig/drivers/media/IR/ir-rc5-decoder.c	2010-04-06 12:16:51.784849187 +0200
+++ ir/drivers/media/IR/ir-rc5-decoder.c	2010-04-06 12:25:20.968874462 +0200
@@ -15,31 +15,22 @@
 /*
  * This code only handles 14 bits RC-5 protocols. There are other variants
  * that use a different number of bits. This is currently unsupported
- * It considers a carrier of 36 kHz, with a total of 14 bits, where
- * the first two bits are start bits, and a third one is a filing bit
  */
 
 #include <media/ir-core.h>
 
-static unsigned int ir_rc5_remote_gap = 888888;
-
-#define RC5_NBITS		14
-#define RC5_BIT			(ir_rc5_remote_gap * 2)
-#define RC5_DURATION		(ir_rc5_remote_gap * RC5_NBITS)
+#define RC5_UNIT		889 /* us */
 
 /* Used to register rc5_decoder clients */
 static LIST_HEAD(decoder_list);
-static spinlock_t decoder_lock;
+static DEFINE_SPINLOCK(decoder_lock);
 
 enum rc5_state {
 	STATE_INACTIVE,
-	STATE_MARKSPACE,
-	STATE_TRAILER,
-};
-
-struct rc5_code {
-	u8	address;
-	u8	command;
+	STATE_BIT_START,
+	STATE_BIT_END,
+	STATE_CHECK_RC5X,
+	STATE_FINISHED,
 };
 
 struct decoder_data {
@@ -49,8 +40,10 @@
 
 	/* State machine control */
 	enum rc5_state		state;
-	struct rc5_code		rc5_code;
-	unsigned		code, elapsed, last_bit, last_code;
+	u32			rc5_bits;
+	int			last_delta;
+	unsigned		count;
+	unsigned		wanted_bits;
 };
 
 
@@ -122,18 +115,35 @@
 };
 
 /**
- * handle_event() - Decode one RC-5 pulse or space
+ * ir_rc5_reset() - reset the RC5 state machine
  * @input_dev:	the struct input_dev descriptor of the device
- * @ev:		event array with type/duration of pulse/space
+ *
+ * This function is used to reset the RC5 state machine, e.g. on hw
+ * reset.
+ */
+static int ir_rc5_reset(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct decoder_data *data;
+
+	data = get_decoder_data(ir_dev);
+	if (data)
+		data->state = STATE_INACTIVE;
+	return 0;
+}
+
+/**
+ * ir_rc5_decode() - Decode one RC-5 pulse or space
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @duration:	duration of pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc5_decode(struct input_dev *input_dev,
-			struct ir_raw_event *ev)
+static int ir_rc5_decode(struct input_dev *input_dev, int duration)
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int is_pulse, scancode, delta, toggle;
+	int d;
 
 	data = get_decoder_data(ir_dev);
 	if (!data)
@@ -142,79 +152,110 @@
 	if (!data->enabled)
 		return 0;
 
-	delta = DIV_ROUND_CLOSEST(ev->delta.tv_nsec, ir_rc5_remote_gap);
+	d = DIV_ROUND_CLOSEST(abs(duration), RC5_UNIT);
+	if (duration < 0)
+		d = -d;
 
-	/* The duration time refers to the last bit time */
-	is_pulse = (ev->type & IR_PULSE) ? 1 : 0;
-
-	/* Very long delays are considered as start events */
-	if (delta > RC5_DURATION || (ev->type & IR_START_EVENT))
-		data->state = STATE_INACTIVE;
+again:
+	if (d == 0 && data->state != STATE_FINISHED)
+		return 0;
 
 	switch (data->state) {
+
 	case STATE_INACTIVE:
-	IR_dprintk(2, "currently inative. Start bit (%s) @%uus\n",
-		   is_pulse ? "pulse" : "space",
-		   (unsigned)(ev->delta.tv_nsec + 500) / 1000);
-
-		/* Discards the initial start space */
-		if (!is_pulse)
-			goto err;
-		data->code = 1;
-		data->last_bit = 1;
-		data->elapsed = 0;
-		memset(&data->rc5_code, 0, sizeof(data->rc5_code));
-		data->state = STATE_MARKSPACE;
-		return 0;
-	case STATE_MARKSPACE:
-		if (delta != 1)
-			data->last_bit = data->last_bit ? 0 : 1;
+		if ((d == 1) || (d == 2)) {
+			data->state = STATE_BIT_START;
+			/* We need enough bits to get to STATE_CHECK_RC5X */
+			data->wanted_bits = 19;
+			data->count = 0;
+			d--;
+			goto again;
+		}
+		break;
 
-		data->elapsed += delta;
+	case STATE_BIT_START:
+		if (abs(d) == 1) {
+			data->rc5_bits <<= 1;
+			if (d == -1)
+				data->rc5_bits |= 1;
+			data->count++;
+
+			/*
+			 * If the last bit is zero, a space will "merge"
+			 * with the silence after the command.
+			 */
+			if ((data->count == data->wanted_bits) && (d == 1))
+				data->state = STATE_FINISHED;
+			else
+				data->state = STATE_BIT_END;
 
-		if ((data->elapsed % 2) == 1)
 			return 0;
+		}
+		break;
+
+	case STATE_BIT_END:
+		/* delta and last_delta signedness must differ */
+		if (d * data->last_delta < 0) {
+			if (data->count == data->wanted_bits)
+				data->state = STATE_FINISHED;
+			else if (data->count == 7)
+				data->state = STATE_CHECK_RC5X;
+			else
+				data->state = STATE_BIT_START;
+
+			if (d > 0)
+				d--;
+			else if (d < 0)
+				d++;
+			goto again;
+		}
+		break;
 
-		data->code <<= 1;
-		data->code |= data->last_bit;
+	case STATE_CHECK_RC5X:
+		if (d <= -4) {
+			/* RC5X */
+			data->wanted_bits = 19;
+			d += 4;
+		} else {
+			/* RC5 */
+			data->wanted_bits = 13;
+		}
+		data->state = STATE_BIT_START;
+		goto again;
 
-		/* Fill the 2 unused bits at the command with 0 */
-		if (data->elapsed / 2 == 6)
-			data->code <<= 2;
-
-		if (data->elapsed >= (RC5_NBITS - 1) * 2) {
-			scancode = data->code;
-
-			/* Check for the start bits */
-			if ((scancode & 0xc000) != 0xc000) {
-				IR_dprintk(1, "Code 0x%04x doesn't have two start bits. It is not RC-5\n", scancode);
-				goto err;
-			}
-
-			toggle = (scancode & 0x2000) ? 1 : 0;
-
-			if (scancode == data->last_code) {
-				IR_dprintk(1, "RC-5 repeat\n");
-				ir_repeat(input_dev);
-			} else {
-				data->last_code = scancode;
-				scancode &= 0x1fff;
-				IR_dprintk(1, "RC-5 scancode 0x%04x\n", scancode);
-
-				ir_keydown(input_dev, scancode, 0);
-			}
-			data->state = STATE_TRAILER;
+	case STATE_FINISHED:
+		if (data->wanted_bits == 19) {
+			u8 xdata, command, system, toggle;
+			u32 scancode;
+			xdata    = (data->rc5_bits & 0x0003F) >> 0;
+			command  = (data->rc5_bits & 0x00FC0) >> 6;
+			system   = (data->rc5_bits & 0x1F000) >> 12;
+			toggle   = (data->rc5_bits & 0x20000) ? 1 : 0;
+			command += (data->rc5_bits & 0x01000) ? 0 : 0x40;
+			scancode = system << 16 | command << 8 | xdata;
+
+			IR_dprintk(1, "RC5X scancode 0x%06x (toggle: %u)\n",
+				   scancode, toggle);
+			ir_keydown(input_dev, scancode, toggle);
+		} else {
+			u8 command, system, toggle;
+			u32 scancode;
+                        command  = (data->rc5_bits & 0x0003F) >> 0;
+                        system   = (data->rc5_bits & 0x007C0) >> 6;
+                        toggle   = (data->rc5_bits & 0x00800) ? 1 : 0;
+                        command += (data->rc5_bits & 0x01000) ? 0 : 0x40;
+			scancode = system << 8 | command;
+
+			IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
+				   scancode, toggle);
+			ir_keydown(input_dev, scancode, toggle);
 		}
-		return 0;
-	case STATE_TRAILER:
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-err:
-	IR_dprintk(1, "RC-5 decoded failed at %s @ %luus\n",
-		   is_pulse ? "pulse" : "space",
-		   (ev->delta.tv_nsec + 500) / 1000);
+	IR_dprintk(1, "RC5(X) decode failed at state %i (%i units, %uus)\n",
+		   data->state, d, duration);
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
@@ -264,6 +305,7 @@
 }
 
 static struct ir_raw_handler rc5_handler = {
+	.reset		= ir_rc5_reset,
 	.decode		= ir_rc5_decode,
 	.raw_register	= ir_rc5_register,
 	.raw_unregister	= ir_rc5_unregister,
Index: ir/drivers/media/video/saa7134/saa7134-input.c
===================================================================
--- ir.orig/drivers/media/video/saa7134/saa7134-input.c	2010-04-06 12:30:16.428854774 +0200
+++ ir/drivers/media/video/saa7134/saa7134-input.c	2010-04-06 12:34:44.701888094 +0200
@@ -433,8 +433,6 @@
 	struct saa7134_dev *dev = (struct saa7134_dev *)data;
 	struct card_ir *ir = dev->remote;
 
-	ir_raw_event_handle(dev->remote->dev);
-
 	ir->active = 0;
 }
 
@@ -1021,7 +1019,7 @@
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	space = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
-	ir_raw_event_store(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
+	ir_raw_event_edge(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
 
 
 	/*

