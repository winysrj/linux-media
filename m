Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43313 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbeH0QQM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 12:16:12 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: Remove init_ir_raw_event and DEFINE_IR_RAW_EVENT macros
Date: Mon, 27 Aug 2018 13:29:44 +0100
Message-Id: <20180827122944.22331-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This can be done with c99 initializers, which makes the code cleaner
and more transparent. It does require gcc 4.6, because of this bug
in earlier versions:

	https://gcc.gnu.org/bugzilla/show_bug.cgi?id=10676

Since commit cafa0010cd51 ("Raise the minimum required gcc version to
4.6"), this is the case.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/hid/hid-picolcd_cir.c           |  3 +--
 drivers/media/common/siano/smsir.c      |  8 ++++----
 drivers/media/i2c/cx25840/cx25840-ir.c  |  6 ++----
 drivers/media/pci/cx23885/cx23888-ir.c  |  6 ++----
 drivers/media/pci/cx88/cx88-input.c     |  3 +--
 drivers/media/rc/ene_ir.c               | 12 ++++++------
 drivers/media/rc/fintek-cir.c           |  3 +--
 drivers/media/rc/igorplugusb.c          |  2 +-
 drivers/media/rc/iguanair.c             |  4 +---
 drivers/media/rc/imon_raw.c             |  2 +-
 drivers/media/rc/ir-hix5hd2.c           |  2 +-
 drivers/media/rc/ite-cir.c              |  5 +----
 drivers/media/rc/mceusb.c               | 15 ++++++++-------
 drivers/media/rc/meson-ir.c             |  2 +-
 drivers/media/rc/mtk-cir.c              |  2 +-
 drivers/media/rc/nuvoton-cir.c          |  2 +-
 drivers/media/rc/rc-core-priv.h         |  7 ++++---
 drivers/media/rc/rc-ir-raw.c            | 12 ++++++------
 drivers/media/rc/rc-loopback.c          |  2 +-
 drivers/media/rc/redrat3.c              | 10 +++++-----
 drivers/media/rc/serial_ir.c            | 10 +++++-----
 drivers/media/rc/sir_ir.c               |  2 +-
 drivers/media/rc/st_rc.c                |  5 ++---
 drivers/media/rc/streamzap.c            | 12 ++++++------
 drivers/media/rc/sunxi-cir.c            |  2 +-
 drivers/media/rc/ttusbir.c              |  4 +---
 drivers/media/rc/winbond-cir.c          | 12 ++++++------
 drivers/media/usb/au0828/au0828-input.c |  5 +----
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  4 +---
 include/media/rc-core.h                 | 11 +----------
 30 files changed, 74 insertions(+), 101 deletions(-)

diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index 32747b7f917e..bf6f29ca3315 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -45,7 +45,7 @@ int picolcd_raw_cir(struct picolcd_data *data,
 {
 	unsigned long flags;
 	int i, w, sz;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	/* ignore if rc_dev is NULL or status is shunned */
 	spin_lock_irqsave(&data->lock, flags);
@@ -67,7 +67,6 @@ int picolcd_raw_cir(struct picolcd_data *data,
 	 */
 	sz = size > 0 ? min((int)raw_data[0], size-1) : 0;
 	for (i = 0; i+1 < sz; i += 2) {
-		init_ir_raw_event(&rawir);
 		w = (raw_data[i] << 8) | (raw_data[i+1]);
 		rawir.pulse = !!(w & 0x8000);
 		rawir.duration = US_TO_NS(rawir.pulse ? (65536 - w) : w);
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 56db0a944421..1c2324f0e05a 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -26,10 +26,10 @@ void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
 	const s32 *samples = (const void *)buf;
 
 	for (i = 0; i < len >> 2; i++) {
-		DEFINE_IR_RAW_EVENT(ev);
-
-		ev.duration = abs(samples[i]) * 1000; /* Convert to ns */
-		ev.pulse = (samples[i] > 0) ? false : true;
+		struct ir_raw_event ev = {
+			.duration = abs(samples[i]) * 1000, /* Convert to ns */
+			.pulse = (samples[i] > 0) ? false : true
+		};
 
 		ir_raw_event_store(coredev->ir.dev, &ev);
 	}
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index ad7f66c7aac8..69cdc09981af 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -701,10 +701,8 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		if (v > IR_MAX_DURATION)
 			v = IR_MAX_DURATION;
 
-		init_ir_raw_event(&p->ir_core_data);
-		p->ir_core_data.pulse = u;
-		p->ir_core_data.duration = v;
-		p->ir_core_data.timeout = w;
+		p->ir_core_data = (struct ir_raw_event)
+			{ .pulse = u, .duration = v, .timeout = w };
 
 		v4l2_dbg(2, ir_debug, sd, "rx read: %10u ns  %s  %s\n",
 			 v, u ? "mark" : "space", w ? "(timed out)" : "");
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index 00329f668b59..1d775c90df51 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -696,10 +696,8 @@ static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		if (v > IR_MAX_DURATION)
 			v = IR_MAX_DURATION;
 
-		init_ir_raw_event(&p->ir_core_data);
-		p->ir_core_data.pulse = u;
-		p->ir_core_data.duration = v;
-		p->ir_core_data.timeout = w;
+		p->ir_core_data = (struct ir_raw_event)
+			{ .pulse = u, .duration = v, .timeout = w };
 
 		v4l2_dbg(2, ir_888_debug, sd, "rx read: %10u ns  %s  %s\n",
 			 v, u ? "mark" : "space", w ? "(timed out)" : "");
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 2f5debce4905..0642610f316e 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -535,7 +535,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	struct cx88_IR *ir = core->ir;
 	u32 samples;
 	unsigned int todo, bits;
-	struct ir_raw_event ev;
+	struct ir_raw_event ev = {};
 
 	if (!ir || !ir->sampling)
 		return;
@@ -550,7 +550,6 @@ void cx88_ir_irq(struct cx88_core *core)
 	if (samples == 0xff && ir->dev->idle)
 		return;
 
-	init_ir_raw_event(&ev);
 	for (todo = 32; todo > 0; todo -= bits) {
 		ev.pulse = samples & 0x80000000 ? false : true;
 		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 71b8c9bbf6c4..dd2fd307ef85 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -326,8 +326,6 @@ static int ene_rx_get_sample_reg(struct ene_device *dev)
 /* Sense current received carrier */
 static void ene_rx_sense_carrier(struct ene_device *dev)
 {
-	DEFINE_IR_RAW_EVENT(ev);
-
 	int carrier, duty_cycle;
 	int period = ene_read_reg(dev, ENE_CIRCAR_PRD);
 	int hperiod = ene_read_reg(dev, ENE_CIRCAR_HPRD);
@@ -348,9 +346,11 @@ static void ene_rx_sense_carrier(struct ene_device *dev)
 	dbg("RX: sensed carrier = %d Hz, duty cycle %d%%",
 						carrier, duty_cycle);
 	if (dev->carrier_detect_enabled) {
-		ev.carrier_report = true;
-		ev.carrier = carrier;
-		ev.duty_cycle = duty_cycle;
+		struct ir_raw_event ev = {
+			.carrier_report = true,
+			.carrier = carrier,
+			.duty_cycle = duty_cycle
+		};
 		ir_raw_event_store(dev->rdev, &ev);
 	}
 }
@@ -733,7 +733,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 	unsigned long flags;
 	irqreturn_t retval = IRQ_NONE;
 	struct ene_device *dev = (struct ene_device *)data;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index f2639d0c2fca..601944666b71 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -282,7 +282,7 @@ static int fintek_cmdsize(u8 cmd, u8 subcmd)
 /* process ir data stored in driver buffer */
 static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	u8 sample;
 	bool event = false;
 	int i;
@@ -314,7 +314,6 @@ static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 			break;
 		case PARSE_IRDATA:
 			fintek->rem--;
-			init_ir_raw_event(&rawir);
 			rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
 			rawir.duration = US_TO_NS((sample & BUF_SAMPLE_MASK)
 					  * CIR_SAMPLE_PERIOD);
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index f563ddd7f739..ba3f95a97f14 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -56,7 +56,7 @@ static void igorplugusb_cmd(struct igorplugusb *ir, int cmd);
 
 static void igorplugusb_irdata(struct igorplugusb *ir, unsigned len)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	unsigned i, start, overflow;
 
 	dev_dbg(ir->dev, "irdata: %*ph (len=%u)", len, ir->buf_in, len);
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 7daac8bab83b..fbacb13b614b 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -129,12 +129,10 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
 			break;
 		}
 	} else if (len >= 7) {
-		DEFINE_IR_RAW_EVENT(rawir);
+		struct ir_raw_event rawir = {};
 		unsigned i;
 		bool event = false;
 
-		init_ir_raw_event(&rawir);
-
 		for (i = 0; i < 7; i++) {
 			if (ir->buf_in[i] == 0x80) {
 				rawir.pulse = false;
diff --git a/drivers/media/rc/imon_raw.c b/drivers/media/rc/imon_raw.c
index 32709f96de14..7796098d9c30 100644
--- a/drivers/media/rc/imon_raw.c
+++ b/drivers/media/rc/imon_raw.c
@@ -28,7 +28,7 @@ static inline int is_bit_set(const u8 *buf, int bit)
 
 static void imon_ir_data(struct imon *imon)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	int offset = 0, size = 5 * 8;
 	int bit;
 
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 700ab4c563d0..abc4d6c1b323 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -175,7 +175,7 @@ static irqreturn_t hix5hd2_ir_rx_interrupt(int irq, void *data)
 	}
 
 	if ((irq_sr & INTMS_SYMBRCV) || (irq_sr & INTMS_TIMEOUT)) {
-		DEFINE_IR_RAW_EVENT(ev);
+		struct ir_raw_event ev = {};
 
 		symb_num = readl_relaxed(priv->base + IR_DATAH);
 		for (i = 0; i < symb_num; i++) {
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index de77d22c30a7..cd3c60ba8519 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -173,7 +173,7 @@ static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
 	u32 sample_period;
 	unsigned long *ldata;
 	unsigned int next_one, next_zero, size;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	if (length == 0)
 		return;
@@ -1507,9 +1507,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* initialize spinlocks */
 	spin_lock_init(&itdev->lock);
 
-	/* initialize raw event */
-	init_ir_raw_event(&itdev->rawir);
-
 	/* set driver data into the pnp device */
 	pnp_set_drvdata(pdev, itdev);
 	itdev->pdev = pdev;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 4c0c8008872a..8f251f407732 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1078,7 +1078,7 @@ static int mceusb_set_rx_carrier_report(struct rc_dev *dev, int enable)
  */
 static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	u8 hi = ir->buf_in[index + 1] & 0xff;
 	u8 lo = ir->buf_in[index + 2] & 0xff;
 	u32 carrier_cycles;
@@ -1152,7 +1152,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	bool event = false;
 	int i = 0;
 
@@ -1175,7 +1175,6 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			break;
 		case PARSE_IRDATA:
 			ir->rem--;
-			init_ir_raw_event(&rawir);
 			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK);
 			if (unlikely(!rawir.duration)) {
@@ -1215,11 +1214,13 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			if (ir->rem) {
 				ir->parser_state = PARSE_IRDATA;
 			} else {
-				init_ir_raw_event(&rawir);
-				rawir.timeout = 1;
-				rawir.duration = ir->rc->timeout;
+				struct ir_raw_event ev = {
+					.timeout = 1,
+					.duration = ir->rc->timeout
+				};
+
 				if (ir_raw_event_store_with_filter(ir->rc,
-								   &rawir))
+								   &ev))
 					event = true;
 				ir->pulse_tunit = 0;
 				ir->pulse_count = 0;
diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index f449b35d25e7..9914c83fecb9 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -86,7 +86,7 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
 {
 	struct meson_ir *ir = dev_id;
 	u32 duration, status;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	spin_lock(&ir->lock);
 
diff --git a/drivers/media/rc/mtk-cir.c b/drivers/media/rc/mtk-cir.c
index e42efd9d382e..31b7bb431497 100644
--- a/drivers/media/rc/mtk-cir.c
+++ b/drivers/media/rc/mtk-cir.c
@@ -212,7 +212,7 @@ static irqreturn_t mtk_ir_irq(int irqno, void *dev_id)
 	struct mtk_ir *ir = dev_id;
 	u8  wid = 0;
 	u32 i, j, val;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	/*
 	 * Reset decoder state machine explicitly is required
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index b8299c9a9744..5c2cd8d2d155 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -737,7 +737,7 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
  */
 static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	u8 sample;
 	int i;
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index e847bdad5c51..22b0ec853acc 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -181,9 +181,10 @@ static inline void init_ir_raw_event_duration(struct ir_raw_event *ev,
 					      unsigned int pulse,
 					      u32 duration)
 {
-	init_ir_raw_event(ev);
-	ev->duration = duration;
-	ev->pulse = pulse;
+	*ev = (struct ir_raw_event) {
+		.duration = duration,
+		.pulse = pulse
+	};
 }
 
 /**
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index e7948908e78c..e10b4644a442 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -102,7 +102,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store);
 int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 {
 	ktime_t			now;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event	ev = {};
 
 	if (!dev->raw)
 		return -EINVAL;
@@ -210,7 +210,7 @@ void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
 	if (idle) {
 		dev->raw->this_ev.timeout = true;
 		ir_raw_event_store(dev, &dev->raw->this_ev);
-		init_ir_raw_event(&dev->raw->this_ev);
+		dev->raw->this_ev = (struct ir_raw_event) {};
 	}
 
 	if (dev->s_idle)
@@ -562,10 +562,10 @@ static void ir_raw_edge_handle(struct timer_list *t)
 	spin_lock_irqsave(&dev->raw->edge_spinlock, flags);
 	interval = ktime_sub(ktime_get(), dev->raw->last_event);
 	if (ktime_to_ns(interval) >= dev->timeout) {
-		DEFINE_IR_RAW_EVENT(ev);
-
-		ev.timeout = true;
-		ev.duration = ktime_to_ns(interval);
+		struct ir_raw_event ev = {
+			.timeout = true,
+			.duration = ktime_to_ns(interval)
+		};
 
 		ir_raw_event_store(dev, &ev);
 	} else {
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 3822d9ebcb46..b9f9325b8db1 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -103,7 +103,7 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	struct loopback_dev *lodev = dev->priv;
 	u32 rxmask;
 	unsigned i;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	if (lodev->txcarrier < lodev->rxcarriermin ||
 	    lodev->txcarrier > lodev->rxcarriermax) {
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 6bfc24885b5c..08c51ffd74a0 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -348,7 +348,7 @@ static u32 redrat3_us_to_len(u32 microsec)
 
 static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	struct device *dev;
 	unsigned int i, sig_size, single_len, offset, val;
 	u32 mod_freq;
@@ -358,10 +358,10 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 	mod_freq = redrat3_val_to_mod_freq(&rr3->irdata);
 	dev_dbg(dev, "Got mod_freq of %u\n", mod_freq);
 	if (mod_freq && rr3->wideband) {
-		DEFINE_IR_RAW_EVENT(ev);
-
-		ev.carrier_report = 1;
-		ev.carrier = mod_freq;
+		struct ir_raw_event ev = {
+			.carrier_report = 1,
+			.carrier = mod_freq
+		};
 
 		ir_raw_event_store(rr3->rc, &ev);
 	}
diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 8bf5637b3a69..ffe2c672d105 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -273,7 +273,7 @@ static void frbwrite(unsigned int l, bool is_pulse)
 {
 	/* simple noise filter */
 	static unsigned int ptr, pulse, space;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	if (ptr > 0 && is_pulse) {
 		pulse += l;
@@ -472,10 +472,10 @@ static int hardware_init_port(void)
 
 static void serial_ir_timeout(struct timer_list *unused)
 {
-	DEFINE_IR_RAW_EVENT(ev);
-
-	ev.timeout = true;
-	ev.duration = serial_ir.rcdev->timeout;
+	struct ir_raw_event ev = {
+		.timeout = true,
+		.duration = serial_ir.rcdev->timeout
+	};
 	ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
 	ir_raw_event_handle(serial_ir.rcdev);
 }
diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index 9ee2c9196b4d..c8951650a368 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -96,7 +96,7 @@ static int sir_tx_ir(struct rc_dev *dev, unsigned int *tx_buf,
 
 static void add_read_queue(int flag, unsigned long val)
 {
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	pr_debug("add flag %d with val %lu\n", flag, val);
 
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index c855b177103c..15de3ae166a2 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -67,8 +67,7 @@ struct st_rc_device {
 
 static void st_rc_send_lirc_timeout(struct rc_dev *rdev)
 {
-	DEFINE_IR_RAW_EVENT(ev);
-	ev.timeout = true;
+	struct ir_raw_event ev = { .timeout = true, .duration = rdev->timeout };
 	ir_raw_event_store(rdev, &ev);
 }
 
@@ -101,7 +100,7 @@ static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
 	struct st_rc_device *dev = data;
 	int last_symbol = 0;
 	u32 status, int_status;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	if (dev->irq_wake)
 		pm_wakeup_event(dev->dev, 0);
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index c9a70fda88a8..79ec805ea4eb 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -130,7 +130,7 @@ static void sz_push(struct streamzap_ir *sz, struct ir_raw_event rawir)
 static void sz_push_full_pulse(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	if (sz->idle) {
 		int delta;
@@ -175,7 +175,7 @@ static void sz_push_half_pulse(struct streamzap_ir *sz,
 static void sz_push_full_space(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	rawir.pulse = false;
 	rawir.duration = ((int) value) * SZ_RESOLUTION;
@@ -249,10 +249,10 @@ static void streamzap_callback(struct urb *urb)
 			break;
 		case FullSpace:
 			if (sz->buf_in[i] == SZ_TIMEOUT) {
-				DEFINE_IR_RAW_EVENT(rawir);
-
-				rawir.pulse = false;
-				rawir.duration = sz->rdev->timeout;
+				struct ir_raw_event rawir = {
+					.pulse = false,
+					.duration = sz->rdev->timeout
+				};
 				sz->idle = true;
 				if (sz->timeout_enabled)
 					sz_push(sz, rawir);
diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index f500cea228a9..307e44714ea0 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -99,7 +99,7 @@ static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
 	unsigned char dt;
 	unsigned int cnt, rc;
 	struct sunxi_ir *ir = dev_id;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	spin_lock(&ir->ir_lock);
 
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index aafea3c5170b..8d4b56d057ae 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -117,12 +117,10 @@ static void ttusbir_bulk_complete(struct urb *urb)
  */
 static void ttusbir_process_ir_data(struct ttusbir *tt, uint8_t *buf)
 {
-	struct ir_raw_event rawir;
+	struct ir_raw_event rawir = {};
 	unsigned i, v, b;
 	bool event = false;
 
-	init_ir_raw_event(&rawir);
-
 	for (i = 0; i < 128; i++) {
 		v = buf[i] & 0xfe;
 		switch (v) {
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 851acba9b436..0f07a2c384fa 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -322,11 +322,11 @@ wbcir_carrier_report(struct wbcir_data *data)
 			inb(data->ebase + WBCIR_REG_ECEIR_CNT_HI) << 8;
 
 	if (counter > 0 && counter < 0xffff) {
-		DEFINE_IR_RAW_EVENT(ev);
-
-		ev.carrier_report = 1;
-		ev.carrier = DIV_ROUND_CLOSEST(counter * 1000000u,
-						data->pulse_duration);
+		struct ir_raw_event ev = {
+			.carrier_report = 1,
+			.carrier = DIV_ROUND_CLOSEST(counter * 1000000u,
+						data->pulse_duration)
+		};
 
 		ir_raw_event_store(data->dev, &ev);
 	}
@@ -362,7 +362,7 @@ static void
 wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 {
 	u8 irdata;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	unsigned duration;
 
 	/* Since RXHDLEV is set, at least 8 bytes are in the FIFO */
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 832ed9f25784..4befa920246c 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -113,7 +113,7 @@ static int au8522_rc_andor(struct au0828_rc *ir, u16 reg, u8 mask, u8 value)
 static int au0828_get_key_au8522(struct au0828_rc *ir)
 {
 	unsigned char buf[40];
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	int i, j, rc;
 	int prv_bit, bit, width;
 	bool first = true;
@@ -167,7 +167,6 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 			if (first) {
 				first = false;
 
-				init_ir_raw_event(&rawir);
 				rawir.pulse = true;
 				if (width > NEC_START_SPACE - 2 &&
 				    width < NEC_START_SPACE + 2) {
@@ -186,7 +185,6 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 				ir_raw_event_store(ir->rc, &rawir);
 			}
 
-			init_ir_raw_event(&rawir);
 			rawir.pulse = prv_bit ? false : true;
 			rawir.duration = AU8522_UNIT * width;
 			dprintk(16, "Storing %s with duration %d",
@@ -199,7 +197,6 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 		}
 	}
 
-	init_ir_raw_event(&rawir);
 	rawir.pulse = prv_bit ? false : true;
 	rawir.duration = AU8522_UNIT * width;
 	dprintk(16, "Storing end %s with duration %d",
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a970224a94bd..a552f88f5ea4 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1685,7 +1685,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i, len;
 	struct rtl28xxu_dev *dev = d->priv;
-	struct ir_raw_event ev;
+	struct ir_raw_event ev = {};
 	u8 buf[128];
 	static const struct rtl28xxu_reg_val_mask refresh_tab[] = {
 		{IR_RX_IF,               0x03, 0xff},
@@ -1751,8 +1751,6 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 	}
 
 	/* pass data to Kernel IR decoder */
-	init_ir_raw_event(&ev);
-
 	for (i = 0; i < len; i++) {
 		ev.pulse = buf[i] >> 7;
 		ev.duration = 50800 * (buf[i] & 0x7f);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 61571773a98d..c0cfbe16a854 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -317,13 +317,6 @@ struct ir_raw_event {
 	unsigned                carrier_report:1;
 };
 
-#define DEFINE_IR_RAW_EVENT(event) struct ir_raw_event event = {}
-
-static inline void init_ir_raw_event(struct ir_raw_event *ev)
-{
-	memset(ev, 0, sizeof(*ev));
-}
-
 #define IR_DEFAULT_TIMEOUT	MS_TO_NS(125)
 #define IR_MAX_DURATION         500000000	/* 500 ms */
 #define US_TO_NS(usec)		((usec) * 1000)
@@ -344,9 +337,7 @@ int ir_raw_encode_carrier(enum rc_proto protocol);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-	struct ir_raw_event ev = { .reset = true };
-
-	ir_raw_event_store(dev, &ev);
+	ir_raw_event_store(dev, &((struct ir_raw_event) { .reset = true }));
 	dev->idle = true;
 	ir_raw_event_handle(dev);
 }
-- 
2.17.1
