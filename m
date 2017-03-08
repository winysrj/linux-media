Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47959 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdCHPku (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 10:40:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] v4l: soc-camera: Remove videobuf1 support
Date: Wed,  8 Mar 2017 17:33:27 +0200
Message-Id: <20170308153327.23954-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All remaining soc-camera drivers use videobuf2, drop support for
videobuf1.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 103 +++++--------------------
 include/media/soc_camera.h                     |  14 +---
 2 files changed, 20 insertions(+), 97 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index edd1c1de4e33..3c9421f4d8e3 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -37,18 +37,12 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-of.h>
-#include <media/videobuf-core.h>
 #include <media/videobuf2-v4l2.h>
 
 /* Default to VGA resolution */
 #define DEFAULT_WIDTH	640
 #define DEFAULT_HEIGHT	480
 
-#define is_streaming(ici, icd)				\
-	(((ici)->ops->init_videobuf) ?			\
-	 (icd)->vb_vidq.streaming :			\
-	 vb2_is_streaming(&(icd)->vb2_vidq))
-
 #define MAP_MAX_NUM 32
 static DECLARE_BITMAP(device_map, MAP_MAX_NUM);
 static LIST_HEAD(hosts);
@@ -367,23 +361,13 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 {
 	int ret;
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
-	if (ici->ops->init_videobuf) {
-		ret = videobuf_reqbufs(&icd->vb_vidq, p);
-		if (ret < 0)
-			return ret;
-
-		ret = ici->ops->reqbufs(icd, p);
-	} else {
-		ret = vb2_reqbufs(&icd->vb2_vidq, p);
-	}
-
+	ret = vb2_reqbufs(&icd->vb2_vidq, p);
 	if (!ret)
 		icd->streamer = p->count ? file : NULL;
 	return ret;
@@ -393,61 +377,44 @@ static int soc_camera_querybuf(struct file *file, void *priv,
 			       struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
-	if (ici->ops->init_videobuf)
-		return videobuf_querybuf(&icd->vb_vidq, p);
-	else
-		return vb2_querybuf(&icd->vb2_vidq, p);
+	return vb2_querybuf(&icd->vb2_vidq, p);
 }
 
 static int soc_camera_qbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	if (ici->ops->init_videobuf)
-		return videobuf_qbuf(&icd->vb_vidq, p);
-	else
-		return vb2_qbuf(&icd->vb2_vidq, p);
+	return vb2_qbuf(&icd->vb2_vidq, p);
 }
 
 static int soc_camera_dqbuf(struct file *file, void *priv,
 			    struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	if (ici->ops->init_videobuf)
-		return videobuf_dqbuf(&icd->vb_vidq, p, file->f_flags & O_NONBLOCK);
-	else
-		return vb2_dqbuf(&icd->vb2_vidq, p, file->f_flags & O_NONBLOCK);
+	return vb2_dqbuf(&icd->vb2_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
 static int soc_camera_create_bufs(struct file *file, void *priv,
 			    struct v4l2_create_buffers *create)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	int ret;
 
-	/* videobuf2 only */
-	if (ici->ops->init_videobuf)
-		return -ENOTTY;
-
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
@@ -461,24 +428,14 @@ static int soc_camera_prepare_buf(struct file *file, void *priv,
 				  struct v4l2_buffer *b)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
-	/* videobuf2 only */
-	if (ici->ops->init_videobuf)
-		return -EINVAL;
-	else
-		return vb2_prepare_buf(&icd->vb2_vidq, b);
+	return vb2_prepare_buf(&icd->vb2_vidq, b);
 }
 
 static int soc_camera_expbuf(struct file *file, void *priv,
 			     struct v4l2_exportbuffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-
-	/* videobuf2 only */
-	if (ici->ops->init_videobuf)
-		return -ENOTTY;
 
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
@@ -602,8 +559,6 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	icd->sizeimage		= pix->sizeimage;
 	icd->colorspace		= pix->colorspace;
 	icd->field		= pix->field;
-	if (ici->ops->init_videobuf)
-		icd->vb_vidq.field = pix->field;
 
 	dev_dbg(icd->pdev, "set width: %d height: %d\n",
 		icd->user_width, icd->user_height);
@@ -745,13 +700,9 @@ static int soc_camera_open(struct file *file)
 		if (ret < 0)
 			goto esfmt;
 
-		if (ici->ops->init_videobuf) {
-			ici->ops->init_videobuf(&icd->vb_vidq, icd);
-		} else {
-			ret = ici->ops->init_videobuf2(&icd->vb2_vidq, icd);
-			if (ret < 0)
-				goto einitvb;
-		}
+		ret = ici->ops->init_videobuf2(&icd->vb2_vidq, icd);
+		if (ret < 0)
+			goto einitvb;
 		v4l2_ctrl_handler_setup(&icd->ctrl_handler);
 	}
 	mutex_unlock(&ici->host_lock);
@@ -842,10 +793,7 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 
 	if (mutex_lock_interruptible(&ici->host_lock))
 		return -ERESTARTSYS;
-	if (ici->ops->init_videobuf)
-		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
-	else
-		err = vb2_mmap(&icd->vb2_vidq, vma);
+	err = vb2_mmap(&icd->vb2_vidq, vma);
 	mutex_unlock(&ici->host_lock);
 
 	dev_dbg(icd->pdev, "vma start=0x%08lx, size=%ld, ret=%d\n",
@@ -866,10 +814,7 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 		return POLLERR;
 
 	mutex_lock(&ici->host_lock);
-	if (ici->ops->init_videobuf && list_empty(&icd->vb_vidq.stream))
-		dev_err(icd->pdev, "Trying to poll with no queued buffers!\n");
-	else
-		res = ici->ops->poll(file, pt);
+	res = ici->ops->poll(file, pt);
 	mutex_unlock(&ici->host_lock);
 	return res;
 }
@@ -900,7 +845,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
-	if (is_streaming(to_soc_camera_host(icd->parent), icd)) {
+	if (vb2_is_streaming(&icd->vb2_vidq)) {
 		dev_err(icd->pdev, "S_FMT denied: queue initialised\n");
 		return -EBUSY;
 	}
@@ -971,7 +916,6 @@ static int soc_camera_streamon(struct file *file, void *priv,
 			       enum v4l2_buf_type i)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret;
 
@@ -983,12 +927,8 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	/* This calls buf_queue from host driver's videobuf_queue_ops */
-	if (ici->ops->init_videobuf)
-		ret = videobuf_streamon(&icd->vb_vidq);
-	else
-		ret = vb2_streamon(&icd->vb2_vidq, i);
-
+	/* This calls buf_queue from host driver's videobuf2_queue_ops */
+	ret = vb2_streamon(&icd->vb2_vidq, i);
 	if (!ret)
 		v4l2_subdev_call(sd, video, s_stream, 1);
 
@@ -1000,7 +940,6 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 {
 	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	int ret;
 
 	WARN_ON(priv != file->private_data);
@@ -1012,13 +951,10 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 		return -EBUSY;
 
 	/*
-	 * This calls buf_release from host driver's videobuf_queue_ops for all
+	 * This calls buf_release from host driver's videobuf2_queue_ops for all
 	 * remaining buffers. When the last buffer is freed, stop capture
 	 */
-	if (ici->ops->init_videobuf)
-		ret = videobuf_streamoff(&icd->vb_vidq);
-	else
-		ret = vb2_streamoff(&icd->vb2_vidq, i);
+	ret = vb2_streamoff(&icd->vb2_vidq, i);
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
 
@@ -1053,7 +989,7 @@ static int soc_camera_s_selection(struct file *file, void *fh,
 
 	if (s->target == V4L2_SEL_TGT_COMPOSE) {
 		/* No output size change during a running capture! */
-		if (is_streaming(ici, icd) &&
+		if (vb2_is_streaming(&icd->vb2_vidq) &&
 		    (icd->user_width != s->r.width ||
 		     icd->user_height != s->r.height))
 			return -EBUSY;
@@ -1066,7 +1002,8 @@ static int soc_camera_s_selection(struct file *file, void *fh,
 			return -EBUSY;
 	}
 
-	if (s->target == V4L2_SEL_TGT_CROP && is_streaming(ici, icd) &&
+	if (s->target == V4L2_SEL_TGT_CROP &&
+	    vb2_is_streaming(&icd->vb2_vidq) &&
 	    ici->ops->set_liveselection)
 		ret = ici->ops->set_liveselection(icd, s);
 	else
@@ -1910,9 +1847,7 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    !ici->ops->set_fmt ||
 	    !ici->ops->set_bus_param ||
 	    !ici->ops->querycap ||
-	    ((!ici->ops->init_videobuf ||
-	      !ici->ops->reqbufs) &&
-	     !ici->ops->init_videobuf2) ||
+	    !ici->ops->init_videobuf2 ||
 	    !ici->ops->poll ||
 	    !ici->v4l2_dev.dev)
 		return -EINVAL;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 1a15c3e4efd3..4d8cb0796bc6 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -17,7 +17,6 @@
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/videodev2.h>
-#include <media/videobuf-core.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
@@ -55,10 +54,7 @@ struct soc_camera_device {
 	/* Asynchronous subdevice management */
 	struct soc_camera_async_client *sasc;
 	/* video buffer queue */
-	union {
-		struct videobuf_queue vb_vidq;
-		struct vb2_queue vb2_vidq;
-	};
+	struct vb2_queue vb2_vidq;
 };
 
 /* Host supports programmable stride */
@@ -114,11 +110,8 @@ struct soc_camera_host_ops {
 	int (*set_liveselection)(struct soc_camera_device *, struct v4l2_selection *);
 	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
-	void (*init_videobuf)(struct videobuf_queue *,
-			      struct soc_camera_device *);
 	int (*init_videobuf2)(struct vb2_queue *,
 			      struct soc_camera_device *);
-	int (*reqbufs)(struct soc_camera_device *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*set_bus_param)(struct soc_camera_device *);
 	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
@@ -396,11 +389,6 @@ static inline struct soc_camera_device *soc_camera_from_vb2q(const struct vb2_qu
 	return container_of(vq, struct soc_camera_device, vb2_vidq);
 }
 
-static inline struct soc_camera_device *soc_camera_from_vbq(const struct videobuf_queue *vq)
-{
-	return container_of(vq, struct soc_camera_device, vb_vidq);
-}
-
 static inline u32 soc_camera_grp_id(const struct soc_camera_device *icd)
 {
 	return (icd->iface << 8) | (icd->devnum + 1);
-- 
Regards,

Laurent Pinchart
