Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44270 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766Ab2EWJyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:49 -0400
Subject: [PATCH 39/43] rc-core: use struct rc_event to signal TX events from
 userspace
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:25 +0200
Message-ID: <20120523094525.14474.90338.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using struct rc_event as the data unit for writes from userspace provides
more flexibility and easier future compatibility with future developments
(e.g. if rc-core grew support for some very different transmission, such
as RF transmission).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ene_ir.c        |   24 ++++++------
 drivers/media/rc/ene_ir.h        |    2 -
 drivers/media/rc/ir-lirc-codec.c |   12 +++---
 drivers/media/rc/ite-cir.c       |   19 +++++----
 drivers/media/rc/mceusb.c        |   10 +++--
 drivers/media/rc/nuvoton-cir.c   |   10 +++--
 drivers/media/rc/rc-loopback.c   |   10 ++++-
 drivers/media/rc/rc-main.c       |   18 +++------
 drivers/media/rc/redrat3.c       |   20 ++++++++--
 drivers/media/rc/winbond-cir.c   |   22 +++++------
 include/media/rc-core.h          |   79 +++++++++++++++++++-------------------
 include/media/rc-ir-raw.h        |    6 +++
 12 files changed, 133 insertions(+), 99 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 2c2cfd5..9669311 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -604,7 +604,7 @@ static void ene_tx_enable(struct ene_device *dev)
 static void ene_tx_disable(struct ene_device *dev)
 {
 	ene_write_reg(dev, ENE_CIRCFG, dev->saved_conf1);
-	init_ir_raw_event(&dev->tx_event);
+	dev->tx_event.val = 0;
 }
 
 
@@ -614,7 +614,7 @@ static void ene_tx_sample(struct ene_device *dev)
 	u8 raw_tx;
 
 	/* Grab next TX sample */
-	if (!dev->tx_event.duration) {
+	while (!dev->tx_event.val) {
 
 		if (!kfifo_get(&dev->rdev->txfifo, &dev->tx_event)) {
 			if (!dev->tx_done) {
@@ -629,19 +629,21 @@ static void ene_tx_sample(struct ene_device *dev)
 			}
 		}
 
-		dev->tx_event.duration = DIV_ROUND_CLOSEST(dev->tx_event.duration,
-							   US_TO_NS(sample_period));
-		if (!dev->tx_event.duration)
-			dev->tx_event.duration = 1;
+		if (!is_ir_raw_timing_event(dev->tx_event))
+			continue;
+
+		dev->tx_event.val = max_t(u64, 1,
+					  DIV_ROUND_CLOSEST(dev->tx_event.val,
+							    US_TO_NS(sample_period)));
 	}
 
-	raw_tx = min_t(unsigned, dev->tx_event.duration, ENE_CIRRLC_OUT_MASK);
-	dev->tx_event.duration -= raw_tx;
+	raw_tx = min_t(unsigned, dev->tx_event.val, ENE_CIRRLC_OUT_MASK);
+	dev->tx_event.val -= raw_tx;
 
 	dbg("TX: sample %8d (%s)", raw_tx * sample_period,
-	    dev->tx_event.pulse ? "pulse" : "space");
+	    dev->tx_event.code == RC_IR_RAW_PULSE ? "pulse" : "space");
 
-	if (dev->tx_event.pulse)
+	if (dev->tx_event.code == RC_IR_RAW_PULSE)
 		raw_tx |= ENE_CIRRLC_OUT_PULSE;
 
 	ene_write_reg(dev,
@@ -953,7 +955,7 @@ static int ene_transmit(struct rc_dev *rdev)
 	dev->tx_reg = 0;
 	dev->tx_done = false;
 
-	init_ir_raw_event(&dev->tx_event);
+	dev->tx_event.val = 0;
 	dbg("TX: %d samples", kfifo_len(&rdev->txfifo));
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index 975d67a..d0898e1 100644
--- a/drivers/media/rc/ene_ir.h
+++ b/drivers/media/rc/ene_ir.h
@@ -224,7 +224,7 @@ struct ene_device {
 	u8  saved_conf1;			/* saved FEC0 reg */
 
 	/* TX buffer */
-	struct ir_raw_event tx_event;		/* current sample for TX */
+	struct rc_event tx_event;		/* current sample for TX */
 	bool tx_done;				/* done transmitting */
 	struct completion tx_complete;		/* TX completion */
 	struct timer_list tx_sim_timer;
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 6811db9..a5b0368 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -109,8 +109,8 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	ssize_t ret;
 	s64 towait;
 	unsigned int duration = 0; /* signal duration in us */
-	DEFINE_IR_RAW_EVENT(event);
 	bool pulse = true;
+	struct rc_event ev;
 
 	if (!lirc || !lirc->dev)
 		return -EFAULT;
@@ -122,14 +122,16 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (n % sizeof(u32) || ((n / sizeof(u32)) % 2) == 0)
 		return -EINVAL;
 
+	ev.type = RC_IR_RAW;
+	ev.reserved = 0x0;
+
 	for (ret = 0; ret + sizeof(u32) <= n; ret += sizeof(u32)) {
 		if (copy_from_user(&value, buf + ret, sizeof(u32)))
 			return -EFAULT;
 
-		event.pulse = pulse;
-		event.duration = US_TO_NS(value);
-		if (kfifo_in_spinlocked(&dev->txfifo, &event, 1, &dev->txlock)
-		    != 1)
+		ev.code = pulse ? RC_IR_RAW_PULSE : RC_IR_RAW_SPACE;
+		ev.val = US_TO_NS(value);
+		if (!kfifo_in_spinlocked(&dev->txfifo, &ev, 1, &dev->txlock))
 			break;
 
 		pulse = !pulse;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 44759db..51fb845 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -390,7 +390,7 @@ static int ite_tx_ir(struct rc_dev *rcdev)
 	int max_rle_us, next_rle_us;
 	u8 last_sent[ITE_TX_FIFO_LEN];
 	u8 val;
-	DEFINE_IR_RAW_EVENT(event);
+	struct rc_event ev;
 
 	ite_dbg("%s called", __func__);
 
@@ -420,14 +420,16 @@ static int ite_tx_ir(struct rc_dev *rcdev)
 	fifo_avail =
 	    ITE_TX_FIFO_LEN - dev->params.get_tx_used_slots(dev);
 
-	while (kfifo_get(&rcdev->txfifo, &event) && dev->in_use) {
+	while (kfifo_get(&rcdev->txfifo, &ev) && dev->in_use) {
+		if (!is_ir_raw_timing_event(ev))
+			continue;
+
 		/* transmit the next sample */
-		remaining_us = event.duration;
+		remaining_us = ev.val;
 
-		ite_dbg("%s: %ld",
-				      (event.pulse ? "pulse" : "space"),
-				      (long int)
-				      remaining_us);
+		ite_dbg("%s: %lld",
+			ev.code == RC_IR_RAW_PULSE ? "pulse" : "space",
+			(long long int)remaining_us);
 
 		/* repeat while the pulse is non-zero length */
 		while (remaining_us > 0 && dev->in_use) {
@@ -450,9 +452,8 @@ static int ite_tx_ir(struct rc_dev *rcdev)
 			val = (val - 1) & ITE_TX_RLE_MASK;
 
 			/* take into account pulse/space prefix */
-			if (event.pulse)
+			if (ev.code == RC_IR_RAW_PULSE)
 				val |= ITE_TX_PULSE;
-
 			else
 				val |= ITE_TX_SPACE;
 
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index e9dda87..952ea01 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -785,7 +785,7 @@ static int mceusb_tx_ir(struct rc_dev *dev)
 	struct mceusb_dev *ir = dev->priv;
 	unsigned tmp, i = 0;
 	unsigned char buf[MCE_CMDBUF_SIZE]; /* MCE command buffer */
-	DEFINE_IR_RAW_EVENT(event);
+	struct rc_event event;
 
 	/* MCE tx init header */
 	buf[i++] = MCE_CMD_PORT_IR;
@@ -793,7 +793,10 @@ static int mceusb_tx_ir(struct rc_dev *dev)
 	buf[i++] = ir->tx_mask;
 
 	while (kfifo_get(&dev->txfifo, &event)) {
-		tmp = event.duration / US_TO_NS(MCE_TIME_UNIT);
+		if (!is_ir_raw_timing_event(event))
+			continue;
+
+		tmp = event.val / US_TO_NS(MCE_TIME_UNIT);
 
 		/* Split event into pulses/spaces <= 127 * 50us = 6.35ms */
 		while (tmp > 0 && i < (MCE_CMDBUF_SIZE - 1)) {
@@ -804,7 +807,8 @@ static int mceusb_tx_ir(struct rc_dev *dev)
 
 			buf[i] = min_t(unsigned, tmp, MCE_MAX_PULSE_LENGTH);
 			tmp -= buf[i];
-			buf[i++] |= event.pulse ? MCE_PULSE_BIT : 0x00;
+			if (event.code == RC_IR_RAW_PULSE)
+				buf[i++] |= MCE_PULSE_BIT;
 		}
 
 		/* See if command buffer is full */
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 915074e..4c37ade 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -756,6 +756,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	struct nvt_dev *nvt = data;
 	u8 status, iren, cur_state;
 	unsigned long flags;
+	struct rc_event ev;
 
 	nvt_dbg_verbose("%s firing", __func__);
 
@@ -830,14 +831,15 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 		spin_lock_irqsave(&nvt->tx.lock, flags);
 
 		/* Any data in tx buffer? */
-		if (nvt->tx.cur_buf_num >= nvt->tx.buf_count) {
-			DEFINE_IR_RAW_EVENT(event);
-			if (!kfifo_get(&nvt->rdev->txfifo, &event)) {
+		while (nvt->tx.cur_buf_num >= nvt->tx.buf_count) {
+			if (!kfifo_get(&nvt->rdev->txfifo, &ev)) {
 				/* No more data, disable TTR interrupt */
 				u8 tmp = nvt_cir_reg_read(nvt, CIR_IREN);
 				nvt_cir_reg_write(nvt, tmp & ~CIR_IREN_TTR, CIR_IREN);
+			} else if (!is_ir_raw_timing_event(ev)) {
+				continue;
 			} else {
-				unsigned sample = event.duration / 1000;
+				unsigned sample = ev.val / 1000;
 				nvt->tx.buf_count = sizeof(sample);
 				nvt->tx.cur_buf_num = 0;
 				memcpy(nvt->tx.buf, &sample, sizeof(sample));
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 7775b3e..45ef966 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -53,6 +53,7 @@ static int loop_tx_ir(struct rc_dev *dev)
 {
 	struct loopback_dev *lodev = dev->priv;
 	u32 rxmask;
+	struct rc_event event;
 	DEFINE_IR_RAW_EVENT(rawir);
 
 	if (lodev->txcarrier < lodev->rxcarriermin ||
@@ -73,8 +74,15 @@ static int loop_tx_ir(struct rc_dev *dev)
 		return 0;
 	}
 
-	while (kfifo_get(&dev->txfifo, &rawir))
+	while (kfifo_get(&dev->txfifo, &event)) {
+		if (is_ir_raw_timing_event(event))
+			continue;
+		init_ir_raw_event(&rawir);
+		rawir.duration = event.val;
+		if (event.code == RC_IR_RAW_PULSE)
+			rawir.pulse = true;
 		ir_raw_event_store_with_filter(dev, &rawir);
+	}
 
 	/* Fake a silence long enough to cause us to go idle */
 	init_ir_raw_event(&rawir);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 14728fc..6c8bc3a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -801,14 +801,12 @@ static ssize_t rc_write(struct file *file, const char __user *buffer,
 	struct rc_client *client = file->private_data;
 	struct rc_dev *dev = client->dev;
 	ssize_t ret;
-	DEFINE_IR_RAW_EVENT(event);
-	bool pulse = true;
-	u32 value;
+	struct rc_event ev;
 
 	if (!dev->tx_ir)
 		return -ENOSYS;
 
-	if ((count < sizeof(u32)) || (count % sizeof(u32)))
+	if (count < sizeof(ev))
 		return -EINVAL;
 
 again:
@@ -825,16 +823,14 @@ again:
 	if (!dev->exist)
 		return -ENODEV;
 
-	for (ret = 0; ret + sizeof(value) <= count; ret += sizeof(value)) {
-		if (copy_from_user(&value, buffer + ret, sizeof(value)))
+	for (ret = 0; ret + sizeof(ev) <= count; ret += sizeof(ev)) {
+		if (copy_from_user(&ev, buffer + ret, sizeof(ev)))
 			return -EFAULT;
 
-		event.duration = US_TO_NS(value);
-		event.pulse = pulse;
-		pulse = !pulse;
+		if (ev.reserved)
+			return -EINVAL;
 
-		if (kfifo_in_spinlocked(&dev->txfifo, &event, 1, &dev->txlock)
-		    != 1)
+		if (!kfifo_in_spinlocked(&dev->txfifo, &ev, 1, &dev->txlock))
 			break;
 	}
 
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 394799d..760f13e 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -906,8 +906,8 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev)
 {
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
-	DEFINE_IR_RAW_EVENT(event);
 	struct redrat3_tx_data tx;
+	struct rc_event ev;
 	unsigned nlens = 0, nsamples = 0, i;
 	int txlen, actual_len;
 	int ret;
@@ -924,9 +924,23 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev)
 	rr3->det_enabled = false;
 	rr3->transmitting = true;
 
-	while (kfifo_get(&rcdev->txfifo, &event)) {
+	while (kfifo_get(&rcdev->txfifo, &ev)) {
+		if (!is_ir_raw_timing_event(ev))
+			continue;
+
 		/* Convert duration to RR format */
-		sample = redrat3_us_to_len(event.duration / 1000);
+		sample = redrat3_us_to_len(ev.val / 1000);
+
+		if (sample < 1)
+			continue;
+
+		if (((ev.code == RC_IR_RAW_PULSE) && (nsamples % 2 == 1)) ||
+		    ((ev.code == RC_IR_RAW_SPACE) && (nsamples % 2 == 0))) {
+			/* Input is not in pulse/space/pulse/space/etc format */
+			dev_err(dev, "signal invalid\n");
+			ret = -EINVAL;
+			goto out;
+		}
 
 		/* See if we already have the same sample size stored */
 		for (i = 0; i < nlens; i++)
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 5a240ba..76a8104 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -213,7 +213,7 @@ struct wbcir_data {
 	/* TX state */
 	enum wbcir_txstate txstate;
 	struct led_trigger *txtrigger;
-	struct ir_raw_event txevent;
+	struct rc_event txevent;
 	wait_queue_head_t txwaitq;
 	u8 txmask;
 	u32 txcarrier;
@@ -403,19 +403,20 @@ wbcir_irq_tx(struct wbcir_data *data)
 	 * X = duration, encoded as (X + 1) * 10us (i.e 10 to 1280 us)
 	 */
 	for (used = 0; used < space; used++) {
-		while (data->txevent.duration == 0) {
+		while (data->txevent.val == 0) {
 			if (!kfifo_get(&data->dev->txfifo, &data->txevent))
 				break;
+			if (!is_ir_raw_timing_event(data->txevent))
+				continue;
 			/* Convert duration to multiples of 10us */
-			data->txevent.duration =
-				DIV_ROUND_CLOSEST(data->txevent.duration,
-						  10 * 1000);
+			data->txevent.val =
+				DIV_ROUND_CLOSEST(data->txevent.val, 10 * 1000);
 		}
 
-		byte = min_t(u32, 0x80, data->txevent.duration);
-		data->txevent.duration -= byte;
+		byte = min_t(u32, 0x80, data->txevent.val);
+		data->txevent.val -= byte;
 		byte--;
-		byte |= data->txevent.pulse ? 0x80 : 0x00;
+		byte |= data->txevent.code == RC_IR_RAW_PULSE ? 0x80 : 0x00;
 		bytes[used] = byte;
 	}
 
@@ -429,8 +430,7 @@ wbcir_irq_tx(struct wbcir_data *data)
 		wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR);
 		led_trigger_event(data->txtrigger, LED_OFF);
 		wake_up(&data->txwaitq);
-	} else if (data->txevent.duration == 0 &&
-		   kfifo_is_empty(&data->dev->txfifo)) {
+	} else if (data->txevent.val == 0 && kfifo_is_empty(&data->dev->txfifo)) {
 		/* At the end of transmission, tell the hw before last byte */
 		outsb(data->sbase + WBCIR_REG_SP3_TXDATA, bytes, used - 1);
 		outb(WBCIR_TX_EOT, data->sbase + WBCIR_REG_SP3_ASCR);
@@ -594,7 +594,7 @@ wbcir_tx(struct rc_dev *dev)
 	}
 
 	/* Fill the TX fifo once, the irq handler will do the rest */
-	init_ir_raw_event(&data->txevent);
+	data->txevent.val = 0;
 	wbcir_irq_tx(data);
 
 	/* Wait for the TX to complete */
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f2ff7f7..d8cad87 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -199,7 +199,6 @@ struct rc_keymap_entry {
 	};
 };
 
-#define RC_TX_KFIFO_SIZE	1024
 struct ir_raw_event {
 	union {
 		u32             duration;
@@ -216,6 +215,43 @@ struct ir_raw_event {
 	unsigned                carrier_report:1;
 };
 
+/**
+ * struct rc_event - used to communicate rc events to userspace
+ * @type:	the event type
+ * @code:	the event code (type specific)
+ * @reserved:	zero for now
+ * @val:	the event value (type and code specific)
+ */
+struct rc_event {
+	__u16 type;
+	__u16 code;
+	__u32 reserved;
+	__u64 val;
+} __packed;
+
+/* rc_event.type value */
+#define RC_DEBUG		0x0
+#define RC_CORE			0x1
+#define RC_KEY			0x2
+#define RC_IR_RAW		0x3
+
+/* RC_CORE codes */
+#define RC_CORE_DROPPED		0x0
+
+/* RC_KEY codes */
+#define RC_KEY_REPEAT		0x0
+#define RC_KEY_PROTOCOL		0x1
+#define RC_KEY_SCANCODE		0x2
+#define RC_KEY_TOGGLE		0x3
+
+/* RC_IR_RAW codes */
+#define RC_IR_RAW_SPACE		0x0
+#define RC_IR_RAW_PULSE		0x1
+#define RC_IR_RAW_START		0x2
+#define RC_IR_RAW_STOP		0x3
+#define RC_IR_RAW_RESET		0x4
+#define RC_IR_RAW_CARRIER	0x5
+#define RC_IR_RAW_DUTY_CYCLE	0x6
 
 /**
  * struct rc_dev - represents a remote control device
@@ -279,6 +315,7 @@ struct ir_raw_event {
  * @set_ir_tx: allow driver to change tx settings
  */
 #define RC_MAX_KEYTABLES		32
+#define RC_TX_KFIFO_SIZE		1024
 struct rc_dev {
 	struct device			dev;
 	const char			*input_name;
@@ -294,7 +331,7 @@ struct rc_dev {
 	struct list_head		client_list;
 	spinlock_t			client_lock;
 	unsigned			users;
-	DECLARE_KFIFO_PTR(txfifo, struct ir_raw_event);
+	DECLARE_KFIFO_PTR(txfifo, struct rc_event);
 	spinlock_t			txlock;
 	wait_queue_head_t		txwait;
 	wait_queue_head_t		rxwait;
@@ -374,44 +411,6 @@ struct rc_keytable {
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
-/* rc_event.type value */
-#define RC_DEBUG		0x0
-#define RC_CORE			0x1
-#define RC_KEY			0x2
-#define RC_IR_RAW		0x3
-
-/* RC_CORE codes */
-#define RC_CORE_DROPPED		0x0
-
-/* RC_KEY codes */
-#define RC_KEY_REPEAT		0x0
-#define RC_KEY_PROTOCOL		0x1
-#define RC_KEY_SCANCODE		0x2
-#define RC_KEY_TOGGLE		0x3
-
-/* RC_IR_RAW codes */
-#define RC_IR_RAW_SPACE		0x0
-#define RC_IR_RAW_PULSE		0x1
-#define RC_IR_RAW_START		0x2
-#define RC_IR_RAW_STOP		0x3
-#define RC_IR_RAW_RESET		0x4
-#define RC_IR_RAW_CARRIER	0x5
-#define RC_IR_RAW_DUTY_CYCLE	0x6
-
-/**
- * struct rc_event - used to communicate rc events to userspace
- * @type:	the event type
- * @code:	the event code (type specific)
- * @reserved:	zero for now
- * @val:	the event value (type and code specific)
- */
-struct rc_event {
-	__u16 type;
-	__u16 code;
-	__u32 reserved;
-	__u64 val;
-} __packed;
-
 /*
  * From rc-main.c
  * Those functions can be used on any type of Remote Controller. They
diff --git a/include/media/rc-ir-raw.h b/include/media/rc-ir-raw.h
index 4c3fe78..7fd0693 100644
--- a/include/media/rc-ir-raw.h
+++ b/include/media/rc-ir-raw.h
@@ -65,4 +65,10 @@ static inline void ir_raw_event_reset(struct rc_dev *dev)
 	ir_raw_event_handle(dev);
 }
 
+static inline bool is_ir_raw_timing_event(struct rc_event ev)
+{
+	return (ev.type == RC_IR_RAW &&
+		(ev.code == RC_IR_RAW_PULSE || ev.code == RC_IR_RAW_SPACE));
+}
+
 #endif /* _RC_IR_RAW */

