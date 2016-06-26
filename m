Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36167 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbcFZU31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2016 16:29:27 -0400
Received: by mail-wm0-f68.google.com with SMTP id c82so19577894wme.3
        for <linux-media@vger.kernel.org>; Sun, 26 Jun 2016 13:29:26 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: b.galvani@gmail.com, linux-media@vger.kernel.org,
	linux-amlogic@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
	carlo@caione.org, mchehab@kernel.org, tobetter@gmail.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] media: rc: use the correct register offset and bits to enable raw mode
Date: Sun, 26 Jun 2016 22:29:05 +0200
Message-Id: <20160626202905.21817-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160626202905.21817-1-martin.blumenstingl@googlemail.com>
References: <20160626202905.21817-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the datasheet of Meson8b (S805) and GXBB (S905) the
decoding mode is configured in AO_MF_IR_DEC_REG2 (offset 0x20) using
bits 0-3.
The "duration" field may not be set correctly when any of the hardware
decoding modes. This can happen while a "default" decoding mode
(either set by the bootloader or the chip's default, which uses NEC as
it's default) is used.
While here, I also added defines for the protocols which can be decoded
by the hardware (more work is needed to be actually able to use them
though).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/rc/meson-ir.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index fcc3b82..662d065 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -32,13 +32,10 @@
 #define IR_DEC_FRAME		0x14
 #define IR_DEC_STATUS		0x18
 #define IR_DEC_REG1		0x1c
+#define IR_DEC_REG2		0x20
 
 #define REG0_RATE_MASK		(BIT(11) - 1)
 
-#define REG1_MODE_MASK		(BIT(7) | BIT(8))
-#define REG1_MODE_NEC		(0 << 7)
-#define REG1_MODE_GENERAL	(2 << 7)
-
 #define REG1_TIME_IV_SHIFT	16
 #define REG1_TIME_IV_MASK	((BIT(13) - 1) << REG1_TIME_IV_SHIFT)
 
@@ -51,6 +48,20 @@
 #define REG1_RESET		BIT(0)
 #define REG1_ENABLE		BIT(15)
 
+#define REG2_DEC_MODE_SHIFT	0
+#define REG2_DEC_MODE_MASK	GENMASK(3, REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_NEC	(0x0 << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_RAW	(0x2 << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_THOMSON	(0x4 << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_TOSHIBA	(0x5 << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_SONY	(0x6 << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_RC5	(0x7 << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_RC6	(0x9 << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_RCMM	(0xa << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_DUOKAN	(0xb << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_COMCAST	(0xe << REG2_DEC_MODE_SHIFT)
+#define REG2_DEC_MODE_SANYO	(0xf << REG2_DEC_MODE_SHIFT)
+
 #define STATUS_IR_DEC_IN	BIT(8)
 
 #define MESON_TRATE		10	/* us */
@@ -158,8 +169,9 @@ static int meson_ir_probe(struct platform_device *pdev)
 	/* Reset the decoder */
 	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_RESET, REG1_RESET);
 	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_RESET, 0);
-	/* Set general operation mode */
-	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_MODE_MASK, REG1_MODE_GENERAL);
+	/* Enable raw/soft-decode mode */
+	meson_ir_set_mask(ir, IR_DEC_REG2, REG2_DEC_MODE_MASK,
+			  REG2_DEC_MODE_RAW << REG2_DEC_MODE_SHIFT);
 	/* Set rate */
 	meson_ir_set_mask(ir, IR_DEC_REG0, REG0_RATE_MASK, MESON_TRATE - 1);
 	/* IRQ on rising and falling edges */
-- 
2.9.0

