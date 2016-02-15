Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52527 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbcBOUBs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 15:01:48 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch] media: ti-vpe: cal: Fix syntax check warnings
Date: Mon, 15 Feb 2016 14:01:42 -0600
Message-ID: <1455566502-29576-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following sparse warnings:

ti-vpe/cal.c:387:26: warning: incorrect type in return expression (different address spaces)
ti-vpe/cal.c:459:26: warning: incorrect type in return expression (different address spaces)
ti-vpe/cal.c:503:27: warning: incorrect type in argument 6 (different address spaces)
ti-vpe/cal.c:509:47: warning: incorrect type in argument 6 (different address spaces)
ti-vpe/cal.c:518:47: warning: incorrect type in argument 6 (different address spaces)
ti-vpe/cal.c:526:31: warning: incorrect type in argument 6 (different address spaces)
ti-vpe/cal.c:1807:24: warning: Using plain integer as NULL pointer
ti-vpe/cal.c:1844:16: warning: Using plain integer as NULL pointer

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/cal.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 69ec79ba49ee..35fa1071c5b2 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -384,7 +384,7 @@ static struct cm_data *cm_create(struct cal_dev *dev)
 	cm->base = devm_ioremap_resource(&pdev->dev, cm->res);
 	if (IS_ERR(cm->base)) {
 		cal_err(dev, "failed to ioremap\n");
-		return cm->base;
+		return ERR_CAST(cm->base);
 	}
 
 	cal_dbg(1, dev, "ioresource %s at %pa - %pa\n",
@@ -456,7 +456,7 @@ static struct cc_data *cc_create(struct cal_dev *dev, unsigned int core)
 	cc->base = devm_ioremap_resource(&pdev->dev, cc->res);
 	if (IS_ERR(cc->base)) {
 		cal_err(dev, "failed to ioremap\n");
-		return cc->base;
+		return ERR_CAST(cc->base);
 	}
 
 	cal_dbg(1, dev, "ioresource %s at %pa - %pa\n",
@@ -500,13 +500,14 @@ static void cal_quickdump_regs(struct cal_dev *dev)
 {
 	cal_info(dev, "CAL Registers @ 0x%pa:\n", &dev->res->start);
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
-		       dev->base, resource_size(dev->res), false);
+		       (__force const void *)dev->base,
+		       resource_size(dev->res), false);
 
 	if (dev->ctx[0]) {
 		cal_info(dev, "CSI2 Core 0 Registers @ %pa:\n",
 			 &dev->ctx[0]->cc->res->start);
 		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
-			       dev->ctx[0]->cc->base,
+			       (__force const void *)dev->ctx[0]->cc->base,
 			       resource_size(dev->ctx[0]->cc->res),
 			       false);
 	}
@@ -515,7 +516,7 @@ static void cal_quickdump_regs(struct cal_dev *dev)
 		cal_info(dev, "CSI2 Core 1 Registers @ %pa:\n",
 			 &dev->ctx[1]->cc->res->start);
 		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
-			       dev->ctx[1]->cc->base,
+			       (__force const void *)dev->ctx[1]->cc->base,
 			       resource_size(dev->ctx[1]->cc->res),
 			       false);
 	}
@@ -523,7 +524,7 @@ static void cal_quickdump_regs(struct cal_dev *dev)
 	cal_info(dev, "CAMERRX_Control Registers @ %pa:\n",
 		 &dev->cm->res->start);
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
-		       dev->cm->base,
+		       (__force const void *)dev->cm->base,
 		       resource_size(dev->cm->res), false);
 }
 
@@ -1804,7 +1805,7 @@ static struct cal_ctx *cal_create_instance(struct cal_dev *dev, int inst)
 
 	ctx = devm_kzalloc(&dev->pdev->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
-		return 0;
+		return NULL;
 
 	/* save the cal_dev * for future ref */
 	ctx->dev = dev;
@@ -1841,7 +1842,7 @@ free_hdl:
 unreg_dev:
 	v4l2_device_unregister(&ctx->v4l2_dev);
 err_exit:
-	return 0;
+	return NULL;
 }
 
 static int cal_probe(struct platform_device *pdev)
-- 
1.8.5.1

