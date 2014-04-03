Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40300 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:53 -0400
Subject: [PATCH 19/49] rc-core: use a kfifo for TX data
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:51 +0200
Message-ID: <20140403233251.27099.37978.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using a per rc_dev TX kfifo for TX data simplifies the device drivers and lays
the ground for the next patch.

This means that every driver with TX capabilities need to be changed at the
same time.

It should be noted that the TX functionality in nuvoton-cir.c is, and was,
probably broken before and after this patch.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ene_ir.c        |   61 +++++++++------------
 drivers/media/rc/ene_ir.h        |    9 +--
 drivers/media/rc/iguanair.c      |   51 ++++++++++++-----
 drivers/media/rc/ir-lirc-codec.c |  100 ++++++++++++++++++----------------
 drivers/media/rc/ir-raw.c        |   41 ++++++++++++++
 drivers/media/rc/ite-cir.c       |   35 +++++-------
 drivers/media/rc/mceusb.c        |   43 ++++++++------
 drivers/media/rc/nuvoton-cir.c   |   57 +++++++++++--------
 drivers/media/rc/nuvoton-cir.h   |    9 ---
 drivers/media/rc/rc-loopback.c   |   25 +++++---
 drivers/media/rc/rc-main.c       |    9 +++
 drivers/media/rc/redrat3.c       |  113 ++++++++++++++++++++++----------------
 drivers/media/rc/winbond-cir.c   |   79 +++++++++++----------------
 include/media/rc-core.h          |    9 +++
 14 files changed, 363 insertions(+), 278 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index d16d9b4..cab5da9 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -615,7 +615,8 @@ static void ene_tx_enable(struct ene_device *dev)
 static void ene_tx_disable(struct ene_device *dev)
 {
 	ene_write_reg(dev, ENE_CIRCFG, dev->saved_conf1);
-	dev->tx_buffer = NULL;
+	dev->tx_ev.val = 0;
+	kfifo_reset_out(&dev->rdev->txfifo);
 }
 
 
@@ -623,18 +624,16 @@ static void ene_tx_disable(struct ene_device *dev)
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
+	while (!dev->tx_ev.val) {
+		int tmp;
 
-		if (dev->tx_pos == dev->tx_len) {
+		tmp = ir_raw_get_tx_event(dev->rdev, &dev->tx_ev);
+		if (tmp < 0) {
+			dev->tx_ev.val = 0;
+			continue;
+		} else if (tmp == 0) {
 			if (!dev->tx_done) {
 				dbg("TX: no more data to send");
 				dev->tx_done = true;
@@ -647,25 +646,23 @@ static void ene_tx_sample(struct ene_device *dev)
 			}
 		}
 
-		sample = dev->tx_buffer[dev->tx_pos++];
-		dev->tx_sample_pulse = !dev->tx_sample_pulse;
-
-		dev->tx_sample = DIV_ROUND_CLOSEST(sample, sample_period);
-
-		if (!dev->tx_sample)
-			dev->tx_sample = 1;
+		dev->tx_ev.val = DIV_ROUND_CLOSEST(dev->tx_ev.val,
+						   US_TO_NS(sample_period));
+		if (!dev->tx_ev.val)
+			dev->tx_ev.val = 1;
 	}
 
-	raw_tx = min(dev->tx_sample , (unsigned int)ENE_CIRRLC_OUT_MASK);
-	dev->tx_sample -= raw_tx;
+	raw_tx = min_t(unsigned, dev->tx_ev.val, ENE_CIRRLC_OUT_MASK);
+	dev->tx_ev.val -= raw_tx;
 
 	dbg("TX: sample %8d (%s)", raw_tx * sample_period,
-						pulse ? "pulse" : "space");
-	if (pulse)
+	    dev->tx_ev.code == RC_IR_PULSE ? "pulse" : "space");
+
+	if (dev->tx_ev.code == RC_IR_PULSE)
 		raw_tx |= ENE_CIRRLC_OUT_PULSE;
 
 	ene_write_reg(dev,
-		dev->tx_reg ? ENE_CIRRLC_OUT1 : ENE_CIRRLC_OUT0, raw_tx);
+		      dev->tx_reg ? ENE_CIRRLC_OUT1 : ENE_CIRRLC_OUT0, raw_tx);
 
 	dev->tx_reg = !dev->tx_reg;
 exit:
@@ -968,20 +965,16 @@ static void ene_set_idle(struct rc_dev *rdev, bool idle)
 }
 
 /* outside interface: transmit */
-static int ene_transmit(struct rc_dev *rdev, unsigned *buf, unsigned n)
+static int ene_transmit(struct rc_dev *rdev, unsigned count)
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
+	dev->tx_ev.val = 0;
+	dbg("TX: %d samples", count);
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
@@ -998,9 +991,11 @@ static int ene_transmit(struct rc_dev *rdev, unsigned *buf, unsigned n)
 		spin_lock_irqsave(&dev->hw_lock, flags);
 		ene_tx_disable(dev);
 		spin_unlock_irqrestore(&dev->hw_lock, flags);
-	} else
-		dbg("TX: done");
-	return n;
+		return -EIO;
+	}
+
+	dbg("TX: done");
+	return count;
 }
 
 /* probe entry */
diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index a7911e3..9eb0b57 100644
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
+	struct rc_event tx_ev;			/* current sample for TX */
+	bool tx_done;				/* done transmitting */
 	struct completion tx_complete;		/* TX completion */
 	struct timer_list tx_sim_timer;
 
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index ee60e17..8a4baf5 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -347,29 +347,46 @@ static int iguanair_set_tx_mask(struct rc_dev *dev, uint32_t mask)
 	return 0;
 }
 
-static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
+static int iguanair_tx(struct rc_dev *dev, unsigned count)
 {
 	struct iguanair *ir = dev->priv;
-	uint8_t space;
-	unsigned i, size, periods, bytes;
+	struct rc_event ev;
+	unsigned size = 0;
 	int rc;
 
 	mutex_lock(&ir->lock);
 
-	/* convert from us to carrier periods */
-	for (i = space = size = 0; i < count; i++) {
-		periods = DIV_ROUND_CLOSEST(txbuf[i] * ir->carrier, 1000000);
-		bytes = DIV_ROUND_UP(periods, 127);
+	while (kfifo_peek(&dev->txfifo, &ev)) {
+		unsigned p, bytes;
+
+		if ((ev.type != RC_IR) ||
+		    (ev.code != RC_IR_SPACE && ev.code != RC_IR_PULSE) ||
+		    (ev.val == 0))
+			continue;
+
+		/* convert from ns to carrier periods */
+		p = DIV_ROUND_CLOSEST(ev.val * ir->carrier, 1000000000);
+		bytes = DIV_ROUND_UP(p, 127);
 		if (size + bytes > ir->bufsize) {
-			rc = -EINVAL;
-			goto out;
+			size = 0;
+			break;
 		}
-		while (periods) {
-			unsigned p = min(periods, 127u);
-			ir->packet->payload[size++] = p | space;
-			periods -= p;
+	
+		while (p > 0) {
+			u8 byte = min_t(u8, p, 127);
+			p -= byte;
+			if (ev.code == RC_IR_SPACE)
+				byte |= 0x80;
+			ir->packet->payload[size++] = byte;
 		}
-		space ^= 0x80;
+
+		kfifo_skip(&dev->txfifo);
+	}
+
+	if (size == 0) {
+		rc = -EINVAL;
+		kfifo_reset_out(&dev->txfifo);
+		goto out;
 	}
 
 	ir->packet->header.start = 0;
@@ -386,8 +403,10 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 
 out:
 	mutex_unlock(&ir->lock);
-
-	return rc ? rc : count;
+	if (rc == 0)
+		return count;
+	else
+		return rc;
 }
 
 static int iguanair_open(struct rc_dev *rdev)
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index ed2c8a1..7d58eea 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -102,75 +102,81 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
-	struct lirc_codec *lirc;
+	struct lirc_codec *lirc = lirc_get_pdata(file);
 	struct rc_dev *dev;
-	unsigned int *txbuf; /* buffer with values to transmit */
-	ssize_t ret = -EINVAL;
-	size_t count;
-	ktime_t start;
-	s64 towait;
-	unsigned int duration = 0; /* signal duration in us */
-	int i;
-
-	start = ktime_get();
+	ktime_t start = ktime_get();
+	ssize_t ret;
+	unsigned duration = 0; /* signal duration in us */
+	unsigned tostore, stored;
 
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
+	/*
+	 * LIRC TX API:
+	 * Userspace writes an odd number of u32 samples which
+	 * represent a sequence of pulse-space-pulse...etc values
+	 */
+	if (n % sizeof(u32) != 0)
 		return -EINVAL;
 
-	txbuf = memdup_user(buf, n);
-	if (IS_ERR(txbuf))
-		return PTR_ERR(txbuf);
+	tostore = n / sizeof(u32);
+	if (tostore % 2 == 0)
+		return -EINVAL;
 
-	dev = lirc->dev;
-	if (!dev) {
-		ret = -EFAULT;
-		goto out;
-	}
+	mutex_lock(&dev->txmutex);
 
-	if (!dev->tx_ir) {
-		ret = -ENOSYS;
-		goto out;
-	}
+	for (stored = 0; stored < tostore; stored++) {
+		bool pulse = true;
+		u32 val;
+		struct rc_event ev;
 
-	for (i = 0; i < count; i++) {
-		if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
-			ret = -EINVAL;
-			goto out;
+		if (copy_from_user(&val, buf, sizeof(u32)) ||
+		    val == 0 ||
+		    val > IR_MAX_DURATION / 1000 - duration) {
+			kfifo_reset_out(&dev->txfifo);
+			mutex_unlock(&dev->txmutex);
+			return -EFAULT;
 		}
 
-		duration += txbuf[i];
-	}
-
-	ret = dev->tx_ir(dev, txbuf, count);
-	if (ret < 0)
-		goto out;
+		ev.type = RC_IR;
+		ev.code = pulse ? RC_IR_PULSE : RC_IR_SPACE;
+		ev.val = val;
+		if (kfifo_in(&dev->txfifo, &ev, 1) != 1)
+			break;
 
-	for (duration = i = 0; i < ret; i++)
-		duration += txbuf[i];
+		pulse = !pulse;
+		duration += val;
+		buf += sizeof(u32);
+	}
 
-	ret *= sizeof(unsigned int);
+	ret = dev->tx_ir(dev, stored);
+	mutex_unlock(&dev->txmutex);
 
 	/*
 	 * The lircd gap calculation expects the write function to
 	 * wait for the actual IR signal to be transmitted before
 	 * returning.
+	 *
+	 * Only do this if the driver didn't have to truncate the
+	 * TX data.
 	 */
-	towait = ktime_us_delta(ktime_add_us(start, duration), ktime_get());
-	if (towait > 0) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(usecs_to_jiffies(towait));
+	if (ret == stored) {
+		s64 towait = ktime_us_delta(ktime_add_us(start, duration),
+					    ktime_get());
+		if (towait > 0) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(usecs_to_jiffies(towait));
+		}
 	}
 
-out:
-	kfree(txbuf);
+	if (ret > 0)
+		ret *= sizeof(u32);
+
 	return ret;
 }
 
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 7eb347a..af23f4d 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -211,6 +211,47 @@ void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
 EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
 
 /**
+ * ir_raw_get_tx_event() - fetches the next ir tx event from the tx fifo
+ * @dev:	the struct rc_dev device descriptor
+ * @ev:		the struct rc_event to fill in with the next tx event
+ *
+ * Fetches the next ir tx event from the kfifo while taking care of
+ * details such as merging consecutive events of the same type.
+ *
+ * Return: the number of events consumed from the kfifo, or a negative error
+ */
+int ir_raw_get_tx_event(struct rc_dev *dev, struct rc_event *ev)
+{
+	struct rc_event tmp;
+	unsigned consumed = 1;
+
+	if (!kfifo_get(&dev->txfifo, ev))
+		return 0;
+
+	/* Sanity check */
+	if ((ev->type != RC_IR) ||
+	    (ev->code != RC_IR_SPACE && ev->code != RC_IR_PULSE) ||
+	    (ev->val == 0))
+		return -EINVAL;
+
+	/* Merge consecutive entries of same type */
+	while (kfifo_peek(&dev->txfifo, &tmp)) {
+		if (tmp.type != ev->type || tmp.code != ev->code)
+			break;
+		if (tmp.val == 0)
+			return -EINVAL;
+		/* No check for overflow, which is ok */
+		ev->val += tmp.val;
+		kfifo_skip(&dev->txfifo);
+		consumed++;
+	}
+
+	/* Done */
+	return consumed;
+}
+EXPORT_SYMBOL_GPL(ir_raw_get_tx_event);
+
+/**
  * ir_raw_event_handle() - schedules the decoding of stored ir data
  * @dev:	the struct rc_dev device descriptor
  *
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 32fd5f4..0d404a2 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -382,16 +382,15 @@ static int ite_set_tx_duty_cycle(struct rc_dev *rcdev, u32 duty_cycle)
 /* transmit out IR pulses; what you get here is a batch of alternating
  * pulse/space/pulse/space lengths that we should write out completely through
  * the FIFO, blocking on a full FIFO */
-static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
+static int ite_tx_ir(struct rc_dev *rcdev, unsigned count)
 {
 	unsigned long flags;
 	struct ite_dev *dev = rcdev->priv;
-	bool is_pulse = false;
 	int remaining_us, fifo_avail, fifo_remaining, last_idx = 0;
-	int max_rle_us, next_rle_us;
-	int ret = n;
+	int max_rle_us, next_rle_us, tmp;
 	u8 last_sent[ITE_TX_FIFO_LEN];
 	u8 val;
+	struct rc_event ev;
 
 	ite_dbg("%s called", __func__);
 
@@ -421,22 +420,21 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 	fifo_avail =
 	    ITE_TX_FIFO_LEN - dev->params.get_tx_used_slots(dev);
 
-	while (n > 0 && dev->in_use) {
+	while ((tmp = ir_raw_get_tx_event(rcdev, &ev)) != 0 && dev->in_use) {
+		if (tmp < 0)
+			continue;
+
 		/* transmit the next sample */
-		is_pulse = !is_pulse;
-		remaining_us = *(txbuf++);
-		n--;
+		remaining_us = ev.val;
 
-		ite_dbg("%s: %ld",
-				      ((is_pulse) ? "pulse" : "space"),
-				      (long int)
-				      remaining_us);
+		ite_dbg("%s: %i",
+			(ev.code == RC_IR_PULSE ? "pulse" : "space"),
+			remaining_us);
 
 		/* repeat while the pulse is non-zero length */
 		while (remaining_us > 0 && dev->in_use) {
 			if (remaining_us > max_rle_us)
 				next_rle_us = max_rle_us;
-
 			else
 				next_rle_us = remaining_us;
 
@@ -453,9 +451,8 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 			val = (val - 1) & ITE_TX_RLE_MASK;
 
 			/* take into account pulse/space prefix */
-			if (is_pulse)
+			if (ev.code == RC_IR_PULSE)
 				val |= ITE_TX_PULSE;
-
 			else
 				val |= ITE_TX_SPACE;
 
@@ -469,8 +466,7 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 			/* if it's still full */
 			if (fifo_avail <= 0) {
 				/* enable the tx interrupt */
-				dev->params.
-				enable_tx_interrupt(dev);
+				dev->params.enable_tx_interrupt(dev);
 
 				/* drop the spinlock */
 				spin_unlock_irqrestore(&dev->lock, flags);
@@ -482,8 +478,7 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 				spin_lock_irqsave(&dev->lock, flags);
 
 				/* disable the tx interrupt again. */
-				dev->params.
-				disable_tx_interrupt(dev);
+				dev->params.disable_tx_interrupt(dev);
 			}
 
 			/* now send the byte through the FIFO */
@@ -529,7 +524,7 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	return ret;
+	return count;
 }
 
 /* idle the receiver if needed */
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a347736..e0c8552 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -797,12 +797,13 @@ static void mce_flush_rx_buffer(struct mceusb_dev *ir, int size)
 }
 
 /* Send data out the IR blaster port(s) */
-static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
+static int mceusb_tx_ir(struct rc_dev *dev, unsigned count)
 {
 	struct mceusb_dev *ir = dev->priv;
-	int i, length, ret = 0;
+	int tmp, ret = 0;
 	int cmdcount = 0;
 	unsigned char cmdbuf[MCE_CMDBUF_SIZE];
+	struct rc_event ev;
 
 	/* MCE tx init header */
 	cmdbuf[cmdcount++] = MCE_CMD_PORT_IR;
@@ -814,8 +815,9 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	cmdcount = 0;
 
 	/* Generate mce packet data */
-	for (i = 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
-		txbuf[i] = txbuf[i] / MCE_TIME_UNIT;
+	while ((tmp = ir_raw_get_tx_event(dev, &ev)) > 0) {
+		ret += tmp;
+		ev.val /= MCE_TIME_UNIT;
 
 		do { /* loop to support long pulses/spaces > 127*50us=6.35ms */
 
@@ -824,30 +826,34 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 			    (cmdcount % MCE_CODE_LENGTH) == 0)
 				cmdbuf[cmdcount++] = MCE_IRDATA_HEADER;
 
-			/* Insert mce packet data */
-			if (cmdcount < MCE_CMDBUF_SIZE)
-				cmdbuf[cmdcount++] =
-					(txbuf[i] < MCE_PULSE_BIT ?
-					 txbuf[i] : MCE_MAX_PULSE_LENGTH) |
-					 (i & 1 ? 0x00 : MCE_PULSE_BIT);
-			else {
-				ret = -EINVAL;
+			if (cmdcount >= MCE_CMDBUF_SIZE) {
+				ret = -EMSGSIZE;
 				goto out;
 			}
 
-		} while ((txbuf[i] > MCE_MAX_PULSE_LENGTH) &&
-			 (txbuf[i] -= MCE_MAX_PULSE_LENGTH));
+			/* Insert mce packet data */
+			cmdbuf[cmdcount++] =
+				min_t(u32, ev.val, MCE_MAX_PULSE_LENGTH) |
+				(ev.code == RC_IR_PULSE ? MCE_PULSE_BIT : 0x0);
+
+		} while ((ev.val > MCE_MAX_PULSE_LENGTH) &&
+			 (ev.val -= MCE_MAX_PULSE_LENGTH));
+	}
+
+	if (tmp < 0) {
+		ret = tmp;
+		goto out;
 	}
 
 	/* Check if we have room for the empty packet at the end */
 	if (cmdcount >= MCE_CMDBUF_SIZE) {
-		ret = -EINVAL;
+		ret = -EMSGSIZE;
 		goto out;
 	}
 
 	/* Fix packet length in last header */
-	length = cmdcount % MCE_CODE_LENGTH;
-	cmdbuf[cmdcount - length] -= MCE_CODE_LENGTH - length;
+	tmp = cmdcount % MCE_CODE_LENGTH;
+	cmdbuf[cmdcount - tmp] -= MCE_CODE_LENGTH - tmp;
 
 	/* All mce commands end with an empty packet (0x80) */
 	cmdbuf[cmdcount++] = MCE_IRDATA_TRAILER;
@@ -856,7 +862,8 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	mce_async_out(ir, cmdbuf, cmdcount);
 
 out:
-	return ret ? ret : count;
+	kfifo_reset_out(&dev->txfifo);
+	return ret;
 }
 
 /* Sets active IR outputs -- mce devices typically have two */
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 8c6008f..160d685 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -545,21 +545,16 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
  * number may larger than TXFCONT (0xff). So in interrupt_handler, it has to
  * set TXFCONT as 0xff, until buf_count less than 0xff.
  */
-static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
+static int nvt_tx_ir(struct rc_dev *dev, unsigned count)
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
@@ -588,7 +583,7 @@ static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
 	/* restore enabled interrupts to prior state */
 	nvt_cir_reg_write(nvt, iren, CIR_IREN);
 
-	return ret;
+	return count;
 }
 
 /* dump contents of the last rx buffer we got from the hw rx fifo */
@@ -821,27 +816,43 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
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
+		while (nvt->tx.cur_buf_num >= nvt->tx.buf_count) {
+			struct rc_event ev;
+			int tmp;
+
+			tmp = ir_raw_get_tx_event(nvt->rdev, &ev);
+			if (tmp < 0)
+				continue;
+			else if (tmp == 0) {
+				/* No more data, disable TTR interrupt */
+				u8 tmp = nvt_cir_reg_read(nvt, CIR_IREN);
+				nvt_cir_reg_write(nvt, tmp & ~CIR_IREN_TTR, CIR_IREN);
+				break;
+			} else {
+				unsigned sample = ev.val / 1000;
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
index e1cf23c..5c69a2e 100644
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
index 63dace8..bc67d2f 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -101,17 +101,19 @@ static int loop_set_rx_carrier_range(struct rc_dev *dev, u32 min, u32 max)
 	return 0;
 }
 
-static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
+static int loop_tx_ir(struct rc_dev *dev, unsigned count)
 {
 	struct loopback_dev *lodev = dev->priv;
 	u32 rxmask;
-	unsigned i;
+	struct rc_event ev;
 	DEFINE_IR_RAW_EVENT(rawir);
+	int tmp;
 
 	if (lodev->txcarrier < lodev->rxcarriermin ||
 	    lodev->txcarrier > lodev->rxcarriermax) {
 		dprintk("ignoring tx, carrier out of range\n");
-		goto out;
+		kfifo_reset_out(&dev->txfifo);
+		return 0;
 	}
 
 	if (lodev->learning)
@@ -121,24 +123,27 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 
 	if (!(rxmask & lodev->txmask)) {
 		dprintk("ignoring tx, rx mask mismatch\n");
-		goto out;
+		kfifo_reset_out(&dev->txfifo);
+		return count;
 	}
 
-	for (i = 0; i < count; i++) {
-		rawir.pulse = i % 2 ? false : true;
-		rawir.duration = txbuf[i] * 1000;
-		if (rawir.duration)
-			ir_raw_event_store_with_filter(dev, &rawir);
+	while ((tmp = ir_raw_get_tx_event(dev, &ev)) != 0) {
+		if (tmp < 0)
+			continue;
+		init_ir_raw_event(&rawir);
+		rawir.pulse = (ev.code == RC_IR_PULSE);
+		rawir.duration = ev.val;
+		ir_raw_event_store_with_filter(dev, &rawir);
 	}
 
 	/* Fake a silence long enough to cause us to go idle */
+	init_ir_raw_event(&rawir);
 	rawir.pulse = false;
 	rawir.duration = dev->timeout;
 	ir_raw_event_store_with_filter(dev, &rawir);
 
 	ir_raw_event_handle(dev);
 
-out:
 	return count;
 }
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 5ce0cdb..43789b4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1591,6 +1591,7 @@ static void rc_dev_release(struct device *device)
 	if (dev->input_dev)
 		input_free_device(dev->input_dev);
 
+	kfifo_free(&dev->txfifo);
 	kfree(dev);
 	module_put(THIS_MODULE);
 }
@@ -1696,6 +1697,7 @@ struct rc_dev *rc_allocate_device(void)
 
 	INIT_LIST_HEAD(&dev->client_list);
 	spin_lock_init(&dev->client_lock);
+	mutex_init(&dev->txmutex);
 	init_waitqueue_head(&dev->rxwait);
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
@@ -1763,6 +1765,12 @@ int rc_register_device(struct rc_dev *dev)
 	dev_set_name(&dev->dev, "rc%u", minor);
 	dev_set_drvdata(&dev->dev, dev);
 
+	if (dev->tx_ir) {
+		rc = kfifo_alloc(&dev->txfifo, RC_TX_KFIFO_SIZE, GFP_KERNEL);
+		if (rc)
+			goto out_minor;
+	}
+
 	dev->dev.groups = dev->sysfs_groups;
 	dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
 	if (dev->s_filter)
@@ -1874,6 +1882,7 @@ out_cdev:
 	cdev_del(&dev->cdev);
 out_unlock:
 	mutex_unlock(&dev->lock);
+out_minor:
 	ida_simple_remove(&rc_ida, minor);
 	return rc;
 }
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 3f45e1a..3a931a5 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -752,90 +752,105 @@ static int redrat3_set_tx_carrier(struct rc_dev *rcdev, u32 carrier)
 	return carrier;
 }
 
-static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
-				unsigned count)
+static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned count)
 {
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
 	struct redrat3_irdata *irdata = NULL;
-	int ret, ret_len;
-	int lencheck, cur_sample_len, pipe;
-	int *sample_lens = NULL;
-	u8 curlencheck = 0;
-	unsigned i, sendbuf_len;
+	int ret = 0;
+	int pipe, tmp;
+	unsigned sendbuf_len;
+	struct rc_event ev;
+	unsigned events_consumed = 0;
+	unsigned short sample_lens[RR3_DRIVER_MAXLENS];
+	unsigned n_sample_lens = 0;
+	unsigned n_sigs = 0;
+	bool send_pulse = true;
 
 	rr3_ftr(dev, "Entering %s\n", __func__);
 
 	if (rr3->transmitting) {
 		dev_warn(dev, "%s: transmitter already in use\n", __func__);
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out;
 	}
 
-	if (count > RR3_MAX_SIG_SIZE - RR3_TX_TRAILER_LEN)
-		return -EINVAL;
-
 	/* rr3 will disable rc detector on transmit */
 	rr3->transmitting = true;
 
-	sample_lens = kzalloc(sizeof(int) * RR3_DRIVER_MAXLENS, GFP_KERNEL);
-	if (!sample_lens) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	irdata = kzalloc(sizeof(*irdata), GFP_KERNEL);
 	if (!irdata) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	for (i = 0; i < count; i++) {
-		cur_sample_len = redrat3_us_to_len(txbuf[i]);
-		if (cur_sample_len > 0xffff) {
-			dev_warn(dev, "transmit period of %uus truncated to %uus\n",
-					txbuf[i], redrat3_len_to_us(0xffff));
-			cur_sample_len = 0xffff;
+	while ((tmp = ir_raw_get_tx_event(rcdev, &ev)) > 0) {
+		unsigned sample_len;
+		unsigned i;
+
+		/* Sanity check */
+		if ((ev.code == RC_IR_SPACE && send_pulse) ||
+		    (ev.code == RC_IR_PULSE && !send_pulse)) {
+			ret = -EINVAL;
+			goto out;
 		}
-		for (lencheck = 0; lencheck < curlencheck; lencheck++) {
-			if (sample_lens[lencheck] == cur_sample_len)
+
+		events_consumed += tmp;
+		send_pulse = !send_pulse;
+		sample_len = redrat3_us_to_len(ev.val);
+
+		if (sample_len > 0xffff) {
+			dev_warn(dev, "transmitting %uus not supported\n",
+				 redrat3_len_to_us(sample_len));
+			ret = -EMSGSIZE;
+			goto out;
+		}
+
+		/* See if a sample of this length is already in the array... */
+		for (i = 0; i < n_sample_lens; i++) {
+			if (sample_lens[i] == sample_len)
 				break;
 		}
-		if (lencheck == curlencheck) {
-			rr3_dbg(dev, "txbuf[%d]=%u, pos %d, enc %u\n",
-				i, txbuf[i], curlencheck, cur_sample_len);
-			if (curlencheck < RR3_DRIVER_MAXLENS) {
-				/* now convert the value to a proper
-				 * rr3 value.. */
-				sample_lens[curlencheck] = cur_sample_len;
-				put_unaligned_be16(cur_sample_len,
-						&irdata->lens[curlencheck]);
-				curlencheck++;
-			} else {
-				ret = -EINVAL;
+
+		if (i == n_sample_lens) {
+			/* ...nope, add it */
+			rr3_dbg(dev, "pos %u, enc %u\n", i, sample_len);
+
+			if (i >= RR3_DRIVER_MAXLENS) {
+				ret = -EMSGSIZE;
 				goto out;
 			}
+
+			sample_lens[i] = sample_len;
+			put_unaligned_be16(sample_len, &irdata->lens[i]);
+			n_sample_lens++;
+		}
+
+		if (n_sigs >= RR3_MAX_SIG_SIZE - RR3_TX_TRAILER_LEN) {
+			ret = -EMSGSIZE;
+			goto out;
 		}
-		irdata->sigdata[i] = lencheck;
+
+		irdata->sigdata[n_sigs++] = i;
 	}
 
-	irdata->sigdata[count] = RR3_END_OF_SIGNAL;
-	irdata->sigdata[count + 1] = RR3_END_OF_SIGNAL;
+	irdata->sigdata[n_sigs++] = RR3_END_OF_SIGNAL;
+	irdata->sigdata[n_sigs++] = RR3_END_OF_SIGNAL;
+	sendbuf_len = offsetof(struct redrat3_irdata, sigdata[n_sigs]);
 
-	sendbuf_len = offsetof(struct redrat3_irdata,
-					sigdata[count + RR3_TX_TRAILER_LEN]);
 	/* fill in our packet header */
 	irdata->header.length = cpu_to_be16(sendbuf_len -
-						sizeof(struct redrat3_header));
+					    sizeof(struct redrat3_header));
 	irdata->header.transfer_type = cpu_to_be16(RR3_MOD_SIGNAL_OUT);
 	irdata->pause = cpu_to_be32(redrat3_len_to_us(100));
 	irdata->mod_freq_count = cpu_to_be16(mod_freq_to_val(rr3->carrier));
-	irdata->no_lengths = curlencheck;
-	irdata->sig_size = cpu_to_be16(count + RR3_TX_TRAILER_LEN);
+	irdata->no_lengths = n_sample_lens;
+	irdata->sig_size = cpu_to_be16(n_sigs);
 
 	pipe = usb_sndbulkpipe(rr3->udev, rr3->ep_out->bEndpointAddress);
 	ret = usb_bulk_msg(rr3->udev, pipe, irdata,
-			    sendbuf_len, &ret_len, 10 * HZ);
-	rr3_dbg(dev, "sent %d bytes, (ret %d)\n", ret_len, ret);
+			   sendbuf_len, &tmp, 10 * HZ);
+	rr3_dbg(dev, "sent %d bytes, (ret %d)\n", tmp, ret);
 
 	/* now tell the hardware to transmit what we sent it */
 	pipe = usb_rcvctrlpipe(rr3->udev, 0);
@@ -846,11 +861,11 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	if (ret < 0)
 		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);
 	else
-		ret = count;
+		ret = events_consumed;
 
 out:
-	kfree(sample_lens);
 	kfree(irdata);
+	kfifo_reset_out(&rcdev->txfifo);
 
 	rr3->transmitting = false;
 	/* rr3 re-enables rc detector because it was enabled before */
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index d839f73..8871109 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -218,9 +218,8 @@ struct wbcir_data {
 
 	/* TX state */
 	enum wbcir_txstate txstate;
-	u32 txlen;
-	u32 txoff;
-	u32 *txbuf;
+	struct led_trigger *txtrigger;
+	struct rc_event txev;
 	u8 txmask;
 	u32 txcarrier;
 };
@@ -413,9 +412,6 @@ wbcir_irq_tx(struct wbcir_data *data)
 	u8 bytes[16];
 	u8 byte;
 
-	if (!data->txbuf)
-		return;
-
 	switch (data->txstate) {
 	case WBCIR_TXSTATE_INACTIVE:
 		/* TX FIFO empty */
@@ -437,31 +433,43 @@ wbcir_irq_tx(struct wbcir_data *data)
 	 * Y = space (1) or pulse (0)
 	 * X = duration, encoded as (X + 1) * 10us (i.e 10 to 1280 us)
 	 */
-	for (used = 0; used < space && data->txoff != data->txlen; used++) {
-		if (data->txbuf[data->txoff] == 0) {
-			data->txoff++;
-			continue;
+	for (used = 0; used < space; used++) {
+		while (data->txev.val == 0) {
+			int tmp;
+
+			tmp = ir_raw_get_tx_event(data->dev, &data->txev);
+			if (tmp < 1) {
+				data->txev.val = 0;
+				if (tmp < 0)
+					continue;
+				else
+					break;
+			}
+
+			/* Convert duration to multiples of 10us */
+			data->txev.val = DIV_ROUND_CLOSEST(data->txev.val,
+							   10 * 1000);
 		}
-		byte = min((u32)0x80, data->txbuf[data->txoff]);
-		data->txbuf[data->txoff] -= byte;
+
+		if (data->txev.val == 0)
+			break;
+
+		byte = min_t(u32, 0x80, data->txev.val);
+		data->txev.val -= byte;
 		byte--;
-		byte |= (data->txoff % 2 ? 0x80 : 0x00); /* pulse/space */
+		byte |= (data->txev.code == RC_IR_PULSE ? 0x80 : 0x00);
 		bytes[used] = byte;
 	}
 
-	while (data->txbuf[data->txoff] == 0 && data->txoff != data->txlen)
-		data->txoff++;
-
 	if (used == 0) {
 		/* Finished */
 		if (data->txstate == WBCIR_TXSTATE_ERROR)
 			/* Clear TX underrun bit */
 			outb(WBCIR_TX_UNDERRUN, data->sbase + WBCIR_REG_SP3_ASCR);
 		wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR);
-		kfree(data->txbuf);
-		data->txbuf = NULL;
 		data->txstate = WBCIR_TXSTATE_INACTIVE;
-	} else if (data->txoff == data->txlen) {
+		data->txev.val = 0;
+	} else if (data->txev.val == 0 && kfifo_is_empty(&data->dev->txfifo)) {
 		/* At the end of transmission, tell the hw before last byte */
 		outsb(data->sbase + WBCIR_REG_SP3_TXDATA, bytes, used - 1);
 		outb(WBCIR_TX_EOT, data->sbase + WBCIR_REG_SP3_ASCR);
@@ -649,37 +657,17 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)
 }
 
 static int
-wbcir_tx(struct rc_dev *dev, unsigned *b, unsigned count)
+wbcir_tx(struct rc_dev *dev, unsigned count)
 {
 	struct wbcir_data *data = dev->priv;
-	unsigned *buf;
-	unsigned i;
 	unsigned long flags;
 
-	buf = kmalloc(count * sizeof(*b), GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	/* Convert values to multiples of 10us */
-	for (i = 0; i < count; i++)
-		buf[i] = DIV_ROUND_CLOSEST(b[i], 10);
-
-	/* Not sure if this is possible, but better safe than sorry */
 	spin_lock_irqsave(&data->spinlock, flags);
-	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
-		spin_unlock_irqrestore(&data->spinlock, flags);
-		kfree(buf);
-		return -EBUSY;
-	}
-
-	/* Fill the TX fifo once, the irq handler will do the rest */
-	data->txbuf = buf;
-	data->txlen = count;
-	data->txoff = 0;
-	wbcir_irq_tx(data);
-
-	/* We're done */
+	if (data->txstate == WBCIR_TXSTATE_INACTIVE)
+		/* Kick the tx irq handler once, it will do the rest */
+		wbcir_irq_tx(data);
 	spin_unlock_irqrestore(&data->spinlock, flags);
+
 	return count;
 }
 
@@ -990,9 +978,8 @@ wbcir_init_hw(struct wbcir_data *data)
 
 	/* Clear TX state */
 	if (data->txstate == WBCIR_TXSTATE_ACTIVE) {
-		kfree(data->txbuf);
-		data->txbuf = NULL;
 		data->txstate = WBCIR_TXSTATE_INACTIVE;
+		data->txev.val = 0;
 	}
 
 	/* Enable interrupts */
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index d31ccdd..ca22cf7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -90,6 +90,8 @@ struct rc_event {
 	__u32 val;
 } __packed;
 
+#define RC_TX_KFIFO_SIZE	1024
+
 /**
  * struct rc_scancode_filter - Filter scan codes.
  * @data:	Scancode data to match.
@@ -129,6 +131,8 @@ enum rc_filter_type {
  * @dead: used to determine if the device is still alive
  * @client_list: list of clients (processes which have opened the rc chardev)
  * @client_lock: protects client_list
+ * @txfifo: fifo with tx data to transmit
+ * @txmutex: protects txfifo and serializes calls to @tx_ir
  * @rxwait: waitqueue for processes waiting for data to read
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
@@ -193,6 +197,8 @@ struct rc_dev {
 	bool				dead;
 	struct list_head		client_list;
 	spinlock_t			client_lock;
+	DECLARE_KFIFO_PTR(txfifo, struct rc_event);
+	struct mutex			txmutex;
 	wait_queue_head_t		rxwait;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
@@ -228,7 +234,7 @@ struct rc_dev {
 	int				(*s_tx_carrier)(struct rc_dev *dev, u32 carrier);
 	int				(*s_tx_duty_cycle)(struct rc_dev *dev, u32 duty_cycle);
 	int				(*s_rx_carrier_range)(struct rc_dev *dev, u32 min, u32 max);
-	int				(*tx_ir)(struct rc_dev *dev, unsigned *txbuf, unsigned n);
+	int				(*tx_ir)(struct rc_dev *dev, unsigned count);
 	void				(*s_idle)(struct rc_dev *dev, bool enable);
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
@@ -315,6 +321,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
 				struct ir_raw_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
+int ir_raw_get_tx_event(struct rc_dev *dev, struct rc_event *ev);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {

