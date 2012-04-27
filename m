Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11061 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760016Ab2D0JxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:22 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M34002S0U2E83@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:51:50 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M340063QU4K3A@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:18 +0100 (BST)
Date: Fri, 27 Apr 2012 11:52:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 04/13] s5p-fimc: Use v4l2_subdev internal ops to register video
 nodes
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to be able to select only FIMC-LITE support, which is added
with subsequent patches, the regular FIMC support is now contained
only in fimc-core.c, fimc-m2m.c and fimc-capture.c files. The graph
and pipeline management is now solely handled in fimc-mdevice.[ch].
This means the FIMC driver can now be excluded with Kconfig option,
leaving only FIMC-LITE and allowing this driver to be reused in SoCs
that have only FIMC-LITE and no regular FIMC IP.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  142 +++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.c    |    8 +-
 drivers/media/video/s5p-fimc/fimc-core.h    |    7 +-
 drivers/media/video/s5p-fimc/fimc-m2m.c     |   17 +++-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   89 +++++++----------
 drivers/media/video/s5p-fimc/fimc-mdevice.h |    1 +
 6 files changed, 136 insertions(+), 128 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 8488089..121f101 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -988,7 +988,7 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
 			break;
 		/* Don't call FIMC subdev operation to avoid nested locking */
-		if (sd == fimc->vid_cap.subdev) {
+		if (sd == &fimc->vid_cap.subdev) {
 			struct fimc_frame *ff = &vid_cap->ctx->s_frame;
 			sink_fmt.format.width = ff->f_width;
 			sink_fmt.format.height = ff->f_height;
@@ -1484,53 +1484,6 @@ static struct v4l2_subdev_ops fimc_subdev_ops = {
 	.pad = &fimc_subdev_pad_ops,
 };
 
-static int fimc_create_capture_subdev(struct fimc_dev *fimc,
-				      struct v4l2_device *v4l2_dev)
-{
-	struct v4l2_subdev *sd;
-	int ret;
-
-	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
-	if (!sd)
-		return -ENOMEM;
-
-	v4l2_subdev_init(sd, &fimc_subdev_ops);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
-	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
-
-	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
-	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
-				fimc->vid_cap.sd_pads, 0);
-	if (ret)
-		goto me_err;
-	ret = v4l2_device_register_subdev(v4l2_dev, sd);
-	if (ret)
-		goto sd_err;
-
-	fimc->vid_cap.subdev = sd;
-	v4l2_set_subdevdata(sd, fimc);
-	sd->entity.ops = &fimc_sd_media_ops;
-	return 0;
-sd_err:
-	media_entity_cleanup(&sd->entity);
-me_err:
-	kfree(sd);
-	return ret;
-}
-
-static void fimc_destroy_capture_subdev(struct fimc_dev *fimc)
-{
-	struct v4l2_subdev *sd = fimc->vid_cap.subdev;
-
-	if (!sd)
-		return;
-	media_entity_cleanup(&sd->entity);
-	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
-	fimc->vid_cap.subdev = NULL;
-}
-
 /* Set default format at the sensor and host interface */
 static int fimc_capture_set_default_format(struct fimc_dev *fimc)
 {
@@ -1549,7 +1502,7 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc)
 }
 
 /* fimc->lock must be already initialized */
-int fimc_register_capture_device(struct fimc_dev *fimc,
+static int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev)
 {
 	struct video_device *vfd;
@@ -1567,7 +1520,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	ctx->out_path	 = FIMC_DMA;
 	ctx->state	 = FIMC_CTX_CAP;
 	ctx->s_frame.fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
-	ctx->d_frame.fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
+	ctx->d_frame.fmt = ctx->s_frame.fmt;
 
 	vfd = video_device_alloc();
 	if (!vfd) {
@@ -1575,8 +1528,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 		goto err_vd_alloc;
 	}
 
-	snprintf(vfd->name, sizeof(vfd->name), "%s.capture",
-		 dev_name(&fimc->pdev->dev));
+	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.capture", fimc->id);
 
 	vfd->fops	= &fimc_capture_fops;
 	vfd->ioctl_ops	= &fimc_capture_ioctl_ops;
@@ -1607,18 +1559,22 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 
 	vb2_queue_init(q);
 
-	fimc->vid_cap.vd_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&vfd->entity, 1, &fimc->vid_cap.vd_pad, 0);
+	vid_cap->vd_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&vfd->entity, 1, &vid_cap->vd_pad, 0);
 	if (ret)
 		goto err_ent;
-	ret = fimc_create_capture_subdev(fimc, v4l2_dev);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret)
-		goto err_sd_reg;
+		goto err_vd;
+
+	v4l2_info(v4l2_dev, "Registered %s as /dev/%s\n",
+		  vfd->name, video_device_node_name(vfd));
 
 	vfd->ctrl_handler = &ctx->ctrl_handler;
 	return 0;
 
-err_sd_reg:
+err_vd:
 	media_entity_cleanup(&vfd->entity);
 err_ent:
 	video_device_release(vfd);
@@ -1627,17 +1583,73 @@ err_vd_alloc:
 	return ret;
 }
 
-void fimc_unregister_capture_device(struct fimc_dev *fimc)
+static int fimc_capture_subdev_registered(struct v4l2_subdev *sd)
 {
-	struct video_device *vfd = fimc->vid_cap.vfd;
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+	int ret;
 
-	if (vfd) {
-		media_entity_cleanup(&vfd->entity);
-		/* Can also be called if video device was
-		   not registered */
-		video_unregister_device(vfd);
+	ret = fimc_register_m2m_device(fimc, sd->v4l2_dev);
+	if (ret)
+		return ret;
+
+	ret = fimc_register_capture_device(fimc, sd->v4l2_dev);
+	if (ret)
+		fimc_unregister_m2m_device(fimc);
+
+	return ret;
+}
+
+static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+
+	if (fimc == NULL)
+		return;
+
+	fimc_unregister_m2m_device(fimc);
+
+	if (fimc->vid_cap.vfd) {
+		media_entity_cleanup(&fimc->vid_cap.vfd->entity);
+		video_unregister_device(fimc->vid_cap.vfd);
+		fimc->vid_cap.vfd = NULL;
 	}
-	fimc_destroy_capture_subdev(fimc);
+
 	kfree(fimc->vid_cap.ctx);
 	fimc->vid_cap.ctx = NULL;
 }
+
+static const struct v4l2_subdev_internal_ops fimc_capture_sd_internal_ops = {
+	.registered = fimc_capture_subdev_registered,
+	.unregistered = fimc_capture_subdev_unregistered,
+};
+
+int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
+{
+	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
+	int ret;
+
+	v4l2_subdev_init(sd, &fimc_subdev_ops);
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
+
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
+				fimc->vid_cap.sd_pads, 0);
+	if (ret)
+		return ret;
+
+	sd->entity.ops = &fimc_sd_media_ops;
+	sd->internal_ops = &fimc_capture_sd_internal_ops;
+	v4l2_set_subdevdata(sd, fimc);
+	return 0;
+}
+
+void fimc_unregister_capture_subdev(struct fimc_dev *fimc)
+{
+	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_set_subdevdata(sd, NULL);
+}
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index b35c0a6..a733ce4 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -860,11 +860,16 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_pm;
 	}
 
+	ret = fimc_initialize_capture_subdev(fimc);
+	if (ret)
+		goto err_sd;
+
 	dev_dbg(&pdev->dev, "FIMC.%d registered successfully\n", fimc->id);
 
 	pm_runtime_put(&pdev->dev);
 	return 0;
-
+err_sd:
+	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 err_pm:
 	pm_runtime_put(&pdev->dev);
 err_clk:
@@ -951,6 +956,7 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
+	fimc_unregister_capture_subdev(fimc);
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
 	clk_disable(fimc->clock[CLK_BUS]);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index eddc370..ab38e6e 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -331,7 +331,7 @@ struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		*vfd;
-	struct v4l2_subdev		*subdev;
+	struct v4l2_subdev		subdev;
 	struct media_pad		vd_pad;
 	struct v4l2_mbus_framefmt	mf;
 	struct media_pad		sd_pads[FIMC_SD_PADS_NUM];
@@ -733,9 +733,8 @@ void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state);
 
 /* -----------------------------------------------------*/
 /* fimc-capture.c					*/
-int fimc_register_capture_device(struct fimc_dev *fimc,
-				 struct v4l2_device *v4l2_dev);
-void fimc_unregister_capture_device(struct fimc_dev *fimc);
+int fimc_initialize_capture_subdev(struct fimc_dev *fimc);
+void fimc_unregister_capture_subdev(struct fimc_dev *fimc);
 int fimc_capture_ctrls_create(struct fimc_dev *fimc);
 void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 			void *arg);
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
index 01e79f2..90cce00 100644
--- a/drivers/media/video/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -772,7 +772,7 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 	vfd->release = video_device_release;
 	vfd->lock = &fimc->lock;
 
-	snprintf(vfd->name, sizeof(vfd->name), "%s.m2m", dev_name(&pdev->dev));
+	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.m2m", fimc->id);
 	video_set_drvdata(vfd, fimc);
 
 	fimc->m2m.vfd = vfd;
@@ -784,9 +784,20 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 	}
 
 	ret = media_entity_init(&vfd->entity, 0, NULL, 0);
-	if (!ret)
-		return 0;
+	if (ret)
+		goto err_me;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto err_vd;
+
+	v4l2_info(v4l2_dev, "Registered %s as /dev/%s\n",
+		  vfd->name, video_device_node_name(vfd));
+	return 0;
 
+err_vd:
+	media_entity_cleanup(&vfd->entity);
+err_me:
 	v4l2_m2m_release(fimc->m2m.m2m_dev);
 err_init:
 	video_device_release(fimc->m2m.vfd);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 75296a6..c73b714 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -304,8 +304,9 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 static int fimc_register_callback(struct device *dev, void *p)
 {
 	struct fimc_dev *fimc = dev_get_drvdata(dev);
+	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
 	struct fimc_md *fmd = p;
-	int ret;
+	int ret = 0;
 
 	if (!fimc || !fimc->pdev)
 		return 0;
@@ -313,12 +314,14 @@ static int fimc_register_callback(struct device *dev, void *p)
 		return 0;
 
 	fmd->fimc[fimc->pdev->id] = fimc;
-	ret = fimc_register_m2m_device(fimc, &fmd->v4l2_dev);
-	if (ret)
-		return ret;
-	ret = fimc_register_capture_device(fimc, &fmd->v4l2_dev);
-	if (!ret)
-		fimc->vid_cap.user_subdev_api = fmd->user_subdev_api;
+	sd->grp_id = FIMC_GROUP_ID;
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (ret) {
+		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.%d (%d)\n",
+			 fimc->id, ret);
+	}
+
 	return ret;
 }
 
@@ -399,8 +402,7 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
 		if (fmd->fimc[i] == NULL)
 			continue;
-		fimc_unregister_m2m_device(fmd->fimc[i]);
-		fimc_unregister_capture_device(fmd->fimc[i]);
+		v4l2_device_unregister_subdev(&fmd->fimc[i]->vid_cap.subdev);
 		fmd->fimc[i] = NULL;
 	}
 	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
@@ -418,35 +420,6 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 	}
 }
 
-static int fimc_md_register_video_nodes(struct fimc_md *fmd)
-{
-	struct video_device *vdev;
-	int i, ret = 0;
-
-	for (i = 0; i < FIMC_MAX_DEVS && !ret; i++) {
-		if (!fmd->fimc[i])
-			continue;
-
-		vdev = fmd->fimc[i]->m2m.vfd;
-		if (vdev) {
-			ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
-			if (ret)
-				break;
-			v4l2_info(&fmd->v4l2_dev, "Registered %s as /dev/%s\n",
-				  vdev->name, video_device_node_name(vdev));
-		}
-
-		vdev = fmd->fimc[i]->vid_cap.vfd;
-		if (vdev == NULL)
-			continue;
-		ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
-		v4l2_info(&fmd->v4l2_dev, "Registered %s as /dev/%s\n",
-			  vdev->name, video_device_node_name(vdev));
-	}
-
-	return ret;
-}
-
 /**
  * __fimc_md_create_fimc_links - create links to all FIMC entities
  * @fmd: fimc media device
@@ -477,7 +450,7 @@ static int __fimc_md_create_fimc_links(struct fimc_md *fmd,
 			continue;
 
 		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
-		sink = &fmd->fimc[i]->vid_cap.subdev->entity;
+		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
 		ret = media_entity_create_link(source, pad, sink,
 					      FIMC_SD_PAD_SINK, flags);
 		if (ret)
@@ -586,7 +559,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
 		if (!fmd->fimc[i])
 			continue;
-		source = &fmd->fimc[i]->vid_cap.subdev->entity;
+		source = &fmd->fimc[i]->vid_cap.subdev.entity;
 		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
 		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
 					      sink, 0, flags);
@@ -815,42 +788,48 @@ static int fimc_md_probe(struct platform_device *pdev)
 	ret = media_device_register(&fmd->media_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
-		goto err2;
+		goto err_md;
 	}
 	ret = fimc_md_get_clocks(fmd);
 	if (ret)
-		goto err3;
+		goto err_clk;
 
 	fmd->user_subdev_api = false;
+
+	/* Protect the media graph while we're registering entities */
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
 	ret = fimc_md_register_platform_entities(fmd);
 	if (ret)
-		goto err3;
+		goto err_unlock;
 
 	if (pdev->dev.platform_data) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
-			goto err3;
+			goto err_unlock;
 	}
 	ret = fimc_md_create_links(fmd);
 	if (ret)
-		goto err3;
+		goto err_unlock;
 	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 	if (ret)
-		goto err3;
-	ret = fimc_md_register_video_nodes(fmd);
-	if (ret)
-		goto err3;
+		goto err_unlock;
 
 	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
-	if (!ret) {
-		platform_set_drvdata(pdev, fmd);
-		return 0;
-	}
-err3:
+	if (ret)
+		goto err_unlock;
+
+	platform_set_drvdata(pdev, fmd);
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+	return 0;
+
+err_unlock:
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+err_clk:
 	media_device_unregister(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
 	fimc_md_unregister_entities(fmd);
-err2:
+err_md:
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	return ret;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
index da37808..4f3b69c 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -24,6 +24,7 @@
 #define SENSOR_GROUP_ID		(1 << 8)
 #define CSIS_GROUP_ID		(1 << 9)
 #define WRITEBACK_GROUP_ID	(1 << 10)
+#define FIMC_GROUP_ID		(1 << 11)
 
 #define FIMC_MAX_SENSORS	8
 #define FIMC_MAX_CAMCLKS	2
-- 
1.7.10

