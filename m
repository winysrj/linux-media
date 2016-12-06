Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53109 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752194AbcLFKTc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:32 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        James Hogan <james@albanarts.com>,
        Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v4 13/13] [media] rc: nuvoton-cir: Add support wakeup via sysfs filter callback
Date: Tue,  6 Dec 2016 10:19:21 +0000
Message-Id: <5aacd20bd41d814c72ef365acb941b4ae5e20381.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
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
---
 drivers/media/rc/nuvoton-cir.c | 126 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h |   1 +
 include/media/rc-core.h        |   1 +
 3 files changed, 128 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 9e04f41..ec16012 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -662,6 +662,129 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
+static int nvt_write_wakeup_codes(struct rc_dev *dev,
+				  const u8 *wakeup_sample_buf, int count)
+{
+	u8 reg, reg_learn_mode;
+	struct nvt_dev *nvt = dev->priv;
+	int i;
+
+	nvt_dbg_wake("writing wakeup samples");
+
+	reg = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
+	reg_learn_mode = reg & ~CIR_WAKE_IRCON_MODE0;
+	reg_learn_mode |= CIR_WAKE_IRCON_MODE1;
+
+	/* Lock the learn area to prevent racing with wake-isr */
+	spin_lock(&nvt->lock);
+
+	/* Enable fifo writes */
+	nvt_cir_wake_reg_write(nvt, reg_learn_mode, CIR_WAKE_IRCON);
+
+	/* Clear cir wake rx fifo */
+	nvt_clear_cir_wake_fifo(nvt);
+
+	if (count > WAKE_FIFO_LEN) {
+		nvt_dbg_wake("HW FIFO too small for all wake samples");
+		count = WAKE_FIFO_LEN;
+	}
+
+	if (count)
+		pr_info("Wake samples (%d) =", count);
+	else
+		pr_info("Wake sample fifo cleared");
+
+	/* Write wake samples to fifo */
+	for (i = 0; i < count; i++) {
+		pr_cont(" %02x", wakeup_sample_buf[i]);
+		nvt_cir_wake_reg_write(nvt, wakeup_sample_buf[i],
+				       CIR_WAKE_WR_FIFO_DATA);
+	}
+	pr_cont("\n");
+
+	/* Switch cir to wakeup mode and disable fifo writing */
+	nvt_cir_wake_reg_write(nvt, reg, CIR_WAKE_IRCON);
+
+	/* Set number of bytes needed for wake */
+	nvt_cir_wake_reg_write(nvt, count ? count :
+			       CIR_WAKE_FIFO_CMP_BYTES,
+			       CIR_WAKE_FIFO_CMP_DEEP);
+
+	spin_unlock(&nvt->lock);
+
+	return 0;
+}
+
+static int nvt_ir_raw_set_wakeup_filter(struct rc_dev *dev,
+					struct rc_scancode_filter *sc_filter)
+{
+	u8 *reg_buf;
+	u8 buf_val;
+	int i, ret, count;
+	unsigned int val;
+	struct ir_raw_event *raw;
+	bool complete;
+
+	/* Require both mask and protocol to be set */
+	if (!sc_filter->mask || dev->wakeup_protocol != RC_TYPE_UNKNOWN)
+		return 0;
+
+	raw = kmalloc_array(WAKE_FIFO_LEN, sizeof(*raw), GFP_KERNEL);
+	if (!raw)
+		return -ENOMEM;
+
+	ret = ir_raw_encode_scancode(dev->wakeup_protocol, sc_filter,
+				     raw, WAKE_FIFO_LEN);
+	complete = (ret != -ENOBUFS);
+	if (!complete)
+		ret = WAKE_FIFO_LEN;
+	else if (ret < 0)
+		goto out_raw;
+
+	reg_buf = kmalloc_array(WAKE_FIFO_LEN, sizeof(*reg_buf), GFP_KERNEL);
+	if (!reg_buf) {
+		ret = -ENOMEM;
+		goto out_raw;
+	}
+
+	/* Inspect the ir samples */
+	for (i = 0, count = 0; i < ret && count < WAKE_FIFO_LEN; ++i) {
+		val = NS_TO_US((raw[i]).duration) / SAMPLE_PERIOD;
+
+		/* Split too large values into several smaller ones */
+		while (val > 0 && count < WAKE_FIFO_LEN) {
+
+			/* Skip last value for better comparison tolerance */
+			if (complete && i == ret - 1 && val < BUF_LEN_MASK)
+				break;
+
+			/* Clamp values to BUF_LEN_MASK at most */
+			buf_val = (val > BUF_LEN_MASK) ? BUF_LEN_MASK : val;
+
+			reg_buf[count] = buf_val;
+			val -= buf_val;
+			if ((raw[i]).pulse)
+				reg_buf[count] |= BUF_PULSE_BIT;
+			count++;
+		}
+	}
+
+	ret = nvt_write_wakeup_codes(dev, reg_buf, count);
+
+	kfree(reg_buf);
+out_raw:
+	kfree(raw);
+
+	return ret;
+}
+
+/* Dummy implementation. nuvoton is agnostic to the protocol used */
+static int nvt_ir_raw_change_wakeup_protocol(struct rc_dev *dev,
+					     enum rc_type protocol)
+{
+	return 0;
+}
+
 /*
  * nvt_tx_ir
  *
@@ -1062,11 +1185,14 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
+	rdev->encode_wakeup = true;
 	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
+	rdev->s_wakeup_filter = nvt_ir_raw_set_wakeup_filter;
+	rdev->change_wakeup_protocol = nvt_ir_raw_change_wakeup_protocol;
 	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
 	rdev->input_phys = "nuvoton/cir0";
 	rdev->input_id.bustype = BUS_HOST;
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index c41c576..de2384a 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -60,6 +60,7 @@ static int debug;
  */
 #define TX_BUF_LEN 256
 #define RX_BUF_LEN 32
+#define WAKE_FIFO_LEN 67
 
 #define SIO_ID_MASK 0xfff0
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index acfdaf5..0ebf166 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -303,6 +303,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 #define US_TO_NS(usec)		((usec) * 1000)
 #define MS_TO_US(msec)		((msec) * 1000)
 #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
+#define NS_TO_US(nsec)		DIV_ROUND_UP(nsec, 1000L)
 
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-- 
2.9.3

