Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:24511 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab2HPJqe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 05:46:34 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00D8EDTLHB90@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 18:46:33 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8U00AV0DT26T80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 18:46:30 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 4/4] s5p-fimc: Don't allocate fimc-m2m video device dynamically
Date: Thu, 16 Aug 2012 11:46:12 +0200
Message-id: <1345110372-11874-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1345110372-11874-1-git-send-email-s.nawrocki@samsung.com>
References: <1345110372-11874-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to to dynamically allocate struct video_device
for the M2M devices, so embed it instead in driver's private
data structure as it is done in case of fimc-capture and fimc-lite,
where it solves some bugs on cleanup paths.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    3 ++
 drivers/media/platform/s5p-fimc/fimc-core.h    |    2 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |   40 ++++++++----------------
 3 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 5d3a70f..4092388 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1663,6 +1663,9 @@ static int fimc_capture_subdev_registered(struct v4l2_subdev *sd)
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
 	int ret;
 
+	if (fimc == NULL)
+		return -ENXIO;
+
 	ret = fimc_register_m2m_device(fimc, sd->v4l2_dev);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 30f93f2..d3a3a00 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -287,7 +287,7 @@ struct fimc_frame {
  * @refcnt: the reference counter
  */
 struct fimc_m2m_device {
-	struct video_device	*vfd;
+	struct video_device	vfd;
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct fimc_ctx		*ctx;
 	int			refcnt;
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index c587011..293e602 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -370,7 +370,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
 
 	if (vb2_is_busy(vq)) {
-		v4l2_err(fimc->m2m.vfd, "queue (%d) busy\n", f->type);
+		v4l2_err(&fimc->m2m.vfd, "queue (%d) busy\n", f->type);
 		return -EBUSY;
 	}
 
@@ -507,7 +507,7 @@ static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 	int i;
 
 	if (cr->c.top < 0 || cr->c.left < 0) {
-		v4l2_err(fimc->m2m.vfd,
+		v4l2_err(&fimc->m2m.vfd,
 			"doesn't support negative values for top & left\n");
 		return -EINVAL;
 	}
@@ -577,7 +577,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 					cr->c.height, ctx->rotation);
 		}
 		if (ret) {
-			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
+			v4l2_err(&fimc->m2m.vfd, "Out of scaler range\n");
 			return -EINVAL;
 		}
 	}
@@ -666,7 +666,7 @@ static int fimc_m2m_open(struct file *file)
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
+	v4l2_fh_init(&ctx->fh, &fimc->m2m.vfd);
 	ctx->fimc_dev = fimc;
 
 	/* Default color format */
@@ -784,38 +784,26 @@ static struct v4l2_m2m_ops m2m_ops = {
 int fimc_register_m2m_device(struct fimc_dev *fimc,
 			     struct v4l2_device *v4l2_dev)
 {
-	struct video_device *vfd;
-	struct platform_device *pdev;
-	int ret = 0;
-
-	if (!fimc)
-		return -ENODEV;
+	struct video_device *vfd = &fimc->m2m.vfd;
+	int ret;
 
-	pdev = fimc->pdev;
 	fimc->v4l2_dev = v4l2_dev;
 
-	vfd = video_device_alloc();
-	if (!vfd) {
-		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
-		return -ENOMEM;
-	}
-
+	memset(vfd, 0, sizeof(*vfd));
 	vfd->fops = &fimc_m2m_fops;
 	vfd->ioctl_ops = &fimc_m2m_ioctl_ops;
 	vfd->v4l2_dev = v4l2_dev;
 	vfd->minor = -1;
-	vfd->release = video_device_release;
+	vfd->release = video_device_release_empty;
 	vfd->lock = &fimc->lock;
 
 	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.m2m", fimc->id);
 	video_set_drvdata(vfd, fimc);
 
-	fimc->m2m.vfd = vfd;
 	fimc->m2m.m2m_dev = v4l2_m2m_init(&m2m_ops);
 	if (IS_ERR(fimc->m2m.m2m_dev)) {
 		v4l2_err(v4l2_dev, "failed to initialize v4l2-m2m device\n");
-		ret = PTR_ERR(fimc->m2m.m2m_dev);
-		goto err_init;
+		return PTR_ERR(fimc->m2m.m2m_dev);
 	}
 
 	ret = media_entity_init(&vfd->entity, 0, NULL, 0);
@@ -834,8 +822,6 @@ err_vd:
 	media_entity_cleanup(&vfd->entity);
 err_me:
 	v4l2_m2m_release(fimc->m2m.m2m_dev);
-err_init:
-	video_device_release(fimc->m2m.vfd);
 	return ret;
 }
 
@@ -846,9 +832,9 @@ void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 
 	if (fimc->m2m.m2m_dev)
 		v4l2_m2m_release(fimc->m2m.m2m_dev);
-	if (fimc->m2m.vfd) {
-		media_entity_cleanup(&fimc->m2m.vfd->entity);
-		/* Can also be called if video device wasn't registered */
-		video_unregister_device(fimc->m2m.vfd);
+
+	if (video_is_registered(&fimc->m2m.vfd)) {
+		video_unregister_device(&fimc->m2m.vfd);
+		media_entity_cleanup(&fimc->m2m.vfd.entity);
 	}
 }
-- 
1.7.10

