Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4191 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2IGN3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 19/28] v4l2: make vidioc_(un)subscribe_event const.
Date: Fri,  7 Sep 2012 15:29:19 +0200
Message-Id: <7778a68c636e312a2c57da4be76d305e47d8b9e8.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_(un)subscribe_event.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c       |    2 +-
 drivers/media/platform/omap3isp/ispccdc.c |    4 ++--
 drivers/media/platform/omap3isp/ispstat.c |    4 ++--
 drivers/media/platform/omap3isp/ispstat.h |    4 ++--
 drivers/media/v4l2-core/v4l2-ctrls.c      |    2 +-
 drivers/media/v4l2-core/v4l2-event.c      |    4 ++--
 include/media/v4l2-ctrls.h                |    2 +-
 include/media/v4l2-event.h                |    4 ++--
 include/media/v4l2-ioctl.h                |    4 ++--
 9 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index d3b32c2..966abb4 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1460,7 +1460,7 @@ static int ivtv_overlay(struct file *file, void *fh, unsigned int on)
 	return 0;
 }
 
-static int ivtv_subscribe_event(struct v4l2_fh *fh, struct v4l2_event_subscription *sub)
+static int ivtv_subscribe_event(struct v4l2_fh *fh, const struct v4l2_event_subscription *sub)
 {
 	switch (sub->type) {
 	case V4L2_EVENT_VSYNC:
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index aa9df9d..60181ab 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1706,7 +1706,7 @@ static long ccdc_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 }
 
 static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
-				struct v4l2_event_subscription *sub)
+				const struct v4l2_event_subscription *sub)
 {
 	if (sub->type != V4L2_EVENT_FRAME_SYNC)
 		return -EINVAL;
@@ -1719,7 +1719,7 @@ static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 }
 
 static int ccdc_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
-				  struct v4l2_event_subscription *sub)
+				  const struct v4l2_event_subscription *sub)
 {
 	return v4l2_event_unsubscribe(fh, sub);
 }
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index b8640be..d7ac76b 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1025,7 +1025,7 @@ void omap3isp_stat_dma_isr(struct ispstat *stat)
 
 int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 				  struct v4l2_fh *fh,
-				  struct v4l2_event_subscription *sub)
+				  const struct v4l2_event_subscription *sub)
 {
 	struct ispstat *stat = v4l2_get_subdevdata(subdev);
 
@@ -1037,7 +1037,7 @@ int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 
 int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
 				    struct v4l2_fh *fh,
-				    struct v4l2_event_subscription *sub)
+				    const struct v4l2_event_subscription *sub)
 {
 	return v4l2_event_unsubscribe(fh, sub);
 }
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index 9b7c865..a6fe653 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -147,10 +147,10 @@ int omap3isp_stat_init(struct ispstat *stat, const char *name,
 void omap3isp_stat_cleanup(struct ispstat *stat);
 int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 				  struct v4l2_fh *fh,
-				  struct v4l2_event_subscription *sub);
+				  const struct v4l2_event_subscription *sub);
 int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
 				    struct v4l2_fh *fh,
-				    struct v4l2_event_subscription *sub);
+				    const struct v4l2_event_subscription *sub);
 int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, int enable);
 
 int omap3isp_stat_busy(struct ispstat *stat);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6a2ee7..ac3bfe5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2631,7 +2631,7 @@ int v4l2_ctrl_log_status(struct file *file, void *fh)
 EXPORT_SYMBOL(v4l2_ctrl_log_status);
 
 int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
-				struct v4l2_event_subscription *sub)
+				const struct v4l2_event_subscription *sub)
 {
 	if (sub->type == V4L2_EVENT_CTRL)
 		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index ef2a33c..18a040b 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -203,7 +203,7 @@ int v4l2_event_pending(struct v4l2_fh *fh)
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
 int v4l2_event_subscribe(struct v4l2_fh *fh,
-			 struct v4l2_event_subscription *sub, unsigned elems,
+			 const struct v4l2_event_subscription *sub, unsigned elems,
 			 const struct v4l2_subscribed_event_ops *ops)
 {
 	struct v4l2_subscribed_event *sev, *found_ev;
@@ -278,7 +278,7 @@ void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 EXPORT_SYMBOL_GPL(v4l2_event_unsubscribe_all);
 
 int v4l2_event_unsubscribe(struct v4l2_fh *fh,
-			   struct v4l2_event_subscription *sub)
+			   const struct v4l2_event_subscription *sub)
 {
 	struct v4l2_subscribed_event *sev;
 	unsigned long flags;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 776605f..89a68fb 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -523,7 +523,7 @@ int v4l2_ctrl_log_status(struct file *file, void *fh);
 /* Can be used as a vidioc_subscribe_event function that just subscribes
    control events. */
 int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
-				struct v4l2_event_subscription *sub);
+				const struct v4l2_event_subscription *sub);
 
 /* Can be used as a poll function that just polls for control events. */
 unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 2885a81..e7c5d17 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -124,10 +124,10 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
 int v4l2_event_pending(struct v4l2_fh *fh);
 int v4l2_event_subscribe(struct v4l2_fh *fh,
-			 struct v4l2_event_subscription *sub, unsigned elems,
+			 const struct v4l2_event_subscription *sub, unsigned elems,
 			 const struct v4l2_subscribed_event_ops *ops);
 int v4l2_event_unsubscribe(struct v4l2_fh *fh,
-			   struct v4l2_event_subscription *sub);
+			   const struct v4l2_event_subscription *sub);
 void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
 
 #endif /* V4L2_EVENT_H */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 865f95d..3eef4de 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -273,9 +273,9 @@ struct v4l2_ioctl_ops {
 				    struct v4l2_dv_timings_cap *cap);
 
 	int (*vidioc_subscribe_event)  (struct v4l2_fh *fh,
-					struct v4l2_event_subscription *sub);
+					const struct v4l2_event_subscription *sub);
 	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
-					struct v4l2_event_subscription *sub);
+					const struct v4l2_event_subscription *sub);
 
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
-- 
1.7.10.4

