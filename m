Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50491 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0H3IxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 04:53:03 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 6/7] IR: extend ir_raw_event and do refactoring
Date: Mon, 30 Aug 2010 11:52:26 +0300
Message-Id: <1283158348-7429-7-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
References: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Add new event types for timeout & carrier report
Move timeout handling from ir_raw_event_store_with_filter to
ir-lirc-codec, where it is really needed.
Now lirc bridge ensures proper gap handling.
Extend lirc bridge for carrier & timeout reports

Note: all new ir_raw_event variables now should be initialized
like that:
struct ir_raw_event ev = ir_new_event;

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ene_ir.c          |    2 +-
 drivers/media/IR/ene_ir.h          |    2 +-
 drivers/media/IR/ir-core-priv.h    |   11 +++++-
 drivers/media/IR/ir-jvc-decoder.c  |    5 ++-
 drivers/media/IR/ir-lirc-codec.c   |   66 ++++++++++++++++++++++++++++++++----
 drivers/media/IR/ir-nec-decoder.c  |    5 ++-
 drivers/media/IR/ir-raw-event.c    |   41 +++++-----------------
 drivers/media/IR/ir-rc5-decoder.c  |    5 ++-
 drivers/media/IR/ir-rc6-decoder.c  |    5 ++-
 drivers/media/IR/ir-sony-decoder.c |    5 ++-
 drivers/media/IR/mceusb.c          |    2 +-
 drivers/media/IR/streamzap.c       |    6 ++--
 include/media/ir-core.h            |   26 ++++++++++++--
 13 files changed, 121 insertions(+), 60 deletions(-)

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index 8e3e0c8..c7bbbca 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -699,7 +699,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 	unsigned long flags;
 	irqreturn_t retval = IRQ_NONE;
 	struct ene_device *dev = (struct ene_device *)data;
-	struct ir_raw_event ev;
+	struct ir_raw_event ev = ir_new_event;
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
diff --git a/drivers/media/IR/ene_ir.h b/drivers/media/IR/ene_ir.h
index 69a0ae0..27b2eb0 100644
--- a/drivers/media/IR/ene_ir.h
+++ b/drivers/media/IR/ene_ir.h
@@ -188,7 +188,7 @@
  *      And there is nothing to change this setting
  */
 
-#define ENE_MAXGAP		(0xFFF * 0x61)
+#define ENE_MAXGAP		20000
 #define ENE_MINGAP		(127 * sample_period)
 
 /******************************************************************************/
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 5d7e08f..a287373 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -82,6 +82,10 @@ struct ir_raw_event_ctrl {
 		struct ir_input_dev *ir_dev;
 		struct lirc_driver *drv;
 		int carrier_low;
+		ktime_t timeout_start;
+		bool timeout;
+		bool send_timeout_reports;
+
 	} lirc;
 };
 
@@ -109,9 +113,14 @@ static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
 		ev->duration -= duration;
 }
 
+/* Returns true if event is normal pulse/space event */
+static inline bool is_timing_event(struct ir_raw_event ev)
+{
+	return !ev.carrier_report && !ev.reset;
+}
+
 #define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
 #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
-#define IS_RESET(ev)			(ev.duration == 0)
 /*
  * Routines from ir-sysfs.c - Meant to be called only internally inside
  * ir-core
diff --git a/drivers/media/IR/ir-jvc-decoder.c b/drivers/media/IR/ir-jvc-decoder.c
index 77a89c4..63dca6e 100644
--- a/drivers/media/IR/ir-jvc-decoder.c
+++ b/drivers/media/IR/ir-jvc-decoder.c
@@ -50,8 +50,9 @@ static int ir_jvc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_JVC))
 		return 0;
 
-	if (IS_RESET(ev)) {
-		data->state = STATE_INACTIVE;
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
 		return 0;
 	}
 
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index e63f757..e6ca7a3 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -32,7 +32,9 @@
 static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct lirc_codec *lirc = &ir_dev->raw->lirc;
 	int sample;
+	int duration_msec;
 
 	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_LIRC))
 		return 0;
@@ -40,21 +42,56 @@ static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
 		return -EINVAL;
 
-	if (IS_RESET(ev))
+	duration_msec = DIV_ROUND_CLOSEST(ev.duration, 1000);
+
+	if (ev.reset)
 		return 0;
 
-	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
-		   TO_US(ev.duration), TO_STR(ev.pulse));
+	if (ev.carrier_report) {
+		/* TODO: send RX duty cycle */
+		sample = LIRC_FREQUENCY(ev.carrier);
+
+	} else if (ev.timeout) {
+		WARN_ON(lirc->timeout || ev.pulse);
+		lirc->timeout_start = ktime_get();
+		lirc->timeout = true;
+
+		if (!lirc->send_timeout_reports)
+			return 0;
+
+		sample = LIRC_TIMEOUT(duration_msec);
+
+	} else {
+
+		if (ev.pulse)
+			sample = LIRC_PULSE(duration_msec);
+		else
+			sample = LIRC_SPACE(duration_msec);
+	}
+
+	/* Write the combined timeout sample now */
+	if (lirc->timeout) {
+		ktime_t now = ktime_get();
+		int timeout_sample;
+
+		u64 duration = ktime_to_ns(ktime_sub(now, lirc->timeout_start))
+				+ ir_dev->raw->prev_ev.duration;
+
+		duration_msec = min(DIV_ROUND_CLOSEST(duration, 1000),
+						(u64)LIRC_VALUE_MASK);
 
-	sample = ev.duration / 1000;
-	if (ev.pulse)
-		sample |= PULSE_BIT;
+		timeout_sample = LIRC_SPACE(duration_msec);
+
+		lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
+				(unsigned char *) &timeout_sample);
+
+		lirc->timeout = false;
+	}
 
 	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
 			  (unsigned char *) &sample);
 	wake_up(&ir_dev->raw->lirc.drv->rbuf->wait_poll);
 
-
 	return 0;
 }
 
@@ -207,6 +244,17 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		ir_dev->props->timeout = val * 1000;
 		break;
 
+	case LIRC_SET_REC_TIMEOUT_REPORTS:
+		lirc->send_timeout_reports = !!val;
+		break;
+
+	case LIRC_SET_MEASURE_CARRIER_MODE:
+
+		if (!ir_dev->props->s_carrier_report)
+			return -ENOSYS;
+		return ir_dev->props->s_carrier_report(
+			ir_dev->props->priv, !!val);
+
 	default:
 		return lirc_dev_fop_ioctl(filep, cmd, arg);
 	}
@@ -277,6 +325,10 @@ static int ir_lirc_register(struct input_dev *input_dev)
 	if (ir_dev->props->s_learning_mode)
 		features |= LIRC_CAN_USE_WIDEBAND_RECEIVER;
 
+	if (ir_dev->props->s_carrier_report)
+		features |= LIRC_CAN_MEASURE_CARRIER;
+
+
 	if (ir_dev->props->max_timeout)
 		features |= LIRC_CAN_SET_REC_TIMEOUT;
 
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index d597421..70993f7 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -54,8 +54,9 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_NEC))
 		return 0;
 
-	if (IS_RESET(ev)) {
-		data->state = STATE_INACTIVE;
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
 		return 0;
 	}
 
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 56797be..a758977 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -174,7 +174,7 @@ int ir_raw_event_store_with_filter(struct input_dev *input_dev,
 	if (ir->idle && !ev->pulse)
 		return 0;
 	else if (ir->idle)
-		ir_raw_event_set_idle(input_dev, 0);
+		ir_raw_event_set_idle(input_dev, false);
 
 	if (!raw->this_ev.duration) {
 		raw->this_ev = *ev;
@@ -187,8 +187,12 @@ int ir_raw_event_store_with_filter(struct input_dev *input_dev,
 
 	/* Enter idle mode if nessesary */
 	if (!ev->pulse && ir->props->timeout &&
-		raw->this_ev.duration >= ir->props->timeout)
-		ir_raw_event_set_idle(input_dev, 1);
+		raw->this_ev.duration >= ir->props->timeout) {
+		raw->this_ev.timeout = true;
+		ir_raw_event_store(input_dev, &raw->this_ev);
+		raw->this_ev.duration = 0;
+		ir_raw_event_set_idle(input_dev, true);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
@@ -196,39 +200,12 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
 void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
 {
 	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	struct ir_raw_event_ctrl *raw = ir->raw;
-	ktime_t now;
-	u64 delta;
 
-	if (!ir->props)
+	if (!ir->props || !ir->raw)
 		return;
 
-	if (!ir->raw)
-		goto out;
-
-	if (idle) {
-		IR_dprintk(2, "enter idle mode\n");
-		raw->last_event = ktime_get();
-	} else {
-		IR_dprintk(2, "exit idle mode\n");
-
-		now = ktime_get();
-		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
+	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
 
-		WARN_ON(raw->this_ev.pulse);
-
-		raw->this_ev.duration =
-			min(raw->this_ev.duration + delta,
-						(u64)IR_MAX_DURATION);
-
-		ir_raw_event_store(input_dev, &raw->this_ev);
-
-		if (raw->this_ev.duration == IR_MAX_DURATION)
-			ir_raw_event_reset(input_dev);
-
-		raw->this_ev.duration = 0;
-	}
-out:
 	if (ir->props->s_idle)
 		ir->props->s_idle(ir->props->priv, idle);
 	ir->idle = idle;
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index df4770d..572ed4c 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -55,8 +55,9 @@ static int ir_rc5_decode(struct input_dev *input_dev, struct ir_raw_event ev)
         if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC5))
                 return 0;
 
-	if (IS_RESET(ev)) {
-		data->state = STATE_INACTIVE;
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
 		return 0;
 	}
 
diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/IR/ir-rc6-decoder.c
index f1624b8..d25da91 100644
--- a/drivers/media/IR/ir-rc6-decoder.c
+++ b/drivers/media/IR/ir-rc6-decoder.c
@@ -85,8 +85,9 @@ static int ir_rc6_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC6))
 		return 0;
 
-	if (IS_RESET(ev)) {
-		data->state = STATE_INACTIVE;
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
 		return 0;
 	}
 
diff --git a/drivers/media/IR/ir-sony-decoder.c b/drivers/media/IR/ir-sony-decoder.c
index b9074f0..2d15730 100644
--- a/drivers/media/IR/ir-sony-decoder.c
+++ b/drivers/media/IR/ir-sony-decoder.c
@@ -48,8 +48,9 @@ static int ir_sony_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_SONY))
 		return 0;
 
-	if (IS_RESET(ev)) {
-		data->state = STATE_INACTIVE;
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
 		return 0;
 	}
 
diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index ac6bb2c..44f041e 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -656,7 +656,7 @@ static int mceusb_set_tx_carrier(void *priv, u32 carrier)
 
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	struct ir_raw_event rawir = ir_new_event;
 	int i, start_index = 0;
 	u8 hdr = MCE_CONTROL_HEADER;
 
diff --git a/drivers/media/IR/streamzap.c b/drivers/media/IR/streamzap.c
index 058e29f..9b0e246 100644
--- a/drivers/media/IR/streamzap.c
+++ b/drivers/media/IR/streamzap.c
@@ -170,7 +170,7 @@ static void streamzap_flush_timeout(unsigned long arg)
 static void streamzap_delay_timeout(unsigned long arg)
 {
 	struct streamzap_ir *sz = (struct streamzap_ir *)arg;
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	struct ir_raw_event rawir = ir_new_event;
 	unsigned long flags;
 	int len, ret;
 	static unsigned long delay;
@@ -215,7 +215,7 @@ static void streamzap_delay_timeout(unsigned long arg)
 
 static void streamzap_flush_delay_buffer(struct streamzap_ir *sz)
 {
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	struct ir_raw_event rawir = ir_new_event;
 	bool wake = false;
 	int ret;
 
@@ -233,7 +233,7 @@ static void streamzap_flush_delay_buffer(struct streamzap_ir *sz)
 
 static void sz_push(struct streamzap_ir *sz)
 {
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	struct ir_raw_event rawir = ir_new_event;
 	unsigned long flags;
 	int ret;
 
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index eb7fddf..3b798f5 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -60,6 +60,7 @@ enum rc_driver_type {
  * @s_idle: optional: enable/disable hardware idle mode, upon which,
 	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
+ * @s_carrier_report: enable carrier reports
  */
 struct ir_dev_props {
 	enum rc_driver_type	driver_type;
@@ -84,6 +85,7 @@ struct ir_dev_props {
 	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
 	void			(*s_idle)(void *priv, int enable);
 	int			(*s_learning_mode)(void *priv, int enable);
+	int			(*s_carrier_report) (void *priv, int enable);
 };
 
 struct ir_input_dev {
@@ -162,11 +164,25 @@ u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
 /* From ir-raw-event.c */
 
 struct ir_raw_event {
-	unsigned                        pulse:1;
-	unsigned                        duration:31;
+	union {
+		u32             duration;
+
+		struct {
+			u32     carrier;
+			u8      duty_cycle;
+		};
+	};
+
+	unsigned                pulse:1;
+	unsigned                reset:1;
+	unsigned                timeout:1;
+	unsigned                carrier_report:1;
 };
 
-#define IR_MAX_DURATION                 0x7FFFFFFF      /* a bit more than 2 seconds */
+#define ir_new_event \
+	{ .pulse = 0, .reset = 0, .timeout = 0, .carrier_report = 0 }
+
+#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 2 seconds */
 
 void ir_raw_event_handle(struct input_dev *input_dev);
 int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
@@ -177,7 +193,9 @@ void ir_raw_event_set_idle(struct input_dev *input_dev, int idle);
 
 static inline void ir_raw_event_reset(struct input_dev *input_dev)
 {
-	struct ir_raw_event ev = { .pulse = false, .duration = 0 };
+	struct ir_raw_event ev = ir_new_event;
+	ev.reset = true;
+
 	ir_raw_event_store(input_dev, &ev);
 	ir_raw_event_handle(input_dev);
 }
-- 
1.7.0.4

