Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35028 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752267AbdDKGHd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 02:07:33 -0400
Received: by mail-wr0-f193.google.com with SMTP id l44so4279663wrc.2
        for <linux-media@vger.kernel.org>; Mon, 10 Apr 2017 23:07:33 -0700 (PDT)
Subject: [PATCH 1/5] media: rc: meson-ir: remove irq from struct meson_ir
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, Kevin Hilman <khilman@baylibre.com>
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org
References: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
Message-ID: <b550b154-400e-2aea-b863-c217bcb730ad@gmail.com>
Date: Tue, 11 Apr 2017 07:53:42 +0200
MIME-Version: 1.0
In-Reply-To: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The irq number is used in the probe function only, therefore just use
a local variable.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/meson-ir.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 5576dbd6..a4128d7c 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -68,7 +68,6 @@
 struct meson_ir {
 	void __iomem	*reg;
 	struct rc_dev	*rc;
-	int		irq;
 	spinlock_t	lock;
 };
 
@@ -112,7 +111,7 @@ static int meson_ir_probe(struct platform_device *pdev)
 	struct resource *res;
 	const char *map_name;
 	struct meson_ir *ir;
-	int ret;
+	int irq, ret;
 
 	ir = devm_kzalloc(dev, sizeof(struct meson_ir), GFP_KERNEL);
 	if (!ir)
@@ -125,10 +124,10 @@ static int meson_ir_probe(struct platform_device *pdev)
 		return PTR_ERR(ir->reg);
 	}
 
-	ir->irq = platform_get_irq(pdev, 0);
-	if (ir->irq < 0) {
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
 		dev_err(dev, "no irq resource\n");
-		return ir->irq;
+		return irq;
 	}
 
 	ir->rc = rc_allocate_device(RC_DRIVER_IR_RAW);
@@ -158,7 +157,7 @@ static int meson_ir_probe(struct platform_device *pdev)
 		goto out_free;
 	}
 
-	ret = devm_request_irq(dev, ir->irq, meson_ir_irq, 0, "ir-meson", ir);
+	ret = devm_request_irq(dev, irq, meson_ir_irq, 0, "ir-meson", ir);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
 		goto out_unreg;
-- 
2.12.2
