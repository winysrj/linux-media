Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:47665 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753243AbeCFRtx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 12:49:53 -0500
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>, linux-media@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH] media: rc: meson-ir: add timeout on idle
Date: Tue,  6 Mar 2018 18:41:22 +0100
Message-Id: <20180306174122.6017-1-hias@horus.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Meson doesn't seem to be able to generate timeout events
in hardware. So install a software timer to generate the
timeout events required by the decoders to prevent
"ghost keypresses".

Signed-off-by: Matthias Reichl <hias@horus.com>
---
 drivers/media/rc/meson-ir.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index f2204eb77e2a..f34c5836412b 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -69,6 +69,7 @@ struct meson_ir {
 	void __iomem	*reg;
 	struct rc_dev	*rc;
 	spinlock_t	lock;
+	struct timer_list timeout_timer;
 };
 
 static void meson_ir_set_mask(struct meson_ir *ir, unsigned int reg,
@@ -98,6 +99,10 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
 	rawir.pulse = !!(status & STATUS_IR_DEC_IN);
 
 	ir_raw_event_store(ir->rc, &rawir);
+
+	mod_timer(&ir->timeout_timer,
+		jiffies + nsecs_to_jiffies(ir->rc->timeout));
+
 	ir_raw_event_handle(ir->rc);
 
 	spin_unlock(&ir->lock);
@@ -105,6 +110,17 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void meson_ir_timeout_timer(struct timer_list *t)
+{
+	struct meson_ir *ir = from_timer(ir, t, timeout_timer);
+	DEFINE_IR_RAW_EVENT(rawir);
+
+	rawir.timeout = true;
+	rawir.duration = ir->rc->timeout;
+	ir_raw_event_store(ir->rc, &rawir);
+	ir_raw_event_handle(ir->rc);
+}
+
 static int meson_ir_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -145,7 +161,9 @@ static int meson_ir_probe(struct platform_device *pdev)
 	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
 	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
+	ir->rc->min_timeout = 1;
 	ir->rc->timeout = MS_TO_NS(200);
+	ir->rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	ir->rc->driver_name = DRIVER_NAME;
 
 	spin_lock_init(&ir->lock);
@@ -157,6 +175,8 @@ static int meson_ir_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	timer_setup(&ir->timeout_timer, meson_ir_timeout_timer, 0);
+
 	ret = devm_request_irq(dev, irq, meson_ir_irq, 0, NULL, ir);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
@@ -198,6 +218,8 @@ static int meson_ir_remove(struct platform_device *pdev)
 	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_ENABLE, 0);
 	spin_unlock_irqrestore(&ir->lock, flags);
 
+	del_timer_sync(&ir->timeout_timer);
+
 	return 0;
 }
 
-- 
2.11.0
