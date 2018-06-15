Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35856 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934701AbeFOTHv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:07:51 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH v4 01/17] v4l2-ioctl.c: use correct vb2_queue lock for m2m devices
Date: Fri, 15 Jun 2018 16:07:21 -0300
Message-Id: <20180615190737.24139-2-ezequiel@collabora.com>
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

For m2m devices the vdev->queue lock was always taken instead of the
lock for the specific capture or output queue. Now that we pushed
the locking down into __video_do_ioctl() we can pick the correct
lock and improve the performance of m2m devices.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 59 ++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index dd210067151f..db835578e21f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -29,6 +29,7 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mc.h>
+#include <media/v4l2-mem2mem.h>
 
 #include <trace/events/v4l2.h>
 
@@ -2662,11 +2663,62 @@ static bool v4l2_is_known_ioctl(unsigned int cmd)
 	return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
+static bool v4l2_ioctl_m2m_queue_is_output(unsigned int cmd, void *arg)
+{
+	switch (cmd) {
+	case VIDIOC_CREATE_BUFS: {
+		struct v4l2_create_buffers *cbufs = arg;
+
+		return V4L2_TYPE_IS_OUTPUT(cbufs->format.type);
+	}
+	case VIDIOC_REQBUFS: {
+		struct v4l2_requestbuffers *rbufs = arg;
+
+		return V4L2_TYPE_IS_OUTPUT(rbufs->type);
+	}
+	case VIDIOC_QBUF:
+	case VIDIOC_DQBUF:
+	case VIDIOC_QUERYBUF:
+	case VIDIOC_PREPARE_BUF: {
+		struct v4l2_buffer *buf = arg;
+
+		return V4L2_TYPE_IS_OUTPUT(buf->type);
+	}
+	case VIDIOC_EXPBUF: {
+		struct v4l2_exportbuffer *expbuf = arg;
+
+		return V4L2_TYPE_IS_OUTPUT(expbuf->type);
+	}
+	case VIDIOC_STREAMON:
+	case VIDIOC_STREAMOFF: {
+		int *type = arg;
+
+		return V4L2_TYPE_IS_OUTPUT(*type);
+	}
+	default:
+		return false;
+	}
+}
+#endif
+
 static struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev,
-					 unsigned int cmd)
+					 struct v4l2_fh *vfh, unsigned cmd,
+					 void *arg)
 {
 	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
 		return vdev->lock;
+#if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
+	if (vfh && vfh->m2m_ctx &&
+	    (v4l2_ioctls[_IOC_NR(cmd)].flags & INFO_FL_QUEUE)) {
+		bool is_output = v4l2_ioctl_m2m_queue_is_output(cmd, arg);
+		struct v4l2_m2m_queue_ctx *ctx = is_output ?
+			&vfh->m2m_ctx->out_q_ctx : &vfh->m2m_ctx->cap_q_ctx;
+
+		if (ctx->q.lock)
+			return ctx->q.lock;
+	}
+#endif
 	if (vdev->queue && vdev->queue->lock &&
 			(v4l2_ioctls[_IOC_NR(cmd)].flags & INFO_FL_QUEUE))
 		return vdev->queue->lock;
@@ -2714,7 +2766,7 @@ static long __video_do_ioctl(struct file *file,
 		unsigned int cmd, void *arg)
 {
 	struct video_device *vfd = video_devdata(file);
-	struct mutex *lock; /* ioctl serialization mutex */
+	struct mutex *lock;
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	bool write_only = false;
 	struct v4l2_ioctl_info default_info;
@@ -2733,8 +2785,7 @@ static long __video_do_ioctl(struct file *file,
 	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
 		vfh = file->private_data;
 
-	lock = v4l2_ioctl_get_lock(vfd, cmd);
-
+	lock = v4l2_ioctl_get_lock(vfd, vfh, cmd, arg);
 	if (lock && mutex_lock_interruptible(lock))
 		return -ERESTARTSYS;
 
-- 
2.17.1
