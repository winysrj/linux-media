Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:59247 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932569AbcLLVN7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 16:13:59 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        James Hogan <james@albanarts.com>,
        Jarod Wilson <jarod@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v5 18/18] [media] rc: nuvoton-cir: Add support wakeup via sysfs filter callback
Date: Mon, 12 Dec 2016 21:13:54 +0000
Message-Id: <8f298b8d0693d71cac10bc6b6b4a2a92b1899d68.1481575826.git.sean@mess.org>
In-Reply-To: <1669f6c54c34e5a78ce114c633c98b331e58e8c7.1481575826.git.sean@mess.org>
References: <1669f6c54c34e5a78ce114c633c98b331e58e8c7.1481575826.git.sean@mess.org>
In-Reply-To: <cover.1481575826.git.sean@mess.org>
References: <cover.1481575826.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antti Seppälä <a.seppala@gmail.com>

Nuvoton-cir utilizes the encoding capabilities of rc-core to convert
scancodes from user space to pulse/space format understood by the
underlying hardware.

Converted samples are then written to the wakeup fifo along with other
necessary configuration to enable wake up functionality.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 120 ++++++++++++++++++++++++++++++++---------
 1 file changed, 96 insertions(+), 24 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 9e04f41..2e2d981 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -176,6 +176,41 @@ static void nvt_set_ioaddr(struct nvt_dev *nvt, unsigned long *ioaddr)
 	}
 }
 
+static void nvt_write_wakeup_codes(struct rc_dev *dev,
+				   const u8 *wbuf, int count)
+{
+	u8 tolerance, config;
+	struct nvt_dev *nvt = dev->priv;
+	int i;
+
+	/* hardcode the tolerance to 10% */
+	tolerance = DIV_ROUND_UP(count, 10);
+
+	spin_lock(&nvt->lock);
+
+	nvt_clear_cir_wake_fifo(nvt);
+	nvt_cir_wake_reg_write(nvt, count, CIR_WAKE_FIFO_CMP_DEEP);
+	nvt_cir_wake_reg_write(nvt, tolerance, CIR_WAKE_FIFO_CMP_TOL);
+
+	config = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
+
+	/* enable writes to wake fifo */
+	nvt_cir_wake_reg_write(nvt, config | CIR_WAKE_IRCON_MODE1,
+			       CIR_WAKE_IRCON);
+
+	if (count)
+		pr_info("Wake samples (%d) =", count);
+	else
+		pr_info("Wake sample fifo cleared");
+
+	for (i = 0; i < count; i++)
+		nvt_cir_wake_reg_write(nvt, wbuf[i], CIR_WAKE_WR_FIFO_DATA);
+
+	nvt_cir_wake_reg_write(nvt, config, CIR_WAKE_IRCON);
+
+	spin_unlock(&nvt->lock);
+}
+
 static ssize_t wakeup_data_show(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -214,9 +249,7 @@ static ssize_t wakeup_data_store(struct device *dev,
 				 const char *buf, size_t len)
 {
 	struct rc_dev *rc_dev = to_rc_dev(dev);
-	struct nvt_dev *nvt = rc_dev->priv;
-	unsigned long flags;
-	u8 tolerance, config, wake_buf[WAKEUP_MAX_SIZE];
+	u8 wake_buf[WAKEUP_MAX_SIZE];
 	char **argv;
 	int i, count;
 	unsigned int val;
@@ -245,27 +278,7 @@ static ssize_t wakeup_data_store(struct device *dev,
 			wake_buf[i] |= BUF_PULSE_BIT;
 	}
 
-	/* hardcode the tolerance to 10% */
-	tolerance = DIV_ROUND_UP(count, 10);
-
-	spin_lock_irqsave(&nvt->lock, flags);
-
-	nvt_clear_cir_wake_fifo(nvt);
-	nvt_cir_wake_reg_write(nvt, count, CIR_WAKE_FIFO_CMP_DEEP);
-	nvt_cir_wake_reg_write(nvt, tolerance, CIR_WAKE_FIFO_CMP_TOL);
-
-	config = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
-
-	/* enable writes to wake fifo */
-	nvt_cir_wake_reg_write(nvt, config | CIR_WAKE_IRCON_MODE1,
-			       CIR_WAKE_IRCON);
-
-	for (i = 0; i < count; i++)
-		nvt_cir_wake_reg_write(nvt, wake_buf[i], CIR_WAKE_WR_FIFO_DATA);
-
-	nvt_cir_wake_reg_write(nvt, config, CIR_WAKE_IRCON);
-
-	spin_unlock_irqrestore(&nvt->lock, flags);
+	nvt_write_wakeup_codes(rc_dev, wake_buf, count);
 
 	ret = len;
 out:
@@ -662,6 +675,62 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
+static int nvt_ir_raw_set_wakeup_filter(struct rc_dev *dev,
+					struct rc_scancode_filter *sc_filter)
+{
+	u8 buf_val;
+	int i, ret, count;
+	unsigned int val;
+	struct ir_raw_event *raw;
+	u8 wake_buf[WAKEUP_MAX_SIZE];
+	bool complete;
+
+	/* Require mask to be set */
+	if (!sc_filter->mask)
+		return 0;
+
+	raw = kmalloc_array(WAKEUP_MAX_SIZE, sizeof(*raw), GFP_KERNEL);
+	if (!raw)
+		return -ENOMEM;
+
+	ret = ir_raw_encode_scancode(dev->wakeup_protocol, sc_filter->data,
+				     raw, WAKEUP_MAX_SIZE);
+	complete = (ret != -ENOBUFS);
+	if (!complete)
+		ret = WAKEUP_MAX_SIZE;
+	else if (ret < 0)
+		goto out_raw;
+
+	/* Inspect the ir samples */
+	for (i = 0, count = 0; i < ret && count < WAKEUP_MAX_SIZE; ++i) {
+		/* NS to US */
+		val = DIV_ROUND_UP(raw[i].duration, 1000L) / SAMPLE_PERIOD;
+
+		/* Split too large values into several smaller ones */
+		while (val > 0 && count < WAKEUP_MAX_SIZE) {
+			/* Skip last value for better comparison tolerance */
+			if (complete && i == ret - 1 && val < BUF_LEN_MASK)
+				break;
+
+			/* Clamp values to BUF_LEN_MASK at most */
+			buf_val = (val > BUF_LEN_MASK) ? BUF_LEN_MASK : val;
+
+			wake_buf[count] = buf_val;
+			val -= buf_val;
+			if ((raw[i]).pulse)
+				wake_buf[count] |= BUF_PULSE_BIT;
+			count++;
+		}
+	}
+
+	nvt_write_wakeup_codes(dev, wake_buf, count);
+	ret = 0;
+out_raw:
+	kfree(raw);
+
+	return ret;
+}
+
 /*
  * nvt_tx_ir
  *
@@ -1063,10 +1132,13 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rdev->allowed_wakeup_protocols = RC_BIT_ALL_IR_ENCODER;
+	rdev->encode_wakeup = true;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
+	rdev->s_wakeup_filter = nvt_ir_raw_set_wakeup_filter;
 	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
 	rdev->input_phys = "nuvoton/cir0";
 	rdev->input_id.bustype = BUS_HOST;
-- 
2.9.3

