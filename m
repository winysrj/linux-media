Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48329 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3KDAG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 18/18] v4l: omap4iss: Simplify error paths
Date: Mon,  4 Nov 2013 01:06:43 +0100
Message-Id: <1383523603-3907-19-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of a goto statement for a simple error path that can be inlined,
and split spaghetti error code to a separate section.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c       | 20 +++++++++-----------
 drivers/staging/media/omap4iss/iss_video.c | 15 ++++++++-------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 7d427d5..b7c8a6b 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -887,24 +887,22 @@ void omap4iss_isp_subclk_disable(struct iss_device *iss,
  */
 static int iss_enable_clocks(struct iss_device *iss)
 {
-	int r;
+	int ret;
 
-	r = clk_enable(iss->iss_fck);
-	if (r) {
+	ret = clk_enable(iss->iss_fck);
+	if (ret) {
 		dev_err(iss->dev, "clk_enable iss_fck failed\n");
-		return r;
+		return ret;
 	}
 
-	r = clk_enable(iss->iss_ctrlclk);
-	if (r) {
+	ret = clk_enable(iss->iss_ctrlclk);
+	if (ret) {
 		dev_err(iss->dev, "clk_enable iss_ctrlclk failed\n");
-		goto out_clk_enable_ctrlclk;
+		clk_disable(iss->iss_fck);
+		return ret;
 	}
-	return 0;
 
-out_clk_enable_ctrlclk:
-	clk_disable(iss->iss_fck);
-	return r;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index ccbdecd..a527330 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -826,16 +826,17 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		spin_unlock_irqrestore(&video->qlock, flags);
 	}
 
-	if (ret < 0) {
+	mutex_unlock(&video->stream_lock);
+	return 0;
+
 err_omap4iss_set_stream:
-		vb2_streamoff(&vfh->queue, type);
+	vb2_streamoff(&vfh->queue, type);
 err_iss_video_check_format:
-		media_entity_pipeline_stop(&video->video.entity);
+	media_entity_pipeline_stop(&video->video.entity);
 err_media_entity_pipeline_start:
-		if (video->iss->pdata->set_constraints)
-			video->iss->pdata->set_constraints(video->iss, false);
-		video->queue = NULL;
-	}
+	if (video->iss->pdata->set_constraints)
+		video->iss->pdata->set_constraints(video->iss, false);
+	video->queue = NULL;
 
 	mutex_unlock(&video->stream_lock);
 	return ret;
-- 
1.8.1.5

