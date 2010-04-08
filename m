Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933150Ab0DHThc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 15:37:32 -0400
Date: Thu, 8 Apr 2010 16:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 7/8] V4L/DVB: Teach drivers/media/IR/ir-raw-event.c to use
 durations
Message-ID: <20100408163717.085f33fc@pedra>
In-Reply-To: <cover.1270754989.git.mchehab@redhat.com>
References: <cover.1270754989.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: David Härdeman <david@hardeman.nu>

drivers/media/IR/ir-raw-event.c is currently written with the assumption
that all "raw" hardware will generate events only on state change (i.e.
when a pulse or space starts).

However, some hardware (like mceusb, probably the most popular IR receiver
out there) only generates duration data (and that data is buffered so using
any kind of timing on the data is futile).

Furthermore, using signed int's to represent pulse/space durations is a
well-known approach when writing ir decoders.

With this patch:

- s64 int's are used to represent pulse/space durations in ns

- a workqueue is used to decode the ir protocols outside of interrupt context

- #defines are added to make decoders clearer

- decoder reset is implemented by passing a zero duration to the kfifo queue
  and decoders are updated accordingly

Signed-off-by: David Härdeman <david@hardeman.nu>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 48a86cc..5085f90 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -13,15 +13,16 @@
  */
 
 #include <media/ir-core.h>
+#include <linux/bitrev.h>
 
 #define NEC_NBITS		32
-#define NEC_UNIT		559979 /* ns */
-#define NEC_HEADER_MARK		(16 * NEC_UNIT)
-#define NEC_HEADER_SPACE	(8 * NEC_UNIT)
-#define NEC_REPEAT_SPACE	(4 * NEC_UNIT)
-#define NEC_MARK		(NEC_UNIT)
-#define NEC_0_SPACE		(NEC_UNIT)
-#define NEC_1_SPACE		(3 * NEC_UNIT)
+#define NEC_UNIT		562500  /* ns */
+#define NEC_HEADER_PULSE	PULSE(16)
+#define NEC_HEADER_SPACE	SPACE(8)
+#define NEC_REPEAT_SPACE	SPACE(4)
+#define NEC_BIT_PULSE		PULSE(1)
+#define NEC_BIT_0_SPACE		SPACE(1)
+#define NEC_BIT_1_SPACE		SPACE(3)
 
 /* Used to register nec_decoder clients */
 static LIST_HEAD(decoder_list);
@@ -29,21 +30,13 @@ DEFINE_SPINLOCK(decoder_lock);
 
 enum nec_state {
 	STATE_INACTIVE,
-	STATE_HEADER_MARK,
 	STATE_HEADER_SPACE,
-	STATE_MARK,
-	STATE_SPACE,
-	STATE_TRAILER_MARK,
+	STATE_BIT_PULSE,
+	STATE_BIT_SPACE,
+	STATE_TRAILER_PULSE,
 	STATE_TRAILER_SPACE,
 };
 
-struct nec_code {
-	u8	address;
-	u8	not_address;
-	u8	command;
-	u8	not_command;
-};
-
 struct decoder_data {
 	struct list_head	list;
 	struct ir_input_dev	*ir_dev;
@@ -51,7 +44,7 @@ struct decoder_data {
 
 	/* State machine control */
 	enum nec_state		state;
-	struct nec_code		nec_code;
+	u32			nec_bits;
 	unsigned		count;
 };
 
@@ -62,7 +55,6 @@ struct decoder_data {
  *
  * Returns the struct decoder_data that corresponds to a device
  */
-
 static struct decoder_data *get_decoder_data(struct  ir_input_dev *ir_dev)
 {
 	struct decoder_data *data = NULL;
@@ -123,20 +115,20 @@ static struct attribute_group decoder_attribute_group = {
 	.attrs	= decoder_attributes,
 };
 
-
 /**
  * ir_nec_decode() - Decode one NEC pulse or space
  * @input_dev:	the struct input_dev descriptor of the device
- * @ev:		event array with type/duration of pulse/space
+ * @duration:	duration in ns of pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_nec_decode(struct input_dev *input_dev,
-			 struct ir_raw_event *ev)
+static int ir_nec_decode(struct input_dev *input_dev, s64 duration)
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int bit, last_bit;
+	int u;
+	u32 scancode;
+	u8 address, not_address, command, not_command;
 
 	data = get_decoder_data(ir_dev);
 	if (!data)
@@ -145,151 +137,108 @@ static int ir_nec_decode(struct input_dev *input_dev,
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
+	if (IS_RESET(duration)) {
 		data->state = STATE_INACTIVE;
+		return 0;
+	}
 
-	if (ev->type & IR_START_EVENT)
-		data->state = STATE_INACTIVE;
+	u = TO_UNITS(duration, NEC_UNIT);
+	if (DURATION(u) == 0)
+		goto out;
+
+	IR_dprintk(2, "NEC decode started at state %d (%i units, %ius)\n",
+		   data->state, u, TO_US(duration));
 
 	switch (data->state) {
+
 	case STATE_INACTIVE:
-		if (!bit)		/* PULSE marks the start event */
-			return 0;
+		if (u == NEC_HEADER_PULSE) {
+			data->count = 0;
+			data->state = STATE_HEADER_SPACE;
+		}
+		return 0;
 
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
-		return 0;
 	case STATE_HEADER_SPACE:
-		if (last_bit)
-			goto err;
-		if (ev->delta.tv_nsec >= NEC_HEADER_SPACE - NEC_UNIT / 2) {
-			data->state = STATE_MARK;
+		if (u == NEC_HEADER_SPACE) {
+			data->state = STATE_BIT_PULSE;
 			return 0;
-		}
-
-		if (ev->delta.tv_nsec >= NEC_REPEAT_SPACE - NEC_UNIT / 2) {
+		} else if (u == NEC_REPEAT_SPACE) {
 			ir_repeat(input_dev);
 			IR_dprintk(1, "Repeat last key\n");
-			data->state = STATE_TRAILER_MARK;
+			data->state = STATE_TRAILER_PULSE;
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
+		break;
+
+	case STATE_BIT_PULSE:
+		if (u == NEC_BIT_PULSE) {
+			data->state = STATE_BIT_SPACE;
+			return 0;
+		}
+		break;
+
+	case STATE_BIT_SPACE:
+		if (u != NEC_BIT_0_SPACE && u != NEC_BIT_1_SPACE)
+			break;
 
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
+		data->nec_bits <<= 1;
+		if (u == NEC_BIT_1_SPACE)
+			data->nec_bits |= 1;
+		data->count++;
 
-			goto err2;
+		if (data->count != NEC_NBITS) {
+			data->state = STATE_BIT_PULSE;
+			return 0;
 		}
 
-		/* Ok, we've got a valid bit. proccess it */
-		if (bit) {
-			int shift = data->count;
+		address     = bitrev8((data->nec_bits >> 24) & 0xff);
+		not_address = bitrev8((data->nec_bits >> 16) & 0xff);
+		command	    = bitrev8((data->nec_bits >>  8) & 0xff);
+		not_command = bitrev8((data->nec_bits >>  0) & 0xff);
 
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
-			}
+		if ((command ^ not_command) != 0xff) {
+			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
+				   data->nec_bits);
+			break;
 		}
-		if (++data->count == NEC_NBITS) {
-			u32 scancode;
-			/*
-			 * Fixme: may need to accept Extended NEC protocol?
-			 */
-			if ((data->nec_code.command ^ data->nec_code.not_command) != 0xff)
-				goto checksum_err;
 
-			if ((data->nec_code.address ^ data->nec_code.not_address) != 0xff) {
-				/* Extended NEC */
-				scancode = data->nec_code.address << 16 |
-					   data->nec_code.not_address << 8 |
-					   data->nec_code.command;
-				IR_dprintk(1, "NEC scancode 0x%06x\n", scancode);
-			} else {
-				/* normal NEC */
-				scancode = data->nec_code.address << 8 |
-					   data->nec_code.command;
-				IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
-			}
-			ir_keydown(input_dev, scancode, 0);
+		if ((address ^ not_address) != 0xff) {
+			/* Extended NEC */
+			scancode = address     << 16 |
+				   not_address <<  8 |
+				   command;
+			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
+		} else {
+			/* normal NEC */
+			scancode = address << 8 | command;
+			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
+		}
 
-			data->state = STATE_TRAILER_MARK;
-		} else
-			data->state = STATE_MARK;
-		return 0;
-	case STATE_TRAILER_MARK:
-		if (!last_bit)
-			goto err;
-		data->state = STATE_TRAILER_SPACE;
+		ir_keydown(input_dev, scancode, 0);
+		data->state = STATE_TRAILER_PULSE;
 		return 0;
+
+	case STATE_TRAILER_PULSE:
+		if (u > 0) {
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
+		if (u < 0) {
+			data->state = STATE_INACTIVE;
+			return 0;
+		}
+
+		break;
 	}
 
-err:
-	IR_dprintk(1, "NEC decoded failed at state %d (%s) @ %luus\n",
-		   data->state,
-		   bit ? "pulse" : "space",
-		   (ev->delta.tv_nsec + 500) / 1000);
-err2:
+out:
+	IR_dprintk(1, "NEC decode failed at state %d (%i units, %ius)\n",
+		   data->state, u, TO_US(duration));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
-
-checksum_err:
-	data->state = STATE_INACTIVE;
-	IR_dprintk(1, "NEC checksum error: received 0x%02x%02x%02x%02x\n",
-		   data->nec_code.address,
-		   data->nec_code.not_address,
-		   data->nec_code.command,
-		   data->nec_code.not_command);
-	return -EINVAL;
 }
 
 static int ir_nec_register(struct input_dev *input_dev)
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 5b121d8..3a25d8d 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -15,9 +15,10 @@
 #include <media/ir-core.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/sched.h>
 
-/* Define the max number of bit transitions per IR keycode */
-#define MAX_IR_EVENT_SIZE	256
+/* Define the max number of pulse/space transitions to buffer */
+#define MAX_IR_EVENT_SIZE      512
 
 /* Used to handle IR raw handler extensions */
 static LIST_HEAD(ir_raw_handler_list);
@@ -53,19 +54,30 @@ DEFINE_SPINLOCK(ir_raw_handler_lock);
 /* Used to load the decoders */
 static struct work_struct wq_load;
 
+static void ir_raw_event_work(struct work_struct *work)
+{
+	s64 d;
+	struct ir_raw_event_ctrl *raw =
+		container_of(work, struct ir_raw_event_ctrl, rx_work);
+
+	while (kfifo_out(&raw->kfifo, &d, sizeof(d)) == sizeof(d))
+		RUN_DECODER(decode, raw->input_dev, d);
+}
+
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
+	ir->raw->input_dev = input_dev;
+	INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
 
-	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
+	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
+			 GFP_KERNEL);
 	if (rc < 0) {
 		kfree(ir->raw);
 		ir->raw = NULL;
@@ -90,6 +102,7 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 	if (!ir->raw)
 		return;
 
+	cancel_work_sync(&ir->raw->rx_work);
 	RUN_DECODER(raw_unregister, input_dev);
 
 	kfifo_free(&ir->raw->kfifo);
@@ -97,75 +110,91 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 	ir->raw = NULL;
 }
 
-int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)
+/**
+ * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
+ * @input_dev:	the struct input_dev device descriptor
+ * @duration:	duration of the pulse or space in ns
+ *
+ * This routine (which may be called from an interrupt context) stores a
+ * pulse/space duration for the raw ir decoding state machines. Pulses are
+ * signalled as positive values and spaces as negative values. A zero value
+ * will reset the decoding state machines.
+ */
+int ir_raw_event_store(struct input_dev *input_dev, s64 duration)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+
+	if (!ir->raw)
+		return -EINVAL;
+
+	if (kfifo_in(&ir->raw->kfifo, &duration, sizeof(duration)) != sizeof(duration))
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store);
+
+/**
+ * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
+ * @input_dev:	the struct input_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine (which may be called from an interrupt context) is used to
+ * store the beginning of an ir pulse or space (or the start/end of ir
+ * reception) for the raw ir decoding state machines. This is used by
+ * hardware which does not provide durations directly but only interrupts
+ * (or similar events) on state change.
+ */
+int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type)
 {
 	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
-	struct timespec		ts;
-	struct ir_raw_event	event;
-	int			rc;
+	ktime_t			now;
+	s64			delta; /* ns */
+	int			rc = 0;
 
 	if (!ir->raw)
 		return -EINVAL;
 
-	event.type = type;
-	event.delta.tv_sec = 0;
-	event.delta.tv_nsec = 0;
+	now = ktime_get();
+	delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
 
-	ktime_get_ts(&ts);
+	/* Check for a long duration since last event or if we're
+	 * being called for the first time, note that delta can't
+	 * possibly be negative.
+	 */
+	if (delta > NSEC_PER_SEC || !ir->raw->last_type)
+		type |= IR_START_EVENT;
 
-	if (timespec_equal(&ir->raw->last_event, &event.delta))
-		event.type |= IR_START_EVENT;
+	if (type & IR_START_EVENT)
+		ir_raw_event_reset(input_dev);
+	else if (ir->raw->last_type & IR_SPACE)
+		rc = ir_raw_event_store(input_dev, -delta);
+	else if (ir->raw->last_type & IR_PULSE)
+		rc = ir_raw_event_store(input_dev, delta);
 	else
-		event.delta = timespec_sub(ts, ir->raw->last_event);
-
-	memcpy(&ir->raw->last_event, &ts, sizeof(ts));
-
-	if (event.delta.tv_sec) {
-		event.type |= IR_START_EVENT;
-		event.delta.tv_sec = 0;
-		event.delta.tv_nsec = 0;
-	}
-
-	kfifo_in(&ir->raw->kfifo, &event, sizeof(event));
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store);
-
-int ir_raw_event_handle(struct input_dev *input_dev)
-{
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
 		return 0;
 
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
-
-	/*
-	 * Call all ir decoders. This allows decoding the same event with
-	 * more than one protocol handler.
-	 */
-
+	ir->raw->last_event = now;
+	ir->raw->last_type = type;
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
+
+/**
+ * ir_raw_event_handle() - schedules the decoding of stored ir data
+ * @input_dev:	the struct input_dev device descriptor
+ *
+ * This routine will signal the workqueue to start decoding stored ir data.
+ */
+void ir_raw_event_handle(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+
+	if (!ir->raw)
+		return;
+
+	schedule_work(&ir->raw->rx_work);
+}
 EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 
 /*
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index b8a33ae..d6def8c 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -21,11 +21,8 @@
 
 #include <media/ir-core.h>
 
-static unsigned int ir_rc5_remote_gap = 888888;
-
 #define RC5_NBITS		14
-#define RC5_BIT			(ir_rc5_remote_gap * 2)
-#define RC5_DURATION		(ir_rc5_remote_gap * RC5_NBITS)
+#define RC5_UNIT		888888 /* ns */
 
 /* Used to register rc5_decoder clients */
 static LIST_HEAD(decoder_list);
@@ -33,13 +30,9 @@ DEFINE_SPINLOCK(decoder_lock);
 
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
+	STATE_FINISHED,
 };
 
 struct decoder_data {
@@ -49,8 +42,9 @@ struct decoder_data {
 
 	/* State machine control */
 	enum rc5_state		state;
-	struct rc5_code		rc5_code;
-	unsigned		code, elapsed, last_bit, last_code;
+	u32			rc5_bits;
+	int			last_unit;
+	unsigned		count;
 };
 
 
@@ -122,18 +116,19 @@ static struct attribute_group decoder_attribute_group = {
 };
 
 /**
- * handle_event() - Decode one RC-5 pulse or space
+ * ir_rc5_decode() - Decode one RC-5 pulse or space
  * @input_dev:	the struct input_dev descriptor of the device
- * @ev:		event array with type/duration of pulse/space
+ * @duration:	duration of pulse/space in ns
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc5_decode(struct input_dev *input_dev,
-			struct ir_raw_event *ev)
+static int ir_rc5_decode(struct input_dev *input_dev, s64 duration)
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int is_pulse, scancode, delta, toggle;
+	u8 command, system, toggle;
+	u32 scancode;
+	int u;
 
 	data = get_decoder_data(ir_dev);
 	if (!data)
@@ -142,79 +137,84 @@ static int ir_rc5_decode(struct input_dev *input_dev,
 	if (!data->enabled)
 		return 0;
 
-	delta = DIV_ROUND_CLOSEST(ev->delta.tv_nsec, ir_rc5_remote_gap);
-
-	/* The duration time refers to the last bit time */
-	is_pulse = (ev->type & IR_PULSE) ? 1 : 0;
-
-	/* Very long delays are considered as start events */
-	if (delta > RC5_DURATION || (ev->type & IR_START_EVENT))
+	if (IS_RESET(duration)) {
 		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	u = TO_UNITS(duration, RC5_UNIT);
+	if (DURATION(u) == 0)
+		goto out;
+
+again:
+	IR_dprintk(2, "RC5 decode started at state %i (%i units, %ius)\n",
+		   data->state, u, TO_US(duration));
+
+	if (DURATION(u) == 0 && data->state != STATE_FINISHED)
+		return 0;
 
 	switch (data->state) {
+
 	case STATE_INACTIVE:
-	IR_dprintk(2, "currently inative. Start bit (%s) @%uus\n",
-		   is_pulse ? "pulse" : "space",
-		   (unsigned)(ev->delta.tv_nsec + 500) / 1000);
+		if (IS_PULSE(u)) {
+			data->state = STATE_BIT_START;
+			data->count = 1;
+			DECREASE_DURATION(u, 1);
+			goto again;
+		}
+		break;
 
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
+	case STATE_BIT_START:
+		if (DURATION(u) == 1) {
+			data->rc5_bits <<= 1;
+			if (IS_SPACE(u))
+				data->rc5_bits |= 1;
+			data->count++;
+			data->last_unit = u;
 
-		data->elapsed += delta;
+			/*
+			 * If the last bit is zero, a space will merge
+			 * with the silence after the command.
+			 */
+			if (IS_PULSE(u) && data->count == RC5_NBITS) {
+				data->state = STATE_FINISHED;
+				goto again;
+			}
 
-		if ((data->elapsed % 2) == 1)
+			data->state = STATE_BIT_END;
 			return 0;
+		}
+		break;
 
-		data->code <<= 1;
-		data->code |= data->last_bit;
-
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
+	case STATE_BIT_END:
+		if (IS_TRANSITION(u, data->last_unit)) {
+			if (data->count == RC5_NBITS)
+				data->state = STATE_FINISHED;
+			else
+				data->state = STATE_BIT_START;
 
-			toggle = (scancode & 0x2000) ? 1 : 0;
+			DECREASE_DURATION(u, 1);
+			goto again;
+		}
+		break;
 
-			if (scancode == data->last_code) {
-				IR_dprintk(1, "RC-5 repeat\n");
-				ir_repeat(input_dev);
-			} else {
-				data->last_code = scancode;
-				scancode &= 0x1fff;
-				IR_dprintk(1, "RC-5 scancode 0x%04x\n", scancode);
+	case STATE_FINISHED:
+		command  = (data->rc5_bits & 0x0003F) >> 0;
+		system   = (data->rc5_bits & 0x007C0) >> 6;
+		toggle   = (data->rc5_bits & 0x00800) ? 1 : 0;
+		command += (data->rc5_bits & 0x01000) ? 0 : 0x40;
+		scancode = system << 8 | command;
 
-				ir_keydown(input_dev, scancode, 0);
-			}
-			data->state = STATE_TRAILER;
-		}
-		return 0;
-	case STATE_TRAILER:
+		IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
+			   scancode, toggle);
+		ir_keydown(input_dev, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-err:
-	IR_dprintk(1, "RC-5 decoded failed at %s @ %luus\n",
-		   is_pulse ? "pulse" : "space",
-		   (ev->delta.tv_nsec + 500) / 1000);
+out:
+	IR_dprintk(1, "RC5 decode failed at state %i (%i units, %ius)\n",
+		   data->state, u, TO_US(duration));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index dc4faaf..e02c5be 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -1017,7 +1017,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	space = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
-	ir_raw_event_store(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
+	ir_raw_event_store_edge(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
 
 
 	/*
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index e9fa94f..e9a0cbf 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -65,14 +65,12 @@ struct ir_dev_props {
 	void			(*close)(void *priv);
 };
 
-struct ir_raw_event {
-	struct timespec		delta;	/* Time spent before event */
-	enum raw_event_type	type;	/* event type */
-};
-
 struct ir_raw_event_ctrl {
-	struct kfifo			kfifo;		/* fifo for the pulse/space events */
-	struct timespec			last_event;	/* when last event occurred */
+	struct work_struct		rx_work;	/* for the rx decoding workqueue */
+	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
+	ktime_t				last_event;	/* when last event occurred */
+	enum raw_event_type		last_type;	/* last event type */
+	struct input_dev		*input_dev;	/* pointer to the parent input_dev */
 };
 
 struct ir_input_dev {
@@ -97,8 +95,7 @@ struct ir_input_dev {
 struct ir_raw_handler {
 	struct list_head list;
 
-	int (*decode)(struct input_dev *input_dev,
-		      struct ir_raw_event *ev);
+	int (*decode)(struct input_dev *input_dev, s64 duration);
 	int (*raw_register)(struct input_dev *input_dev);
 	int (*raw_unregister)(struct input_dev *input_dev);
 };
@@ -154,8 +151,14 @@ void ir_unregister_class(struct input_dev *input_dev);
 /* Routines from ir-raw-event.c */
 int ir_raw_event_register(struct input_dev *input_dev);
 void ir_raw_event_unregister(struct input_dev *input_dev);
-int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type);
-int ir_raw_event_handle(struct input_dev *input_dev);
+void ir_raw_event_handle(struct input_dev *input_dev);
+int ir_raw_event_store(struct input_dev *input_dev, s64 duration);
+int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
+static inline void ir_raw_event_reset(struct input_dev *input_dev)
+{
+	ir_raw_event_store(input_dev, 0);
+	ir_raw_event_handle(input_dev);
+}
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
@@ -174,4 +177,26 @@ void ir_raw_init(void);
 #define load_rc5_decode()	0
 #endif
 
+/* macros for ir decoders */
+#define PULSE(units)				((units))
+#define SPACE(units)				(-(units))
+#define IS_RESET(duration)			((duration) == 0)
+#define IS_PULSE(duration)			((duration) > 0)
+#define IS_SPACE(duration)			((duration) < 0)
+#define DURATION(duration)			(abs((duration)))
+#define IS_TRANSITION(x, y)			((x) * (y) < 0)
+#define DECREASE_DURATION(duration, amount)			\
+	do {							\
+		if (IS_SPACE(duration))				\
+			duration += (amount);			\
+		else if (IS_PULSE(duration))			\
+			duration -= (amount);			\
+	} while (0)
+
+#define TO_UNITS(duration, unit_len)				\
+	((int)((duration) > 0 ?					\
+		DIV_ROUND_CLOSEST(abs((duration)), (unit_len)) :\
+		-DIV_ROUND_CLOSEST(abs((duration)), (unit_len))))
+#define TO_US(duration)		((int)TO_UNITS(duration, 1000))
+
 #endif /* _IR_CORE */
-- 
1.6.6.1


