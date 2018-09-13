Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44701 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbeIMUBv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 16:01:51 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v10 3/5] media: v4l: Add definition for the Sunxi tiled NV12 format
Date: Thu, 13 Sep 2018 16:51:53 +0200
Message-Id: <20180913145155.1636-4-maxime.ripard@bootlin.com>
In-Reply-To: <20180913145155.1636-1-maxime.ripard@bootlin.com>
References: <20180913145155.1636-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

This introduces support for the Sunxi tiled NV12 format, where each
component of the YUV frame is divided into macroblocks. Hence, the size
of each plane requires specific alignment. The pixels inside each
macroblock are coded in linear order (line after line from top to
bottom).

This tiled NV12 format is used by the video engine on Allwinner
platforms: it is the default format for decoded frames (and the only
one available in the oldest supported platforms).

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/media/uapi/v4l/pixfmt-reserved.rst | 13 +++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c             |  1 +
 include/uapi/linux/videodev2.h                   |  1 +
 3 files changed, 15 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
index 38af1472a4b4..0c399858bda2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
@@ -243,7 +243,20 @@ please make a proposal on the linux-media mailing list.
 	It is an opaque intermediate format and the MDP hardware must be
 	used to convert ``V4L2_PIX_FMT_MT21C`` to ``V4L2_PIX_FMT_NV12M``,
 	``V4L2_PIX_FMT_YUV420M`` or ``V4L2_PIX_FMT_YVU420``.
+    * .. _V4L2-PIX-FMT-SUNXI-TILED-NV12:
 
+      - ``V4L2_PIX_FMT_SUNXI_TILED_NV12``
+      - 'ST12'
+      - Two-planar NV12-based format used by the video engine found on Allwinner
+	(codenamed sunxi) platforms, with 32x32 tiles for the luminance plane
+	and 32x64 tiles for the chrominance plane. The data in each tile is
+	stored in linear order, within the tile bounds. Each tile follows the
+	previous one linearly in memory (from left to right, top to bottom).
+
+	The associated buffer dimensions are aligned to match an integer number
+	of tiles, resulting in 32-aligned resolutions for the luminance plane
+	and 16-aligned resolutions for the chrominance plane (with 2x2
+	subsampling).
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 1a8feaf6c3f7..c148c44caffb 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1337,6 +1337,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_SE401:	descr = "GSPCA SE401"; break;
 		case V4L2_PIX_FMT_S5C_UYVY_JPG:	descr = "S5C73MX interleaved UYVY/JPEG"; break;
 		case V4L2_PIX_FMT_MT21C:	descr = "Mediatek Compressed Format"; break;
+		case V4L2_PIX_FMT_SUNXI_TILED_NV12: descr = "Sunxi Tiled NV12 Format"; break;
 		default:
 			WARN(1, "Unknown pixelformat 0x%08x\n", fmt->pixelformat);
 			if (fmt->description[0])
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 314ec7a5f046..7412a255d9ce 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -677,6 +677,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
 #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
 #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
+#define V4L2_PIX_FMT_SUNXI_TILED_NV12 v4l2_fourcc('S', 'T', '1', '2') /* Sunxi Tiled NV12 Format */
 
 /* 10bit raw bayer packed, 32 bytes for every 25 pixels, last LSB 6 bits unused */
 #define V4L2_PIX_FMT_IPU3_SBGGR10	v4l2_fourcc('i', 'p', '3', 'b') /* IPU3 packed 10-bit BGGR bayer */
-- 
2.17.1
