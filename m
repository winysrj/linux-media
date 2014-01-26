Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:59667 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaAZVvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 16:51:11 -0500
Received: by mail-la0-f45.google.com with SMTP id b8so3899039lan.4
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 13:51:09 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 4/5] nuvoton-cir: Add support for reading/writing wakeup samples via sysfs
Date: Sun, 26 Jan 2014 23:50:25 +0200
Message-Id: <1390773026-567-5-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
References: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for reading/writing wakeup samples via sysfs
to nuvoton-cir hardware.

The sysfs interface for nuvoton-cir contains raw IR pulse/space lengths.
If value is negative it is a space, otherwise it is a pulse.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 118 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h |   2 +
 2 files changed, 120 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 21ee0dc..015f3a8 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -531,6 +531,121 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
+static int nvt_validate_wakeup_codes(struct list_head *wakeup_code_list)
+{
+	int i = 0;
+	const int MAX_SAMPLE = US_TO_NS(BUF_LEN_MASK * SAMPLE_PERIOD);
+	struct rc_wakeup_code *code;
+	list_for_each_entry(code, wakeup_code_list, list_item) {
+
+		/* Prevent writing too many or invalid codes */
+		if (++i > WAKE_FIFO_LEN)
+			return -EINVAL;
+		if (abs(code->value) > MAX_SAMPLE)
+			return -EINVAL;
+	}
+
+	return i;
+}
+
+static int nvt_wakeup_codes(struct rc_dev *dev,
+				struct list_head *wakeup_code_list, int write)
+{
+	int i = 0;
+	u8 cnt, val, reg, reg_learn_mode;
+	unsigned long flags;
+	struct rc_wakeup_code *code;
+	struct nvt_dev *nvt = dev->priv;
+
+	nvt_dbg_wake("%sing wakeup codes", write ? "writ" : "read");
+
+	if (write) {
+
+		/* Validate wake codes (count and values) */
+		i = nvt_validate_wakeup_codes(wakeup_code_list);
+		if (i < 0)
+			return -EINVAL;
+
+		reg = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
+		reg_learn_mode = reg & ~CIR_WAKE_IRCON_MODE0;
+		reg_learn_mode |= CIR_WAKE_IRCON_MODE1;
+
+		/* Lock the learn area to prevent racing with wake-isr */
+		spin_lock_irqsave(&nvt->nvt_lock, flags);
+
+		/* Enable fifo writes */
+		nvt_cir_wake_reg_write(nvt, reg_learn_mode, CIR_WAKE_IRCON);
+
+		/* Clear cir wake rx fifo */
+		nvt_clear_cir_wake_fifo(nvt);
+
+		pr_info("Wake samples (%d) =", i);
+
+		/* Write wake samples to fifo */
+		list_for_each_entry(code, wakeup_code_list, list_item) {
+
+			/* Convert to driver format */
+			val = DIV_ROUND_UP(abs(code->value), 1000L)
+				/ SAMPLE_PERIOD;
+
+			if (code->value > 0)
+				val |= BUF_PULSE_BIT;
+
+			pr_cont(" %02x", val);
+			nvt_cir_wake_reg_write(nvt, val,
+					       CIR_WAKE_WR_FIFO_DATA);
+		}
+		pr_cont("\n");
+
+		/* Switch cir to wakeup mode and disable fifo writing */
+		nvt_cir_wake_reg_write(nvt, reg, CIR_WAKE_IRCON);
+
+		/* Set number of bytes needed for wake */
+		nvt_cir_wake_reg_write(nvt, i ? i :
+				       CIR_WAKE_FIFO_CMP_BYTES,
+				       CIR_WAKE_FIFO_CMP_DEEP);
+
+		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
+	} else {
+
+		/* Scroll to index 0 */
+		while (nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX)) {
+			nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY);
+
+			/* Stuck index guardian */
+			if (++i > 255) {
+				nvt_dbg_wake("Idx reg is stuck!");
+				break;
+			}
+		}
+
+		/* Get size of wake fifo and allocate memory for the bytes */
+		cnt = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT);
+
+		for (i = 0; i < cnt; i++) {
+			code = kmalloc(sizeof(struct rc_wakeup_code),
+					   GFP_KERNEL | GFP_ATOMIC);
+			if (!code)
+				return -ENOMEM;
+
+			val = nvt_cir_wake_reg_read(nvt,
+						    CIR_WAKE_RD_FIFO_ONLY);
+
+			/* Convert to human readable sample-pulse format */
+			code->value = US_TO_NS((val & BUF_LEN_MASK)
+					       * SAMPLE_PERIOD);
+			if (!(val & BUF_PULSE_BIT))
+				code->value *= -1;
+
+			list_add_tail(&code->list_item, wakeup_code_list);
+		}
+
+		return cnt;
+	}
+
+	return 0;
+}
 /*
  * nvt_tx_ir
  *
@@ -1043,10 +1158,13 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protos = RC_BIT_ALL;
+	rdev->allowed_wake_protos = RC_BIT_OTHER;
+	rdev->enabled_wake_protos = RC_BIT_OTHER;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
+	rdev->s_wakeup_codes = nvt_wakeup_codes;
 	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
 	rdev->input_phys = "nuvoton/cir0";
 	rdev->input_id.bustype = BUS_HOST;
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 07e8310..24ff630 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -64,6 +64,8 @@ static int debug;
 #define TX_BUF_LEN 256
 #define RX_BUF_LEN 32
 
+#define WAKE_FIFO_LEN 67
+
 struct nvt_dev {
 	struct pnp_dev *pdev;
 	struct rc_dev *rdev;
-- 
1.8.3.2

