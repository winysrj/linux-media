Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35204 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753771AbdDLTfO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 15:35:14 -0400
Received: by mail-wm0-f66.google.com with SMTP id d79so8569544wmi.2
        for <linux-media@vger.kernel.org>; Wed, 12 Apr 2017 12:35:13 -0700 (PDT)
Subject: [PATCH v2 3/5] media: rc: meson-ir: switch to managed rc device
 allocation / registration
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org
References: <d5c18dbb-e86a-6b1c-1410-d6cc92dce711@gmail.com>
Message-ID: <6e38bc01-e865-0a26-649e-950021e0eef7@gmail.com>
Date: Wed, 12 Apr 2017 21:32:35 +0200
MIME-Version: 1.0
In-Reply-To: <d5c18dbb-e86a-6b1c-1410-d6cc92dce711@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to the managed versions of rc_allocate_device/rc_register_device,
thus simplifying the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
---
v2:
- added R-b
---
 drivers/media/rc/meson-ir.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 3864ebe3..cf8943d2 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -128,7 +128,7 @@ static int meson_ir_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	ir->rc = rc_allocate_device(RC_DRIVER_IR_RAW);
+	ir->rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
 	if (!ir->rc) {
 		dev_err(dev, "failed to allocate rc device\n");
 		return -ENOMEM;
@@ -140,7 +140,6 @@ static int meson_ir_probe(struct platform_device *pdev)
 	ir->rc->input_id.bustype = BUS_HOST;
 	map_name = of_get_property(node, "linux,rc-map-name", NULL);
 	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
-	ir->rc->dev.parent = dev;
 	ir->rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
 	ir->rc->timeout = MS_TO_NS(200);
@@ -149,16 +148,16 @@ static int meson_ir_probe(struct platform_device *pdev)
 	spin_lock_init(&ir->lock);
 	platform_set_drvdata(pdev, ir);
 
-	ret = rc_register_device(ir->rc);
+	ret = devm_rc_register_device(dev, ir->rc);
 	if (ret) {
 		dev_err(dev, "failed to register rc device\n");
-		goto out_free;
+		return ret;
 	}
 
 	ret = devm_request_irq(dev, irq, meson_ir_irq, 0, "ir-meson", ir);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
-		goto out_unreg;
+		return ret;
 	}
 
 	/* Reset the decoder */
@@ -184,13 +183,6 @@ static int meson_ir_probe(struct platform_device *pdev)
 	dev_info(dev, "receiver initialized\n");
 
 	return 0;
-out_unreg:
-	rc_unregister_device(ir->rc);
-	ir->rc = NULL;
-out_free:
-	rc_free_device(ir->rc);
-
-	return ret;
 }
 
 static int meson_ir_remove(struct platform_device *pdev)
@@ -203,8 +195,6 @@ static int meson_ir_remove(struct platform_device *pdev)
 	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_ENABLE, 0);
 	spin_unlock_irqrestore(&ir->lock, flags);
 
-	rc_unregister_device(ir->rc);
-
 	return 0;
 }
 
-- 
2.12.2
