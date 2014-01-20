Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:56033 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaATTkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 14:40:14 -0500
Received: by mail-la0-f41.google.com with SMTP id mc6so5997238lab.28
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 11:40:13 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFC PATCH 4/4] nuvoton-cir: Add support for reading/writing wakeup scancodes via sysfs
Date: Mon, 20 Jan 2014 21:39:47 +0200
Message-Id: <1390246787-15616-5-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
References: <20140115173559.7e53239a@samsung.com>
 <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for reading/writing wakeup scancodes via sysfs
to nuvoton-cir hardware.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 81 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h |  2 ++
 2 files changed, 83 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 21ee0dc..c1b0cf2 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -531,6 +531,86 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
+static int nvt_wakeup_scancodes(struct rc_dev *dev,
+				struct list_head *scancode_list, int write)
+{
+	int i = 0;
+	u8 cnt, reg, reg_learn_mode;
+	unsigned long flags;
+	struct rc_wakeup_scancode *scancode;
+	struct nvt_dev *nvt = dev->priv;
+
+	if (write) {
+		nvt_dbg_wake("%s firing, write", __func__);
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
+		/* Write wake samples to fifo */
+		list_for_each_entry_reverse(scancode, scancode_list,
+					    list_item) {
+			/* Prevent writing too many codes */
+			if (++i > WAKE_FIFO_LEN)
+				break;
+			nvt_cir_wake_reg_write(nvt, scancode->value,
+					       CIR_WAKE_WR_FIFO_DATA);
+		}
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
+		if (i > WAKE_FIFO_LEN)
+			return -EINVAL;
+	} else {
+		nvt_dbg_wake("%s firing, read", __func__);
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
+			scancode = kmalloc(sizeof(struct rc_wakeup_scancode),
+					   GFP_KERNEL | GFP_ATOMIC);
+			if (!scancode)
+				return -ENOMEM;
+			scancode->value =
+				nvt_cir_wake_reg_read(nvt,
+						      CIR_WAKE_RD_FIFO_ONLY);
+			list_add(&scancode->list_item, scancode_list);
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
@@ -1047,6 +1127,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
+	rdev->s_wakeup_scancodes = nvt_wakeup_scancodes;
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

