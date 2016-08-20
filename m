Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35996 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752963AbcHTJzf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 05:55:35 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, linus.walleij@linaro.org,
        khilman@baylibre.com, carlo@caione.org
Cc: linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com,
        robh+dt@kernel.org, b.galvani@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 4/6] media: rc: meson-ir: Add support for newer versions of the IR decoder
Date: Sat, 20 Aug 2016 11:54:22 +0200
Message-Id: <20160820095424.636-5-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160820095424.636-1-martin.blumenstingl@googlemail.com>
References: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
 <20160820095424.636-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Neil Armstrong <narmstrong@baylibre.com>

Newer SoCs (Meson 8b and GXBB) are using REG2 (offset 0x20) instead of
REG1 to configure the decoder mode. This makes it necessary to
introduce new bindings so the driver knows which register has to be
used.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Kevin Hilman <khilman@baylibre.com>
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
2.9.3

