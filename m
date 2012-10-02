Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32558 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2JBO3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 10:29:40 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB9001VGS9FFGL0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:29:40 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MB9005A7S65K790@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:29:39 +0900 (KST)
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
Subject: [PATCHv9 15/25] v4l: s5p-fimc: support for dmabuf importing
Date: Tue, 02 Oct 2012 16:27:26 +0200
Message-id: <1349188056-4886-16-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-fimc with support for DMABUF importing via
V4L2_MEMORY_DMABUF memory type.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 8e413dd..3fcaf7d 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1634,7 +1634,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	q = &fimc->vid_cap.vbq;
 	memset(q, 0, sizeof(*q));
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	q->drv_priv = fimc->vid_cap.ctx;
 	q->ops = &fimc_capture_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
-- 
1.7.9.5

