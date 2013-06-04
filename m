Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:41505 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359Ab3FDF6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 01:58:06 -0400
Message-ID: <1370325463.26072.31.camel@younglee-desktop>
Subject: [PATCH 5/7] marvell-ccic: add new formats support for marvell-ccic
 driver
From: lbyang <lbyang@marvell.com>
Reply-To: <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>, <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <lbyang@marvell.com>,
	<albert.v.wang@gmail.com>
Date: Tue, 4 Jun 2013 13:57:43 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch adds the new formats support for marvell-ccic.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |  192 +++++++++++++++++++----
 drivers/media/platform/marvell-ccic/mcam-core.h |    6 +
 2 files changed, 165 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 19404ff..546f096 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -103,6 +103,7 @@ static struct mcam_format_struct {
 	__u8 *desc;
 	__u32 pixelformat;
 	int bpp;   /* Bytes per pixel */
+	bool planar;
 	enum v4l2_mbus_pixelcode mbus_code;
 } mcam_formats[] = {
 	{
@@ -110,24 +111,56 @@ static struct mcam_format_struct {
 		.pixelformat	= V4L2_PIX_FMT_YUYV,
 		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
+		.planar		= false,
+	},
+	{
+		.desc		= "UYVY 4:2:2",
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.bpp		= 2,
+		.planar		= false,
+	},
+	{
+		.desc		= "YUV 4:2:2 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YUV422P,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.bpp		= 2,
+		.planar		= true,
+	},
+	{
+		.desc		= "YUV 4:2:0 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YUV420,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.bpp		= 2,
+		.planar		= true,
+	},
+	{
+		.desc		= "YVU 4:2:0 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YVU420,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.bpp		= 2,
+		.planar		= true,
 	},
 	{
 		.desc		= "RGB 444",
 		.pixelformat	= V4L2_PIX_FMT_RGB444,
 		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
 		.bpp		= 2,
+		.planar		= false,
 	},
 	{
 		.desc		= "RGB 565",
 		.pixelformat	= V4L2_PIX_FMT_RGB565,
 		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
 		.bpp		= 2,
+		.planar		= false,
 	},
 	{
 		.desc		= "Raw RGB Bayer",
 		.pixelformat	= V4L2_PIX_FMT_SBGGR8,
 		.mbus_code	= V4L2_MBUS_FMT_SBGGR8_1X8,
-		.bpp		= 1
+		.bpp		= 1,
+		.planar		= false,
 	},
 };
 #define N_MCAM_FMTS ARRAY_SIZE(mcam_formats)
@@ -170,6 +203,12 @@ struct mcam_dma_desc {
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
@@ -181,6 +220,7 @@ struct mcam_vb_buffer {
 	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
 	int dma_desc_nent;		/* Number of mapped descriptors */
+	struct yuv_pointer_t yuv_p;
 };
 
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
@@ -466,6 +506,15 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
 /*
  * DMA-contiguous code.
  */
+
+static bool mcam_fmt_is_planar(__u32 pfmt)
+{
+	struct mcam_format_struct *f;
+
+	f = mcam_find_format(pfmt);
+	return f->planar;
+}
+
 /*
  * Set up a contiguous buffer for the given frame.  Here also is where
  * the underrun strategy is set: if there is no buffer available, reuse
@@ -477,6 +526,11 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
 static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf;
+	struct v4l2_pix_format *fmt = &cam->pix_format;
+	dma_addr_t dma_handle;
+	u32 pixel_count = fmt->width * fmt->height;
+	struct vb2_buffer *vb;
+
 	/*
 	 * If there are no available buffers, go into single mode
 	 */
@@ -495,8 +549,35 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	}
 
 	cam->vb_bufs[frame] = buf;
-	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
-			vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
+	vb = &buf->vb_buf;
+
+	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
+	buf->yuv_p.y = dma_handle;
+
+	switch (cam->pix_format.pixelformat) {
+	case V4L2_PIX_FMT_YUV422P:
+		buf->yuv_p.u = buf->yuv_p.y + pixel_count;
+		buf->yuv_p.v = buf->yuv_p.u + pixel_count / 2;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		buf->yuv_p.u = buf->yuv_p.y + pixel_count;
+		buf->yuv_p.v = buf->yuv_p.u + pixel_count / 4;
+		break;
+	case V4L2_PIX_FMT_YVU420:
+		buf->yuv_p.v = buf->yuv_p.y + pixel_count;
+		buf->yuv_p.u = buf->yuv_p.v + pixel_count / 4;
+		break;
+	default:
+		break;
+	}
+
+	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
+	if (mcam_fmt_is_planar(fmt->pixelformat)) {
+		mcam_reg_write(cam, frame == 0 ?
+					REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
+		mcam_reg_write(cam, frame == 0 ?
+					REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
+	}
 }
 
 /*
@@ -654,49 +735,84 @@ static inline void mcam_sg_restart(struct mcam_camera *cam)
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
+	imgsz_w = (fmt->width * 2) & IMGSZ_H_MASK;
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
@@ -1171,6 +1287,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 #ifdef MCAM_MODE_DMA_CONTIG
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_dma_contig_memops;
+		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
 		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
 		vq->io_modes = VB2_MMAP | VB2_USERPTR;
 		cam->dma_setup = mcam_ctlr_dma_contig;
@@ -1181,6 +1298,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 #ifdef MCAM_MODE_DMA_SG
 		vq->ops = &mcam_vb2_sg_ops;
 		vq->mem_ops = &vb2_dma_sg_memops;
+		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
 		vq->io_modes = VB2_MMAP | VB2_USERPTR;
 		cam->dma_setup = mcam_ctlr_dma_sg;
 		cam->frame_complete = mcam_dma_sg_done;
@@ -1331,7 +1449,15 @@ static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
 	mutex_unlock(&cam->s_mutex);
 	v4l2_fill_pix_format(pix, &mbus_fmt);
-	pix->bytesperline = pix->width * f->bpp;
+	switch (f->pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		pix->bytesperline = pix->width * 3 / 2;
+		break;
+	default:
+		pix->bytesperline = pix->width * f->bpp;
+		break;
+	}
 	pix->sizeimage = pix->height * pix->bytesperline;
 	return ret;
 }
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index ab5e829c9..b7feeb3 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -239,6 +239,12 @@ int mccic_resume(struct mcam_camera *cam);
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



