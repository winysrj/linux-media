Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22315 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534Ab1FVSBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 14:01:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 22 Jun 2011 20:01:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 01/18] s5p-fimc: Add media entity initialization
In-reply-to: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1308765684-10677-2-git-send-email-s.nawrocki@samsung.com>
References: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add intialization of the media entities for video capture
and mem-to-mem video nodes.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   28 ++++++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-core.c    |   27 +++++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-core.h    |    4 +++
 3 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 9432ea8..2748cca 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -842,9 +842,8 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	fr->width = fr->f_width = fr->o_width = 640;
 	fr->height = fr->f_height = fr->o_height = 480;
 
-	if (!v4l2_dev->name[0])
-		snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
-			 "%s.capture", dev_name(&fimc->pdev->dev));
+	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
+		 "%s.capture", dev_name(&fimc->pdev->dev));
 
 	ret = v4l2_device_register(NULL, v4l2_dev);
 	if (ret)
@@ -856,11 +855,11 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 		goto err_v4l2_reg;
 	}
 
-	snprintf(vfd->name, sizeof(vfd->name), "%s:cap",
-		 dev_name(&fimc->pdev->dev));
+	strlcpy(vfd->name, v4l2_dev->name, sizeof(vfd->name));
 
 	vfd->fops	= &fimc_capture_fops;
 	vfd->ioctl_ops	= &fimc_capture_ioctl_ops;
+	vfd->v4l2_dev	= v4l2_dev;
 	vfd->minor	= -1;
 	vfd->release	= video_device_release;
 	vfd->lock	= &fimc->lock;
@@ -890,6 +889,11 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 
 	vb2_queue_init(q);
 
+	fimc->vid_cap.vd_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&vfd->entity, 1, &fimc->vid_cap.vd_pad, 0);
+	if (ret)
+		goto err_ent;
+
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(v4l2_dev, "Failed to register video device\n");
@@ -899,10 +903,11 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	v4l2_info(v4l2_dev,
 		  "FIMC capture driver registered as /dev/video%d\n",
 		  vfd->num);
-
 	return 0;
 
 err_vd_reg:
+	media_entity_cleanup(&vfd->entity);
+err_ent:
 	video_device_release(vfd);
 err_v4l2_reg:
 	v4l2_device_unregister(v4l2_dev);
@@ -914,10 +919,11 @@ err_info:
 
 void fimc_unregister_capture_device(struct fimc_dev *fimc)
 {
-	struct fimc_vid_cap *capture = &fimc->vid_cap;
+	struct video_device *vfd = fimc->vid_cap.vfd;
 
-	if (capture->vfd)
-		video_unregister_device(capture->vfd);
-
-	kfree(capture->ctx);
+	if (vfd) {
+		media_entity_cleanup(&vfd->entity);
+		video_unregister_device(vfd);
+	}
+	kfree(fimc->vid_cap.ctx);
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 119f170..af0d966 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1504,10 +1504,8 @@ static int fimc_register_m2m_device(struct fimc_dev *fimc)
 	pdev = fimc->pdev;
 	v4l2_dev = &fimc->m2m.v4l2_dev;
 
-	/* set name if it is empty */
-	if (!v4l2_dev->name[0])
-		snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
-			 "%s.m2m", dev_name(&pdev->dev));
+	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
+		 "%s.m2m", dev_name(&pdev->dev));
 
 	ret = v4l2_device_register(&pdev->dev, v4l2_dev);
 	if (ret)
@@ -1521,6 +1519,7 @@ static int fimc_register_m2m_device(struct fimc_dev *fimc)
 
 	vfd->fops	= &fimc_m2m_fops;
 	vfd->ioctl_ops	= &fimc_m2m_ioctl_ops;
+	vfd->v4l2_dev	= v4l2_dev;
 	vfd->minor	= -1;
 	vfd->release	= video_device_release;
 	vfd->lock	= &fimc->lock;
@@ -1538,17 +1537,22 @@ static int fimc_register_m2m_device(struct fimc_dev *fimc)
 		goto err_m2m_r2;
 	}
 
+	ret = media_entity_init(&vfd->entity, 0, NULL, 0);
+	if (ret)
+		goto err_m2m_r3;
+
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(v4l2_dev,
 			 "%s(): failed to register video device\n", __func__);
-		goto err_m2m_r3;
+		goto err_m2m_r4;
 	}
 	v4l2_info(v4l2_dev,
 		  "FIMC m2m driver registered as /dev/video%d\n", vfd->num);
 
 	return 0;
-
+err_m2m_r4:
+	media_entity_cleanup(&vfd->entity);
 err_m2m_r3:
 	v4l2_m2m_release(fimc->m2m.m2m_dev);
 err_m2m_r2:
@@ -1561,12 +1565,13 @@ err_m2m_r1:
 
 void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 {
-	if (fimc) {
-		v4l2_m2m_release(fimc->m2m.m2m_dev);
-		video_unregister_device(fimc->m2m.vfd);
+	if (fimc == NULL)
+		return;
 
-		v4l2_device_unregister(&fimc->m2m.v4l2_dev);
-	}
+	v4l2_m2m_release(fimc->m2m.m2m_dev);
+	v4l2_device_unregister(&fimc->m2m.v4l2_dev);
+	media_entity_cleanup(&fimc->m2m.vfd->entity);
+	video_unregister_device(fimc->m2m.vfd);
 }
 
 static void fimc_clk_put(struct fimc_dev *fimc)
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 21dfcac..55c1410 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -16,6 +16,8 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
+
+#include <media/media-entity.h>
 #include <media/videobuf2-core.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
@@ -298,6 +300,7 @@ struct fimc_m2m_device {
  * @vfd: video device node for camera capture mode
  * @v4l2_dev: v4l2_device struct to manage subdevs
  * @sd: pointer to camera sensor subdevice currently in use
+ * @vd_pad: fimc video capture node pad
  * @fmt: Media Bus format configured at selected image sensor
  * @pending_buf_q: the pending buffer queue head
  * @active_buf_q: the queue head of buffers scheduled in hardware
@@ -315,6 +318,7 @@ struct fimc_vid_cap {
 	struct video_device		*vfd;
 	struct v4l2_device		v4l2_dev;
 	struct v4l2_subdev		*sd;;
+	struct media_pad		vd_pad;
 	struct v4l2_mbus_framefmt	fmt;
 	struct list_head		pending_buf_q;
 	struct list_head		active_buf_q;
-- 
1.7.5.4

