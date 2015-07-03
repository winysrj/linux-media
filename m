Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59743 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbbGCKF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2015 06:05:27 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH] media: s5p-jpeg: Eliminate double kfree
Date: Fri, 03 Jul 2015 12:04:38 +0200
Message-id: <1435917878-27545-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video_unregister_device() calls device_unregister(), which calls
put_device(), which calls kobject_put(), and if this is the last reference
then kobject_release() is called, which calls kobject_cleanup(), which
calls ktype's release method which happens to be device_release() in this
case, which calls dev->release(), which happens to be
v4l2_device_release() in this case, which calls vdev->release(), which
happens to be video_device_release(). But video_device_release() is
called explicitly both in error recovery path of s5p_jpeg_probe() and
in s5p_jpeg_remove(). The pointers in question are not nullified between
the two calls, so this is harmful.

This patch fixes the driver so that video_device_release() is not called
twice for the same object.

Rebased onto Mauro's master.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index bfbf157..9690f9d 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2544,7 +2544,8 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	ret = video_register_device(jpeg->vfd_encoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
-		goto enc_vdev_alloc_rollback;
+		video_device_release(jpeg->vfd_encoder);
+		goto vb2_allocator_rollback;
 	}
 
 	video_set_drvdata(jpeg->vfd_encoder, jpeg);
@@ -2572,7 +2573,8 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	ret = video_register_device(jpeg->vfd_decoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
-		goto dec_vdev_alloc_rollback;
+		video_device_release(jpeg->vfd_decoder);
+		goto enc_vdev_register_rollback;
 	}
 
 	video_set_drvdata(jpeg->vfd_decoder, jpeg);
@@ -2589,15 +2591,9 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 
 	return 0;
 
-dec_vdev_alloc_rollback:
-	video_device_release(jpeg->vfd_decoder);
-
 enc_vdev_register_rollback:
 	video_unregister_device(jpeg->vfd_encoder);
 
-enc_vdev_alloc_rollback:
-	video_device_release(jpeg->vfd_encoder);
-
 vb2_allocator_rollback:
 	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
 
@@ -2622,9 +2618,7 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	pm_runtime_disable(jpeg->dev);
 
 	video_unregister_device(jpeg->vfd_decoder);
-	video_device_release(jpeg->vfd_decoder);
 	video_unregister_device(jpeg->vfd_encoder);
-	video_device_release(jpeg->vfd_encoder);
 	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
-- 
1.9.1

