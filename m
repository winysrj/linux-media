Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36825 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176039AbdDYHlP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 03:41:15 -0400
Received: by mail-wm0-f52.google.com with SMTP id u65so15035488wmu.1
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 00:41:14 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: khilman@baylibre.com, carlo@caione.org, mchehab@kernel.org
Cc: Alex Deryskyba <alex@codesnake.com>,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH] media: rc: meson-ir: switch config to NEC decoding on shutdown
Date: Tue, 25 Apr 2017 09:41:09 +0200
Message-Id: <1493106069-19922-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alex Deryskyba <alex@codesnake.com>

On the Amlogic SoCs, the bootloader firmware can handle the IR hardware in
order to Wake up or Power back the system when in suspend on shutdown mode.

This patch switches the hardware configuration in a state usable by the
firmware to permit powering the system back.

Some vendor bootloader firmware were modified to switch to this configuration
but it may not be the case for all available products.

This patch was originally posted at [1].

[1] https://github.com/LibreELEC/linux-amlogic/pull/27

Signed-off-by: Alex Deryskyba <alex@codesnake.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/media/rc/meson-ir.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 42ae2ec..0632f6a 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -211,6 +211,32 @@ static int meson_ir_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void meson_ir_shutdown(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct meson_ir *ir = platform_get_drvdata(pdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ir->lock, flags);
+
+	/*
+	 * Set operation mode to NEC/hardware decoding to give
+	 * bootloader a chance to power the system back on
+	 */
+	if (of_device_is_compatible(node, "amlogic,meson6-ir"))
+		meson_ir_set_mask(ir, IR_DEC_REG1, REG1_MODE_MASK,
+				DECODE_MODE_NEC << REG1_MODE_SHIFT);
+	else
+		meson_ir_set_mask(ir, IR_DEC_REG2, REG2_MODE_MASK,
+				DECODE_MODE_NEC << REG2_MODE_SHIFT);
+
+	/* Set rate to default value */
+	meson_ir_set_mask(ir, IR_DEC_REG0, REG0_RATE_MASK, 0x13);
+
+	spin_unlock_irqrestore(&ir->lock, flags);
+}
+
 static const struct of_device_id meson_ir_match[] = {
 	{ .compatible = "amlogic,meson6-ir" },
 	{ .compatible = "amlogic,meson8b-ir" },
@@ -222,6 +248,7 @@ static int meson_ir_remove(struct platform_device *pdev)
 static struct platform_driver meson_ir_driver = {
 	.probe		= meson_ir_probe,
 	.remove		= meson_ir_remove,
+	.shutdown	= meson_ir_shutdown,
 	.driver = {
 		.name		= DRIVER_NAME,
 		.of_match_table	= meson_ir_match,
-- 
1.9.1
