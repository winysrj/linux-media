Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:14620 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbbBCR3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 12:29:13 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH] rc: img-ir: Add and enable sys clock for IR
Date: Tue, 3 Feb 2015 17:30:29 +0000
Message-ID: <1422984629-13313-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gets a handle to the system clock, already described in the binding
document, and calls the appropriate common clock
framework functions to mark it prepared/enabled, the common clock
framework initially enables the clock and doesn't disable it at least
until the device/driver is removed.
The system clock to IR is needed for the driver to communicate with the
IR hardware via MMIO accesses on the system bus, so it must not be
disabled during use or the driver will malfunction.

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
---
 drivers/media/rc/img-ir/img-ir-core.c |   13 +++++++++----
 drivers/media/rc/img-ir/img-ir.h      |    2 ++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/img-ir/img-ir-core.c
index 77c78de..783dd21 100644
--- a/drivers/media/rc/img-ir/img-ir-core.c
+++ b/drivers/media/rc/img-ir/img-ir-core.c
@@ -60,6 +60,8 @@ static void img_ir_setup(struct img_ir_priv *priv)
 
 	if (!IS_ERR(priv->clk))
 		clk_prepare_enable(priv->clk);
+	if (!IS_ERR(priv->sys_clk))
+		clk_prepare_enable(priv->sys_clk);
 }
 
 static void img_ir_ident(struct img_ir_priv *priv)
@@ -110,10 +112,11 @@ static int img_ir_probe(struct platform_device *pdev)
 	priv->clk = devm_clk_get(&pdev->dev, "core");
 	if (IS_ERR(priv->clk))
 		dev_warn(&pdev->dev, "cannot get core clock resource\n");
-	/*
-	 * The driver doesn't need to know about the system ("sys") or power
-	 * modulation ("mod") clocks yet
-	 */
+
+	/* Get sys clock */
+	priv->sys_clk = devm_clk_get(&pdev->dev, "sys");
+	if (IS_ERR(priv->sys_clk))
+		dev_warn(&pdev->dev, "cannot get sys clock resource\n");
 
 	/* Set up raw & hw decoder */
 	error = img_ir_probe_raw(priv);
@@ -152,6 +155,8 @@ static int img_ir_remove(struct platform_device *pdev)
 
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
+	if (!IS_ERR(priv->sys_clk))
+		clk_disable_unprepare(priv->sys_clk);
 	return 0;
 }
 
diff --git a/drivers/media/rc/img-ir/img-ir.h b/drivers/media/rc/img-ir/img-ir.h
index 2ddf560..f1387c0 100644
--- a/drivers/media/rc/img-ir/img-ir.h
+++ b/drivers/media/rc/img-ir/img-ir.h
@@ -138,6 +138,7 @@ struct clk;
  * @dev:		Platform device.
  * @irq:		IRQ number.
  * @clk:		Input clock.
+ * @sys_clk:		System clock.
  * @reg_base:		Iomem base address of IR register block.
  * @lock:		Protects IR registers and variables in this struct.
  * @raw:		Driver data for raw decoder.
@@ -147,6 +148,7 @@ struct img_ir_priv {
 	struct device		*dev;
 	int			irq;
 	struct clk		*clk;
+	struct clk		*sys_clk;
 	void __iomem		*reg_base;
 	spinlock_t		lock;
 
-- 
1.7.9.5

