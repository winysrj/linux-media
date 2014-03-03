Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38195 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaCCHeZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 02:34:25 -0500
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 4/7] v4l: ti-vpe: Allow DMABUF buffer type support
Date: Mon, 3 Mar 2014 13:03:25 +0530
Message-ID: <1393832008-22174-5-git-send-email-archit@ti.com>
In-Reply-To: <1393832008-22174-1-git-send-email-archit@ti.com>
References: <1393832008-22174-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For OMAP and DRA7x, we generally allocate video and graphics buffers through
omapdrm since the corresponding omap-gem driver provides DMM-Tiler backed
contiguous buffers. omapdrm is a dma-buf exporter. These buffers are used by
other drivers in the video pipeline.

Add VB2_DMABUF flag to the io_modes of the vb2 output and capture queues. This
allows the driver to import dma shared buffers.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index bb275f4..915029b 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1768,7 +1768,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 
 	memset(src_vq, 0, sizeof(*src_vq));
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	src_vq->io_modes = VB2_MMAP;
+	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
 	src_vq->drv_priv = ctx;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &vpe_qops;
@@ -1781,7 +1781,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 
 	memset(dst_vq, 0, sizeof(*dst_vq));
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	dst_vq->io_modes = VB2_MMAP;
+	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
 	dst_vq->drv_priv = ctx;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &vpe_qops;
-- 
1.8.3.2

