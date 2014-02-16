Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52826 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaBPQqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 11:46:50 -0500
Received: by mail-la0-f46.google.com with SMTP id b8so10587433lan.33
        for <linux-media@vger.kernel.org>; Sun, 16 Feb 2014 08:46:49 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 3/3] nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback
Date: Sun, 16 Feb 2014 18:45:55 +0200
Message-Id: <1392569155-27659-4-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1392569155-27659-1-git-send-email-a.seppala@gmail.com>
References: <CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
 <1392569155-27659-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nuvoton-cir utilizes the encoding capabilities of rc-core to convert
scancodes from user space to pulse/space format understood by the
underlying hardware.

Converted samples are then written to the wakeup fifo along with other
necessary configuration to enable wake up functionality.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 119 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h |   1 +
 include/media/rc-core.h        |   1 +
 3 files changed, 121 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index b41e52e..8be81b5 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -527,6 +527,124 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
+static int nvt_write_wakeup_codes(struct rc_dev *dev,
+				  const u8 *wakeup_sample_buf, int count)
+{
+	int i = 0;
+	u8 reg, reg_learn_mode;
+	unsigned long flags;
+	struct nvt_dev *nvt = dev->priv;
+
+	nvt_dbg_wake("writing wakeup samples");
+
+	reg = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
+	reg_learn_mode = reg & ~CIR_WAKE_IRCON_MODE0;
+	reg_learn_mode |= CIR_WAKE_IRCON_MODE1;
+
+	/* Lock the learn area to prevent racing with wake-isr */
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
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
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
+	return 0;
+}
+
+static int nvt_ir_raw_set_filter(struct rc_dev *dev, enum rc_filter_type type,
+				 struct rc_scancode_filter *sc_filter)
+{
+	u8 *reg_buf;
+	u8 buf_val;
+	int i, ret, count;
+	unsigned int val;
+	const unsigned int BUF_SIZE = 127;
+	struct ir_raw_event *raw;
+
+	/* Other types are not valid for nuvoton */
+	if (type != RC_FILTER_WAKEUP)
+		return -EINVAL;
+
+	/* Require both mask and data to be set before actually committing */
+	if (!sc_filter->mask || !sc_filter->data)
+		return 0;
+
+	raw = kmalloc(BUF_SIZE * sizeof(*raw), GFP_KERNEL);
+	if (!raw)
+		return -ENOMEM;
+
+	ret = ir_raw_encode_scancode(dev->enabled_protocols, sc_filter, raw,
+				     BUF_SIZE);
+	if (ret < 0)
+		goto out_raw;
+
+	reg_buf = kmalloc(sizeof(*reg_buf) * BUF_SIZE, GFP_KERNEL);
+	if (!reg_buf) {
+		ret = -ENOMEM;
+		goto out_raw;
+	}
+
+	/* Inspect the ir samples */
+	for (i = 0, count = 0; i <= ret && count < BUF_SIZE; ++i) {
+		val = NS_TO_US((raw[i]).duration) / SAMPLE_PERIOD;
+
+		/* Split too large values into several smaller ones */
+		while (val > 0 && count < BUF_SIZE) {
+
+			/* Skip last value for better comparison tolerance */
+			if (i == ret && val < BUF_LEN_MASK)
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
 /*
  * nvt_tx_ir
  *
@@ -1043,6 +1161,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
+	rdev->s_filter = nvt_ir_raw_set_filter;
 	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
 	rdev->input_phys = "nuvoton/cir0";
 	rdev->input_id.bustype = BUS_HOST;
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index e1cf23c..9d0e161 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -63,6 +63,7 @@ static int debug;
  */
 #define TX_BUF_LEN 256
 #define RX_BUF_LEN 32
+#define WAKE_FIFO_LEN 67
 
 struct nvt_dev {
 	struct pnp_dev *pdev;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 81cddd3..6b12a1b 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -227,6 +227,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 #define US_TO_NS(usec)		((usec) * 1000)
 #define MS_TO_US(msec)		((msec) * 1000)
 #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
+#define NS_TO_US(nsec)		DIV_ROUND_UP(nsec, 1000L)
 
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-- 
1.8.3.2

