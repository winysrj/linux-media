Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44271 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab2EWJyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:54 -0400
Subject: [PATCH 13/43] rc-core: use a kfifo for TX data
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:43:09 +0200
Message-ID: <20120523094308.14474.244.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using a per rc_dev TX kfifo for TX data simplifies the device drivers and lays
the ground for the next patch.

This means that every driver with TX capabilities need to be changed at the same
time.

It should be noted that the redrat TX functionality was almost completely
rewritten (to be less obfuscated and kmalloc-happy) and that the
TX functionality in nuvoton-cir.c is, and was, probably broken
before and after this patch.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ene_ir.c        |   47 +++----
 drivers/media/rc/ene_ir.h        |    9 -
 drivers/media/rc/ir-lirc-codec.c |   57 +++------
 drivers/media/rc/ite-cir.c       |   17 +--
 drivers/media/rc/mceusb.c        |   77 +++++-------
 drivers/media/rc/nuvoton-cir.c   |   51 ++++----
 drivers/media/rc/nuvoton-cir.h   |    9 -
 drivers/media/rc/rc-loopback.c   |   21 +--
 drivers/media/rc/rc-main.c       |   10 ++
 drivers/media/rc/redrat3.c       |  245 +++++++++++++++-----------------------
 drivers/media/rc/winbond-cir.c   |   48 +++----
 include/media/rc-core.h          |   40 ++++--
 12 files changed, 267 insertions(+), 364 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 10621dc..ec09646 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -604,7 +604,7 @@ static void ene_tx_enable(struct ene_device *dev)
 static void ene_tx_disable(struct ene_device *dev)
 {
 	ene_write_reg(dev, ENE_CIRCFG, dev->saved_conf1);
-	dev->tx_buffer = NULL;
+	init_ir_raw_event(&dev->tx_event);
 }
 
 
@@ -612,18 +612,11 @@ static void ene_tx_disable(struct ene_device *dev)
 static void ene_tx_sample(struct ene_device *dev)
 {
 	u8 raw_tx;
-	u32 sample;
-	bool pulse = dev->tx_sample_pulse;
-
-	if (!dev->tx_buffer) {
-		pr_warn("TX: BUG: attempt to transmit NULL buffer\n");
-		return;
-	}
 
 	/* Grab next TX sample */
-	if (!dev->tx_sample) {
+	if (!dev->tx_event.duration) {
 
-		if (dev->tx_pos == dev->tx_len) {
+		if (!kfifo_get(&dev->rdev->txfifo, &dev->tx_event)) {
 			if (!dev->tx_done) {
 				dbg("TX: no more data to send");
 				dev->tx_done = true;
@@ -636,21 +629,19 @@ static void ene_tx_sample(struct ene_device *dev)
 			}
 		}
 
-		sample = dev->tx_buffer[dev->tx_pos++];
-		dev->tx_sample_pulse = !dev->tx_sample_pulse;
-
-		dev->tx_sample = DIV_ROUND_CLOSEST(sample, sample_period);
-
-		if (!dev->tx_sample)
-			dev->tx_sample = 1;
+		dev->tx_event.duration = DIV_ROUND_CLOSEST(dev->tx_event.duration,
+							   US_TO_NS(sample_period));
+		if (!dev->tx_event.duration)
+			dev->tx_event.duration = 1;
 	}
 
-	raw_tx = min(dev->tx_sample , (unsigned int)ENE_CIRRLC_OUT_MASK);
-	dev->tx_sample -= raw_tx;
+	raw_tx = min_t(unsigned, dev->tx_event.duration, ENE_CIRRLC_OUT_MASK);
+	dev->tx_event.duration -= raw_tx;
 
 	dbg("TX: sample %8d (%s)", raw_tx * sample_period,
-						pulse ? "pulse" : "space");
-	if (pulse)
+	    dev->tx_event.pulse ? "pulse" : "space");
+
+	if (dev->tx_event.pulse)
 		raw_tx |= ENE_CIRRLC_OUT_PULSE;
 
 	ene_write_reg(dev,
@@ -954,20 +945,16 @@ static void ene_set_idle(struct rc_dev *rdev, bool idle)
 }
 
 /* outside interface: transmit */
-static int ene_transmit(struct rc_dev *rdev, unsigned *buf, unsigned n)
+static int ene_transmit(struct rc_dev *rdev)
 {
 	struct ene_device *dev = rdev->priv;
 	unsigned long flags;
 
-	dev->tx_buffer = buf;
-	dev->tx_len = n;
-	dev->tx_pos = 0;
 	dev->tx_reg = 0;
-	dev->tx_done = 0;
-	dev->tx_sample = 0;
-	dev->tx_sample_pulse = 0;
+	dev->tx_done = false;
 
-	dbg("TX: %d samples", dev->tx_len);
+	init_ir_raw_event(&dev->tx_event);
+	dbg("TX: %d samples", kfifo_len(&rdev->txfifo));
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
@@ -986,7 +973,7 @@ static int ene_transmit(struct rc_dev *rdev, unsigned *buf, unsigned n)
 		spin_unlock_irqrestore(&dev->hw_lock, flags);
 	} else
 		dbg("TX: done");
-	return n;
+	return 0;
 }
 
 /* probe entry */
diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index 6f978e8..975d67a 100644
--- a/drivers/media/rc/ene_ir.h
+++ b/drivers/media/rc/ene_ir.h
@@ -222,15 +222,10 @@ struct ene_device {
 	bool rx_fan_input_inuse;		/* is fan input in use for rx*/
 	int tx_reg;				/* current reg used for TX */
 	u8  saved_conf1;			/* saved FEC0 reg */
-	unsigned int tx_sample;			/* current sample for TX */
-	bool tx_sample_pulse;			/* current sample is pulse */
 
 	/* TX buffer */
-	unsigned *tx_buffer;			/* input samples buffer*/
-	int tx_pos;				/* position in that buffer */
-	int tx_len;				/* current len of tx buffer */
-	int tx_done;				/* done transmitting */
-						/* one more sample pending*/
+	struct ir_raw_event tx_event;		/* current sample for TX */
+	bool tx_done;				/* done transmitting */
 	struct completion tx_complete;		/* TX completion */
 	struct timer_list tx_sim_timer;
 
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 1490a8b..795cbdf 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -102,52 +102,41 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
-	struct lirc_codec *lirc;
+	struct lirc_codec *lirc = lirc_get_pdata(file);
 	struct rc_dev *dev;
-	unsigned int *txbuf; /* buffer with values to transmit */
-	ssize_t ret = 0;
-	size_t count;
-	ktime_t start;
+	ktime_t start = ktime_get();
+	u32 value;
+	ssize_t ret;
 	s64 towait;
 	unsigned int duration = 0; /* signal duration in us */
-	int i;
-
-	start = ktime_get();
+	DEFINE_IR_RAW_EVENT(event);
+	bool pulse = true;
 
-	lirc = lirc_get_pdata(file);
-	if (!lirc)
+	if (!lirc || !lirc->dev)
 		return -EFAULT;
 
-	if (n < sizeof(unsigned) || n % sizeof(unsigned))
-		return -EINVAL;
+	dev = lirc->dev;
+	if (!dev->tx_ir)
+		return -ENOSYS;
 
-	count = n / sizeof(unsigned);
-	if (count > LIRCBUF_SIZE || count % 2 == 0)
+	if (n % sizeof(u32) || ((n / sizeof(u32)) % 2) == 0)
 		return -EINVAL;
 
-	txbuf = memdup_user(buf, n);
-	if (IS_ERR(txbuf))
-		return PTR_ERR(txbuf);
+	for (ret = 0; ret + sizeof(u32) <= n; ret += sizeof(u32)) {
+		if (copy_from_user(&value, buf + ret, sizeof(u32)))
+			return -EFAULT;
 
-	dev = lirc->dev;
-	if (!dev) {
-		ret = -EFAULT;
-		goto out;
-	}
+		event.pulse = pulse;
+		event.duration = US_TO_NS(value);
+		if (kfifo_in_spinlocked(&dev->txfifo, &event, 1, &dev->txlock)
+		    != 1)
+			break;
 
-	if (!dev->tx_ir) {
-		ret = -ENOSYS;
-		goto out;
+		pulse = !pulse;
+		duration += value;
 	}
 
-	ret = dev->tx_ir(dev, txbuf, (u32)count);
-	if (ret < 0)
-		goto out;
-
-	for (i = 0; i < ret; i++)
-		duration += txbuf[i];
-
-	ret *= sizeof(unsigned int);
+	dev->tx_ir(dev);
 
 	/*
 	 * The lircd gap calculation expects the write function to
@@ -160,8 +149,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		schedule_timeout(usecs_to_jiffies(towait));
 	}
 
-out:
-	kfree(txbuf);
 	return ret;
 }
 
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 494801e..5abb7c3 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -382,16 +382,15 @@ static int ite_set_tx_duty_cycle(struct rc_dev *rcdev, u32 duty_cycle)
 /* transmit out IR pulses; what you get here is a batch of alternating
  * pulse/space/pulse/space lengths that we should write out completely through
  * the FIFO, blocking on a full FIFO */
-static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
+static int ite_tx_ir(struct rc_dev *rcdev)
 {
 	unsigned long flags;
 	struct ite_dev *dev = rcdev->priv;
-	bool is_pulse = false;
 	int remaining_us, fifo_avail, fifo_remaining, last_idx = 0;
 	int max_rle_us, next_rle_us;
-	int ret = n;
 	u8 last_sent[ITE_TX_FIFO_LEN];
 	u8 val;
+	DEFINE_IR_RAW_EVENT(event);
 
 	ite_dbg("%s called", __func__);
 
@@ -421,14 +420,12 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 	fifo_avail =
 	    ITE_TX_FIFO_LEN - dev->params.get_tx_used_slots(dev);
 
-	while (n > 0 && dev->in_use) {
+	while (kfifo_get(&rcdev->txfifo, &event) && dev->in_use) {
 		/* transmit the next sample */
-		is_pulse = !is_pulse;
-		remaining_us = *(txbuf++);
-		n--;
+		remaining_us = event.duration;
 
 		ite_dbg("%s: %ld",
-				      ((is_pulse) ? "pulse" : "space"),
+				      (event.pulse ? "pulse" : "space"),
 				      (long int)
 				      remaining_us);
 
@@ -453,7 +450,7 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 			val = (val - 1) & ITE_TX_RLE_MASK;
 
 			/* take into account pulse/space prefix */
-			if (is_pulse)
+			if (event.pulse)
 				val |= ITE_TX_PULSE;
 
 			else
@@ -529,7 +526,7 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 /* idle the receiver if needed */
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 9f546be..c60ac4e 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -780,64 +780,51 @@ static void mce_flush_rx_buffer(struct mceusb_dev *ir, int size)
 }
 
 /* Send data out the IR blaster port(s) */
-static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
+static int mceusb_tx_ir(struct rc_dev *dev)
 {
 	struct mceusb_dev *ir = dev->priv;
-	int i, ret = 0;
-	int cmdcount = 0;
-	unsigned char cmdbuf[MCE_CMDBUF_SIZE]; /* MCE command buffer */
+	unsigned tmp, i = 0;
+	unsigned char buf[MCE_CMDBUF_SIZE]; /* MCE command buffer */
+	DEFINE_IR_RAW_EVENT(event);
 
 	/* MCE tx init header */
-	cmdbuf[cmdcount++] = MCE_CMD_PORT_IR;
-	cmdbuf[cmdcount++] = MCE_CMD_SETIRTXPORTS;
-	cmdbuf[cmdcount++] = ir->tx_mask;
-
-	/* Generate mce packet data */
-	for (i = 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
-		txbuf[i] = txbuf[i] / MCE_TIME_UNIT;
-
-		do { /* loop to support long pulses/spaces > 127*50us=6.35ms */
-
-			/* Insert mce packet header every 4th entry */
-			if ((cmdcount < MCE_CMDBUF_SIZE) &&
-			    (cmdcount - MCE_TX_HEADER_LENGTH) %
-			     MCE_CODE_LENGTH == 0)
-				cmdbuf[cmdcount++] = MCE_IRDATA_HEADER;
-
-			/* Insert mce packet data */
-			if (cmdcount < MCE_CMDBUF_SIZE)
-				cmdbuf[cmdcount++] =
-					(txbuf[i] < MCE_PULSE_BIT ?
-					 txbuf[i] : MCE_MAX_PULSE_LENGTH) |
-					 (i & 1 ? 0x00 : MCE_PULSE_BIT);
-			else {
-				ret = -EINVAL;
-				goto out;
-			}
+	buf[i++] = MCE_CMD_PORT_IR;
+	buf[i++] = MCE_CMD_SETIRTXPORTS;
+	buf[i++] = ir->tx_mask;
 
-		} while ((txbuf[i] > MCE_MAX_PULSE_LENGTH) &&
-			 (txbuf[i] -= MCE_MAX_PULSE_LENGTH));
-	}
+	while (kfifo_get(&dev->txfifo, &event)) {
+		tmp = event.duration / US_TO_NS(MCE_TIME_UNIT);
 
-	/* Fix packet length in last header */
-	cmdbuf[cmdcount - (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH] =
-		MCE_COMMAND_IRDATA + (cmdcount - MCE_TX_HEADER_LENGTH) %
-		MCE_CODE_LENGTH - 1;
+		/* Split event into pulses/spaces <= 127 * 50us = 6.35ms */
+		while (tmp > 0 && i < (MCE_CMDBUF_SIZE - 1)) {
 
-	/* Check if we have room for the empty packet at the end */
-	if (cmdcount >= MCE_CMDBUF_SIZE) {
-		ret = -EINVAL;
-		goto out;
+			/* Insert packet header before every 4 bytes */
+			if ((i - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH == 0)
+				buf[i++] = MCE_IRDATA_HEADER;
+
+			buf[i] = min_t(unsigned, tmp, MCE_MAX_PULSE_LENGTH);
+			tmp -= buf[i];
+			buf[i++] |= event.pulse ? MCE_PULSE_BIT : 0x00;
+		}
+
+		/* See if command buffer is full */
+		if (tmp > 0 || i >= MCE_CMDBUF_SIZE) {
+			kfifo_reset_out(&dev->txfifo);
+			return -EINVAL;
+		}
 	}
 
+	/* Fix packet length in last header */
+	tmp = ((i - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH);
+	buf[i - tmp] -= (MCE_CODE_LENGTH - tmp);
+
 	/* All mce commands end with an empty packet (0x80) */
-	cmdbuf[cmdcount++] = MCE_IRDATA_TRAILER;
+	buf[i++] = MCE_IRDATA_TRAILER;
 
 	/* Transmit the command to the mce device */
-	mce_async_out(ir, cmdbuf, cmdcount);
+	mce_async_out(ir, buf, i);
 
-out:
-	return ret ? ret : count;
+	return 0;
 }
 
 /* Sets active IR outputs -- mce devices typically have two */
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index f4ce071..447f0d0 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -546,21 +546,16 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
  * number may larger than TXFCONT (0xff). So in interrupt_handler, it has to
  * set TXFCONT as 0xff, until buf_count less than 0xff.
  */
-static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
+static int nvt_tx_ir(struct rc_dev *dev)
 {
 	struct nvt_dev *nvt = dev->priv;
 	unsigned long flags;
 	unsigned int i;
 	u8 iren;
-	int ret;
 
 	spin_lock_irqsave(&nvt->tx.lock, flags);
 
-	ret = min((unsigned)(TX_BUF_LEN / sizeof(unsigned)), n);
-	nvt->tx.buf_count = (ret * sizeof(unsigned));
-
-	memcpy(nvt->tx.buf, txbuf, nvt->tx.buf_count);
-
+	nvt->tx.buf_count = 0;
 	nvt->tx.cur_buf_num = 0;
 
 	/* save currently enabled interrupts */
@@ -589,7 +584,7 @@ static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
 	/* restore enabled interrupts to prior state */
 	nvt_cir_reg_write(nvt, iren, CIR_IREN);
 
-	return ret;
+	return 0;
 }
 
 /* dump contents of the last rx buffer we got from the hw rx fifo */
@@ -826,27 +821,37 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	if (status & CIR_IRSTS_TE)
 		nvt_clear_tx_fifo(nvt);
 
+	/*
+	 * FIXME: The TX code is quite unlikely to do the right thing as it
+	 *	  merely sends unsigned ints with host-specific endianness to
+	 *	  the hardware without any hints of pulse/space, etc.
+	 */
 	if (status & CIR_IRSTS_TTR) {
-		unsigned int pos, count;
-		u8 tmp;
-
 		spin_lock_irqsave(&nvt->tx.lock, flags);
 
-		pos = nvt->tx.cur_buf_num;
-		count = nvt->tx.buf_count;
-
-		/* Write data into the hardware tx fifo while pos < count */
-		if (pos < count) {
-			nvt_cir_reg_write(nvt, nvt->tx.buf[pos], CIR_STXFIFO);
-			nvt->tx.cur_buf_num++;
-		/* Disable TX FIFO Trigger Level Reach (TTR) interrupt */
-		} else {
-			tmp = nvt_cir_reg_read(nvt, CIR_IREN);
-			nvt_cir_reg_write(nvt, tmp & ~CIR_IREN_TTR, CIR_IREN);
+		/* Any data in tx buffer? */
+		if (nvt->tx.cur_buf_num >= nvt->tx.buf_count) {
+			DEFINE_IR_RAW_EVENT(event);
+			if (!kfifo_get(&nvt->rdev->txfifo, &event)) {
+				/* No more data, disable TTR interrupt */
+				u8 tmp = nvt_cir_reg_read(nvt, CIR_IREN);
+				nvt_cir_reg_write(nvt, tmp & ~CIR_IREN_TTR, CIR_IREN);
+			} else {
+				unsigned sample = event.duration / 1000;
+				nvt->tx.buf_count = sizeof(sample);
+				nvt->tx.cur_buf_num = 0;
+				memcpy(nvt->tx.buf, &sample, sizeof(sample));
+			}
 		}
 
-		spin_unlock_irqrestore(&nvt->tx.lock, flags);
+		/* Write data into the hardware tx fifo if we have any */
+		if (nvt->tx.cur_buf_num < nvt->tx.buf_count) {
+			nvt_cir_reg_write(nvt,
+					  nvt->tx.buf[nvt->tx.cur_buf_num++],
+					  CIR_STXFIFO);
+		}
 
+		spin_unlock_irqrestore(&nvt->tx.lock, flags);
 	}
 
 	if (status & CIR_IRSTS_TFU) {
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 0d5e087..4477439 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -54,15 +54,8 @@ static int debug;
 			KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
 
 
-/*
- * Original lirc driver said min value of 76, and recommended value of 256
- * for the buffer length, but then used 2048. Never mind that the size of the
- * RX FIFO is 32 bytes... So I'm using 32 for RX and 256 for TX atm, but I'm
- * not sure if maybe that TX value is off by a factor of 8 (bits vs. bytes),
- * and I don't have TX-capable hardware to test/debug on...
- */
-#define TX_BUF_LEN 256
 #define RX_BUF_LEN 32
+#define TX_BUF_LEN sizeof(unsigned)
 
 struct nvt_dev {
 	struct pnp_dev *pdev;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 53d0282..b6a2e58 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -101,17 +101,17 @@ static int loop_set_rx_carrier_range(struct rc_dev *dev, u32 min, u32 max)
 	return 0;
 }
 
-static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
+static int loop_tx_ir(struct rc_dev *dev)
 {
 	struct loopback_dev *lodev = dev->priv;
 	u32 rxmask;
-	unsigned i;
 	DEFINE_IR_RAW_EVENT(rawir);
 
 	if (lodev->txcarrier < lodev->rxcarriermin ||
 	    lodev->txcarrier > lodev->rxcarriermax) {
 		dprintk("ignoring tx, carrier out of range\n");
-		goto out;
+		kfifo_reset_out(&dev->txfifo);
+		return 0;
 	}
 
 	if (lodev->learning)
@@ -121,25 +121,22 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 
 	if (!(rxmask & lodev->txmask)) {
 		dprintk("ignoring tx, rx mask mismatch\n");
-		goto out;
+		kfifo_reset_out(&dev->txfifo);
+		return 0;
 	}
 
-	for (i = 0; i < count; i++) {
-		rawir.pulse = i % 2 ? false : true;
-		rawir.duration = txbuf[i] * 1000;
-		if (rawir.duration)
-			ir_raw_event_store_with_filter(dev, &rawir);
-	}
+	while (kfifo_get(&dev->txfifo, &rawir))
+		ir_raw_event_store_with_filter(dev, &rawir);
 
 	/* Fake a silence long enough to cause us to go idle */
+	init_ir_raw_event(&rawir);
 	rawir.pulse = false;
 	rawir.duration = dev->timeout;
 	ir_raw_event_store_with_filter(dev, &rawir);
 
 	ir_raw_event_handle(dev);
 
-out:
-	return count;
+	return 0;
 }
 
 static void loop_set_idle(struct rc_dev *dev, bool enable)
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index ef8d358..80d6dac 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1135,6 +1135,7 @@ static void rc_dev_release(struct device *device)
 	if (dev->input_dev)
 		input_free_device(dev->input_dev);
 
+	kfifo_free(&dev->txfifo);
 	kfree(dev);
 	module_put(THIS_MODULE);
 }
@@ -1207,6 +1208,8 @@ struct rc_dev *rc_allocate_device(void)
 
 	INIT_LIST_HEAD(&dev->client_list);
 	spin_lock_init(&dev->client_lock);
+	INIT_KFIFO(dev->txfifo);
+	spin_lock_init(&dev->txlock);
 	init_waitqueue_head(&dev->rxwait);
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
@@ -1284,6 +1287,12 @@ int rc_register_device(struct rc_dev *dev)
 	dev_set_name(&dev->dev, "rc%u", dev->minor);
 	dev_set_drvdata(&dev->dev, dev);
 
+	if (dev->tx_ir) {
+		rc = kfifo_alloc(&dev->txfifo, RC_TX_KFIFO_SIZE, GFP_KERNEL);
+		if (rc)
+			goto out_minor;
+	}
+
 	/*
 	 * Take the lock here, as the device sysfs node will appear
 	 * when device_add() is called, which may trigger an ir-keytable udev
@@ -1372,6 +1381,7 @@ out_dev:
 	device_del(&dev->dev);
 out_unlock:
 	mutex_unlock(&dev->lock);
+out_minor:
 	mutex_lock(&rc_dev_table_mutex);
 	rc_dev_table[dev->minor] = NULL;
 	mutex_unlock(&rc_dev_table_mutex);
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 46137b8..5eefb0b 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -223,7 +223,7 @@ struct redrat3_dev {
 	char phys[64];
 };
 
-/* All incoming data buffers adhere to a very specific data format */
+/* All incoming/outgoing data buffers have the following header */
 struct redrat3_signal_header {
 	u16 length;	/* Length of data being transferred */
 	u16 transfer_type; /* Type of data transferred */
@@ -235,8 +235,19 @@ struct redrat3_signal_header {
 	u16 max_sig_size; /* Max no. of values in signal data array */
 	u16 sig_size;	/* Acuto no. of values in signal data array */
 	u8 no_repeats;	/* No. of repeats of repeat signal section */
-	/* Here forward is the lengths and signal data */
-};
+} __packed;
+
+/*
+ * Data is sent by using a packet with a header followed by two arrays.
+ * - one with sample sizes (big-endian u16)
+ * - one with array index values (referring to the first array) which represent
+ *   alternating pulse/space samples
+ */
+struct redrat3_tx_data {
+	struct redrat3_signal_header header;
+	u16 lens[RR3_DRIVER_MAXLENS];
+	u8 samples[RR3_MAX_SIG_SIZE];
+} __packed;
 
 static void redrat3_dump_signal_header(struct redrat3_signal_header *header)
 {
@@ -370,40 +381,26 @@ static u32 redrat3_val_to_mod_freq(struct redrat3_signal_header *ph)
 	return mod_freq;
 }
 
-/* this function scales down the figures for the same result... */
-static u32 redrat3_len_to_us(u32 length)
-{
-	u32 biglen = length * 1000;
-	u32 divisor = (RR3_CLK_CONV_FACTOR) / 1000;
-	u32 result = (u32) (biglen / divisor);
-
-	/* don't allow zero lengths to go back, breaks lirc */
-	return result ? result : 1;
-}
-
 /*
- * convert us back into redrat3 lengths
+ * Functions to convert between microseconds (u32) and redrat3 lengths (u16)
  *
- * length * 1000   length * 1000000
- * ------------- = ---------------- = micro
- * rr3clk / 1000       rr3clk
-
- * 6 * 2       4 * 3        micro * rr3clk          micro * rr3clk / 1000
- * ----- = 4   ----- = 6    -------------- = len    ---------------------
- *   3           2             1000000                    1000
+ * 1000000			rr3clk
+ * ------- * len = us    =>	------- * us = len
+ * rr3clk			1000000
+ *
+ * Zero samples are avoided as they confuse lirc.
  */
-static u32 redrat3_us_to_len(u32 microsec)
+static inline u32 redrat3_len_to_us(u16 length)
 {
-	u32 result;
-	u32 divisor;
-
-	microsec &= IR_MAX_DURATION;
-	divisor = (RR3_CLK_CONV_FACTOR / 1000);
-	result = (u32)(microsec * divisor) / 1000;
-
-	/* don't allow zero lengths to go back, breaks lirc */
-	return result ? result : 1;
+	return max((u32)length / (RR3_CLK_CONV_FACTOR / (1000000)), (u32)1);
+}
 
+#define RR_MAX_DURATION (redrat3_len_to_us((u16)(~0)))
+static inline u16 redrat3_us_to_len(u32 microsec)
+{
+	return max(max(microsec, RR_MAX_DURATION) *
+		   (RR3_CLK_CONV_FACTOR / (1000000)),
+		   (u32)1);
 }
 
 /* timer callback to send reset event */
@@ -900,22 +897,21 @@ static int redrat3_set_tx_carrier(struct rc_dev *rcdev, u32 carrier)
 	return carrier;
 }
 
-static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
-				unsigned count)
+/*
+ * Transmit IR data
+ *
+ * See the description of struct redrat3_tx_data above.
+ */
+static int redrat3_transmit_ir(struct rc_dev *rcdev)
 {
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
-	struct redrat3_signal_header header;
-	int i, j, ret, ret_len, offset;
-	int lencheck, cur_sample_len, pipe;
-	char *buffer = NULL, *sigdata = NULL;
-	int *sample_lens = NULL;
-	u32 tmpi;
-	u16 tmps;
-	u8 *datap;
-	u8 curlencheck = 0;
-	u16 *lengths_ptr;
-	int sendbuf_len;
+	DEFINE_IR_RAW_EVENT(event);
+	struct redrat3_tx_data tx;
+	unsigned nlens = 0, nsamples = 0, i;
+	int txlen, actual_len;
+	int ret;
+	u16 sample;
 
 	rr3_ftr(dev, "Entering %s\n", __func__);
 
@@ -924,138 +920,87 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 		return -EAGAIN;
 	}
 
-	if (count > (RR3_DRIVER_MAXLENS * 2))
-		return -EINVAL;
-
 	/* rr3 will disable rc detector on transmit */
 	rr3->det_enabled = false;
 	rr3->transmitting = true;
 
-	sample_lens = kzalloc(sizeof(int) * RR3_DRIVER_MAXLENS, GFP_KERNEL);
-	if (!sample_lens) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	while (kfifo_get(&rcdev->txfifo, &event)) {
+		/* Convert duration to RR format */
+		sample = redrat3_us_to_len(event.duration / 1000);
 
-	for (i = 0; i < count; i++) {
-		for (lencheck = 0; lencheck < curlencheck; lencheck++) {
-			cur_sample_len = redrat3_us_to_len(txbuf[i]);
-			if (sample_lens[lencheck] == cur_sample_len)
+		/* See if we already have the same sample size stored */
+		for (i = 0; i < nlens; i++)
+			if (tx.lens[i] == sample)
 				break;
-		}
-		if (lencheck == curlencheck) {
-			cur_sample_len = redrat3_us_to_len(txbuf[i]);
-			rr3_dbg(dev, "txbuf[%d]=%u, pos %d, enc %u\n",
-				i, txbuf[i], curlencheck, cur_sample_len);
-			if (curlencheck < 255) {
-				/* now convert the value to a proper
-				 * rr3 value.. */
-				sample_lens[curlencheck] = cur_sample_len;
-				curlencheck++;
-			} else {
-				dev_err(dev, "signal too long\n");
+
+		if (i >= nlens) {
+			/* Nope */
+			if (nlens >= ARRAY_SIZE(tx.lens)) {
+				dev_err(dev, "signal too long (lens)\n");
 				ret = -EINVAL;
 				goto out;
 			}
+			rr3_dbg(dev, "lens[%u] = %u\n", nlens, sample);
+			tx.lens[nlens++] = sample;
 		}
-	}
 
-	sigdata = kzalloc((count + RR3_TX_TRAILER_LEN), GFP_KERNEL);
-	if (!sigdata) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	sigdata[count] = RR3_END_OF_SIGNAL;
-	sigdata[count + 1] = RR3_END_OF_SIGNAL;
-	for (i = 0; i < count; i++) {
-		for (j = 0; j < curlencheck; j++) {
-			if (sample_lens[j] == redrat3_us_to_len(txbuf[i]))
-				sigdata[i] = j;
+		/* And store the sample */
+		if (nsamples >= ARRAY_SIZE(tx.samples) - RR3_TX_TRAILER_LEN) {
+			dev_err(dev, "signal too long (samples)\n");
+			ret = -EINVAL;
+			goto out;
 		}
+		tx.samples[nsamples++] = i;
 	}
 
-	offset = RR3_TX_HEADER_OFFSET;
-	sendbuf_len = RR3_HEADER_LENGTH + (sizeof(u16) * RR3_DRIVER_MAXLENS)
-			+ count + RR3_TX_TRAILER_LEN + offset;
+	for (i = 0; i < nlens; i++)
+		cpu_to_be16s(&tx.lens[i]);
+
+	/* Add TX trailer */
+	tx.samples[nsamples++] = RR3_END_OF_SIGNAL;
+	tx.samples[nsamples++] = RR3_END_OF_SIGNAL;
+
+	/* Fill in our packet header */
+	txlen = sizeof(tx) - (RR3_MAX_SIG_SIZE - nsamples);
+	tx.header.length	 = cpu_to_be16(txlen - RR3_TX_HEADER_OFFSET);
+	tx.header.transfer_type	 = cpu_to_be16(RR3_MOD_SIGNAL_OUT);
+	tx.header.pause		 = cpu_to_be32(redrat3_len_to_us(100));
+	tx.header.mod_freq_count = cpu_to_be16(mod_freq_to_val(rr3->carrier));
+	tx.header.no_periods	 = cpu_to_be16(0);	/* n/a to transmit */
+	tx.header.max_lengths	 = RR3_DRIVER_MAXLENS;	/* u8 */
+	tx.header.no_lengths	 = nlens;		/* u8 */
+	tx.header.max_sig_size	 = cpu_to_be16(RR3_MAX_SIG_SIZE);
+	tx.header.sig_size	 = cpu_to_be16(nsamples);
+	/* We currently rely on repeat handling in user-space */
+	tx.header.no_repeats	 = 0;			/* u8 */
 
-	buffer = kzalloc(sendbuf_len, GFP_KERNEL);
-	if (!buffer) {
-		ret = -ENOMEM;
-		goto out;
+	if (debug) {
+		redrat3_dump_signal_header(&tx.header);
+		redrat3_dump_signal_lens(tx.lens, nlens);
+		redrat3_dump_signal_data(tx.samples, nsamples);
 	}
 
-	/* fill in our packet header */
-	header.length = sendbuf_len - offset;
-	header.transfer_type = RR3_MOD_SIGNAL_OUT;
-	header.pause = redrat3_len_to_us(100);
-	header.mod_freq_count = mod_freq_to_val(rr3->carrier);
-	header.no_periods = 0; /* n/a to transmit */
-	header.max_lengths = RR3_DRIVER_MAXLENS;
-	header.no_lengths = curlencheck;
-	header.max_sig_size = RR3_MAX_SIG_SIZE;
-	header.sig_size = count + RR3_TX_TRAILER_LEN;
-	/* we currently rely on repeat handling in the IR encoding source */
-	header.no_repeats = 0;
-
-	tmps = cpu_to_be16(header.length);
-	memcpy(buffer, &tmps, 2);
-
-	tmps = cpu_to_be16(header.transfer_type);
-	memcpy(buffer + 2, &tmps, 2);
-
-	tmpi = cpu_to_be32(header.pause);
-	memcpy(buffer + offset, &tmpi, sizeof(tmpi));
-
-	tmps = cpu_to_be16(header.mod_freq_count);
-	memcpy(buffer + offset + RR3_FREQ_COUNT_OFFSET, &tmps, 2);
-
-	buffer[offset + RR3_NUM_LENGTHS_OFFSET] = header.no_lengths;
-
-	tmps = cpu_to_be16(header.sig_size);
-	memcpy(buffer + offset + RR3_NUM_SIGS_OFFSET, &tmps, 2);
-
-	buffer[offset + RR3_REPEATS_OFFSET] = header.no_repeats;
-
-	lengths_ptr = (u16 *)(buffer + offset + RR3_HEADER_LENGTH);
-	for (i = 0; i < curlencheck; ++i)
-		lengths_ptr[i] = cpu_to_be16(sample_lens[i]);
-
-	datap = (u8 *)(buffer + offset + RR3_HEADER_LENGTH +
-			    (sizeof(u16) * RR3_DRIVER_MAXLENS));
-	memcpy(datap, sigdata, (count + RR3_TX_TRAILER_LEN));
-
-	if (debug) {
-		redrat3_dump_signal_header(&header);
-		redrat3_dump_signal_lens(lengths_ptr, curlencheck);
-		redrat3_dump_signal_data(sigdata, count);
+	ret = usb_bulk_msg(rr3->udev,
+			   usb_sndbulkpipe(rr3->udev, rr3->ep_out->bEndpointAddress),
+			   &tx, txlen, &actual_len, 10 * HZ);
+	if (ret < 0) {
+		dev_err(dev, "Error: bulk msg send failed, rc %d\n", ret);
+		goto out;
 	}
 
-	pipe = usb_sndbulkpipe(rr3->udev, rr3->ep_out->bEndpointAddress);
-	tmps = usb_bulk_msg(rr3->udev, pipe, buffer,
-			    sendbuf_len, &ret_len, 10 * HZ);
-	rr3_dbg(dev, "sent %d bytes, (ret %d)\n", ret_len, tmps);
+	rr3_dbg(dev, "sent usb bulk msg - %i bytes\n", actual_len);
 
-	/* now tell the hardware to transmit what we sent it */
-	pipe = usb_rcvctrlpipe(rr3->udev, 0);
-	ret = usb_control_msg(rr3->udev, pipe, RR3_TX_SEND_SIGNAL,
+	ret = usb_control_msg(rr3->udev,
+			      usb_rcvctrlpipe(rr3->udev, 0),
+			      RR3_TX_SEND_SIGNAL,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      0, 0, buffer, 2, HZ * 10);
-
+			      0, 0, &tx, 2, HZ * 10);
 	if (ret < 0)
 		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);
-	else
-		ret = count;
 
 out:
-	kfree(sample_lens);
-	kfree(buffer);
-	kfree(sigdata);
-
 	rr3->transmitting = false;
-	/* rr3 re-enables rc detector because it was enabled before */
 	rr3->det_enabled = true;
-
 	return ret;
 }
 
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 342c2c8..207410c 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -213,9 +213,7 @@ struct wbcir_data {
 	/* TX state */
 	enum wbcir_txstate txstate;
 	struct led_trigger *txtrigger;
-	u32 txlen;
-	u32 txoff;
-	u32 *txbuf;
+	struct ir_raw_event txevent;
 	wait_queue_head_t txwaitq;
 	u8 txmask;
 	u32 txcarrier;
@@ -379,7 +377,7 @@ wbcir_irq_tx(struct wbcir_data *data)
 	u8 bytes[16];
 	u8 byte;
 
-	if (!data->txbuf)
+	if (kfifo_is_empty(&data->dev->txfifo))
 		return;
 
 	switch (data->txstate) {
@@ -404,21 +402,23 @@ wbcir_irq_tx(struct wbcir_data *data)
 	 * Y = space (1) or pulse (0)
 	 * X = duration, encoded as (X + 1) * 10us (i.e 10 to 1280 us)
 	 */
-	for (used = 0; used < space && data->txoff != data->txlen; used++) {
-		if (data->txbuf[data->txoff] == 0) {
-			data->txoff++;
-			continue;
+	for (used = 0; used < space; used++) {
+		while (data->txevent.duration == 0) {
+			if (!kfifo_get(&data->dev->txfifo, &data->txevent))
+				break;
+			/* Convert duration to multiples of 10us */
+			data->txevent.duration =
+				DIV_ROUND_CLOSEST(data->txevent.duration,
+						  10 * 1000);
 		}
-		byte = min((u32)0x80, data->txbuf[data->txoff]);
-		data->txbuf[data->txoff] -= byte;
+
+		byte = min_t(u32, 0x80, data->txevent.duration);
+		data->txevent.duration -= byte;
 		byte--;
-		byte |= (data->txoff % 2 ? 0x80 : 0x00); /* pulse/space */
+		byte |= data->txevent.pulse ? 0x80 : 0x00;
 		bytes[used] = byte;
 	}
 
-	while (data->txbuf[data->txoff] == 0 && data->txoff != data->txlen)
-		data->txoff++;
-
 	if (used == 0) {
 		/* Finished */
 		if (data->txstate == WBCIR_TXSTATE_ERROR)
@@ -429,7 +429,8 @@ wbcir_irq_tx(struct wbcir_data *data)
 		wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR);
 		led_trigger_event(data->txtrigger, LED_OFF);
 		wake_up(&data->txwaitq);
-	} else if (data->txoff == data->txlen) {
+	} else if (data->txevent.duration == 0 &&
+		   kfifo_is_empty(&data->dev->txfifo)) {
 		/* At the end of transmission, tell the hw before last byte */
 		outsb(data->sbase + WBCIR_REG_SP3_TXDATA, bytes, used - 1);
 		outb(WBCIR_TX_EOT, data->sbase + WBCIR_REG_SP3_ASCR);
@@ -579,11 +580,11 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)
 }
 
 static int
-wbcir_tx(struct rc_dev *dev, unsigned *buf, unsigned count)
+wbcir_tx(struct rc_dev *dev)
 {
 	struct wbcir_data *data = dev->priv;
-	unsigned i;
 	unsigned long flags;
+	int ret = 0;
 
 	/* Not sure if this is possible, but better safe than sorry */
 	spin_lock_irqsave(&data->spinlock, flags);
@@ -592,14 +593,8 @@ wbcir_tx(struct rc_dev *dev, unsigned *buf, unsigned count)
 		return -EBUSY;
 	}
 
-	/* Convert values to multiples of 10us */
-	for (i = 0; i < count; i++)
-		buf[i] = DIV_ROUND_CLOSEST(buf[i], 10);
-
 	/* Fill the TX fifo once, the irq handler will do the rest */
-	data->txbuf = buf;
-	data->txlen = count;
-	data->txoff = 0;
+	init_ir_raw_event(&data->txevent);
 	wbcir_irq_tx(data);
 
 	/* Wait for the TX to complete */
@@ -611,12 +606,11 @@ wbcir_tx(struct rc_dev *dev, unsigned *buf, unsigned count)
 
 	/* We're done */
 	if (data->txstate == WBCIR_TXSTATE_ERROR)
-		count = -EAGAIN;
+		ret = -EFAULT;
 	data->txstate = WBCIR_TXSTATE_INACTIVE;
-	data->txbuf = NULL;
 	spin_unlock_irqrestore(&data->spinlock, flags);
 
-	return count;
+	return ret;
 }
 
 /*****************************************************************************
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 4f69aa9..4a5dbcb 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -52,6 +52,24 @@ struct rc_keymap_entry {
 	};
 };
 
+#define RC_TX_KFIFO_SIZE	1024
+struct ir_raw_event {
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
+};
+
+
 /**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
@@ -67,6 +85,8 @@ struct rc_keymap_entry {
  * @exist: used to determine if the device is still valid
  * @client_list: list of clients (processes which have opened the rc chardev)
  * @client_lock: protects client_list
+ * @txfifo: fifo with tx data to transmit
+ * @txlock: protects txfifo
  * @rxwait: waitqueue for processes waiting for data to read
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
@@ -119,6 +139,8 @@ struct rc_dev {
 	bool				exist;
 	struct list_head		client_list;
 	spinlock_t			client_lock;
+	DECLARE_KFIFO_PTR(txfifo, struct ir_raw_event);
+	spinlock_t			txlock;
 	wait_queue_head_t		rxwait;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
@@ -148,7 +170,7 @@ struct rc_dev {
 	int				(*s_tx_carrier)(struct rc_dev *dev, u32 carrier);
 	int				(*s_tx_duty_cycle)(struct rc_dev *dev, u32 duty_cycle);
 	int				(*s_rx_carrier_range)(struct rc_dev *dev, u32 min, u32 max);
-	int				(*tx_ir)(struct rc_dev *dev, unsigned *txbuf, unsigned n);
+	int				(*tx_ir)(struct rc_dev *dev);
 	void				(*s_idle)(struct rc_dev *dev, bool enable);
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
@@ -216,22 +238,6 @@ enum raw_event_type {
 	IR_STOP_EVENT   = (1 << 3),
 };
 
-struct ir_raw_event {
-	union {
-		u32             duration;
-
-		struct {
-			u32     carrier;
-			u8      duty_cycle;
-		};
-	};
-
-	unsigned                pulse:1;
-	unsigned                reset:1;
-	unsigned                timeout:1;
-	unsigned                carrier_report:1;
-};
-
 #define DEFINE_IR_RAW_EVENT(event) \
 	struct ir_raw_event event = { \
 		{ .duration = 0 } , \

