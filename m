Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33310 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750892AbbCGVmR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:17 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 05/18] omap3isp: Platform data could be NULL
Date: Sat,  7 Mar 2015 23:41:02 +0200
Message-Id: <1425764475-27691-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only check for call platform data callback functions if there's platform
data. Also take care of a few other cases where the NULL pdata pointer could
have been accessed, and remove the check for NULL dev->platform_data
pointer.

Removing the check for NULL dev->platform_data isn't strictly needed by the
DT support but there's no harm from that either: the device now can be used
without sensors, for instance.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c      |   10 ++++------
 drivers/media/platform/omap3isp/ispvideo.c |    6 +++---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 01356dd..b836bc8 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -330,8 +330,8 @@ static int isp_xclk_init(struct isp_device *isp)
 		if (np)
 			continue;
 
-		if (pdata->xclks[i].con_id == NULL &&
-		    pdata->xclks[i].dev_id == NULL)
+		if (!pdata || (pdata->xclks[i].con_id == NULL &&
+			       pdata->xclks[i].dev_id == NULL))
 			continue;
 
 		xclk->lookup = kzalloc(sizeof(*xclk->lookup), GFP_KERNEL);
@@ -1989,7 +1989,8 @@ static int isp_register_entities(struct isp_device *isp)
 		goto done;
 
 	/* Register external entities */
-	for (subdevs = pdata->subdevs; subdevs && subdevs->subdevs; ++subdevs) {
+	for (subdevs = pdata ? pdata->subdevs : NULL;
+	     subdevs && subdevs->subdevs; ++subdevs) {
 		struct v4l2_subdev *sensor =
 			isp_register_subdev_group(isp, subdevs->subdevs);
 
@@ -2271,9 +2272,6 @@ static int isp_probe(struct platform_device *pdev)
 	int ret;
 	int i, m;
 
-	if (pdata == NULL)
-		return -EINVAL;
-
 	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
 	if (!isp) {
 		dev_err(&pdev->dev, "could not allocate memory\n");
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3fe9047..d644164 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1022,7 +1022,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	pipe->entities = 0;
 
-	if (video->isp->pdata->set_constraints)
+	if (video->isp->pdata && video->isp->pdata->set_constraints)
 		video->isp->pdata->set_constraints(video->isp, true);
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
 	pipe->max_rate = pipe->l3_ick;
@@ -1104,7 +1104,7 @@ err_set_stream:
 err_check_format:
 	media_entity_pipeline_stop(&video->video.entity);
 err_pipeline_start:
-	if (video->isp->pdata->set_constraints)
+	if (video->isp->pdata && video->isp->pdata->set_constraints)
 		video->isp->pdata->set_constraints(video->isp, false);
 	/* The DMA queue must be emptied here, otherwise CCDC interrupts that
 	 * will get triggered the next time the CCDC is powered up will try to
@@ -1165,7 +1165,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->queue = NULL;
 	video->error = false;
 
-	if (video->isp->pdata->set_constraints)
+	if (video->isp->pdata && video->isp->pdata->set_constraints)
 		video->isp->pdata->set_constraints(video->isp, false);
 	media_entity_pipeline_stop(&video->video.entity);
 
-- 
1.7.10.4

