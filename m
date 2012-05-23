Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9045 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab2EWMKs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 08:10:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4H00A0C5SH9A60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:09:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00FO15TTCC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:42 +0100 (BST)
Date: Wed, 23 May 2012 14:10:27 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv6 13/13] v4l: s5p-fimc: support for dmabuf importing
In-reply-to: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337775027-9489-14-git-send-email-t.stanislaws@samsung.com>
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-fimc with support for DMABUF importing via
V4L2_MEMORY_DMABUF memory type.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/Kconfig        |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/s5p-fimc/Kconfig b/drivers/media/video/s5p-fimc/Kconfig
index a564f7e..3106026 100644
--- a/drivers/media/video/s5p-fimc/Kconfig
+++ b/drivers/media/video/s5p-fimc/Kconfig
@@ -14,6 +14,7 @@ config VIDEO_S5P_FIMC
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
+	select DMA_SHARED_BUFFER
 	help
 	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC camera host
 	  interface and video postprocessor (FIMC and FIMC-LITE) devices.
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 3545745..cd27e33 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1609,7 +1609,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
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

