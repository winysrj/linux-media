Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35342 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbcF1TTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 15:19:16 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, carlo@caione.org,
	khilman@baylibre.com, mchehab@kernel.org,
	devicetree@vger.kernel.org, narmstrong@baylibre.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 2/4] media: rc: meson-ir: Add support for newer versions of the IR decoder
Date: Tue, 28 Jun 2016 21:18:00 +0200
Message-Id: <20160628191802.21227-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
 <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Neil Armstrong <narmstrong@baylibre.com>

Newer SoCs (Meson 8b and GXBB) are using REG2 (offset 0x20) instead of
REG1 to configure the decoder mode. This makes it necessary to
introduce new bindings so the driver knows which register has to be
used.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/rc/meson-ir.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index fcc3b82..003fff0 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -24,6 +24,7 @@
 
 #define DRIVER_NAME		"meson-ir"
 
+/* valid on all Meson platforms */
 #define IR_DEC_LDR_ACTIVE	0x00
 #define IR_DEC_LDR_IDLE		0x04
 #define IR_DEC_LDR_REPEAT	0x08
@@ -32,12 +33,21 @@
 #define IR_DEC_FRAME		0x14
 #define IR_DEC_STATUS		0x18
 #define IR_DEC_REG1		0x1c
+/* only available on Meson 8b and newer */
+#define IR_DEC_REG2		0x20
 
 #define REG0_RATE_MASK		(BIT(11) - 1)
 
-#define REG1_MODE_MASK		(BIT(7) | BIT(8))
-#define REG1_MODE_NEC		(0 << 7)
-#define REG1_MODE_GENERAL	(2 << 7)
+#define DECODE_MODE_NEC		0x0
+#define DECODE_MODE_RAW		0x2
+
+/* Meson 6b uses REG1 to configure the mode */
+#define REG1_MODE_MASK		GENMASK(8, 7)
+#define REG1_MODE_SHIFT		7
+
+/* Meson 8b / GXBB use REG2 to configure the mode */
+#define REG2_MODE_MASK		GENMASK(3, 0)
+#define REG2_MODE_SHIFT		0
 
 #define REG1_TIME_IV_SHIFT	16
 #define REG1_TIME_IV_MASK	((BIT(13) - 1) << REG1_TIME_IV_SHIFT)
@@ -158,8 +168,15 @@ static int meson_ir_probe(struct platform_device *pdev)
 	/* Reset the decoder */
 	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_RESET, REG1_RESET);
 	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_RESET, 0);
-	/* Set general operation mode */
-	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_MODE_MASK, REG1_MODE_GENERAL);
+
+	/* Set general operation mode (= raw/software decoding) */
+	if (of_device_is_compatible(node, "amlogic,meson6-ir"))
+		meson_ir_set_mask(ir, IR_DEC_REG1, REG1_MODE_MASK,
+				  DECODE_MODE_RAW << REG1_MODE_SHIFT);
+	else
+		meson_ir_set_mask(ir, IR_DEC_REG2, REG2_MODE_MASK,
+				  DECODE_MODE_RAW << REG2_MODE_SHIFT);
+
 	/* Set rate */
 	meson_ir_set_mask(ir, IR_DEC_REG0, REG0_RATE_MASK, MESON_TRATE - 1);
 	/* IRQ on rising and falling edges */
@@ -197,6 +214,8 @@ static int meson_ir_remove(struct platform_device *pdev)
 
 static const struct of_device_id meson_ir_match[] = {
 	{ .compatible = "amlogic,meson6-ir" },
+	{ .compatible = "amlogic,meson8b-ir" },
+	{ .compatible = "amlogic,meson-gxbb-ir" },
 	{ },
 };
 
-- 
2.9.0

