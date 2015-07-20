Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52562 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbbGTTQd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:16:33 -0400
Subject: [PATCH 1/7] [PATCH FIXES] Revert "[media] rc: nuvoton-cir: Add
 support for writing wakeup samples via sysfs filter callback"
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 20 Jul 2015 21:16:31 +0200
Message-ID: <20150720191631.24633.58589.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
References: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit da7ee60b03bd66bb10974d7444aa444de6391312.

The current code is not mature enough, the API should allow a single
protocol to be specified. Also, the current code contains heuristics
that will depend on module load order.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/nuvoton-cir.c |  127 ----------------------------------------
 drivers/media/rc/nuvoton-cir.h |    1 
 include/media/rc-core.h        |    1 
 3 files changed, 129 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index baeb597..85af7a8 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -526,130 +526,6 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
-static int nvt_write_wakeup_codes(struct rc_dev *dev,
-				  const u8 *wakeup_sample_buf, int count)
-{
-	int i = 0;
-	u8 reg, reg_learn_mode;
-	unsigned long flags;
-	struct nvt_dev *nvt = dev->priv;
-
-	nvt_dbg_wake("writing wakeup samples");
-
-	reg = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
-	reg_learn_mode = reg & ~CIR_WAKE_IRCON_MODE0;
-	reg_learn_mode |= CIR_WAKE_IRCON_MODE1;
-
-	/* Lock the learn area to prevent racing with wake-isr */
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
-
-	/* Enable fifo writes */
-	nvt_cir_wake_reg_write(nvt, reg_learn_mode, CIR_WAKE_IRCON);
-
-	/* Clear cir wake rx fifo */
-	nvt_clear_cir_wake_fifo(nvt);
-
-	if (count > WAKE_FIFO_LEN) {
-		nvt_dbg_wake("HW FIFO too small for all wake samples");
-		count = WAKE_FIFO_LEN;
-	}
-
-	if (count)
-		pr_info("Wake samples (%d) =", count);
-	else
-		pr_info("Wake sample fifo cleared");
-
-	/* Write wake samples to fifo */
-	for (i = 0; i < count; i++) {
-		pr_cont(" %02x", wakeup_sample_buf[i]);
-		nvt_cir_wake_reg_write(nvt, wakeup_sample_buf[i],
-				       CIR_WAKE_WR_FIFO_DATA);
-	}
-	pr_cont("\n");
-
-	/* Switch cir to wakeup mode and disable fifo writing */
-	nvt_cir_wake_reg_write(nvt, reg, CIR_WAKE_IRCON);
-
-	/* Set number of bytes needed for wake */
-	nvt_cir_wake_reg_write(nvt, count ? count :
-			       CIR_WAKE_FIFO_CMP_BYTES,
-			       CIR_WAKE_FIFO_CMP_DEEP);
-
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
-
-	return 0;
-}
-
-static int nvt_ir_raw_set_wakeup_filter(struct rc_dev *dev,
-					struct rc_scancode_filter *sc_filter)
-{
-	u8 *reg_buf;
-	u8 buf_val;
-	int i, ret, count;
-	unsigned int val;
-	struct ir_raw_event *raw;
-	bool complete;
-
-	/* Require both mask and data to be set before actually committing */
-	if (!sc_filter->mask || !sc_filter->data)
-		return 0;
-
-	raw = kmalloc_array(WAKE_FIFO_LEN, sizeof(*raw), GFP_KERNEL);
-	if (!raw)
-		return -ENOMEM;
-
-	ret = ir_raw_encode_scancode(dev->enabled_wakeup_protocols, sc_filter,
-				     raw, WAKE_FIFO_LEN);
-	complete = (ret != -ENOBUFS);
-	if (!complete)
-		ret = WAKE_FIFO_LEN;
-	else if (ret < 0)
-		goto out_raw;
-
-	reg_buf = kmalloc_array(WAKE_FIFO_LEN, sizeof(*reg_buf), GFP_KERNEL);
-	if (!reg_buf) {
-		ret = -ENOMEM;
-		goto out_raw;
-	}
-
-	/* Inspect the ir samples */
-	for (i = 0, count = 0; i < ret && count < WAKE_FIFO_LEN; ++i) {
-		val = NS_TO_US((raw[i]).duration) / SAMPLE_PERIOD;
-
-		/* Split too large values into several smaller ones */
-		while (val > 0 && count < WAKE_FIFO_LEN) {
-
-			/* Skip last value for better comparison tolerance */
-			if (complete && i == ret - 1 && val < BUF_LEN_MASK)
-				break;
-
-			/* Clamp values to BUF_LEN_MASK at most */
-			buf_val = (val > BUF_LEN_MASK) ? BUF_LEN_MASK : val;
-
-			reg_buf[count] = buf_val;
-			val -= buf_val;
-			if ((raw[i]).pulse)
-				reg_buf[count] |= BUF_PULSE_BIT;
-			count++;
-		}
-	}
-
-	ret = nvt_write_wakeup_codes(dev, reg_buf, count);
-
-	kfree(reg_buf);
-out_raw:
-	kfree(raw);
-
-	return ret;
-}
-
-/* Dummy implementation. nuvoton is agnostic to the protocol used */
-static int nvt_ir_raw_change_wakeup_protocol(struct rc_dev *dev,
-					     u64 *rc_type)
-{
-	return 0;
-}
-
 /*
  * nvt_tx_ir
  *
@@ -1167,14 +1043,11 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->encode_wakeup = true;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
-	rdev->s_wakeup_filter = nvt_ir_raw_set_wakeup_filter;
-	rdev->change_wakeup_protocol = nvt_ir_raw_change_wakeup_protocol;
 	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
 	rdev->input_phys = "nuvoton/cir0";
 	rdev->input_id.bustype = BUS_HOST;
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 9d0e161..e1cf23c 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -63,7 +63,6 @@ static int debug;
  */
 #define TX_BUF_LEN 256
 #define RX_BUF_LEN 32
-#define WAKE_FIFO_LEN 67
 
 struct nvt_dev {
 	struct pnp_dev *pdev;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 5642fbe..9a9beb8 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -246,7 +246,6 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 #define US_TO_NS(usec)		((usec) * 1000)
 #define MS_TO_US(msec)		((msec) * 1000)
 #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
-#define NS_TO_US(nsec)		DIV_ROUND_UP(nsec, 1000L)
 
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);

