Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:32497 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZLOMUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 07:20:17 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	gururaj.nagendra@intel.com, mchehab@infradead.org,
	mkrufky@linuxtv.org, dheitmueller@kernellabs.com,
	iivanov@mm-sol.com, vimarsh.zutshi@nokia.com
Subject: [RFC 3/4] V4L: Events: Support event handling in do_ioctl
Date: Tue, 15 Dec 2009 14:19:50 +0200
Message-Id: <1260879591-14376-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1260879591-14376-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B277D2A.7050201@maxwell.research.nokia.com>
 <1260879591-14376-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1260879591-14376-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for event handling to do_ioctl.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-ioctl.c |   48 ++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h       |    7 +++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index bfc4696..067ab3a 100644
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
+		ret = ops->vidioc_dqevent(file, ev);
+		if (ret < 0) {
+			dbgarg(cmd, "no pending events?");
+			break;
+		}
+		dbgarg(cmd,
+		       "count=%d, type=0x%8.8x, sequence=%d, "
+		       "timestamp=%d.%9.9lu ",
+		       ev->count, ev->type, ev->sequence,
+		       (int)ev->timestamp.tv_sec, ev->timestamp.tv_nsec);
+		break;
+	}
+	case VIDIOC_SUBSCRIBE_EVENT:
+	{
+		struct v4l2_event_subscription *sub = arg;
 
+		if (!ops->vidioc_subscribe_event)
+			break;
+
+		ret = ops->vidioc_subscribe_event(file, sub);
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
+		ret = ops->vidioc_unsubscribe_event(file, sub);
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
index 7a4529d..77a71cc 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -239,6 +239,13 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_enum_frameintervals) (struct file *file, void *fh,
 					   struct v4l2_frmivalenum *fival);
 
+	int (*vidioc_dqevent)	       (struct file *file,
+					struct v4l2_event *ev);
+	int (*vidioc_subscribe_event)  (struct file *file,
+					struct v4l2_event_subscription *sub);
+	int (*vidioc_unsubscribe_event) (struct file *file,
+					 struct v4l2_event_subscription *sub);
+
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
 					int cmd, void *arg);
-- 
1.5.6.5

