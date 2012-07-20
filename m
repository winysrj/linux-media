Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35000 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab2GTOL7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 10:11:59 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id q6KEBvSb025981
	for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 09:11:58 -0500
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] davinci: vpss: enable vpss clocks
Date: Fri, 20 Jul 2012 19:41:37 +0530
Message-ID: <1342793497-27793-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.lad@ti.com>

By default the VPSS clocks are only enabled in capture driver.
and display wont work if the capture is not enabled. This
patch adds support to enable the VPSS clocks in VPSS driver.
This way we can enable/disable capture and display and use it
independently.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpss.c |   38 ++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
index 3e5cf27..30283bb 100644
--- a/drivers/media/video/davinci/vpss.c
+++ b/drivers/media/video/davinci/vpss.c
@@ -25,6 +25,9 @@
 #include <linux/spinlock.h>
 #include <linux/compiler.h>
 #include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+
 #include <mach/hardware.h>
 #include <media/davinci/vpss.h>
 
@@ -104,6 +107,10 @@ struct vpss_oper_config {
 	enum vpss_platform_type platform;
 	spinlock_t vpss_lock;
 	struct vpss_hw_ops hw_ops;
+	/* Master clock */
+	struct clk *mclk;
+	/* slave clock */
+	struct clk *sclk;
 };
 
 static struct vpss_oper_config oper_cfg;
@@ -381,6 +388,29 @@ static int __init vpss_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	/* Get and enable Master clock */
+	oper_cfg.mclk = clk_get(&pdev->dev, "master");
+	if (IS_ERR(oper_cfg.mclk)) {
+		status = PTR_ERR(oper_cfg.mclk);
+		goto fail_getclk;
+	}
+	if (clk_enable(oper_cfg.mclk)) {
+		status = -ENODEV;
+		goto fail_mclk;
+	}
+	if (oper_cfg.platform == DM355 || oper_cfg.platform == DM644X) {
+		/* Get and enable Slave clock */
+		oper_cfg.sclk = clk_get(&pdev->dev, "slave");
+		if (IS_ERR(oper_cfg.sclk)) {
+			status = PTR_ERR(oper_cfg.sclk);
+			goto fail_mclk;
+		}
+		if (clk_enable(oper_cfg.sclk)) {
+			status = -ENODEV;
+			goto fail_sclk;
+		}
+	}
+
 	dev_info(&pdev->dev, "%s vpss probed\n", platform_name);
 	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r1)
@@ -442,6 +472,11 @@ fail2:
 	iounmap(oper_cfg.vpss_regs_base0);
 fail1:
 	release_mem_region(r1->start, resource_size(r1));
+fail_sclk:
+	clk_put(oper_cfg.sclk);
+fail_mclk:
+	clk_put(oper_cfg.mclk);
+fail_getclk:
 	return status;
 }
 
@@ -452,6 +487,9 @@ static int __devexit vpss_remove(struct platform_device *pdev)
 	iounmap(oper_cfg.vpss_regs_base0);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
+	clk_put(oper_cfg.mclk);
+	if (oper_cfg.platform == DM355 || oper_cfg.platform == DM644X)
+		clk_put(oper_cfg.sclk);
 	if (oper_cfg.platform == DM355 || oper_cfg.platform == DM365) {
 		iounmap(oper_cfg.vpss_regs_base1);
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-- 
1.7.0.4

