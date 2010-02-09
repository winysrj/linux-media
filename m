Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22936 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab0BIS1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 13:27:07 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
Subject: [PATCH v3 3/7] V4L: Events: Support event handling in do_ioctl
Date: Tue,  9 Feb 2010 20:26:46 +0200
Message-Id: <1265740010-24144-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265740010-24144-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B71A8DF.8070907@maxwell.research.nokia.com>
 <1265740010-24144-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265740010-24144-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for event handling to do_ioctl.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Makefile     |    2 +-
 drivers/media/video/v4l2-ioctl.c |   48 ++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h       |    9 +++++++
 3 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index b888ad1..68253d6 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -11,7 +11,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-subdev.o \
-			v4l2-fh.o
+			v4l2-fh.o v4l2-event.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index bfc4696..a6d6e73 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1797,7 +1797,55 @@ static long __video_do_ioctl(struct file *file,
 		}
 		break;
 	}
+	case VIDIOC_DQEVENT:
+	{
+		struct v4l2_event *ev = arg;
+
+		if (!ops->vidioc_dqevent)
+			break;
+
+		ret = ops->vidioc_dqevent(fh, ev);
+		if (ret < 0) {
+			dbgarg(cmd, "no pending events?");
+			break;
+		}
+		dbgarg(cmd,
+		       "count=%d, type=0x%8.8x, sequence=%d, "
+		       "timestamp=%lu.%9.9lu ",
+		       ev->count, ev->type, ev->sequence,
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
index 7a4529d..6d6a2a3 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -21,6 +21,8 @@
 #include <linux/videodev2.h>
 #endif
 
+struct v4l2_fh;
+
 struct v4l2_ioctl_ops {
 	/* ioctl callbacks */
 
@@ -239,6 +241,13 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_enum_frameintervals) (struct file *file, void *fh,
 					   struct v4l2_frmivalenum *fival);
 
+	int (*vidioc_dqevent)	       (struct v4l2_fh *fh,
+					struct v4l2_event *ev);
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

