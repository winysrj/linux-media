Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59117 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbbCIVYB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:24:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/18] marvell-ccic: add DMABUF support for all three DMA modes
Date: Mon,  9 Mar 2015 22:22:16 +0100
Message-Id: <1425936143-5658-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add VB2_DMABUF and VIDIOC_EXPBUF support. Also add VB2_USERPTR support
for the vmalloc DMA mode which was missing for no good reason.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 51b7291..a1312a5 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1255,14 +1255,14 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	vq->drv_priv = cam;
 	vq->lock = &cam->s_mutex;
 	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
 	INIT_LIST_HEAD(&cam->buffers);
 	switch (cam->buffer_mode) {
 	case B_DMA_contig:
 #ifdef MCAM_MODE_DMA_CONTIG
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_dma_contig_memops;
-		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-		vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 		cam->dma_setup = mcam_ctlr_dma_contig;
 		cam->frame_complete = mcam_dma_contig_done;
 		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
@@ -1274,8 +1274,6 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 #ifdef MCAM_MODE_DMA_SG
 		vq->ops = &mcam_vb2_sg_ops;
 		vq->mem_ops = &vb2_dma_sg_memops;
-		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-		vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 		cam->dma_setup = mcam_ctlr_dma_sg;
 		cam->frame_complete = mcam_dma_sg_done;
 		cam->vb_alloc_ctx_sg = vb2_dma_sg_init_ctx(cam->dev);
@@ -1289,8 +1287,6 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 				(unsigned long) cam);
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_vmalloc_memops;
-		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-		vq->io_modes = VB2_MMAP | VB2_READ;
 		cam->dma_setup = mcam_ctlr_dma_vmalloc;
 		cam->frame_complete = mcam_vmalloc_done;
 #endif
@@ -1579,6 +1575,7 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_querybuf	= vb2_ioctl_querybuf,
 	.vidioc_qbuf		= vb2_ioctl_qbuf,
 	.vidioc_dqbuf		= vb2_ioctl_dqbuf,
+	.vidioc_expbuf		= vb2_ioctl_expbuf,
 	.vidioc_streamon	= vb2_ioctl_streamon,
 	.vidioc_streamoff	= vb2_ioctl_streamoff,
 	.vidioc_g_parm		= mcam_vidioc_g_parm,
-- 
2.1.4

