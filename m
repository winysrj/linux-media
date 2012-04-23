Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37599 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2DWL3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:29:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 4/4] omap3isp: Mark probe and cleanup functions with __devinit and __devexit
Date: Mon, 23 Apr 2012 13:29:55 +0200
Message-Id: <1335180595-27931-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index df6416c..0307ac3 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1978,7 +1978,7 @@ error_csiphy:
  *
  * Always returns 0.
  */
-static int isp_remove(struct platform_device *pdev)
+static int __devexit isp_remove(struct platform_device *pdev)
 {
 	struct isp_device *isp = platform_get_drvdata(pdev);
 	int i;
@@ -2059,7 +2059,7 @@ static int isp_map_mem_resource(struct platform_device *pdev,
  *   -EINVAL if couldn't install ISR,
  *   or clk_get return error value.
  */
-static int isp_probe(struct platform_device *pdev)
+static int __devinit isp_probe(struct platform_device *pdev)
 {
 	struct isp_platform_data *pdata = pdev->dev.platform_data;
 	struct isp_device *isp;
@@ -2227,7 +2227,7 @@ MODULE_DEVICE_TABLE(platform, omap3isp_id_table);
 
 static struct platform_driver omap3isp_driver = {
 	.probe = isp_probe,
-	.remove = isp_remove,
+	.remove = __devexit_p(isp_remove),
 	.id_table = omap3isp_id_table,
 	.driver = {
 		.owner = THIS_MODULE,
-- 
1.7.3.4

