Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:35193 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab1D1PTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 11:19:46 -0400
Subject: [PATCH 09/10] rc-core: lirc use unsigned int
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@redhat.com
Date: Thu, 28 Apr 2011 17:13:58 +0200
Message-ID: <20110428151358.8272.94634.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Durations can never be negative, so it makes sense to consistently use
unsigned int for LIRC transmission. Contrary to the initial impression,
this shouldn't actually change the userspace API.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ene_ir.c        |    4 ++--
 drivers/media/rc/ene_ir.h        |    2 +-
 drivers/media/rc/ir-lirc-codec.c |   15 +++++++++------
 drivers/media/rc/ite-cir.c       |    5 +----
 drivers/media/rc/mceusb.c        |   10 ++++------
 drivers/media/rc/nuvoton-cir.c   |   12 +++---------
 drivers/media/rc/rc-loopback.c   |   13 +++----------
 drivers/media/rc/winbond-cir.c   |    6 +-----
 include/media/rc-core.h          |    2 +-
 9 files changed, 25 insertions(+), 44 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 569b07b..2b1d2df 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -953,13 +953,13 @@ static void ene_set_idle(struct rc_dev *rdev, bool idle)
 }
 
 /* outside interface: transmit */
-static int ene_transmit(struct rc_dev *rdev, int *buf, u32 n)
+static int ene_transmit(struct rc_dev *rdev, unsigned *buf, unsigned n)
 {
 	struct ene_device *dev = rdev->priv;
 	unsigned long flags;
 
 	dev->tx_buffer = buf;
-	dev->tx_len = n / sizeof(int);
+	dev->tx_len = n;
 	dev->tx_pos = 0;
 	dev->tx_reg = 0;
 	dev->tx_done = 0;
diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index 337a41d..017c209 100644
--- a/drivers/media/rc/ene_ir.h
+++ b/drivers/media/rc/ene_ir.h
@@ -235,7 +235,7 @@ struct ene_device {
 	bool tx_sample_pulse;			/* current sample is pulse */
 
 	/* TX buffer */
-	int *tx_buffer;				/* input samples buffer*/
+	unsigned *tx_buffer;			/* input samples buffer*/
 	int tx_pos;				/* position in that bufer */
 	int tx_len;				/* current len of tx buffer */
 	int tx_done;				/* done transmitting */
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index b4119f8..ac54139 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -103,19 +103,19 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 {
 	struct lirc_codec *lirc;
 	struct rc_dev *dev;
-	int *txbuf; /* buffer with values to transmit */
-	int ret = 0;
+	unsigned int *txbuf; /* buffer with values to transmit */
+	ssize_t ret = 0;
 	size_t count;
 
 	lirc = lirc_get_pdata(file);
 	if (!lirc)
 		return -EFAULT;
 
-	if (n % sizeof(int))
+	if (n < sizeof(unsigned) || n % sizeof(unsigned))
 		return -EINVAL;
 
-	count = n / sizeof(int);
-	if (count > LIRCBUF_SIZE || count % 2 == 0 || n % sizeof(int) != 0)
+	count = n / sizeof(unsigned);
+	if (count > LIRCBUF_SIZE || count % 2 == 0)
 		return -EINVAL;
 
 	txbuf = memdup_user(buf, n);
@@ -129,7 +129,10 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 	}
 
 	if (dev->tx_ir)
-		ret = dev->tx_ir(dev, txbuf, (u32)n);
+		ret = dev->tx_ir(dev, txbuf, count);
+
+	if (ret > 0)
+		ret *= sizeof(unsigned);
 
 out:
 	kfree(txbuf);
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 3d13fcb..e8f7847 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -381,7 +381,7 @@ static int ite_set_tx_duty_cycle(struct rc_dev *rcdev, u32 duty_cycle)
 /* transmit out IR pulses; what you get here is a batch of alternating
  * pulse/space/pulse/space lengths that we should write out completely through
  * the FIFO, blocking on a full FIFO */
-static int ite_tx_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
+static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 {
 	unsigned long flags;
 	struct ite_dev *dev = rcdev->priv;
@@ -397,9 +397,6 @@ static int ite_tx_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
 	/* clear the array just in case */
 	memset(last_sent, 0, ARRAY_SIZE(last_sent));
 
-	/* n comes in bytes; convert to ints */
-	n /= sizeof(int);
-
 	spin_lock_irqsave(&dev->lock, flags);
 
 	/* let everybody know we're now transmitting */
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index c51e7c2..c1cd00d 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -665,20 +665,18 @@ static void mce_sync_in(struct mceusb_dev *ir, unsigned char *data, int size)
 }
 
 /* Send data out the IR blaster port(s) */
-static int mceusb_tx_ir(struct rc_dev *dev, int *txbuf, u32 n)
+static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 {
 	struct mceusb_dev *ir = dev->priv;
 	int i, ret = 0;
-	int count, cmdcount = 0;
+	int cmdcount = 0;
 	unsigned char *cmdbuf; /* MCE command buffer */
 	long signal_duration = 0; /* Singnal length in us */
 	struct timeval start_time, end_time;
 
 	do_gettimeofday(&start_time);
 
-	count = n / sizeof(int);
-
-	cmdbuf = kzalloc(sizeof(int) * MCE_CMDBUF_SIZE, GFP_KERNEL);
+	cmdbuf = kzalloc(sizeof(unsigned) * MCE_CMDBUF_SIZE, GFP_KERNEL);
 	if (!cmdbuf)
 		return -ENOMEM;
 
@@ -747,7 +745,7 @@ static int mceusb_tx_ir(struct rc_dev *dev, int *txbuf, u32 n)
 
 out:
 	kfree(cmdbuf);
-	return ret ? ret : n;
+	return ret ? ret : count;
 }
 
 /* Sets active IR outputs -- mce devices typically have two */
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index dba02b5..64fea04 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -512,24 +512,18 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
  * number may larger than TXFCONT (0xff). So in interrupt_handler, it has to
  * set TXFCONT as 0xff, until buf_count less than 0xff.
  */
-static int nvt_tx_ir(struct rc_dev *dev, int *txbuf, u32 n)
+static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
 {
 	struct nvt_dev *nvt = dev->priv;
 	unsigned long flags;
-	size_t cur_count;
 	unsigned int i;
 	u8 iren;
 	int ret;
 
 	spin_lock_irqsave(&nvt->tx.lock, flags);
 
-	if (n >= TX_BUF_LEN) {
-		nvt->tx.buf_count = cur_count = TX_BUF_LEN;
-		ret = TX_BUF_LEN;
-	} else {
-		nvt->tx.buf_count = cur_count = n;
-		ret = n;
-	}
+	ret = min((unsigned)(TX_BUF_LEN / sizeof(unsigned)), n);
+	nvt->tx.buf_count = (ret * sizeof(unsigned));
 
 	memcpy(nvt->tx.buf, txbuf, nvt->tx.buf_count);
 
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 6dee719..fb8ca81 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -101,21 +101,14 @@ static int loop_set_rx_carrier_range(struct rc_dev *dev, u32 min, u32 max)
 	return 0;
 }
 
-static int loop_tx_ir(struct rc_dev *dev, int *txbuf, u32 n)
+static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 {
 	struct loopback_dev *lodev = dev->priv;
 	u32 rxmask;
-	unsigned count;
 	unsigned total_duration = 0;
 	unsigned i;
 	DEFINE_IR_RAW_EVENT(rawir);
 
-	if (n == 0 || n % sizeof(int)) {
-		dprintk("invalid tx buffer size\n");
-		return -EINVAL;
-	}
-
-	count = n / sizeof(int);
 	for (i = 0; i < count; i++)
 		total_duration += abs(txbuf[i]);
 
@@ -142,7 +135,7 @@ static int loop_tx_ir(struct rc_dev *dev, int *txbuf, u32 n)
 
 	for (i = 0; i < count; i++) {
 		rawir.pulse = i % 2 ? false : true;
-		rawir.duration = abs(txbuf[i]) * 1000;
+		rawir.duration = txbuf[i] * 1000;
 		if (rawir.duration)
 			ir_raw_event_store_with_filter(dev, &rawir);
 	}
@@ -158,7 +151,7 @@ out:
 	/* Lirc expects this function to take as long as the total duration */
 	set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout(usecs_to_jiffies(total_duration));
-	return n;
+	return count;
 }
 
 static void loop_set_idle(struct rc_dev *dev, bool enable)
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 48bafa2..b74d0fd 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -577,16 +577,12 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)
 }
 
 static int
-wbcir_tx(struct rc_dev *dev, int *buf, u32 bufsize)
+wbcir_tx(struct rc_dev *dev, unsigned *buf, unsigned count)
 {
 	struct wbcir_data *data = dev->priv;
-	u32 count;
 	unsigned i;
 	unsigned long flags;
 
-	/* bufsize has been sanity checked by the caller */
-	count = bufsize / sizeof(int);
-
 	/* Not sure if this is possible, but better safe than sorry */
 	spin_lock_irqsave(&data->spinlock, flags);
 	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 1e6b6fc..052ce79 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -134,7 +134,7 @@ struct rc_dev {
 	int				(*s_tx_carrier)(struct rc_dev *dev, u32 carrier);
 	int				(*s_tx_duty_cycle)(struct rc_dev *dev, u32 duty_cycle);
 	int				(*s_rx_carrier_range)(struct rc_dev *dev, u32 min, u32 max);
-	int				(*tx_ir)(struct rc_dev *dev, int *txbuf, u32 n);
+	int				(*tx_ir)(struct rc_dev *dev, unsigned *txbuf, unsigned n);
 	void				(*s_idle)(struct rc_dev *dev, bool enable);
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);

