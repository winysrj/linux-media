Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36334 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbCIGjm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 02:39:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH/RFC 4/4] soc-camera: Skip v4l2 clock registration if host doesn't provide clk ops
Date: Mon,  9 Mar 2015 08:39:36 +0200
Message-Id: <1425883176-29859-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the soc-camera host doesn't provide clock start and stop operations
registering a v4l2 clock is pointless. Don't do it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 51 +++++++++++++++++---------
 1 file changed, 33 insertions(+), 18 deletions(-)

This requires proper review and testing, please don't apply it blindly.

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 0943125..f3ea911 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1374,10 +1374,13 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
 		 shd->i2c_adapter_id, shd->board_info->addr);
 
-	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
-	if (IS_ERR(icd->clk)) {
-		ret = PTR_ERR(icd->clk);
-		goto eclkreg;
+	if (ici->ops->clock_start && ici->ops->clock_stop) {
+		icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name,
+					     "mclk", icd);
+		if (IS_ERR(icd->clk)) {
+			ret = PTR_ERR(icd->clk);
+			goto eclkreg;
+		}
 	}
 
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
@@ -1394,8 +1397,10 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 
 	return 0;
 ei2cnd:
-	v4l2_clk_unregister(icd->clk);
-	icd->clk = NULL;
+	if (icd->clk) {
+		v4l2_clk_unregister(icd->clk);
+		icd->clk = NULL;
+	}
 eclkreg:
 	kfree(ssdd);
 ealloc:
@@ -1420,8 +1425,10 @@ static void soc_camera_i2c_free(struct soc_camera_device *icd)
 	i2c_unregister_device(client);
 	i2c_put_adapter(adap);
 	kfree(ssdd);
-	v4l2_clk_unregister(icd->clk);
-	icd->clk = NULL;
+	if (icd->clk) {
+		v4l2_clk_unregister(icd->clk);
+		icd->clk = NULL;
+	}
 }
 
 /*
@@ -1555,17 +1562,21 @@ static int scan_async_group(struct soc_camera_host *ici,
 	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
 		 sasd->asd.match.i2c.adapter_id, sasd->asd.match.i2c.address);
 
-	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
-	if (IS_ERR(icd->clk)) {
-		ret = PTR_ERR(icd->clk);
-		goto eclkreg;
+	if (ici->ops->clock_start && ici->ops->clock_stop) {
+		icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name,
+					     "mclk", icd);
+		if (IS_ERR(icd->clk)) {
+			ret = PTR_ERR(icd->clk);
+			goto eclkreg;
+		}
 	}
 
 	ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
 	if (!ret)
 		return 0;
 
-	v4l2_clk_unregister(icd->clk);
+	if (icd->clk)
+		v4l2_clk_unregister(icd->clk);
 eclkreg:
 	icd->clk = NULL;
 	platform_device_del(sasc->pdev);
@@ -1660,17 +1671,21 @@ static int soc_of_bind(struct soc_camera_host *ici,
 		snprintf(clk_name, sizeof(clk_name), "of-%s",
 			 of_node_full_name(remote));
 
-	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
-	if (IS_ERR(icd->clk)) {
-		ret = PTR_ERR(icd->clk);
-		goto eclkreg;
+	if (ici->ops->clock_start && ici->ops->clock_stop) {
+		icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name,
+					     "mclk", icd);
+		if (IS_ERR(icd->clk)) {
+			ret = PTR_ERR(icd->clk);
+			goto eclkreg;
+		}
 	}
 
 	ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
 	if (!ret)
 		return 0;
 
-	v4l2_clk_unregister(icd->clk);
+	if (icd->clk)
+		v4l2_clk_unregister(icd->clk);
 eclkreg:
 	icd->clk = NULL;
 	platform_device_del(sasc->pdev);
-- 
2.0.5

