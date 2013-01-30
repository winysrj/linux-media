Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3A3NZ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 08:25:27 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id B554240B98
	for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 14:25:25 +0100 (CET)
Date: Wed, 30 Jan 2013 14:25:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: fix compilation breakage in 3 drivers
Message-ID: <Pine.LNX.4.64.1301301419000.3113@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent commit broke compilation of 3 camera drivers: for PXA2x0, OMAP1
and MX1 by using a wrong pointer. Fix them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Mauro, if possible, would be nice to merge this with 
http://patchwork.linuxtv.org/patch/15990/
which is already in -next. If too late - well, bisection will be 
interesting for those 3 drivers for a few commits :)
Thanks
Guennadi

 drivers/media/platform/soc_camera/mx1_camera.c   |    2 +-
 drivers/media/platform/soc_camera/omap1_camera.c |    4 ++--
 drivers/media/platform/soc_camera/pxa_camera.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
index 4b661e8..25b2a28 100644
--- a/drivers/media/platform/soc_camera/mx1_camera.c
+++ b/drivers/media/platform/soc_camera/mx1_camera.c
@@ -372,7 +372,7 @@ static void mx1_camera_init_videobuf(struct videobuf_queue *q,
 	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, icd->parent,
 				&pcdev->lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				V4L2_FIELD_NONE,
-				sizeof(struct mx1_buffer), icd, &icd->host_lock);
+				sizeof(struct mx1_buffer), icd, &ici->host_lock);
 }
 
 static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index dcf7be8..2547bf8 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1383,12 +1383,12 @@ static void omap1_cam_init_videobuf(struct videobuf_queue *q,
 		videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
 				icd->parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd, &icd->host_lock);
+				sizeof(struct omap1_cam_buf), icd, &ici->host_lock);
 	else
 		videobuf_queue_sg_init(q, &omap1_videobuf_ops,
 				icd->parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd, &icd->host_lock);
+				sizeof(struct omap1_cam_buf), icd, &ici->host_lock);
 
 	/* use videobuf mode (auto)selected with the module parameter */
 	pcdev->vb_mode = sg_mode ? OMAP1_CAM_DMA_SG : OMAP1_CAM_DMA_CONTIG;
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 3e8a82e..395e2e0 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -842,7 +842,7 @@ static void pxa_camera_init_videobuf(struct videobuf_queue *q,
 	 */
 	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct pxa_buffer), icd, &icd->host_lock);
+				sizeof(struct pxa_buffer), icd, &ici->host_lock);
 }
 
 static u32 mclk_get_divisor(struct platform_device *pdev,
-- 
1.7.2.5

