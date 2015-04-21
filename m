Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:36200 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbbDUNKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:10:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 09/15] v4l2: add initial V4L2_REQ_CMD_QUEUE support
Date: Tue, 21 Apr 2015 14:58:52 +0200
Message-Id: <1429621138-17213-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the V4L2_REQ_CMD_QUEUE command and the req_queue callback to struct
v4l2_device. Call it if set from v4l2-ioctl.c and v4l2-subdev.c. Make sure
in v4l2-ioctl.c to unlock any current lock first (and relock afterwards).
That way req_queue is called with the assurance that there are no video_device
locks taken. Since req_queue operates device-wide that would make that code
much more complex.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c  | 11 +++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c |  6 ++++++
 include/media/v4l2-device.h           |  2 ++
 include/uapi/linux/videodev2.h        |  1 +
 4 files changed, 20 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 51830c2..44c33f3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1996,6 +1996,17 @@ static int v4l_request_cmd(const struct v4l2_ioctl_ops *ops,
 		return v4l2_ctrl_delete_request(vfh->ctrl_handler, p->request);
 	case V4L2_REQ_CMD_APPLY:
 		return v4l2_ctrl_apply_request(vfh->ctrl_handler, p->request);
+	case V4L2_REQ_CMD_QUEUE:
+		if (vfd->v4l2_dev->req_queue == NULL)
+			return -ENOSYS;
+		if (p->request == 0)
+			return -EINVAL;
+		if (vfd->lock)
+			mutex_unlock(vfd->lock);
+		ret = vfd->v4l2_dev->req_queue(vfd->v4l2_dev, p->request);
+		if (vfd->lock)
+			mutex_lock(vfd->lock);
+		return ret;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index cabbddc..7113b95 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -266,6 +266,12 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		case V4L2_REQ_CMD_APPLY:
 			return v4l2_ctrl_apply_request(vfh->ctrl_handler,
 						       p->request);
+		case V4L2_REQ_CMD_QUEUE:
+			if (sd->v4l2_dev->req_queue == NULL)
+				return -ENOSYS;
+			if (p->request == 0)
+				return -EINVAL;
+			return sd->v4l2_dev->req_queue(sd->v4l2_dev, p->request);
 		default:
 			return -EINVAL;
 		}
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 9c58157..603e7f3 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -62,6 +62,8 @@ struct v4l2_device {
 	struct kref ref;
 	/* Release function that is called when the ref count goes to 0. */
 	void (*release)(struct v4l2_device *v4l2_dev);
+	/* Queue a request */
+	int (*req_queue)(struct v4l2_device *v4l2_dev, u16 request);
 };
 
 static inline void v4l2_device_get(struct v4l2_device *v4l2_dev)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 98a7717..f3164f6 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2089,6 +2089,7 @@ struct v4l2_create_buffers {
 #define V4L2_REQ_CMD_END	(1)
 #define V4L2_REQ_CMD_DELETE	(2)
 #define V4L2_REQ_CMD_APPLY	(3)
+#define V4L2_REQ_CMD_QUEUE	(4)
 
 struct v4l2_request_cmd {
 	__u32 cmd;
-- 
2.1.4

