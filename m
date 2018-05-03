Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0044.outbound.protection.outlook.com ([104.47.42.44]:40056
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751974AbeECCnL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:43:11 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v5 5/8] v4l: xilinx: dma: Update video format descriptor
Date: Wed, 2 May 2018 19:42:50 -0700
Message-ID: <81391061e8a383fe33a1f8f519b9ae33748de00b.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch updates video format descriptor to help information
viz., number of planes per color format and chroma sub sampling
factors.

Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
Changes in v5:
 - Added YUV420 10 bit format to video descriptor table

Changes in v4:
 - Introduced bpp (bits per pixel) per plane

 drivers/media/platform/xilinx/xilinx-dma.c | 12 ++++++------
 drivers/media/platform/xilinx/xilinx-vip.c | 18 ++++++++++--------
 drivers/media/platform/xilinx/xilinx-vip.h | 10 ++++++++--
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 727dc6e..518d572 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -366,7 +366,7 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
 	}
 
 	dma->xt.frame_size = 1;
-	dma->sgl[0].size = dma->format.width * dma->fmtinfo->bpp;
+	dma->sgl[0].size = dma->format.width * dma->fmtinfo->bpp[0];
 	dma->sgl[0].icg = dma->format.bytesperline - dma->sgl[0].size;
 	dma->xt.numf = dma->format.height;
 
@@ -569,12 +569,12 @@ __xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
 	 * the minimum and maximum values, clamp the requested width and convert
 	 * it back to pixels.
 	 */
-	align = lcm(dma->align, info->bpp);
+	align = lcm(dma->align, info->bpp[0]);
 	min_width = roundup(XVIP_DMA_MIN_WIDTH, align);
 	max_width = rounddown(XVIP_DMA_MAX_WIDTH, align);
-	width = rounddown(pix->width * info->bpp, align);
+	width = rounddown(pix->width * info->bpp[0], align);
 
-	pix->width = clamp(width, min_width, max_width) / info->bpp;
+	pix->width = clamp(width, min_width, max_width) / info->bpp[0];
 	pix->height = clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
 			    XVIP_DMA_MAX_HEIGHT);
 
@@ -582,7 +582,7 @@ __xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
 	 * line value is zero, the module doesn't support user configurable line
 	 * sizes. Override the requested value with the minimum in that case.
 	 */
-	min_bpl = pix->width * info->bpp;
+	min_bpl = pix->width * info->bpp[0];
 	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
 	bpl = rounddown(pix->bytesperline, dma->align);
 
@@ -676,7 +676,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 	dma->format.field = V4L2_FIELD_NONE;
 	dma->format.width = XVIP_DMA_DEF_WIDTH;
 	dma->format.height = XVIP_DMA_DEF_HEIGHT;
-	dma->format.bytesperline = dma->format.width * dma->fmtinfo->bpp;
+	dma->format.bytesperline = dma->format.width * dma->fmtinfo->bpp[0];
 	dma->format.sizeimage = dma->format.bytesperline * dma->format.height;
 
 	/* Initialize the media entity... */
diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
index 3112591..fb1a08f 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.c
+++ b/drivers/media/platform/xilinx/xilinx-vip.c
@@ -27,22 +27,24 @@
  */
 
 static const struct xvip_video_format xvip_video_formats[] = {
+	{ XVIP_VF_YUV_420, 8, NULL, MEDIA_BUS_FMT_VYYUYY8_1X24,
+	  {1, 2, 0}, V4L2_PIX_FMT_NV12, 2, 2, 2, "4:2:0, semi-planar, YUV" },
 	{ XVIP_VF_YUV_422, 8, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
-	  2, V4L2_PIX_FMT_YUYV, "4:2:2, packed, YUYV" },
+	  {2, 0, 0}, V4L2_PIX_FMT_YUYV, 1, 2, 1, "4:2:2, packed, YUYV" },
 	{ XVIP_VF_YUV_444, 8, NULL, MEDIA_BUS_FMT_VUY8_1X24,
-	  3, V4L2_PIX_FMT_YUV444, "4:4:4, packed, YUYV" },
+	  {3, 0, 0}, V4L2_PIX_FMT_YUV444, 1, 1, 1, "4:4:4, packed, YUYV" },
 	{ XVIP_VF_RBG, 8, NULL, MEDIA_BUS_FMT_RBG888_1X24,
-	  3, 0, NULL },
+	  {3, 0, 0}, V4L2_PIX_FMT_RGB24, 1, 1, 1, "24-bit RGB" },
 	{ XVIP_VF_MONO_SENSOR, 8, "mono", MEDIA_BUS_FMT_Y8_1X8,
-	  1, V4L2_PIX_FMT_GREY, "Greyscale 8-bit" },
+	  {1, 0, 0}, V4L2_PIX_FMT_GREY, 1, 1, 1, "Greyscale 8-bit" },
 	{ XVIP_VF_MONO_SENSOR, 8, "rggb", MEDIA_BUS_FMT_SRGGB8_1X8,
-	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit RGGB" },
+	  {1, 0, 0}, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, "Bayer 8-bit RGGB" },
 	{ XVIP_VF_MONO_SENSOR, 8, "grbg", MEDIA_BUS_FMT_SGRBG8_1X8,
-	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit GRBG" },
+	  {1, 0, 0}, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, "Bayer 8-bit GRBG" },
 	{ XVIP_VF_MONO_SENSOR, 8, "gbrg", MEDIA_BUS_FMT_SGBRG8_1X8,
-	  1, V4L2_PIX_FMT_SGBRG8, "Bayer 8-bit GBRG" },
+	  {1, 0, 0}, V4L2_PIX_FMT_SGBRG8, 1, 1, 1, "Bayer 8-bit GBRG" },
 	{ XVIP_VF_MONO_SENSOR, 8, "bggr", MEDIA_BUS_FMT_SBGGR8_1X8,
-	  1, V4L2_PIX_FMT_SBGGR8, "Bayer 8-bit BGGR" },
+	  {1, 0, 0}, V4L2_PIX_FMT_SBGGR8, 1, 1, 1, "Bayer 8-bit BGGR" },
 };
 
 /**
diff --git a/drivers/media/platform/xilinx/xilinx-vip.h b/drivers/media/platform/xilinx/xilinx-vip.h
index 42fee20..256efa2 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.h
+++ b/drivers/media/platform/xilinx/xilinx-vip.h
@@ -109,8 +109,11 @@ struct xvip_device {
  * @width: AXI4 format width in bits per component
  * @pattern: CFA pattern for Mono/Sensor formats
  * @code: media bus format code
- * @bpp: bytes per pixel (when stored in memory)
+ * @bpp: bytes per pixel is per plane
  * @fourcc: V4L2 pixel format FCC identifier
+ * @num_planes: number of planes w.r.t. color format
+ * @hsub: Horizontal sampling factor of Chroma
+ * @vsub: Vertical sampling factor of Chroma
  * @description: format description, suitable for userspace
  */
 struct xvip_video_format {
@@ -118,8 +121,11 @@ struct xvip_video_format {
 	unsigned int width;
 	const char *pattern;
 	unsigned int code;
-	unsigned int bpp;
+	unsigned int bpp[3];
 	u32 fourcc;
+	u8 num_planes;
+	u8 hsub;
+	u8 vsub;
 	const char *description;
 };
 
-- 
2.7.4
