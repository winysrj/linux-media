Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39101 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0BVPwS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 10:52:18 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@nokia.com, hverkuil@xs4all.nl,
	david.cohen@nokia.com
Subject: [PATCH 5/6] V4L: Events: Support event handling in do_ioctl
Date: Mon, 22 Feb 2010 17:51:36 +0200
Message-Id: <1266853897-25749-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1266853897-25749-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B82A7FB.50505@maxwell.research.nokia.com>
 <1266853897-25749-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1266853897-25749-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1266853897-25749-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1266853897-25749-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for event handling to do_ioctl.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-fh.c    |    5 +++-
 drivers/media/video/v4l2-ioctl.c |   50 ++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h       |    7 +++++
 3 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 713f5a0..2986a2c 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -33,7 +33,10 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 	fh->vdev = vdev;
 	INIT_LIST_HEAD(&fh->list);
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
-	v4l2_event_init(fh);
+	if (vdev->ioctl_ops && vdev->ioctl_ops->vidioc_subscribe_event)
+		v4l2_event_init(fh);
+	else
+		fh->events = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_init);
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 34c7d6e..4ba22da 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -25,6 +25,8 @@
 #endif
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-chip-ident.h>
 
 #define dbgarg(cmd, fmt, arg...) \
@@ -1944,7 +1946,55 @@ static long __video_do_ioctl(struct file *file,
 		}
 		break;
 	}
+	case VIDIOC_DQEVENT:
+	{
+		struct v4l2_event *ev = arg;
+
+		if (!ops->vidioc_subscribe_event)
+			break;
+
+		ret = v4l2_event_dequeue(fh, ev, file->f_flags & O_NONBLOCK);
+		if (ret < 0) {
+			dbgarg(cmd, "no pending events?");
+			break;
+		}
+		dbgarg(cmd,
+		       "pending=%d, type=0x%8.8x, sequence=%d, "
+		       "timestamp=%lu.%9.9lu ",
+		       ev->pending, ev->type, ev->sequence,
+		       ev->timestamp.tv_sec, ev->timestamp.tv_nsec);
+		break;
+	}
+	case VIDIOC_SUBSCRIBE_EVENT:
+	{
+		struct v4l2_event_subscription *sub = arg;
 
+		if (!ops->vidioc_subscribe_event)
+			break;
+
+		ret = ops->vidioc_subscribe_event(fh, sub);
+		if (ret < 0) {
+			dbgarg(cmd, "failed, ret=%ld", ret);
+			break;
+		}
+		dbgarg(cmd, "type=0x%8.8x", sub->type);
+		break;
+	}
+	case VIDIOC_UNSUBSCRIBE_EVENT:
+	{
+		struct v4l2_event_subscription *sub = arg;
+
+		if (!ops->vidioc_unsubscribe_event)
+			break;
+
+		ret = ops->vidioc_unsubscribe_event(fh, sub);
+		if (ret < 0) {
+			dbgarg(cmd, "failed, ret=%ld", ret);
+			break;
+		}
+		dbgarg(cmd, "type=0x%8.8x", sub->type);
+		break;
+	}
 	default:
 	{
 		if (!ops->vidioc_default)
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index e8ba0f2..06daa6e 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -21,6 +21,8 @@
 #include <linux/videodev2.h>
 #endif
 
+struct v4l2_fh;
+
 struct v4l2_ioctl_ops {
 	/* ioctl callbacks */
 
@@ -254,6 +256,11 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_dv_timings) (struct file *file, void *fh,
 				    struct v4l2_dv_timings *timings);
 
+	int (*vidioc_subscribe_event)  (struct v4l2_fh *fh,
+					struct v4l2_event_subscription *sub);
+	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
+					struct v4l2_event_subscription *sub);
+
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
 					int cmd, void *arg);
-- 
1.5.6.5

