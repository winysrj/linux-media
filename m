Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:38537 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520AbcDLM1z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2016 08:27:55 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] rc: Remove init_ir_raw_event and DEFINE_IR_RAW_EVENT
Date: Tue, 12 Apr 2016 13:27:52 +0100
Message-Id: <1460464072-2245-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These can be done with regular c99 constructs, which makes the
code cleaner and more transparent.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/hid/hid-picolcd_cir.c           |  3 +--
 drivers/media/common/siano/smsir.c      |  2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c  |  6 ++----
 drivers/media/pci/cx23885/cx23888-ir.c  |  6 ++----
 drivers/media/pci/cx88/cx88-input.c     |  3 +--
 drivers/media/rc/ene_ir.c               |  5 ++---
 drivers/media/rc/fintek-cir.c           |  3 +--
 drivers/media/rc/gpio-ir-recv.c         |  2 +-
 drivers/media/rc/igorplugusb.c          |  2 +-
 drivers/media/rc/iguanair.c             |  4 +---
 drivers/media/rc/ir-hix5hd2.c           |  2 +-
 drivers/media/rc/ite-cir.c              |  5 +----
 drivers/media/rc/mceusb.c               |  3 +--
 drivers/media/rc/meson-ir.c             |  2 +-
 drivers/media/rc/nuvoton-cir.c          |  4 +---
 drivers/media/rc/rc-ir-raw.c            |  4 ++--
 drivers/media/rc/rc-loopback.c          |  2 +-
 drivers/media/rc/redrat3.c              |  2 +-
 drivers/media/rc/st_rc.c                |  5 ++---
 drivers/media/rc/streamzap.c            | 12 ++++++------
 drivers/media/rc/sunxi-cir.c            |  2 +-
 drivers/media/rc/ttusbir.c              |  4 +---
 drivers/media/rc/winbond-cir.c          |  4 ++--
 drivers/media/usb/au0828/au0828-input.c |  5 +----
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  4 +---
 include/media/rc-core.h                 | 15 +--------------
 26 files changed, 37 insertions(+), 74 deletions(-)

diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index 9628651..b723307 100644
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
index 41f2a39..0931111 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -41,7 +41,7 @@ void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
 	const s32 *samples = (const void *)buf;
 
 	for (i = 0; i < len >> 2; i++) {
-		DEFINE_IR_RAW_EVENT(ev);
+		struct ir_raw_event ev = {};
 
 		ev.duration = abs(samples[i]) * 1000; /* Convert to ns */
 		ev.pulse = (samples[i] > 0) ? false : true;
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 4b78201..84bef3e 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -706,10 +706,8 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
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
index c1aa888..5bf7abb 100644
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
index 3f1342c..c0ed801 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -529,7 +529,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	struct cx88_IR *ir = core->ir;
 	u32 samples;
 	unsigned todo, bits;
-	struct ir_raw_event ev;
+	struct ir_raw_event ev = {};
 
 	if (!ir || !ir->sampling)
 		return;
@@ -544,7 +544,6 @@ void cx88_ir_irq(struct cx88_core *core)
 	if (samples == 0xff && ir->dev->idle)
 		return;
 
-	init_ir_raw_event(&ev);
 	for (todo = 32; todo > 0; todo -= bits) {
 		ev.pulse = samples & 0x80000000 ? false : true;
 		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 8d77e1c..8a68713 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -331,8 +331,7 @@ static int ene_rx_get_sample_reg(struct ene_device *dev)
 /* Sense current received carrier */
 static void ene_rx_sense_carrier(struct ene_device *dev)
 {
-	DEFINE_IR_RAW_EVENT(ev);
-
+	struct ir_raw_event ev = {};
 	int carrier, duty_cycle;
 	int period = ene_read_reg(dev, ENE_CIRCAR_PRD);
 	int hperiod = ene_read_reg(dev, ENE_CIRCAR_HPRD);
@@ -738,7 +737,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 	unsigned long flags;
 	irqreturn_t retval = IRQ_NONE;
 	struct ene_device *dev = (struct ene_device *)data;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index bd7b3bd..19f0b79 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -291,7 +291,7 @@ static int fintek_cmdsize(u8 cmd, u8 subcmd)
 /* process ir data stored in driver buffer */
 static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	u8 sample;
 	bool event = false;
 	int i;
@@ -323,7 +323,6 @@ static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 			break;
 		case PARSE_IRDATA:
 			fintek->rem--;
-			init_ir_raw_event(&rawir);
 			rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
 			rawir.duration = US_TO_NS((sample & BUF_SAMPLE_MASK)
 					  * CIR_SAMPLE_PERIOD);
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 5b63b1f..ea8a735 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -106,7 +106,7 @@ err_get_value:
 static void flush_timer(unsigned long arg)
 {
 	struct gpio_rc_dev *gpio_dev = (struct gpio_rc_dev *)arg;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	ev.timeout = true;
 	ev.duration = gpio_dev->rcdev->timeout;
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index e0c531f..385ea53 100644
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
index ee60e17..73a6b35 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -132,12 +132,10 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
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
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index d0549fb..f20b025 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -157,7 +157,7 @@ static irqreturn_t hix5hd2_ir_rx_interrupt(int irq, void *data)
 	}
 
 	if ((irq_sr & INTMS_SYMBRCV) || (irq_sr & INTMS_TIMEOUT)) {
-		DEFINE_IR_RAW_EVENT(ev);
+		struct ir_raw_event ev = {};
 
 		symb_num = readl_relaxed(priv->base + IR_DATAH);
 		for (i = 0; i < symb_num; i++) {
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 0f30190..c9ffcd3 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -180,7 +180,7 @@ static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
 	u32 sample_period;
 	unsigned long *ldata;
 	unsigned int next_one, next_zero, size;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	if (length == 0)
 		return;
@@ -1513,9 +1513,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* initialize spinlocks */
 	spin_lock_init(&itdev->lock);
 
-	/* initialize raw event */
-	init_ir_raw_event(&itdev->rawir);
-
 	/* set driver data into the pnp device */
 	pnp_set_drvdata(pdev, itdev);
 	itdev->pdev = pdev;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 35155ae..dd3ffd8 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -980,7 +980,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	bool event = false;
 	int i = 0;
 
@@ -1003,7 +1003,6 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			break;
 		case PARSE_IRDATA:
 			ir->rem--;
-			init_ir_raw_event(&rawir);
 			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
 					 * US_TO_NS(MCE_TIME_UNIT);
diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index fcc3b82..ff6929a 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -77,7 +77,7 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
 {
 	struct meson_ir *ir = dev_id;
 	u32 duration;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	spin_lock(&ir->lock);
 
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 99b303b..09301cc 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -777,7 +777,7 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
  */
 static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	u8 sample;
 	int i;
 
@@ -788,8 +788,6 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 
 	nvt_dbg_verbose("Processing buffer of len %d", nvt->pkts);
 
-	init_ir_raw_event(&rawir);
-
 	for (i = 0; i < nvt->pkts; i++) {
 		sample = nvt->buf[i];
 
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 144304c..ecfa186 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -107,7 +107,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 {
 	ktime_t			now;
 	s64			delta; /* ns */
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event	ev = {};
 	int			rc = 0;
 	int			delay;
 
@@ -200,7 +200,7 @@ void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
 	if (idle) {
 		dev->raw->this_ev.timeout = true;
 		ir_raw_event_store(dev, &dev->raw->this_ev);
-		init_ir_raw_event(&dev->raw->this_ev);
+		dev->raw->this_ev = (struct ir_raw_event) {};
 	}
 
 	if (dev->s_idle)
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 63dace8..d56d731 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -106,7 +106,7 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	struct loopback_dev *lodev = dev->priv;
 	u32 rxmask;
 	unsigned i;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	if (lodev->txcarrier < lodev->rxcarriermin ||
 	    lodev->txcarrier > lodev->rxcarriermax) {
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index ec74244..f455839 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -341,7 +341,7 @@ static void redrat3_rx_timeout(unsigned long data)
 
 static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	struct device *dev;
 	unsigned i, trailer = 0;
 	unsigned sig_size, single_len, offset, val;
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 1fa0c9d..8dae0ab 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -67,8 +67,7 @@ struct st_rc_device {
 
 static void st_rc_send_lirc_timeout(struct rc_dev *rdev)
 {
-	DEFINE_IR_RAW_EVENT(ev);
-	ev.timeout = true;
+	struct ir_raw_event ev = { .timeout = true };
 	ir_raw_event_store(rdev, &ev);
 }
 
@@ -100,7 +99,7 @@ static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
 	struct st_rc_device *dev = data;
 	int last_symbol = 0;
 	u32 status;
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 
 	if (dev->irq_wake)
 		pm_wakeup_event(dev->dev, 0);
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 815243c..2edc6bc 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -134,7 +134,7 @@ static void sz_push(struct streamzap_ir *sz, struct ir_raw_event rawir)
 static void sz_push_full_pulse(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	if (sz->idle) {
 		int delta;
@@ -179,7 +179,7 @@ static void sz_push_half_pulse(struct streamzap_ir *sz,
 static void sz_push_full_space(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	rawir.pulse = false;
 	rawir.duration = ((int) value) * SZ_RESOLUTION;
@@ -253,10 +253,10 @@ static void streamzap_callback(struct urb *urb)
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
index eaadc08..eb2f7b0 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -103,7 +103,7 @@ static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
 	unsigned char dt;
 	unsigned int cnt, rc;
 	struct sunxi_ir *ir = dev_id;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 
 	spin_lock(&ir->ir_lock);
 
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index bc214e2..bea42e2 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -121,12 +121,10 @@ static void ttusbir_bulk_complete(struct urb *urb)
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
index d839f73..e373f86 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -342,7 +342,7 @@ wbcir_carrier_report(struct wbcir_data *data)
 			inb(data->ebase + WBCIR_REG_ECEIR_CNT_HI) << 8;
 
 	if (counter > 0 && counter < 0xffff) {
-		DEFINE_IR_RAW_EVENT(ev);
+		struct ir_raw_event ev = {};
 
 		ev.carrier_report = 1;
 		ev.carrier = DIV_ROUND_CLOSEST(counter * 1000000u,
@@ -382,7 +382,7 @@ static void
 wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 {
 	u8 irdata;
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	unsigned duration;
 
 	/* Since RXHDLEV is set, at least 8 bytes are in the FIFO */
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 3d6687f..09444cd 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -124,7 +124,7 @@ static int au8522_rc_andor(struct au0828_rc *ir, u16 reg, u8 mask, u8 value)
 static int au0828_get_key_au8522(struct au0828_rc *ir)
 {
 	unsigned char buf[40];
-	DEFINE_IR_RAW_EVENT(rawir);
+	struct ir_raw_event rawir = {};
 	int i, j, rc;
 	int prv_bit, bit, width;
 	bool first = true;
@@ -178,7 +178,6 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 			if (first) {
 				first = false;
 
-				init_ir_raw_event(&rawir);
 				rawir.pulse = true;
 				if (width > NEC_START_SPACE - 2 &&
 				    width < NEC_START_SPACE + 2) {
@@ -197,7 +196,6 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 				ir_raw_event_store(ir->rc, &rawir);
 			}
 
-			init_ir_raw_event(&rawir);
 			rawir.pulse = prv_bit ? false : true;
 			rawir.duration = AU8522_UNIT * width;
 			dprintk(16, "Storing %s with duration %d",
@@ -210,7 +208,6 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 		}
 	}
 
-	init_ir_raw_event(&rawir);
 	rawir.pulse = prv_bit ? false : true;
 	rawir.duration = AU8522_UNIT * width;
 	dprintk(16, "Storing end %s with duration %d",
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index fa72642..beff536 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1682,7 +1682,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i, len;
 	struct rtl28xxu_dev *dev = d->priv;
-	struct ir_raw_event ev;
+	struct ir_raw_event ev = {};
 	u8 buf[128];
 	static const struct rtl28xxu_reg_val_mask refresh_tab[] = {
 		{IR_RX_IF,               0x03, 0xff},
@@ -1748,8 +1748,6 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 	}
 
 	/* pass data to Kernel IR decoder */
-	init_ir_raw_event(&ev);
-
 	for (i = 0; i < len; i++) {
 		ev.pulse = buf[i] >> 7;
 		ev.duration = 50800 * (buf[i] & 0x7f);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0f77b3d..705ca6b 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -228,19 +228,6 @@ struct ir_raw_event {
 	unsigned                carrier_report:1;
 };
 
-#define DEFINE_IR_RAW_EVENT(event) \
-	struct ir_raw_event event = { \
-		{ .duration = 0 } , \
-		.pulse = 0, \
-		.reset = 0, \
-		.timeout = 0, \
-		.carrier_report = 0 }
-
-static inline void init_ir_raw_event(struct ir_raw_event *ev)
-{
-	memset(ev, 0, sizeof(*ev));
-}
-
 #define IR_DEFAULT_TIMEOUT	MS_TO_NS(125)
 #define IR_MAX_DURATION         500000000	/* 500 ms */
 #define US_TO_NS(usec)		((usec) * 1000)
@@ -256,7 +243,7 @@ void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-	DEFINE_IR_RAW_EVENT(ev);
+	struct ir_raw_event ev = {};
 	ev.reset = true;
 
 	ir_raw_event_store(dev, &ev);
-- 
2.1.4

