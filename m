Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54548 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820Ab2JLS0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 14:26:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/3] omap3isp: Fix warning caused by bad subdev events operations prototypes
Date: Fri, 12 Oct 2012 20:27:30 +0200
Message-Id: <1350066450-17370-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1350066450-17370-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1350066450-17370-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the const keyword from the V4L2 subdev events operations to match
the V4L2 API.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c |    4 ++--
 drivers/media/platform/omap3isp/ispstat.c |    4 ++--
 drivers/media/platform/omap3isp/ispstat.h |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 60181ab..aa9df9d 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1706,7 +1706,7 @@ static long ccdc_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 }
 
 static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
-				const struct v4l2_event_subscription *sub)
+				struct v4l2_event_subscription *sub)
 {
 	if (sub->type != V4L2_EVENT_FRAME_SYNC)
 		return -EINVAL;
@@ -1719,7 +1719,7 @@ static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 }
 
 static int ccdc_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
-				  const struct v4l2_event_subscription *sub)
+				  struct v4l2_event_subscription *sub)
 {
 	return v4l2_event_unsubscribe(fh, sub);
 }
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 600d610..6e24895 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1026,7 +1026,7 @@ void omap3isp_stat_dma_isr(struct ispstat *stat)
 
 int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 				  struct v4l2_fh *fh,
-				  const struct v4l2_event_subscription *sub)
+				  struct v4l2_event_subscription *sub)
 {
 	struct ispstat *stat = v4l2_get_subdevdata(subdev);
 
@@ -1038,7 +1038,7 @@ int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 
 int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
 				    struct v4l2_fh *fh,
-				    const struct v4l2_event_subscription *sub)
+				    struct v4l2_event_subscription *sub)
 {
 	return v4l2_event_unsubscribe(fh, sub);
 }
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index 253e61e..8221d0c 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -147,10 +147,10 @@ int omap3isp_stat_init(struct ispstat *stat, const char *name,
 void omap3isp_stat_cleanup(struct ispstat *stat);
 int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 				  struct v4l2_fh *fh,
-				  const struct v4l2_event_subscription *sub);
+				  struct v4l2_event_subscription *sub);
 int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
 				    struct v4l2_fh *fh,
-				    const struct v4l2_event_subscription *sub);
+				    struct v4l2_event_subscription *sub);
 int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, int enable);
 
 int omap3isp_stat_busy(struct ispstat *stat);
-- 
1.7.8.6

