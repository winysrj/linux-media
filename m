Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:47472 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2JSMYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 08:24:37 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MC500EF33T0ODV0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Oct 2012 21:24:36 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MC5002XE3SKU150@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Oct 2012 21:24:36 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Don't ignore return value of vb2_queue_init()
Date: Fri, 19 Oct 2012 14:24:18 +0200
Message-id: <1350649458-15065-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing checks for return value of vb2_queue_init(), after
this function has been modified recently to not throw BUG_ON().
This eliminates related compiler warnings,

drivers/media/platform/s5p-fimc/fimc-lite.c: In function fimc_lite_subdev_registered:
drivers/media/platform/s5p-fimc/fimc-lite.c:1256:16: warning: ignoring return value
of vb2_queue_init, declared with attribute warn_unused_result [-Wunused-result]
drivers/media/platform/s5p-fimc/fimc-capture.c: In function fimc_register_capture_device:
drivers/media/platform/s5p-fimc/fimc-capture.c:1739:16: warning: ignoring return value
of vb2_queue_init, declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    4 +++-
 drivers/media/platform/s5p-fimc/fimc-lite.c    |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index ae756f6..cf6cdeb 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1736,7 +1736,9 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct fimc_vid_buffer);
 
-	vb2_queue_init(q);
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto err_ent;
 
 	vid_cap->vd_pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_init(&vfd->entity, 1, &vid_cap->vd_pad, 0);
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index bfbb22c..0376cfe 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1282,7 +1282,9 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 	q->buf_struct_size = sizeof(struct flite_buffer);
 	q->drv_priv = fimc;
 
-	vb2_queue_init(q);
+	ret = vb2_queue_init(q);
+	if (ret < 0)
+		return ret;
 
 	fimc->vd_pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_init(&vfd->entity, 1, &fimc->vd_pad, 0);
-- 
1.7.9.5

