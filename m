Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35999 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1HMQVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 12:21:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/2] omap3isp: Don't fail streamon when the sensor doesn't implement s_stream
Date: Sat, 13 Aug 2011 18:21:45 +0200
Message-Id: <1313252506-32376-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code handles subdevs with no s_stream operation correctly, but
returns -ENOIOCTLCMD by mistake if the first subdev in the chain has no
s_stream operation. Return 0 in that case.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 5cea2bb..fda4be0 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -732,7 +732,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 
 	spin_lock_irqsave(&pipe->lock, flags);
 	pipe->state &= ~(ISP_PIPELINE_IDLE_INPUT | ISP_PIPELINE_IDLE_OUTPUT);
@@ -756,7 +756,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 
 		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
-			break;
+			return ret;
 
 		if (subdev == &isp->isp_ccdc.subdev) {
 			v4l2_subdev_call(&isp->isp_aewb.subdev, video,
@@ -777,7 +777,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 	if (pipe->do_propagation && mode == ISP_PIPELINE_STREAM_SINGLESHOT)
 		atomic_inc(&pipe->frame_number);
 
-	return ret;
+	return 0;
 }
 
 static int isp_pipeline_wait_resizer(struct isp_device *isp)
-- 
1.7.3.4

