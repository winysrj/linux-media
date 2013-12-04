Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3LDA4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:39 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 264A9366A8
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:41 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 20/25] v4l: omap4iss: Propagate stop timeouts from submodules to the driver core
Date: Wed,  4 Dec 2013 01:56:20 +0100
Message-Id: <1386118585-12449-21-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return an error from the s_stream handlers when stopping the stream
failed instead of just logging the error and ignoring it. While we're
at it, move the logging code from submodules to the driver code.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c         | 11 +++++++++--
 drivers/staging/media/omap4iss/iss_csi2.c    |  8 +++-----
 drivers/staging/media/omap4iss/iss_ipipe.c   |  3 +--
 drivers/staging/media/omap4iss/iss_ipipeif.c |  3 +--
 drivers/staging/media/omap4iss/iss_resizer.c |  3 +--
 5 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index ba8460d..a0bf2f3 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -614,6 +614,8 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe)
 	struct media_entity *entity;
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
+	int failure = 0;
+	int ret;
 
 	entity = &pipe->output->video.entity;
 	while (1) {
@@ -629,10 +631,15 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe)
 		entity = pad->entity;
 		subdev = media_entity_to_v4l2_subdev(entity);
 
-		v4l2_subdev_call(subdev, video, s_stream, 0);
+		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
+		if (ret < 0) {
+			dev_dbg(iss->dev, "%s: module stop timeout.\n",
+				subdev->name);
+			failure = -ETIMEDOUT;
+		}
 	}
 
-	return 0;
+	return failure;
 }
 
 /*
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 077545f..7e7e955 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1056,6 +1056,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 	struct iss_device *iss = csi2->iss;
 	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
 	struct iss_video *video_out = &csi2->video_out;
+	int ret = 0;
 
 	if (csi2->state == ISS_PIPELINE_STREAM_STOPPED) {
 		if (enable == ISS_PIPELINE_STREAM_STOPPED)
@@ -1069,8 +1070,6 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 
 	switch (enable) {
 	case ISS_PIPELINE_STREAM_CONTINUOUS: {
-		int ret;
-
 		ret = omap4iss_csiphy_config(iss, sd);
 		if (ret < 0)
 			return ret;
@@ -1102,8 +1101,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 			return 0;
 		if (omap4iss_module_sync_idle(&sd->entity, &csi2->wait,
 					      &csi2->stopping))
-			dev_dbg(iss->dev, "%s: module stop timeout.\n",
-				sd->name);
+			ret = -ETIMEDOUT;
 		csi2_ctx_enable(csi2, 0, 0);
 		csi2_if_enable(csi2, 0);
 		csi2_irq_ctx_set(csi2, 0);
@@ -1117,7 +1115,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 	}
 
 	csi2->state = enable;
-	return 0;
+	return ret;
 }
 
 /* subdev video operations */
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index d0b9f8c..c013f83 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -166,8 +166,7 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
 			return 0;
 		if (omap4iss_module_sync_idle(&sd->entity, &ipipe->wait,
 					      &ipipe->stopping))
-			dev_dbg(iss->dev, "%s: module stop timeout.\n",
-				sd->name);
+			ret = -ETIMEDOUT;
 
 		ipipe_enable(ipipe, 0);
 		omap4iss_isp_disable_interrupts(iss);
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 2d11f62..00bc937 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -363,8 +363,7 @@ static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
 			return 0;
 		if (omap4iss_module_sync_idle(&sd->entity, &ipipeif->wait,
 					      &ipipeif->stopping))
-			dev_dbg(iss->dev, "%s: module stop timeout.\n",
-				sd->name);
+			ret = -ETIMEDOUT;
 
 		if (ipipeif->output & IPIPEIF_OUTPUT_MEMORY)
 			ipipeif_write_enable(ipipeif, 0);
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 5bf5080..9dbf018 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -416,8 +416,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 			return 0;
 		if (omap4iss_module_sync_idle(&sd->entity, &resizer->wait,
 					      &resizer->stopping))
-			dev_dbg(iss->dev, "%s: module stop timeout.\n",
-				sd->name);
+			ret = -ETIMEDOUT;
 
 		resizer_enable(resizer, 0);
 		omap4iss_isp_disable_interrupts(iss);
-- 
1.8.3.2

