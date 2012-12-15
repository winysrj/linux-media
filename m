Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:56026 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab2LOJ7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:55 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH V3 06/15] [media] marvell-ccic: add new formats support for marvell-ccic driver
Date: Sat, 15 Dec 2012 17:57:55 +0800
Message-Id: <1355565484-15791-7-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch adds the new formats support for marvell-ccic.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |  175 ++++++++++++++++++-----
 drivers/media/platform/marvell-ccic/mcam-core.h |    6 +
 2 files changed, 149 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 3cc1d0c..a679917 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -111,6 +111,30 @@ static struct mcam_format_struct {
 		.bpp		= 2,
 	},
 	{
+		.desc		= "UYVY 4:2:2",
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "YUV 4:2:2 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YUV422P,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "YUV 4:2:0 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YUV420,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_1_5X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "YVU 4:2:0 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YVU420,
+		.mbus_code	= V4L2_MBUS_FMT_YVYU8_1_5X8,
+		.bpp		= 2,
+	},
+	{
 		.desc		= "RGB 444",
 		.pixelformat	= V4L2_PIX_FMT_RGB444,
 		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
@@ -169,6 +193,12 @@ struct mcam_dma_desc {
 	u32 segment_len;
 };
 
+struct yuv_pointer_t {
+	dma_addr_t y;
+	dma_addr_t u;
+	dma_addr_t v;
+};
+
 /*
  * Our buffer type for working with videobuf2.  Note that the vb2
  * developers have decreed that struct vb2_buffer must be at the
@@ -180,6 +210,7 @@ struct mcam_vb_buffer {
 	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
 	int dma_desc_nent;		/* Number of mapped descriptors */
+	struct yuv_pointer_t yuv_p;
 };
 
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
@@ -470,6 +501,18 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
 /*
  * DMA-contiguous code.
  */
+
+static bool mcam_fmt_is_planar(__u32 pfmt)
+{
+	switch (pfmt) {
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		return true;
+	}
+	return false;
+}
+
 /*
  * Set up a contiguous buffer for the given frame.  Here also is where
  * the underrun strategy is set: if there is no buffer available, reuse
@@ -481,6 +524,8 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
 static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf;
+	struct v4l2_pix_format *fmt = &cam->pix_format;
+
 	/*
 	 * If there are no available buffers, go into single mode
 	 */
@@ -499,8 +544,13 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	}
 
 	cam->vb_bufs[frame] = buf;
-	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
-			vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
+	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
+	if (mcam_fmt_is_planar(fmt->pixelformat)) {
+		mcam_reg_write(cam, frame == 0 ?
+					REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
+		mcam_reg_write(cam, frame == 0 ?
+					REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
+	}
 }
 
 /*
@@ -658,49 +708,85 @@ static inline void mcam_sg_restart(struct mcam_camera *cam)
  */
 static void mcam_ctlr_image(struct mcam_camera *cam)
 {
-	int imgsz;
 	struct v4l2_pix_format *fmt = &cam->pix_format;
+	u32 widthy = 0, widthuv = 0, imgsz_h, imgsz_w;
+
+	cam_dbg(cam, "camera: bytesperline = %d; height = %d\n",
+		fmt->bytesperline, fmt->sizeimage / fmt->bytesperline);
+	imgsz_h = (fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK;
+	imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
+
+	switch (fmt->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+		widthy = fmt->width * 2;
+		widthuv = 0;
+		break;
+	case V4L2_PIX_FMT_JPEG:
+		imgsz_h = (fmt->sizeimage / fmt->bytesperline) << IMGSZ_V_SHIFT;
+		widthy = fmt->bytesperline;
+		widthuv = 0;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		imgsz_w = (fmt->bytesperline * 4 / 3) & IMGSZ_H_MASK;
+		widthy = fmt->width;
+		widthuv = fmt->width / 2;
+		break;
+	default:
+		widthy = fmt->bytesperline;
+		widthuv = 0;
+	}
+
+	mcam_reg_write_mask(cam, REG_IMGPITCH, widthuv << 16 | widthy,
+			IMGP_YP_MASK | IMGP_UVP_MASK);
+	mcam_reg_write(cam, REG_IMGSIZE, imgsz_h | imgsz_w);
+	mcam_reg_write(cam, REG_IMGOFFSET, 0x0);
 
-	imgsz = ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
-		(fmt->bytesperline & IMGSZ_H_MASK);
-	mcam_reg_write(cam, REG_IMGSIZE, imgsz);
-	mcam_reg_write(cam, REG_IMGOFFSET, 0);
-	/* YPITCH just drops the last two bits */
-	mcam_reg_write_mask(cam, REG_IMGPITCH, fmt->bytesperline,
-			IMGP_YP_MASK);
 	/*
 	 * Tell the controller about the image format we are using.
 	 */
-	switch (cam->pix_format.pixelformat) {
+	switch (fmt->pixelformat) {
+	case V4L2_PIX_FMT_YUV422P:
+		mcam_reg_write_mask(cam, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_PLANAR | C0_YUVE_YVYU, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		mcam_reg_write_mask(cam, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_420PL | C0_YUVE_YVYU, C0_DF_MASK);
+		break;
 	case V4L2_PIX_FMT_YUYV:
-	    mcam_reg_write_mask(cam, REG_CTRL0,
-			    C0_DF_YUV|C0_YUV_PACKED|C0_YUVE_YUYV,
-			    C0_DF_MASK);
-	    break;
-
+		mcam_reg_write_mask(cam, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_UYVY, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		mcam_reg_write_mask(cam, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_JPEG:
+		mcam_reg_write_mask(cam, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
+		break;
 	case V4L2_PIX_FMT_RGB444:
-	    mcam_reg_write_mask(cam, REG_CTRL0,
-			    C0_DF_RGB|C0_RGBF_444|C0_RGB4_XRGB,
-			    C0_DF_MASK);
+		mcam_reg_write_mask(cam, REG_CTRL0,
+			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB, C0_DF_MASK);
 		/* Alpha value? */
-	    break;
-
+		break;
 	case V4L2_PIX_FMT_RGB565:
-	    mcam_reg_write_mask(cam, REG_CTRL0,
-			    C0_DF_RGB|C0_RGBF_565|C0_RGB5_BGGR,
-			    C0_DF_MASK);
-	    break;
-
+		mcam_reg_write_mask(cam, REG_CTRL0,
+			C0_DF_RGB | C0_RGBF_565 | C0_RGB5_BGGR, C0_DF_MASK);
+		break;
 	default:
-	    cam_err(cam, "Unknown format %x\n", cam->pix_format.pixelformat);
-	    break;
+		cam_err(cam, "camera: unknown format: %#x\n", fmt->pixelformat);
+		break;
 	}
+
 	/*
 	 * Make sure it knows we want to use hsync/vsync.
 	 */
-	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
-			C0_SIFM_MASK);
-
+	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
 	/*
 	 * This field controls the generation of EOF(DVP only)
 	 */
@@ -711,7 +797,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 	}
 }
 
-
 /*
  * Configure the controller for operation; caller holds the
  * device mutex.
@@ -984,11 +1069,37 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct v4l2_pix_format *fmt = &cam->pix_format;
 	unsigned long flags;
 	int start;
+	dma_addr_t dma_handle;
+	u32 pixel_count = fmt->width * fmt->height;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
+	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
+	BUG_ON(!dma_handle);
 	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
+
+	switch (cam->pix_format.pixelformat) {
+	case V4L2_PIX_FMT_YUV422P:
+		mvb->yuv_p.y = dma_handle;
+		mvb->yuv_p.u = mvb->yuv_p.y + pixel_count;
+		mvb->yuv_p.v = mvb->yuv_p.u + pixel_count / 2;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		mvb->yuv_p.y = dma_handle;
+		mvb->yuv_p.u = mvb->yuv_p.y + pixel_count;
+		mvb->yuv_p.v = mvb->yuv_p.u + pixel_count / 4;
+		break;
+	case V4L2_PIX_FMT_YVU420:
+		mvb->yuv_p.y = dma_handle;
+		mvb->yuv_p.v = mvb->yuv_p.y + pixel_count;
+		mvb->yuv_p.u = mvb->yuv_p.v + pixel_count / 4;
+		break;
+	default:
+		mvb->yuv_p.y = dma_handle;
+	}
+
 	list_add(&mvb->queue, &cam->buffers);
 	if (cam->state == S_STREAMING && test_bit(CF_SG_RESTART, &cam->flags))
 		mcam_sg_restart(cam);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 7c42cbe..7db638f 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -234,6 +234,12 @@ int mccic_resume(struct mcam_camera *cam);
 #define REG_Y0BAR	0x00
 #define REG_Y1BAR	0x04
 #define REG_Y2BAR	0x08
+#define REG_U0BAR	0x0c
+#define REG_U1BAR	0x10
+#define REG_U2BAR	0x14
+#define REG_V0BAR	0x18
+#define REG_V1BAR	0x1C
+#define REG_V2BAR	0x20
 
 /*
  * register definitions for MIPI support
-- 
1.7.9.5

