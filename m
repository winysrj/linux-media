Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:25854 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966331AbbBDQqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 11:46:53 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH v2] rc: img-ir: Add and enable sys clock for img-ir
Date: Wed, 4 Feb 2015 16:48:14 +0000
Message-ID: <1423068494-9360-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gets a handle to the system clock, already described in the binding
document, and calls the appropriate common clock framework functions
to mark it prepared/enabled, the common clock framework initially
enables the clock and doesn't disable it at least until the
device/driver is removed.
It's important the systen clock is enabled before register interface is
accessed by the driver.
The system clock to IR is needed for the driver to communicate with the
IR hardware via MMIO accesses on the system bus, so it must not be
disabled during use or the driver will malfunction.

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
---
Changes from v1:
System clock enabled in probe function before any hardware is accessed.
Error handling in probe function ensures ISR doesn't get called with 
system clock disabled.

 drivers/media/rc/img-ir/img-ir-core.c |   29 +++++++++++++++++++++++++----
 drivers/media/rc/img-ir/img-ir.h      |    2 ++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/img-ir/img-ir-core.c
index 77c78de..a10d666 100644
--- a/drivers/media/rc/img-ir/img-ir-core.c
+++ b/drivers/media/rc/img-ir/img-ir-core.c
@@ -110,16 +110,32 @@ static int img_ir_probe(struct platform_device *pdev)
 	priv->clk = devm_clk_get(&pdev->dev, "core");
 	if (IS_ERR(priv->clk))
 		dev_warn(&pdev->dev, "cannot get core clock resource\n");
+
+	/* Get sys clock */
+	priv->sys_clk = devm_clk_get(&pdev->dev, "sys");
+	if (IS_ERR(priv->sys_clk))
+		dev_warn(&pdev->dev, "cannot get sys clock resource\n");
 	/*
-	 * The driver doesn't need to know about the system ("sys") or power
-	 * modulation ("mod") clocks yet
+	 * Enabling the system clock before the register interface is
+	 * accessed. ISR shouldn't get called with Sys Clock disabled,
+	 * hence exiting probe with an error.
 	 */
+	if (!IS_ERR(priv->sys_clk)) {
+		error = clk_prepare_enable(priv->sys_clk);
+		if (error) {
+			dev_err(&pdev->dev, "cannot enable sys clock\n");
+			return error;
+		}
+	}
 
 	/* Set up raw & hw decoder */
 	error = img_ir_probe_raw(priv);
 	error2 = img_ir_probe_hw(priv);
-	if (error && error2)
-		return (error == -ENODEV) ? error2 : error;
+	if (error && error2) {
+		if (error == -ENODEV)
+			error = error2;
+		goto err_probe;
+	}
 
 	/* Get the IRQ */
 	priv->irq = irq;
@@ -139,6 +155,9 @@ static int img_ir_probe(struct platform_device *pdev)
 err_irq:
 	img_ir_remove_hw(priv);
 	img_ir_remove_raw(priv);
+err_probe:
+	if (!IS_ERR(priv->sys_clk))
+		clk_disable_unprepare(priv->sys_clk);
 	return error;
 }
 
@@ -152,6 +171,8 @@ static int img_ir_remove(struct platform_device *pdev)
 
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

