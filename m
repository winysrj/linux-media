Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44780 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaBOBS5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 20:18:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Peter Meerwald <pmeerw@pmeerw.net>, sakari.ailus@iki.fi
Subject: [PATCH 2/2] omap3isp: Don't ignore failure to locate external subdev
Date: Sat, 15 Feb 2014 02:19:55 +0100
Message-Id: <1392427195-2017-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392427195-2017-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392427195-2017-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A failure to locate the external subdev for a non memory-to-memory
pipeline is a fatal error, don't ignore it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 313fd13..a62cf0b 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -886,7 +886,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
 	unsigned int i;
-	int ret = 0;
+	int ret;
 
 	/* Memory-to-memory pipelines have no external subdev. */
 	if (pipe->input != NULL)
@@ -909,7 +909,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 
 	if (!source) {
 		dev_warn(isp->dev, "can't find source, failing now\n");
-		return ret;
+		return -EINVAL;
 	}
 
 	if (media_entity_type(source) != MEDIA_ENT_T_V4L2_SUBDEV)
-- 
1.8.3.2

