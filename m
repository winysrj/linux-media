Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:57542 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754020AbeGEQDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 12:03:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv16 23/34] videobuf2-v4l2: integrate with media requests
Date: Thu,  5 Jul 2018 18:03:26 +0200
Message-Id: <20180705160337.54379-24-hverkuil@xs4all.nl>
In-Reply-To: <20180705160337.54379-1-hverkuil@xs4all.nl>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This implements the V4L2 part of the request support. The main
change is that vb2_qbuf and vb2_prepare_buf now have a new
media_device pointer. This required changes to several drivers
that did not use the vb2_ioctl_qbuf/prepare_buf helper functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/common/videobuf2/videobuf2-core.c   |  13 +-
 .../media/common/videobuf2/videobuf2-v4l2.c   | 112 ++++++++++++++++--
 drivers/media/platform/omap3isp/ispvideo.c    |   2 +-
 .../media/platform/s3c-camif/camif-capture.c  |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |   4 +-
 .../media/platform/soc_camera/soc_camera.c    |   4 +-
 drivers/media/usb/uvc/uvc_queue.c             |   5 +-
 drivers/media/usb/uvc/uvc_v4l2.c              |   3 +-
 drivers/media/usb/uvc/uvcvideo.h              |   1 +
 drivers/media/v4l2-core/v4l2-mem2mem.c        |   6 +-
 .../staging/media/davinci_vpfe/vpfe_video.c   |   3 +-
 drivers/staging/media/omap4iss/iss_video.c    |   3 +-
 drivers/usb/gadget/function/uvc_queue.c       |   2 +-
 include/media/videobuf2-v4l2.h                |  14 ++-
 15 files changed, 148 insertions(+), 32 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 6d423bc5a1a1..049822bcdd02 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1338,6 +1338,14 @@ static void vb2_req_queue(struct media_request_object *obj)
 	mutex_unlock(vb->vb2_queue->lock);
 }
 
+static void vb2_req_unbind(struct media_request_object *obj)
+{
+	struct vb2_buffer *vb = container_of(obj, struct vb2_buffer, req_obj);
+
+	if (vb->state == VB2_BUF_STATE_IN_REQUEST)
+		call_void_bufop(vb->vb2_queue, init_buffer, vb);
+}
+
 static void vb2_req_release(struct media_request_object *obj)
 {
 	struct vb2_buffer *vb = container_of(obj, struct vb2_buffer, req_obj);
@@ -1350,6 +1358,7 @@ static const struct media_request_object_ops vb2_core_req_ops = {
 	.prepare = vb2_req_prepare,
 	.unprepare = vb2_req_unprepare,
 	.queue = vb2_req_queue,
+	.unbind = vb2_req_unbind,
 	.release = vb2_req_release,
 };
 
@@ -1476,8 +1485,10 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 
 		vb->state = VB2_BUF_STATE_IN_REQUEST;
 		/* Fill buffer information for the userspace */
-		if (pb)
+		if (pb) {
+			call_void_bufop(q, copy_timestamp, vb, pb);
 			call_void_bufop(q, fill_user_buffer, vb, pb);
+		}
 
 		dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
 		return 0;
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index ea9db4b3f59a..9c652afa62ab 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -25,6 +25,7 @@
 #include <linux/kthread.h>
 
 #include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
@@ -40,10 +41,12 @@ module_param(debug, int, 0644);
 			pr_info("vb2-v4l2: %s: " fmt, __func__, ## arg); \
 	} while (0)
 
-/* Flags that are set by the vb2 core */
+/* Flags that are set by us */
 #define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
 				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
 				 V4L2_BUF_FLAG_PREPARED | \
+				 V4L2_BUF_FLAG_IN_REQUEST | \
+				 V4L2_BUF_FLAG_REQUEST_FD | \
 				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
 /* Output buffer flags that should be passed on to the driver */
 #define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
@@ -118,6 +121,16 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	return 0;
 }
 
+/*
+ * __init_v4l2_vb2_buffer() - initialize the v4l2_vb2_buffer struct
+ */
+static void __init_v4l2_vb2_buffer(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	vbuf->request_fd = -1;
+}
+
 static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 {
 	const struct v4l2_buffer *b = pb;
@@ -181,6 +194,7 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
 		return -EINVAL;
 	}
 	vbuf->sequence = 0;
+	vbuf->request_fd = -1;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		switch (b->memory) {
@@ -318,9 +332,12 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
 	return 0;
 }
 
-static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-				    const char *opname)
+static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *mdev,
+				    struct v4l2_buffer *b,
+				    const char *opname,
+				    struct media_request **p_req)
 {
+	struct media_request *req;
 	struct vb2_v4l2_buffer *vbuf;
 	struct vb2_buffer *vb;
 	int ret;
@@ -357,8 +374,60 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 		memset(vbuf->planes, 0,
 		       sizeof(vbuf->planes[0]) * vb->num_planes);
 		ret = vb2_fill_vb2_v4l2_buffer(vb, b);
+		if (ret)
+			return ret;
 	}
-	return ret;
+
+	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD))
+		return 0;
+
+	/*
+	 * For proper locking when queueing a request you need to be able
+	 * to lock access to the vb2 queue, so check that there is a lock
+	 * that we can use. In addition p_req must be non-NULL.
+	 */
+	if (WARN_ON(!q->lock || !p_req))
+		return -EINVAL;
+
+	/*
+	 * Make sure this op is implemented by the driver. It's easy to forget
+	 * this callback, but is it important when canceling a buffer in a
+	 * queued request.
+	 */
+	if (WARN_ON(!q->ops->buf_request_complete))
+		return -EINVAL;
+
+	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		dprintk(1, "%s: buffer is not in dequeued state\n", opname);
+		return -EINVAL;
+	}
+
+	if (b->request_fd < 0) {
+		dprintk(1, "%s: request_fd < 0\n", opname);
+		return -EINVAL;
+	}
+
+	req = media_request_get_by_fd(mdev, b->request_fd);
+	if (IS_ERR(req)) {
+		dprintk(1, "%s: invalid request_fd\n", opname);
+		return PTR_ERR(req);
+	}
+
+	/*
+	 * Early sanity check. This is checked again when the buffer
+	 * is bound to the request in vb2_core_qbuf().
+	 */
+	if (req->state != MEDIA_REQUEST_STATE_IDLE &&
+	    req->state != MEDIA_REQUEST_STATE_UPDATING) {
+		dprintk(1, "%s: request is not idle\n", opname);
+		media_request_put(req);
+		return -EBUSY;
+	}
+
+	*p_req = req;
+	vbuf->request_fd = b->request_fd;
+
+	return 0;
 }
 
 /*
@@ -442,6 +511,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 		b->flags |= V4L2_BUF_FLAG_QUEUED;
 		break;
 	case VB2_BUF_STATE_IN_REQUEST:
+		b->flags |= V4L2_BUF_FLAG_IN_REQUEST;
 		break;
 	case VB2_BUF_STATE_ERROR:
 		b->flags |= V4L2_BUF_FLAG_ERROR;
@@ -456,11 +526,17 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 		break;
 	}
 
-	if (vb->state == VB2_BUF_STATE_DEQUEUED && vb->synced && vb->prepared)
+	if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
+	     vb->state == VB2_BUF_STATE_IN_REQUEST) &&
+	    vb->synced && vb->prepared)
 		b->flags |= V4L2_BUF_FLAG_PREPARED;
 
 	if (vb2_buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
+	if (vbuf->request_fd >= 0) {
+		b->flags |= V4L2_BUF_FLAG_REQUEST_FD;
+		b->request_fd = vbuf->request_fd;
+	}
 
 	if (!q->is_output &&
 		b->flags & V4L2_BUF_FLAG_DONE &&
@@ -494,6 +570,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
 
 static const struct vb2_buf_ops v4l2_buf_ops = {
 	.verify_planes_array	= __verify_planes_array_core,
+	.init_buffer		= __init_v4l2_vb2_buffer,
 	.fill_user_buffer	= __fill_v4l2_buffer,
 	.fill_vb2_buffer	= __fill_vb2_buffer,
 	.copy_timestamp		= __copy_timestamp,
@@ -542,7 +619,8 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
-int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
+int vb2_prepare_buf(struct vb2_queue *q, struct media_device *mdev,
+		    struct v4l2_buffer *b)
 {
 	int ret;
 
@@ -551,7 +629,10 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EBUSY;
 	}
 
-	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
+	if (b->flags & V4L2_BUF_FLAG_REQUEST_FD)
+		return -EINVAL;
+
+	ret = vb2_queue_or_prepare_buf(q, mdev, b, "prepare_buf", NULL);
 
 	return ret ? ret : vb2_core_prepare_buf(q, b->index, b);
 }
@@ -611,8 +692,10 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+int vb2_qbuf(struct vb2_queue *q, struct media_device *mdev,
+	     struct v4l2_buffer *b)
 {
+	struct media_request *req = NULL;
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
@@ -620,8 +703,13 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EBUSY;
 	}
 
-	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	return ret ? ret : vb2_core_qbuf(q, b->index, b, NULL);
+	ret = vb2_queue_or_prepare_buf(q, mdev, b, "qbuf", &req);
+	if (ret)
+		return ret;
+	ret = vb2_core_qbuf(q, b->index, b, req);
+	if (req)
+		media_request_put(req);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
@@ -811,7 +899,7 @@ int vb2_ioctl_prepare_buf(struct file *file, void *priv,
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_prepare_buf(vdev->queue, p);
+	return vb2_prepare_buf(vdev->queue, vdev->v4l2_dev->mdev, p);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
 
@@ -830,7 +918,7 @@ int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_qbuf(vdev->queue, p);
+	return vb2_qbuf(vdev->queue, vdev->v4l2_dev->mdev, p);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 674e7fd3ad99..1de7b6b13f67 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -940,7 +940,7 @@ isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_qbuf(&vfh->queue, b);
+	ret = vb2_qbuf(&vfh->queue, video->video.v4l2_dev->mdev, b);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index b1d9f3857d3d..60b62ec6e9cd 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -943,7 +943,7 @@ static int s3c_camif_qbuf(struct file *file, void *priv,
 	if (vp->owner && vp->owner != priv)
 		return -EBUSY;
 
-	return vb2_qbuf(&vp->vb_queue, buf);
+	return vb2_qbuf(&vp->vb_queue, vp->vdev.v4l2_dev->mdev, buf);
 }
 
 static int s3c_camif_dqbuf(struct file *file, void *priv,
@@ -981,7 +981,7 @@ static int s3c_camif_prepare_buf(struct file *file, void *priv,
 				 struct v4l2_buffer *b)
 {
 	struct camif_vp *vp = video_drvdata(file);
-	return vb2_prepare_buf(&vp->vb_queue, b);
+	return vb2_prepare_buf(&vp->vb_queue, vp->vdev.v4l2_dev->mdev, b);
 }
 
 static int s3c_camif_g_selection(struct file *file, void *priv,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 6a3cc4f86c5d..fc0b61f1b91d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -632,9 +632,9 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 		return -EIO;
 	}
 	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_qbuf(&ctx->vq_src, buf);
+		return vb2_qbuf(&ctx->vq_src, NULL, buf);
 	else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_qbuf(&ctx->vq_dst, buf);
+		return vb2_qbuf(&ctx->vq_dst, NULL, buf);
 	return -EINVAL;
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 3ad4f5073002..9208c83aa377 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1621,9 +1621,9 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 			mfc_err("Call on QBUF after EOS command\n");
 			return -EIO;
 		}
-		return vb2_qbuf(&ctx->vq_src, buf);
+		return vb2_qbuf(&ctx->vq_src, NULL, buf);
 	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		return vb2_qbuf(&ctx->vq_dst, buf);
+		return vb2_qbuf(&ctx->vq_dst, NULL, buf);
 	}
 	return -EINVAL;
 }
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 901c07f49351..4572fea38d0b 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -394,7 +394,7 @@ static int soc_camera_qbuf(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	return vb2_qbuf(&icd->vb2_vidq, p);
+	return vb2_qbuf(&icd->vb2_vidq, NULL, p);
 }
 
 static int soc_camera_dqbuf(struct file *file, void *priv,
@@ -430,7 +430,7 @@ static int soc_camera_prepare_buf(struct file *file, void *priv,
 {
 	struct soc_camera_device *icd = file->private_data;
 
-	return vb2_prepare_buf(&icd->vb2_vidq, b);
+	return vb2_prepare_buf(&icd->vb2_vidq, NULL, b);
 }
 
 static int soc_camera_expbuf(struct file *file, void *priv,
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index fecccb5e7628..8964e16f2b22 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -300,12 +300,13 @@ int uvc_create_buffers(struct uvc_video_queue *queue,
 	return ret;
 }
 
-int uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
+int uvc_queue_buffer(struct uvc_video_queue *queue,
+		     struct media_device *mdev, struct v4l2_buffer *buf)
 {
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_qbuf(&queue->queue, buf);
+	ret = vb2_qbuf(&queue->queue, mdev, buf);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index bd32914259ae..3da5fdc002ac 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -751,7 +751,8 @@ static int uvc_ioctl_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	if (!uvc_has_privileges(handle))
 		return -EBUSY;
 
-	return uvc_queue_buffer(&stream->queue, buf);
+	return uvc_queue_buffer(&stream->queue,
+				stream->vdev.v4l2_dev->mdev, buf);
 }
 
 static int uvc_ioctl_expbuf(struct file *file, void *fh,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index be5cf179228b..bc9ed18f043c 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -680,6 +680,7 @@ int uvc_query_buffer(struct uvc_video_queue *queue,
 int uvc_create_buffers(struct uvc_video_queue *queue,
 		       struct v4l2_create_buffers *v4l2_cb);
 int uvc_queue_buffer(struct uvc_video_queue *queue,
+		     struct media_device *mdev,
 		     struct v4l2_buffer *v4l2_buf);
 int uvc_export_buffer(struct uvc_video_queue *queue,
 		      struct v4l2_exportbuffer *exp);
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 725da74d15d8..9bfe1c456046 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -409,11 +409,12 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
 int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct v4l2_buffer *buf)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct vb2_queue *vq;
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_qbuf(vq, buf);
+	ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
 	if (!ret)
 		v4l2_m2m_try_schedule(m2m_ctx);
 
@@ -434,11 +435,12 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_buffer *buf)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct vb2_queue *vq;
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_prepare_buf(vq, buf);
+	ret = vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
 	if (!ret)
 		v4l2_m2m_try_schedule(m2m_ctx);
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 4e3ec7fdc90d..6d693067a251 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1425,7 +1425,8 @@ static int vpfe_qbuf(struct file *file, void *priv,
 		return -EACCES;
 	}
 
-	return vb2_qbuf(&video->buffer_queue, p);
+	return vb2_qbuf(&video->buffer_queue,
+			video->video_dev.v4l2_dev->mdev, p);
 }
 
 /*
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index a3a83424a926..a35d1004b522 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -805,9 +805,10 @@ iss_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 static int
 iss_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
+	struct iss_video *video = video_drvdata(file);
 	struct iss_video_fh *vfh = to_iss_video_fh(fh);
 
-	return vb2_qbuf(&vfh->queue, b);
+	return vb2_qbuf(&vfh->queue, video->video.v4l2_dev->mdev, b);
 }
 
 static int
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 9e33d5206d54..f2497cb96abb 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -166,7 +166,7 @@ int uvcg_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 	unsigned long flags;
 	int ret;
 
-	ret = vb2_qbuf(&queue->queue, buf);
+	ret = vb2_qbuf(&queue->queue, NULL, buf);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 097bf3e6951d..91a2b3e1a642 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -32,6 +32,7 @@
  *		&enum v4l2_field.
  * @timecode:	frame timecode.
  * @sequence:	sequence count of this frame.
+ * @request_fd:	the request_fd associated with this buffer
  * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
  *
  * Should contain enough information to be able to cover all the fields
@@ -44,6 +45,7 @@ struct vb2_v4l2_buffer {
 	__u32			field;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
+	__s32			request_fd;
 	struct vb2_plane	planes[VB2_MAX_PLANES];
 };
 
@@ -79,6 +81,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
  * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
  *
  * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @mdev:	pointer to &struct media_device, may be NULL.
  * @b:		buffer structure passed from userspace to
  *		&v4l2_ioctl_ops->vidioc_prepare_buf handler in driver
  *
@@ -90,15 +93,19 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
  * #) verifies the passed buffer,
  * #) calls &vb2_ops->buf_prepare callback in the driver (if provided),
  *    in which driver-specific buffer initialization can be performed.
+ * #) if @b->request_fd is non-zero and @mdev->ops->req_queue is set,
+ *    then bind the prepared buffer to the request.
  *
  * The return values from this function are intended to be directly returned
  * from &v4l2_ioctl_ops->vidioc_prepare_buf handler in driver.
  */
-int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_prepare_buf(struct vb2_queue *q, struct media_device *mdev,
+		    struct v4l2_buffer *b);
 
 /**
  * vb2_qbuf() - Queue a buffer from userspace
  * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @mdev:	pointer to &struct media_device, may be NULL.
  * @b:		buffer structure passed from userspace to
  *		&v4l2_ioctl_ops->vidioc_qbuf handler in driver
  *
@@ -107,6 +114,8 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
  * This function:
  *
  * #) verifies the passed buffer;
+ * #) if @b->request_fd is non-zero and @mdev->ops->req_queue is set,
+ *    then bind the buffer to the request.
  * #) if necessary, calls &vb2_ops->buf_prepare callback in the driver
  *    (if provided), in which driver-specific buffer initialization can
  *    be performed;
@@ -116,7 +125,8 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
  * The return values from this function are intended to be directly returned
  * from &v4l2_ioctl_ops->vidioc_qbuf handler in driver.
  */
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_qbuf(struct vb2_queue *q, struct media_device *mdev,
+	     struct v4l2_buffer *b);
 
 /**
  * vb2_expbuf() - Export a buffer as a file descriptor
-- 
2.18.0
