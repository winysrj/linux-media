Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:24482 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2HPJqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 05:46:25 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00ABJDT84OA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 18:46:24 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8U00AV0DT26T80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 18:46:23 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/4] s5p-fimc: Don't allocate fimc-lite video device structure
 dynamically
Date: Thu, 16 Aug 2012 11:46:10 +0200
Message-id: <1345110372-11874-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1345110372-11874-1-git-send-email-s.nawrocki@samsung.com>
References: <1345110372-11874-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes potential invalid pointer de-reference, when
media_entity_cleanup() is called after video_unregister_device,
and video device structure memory is already freed.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    2 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c     |   42 +++++++++--------------
 drivers/media/platform/s5p-fimc/fimc-lite.h     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c  |    2 +-
 4 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
index f996e94..09dc71e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
@@ -137,7 +137,7 @@ void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
 	}
 
 	if (i == 0 && src_pixfmt_map[i][0] != pixelcode) {
-		v4l2_err(dev->vfd,
+		v4l2_err(&dev->vfd,
 			 "Unsupported pixel code, falling back to %#08x\n",
 			 src_pixfmt_map[i][0]);
 	}
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index c5b57e8..9289008 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -374,7 +374,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		unsigned long size = fimc->payload[i];
 
 		if (vb2_plane_size(vb, i) < size) {
-			v4l2_err(fimc->vfd,
+			v4l2_err(&fimc->vfd,
 				 "User buffer too small (%ld < %ld)\n",
 				 vb2_plane_size(vb, i), size);
 			return -EINVAL;
@@ -467,7 +467,7 @@ static int fimc_lite_open(struct file *file)
 
 	if (++fimc->ref_count == 1 && fimc->out_path == FIMC_IO_DMA) {
 		ret = fimc_pipeline_initialize(&fimc->pipeline,
-					       &fimc->vfd->entity, true);
+					       &fimc->vfd.entity, true);
 		if (ret < 0) {
 			pm_runtime_put_sync(&fimc->pdev->dev);
 			fimc->ref_count--;
@@ -1215,18 +1215,14 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	struct vb2_queue *q = &fimc->vb_queue;
-	struct video_device *vfd;
+	struct video_device *vfd = &fimc->vfd;
 	int ret;
 
+	memset(vfd, 0, sizeof(*vfd));
+
 	fimc->fmt = &fimc_lite_formats[0];
 	fimc->out_path = FIMC_IO_DMA;
 
-	vfd = video_device_alloc();
-	if (!vfd) {
-		v4l2_err(sd->v4l2_dev, "Failed to allocate video device\n");
-		return -ENOMEM;
-	}
-
 	snprintf(vfd->name, sizeof(vfd->name), "fimc-lite.%d.capture",
 		 fimc->index);
 
@@ -1234,9 +1230,8 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 	vfd->ioctl_ops = &fimc_lite_ioctl_ops;
 	vfd->v4l2_dev = sd->v4l2_dev;
 	vfd->minor = -1;
-	vfd->release = video_device_release;
+	vfd->release = video_device_release_empty;
 	vfd->lock = &fimc->lock;
-	fimc->vfd = vfd;
 	fimc->ref_count = 0;
 	fimc->reqbufs_count = 0;
 
@@ -1255,24 +1250,20 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 
 	fimc->vd_pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_init(&vfd->entity, 1, &fimc->vd_pad, 0);
-	if (ret)
-		goto err;
+	if (ret < 0)
+		return ret;
 
 	video_set_drvdata(vfd, fimc);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
-	if (ret)
-		goto err_vd;
+	if (ret < 0) {
+		media_entity_cleanup(&vfd->entity);
+		return ret;
+	}
 
 	v4l2_info(sd->v4l2_dev, "Registered %s as /dev/%s\n",
 		  vfd->name, video_device_node_name(vfd));
 	return 0;
-
- err_vd:
-	media_entity_cleanup(&vfd->entity);
- err:
-	video_device_release(vfd);
-	return ret;
 }
 
 static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
@@ -1282,10 +1273,9 @@ static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
 	if (fimc == NULL)
 		return;
 
-	if (fimc->vfd) {
-		video_unregister_device(fimc->vfd);
-		media_entity_cleanup(&fimc->vfd->entity);
-		fimc->vfd = NULL;
+	if (video_is_registered(&fimc->vfd)) {
+		video_unregister_device(&fimc->vfd);
+		media_entity_cleanup(&fimc->vfd.entity);
 	}
 }
 
@@ -1515,7 +1505,7 @@ static int fimc_lite_resume(struct device *dev)
 		return 0;
 
 	INIT_LIST_HEAD(&fimc->active_buf_q);
-	fimc_pipeline_initialize(&fimc->pipeline, &fimc->vfd->entity, false);
+	fimc_pipeline_initialize(&fimc->pipeline, &fimc->vfd.entity, false);
 	fimc_lite_hw_init(fimc);
 	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
index 44424ee..9944dd3 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
@@ -132,7 +132,7 @@ struct fimc_lite {
 	struct platform_device	*pdev;
 	struct flite_variant	*variant;
 	struct v4l2_device	*v4l2_dev;
-	struct video_device	*vfd;
+	struct video_device	vfd;
 	struct v4l2_fh		fh;
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct v4l2_subdev	subdev;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index e65bb28..0dd26b6 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -591,7 +591,7 @@ static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
 		if (fimc == NULL)
 			continue;
 		source = &fimc->subdev.entity;
-		sink = &fimc->vfd->entity;
+		sink = &fimc->vfd.entity;
 		/* FIMC-LITE's subdev and video node */
 		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
 					       sink, 0, flags);
-- 
1.7.10

