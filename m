Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:22111 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab2A0MyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 07:54:10 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] omap3isp: Fix CCDC vsync event delivery
Date: Fri, 27 Jan 2012 14:54:04 +0200
Message-Id: <1327668844-19136-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The devnode already is a pointer in struct v4l2_subdev, we don't need a
pointer to that.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
This issue is present in for_v3.3 branch and in for_v3.4. This patch is for
the former.

 drivers/media/video/omap3isp/ispccdc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 549b79a..75f142c 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1408,14 +1408,13 @@ static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
 {
 	struct isp_pipeline *pipe =
 		to_isp_pipeline(&ccdc->video_out.video.entity);
-	struct video_device *vdev = &ccdc->subdev.devnode;
 	struct v4l2_event event;
 
 	memset(&event, 0, sizeof(event));
 	event.type = V4L2_EVENT_FRAME_SYNC;
 	event.u.frame_sync.frame_sequence = atomic_read(&pipe->frame_number);
 
-	v4l2_event_queue(vdev, &event);
+	v4l2_event_queue(ccdc->subdev.devnode, &event);
 }
 
 /*
-- 
1.7.2.5

