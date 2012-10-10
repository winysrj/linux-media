Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:61521 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2JJO53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:57:29 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00KC9MVFQ870@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:57:28 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:57:28 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv10 15/26] v4l: s5p-fimc: support for dmabuf importing
Date: Wed, 10 Oct 2012 16:46:34 +0200
Message-id: <1349880405-26049-16-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-fimc with support for DMABUF importing via
V4L2_MEMORY_DMABUF memory type.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 367efd1..246bb32 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1730,7 +1730,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	q = &fimc->vid_cap.vbq;
 	memset(q, 0, sizeof(*q));
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	q->drv_priv = fimc->vid_cap.ctx;
 	q->ops = &fimc_capture_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 4500e44..17067a7 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -622,7 +622,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	src_vq->drv_priv = ctx;
 	src_vq->ops = &fimc_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
@@ -633,7 +633,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 		return ret;
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	dst_vq->drv_priv = ctx;
 	dst_vq->ops = &fimc_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
-- 
1.7.9.5

