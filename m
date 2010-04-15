Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52165 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab0DOVqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 17:46:06 -0400
Subject: [PATCH 1/8] ir-core: change duration to be coded as a u32 integer
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Thu, 15 Apr 2010 23:46:00 +0200
Message-ID: <20100415214600.14142.98835.stgit@localhost.localdomain>
In-Reply-To: <20100415214520.14142.56114.stgit@localhost.localdomain>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch implements the agreed upon 1:31 integer encoded pulse/duration
struct for ir-core raw decoders. All decoders have been tested after the
change. Comments are welcome.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-core-priv.h   |   49 ++++----
 drivers/media/IR/ir-nec-decoder.c |  120 +++++++++++---------
 drivers/media/IR/ir-raw-event.c   |   30 +++--
 drivers/media/IR/ir-rc5-decoder.c |  105 ++++++++----------
 drivers/media/IR/ir-rc6-decoder.c |  221 +++++++++++++++++++------------------
 5 files changed, 271 insertions(+), 254 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index ef7f543..707beeb 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -21,7 +21,7 @@
 struct ir_raw_handler {
 	struct list_head list;
 
-	int (*decode)(struct input_dev *input_dev, s64 duration);
+	int (*decode)(struct input_dev *input_dev, struct ir_raw_event event);
 	int (*raw_register)(struct input_dev *input_dev);
 	int (*raw_unregister)(struct input_dev *input_dev);
 };
@@ -35,26 +35,28 @@ struct ir_raw_event_ctrl {
 };
 
 /* macros for IR decoders */
-#define PULSE(units)				((units))
-#define SPACE(units)				(-(units))
-#define IS_RESET(duration)			((duration) == 0)
-#define IS_PULSE(duration)			((duration) > 0)
-#define IS_SPACE(duration)			((duration) < 0)
-#define DURATION(duration)			(abs((duration)))
-#define IS_TRANSITION(x, y)			((x) * (y) < 0)
-#define DECREASE_DURATION(duration, amount)			\
-	do {							\
-		if (IS_SPACE(duration))				\
-			duration += (amount);			\
-		else if (IS_PULSE(duration))			\
-			duration -= (amount);			\
-	} while (0)
-
-#define TO_UNITS(duration, unit_len)				\
-	((int)((duration) > 0 ?					\
-		DIV_ROUND_CLOSEST(abs((duration)), (unit_len)) :\
-		-DIV_ROUND_CLOSEST(abs((duration)), (unit_len))))
-#define TO_US(duration)		((int)TO_UNITS(duration, 1000))
+static inline bool geq_margin(unsigned d1, unsigned d2, unsigned margin) {
+	return d1 > (d2 - margin);
+}
+
+static inline bool eq_margin(unsigned d1, unsigned d2, unsigned margin) {
+	return ((d1 > (d2 - margin)) && (d1 < (d2 + margin)));
+}
+
+static inline bool is_transition(struct ir_raw_event *x, struct ir_raw_event *y) {
+	return x->pulse != y->pulse;
+}
+
+static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration) {
+	if (duration > ev->duration)
+		ev->duration = 0;
+	else
+		ev->duration -= duration;
+}
+
+#define TO_US(duration)			(((duration) + 500) / 1000)
+#define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
+#define IS_RESET(ev)			(ev.duration == 0)
 
 /*
  * Routines from ir-keytable.c to be used internally on ir-core and decoders
@@ -76,11 +78,6 @@ void ir_unregister_class(struct input_dev *input_dev);
  */
 int ir_raw_event_register(struct input_dev *input_dev);
 void ir_raw_event_unregister(struct input_dev *input_dev);
-static inline void ir_raw_event_reset(struct input_dev *input_dev)
-{
-	ir_raw_event_store(input_dev, 0);
-	ir_raw_event_handle(input_dev);
-}
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 14609d9..ba79233 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -17,13 +17,15 @@
 
 #define NEC_NBITS		32
 #define NEC_UNIT		562500  /* ns */
-#define NEC_HEADER_PULSE	PULSE(16)
-#define NECX_HEADER_PULSE	PULSE(8) /* Less common NEC variant */
-#define NEC_HEADER_SPACE	SPACE(8)
-#define NEC_REPEAT_SPACE	SPACE(4)
-#define NEC_BIT_PULSE		PULSE(1)
-#define NEC_BIT_0_SPACE		SPACE(1)
-#define NEC_BIT_1_SPACE		SPACE(3)
+#define NEC_HEADER_PULSE	(16 * NEC_UNIT)
+#define NECX_HEADER_PULSE	(8  * NEC_UNIT) /* Less common NEC variant */
+#define NEC_HEADER_SPACE	(8  * NEC_UNIT)
+#define NEC_REPEAT_SPACE	(8  * NEC_UNIT)
+#define NEC_BIT_PULSE		(1  * NEC_UNIT)
+#define NEC_BIT_0_SPACE		(1  * NEC_UNIT)
+#define NEC_BIT_1_SPACE		(3  * NEC_UNIT)
+#define	NEC_TRAILER_PULSE	(1  * NEC_UNIT)
+#define	NEC_TRAILER_SPACE	(10 * NEC_UNIT) /* even longer in reality */
 
 /* Used to register nec_decoder clients */
 static LIST_HEAD(decoder_list);
@@ -119,15 +121,14 @@ static struct attribute_group decoder_attribute_group = {
 /**
  * ir_nec_decode() - Decode one NEC pulse or space
  * @input_dev:	the struct input_dev descriptor of the device
- * @duration:	duration in ns of pulse/space
+ * @duration:	the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_nec_decode(struct input_dev *input_dev, s64 duration)
+static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int u;
 	u32 scancode;
 	u8 address, not_address, command, not_command;
 
@@ -138,59 +139,88 @@ static int ir_nec_decode(struct input_dev *input_dev, s64 duration)
 	if (!data->enabled)
 		return 0;
 
-	if (IS_RESET(duration)) {
+	if (IS_RESET(ev)) {
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	u = TO_UNITS(duration, NEC_UNIT);
-	if (DURATION(u) == 0)
-		goto out;
-
-	IR_dprintk(2, "NEC decode started at state %d (%i units, %ius)\n",
-		   data->state, u, TO_US(duration));
+	IR_dprintk(2, "NEC decode started at state %d (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (u == NEC_HEADER_PULSE || u == NECX_HEADER_PULSE) {
-			data->count = 0;
-			data->state = STATE_HEADER_SPACE;
-		}
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT / 2) &&
+		    !eq_margin(ev.duration, NECX_HEADER_PULSE, NEC_UNIT / 2))
+			break;
+
+		data->count = 0;
+		data->state = STATE_HEADER_SPACE;
 		return 0;
 
 	case STATE_HEADER_SPACE:
-		if (u == NEC_HEADER_SPACE) {
+		if (ev.pulse)
+			break;
+
+		if (eq_margin(ev.duration, NEC_HEADER_SPACE, NEC_UNIT / 2)) {
 			data->state = STATE_BIT_PULSE;
 			return 0;
-		} else if (u == NEC_REPEAT_SPACE) {
+		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
 			ir_repeat(input_dev);
 			IR_dprintk(1, "Repeat last key\n");
 			data->state = STATE_TRAILER_PULSE;
 			return 0;
 		}
+
 		break;
 
 	case STATE_BIT_PULSE:
-		if (u == NEC_BIT_PULSE) {
-			data->state = STATE_BIT_SPACE;
-			return 0;
-		}
-		break;
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, NEC_BIT_PULSE, NEC_UNIT / 2))
+			break;
+
+		data->state = STATE_BIT_SPACE;
+		return 0;
 
 	case STATE_BIT_SPACE:
-		if (u != NEC_BIT_0_SPACE && u != NEC_BIT_1_SPACE)
+		if (ev.pulse)
 			break;
 
 		data->nec_bits <<= 1;
-		if (u == NEC_BIT_1_SPACE)
+		if (eq_margin(ev.duration, NEC_BIT_1_SPACE, NEC_UNIT / 2))
 			data->nec_bits |= 1;
+		else if (!eq_margin(ev.duration, NEC_BIT_0_SPACE, NEC_UNIT / 2))
+			break;
 		data->count++;
 
-		if (data->count != NEC_NBITS) {
+		if (data->count == NEC_NBITS)
+			data->state = STATE_TRAILER_PULSE;
+		else
 			data->state = STATE_BIT_PULSE;
-			return 0;
-		}
+
+		return 0;
+
+	case STATE_TRAILER_PULSE:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, NEC_TRAILER_PULSE, NEC_UNIT / 2))
+			break;
+
+		data->state = STATE_TRAILER_SPACE;
+		return 0;
+
+	case STATE_TRAILER_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
+			break;
 
 		address     = bitrev8((data->nec_bits >> 24) & 0xff);
 		not_address = bitrev8((data->nec_bits >> 16) & 0xff);
@@ -210,34 +240,18 @@ static int ir_nec_decode(struct input_dev *input_dev, s64 duration)
 				   command;
 			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
 		} else {
-			/* normal NEC */
+			/* Normal NEC */
 			scancode = address << 8 | command;
 			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
 		}
 
 		ir_keydown(input_dev, scancode, 0);
-		data->state = STATE_TRAILER_PULSE;
+		data->state = STATE_INACTIVE;
 		return 0;
-
-	case STATE_TRAILER_PULSE:
-		if (u > 0) {
-			data->state = STATE_TRAILER_SPACE;
-			return 0;
-		}
-		break;
-
-	case STATE_TRAILER_SPACE:
-		if (u < 0) {
-			data->state = STATE_INACTIVE;
-			return 0;
-		}
-
-		break;
 	}
 
-out:
-	IR_dprintk(1, "NEC decode failed at state %d (%i units, %ius)\n",
-		   data->state, u, TO_US(duration));
+	IR_dprintk(1, "NEC decode failed at state %d (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 674442b..59f173c 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -57,12 +57,12 @@ static struct work_struct wq_load;
 
 static void ir_raw_event_work(struct work_struct *work)
 {
-	s64 d;
+	struct ir_raw_event ev;
 	struct ir_raw_event_ctrl *raw =
 		container_of(work, struct ir_raw_event_ctrl, rx_work);
 
-	while (kfifo_out(&raw->kfifo, &d, sizeof(d)) == sizeof(d))
-		RUN_DECODER(decode, raw->input_dev, d);
+	while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev))
+		RUN_DECODER(decode, raw->input_dev, ev);
 }
 
 int ir_raw_event_register(struct input_dev *input_dev)
@@ -114,21 +114,21 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 /**
  * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
  * @input_dev:	the struct input_dev device descriptor
- * @duration:	duration of the pulse or space in ns
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This routine (which may be called from an interrupt context) stores a
  * pulse/space duration for the raw ir decoding state machines. Pulses are
  * signalled as positive values and spaces as negative values. A zero value
  * will reset the decoding state machines.
  */
-int ir_raw_event_store(struct input_dev *input_dev, s64 duration)
+int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev)
 {
 	struct ir_input_dev *ir = input_get_drvdata(input_dev);
 
 	if (!ir->raw)
 		return -EINVAL;
 
-	if (kfifo_in(&ir->raw->kfifo, &duration, sizeof(duration)) != sizeof(duration))
+	if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
 		return -ENOMEM;
 
 	return 0;
@@ -151,6 +151,7 @@ int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type typ
 	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
 	ktime_t			now;
 	s64			delta; /* ns */
+	struct ir_raw_event	ev;
 	int			rc = 0;
 
 	if (!ir->raw)
@@ -163,16 +164,21 @@ int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type typ
 	 * being called for the first time, note that delta can't
 	 * possibly be negative.
 	 */
-	if (delta > NSEC_PER_SEC || !ir->raw->last_type)
+	ev.duration = 0;
+	if (delta > IR_MAX_DURATION || !ir->raw->last_type)
 		type |= IR_START_EVENT;
+	else
+		ev.duration = delta;
 
 	if (type & IR_START_EVENT)
 		ir_raw_event_reset(input_dev);
-	else if (ir->raw->last_type & IR_SPACE)
-		rc = ir_raw_event_store(input_dev, -delta);
-	else if (ir->raw->last_type & IR_PULSE)
-		rc = ir_raw_event_store(input_dev, delta);
-	else
+	else if (ir->raw->last_type & IR_SPACE) {
+		ev.pulse = false;
+		rc = ir_raw_event_store(input_dev, &ev);
+	} else if (ir->raw->last_type & IR_PULSE) {
+		ev.pulse = true;
+		rc = ir_raw_event_store(input_dev, &ev);
+	} else
 		return 0;
 
 	ir->raw->last_event = now;
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index dd5a4d5..23cdb1b 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -25,8 +25,10 @@
 #define RC5_NBITS		14
 #define RC5X_NBITS		20
 #define CHECK_RC5X_NBITS	8
-#define RC5X_SPACE		SPACE(4)
 #define RC5_UNIT		888888 /* ns */
+#define RC5_BIT_START		(1 * RC5_UNIT)
+#define RC5_BIT_END		(1 * RC5_UNIT)
+#define RC5X_SPACE		(4 * RC5_UNIT)
 
 /* Used to register rc5_decoder clients */
 static LIST_HEAD(decoder_list);
@@ -48,7 +50,7 @@ struct decoder_data {
 	/* State machine control */
 	enum rc5_state		state;
 	u32			rc5_bits;
-	int			last_unit;
+	struct ir_raw_event	prev_ev;
 	unsigned		count;
 	unsigned		wanted_bits;
 };
@@ -124,17 +126,16 @@ static struct attribute_group decoder_attribute_group = {
 /**
  * ir_rc5_decode() - Decode one RC-5 pulse or space
  * @input_dev:	the struct input_dev descriptor of the device
- * @duration:	duration of pulse/space in ns
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc5_decode(struct input_dev *input_dev, s64 duration)
+static int ir_rc5_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	u8 toggle;
 	u32 scancode;
-	int u;
 
 	data = get_decoder_data(ir_dev);
 	if (!data)
@@ -143,76 +144,65 @@ static int ir_rc5_decode(struct input_dev *input_dev, s64 duration)
 	if (!data->enabled)
 		return 0;
 
-	if (IS_RESET(duration)) {
+	if (IS_RESET(ev)) {
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	u = TO_UNITS(duration, RC5_UNIT);
-	if (DURATION(u) == 0)
+	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
 		goto out;
 
 again:
-	IR_dprintk(2, "RC5(x) decode started at state %i (%i units, %ius)\n",
-		   data->state, u, TO_US(duration));
+	IR_dprintk(2, "RC5(x) decode started at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
-	if (DURATION(u) == 0 && data->state != STATE_FINISHED)
+	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
 		return 0;
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (IS_PULSE(u)) {
-			data->state = STATE_BIT_START;
-			data->count = 1;
-			/* We just need enough bits to get to STATE_CHECK_RC5X */
-			data->wanted_bits = RC5X_NBITS;
-			DECREASE_DURATION(u, 1);
-			goto again;
-		}
-		break;
+		if (!ev.pulse)
+			break;
+
+		data->state = STATE_BIT_START;
+		data->count = 1;
+		/* We just need enough bits to get to STATE_CHECK_RC5X */
+		data->wanted_bits = RC5X_NBITS;
+		decrease_duration(&ev, RC5_BIT_START);
+		goto again;
 
 	case STATE_BIT_START:
-		if (DURATION(u) == 1) {
-			data->rc5_bits <<= 1;
-			if (IS_SPACE(u))
-				data->rc5_bits |= 1;
-			data->count++;
-			data->last_unit = u;
-
-			/*
-			 * If the last bit is zero, a space will merge
-			 * with the silence after the command.
-			 */
-			if (IS_PULSE(u) && data->count == data->wanted_bits) {
-				data->state = STATE_FINISHED;
-				goto again;
-			}
-
-			data->state = STATE_BIT_END;
-			return 0;
-		}
-		break;
+		if (!eq_margin(ev.duration, RC5_BIT_START, RC5_UNIT / 2))
+			break;
+
+		data->rc5_bits <<= 1;
+		if (!ev.pulse)
+			data->rc5_bits |= 1;
+		data->count++;
+		data->prev_ev = ev;
+		data->state = STATE_BIT_END;
+		return 0;
 
 	case STATE_BIT_END:
-		if (IS_TRANSITION(u, data->last_unit)) {
-			if (data->count == data->wanted_bits)
-				data->state = STATE_FINISHED;
-			else if (data->count == CHECK_RC5X_NBITS)
-				data->state = STATE_CHECK_RC5X;
-			else
-				data->state = STATE_BIT_START;
-
-			DECREASE_DURATION(u, 1);
-			goto again;
-		}
-		break;
+		if (!is_transition(&ev, &data->prev_ev))
+			break;
+
+		if (data->count == data->wanted_bits)
+			data->state = STATE_FINISHED;
+		else if (data->count == CHECK_RC5X_NBITS)
+			data->state = STATE_CHECK_RC5X;
+		else
+			data->state = STATE_BIT_START;
+
+		decrease_duration(&ev, RC5_BIT_END);
+		goto again;
 
 	case STATE_CHECK_RC5X:
-		if (IS_SPACE(u) && DURATION(u) >= DURATION(RC5X_SPACE)) {
+		if (!ev.pulse && geq_margin(ev.duration, RC5X_SPACE, RC5_UNIT / 2)) {
 			/* RC5X */
 			data->wanted_bits = RC5X_NBITS;
-			DECREASE_DURATION(u, DURATION(RC5X_SPACE));
+			decrease_duration(&ev, RC5X_SPACE);
 		} else {
 			/* RC5 */
 			data->wanted_bits = RC5_NBITS;
@@ -221,6 +211,9 @@ again:
 		goto again;
 
 	case STATE_FINISHED:
+		if (ev.pulse)
+			break;
+
 		if (data->wanted_bits == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
@@ -253,8 +246,8 @@ again:
 	}
 
 out:
-	IR_dprintk(1, "RC5(x) decode failed at state %i (%i units, %ius)\n",
-		   data->state, u, TO_US(duration));
+	IR_dprintk(1, "RC5(x) decode failed at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/IR/ir-rc6-decoder.c
index ccc5be2..2bf479f 100644
--- a/drivers/media/IR/ir-rc6-decoder.c
+++ b/drivers/media/IR/ir-rc6-decoder.c
@@ -26,8 +26,12 @@
 #define RC6_0_NBITS		16
 #define RC6_6A_SMALL_NBITS	24
 #define RC6_6A_LARGE_NBITS	32
-#define RC6_PREFIX_PULSE	PULSE(6)
-#define RC6_PREFIX_SPACE	SPACE(2)
+#define RC6_PREFIX_PULSE	(6 * RC6_UNIT)
+#define RC6_PREFIX_SPACE	(2 * RC6_UNIT)
+#define RC6_BIT_START		(1 * RC6_UNIT)
+#define RC6_BIT_END		(1 * RC6_UNIT)
+#define RC6_TOGGLE_START	(2 * RC6_UNIT)
+#define RC6_TOGGLE_END		(2 * RC6_UNIT)
 #define RC6_MODE_MASK		0x07	/* for the header bits */
 #define RC6_STARTBIT_MASK	0x08	/* for the header bits */
 #define RC6_6A_MCE_TOGGLE_MASK	0x8000	/* for the body bits */
@@ -63,7 +67,7 @@ struct decoder_data {
 	enum rc6_state		state;
 	u8			header;
 	u32			body;
-	int			last_unit;
+	struct ir_raw_event	prev_ev;
 	bool			toggle;
 	unsigned		count;
 	unsigned		wanted_bits;
@@ -152,17 +156,16 @@ static enum rc6_mode rc6_mode(struct decoder_data *data) {
 /**
  * ir_rc6_decode() - Decode one RC6 pulse or space
  * @input_dev:	the struct input_dev descriptor of the device
- * @duration:	duration of pulse/space in ns
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int ir_rc6_decode(struct input_dev *input_dev, s64 duration)
+static int ir_rc6_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	u32 scancode;
 	u8 toggle;
-	int u;
 
 	data = get_decoder_data(ir_dev);
 	if (!data)
@@ -171,140 +174,144 @@ static int ir_rc6_decode(struct input_dev *input_dev, s64 duration)
 	if (!data->enabled)
 		return 0;
 
-	if (IS_RESET(duration)) {
+	if (IS_RESET(ev)) {
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	u =  TO_UNITS(duration, RC6_UNIT);
-	if (DURATION(u) == 0)
+	if (!geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
 		goto out;
 
 again:
-	IR_dprintk(2, "RC6 decode started at state %i (%i units, %ius)\n",
-		   data->state, u, TO_US(duration));
+	IR_dprintk(2, "RC6 decode started at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
-	if (DURATION(u) == 0 && data->state != STATE_FINISHED)
+	if (!geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
 		return 0;
 
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (u >= RC6_PREFIX_PULSE - 1 && u <= RC6_PREFIX_PULSE + 1) {
-			data->state = STATE_PREFIX_SPACE;
-			data->count = 0;
-			return 0;
-		}
-		break;
+		if (!ev.pulse)
+			break;
+
+		/* Note: larger margin on first pulse since each RC6_UNIT
+		   is quite short and some hardware takes some time to
+		   adjust to the signal */
+		if (!eq_margin(ev.duration, RC6_PREFIX_PULSE, RC6_UNIT))
+			break;
+
+		data->state = STATE_PREFIX_SPACE;
+		data->count = 0;
+		return 0;
 
 	case STATE_PREFIX_SPACE:
-		if (u == RC6_PREFIX_SPACE) {
-			data->state = STATE_HEADER_BIT_START;
-			return 0;
-		}
-		break;
+		if (ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, RC6_PREFIX_SPACE, RC6_UNIT / 2))
+			break;
+
+		data->state = STATE_HEADER_BIT_START;
+		return 0;
 
 	case STATE_HEADER_BIT_START:
-		if (DURATION(u) == 1) {
-			data->header <<= 1;
-			if (IS_PULSE(u))
-				data->header |= 1;
-			data->count++;
-			data->last_unit = u;
-			data->state = STATE_HEADER_BIT_END;
-			return 0;
-		}
-		break;
+		if (!eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2))
+			break;
+
+		data->header <<= 1;
+		if (ev.pulse)
+			data->header |= 1;
+		data->count++;
+		data->prev_ev = ev;
+		data->state = STATE_HEADER_BIT_END;
+		return 0;
 
 	case STATE_HEADER_BIT_END:
-		if (IS_TRANSITION(u, data->last_unit)) {
-			if (data->count == RC6_HEADER_NBITS)
-				data->state = STATE_TOGGLE_START;
-			else
-				data->state = STATE_HEADER_BIT_START;
+		if (!is_transition(&ev, &data->prev_ev))
+			break;
 
-			DECREASE_DURATION(u, 1);
-			goto again;
-		}
-		break;
+		if (data->count == RC6_HEADER_NBITS)
+			data->state = STATE_TOGGLE_START;
+		else
+			data->state = STATE_HEADER_BIT_START;
+
+		decrease_duration(&ev, RC6_BIT_END);
+		goto again;
 
 	case STATE_TOGGLE_START:
-		if (DURATION(u) == 2) {
-			data->toggle = IS_PULSE(u);
-			data->last_unit = u;
-			data->state = STATE_TOGGLE_END;
-			return 0;
-		}
-		break;
+		if (!eq_margin(ev.duration, RC6_TOGGLE_START, RC6_UNIT / 2))
+			break;
+
+		data->toggle = ev.pulse;
+		data->prev_ev = ev;
+		data->state = STATE_TOGGLE_END;
+		return 0;
 
 	case STATE_TOGGLE_END:
-		if (IS_TRANSITION(u, data->last_unit) && DURATION(u) >= 2) {
-			data->state = STATE_BODY_BIT_START;
-			data->last_unit = u;
-			DECREASE_DURATION(u, 2);
-			data->count = 0;
+		if (!is_transition(&ev, &data->prev_ev) ||
+		    !geq_margin(ev.duration, RC6_TOGGLE_END, RC6_UNIT / 2))
+			break;
 
-			if (!(data->header & RC6_STARTBIT_MASK)) {
-				IR_dprintk(1, "RC6 invalid start bit\n");
-				break;
-			}
+		if (!(data->header & RC6_STARTBIT_MASK)) {
+			IR_dprintk(1, "RC6 invalid start bit\n");
+			break;
+		}
 
-			switch (rc6_mode(data)) {
-			case RC6_MODE_0:
-				data->wanted_bits = RC6_0_NBITS;
-				break;
-			case RC6_MODE_6A:
-				/* This might look weird, but we basically
-				   check the value of the first body bit to
-				   determine the number of bits in mode 6A */
-				if ((DURATION(u) == 0 && IS_SPACE(data->last_unit)) || DURATION(u) > 0)
-					data->wanted_bits = RC6_6A_LARGE_NBITS;
-				else
-					data->wanted_bits = RC6_6A_SMALL_NBITS;
-				break;
-			default:
-				IR_dprintk(1, "RC6 unknown mode\n");
-				goto out;
-			}
-			goto again;
+		data->state = STATE_BODY_BIT_START;
+		data->prev_ev = ev;
+		decrease_duration(&ev, RC6_TOGGLE_END);
+		data->count = 0;
+
+		switch (rc6_mode(data)) {
+		case RC6_MODE_0:
+			data->wanted_bits = RC6_0_NBITS;
+			break;
+		case RC6_MODE_6A:
+			/* This might look weird, but we basically
+			   check the value of the first body bit to
+			   determine the number of bits in mode 6A */
+			if ((!ev.pulse && !geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2)) ||
+			    geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
+				data->wanted_bits = RC6_6A_LARGE_NBITS;
+			else
+				data->wanted_bits = RC6_6A_SMALL_NBITS;
+			break;
+		default:
+			IR_dprintk(1, "RC6 unknown mode\n");
+			goto out;
 		}
-		break;
+		goto again;
 
 	case STATE_BODY_BIT_START:
-		if (DURATION(u) == 1) {
-			data->body <<= 1;
-			if (IS_PULSE(u))
-				data->body |= 1;
-			data->count++;
-			data->last_unit = u;
-
-			/*
-			 * If the last bit is one, a space will merge
-			 * with the silence after the command.
-			 */
-			if (IS_PULSE(u) && data->count == data->wanted_bits) {
-				data->state = STATE_FINISHED;
-				goto again;
-			}
+		if (!eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2))
+			break;
 
-			data->state = STATE_BODY_BIT_END;
-			return 0;
-		}
-		break;
+		data->body <<= 1;
+		if (ev.pulse)
+			data->body |= 1;
+		data->count++;
+		data->prev_ev = ev;
+
+		data->state = STATE_BODY_BIT_END;
+		return 0;
 
 	case STATE_BODY_BIT_END:
-		if (IS_TRANSITION(u, data->last_unit)) {
-			if (data->count == data->wanted_bits)
-				data->state = STATE_FINISHED;
-			else
-				data->state = STATE_BODY_BIT_START;
+		if (!is_transition(&ev, &data->prev_ev))
+			break;
 
-			DECREASE_DURATION(u, 1);
-			goto again;
-		}
-		break;
+		if (data->count == data->wanted_bits)
+			data->state = STATE_FINISHED;
+		else
+			data->state = STATE_BODY_BIT_START;
+
+		decrease_duration(&ev, RC6_BIT_END);
+		goto again;
 
 	case STATE_FINISHED:
+		if (ev.pulse)
+			break;
+
 		switch (rc6_mode(data)) {
 		case RC6_MODE_0:
 			scancode = data->body & 0xffff;
@@ -335,8 +342,8 @@ again:
 	}
 
 out:
-	IR_dprintk(1, "RC6 decode failed at state %i (%i units, %ius)\n",
-		   data->state, u, TO_US(duration));
+	IR_dprintk(1, "RC6 decode failed at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index ab3bd30..26110cc 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -127,9 +127,21 @@ void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
 
 /* From ir-raw-event.c */
 
+struct ir_raw_event {
+	unsigned                        pulse:1;
+	unsigned                        duration:31;
+};
+
+#define IR_MAX_DURATION                 0x7FFFFFFF      /* a bit more than 2 seconds */
+
 void ir_raw_event_handle(struct input_dev *input_dev);
-int ir_raw_event_store(struct input_dev *input_dev, s64 duration);
+int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
 int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
-
+static inline void ir_raw_event_reset(struct input_dev *input_dev)
+{
+	struct ir_raw_event ev = { .pulse = false, .duration = 0 };
+	ir_raw_event_store(input_dev, &ev);
+	ir_raw_event_handle(input_dev);
+}
 
 #endif /* _IR_CORE */

