Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48381 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbaAQOAN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:13 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 08/15] media: rc: img-ir: add raw driver
Date: Fri, 17 Jan 2014 13:58:53 +0000
Message-ID: <1389967140-20704-9-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add raw IR remote control input driver for the ImgTec Infrared decoder
block's raw edge interrupts. Generic software protocol decoders are used
to allow multiple protocols to be supported at a time, including those
not supported by the hardware decoder.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
v2:
- Echo the last sample after 150ms if no edges have been detected. This
  allows the soft decoder state machines to recognise the final space
  when no repeat code is received.
- Use spin_lock_irq() instead of spin_lock_irqsave() in various bits of
  code that aren't accessible from hard interrupt context.
- Avoid removal race by checking for RC device in ISR.
---
 drivers/media/rc/img-ir/img-ir-raw.c | 151 +++++++++++++++++++++++++++++++++++
 drivers/media/rc/img-ir/img-ir-raw.h |  60 ++++++++++++++
 2 files changed, 211 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-raw.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-raw.h

diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
new file mode 100644
index 0000000..cfb01d9
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-raw.c
@@ -0,0 +1,151 @@
+/*
+ * ImgTec IR Raw Decoder found in PowerDown Controller.
+ *
+ * Copyright 2010-2014 Imagination Technologies Ltd.
+ *
+ * This ties into the input subsystem using the RC-core in raw mode. Raw IR
+ * signal edges are reported and decoded by generic software decoders.
+ */
+
+#include <linux/spinlock.h>
+#include <media/rc-core.h>
+#include "img-ir.h"
+
+#define ECHO_TIMEOUT_MS 150	/* ms between echos */
+
+/* must be called with priv->lock held */
+static void img_ir_refresh_raw(struct img_ir_priv *priv, u32 irq_status)
+{
+	struct img_ir_priv_raw *raw = &priv->raw;
+	struct rc_dev *rc_dev = priv->raw.rdev;
+	int multiple;
+	u32 ir_status;
+
+	/* find whether both rise and fall was detected */
+	multiple = ((irq_status & IMG_IR_IRQ_EDGE) == IMG_IR_IRQ_EDGE);
+	/*
+	 * If so, we need to see if the level has actually changed.
+	 * If it's just noise that we didn't have time to process,
+	 * there's no point reporting it.
+	 */
+	ir_status = img_ir_read(priv, IMG_IR_STATUS) & IMG_IR_IRRXD;
+	if (multiple && ir_status == raw->last_status)
+		return;
+	raw->last_status = ir_status;
+
+	/* report the edge to the IR raw decoders */
+	if (ir_status) /* low */
+		ir_raw_event_store_edge(rc_dev, IR_SPACE);
+	else /* high */
+		ir_raw_event_store_edge(rc_dev, IR_PULSE);
+	ir_raw_event_handle(rc_dev);
+}
+
+/* called with priv->lock held */
+void img_ir_isr_raw(struct img_ir_priv *priv, u32 irq_status)
+{
+	struct img_ir_priv_raw *raw = &priv->raw;
+
+	/* check not removing */
+	if (!raw->rdev)
+		return;
+
+	img_ir_refresh_raw(priv, irq_status);
+
+	/* start / push back the echo timer */
+	mod_timer(&raw->timer, jiffies + msecs_to_jiffies(ECHO_TIMEOUT_MS));
+}
+
+/*
+ * Echo timer callback function.
+ * The raw decoders expect to get a final sample even if there are no edges, in
+ * order to be assured of the final space. If there are no edges for a certain
+ * time we use this timer to emit a final sample to satisfy them.
+ */
+static void img_ir_echo_timer(unsigned long arg)
+{
+	struct img_ir_priv *priv = (struct img_ir_priv *)arg;
+
+	spin_lock_irq(&priv->lock);
+
+	/* check not removing */
+	if (priv->raw.rdev)
+		/*
+		 * It's safe to pass irq_status=0 since it's only used to check
+		 * for double edges.
+		 */
+		img_ir_refresh_raw(priv, 0);
+
+	spin_unlock_irq(&priv->lock);
+}
+
+void img_ir_setup_raw(struct img_ir_priv *priv)
+{
+	u32 irq_en;
+
+	if (!priv->raw.rdev)
+		return;
+
+	/* clear and enable edge interrupts */
+	spin_lock_irq(&priv->lock);
+	irq_en = img_ir_read(priv, IMG_IR_IRQ_ENABLE);
+	irq_en |= IMG_IR_IRQ_EDGE;
+	img_ir_write(priv, IMG_IR_IRQ_CLEAR, IMG_IR_IRQ_EDGE);
+	img_ir_write(priv, IMG_IR_IRQ_ENABLE, irq_en);
+	spin_unlock_irq(&priv->lock);
+}
+
+int img_ir_probe_raw(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_raw *raw = &priv->raw;
+	struct rc_dev *rdev;
+	int error;
+
+	/* Set up the echo timer */
+	setup_timer(&raw->timer, img_ir_echo_timer, (unsigned long)priv);
+
+	/* Allocate raw decoder */
+	raw->rdev = rdev = rc_allocate_device();
+	if (!rdev) {
+		dev_err(priv->dev, "cannot allocate raw input device\n");
+		return -ENOMEM;
+	}
+	rdev->priv = priv;
+	rdev->map_name = RC_MAP_EMPTY;
+	rdev->input_name = "IMG Infrared Decoder Raw";
+	rdev->driver_type = RC_DRIVER_IR_RAW;
+
+	/* Register raw decoder */
+	error = rc_register_device(rdev);
+	if (error) {
+		dev_err(priv->dev, "failed to register raw IR input device\n");
+		rc_free_device(rdev);
+		raw->rdev = NULL;
+		return error;
+	}
+
+	return 0;
+}
+
+void img_ir_remove_raw(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_raw *raw = &priv->raw;
+	struct rc_dev *rdev = raw->rdev;
+	u32 irq_en;
+
+	if (!rdev)
+		return;
+
+	/* switch off and disable raw (edge) interrupts */
+	spin_lock_irq(&priv->lock);
+	raw->rdev = NULL;
+	irq_en = img_ir_read(priv, IMG_IR_IRQ_ENABLE);
+	irq_en &= ~IMG_IR_IRQ_EDGE;
+	img_ir_write(priv, IMG_IR_IRQ_ENABLE, irq_en);
+	img_ir_write(priv, IMG_IR_IRQ_CLEAR, IMG_IR_IRQ_EDGE);
+	spin_unlock_irq(&priv->lock);
+
+	rc_unregister_device(rdev);
+
+	del_timer_sync(&raw->timer);
+}
diff --git a/drivers/media/rc/img-ir/img-ir-raw.h b/drivers/media/rc/img-ir/img-ir-raw.h
new file mode 100644
index 0000000..9802ffd
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-raw.h
@@ -0,0 +1,60 @@
+/*
+ * ImgTec IR Raw Decoder found in PowerDown Controller.
+ *
+ * Copyright 2010-2014 Imagination Technologies Ltd.
+ */
+
+#ifndef _IMG_IR_RAW_H_
+#define _IMG_IR_RAW_H_
+
+struct img_ir_priv;
+
+#ifdef CONFIG_IR_IMG_RAW
+
+/**
+ * struct img_ir_priv_raw - Private driver data for raw decoder.
+ * @rdev:		Raw remote control device
+ * @timer:		Timer to echo samples to keep soft decoders happy.
+ * @last_status:	Last raw status bits.
+ */
+struct img_ir_priv_raw {
+	struct rc_dev		*rdev;
+	struct timer_list	timer;
+	u32			last_status;
+};
+
+static inline bool img_ir_raw_enabled(struct img_ir_priv_raw *raw)
+{
+	return raw->rdev;
+};
+
+void img_ir_isr_raw(struct img_ir_priv *priv, u32 irq_status);
+void img_ir_setup_raw(struct img_ir_priv *priv);
+int img_ir_probe_raw(struct img_ir_priv *priv);
+void img_ir_remove_raw(struct img_ir_priv *priv);
+
+#else
+
+struct img_ir_priv_raw {
+};
+static inline bool img_ir_raw_enabled(struct img_ir_priv_raw *raw)
+{
+	return false;
+};
+static inline void img_ir_isr_raw(struct img_ir_priv *priv, u32 irq_status)
+{
+}
+static inline void img_ir_setup_raw(struct img_ir_priv *priv)
+{
+}
+static inline int img_ir_probe_raw(struct img_ir_priv *priv)
+{
+	return -ENODEV;
+}
+static inline void img_ir_remove_raw(struct img_ir_priv *priv)
+{
+}
+
+#endif /* CONFIG_IR_IMG_RAW */
+
+#endif /* _IMG_IR_RAW_H_ */
-- 
1.8.3.2


