Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19303 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab0BFSCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 13:02:24 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com,
	iivanov@mm-sol.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 3/8] V4L: Events: Add new ioctls for events
Date: Sat,  6 Feb 2010 20:02:06 +0200
Message-Id: <1265479331-20595-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6DAE5A.5090508@maxwell.research.nokia.com>
References: <4B6DAE5A.5090508@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a set of new ioctls to the V4L2 API. The ioctls conform to
V4L2 Events RFC version 2.3:

<URL:http://www.spinics.net/lists/linux-media/msg12033.html>

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    3 +++
 drivers/media/video/v4l2-ioctl.c          |    3 +++
 include/linux/videodev2.h                 |   23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 997975d..cba704c 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -1077,6 +1077,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_DBG_G_REGISTER:
 	case VIDIOC_DBG_G_CHIP_IDENT:
 	case VIDIOC_S_HW_FREQ_SEEK:
+	case VIDIOC_DQEVENT:
+	case VIDIOC_SUBSCRIBE_EVENT:
+	case VIDIOC_UNSUBSCRIBE_EVENT:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 30cc334..bfc4696 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -283,6 +283,9 @@ static const char *v4l2_ioctls[] = {
 
 	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
 	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
+	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
+	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
+	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
 #endif
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 54af357..a19ae89 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1536,6 +1536,26 @@ struct v4l2_streamparm {
 };
 
 /*
+ *	E V E N T S
+ */
+
+struct v4l2_event {
+	__u32		count;
+	__u32		type;
+	__u32		sequence;
+	struct timespec	timestamp;
+	__u32		reserved[9];
+	__u8		data[64];
+};
+
+struct v4l2_event_subscription {
+	__u32		type;
+	__u32		reserved[7];
+};
+
+#define V4L2_EVENT_PRIVATE_START		0x08000000
+
+/*
  *	A D V A N C E D   D E B U G G I N G
  *
  *	NOTE: EXPERIMENTAL API, NEVER RELY ON THIS IN APPLICATIONS!
@@ -1651,6 +1671,9 @@ struct v4l2_dbg_chip_ident {
 #endif
 
 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
+#define VIDIOC_DQEVENT		 _IOR('V', 83, struct v4l2_event)
+#define VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 84, struct v4l2_event_subscription)
+#define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 85, struct v4l2_event_subscription)
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-- 
1.5.6.5

