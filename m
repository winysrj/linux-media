Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34279 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab0JQAEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 20:04:01 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/3] IR: extend ir_raw_event and do refactoring
Date: Sun, 17 Oct 2010 00:56:28 +0200
Message-Id: <1287269790-17605-2-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1287269790-17605-1-git-send-email-maximlevitsky@gmail.com>
References: <1287269790-17605-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add new event types for timeout & carrier report
Move timeout handling from ir_raw_event_store_with_filter to
ir-lirc-codec, where it is really needed.
Now lirc bridge ensures proper gap handling.
Extend lirc bridge for carrier & timeout reports

Note: all new ir_raw_event variables now should be initialized
like that: DEFINE_IR_RAW_EVENT(ev);

To clean an existing event, use init_ir_raw_event(&ev);

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Acked-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ene_ir.c            |    4 +-
 drivers/media/IR/ir-core-priv.h      |   13 +++-
 drivers/media/IR/ir-jvc-decoder.c    |    5 +-
 drivers/media/IR/ir-lirc-codec.c     |  128 ++++++++++++++++++++++++----------
 drivers/media/IR/ir-nec-decoder.c    |    5 +-
 drivers/media/IR/ir-raw-event.c      |   45 ++++--------
 drivers/media/IR/ir-rc5-decoder.c    |    5 +-
 drivers/media/IR/ir-rc5-sz-decoder.c |    5 +-
 drivers/media/IR/ir-rc6-decoder.c    |    5 +-
 drivers/media/IR/ir-sony-decoder.c   |    5 +-
 drivers/media/IR/mceusb.c            |    3 +-
 drivers/media/IR/nuvoton-cir.c       |    5 +-
 drivers/media/IR/streamzap.c         |    6 +-
 include/media/ir-core.h              |   40 +++++++++--
 14 files changed, 181 insertions(+), 93 deletions(-)

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index 9f9afe7..8639621 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -697,7 +697,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 	unsigned long flags;
 	irqreturn_t retval = IRQ_NONE;
 	struct ene_device *dev = (struct ene_device *)data;
-	struct ir_raw_event ev;
+	DEFINE_IR_RAW_EVENT(ev);
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
@@ -898,7 +898,7 @@ static int ene_set_learning_mode(void *data, int enable)
 }
 
 /* outside interface: enable or disable idle mode */
-static void ene_rx_set_idle(void *data, int idle)
+static void ene_rx_set_idle(void *data, bool idle)
 {
 	struct ene_device *dev = (struct ene_device *)data;
 
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 6830580..81c936b 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -88,6 +88,12 @@ struct ir_raw_event_ctrl {
 		struct ir_input_dev *ir_dev;
 		struct lirc_driver *drv;
 		int carrier_low;
+
+		ktime_t gap_start;
+		u64 gap_duration;
+		bool gap;
+		bool send_timeout_reports;
+
 	} lirc;
 };
 
@@ -115,9 +121,14 @@ static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
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
index 20ac9a4..1d9c6b0 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -32,6 +32,7 @@
 static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct lirc_codec *lirc = &ir_dev->raw->lirc;
 	int sample;
 
 	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_LIRC))
@@ -40,21 +41,57 @@ static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
 		return -EINVAL;
 
-	if (IS_RESET(ev))
+	/* Packet start */
+	if (ev.reset)
 		return 0;
 
-	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
-		   TO_US(ev.duration), TO_STR(ev.pulse));
+	/* Carrier reports */
+	if (ev.carrier_report) {
+		sample = LIRC_FREQUENCY(ev.carrier);
+
+	/* Packet end */
+	} else if (ev.timeout) {
+
+		if (lirc->gap)
+			return 0;
+
+		lirc->gap_start = ktime_get();
+		lirc->gap = true;
+		lirc->gap_duration = ev.duration;
+
+		if (!lirc->send_timeout_reports)
+			return 0;
+
+		sample = LIRC_TIMEOUT(ev.duration / 1000);
 
-	sample = ev.duration / 1000;
-	if (ev.pulse)
-		sample |= PULSE_BIT;
+	/* Normal sample */
+	} else {
+
+		if (lirc->gap) {
+			int gap_sample;
+
+			lirc->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
+				lirc->gap_start));
+
+			/* Convert to ms and cap by LIRC_VALUE_MASK */
+			do_div(lirc->gap_duration, 1000);
+			lirc->gap_duration = min(lirc->gap_duration,
+							(u64)LIRC_VALUE_MASK);
+
+			gap_sample = LIRC_SPACE(lirc->gap_duration);
+			lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
+						(unsigned char *) &gap_sample);
+			lirc->gap = false;
+		}
+
+		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
+					LIRC_SPACE(ev.duration / 1000);
+	}
 
 	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
 			  (unsigned char *) &sample);
 	wake_up(&ir_dev->raw->lirc.drv->rbuf->wait_poll);
 
-
 	return 0;
 }
 
@@ -102,7 +139,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	struct ir_input_dev *ir_dev;
 	int ret = 0;
 	void *drv_data;
-	__u32 val = 0;
+	__u32 val = 0, tmp;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
@@ -130,22 +167,20 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	case LIRC_SET_SEND_MODE:
 		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
 			return -EINVAL;
-		break;
+		return 0;
 
 	/* TX settings */
 	case LIRC_SET_TRANSMITTER_MASK:
-		if (ir_dev->props->s_tx_mask)
-			ret = ir_dev->props->s_tx_mask(drv_data, val);
-		else
+		if (!ir_dev->props->s_tx_mask)
 			return -EINVAL;
-		break;
+
+		return ir_dev->props->s_tx_mask(drv_data, val);
 
 	case LIRC_SET_SEND_CARRIER:
-		if (ir_dev->props->s_tx_carrier)
-			ir_dev->props->s_tx_carrier(drv_data, val);
-		else
+		if (!ir_dev->props->s_tx_carrier)
 			return -EINVAL;
-		break;
+
+		return ir_dev->props->s_tx_carrier(drv_data, val);
 
 	case LIRC_SET_SEND_DUTY_CYCLE:
 		if (!ir_dev->props->s_tx_duty_cycle)
@@ -154,39 +189,42 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (val <= 0 || val >= 100)
 			return -EINVAL;
 
-		ir_dev->props->s_tx_duty_cycle(ir_dev->props->priv, val);
-		break;
+		return ir_dev->props->s_tx_duty_cycle(drv_data, val);
 
 	/* RX settings */
 	case LIRC_SET_REC_CARRIER:
-		if (ir_dev->props->s_rx_carrier_range)
-			ret = ir_dev->props->s_rx_carrier_range(
-				ir_dev->props->priv,
-				ir_dev->raw->lirc.carrier_low, val);
-		else
+		if (!ir_dev->props->s_rx_carrier_range)
 			return -ENOSYS;
 
-		if (!ret)
-			ir_dev->raw->lirc.carrier_low = 0;
-		break;
+		if (val <= 0)
+			return -EINVAL;
+
+		return ir_dev->props->s_rx_carrier_range(drv_data,
+			ir_dev->raw->lirc.carrier_low, val);
 
 	case LIRC_SET_REC_CARRIER_RANGE:
-		if (val >= 0)
-			ir_dev->raw->lirc.carrier_low = val;
-		break;
+		if (val <= 0)
+			return -EINVAL;
 
+		ir_dev->raw->lirc.carrier_low = val;
+		return 0;
 
 	case LIRC_GET_REC_RESOLUTION:
 		val = ir_dev->props->rx_resolution;
 		break;
 
 	case LIRC_SET_WIDEBAND_RECEIVER:
-		if (ir_dev->props->s_learning_mode)
-			return ir_dev->props->s_learning_mode(
-				ir_dev->props->priv, !!val);
-		else
+		if (!ir_dev->props->s_learning_mode)
 			return -ENOSYS;
 
+		return ir_dev->props->s_learning_mode(drv_data, !!val);
+
+	case LIRC_SET_MEASURE_CARRIER_MODE:
+		if (!ir_dev->props->s_carrier_report)
+			return -ENOSYS;
+
+		return ir_dev->props->s_carrier_report(drv_data, !!val);
+
 	/* Generic timeout support */
 	case LIRC_GET_MIN_TIMEOUT:
 		if (!ir_dev->props->max_timeout)
@@ -201,10 +239,20 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		break;
 
 	case LIRC_SET_REC_TIMEOUT:
-		if (val < ir_dev->props->min_timeout ||
-		    val > ir_dev->props->max_timeout)
-			return -EINVAL;
-		ir_dev->props->timeout = val * 1000;
+		if (!ir_dev->props->max_timeout)
+			return -ENOSYS;
+
+		tmp = val * 1000;
+
+		if (tmp < ir_dev->props->min_timeout ||
+			tmp > ir_dev->props->max_timeout)
+				return -EINVAL;
+
+		ir_dev->props->timeout = tmp;
+		break;
+
+	case LIRC_SET_REC_TIMEOUT_REPORTS:
+		lirc->send_timeout_reports = !!val;
 		break;
 
 	default:
@@ -280,6 +328,10 @@ static int ir_lirc_register(struct input_dev *input_dev)
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
index 119b567..0d59ef7 100644
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
@@ -187,48 +187,35 @@ int ir_raw_event_store_with_filter(struct input_dev *input_dev,
 
 	/* Enter idle mode if nessesary */
 	if (!ev->pulse && ir->props->timeout &&
-		raw->this_ev.duration >= ir->props->timeout)
-		ir_raw_event_set_idle(input_dev, 1);
+		raw->this_ev.duration >= ir->props->timeout) {
+		ir_raw_event_set_idle(input_dev, true);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
 
-void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
+/**
+ * ir_raw_event_set_idle() - hint the ir core if device is receiving
+ * IR data or not
+ * @input_dev: the struct input_dev device descriptor
+ * @idle: the hint value
+ */
+void ir_raw_event_set_idle(struct input_dev *input_dev, bool idle)
 {
 	struct ir_input_dev *ir = input_get_drvdata(input_dev);
 	struct ir_raw_event_ctrl *raw = ir->raw;
-	ktime_t now;
-	u64 delta;
 
-	if (!ir->props)
+	if (!ir->props || !ir->raw)
 		return;
 
-	if (!ir->raw)
-		goto out;
+	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
 
 	if (idle) {
-		IR_dprintk(2, "enter idle mode\n");
-		raw->last_event = ktime_get();
-	} else {
-		IR_dprintk(2, "exit idle mode\n");
-
-		now = ktime_get();
-		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
-
-		WARN_ON(raw->this_ev.pulse);
-
-		raw->this_ev.duration =
-			min(raw->this_ev.duration + delta,
-						(u64)IR_MAX_DURATION);
-
+		raw->this_ev.timeout = true;
 		ir_raw_event_store(input_dev, &raw->this_ev);
-
-		if (raw->this_ev.duration == IR_MAX_DURATION)
-			ir_raw_event_reset(input_dev);
-
-		raw->this_ev.duration = 0;
+		init_ir_raw_event(&raw->this_ev);
 	}
-out:
+
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
 
diff --git a/drivers/media/IR/ir-rc5-sz-decoder.c b/drivers/media/IR/ir-rc5-sz-decoder.c
index 68f11d6..7c41350 100644
--- a/drivers/media/IR/ir-rc5-sz-decoder.c
+++ b/drivers/media/IR/ir-rc5-sz-decoder.c
@@ -51,8 +51,9 @@ static int ir_rc5_sz_decode(struct input_dev *input_dev, struct ir_raw_event ev)
         if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC5_SZ))
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
index bc620e1..6825da5 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -660,7 +660,7 @@ static int mceusb_set_tx_carrier(void *priv, u32 carrier)
 
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	DEFINE_IR_RAW_EVENT(rawir);
 	int i, start_index = 0;
 	u8 hdr = MCE_CONTROL_HEADER;
 
@@ -997,6 +997,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->len_in = maxp;
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
 	ir->flags.tx_mask_inverted = tx_mask_inverted;
+	init_ir_raw_event(&ir->rawir);
 
 	/* Saving usb interface data for use by the transmitter routine */
 	ir->usb_ep_in = ep_in;
diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/IR/nuvoton-cir.c
index 2f0f780..301be53 100644
--- a/drivers/media/IR/nuvoton-cir.c
+++ b/drivers/media/IR/nuvoton-cir.c
@@ -586,7 +586,7 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
  */
 static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 {
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	DEFINE_IR_RAW_EVENT(rawir);
 	unsigned int count;
 	u32 carrier;
 	u8 sample;
@@ -622,6 +622,8 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 		}
 
 		rawir.duration += nvt->rawir.duration;
+
+		init_ir_raw_event(&nvt->rawir);
 		nvt->rawir.duration = 0;
 		nvt->rawir.pulse = rawir.pulse;
 
@@ -1016,6 +1018,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	spin_lock_init(&nvt->nvt_lock);
 	spin_lock_init(&nvt->tx.lock);
+	init_ir_raw_event(&nvt->rawir);
 
 	ret = -EBUSY;
 	/* now claim resources */
diff --git a/drivers/media/IR/streamzap.c b/drivers/media/IR/streamzap.c
index 86a4f68..548381c 100644
--- a/drivers/media/IR/streamzap.c
+++ b/drivers/media/IR/streamzap.c
@@ -146,7 +146,7 @@ static void sz_push(struct streamzap_ir *sz, struct ir_raw_event rawir)
 static void sz_push_full_pulse(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	struct ir_raw_event rawir;
+	DEFINE_IR_RAW_EVENT(rawir);
 
 	if (sz->idle) {
 		long deltv;
@@ -193,7 +193,7 @@ static void sz_push_half_pulse(struct streamzap_ir *sz,
 static void sz_push_full_space(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	struct ir_raw_event rawir;
+	DEFINE_IR_RAW_EVENT(rawir);
 
 	rawir.pulse = false;
 	rawir.duration = ((int) value) * SZ_RESOLUTION;
@@ -270,7 +270,7 @@ static void streamzap_callback(struct urb *urb)
 			break;
 		case FullSpace:
 			if (sz->buf_in[i] == SZ_TIMEOUT) {
-				struct ir_raw_event rawir;
+				DEFINE_IR_RAW_EVENT(rawir);
 
 				rawir.pulse = false;
 				rawir.duration = timeout;
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 4dd43d4..6dc37fa 100644
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
@@ -82,8 +83,9 @@ struct ir_dev_props {
 	int			(*s_tx_duty_cycle)(void *priv, u32 duty_cycle);
 	int			(*s_rx_carrier_range)(void *priv, u32 min, u32 max);
 	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
-	void			(*s_idle)(void *priv, int enable);
+	void			(*s_idle)(void *priv, bool enable);
 	int			(*s_learning_mode)(void *priv, int enable);
+	int			(*s_carrier_report) (void *priv, int enable);
 };
 
 struct ir_input_dev {
@@ -163,22 +165,48 @@ u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
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
+#define DEFINE_IR_RAW_EVENT(event) \
+	struct ir_raw_event event = { \
+		{ .duration = 0 } , \
+		.pulse = 0, \
+		.reset = 0, \
+		.timeout = 0, \
+		.carrier_report = 0 }
+
+static inline void init_ir_raw_event(struct ir_raw_event *ev)
+{
+	memset(ev, 0, sizeof(*ev));
+}
+
+#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
 
 void ir_raw_event_handle(struct input_dev *input_dev);
 int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
 int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
 int ir_raw_event_store_with_filter(struct input_dev *input_dev,
 				struct ir_raw_event *ev);
-void ir_raw_event_set_idle(struct input_dev *input_dev, int idle);
+void ir_raw_event_set_idle(struct input_dev *input_dev, bool idle);
 
 static inline void ir_raw_event_reset(struct input_dev *input_dev)
 {
-	struct ir_raw_event ev = { .pulse = false, .duration = 0 };
+	DEFINE_IR_RAW_EVENT(ev);
+	ev.reset = true;
+
 	ir_raw_event_store(input_dev, &ev);
 	ir_raw_event_handle(input_dev);
 }
-- 
1.7.1

