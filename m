Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0083.outbound.protection.outlook.com ([104.47.38.83]:27232
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751993AbeECCnO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:43:14 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v5 8/8] v4l: xilinx: dma: Add support for 10 bit formats
Date: Wed, 2 May 2018 19:42:53 -0700
Message-ID: <9aa9a3605e78b5a962c1b526a846ee5f3179d70a.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds xvip_format_plane_width_bytes function to
calculate number of bytes for a macropixel formats and also
adds new 10 bit pixel formats to video descriptor table.

Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
Changes in v4:
 - Introduced macropixel concept to calculate bytes for a given width for 10 bit formats

 drivers/media/platform/xilinx/xilinx-dma.c |  5 ++--
 drivers/media/platform/xilinx/xilinx-vip.c | 37 ++++++++++++++++++++++--------
 drivers/media/platform/xilinx/xilinx-vip.h |  5 ++++
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 2ffc276..89afa24 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -370,7 +370,8 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
 	}
 
 	dma->xt.frame_size = dma->fmtinfo->num_planes;
-	dma->sgl[0].size = pix_mp->width * dma->fmtinfo->bpp[0];
+	dma->sgl[0].size = xvip_fmt_plane_width_bytes(dma->fmtinfo,
+						      pix_mp->width);
 	dma->sgl[0].icg = pix_mp->plane_fmt[0].bytesperline - dma->sgl[0].size;
 	dma->xt.numf = pix_mp->height;
 	dma->sgl[0].dst_icg = 0;
@@ -591,7 +592,7 @@ __xvip_dma_try_format(struct xvip_dma *dma,
 	 * with the minimum in that case.
 	 */
 	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, align);
-	min_bpl = pix_mp->width * info->bpp[0];
+	min_bpl = xvip_fmt_plane_width_bytes(info, pix_mp->width);
 	min_bpl = roundup(min_bpl, align);
 	bpl = roundup(plane_fmt[0].bytesperline, align);
 	plane_fmt[0].bytesperline = clamp(bpl, min_bpl, max_bpl);
diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
index fb1a08f..7569f05 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.c
+++ b/drivers/media/platform/xilinx/xilinx-vip.c
@@ -28,23 +28,25 @@
 
 static const struct xvip_video_format xvip_video_formats[] = {
 	{ XVIP_VF_YUV_420, 8, NULL, MEDIA_BUS_FMT_VYYUYY8_1X24,
-	  {1, 2, 0}, V4L2_PIX_FMT_NV12, 2, 2, 2, "4:2:0, semi-planar, YUV" },
+	  {1, 2, 0}, V4L2_PIX_FMT_NV12, 2, 2, 2, 1, 1, "4:2:0, semi-planar, YUV" },
 	{ XVIP_VF_YUV_422, 8, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
-	  {2, 0, 0}, V4L2_PIX_FMT_YUYV, 1, 2, 1, "4:2:2, packed, YUYV" },
+	  {2, 0, 0}, V4L2_PIX_FMT_YUYV, 1, 2, 1, 1, 1, "4:2:2, packed, YUYV" },
 	{ XVIP_VF_YUV_444, 8, NULL, MEDIA_BUS_FMT_VUY8_1X24,
-	  {3, 0, 0}, V4L2_PIX_FMT_YUV444, 1, 1, 1, "4:4:4, packed, YUYV" },
+	  {3, 0, 0}, V4L2_PIX_FMT_YUV444, 1, 1, 1, 1, 1, "4:4:4, packed, YUYV" },
+	{ XVIP_VF_YUV_420, 10, NULL, MEDIA_BUS_FMT_VYYUYY8_1X24,
+	  {1, 2, 0}, V4L2_PIX_FMT_XV15, 2, 2, 2, 4, 3, "4:2:0, 10-bit 2-plane cont" },
 	{ XVIP_VF_RBG, 8, NULL, MEDIA_BUS_FMT_RBG888_1X24,
-	  {3, 0, 0}, V4L2_PIX_FMT_RGB24, 1, 1, 1, "24-bit RGB" },
+	  {3, 0, 0}, V4L2_PIX_FMT_RGB24, 1, 1, 1, 1, 1, "24-bit RGB" },
 	{ XVIP_VF_MONO_SENSOR, 8, "mono", MEDIA_BUS_FMT_Y8_1X8,
-	  {1, 0, 0}, V4L2_PIX_FMT_GREY, 1, 1, 1, "Greyscale 8-bit" },
+	  {1, 0, 0}, V4L2_PIX_FMT_GREY, 1, 1, 1, 1, 1, "Greyscale 8-bit" },
 	{ XVIP_VF_MONO_SENSOR, 8, "rggb", MEDIA_BUS_FMT_SRGGB8_1X8,
-	  {1, 0, 0}, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, "Bayer 8-bit RGGB" },
+	  {1, 0, 0}, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, 1, 1, "Bayer 8-bit RGGB" },
 	{ XVIP_VF_MONO_SENSOR, 8, "grbg", MEDIA_BUS_FMT_SGRBG8_1X8,
-	  {1, 0, 0}, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, "Bayer 8-bit GRBG" },
+	  {1, 0, 0}, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, 1, 1, "Bayer 8-bit GRBG" },
 	{ XVIP_VF_MONO_SENSOR, 8, "gbrg", MEDIA_BUS_FMT_SGBRG8_1X8,
-	  {1, 0, 0}, V4L2_PIX_FMT_SGBRG8, 1, 1, 1, "Bayer 8-bit GBRG" },
+	  {1, 0, 0}, V4L2_PIX_FMT_SGBRG8, 1, 1, 1, 1, 1, "Bayer 8-bit GBRG" },
 	{ XVIP_VF_MONO_SENSOR, 8, "bggr", MEDIA_BUS_FMT_SBGGR8_1X8,
-	  {1, 0, 0}, V4L2_PIX_FMT_SBGGR8, 1, 1, 1, "Bayer 8-bit BGGR" },
+	  {1, 0, 0}, V4L2_PIX_FMT_SBGGR8, 1, 1, 1, 1, 1, "Bayer 8-bit BGGR" },
 };
 
 /**
@@ -94,6 +96,23 @@ const struct xvip_video_format *xvip_get_format_by_fourcc(u32 fourcc)
 EXPORT_SYMBOL_GPL(xvip_get_format_by_fourcc);
 
 /**
+ * xvip_fmt_plane_width_bytes - bytes of the given width of the plane
+ * @info: VIP format description
+ * @width: width
+ *
+ * Return: Returns the number of bytes for given @width
+ */
+int xvip_fmt_plane_width_bytes(const struct xvip_video_format *info, u32 width)
+{
+	if (!info)
+		return 0;
+
+	return DIV_ROUND_UP(width * info->bytes_per_macropixel * info->bpp[0],
+			    info->pixels_per_macropixel);
+}
+EXPORT_SYMBOL_GPL(xvip_fmt_plane_width_bytes);
+
+/**
  * xvip_of_get_format - Parse a device tree node and return format information
  * @node: the device tree node
  *
diff --git a/drivers/media/platform/xilinx/xilinx-vip.h b/drivers/media/platform/xilinx/xilinx-vip.h
index 256efa2..f216e18 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.h
+++ b/drivers/media/platform/xilinx/xilinx-vip.h
@@ -114,6 +114,8 @@ struct xvip_device {
  * @num_planes: number of planes w.r.t. color format
  * @hsub: Horizontal sampling factor of Chroma
  * @vsub: Vertical sampling factor of Chroma
+ * @bytes_per_macropixel: Number of bytes per macro-pixel
+ * @pixels_per_macropixel: Number of pixels per macro-pixel
  * @description: format description, suitable for userspace
  */
 struct xvip_video_format {
@@ -126,12 +128,15 @@ struct xvip_video_format {
 	u8 num_planes;
 	u8 hsub;
 	u8 vsub;
+	u32 bytes_per_macropixel;
+	u32 pixels_per_macropixel;
 	const char *description;
 };
 
 const struct xvip_video_format *xvip_get_format_by_code(unsigned int code);
 const struct xvip_video_format *xvip_get_format_by_fourcc(u32 fourcc);
 const struct xvip_video_format *xvip_of_get_format(struct device_node *node);
+int xvip_fmt_plane_width_bytes(const struct xvip_video_format *info, u32 width);
 void xvip_set_format_size(struct v4l2_mbus_framefmt *format,
 			  const struct v4l2_subdev_format *fmt);
 int xvip_enum_mbus_code(struct v4l2_subdev *subdev,
-- 
2.7.4
