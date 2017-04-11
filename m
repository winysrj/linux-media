Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34126 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752761AbdDKGHf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 02:07:35 -0400
Received: by mail-wm0-f65.google.com with SMTP id x75so13009455wma.1
        for <linux-media@vger.kernel.org>; Mon, 10 Apr 2017 23:07:34 -0700 (PDT)
Subject: [PATCH 2/5] media: rc: meson-ir: make use of the bitfield macros
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, Kevin Hilman <khilman@baylibre.com>
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org
References: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
Message-ID: <ae27a582-5822-8cb6-30d6-0badaae6f014@gmail.com>
Date: Tue, 11 Apr 2017 08:00:07 +0200
MIME-Version: 1.0
In-Reply-To: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of the bitfield macros thus partially hiding the complexity
of dealing with bitfields.

The patch also includes a minor fix to REG0_RATE_MASK, so far it was
set to bit 0..10, but according to the spec it's bit 0..11.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/meson-ir.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index a4128d7c..a52036c5 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -19,6 +19,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
+#include <linux/bitfield.h>
 
 #include <media/rc-core.h>
 
@@ -36,27 +37,24 @@
 /* only available on Meson 8b and newer */
 #define IR_DEC_REG2		0x20
 
-#define REG0_RATE_MASK		(BIT(11) - 1)
+#define REG0_RATE_MASK		GENMASK(11, 0)
 
 #define DECODE_MODE_NEC		0x0
 #define DECODE_MODE_RAW		0x2
 
 /* Meson 6b uses REG1 to configure the mode */
 #define REG1_MODE_MASK		GENMASK(8, 7)
-#define REG1_MODE_SHIFT		7
 
 /* Meson 8b / GXBB use REG2 to configure the mode */
 #define REG2_MODE_MASK		GENMASK(3, 0)
-#define REG2_MODE_SHIFT		0
 
-#define REG1_TIME_IV_SHIFT	16
-#define REG1_TIME_IV_MASK	((BIT(13) - 1) << REG1_TIME_IV_SHIFT)
+#define REG1_TIME_IV_MASK	GENMASK(28, 16)
 
-#define REG1_IRQSEL_MASK	(BIT(2) | BIT(3))
-#define REG1_IRQSEL_NEC_MODE	(0 << 2)
-#define REG1_IRQSEL_RISE_FALL	(1 << 2)
-#define REG1_IRQSEL_FALL	(2 << 2)
-#define REG1_IRQSEL_RISE	(3 << 2)
+#define REG1_IRQSEL_MASK	GENMASK(3, 2)
+#define REG1_IRQSEL_NEC_MODE	0
+#define REG1_IRQSEL_RISE_FALL	1
+#define REG1_IRQSEL_FALL	2
+#define REG1_IRQSEL_RISE	3
 
 #define REG1_RESET		BIT(0)
 #define REG1_ENABLE		BIT(15)
@@ -78,7 +76,7 @@ static void meson_ir_set_mask(struct meson_ir *ir, unsigned int reg,
 
 	data = readl(ir->reg + reg);
 	data &= ~mask;
-	data |= (value & mask);
+	data |= value;
 	writel(data, ir->reg + reg);
 }
 
@@ -91,7 +89,7 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
 	spin_lock(&ir->lock);
 
 	duration = readl(ir->reg + IR_DEC_REG1);
-	duration = (duration & REG1_TIME_IV_MASK) >> REG1_TIME_IV_SHIFT;
+	duration = FIELD_GET(REG1_TIME_IV_MASK, duration);
 	rawir.duration = US_TO_NS(duration * MESON_TRATE);
 
 	rawir.pulse = !!(readl(ir->reg + IR_DEC_STATUS) & STATUS_IR_DEC_IN);
@@ -170,16 +168,16 @@ static int meson_ir_probe(struct platform_device *pdev)
 	/* Set general operation mode (= raw/software decoding) */
 	if (of_device_is_compatible(node, "amlogic,meson6-ir"))
 		meson_ir_set_mask(ir, IR_DEC_REG1, REG1_MODE_MASK,
-				  DECODE_MODE_RAW << REG1_MODE_SHIFT);
+				  FIELD_PREP(REG1_MODE_MASK, DECODE_MODE_RAW));
 	else
 		meson_ir_set_mask(ir, IR_DEC_REG2, REG2_MODE_MASK,
-				  DECODE_MODE_RAW << REG2_MODE_SHIFT);
+				  FIELD_PREP(REG2_MODE_MASK, DECODE_MODE_RAW));
 
 	/* Set rate */
 	meson_ir_set_mask(ir, IR_DEC_REG0, REG0_RATE_MASK, MESON_TRATE - 1);
 	/* IRQ on rising and falling edges */
 	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_IRQSEL_MASK,
-			  REG1_IRQSEL_RISE_FALL);
+			  FIELD_PREP(REG1_IRQSEL_MASK, REG1_IRQSEL_RISE_FALL));
 	/* Enable the decoder */
 	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_ENABLE, REG1_ENABLE);
 
-- 
2.12.2
