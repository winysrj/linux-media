Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbbCIVY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:24:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/18] marvell-ccic: add planar support to dma-vmalloc
Date: Mon,  9 Mar 2015 22:22:19 +0100
Message-Id: <1425936143-5658-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dma-vmalloc implementation didn't support planar formats, but with
a little bit of refactoring that is easy to fix.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 94 ++++++++++++-------------
 1 file changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 0d94696..2495ab6 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -206,12 +206,6 @@ struct mcam_dma_desc {
 	u32 segment_len;
 };
 
-struct yuv_pointer_t {
-	dma_addr_t y;
-	dma_addr_t u;
-	dma_addr_t v;
-};
-
 /*
  * Our buffer type for working with videobuf2.  Note that the vb2
  * developers have decreed that struct vb2_buffer must be at the
@@ -223,7 +217,6 @@ struct mcam_vb_buffer {
 	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
 	int dma_desc_nent;		/* Number of mapped descriptors */
-	struct yuv_pointer_t yuv_p;
 };
 
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
@@ -341,6 +334,47 @@ static void mcam_disable_mipi(struct mcam_camera *mcam)
 	mcam->mipi_enabled = false;
 }
 
+static bool mcam_fmt_is_planar(__u32 pfmt)
+{
+	struct mcam_format_struct *f;
+
+	f = mcam_find_format(pfmt);
+	return f->planar;
+}
+
+static void mcam_write_yuv_bases(struct mcam_camera *cam,
+				 unsigned frame, dma_addr_t base)
+{
+	struct v4l2_pix_format *fmt = &cam->pix_format;
+	u32 pixel_count = fmt->width * fmt->height;
+	dma_addr_t y, u = 0, v = 0;
+
+	y = base;
+
+	switch (fmt->pixelformat) {
+	case V4L2_PIX_FMT_YUV422P:
+		u = y + pixel_count;
+		v = u + pixel_count / 2;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		u = y + pixel_count;
+		v = u + pixel_count / 4;
+		break;
+	case V4L2_PIX_FMT_YVU420:
+		v = y + pixel_count;
+		u = v + pixel_count / 4;
+		break;
+	default:
+		break;
+	}
+
+	mcam_reg_write(cam, REG_Y0BAR + frame * 4, y);
+	if (mcam_fmt_is_planar(fmt->pixelformat)) {
+		mcam_reg_write(cam, REG_U0BAR + frame * 4, u);
+		mcam_reg_write(cam, REG_V0BAR + frame * 4, v);
+	}
+}
+
 /* ------------------------------------------------------------------- */
 
 #ifdef MCAM_MODE_VMALLOC
@@ -411,15 +445,14 @@ static void mcam_free_dma_bufs(struct mcam_camera *cam)
 static void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 {
 	/*
-	 * Store the first two Y buffers (we aren't supporting
-	 * planar formats for now, so no UV bufs).  Then either
+	 * Store the first two YUV buffers. Then either
 	 * set the third if it exists, or tell the controller
 	 * to just use two.
 	 */
-	mcam_reg_write(cam, REG_Y0BAR, cam->dma_handles[0]);
-	mcam_reg_write(cam, REG_Y1BAR, cam->dma_handles[1]);
+	mcam_write_yuv_bases(cam, 0, cam->dma_handles[0]);
+	mcam_write_yuv_bases(cam, 1, cam->dma_handles[1]);
 	if (cam->nbufs > 2) {
-		mcam_reg_write(cam, REG_Y2BAR, cam->dma_handles[2]);
+		mcam_write_yuv_bases(cam, 2, cam->dma_handles[2]);
 		mcam_reg_clear_bit(cam, REG_CTRL1, C1_TWOBUFS);
 	} else
 		mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
@@ -514,14 +547,6 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
  * DMA-contiguous code.
  */
 
-static bool mcam_fmt_is_planar(__u32 pfmt)
-{
-	struct mcam_format_struct *f;
-
-	f = mcam_find_format(pfmt);
-	return f->planar;
-}
-
 /*
  * Set up a contiguous buffer for the given frame.  Here also is where
  * the underrun strategy is set: if there is no buffer available, reuse
@@ -533,9 +558,7 @@ static bool mcam_fmt_is_planar(__u32 pfmt)
 static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf;
-	struct v4l2_pix_format *fmt = &cam->pix_format;
 	dma_addr_t dma_handle;
-	u32 pixel_count = fmt->width * fmt->height;
 	struct vb2_buffer *vb;
 
 	/*
@@ -559,32 +582,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	vb = &buf->vb_buf;
 
 	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
-	buf->yuv_p.y = dma_handle;
-
-	switch (cam->pix_format.pixelformat) {
-	case V4L2_PIX_FMT_YUV422P:
-		buf->yuv_p.u = buf->yuv_p.y + pixel_count;
-		buf->yuv_p.v = buf->yuv_p.u + pixel_count / 2;
-		break;
-	case V4L2_PIX_FMT_YUV420:
-		buf->yuv_p.u = buf->yuv_p.y + pixel_count;
-		buf->yuv_p.v = buf->yuv_p.u + pixel_count / 4;
-		break;
-	case V4L2_PIX_FMT_YVU420:
-		buf->yuv_p.v = buf->yuv_p.y + pixel_count;
-		buf->yuv_p.u = buf->yuv_p.v + pixel_count / 4;
-		break;
-	default:
-		break;
-	}
-
-	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
-	if (mcam_fmt_is_planar(fmt->pixelformat)) {
-		mcam_reg_write(cam, frame == 0 ?
-					REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
-		mcam_reg_write(cam, frame == 0 ?
-					REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
-	}
+	mcam_write_yuv_bases(cam, frame, dma_handle);
 }
 
 /*
-- 
2.1.4

