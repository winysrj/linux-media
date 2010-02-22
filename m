Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:38907 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab0BVPvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 10:51:46 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@nokia.com, hverkuil@xs4all.nl,
	david.cohen@nokia.com
Subject: [PATCH 3/6] V4L: Events: Add new ioctls for events
Date: Mon, 22 Feb 2010 17:51:34 +0200
Message-Id: <1266853897-25749-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1266853897-25749-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B82A7FB.50505@maxwell.research.nokia.com>
 <1266853897-25749-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1266853897-25749-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a set of new ioctls to the V4L2 API. The ioctls conform to
V4L2 Events RFC version 2.3:

<URL:http://www.spinics.net/lists/linux-media/msg12033.html>

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    3 +++
 drivers/media/video/v4l2-ioctl.c          |    3 +++
 include/linux/videodev2.h                 |   26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index f77f84b..9004a5f 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -1086,6 +1086,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_QUERY_DV_PRESET:
 	case VIDIOC_S_DV_TIMINGS:
 	case VIDIOC_G_DV_TIMINGS:
+	case VIDIOC_DQEVENT:
+	case VIDIOC_SUBSCRIBE_EVENT:
+	case VIDIOC_UNSUBSCRIBE_EVENT:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 4b11257..34c7d6e 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -290,6 +290,9 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_QUERY_DV_PRESET)]  = "VIDIOC_QUERY_DV_PRESET",
 	[_IOC_NR(VIDIOC_S_DV_TIMINGS)]     = "VIDIOC_S_DV_TIMINGS",
 	[_IOC_NR(VIDIOC_G_DV_TIMINGS)]     = "VIDIOC_G_DV_TIMINGS",
+	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
+	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
+	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 3c26560..f7237fc 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1622,6 +1622,29 @@ struct v4l2_streamparm {
 };
 
 /*
+ *	E V E N T S
+ */
+
+struct v4l2_event {
+	__u32				type;
+	union {
+		__u8			data[64];
+	} u;
+	__u32				pending;
+	__u32				sequence;
+	struct timespec			timestamp;
+	__u32				reserved[9];
+};
+
+struct v4l2_event_subscription {
+	__u32				type;
+	__u32				reserved[7];
+};
+
+#define V4L2_EVENT_ALL				0
+#define V4L2_EVENT_PRIVATE_START		0x08000000
+
+/*
  *	A D V A N C E D   D E B U G G I N G
  *
  *	NOTE: EXPERIMENTAL API, NEVER RELY ON THIS IN APPLICATIONS!
@@ -1743,6 +1766,9 @@ struct v4l2_dbg_chip_ident {
 #define	VIDIOC_QUERY_DV_PRESET	_IOR('V',  86, struct v4l2_dv_preset)
 #define	VIDIOC_S_DV_TIMINGS	_IOWR('V', 87, struct v4l2_dv_timings)
 #define	VIDIOC_G_DV_TIMINGS	_IOWR('V', 88, struct v4l2_dv_timings)
+#define	VIDIOC_DQEVENT		 _IOR('V', 83, struct v4l2_event)
+#define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 84, struct v4l2_event_subscription)
+#define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 85, struct v4l2_event_subscription)
 
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
-- 
1.5.6.5

