Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:33007 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab2HPJq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 05:46:29 -0400
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00BWRDTADX90@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 18:46:27 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8U00AV0DT26T80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 18:46:27 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/4] s5p-fimc: Don't allocate fimc-capture video device
 dynamically
Date: Thu, 16 Aug 2012 11:46:11 +0200
Message-id: <1345110372-11874-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1345110372-11874-1-git-send-email-s.nawrocki@samsung.com>
References: <1345110372-11874-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes potential invalid pointer de-reference, when
media_entity_cleanup() is called before video device
is unregistered.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |   28 ++++++++----------------
 drivers/media/platform/s5p-fimc/fimc-core.h    |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    6 ++---
 drivers/media/platform/s5p-fimc/fimc-reg.c     |    6 ++---
 5 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 8e413dd..5d3a70f 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -304,7 +304,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
 	vid_cap->buf_index = 0;
-	fimc_pipeline_initialize(&fimc->pipeline, &vid_cap->vfd->entity,
+	fimc_pipeline_initialize(&fimc->pipeline, &vid_cap->vfd.entity,
 				 false);
 	fimc_capture_hw_init(fimc);
 
@@ -371,7 +371,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		unsigned long size = ctx->d_frame.payload[i];
 
 		if (vb2_plane_size(vb, i) < size) {
-			v4l2_err(ctx->fimc_dev->vid_cap.vfd,
+			v4l2_err(&ctx->fimc_dev->vid_cap.vfd,
 				 "User buffer too small (%ld < %ld)\n",
 				 vb2_plane_size(vb, i), size);
 			return -EINVAL;
@@ -503,7 +503,7 @@ static int fimc_capture_open(struct file *file)
 
 	if (++fimc->vid_cap.refcnt == 1) {
 		ret = fimc_pipeline_initialize(&fimc->pipeline,
-				       &fimc->vid_cap.vfd->entity, true);
+				       &fimc->vid_cap.vfd.entity, true);
 
 		if (!ret && !fimc->vid_cap.user_subdev_api)
 			ret = fimc_capture_set_default_format(fimc);
@@ -1587,7 +1587,7 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc)
 static int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev)
 {
-	struct video_device *vfd;
+	struct video_device *vfd = &fimc->vid_cap.vfd;
 	struct fimc_vid_cap *vid_cap;
 	struct fimc_ctx *ctx;
 	struct vb2_queue *q;
@@ -1604,25 +1604,19 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	ctx->s_frame.fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
 	ctx->d_frame.fmt = ctx->s_frame.fmt;
 
-	vfd = video_device_alloc();
-	if (!vfd) {
-		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
-		goto err_vd_alloc;
-	}
-
+	memset(vfd, 0, sizeof(*vfd));
 	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.capture", fimc->id);
 
 	vfd->fops	= &fimc_capture_fops;
 	vfd->ioctl_ops	= &fimc_capture_ioctl_ops;
 	vfd->v4l2_dev	= v4l2_dev;
 	vfd->minor	= -1;
-	vfd->release	= video_device_release;
+	vfd->release	= video_device_release_empty;
 	vfd->lock	= &fimc->lock;
 
 	video_set_drvdata(vfd, fimc);
 
 	vid_cap = &fimc->vid_cap;
-	vid_cap->vfd = vfd;
 	vid_cap->active_buf_cnt = 0;
 	vid_cap->reqbufs_count  = 0;
 	vid_cap->refcnt = 0;
@@ -1660,8 +1654,6 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 err_vd:
 	media_entity_cleanup(&vfd->entity);
 err_ent:
-	video_device_release(vfd);
-err_vd_alloc:
 	kfree(ctx);
 	return ret;
 }
@@ -1691,12 +1683,10 @@ static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
 
 	fimc_unregister_m2m_device(fimc);
 
-	if (fimc->vid_cap.vfd) {
-		media_entity_cleanup(&fimc->vid_cap.vfd->entity);
-		video_unregister_device(fimc->vid_cap.vfd);
-		fimc->vid_cap.vfd = NULL;
+	if (video_is_registered(&fimc->vid_cap.vfd)) {
+		video_unregister_device(&fimc->vid_cap.vfd);
+		media_entity_cleanup(&fimc->vid_cap.vfd.entity);
 	}
-
 	kfree(fimc->vid_cap.ctx);
 	fimc->vid_cap.ctx = NULL;
 }
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 808ccc6..30f93f2 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -320,7 +320,7 @@ struct fimc_m2m_device {
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
-	struct video_device		*vfd;
+	struct video_device		vfd;
 	struct v4l2_subdev		subdev;
 	struct media_pad		vd_pad;
 	struct v4l2_mbus_framefmt	mf;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 0dd26b6..3c76bd9 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -696,7 +696,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 		if (!fmd->fimc[i])
 			continue;
 		source = &fmd->fimc[i]->vid_cap.subdev.entity;
-		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
+		sink = &fmd->fimc[i]->vid_cap.vfd.entity;
 		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
 					      sink, 0, flags);
 		if (ret)
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index 1f5dbaf..d310d9c 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -99,14 +99,12 @@ static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
 
 static inline void fimc_md_graph_lock(struct fimc_dev *fimc)
 {
-	BUG_ON(fimc->vid_cap.vfd == NULL);
-	mutex_lock(&fimc->vid_cap.vfd->entity.parent->graph_mutex);
+	mutex_lock(&fimc->vid_cap.vfd.entity.parent->graph_mutex);
 }
 
 static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
 {
-	BUG_ON(fimc->vid_cap.vfd == NULL);
-	mutex_unlock(&fimc->vid_cap.vfd->entity.parent->graph_mutex);
+	mutex_unlock(&fimc->vid_cap.vfd.entity.parent->graph_mutex);
 }
 
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
index 0e3eb9c..783408f 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
@@ -612,7 +612,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		}
 
 		if (i == ARRAY_SIZE(pix_desc)) {
-			v4l2_err(fimc->vid_cap.vfd,
+			v4l2_err(&fimc->vid_cap.vfd,
 				 "Camera color format not supported: %d\n",
 				 fimc->vid_cap.mf.code);
 			return -EINVAL;
@@ -684,7 +684,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			cfg |= FIMC_REG_CIGCTRL_CAM_JPEG;
 			break;
 		default:
-			v4l2_err(vid_cap->vfd,
+			v4l2_err(&vid_cap->vfd,
 				 "Not supported camera pixel format: %#x\n",
 				 vid_cap->mf.code);
 			return -EINVAL;
@@ -701,7 +701,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 		cfg |= FIMC_REG_CIGCTRL_CAMIF_SELWB;
 		break;
 	default:
-		v4l2_err(vid_cap->vfd, "Invalid camera bus type selected\n");
+		v4l2_err(&vid_cap->vfd, "Invalid camera bus type selected\n");
 		return -EINVAL;
 	}
 	writel(cfg, fimc->regs + FIMC_REG_CIGCTRL);
-- 
1.7.10

