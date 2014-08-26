Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33550 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbaHZJBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 05:01:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC v2] [media] v4l2: add V4L2 pixel format array and helper functions
Date: Tue, 26 Aug 2014 11:00:54 +0200
Message-Id: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds an array of V4L2 pixel formats and descriptions that can be
used by drivers so that each driver doesn't have to provide its own slightly
different format descriptions for VIDIOC_ENUM_FMT.

Each array entry also includes two bits per pixel values (for a single line and
one for the whole image) that can be used to determine the v4l2_pix_format
bytesperline and sizeimage values and whether the format is planar or
compressed.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Added use of DIV_ROUND_UP in v4l2_bytesperline
 - Un-inlined v4l2_sizeimage and made it use v4l2_bytesperline
   for non-planar, non-tiled formats
 - Added .planes property to struct v4l2_pixfmt for
   non-contiguous planar formats
 - Fixed Y41P, YUV410, and YVU420M pixelformat values
---
 drivers/media/v4l2-core/v4l2-common.c | 505 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-common.h           |  43 +++
 2 files changed, 548 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index ccaa38f..63b91a5 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -533,3 +533,508 @@ void v4l2_get_timestamp(struct timeval *tv)
 	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
+
+static const struct v4l2_pixfmt v4l2_pixfmts[] = {
+	{
+		.name = "8-bit RGB 3-3-2",
+		.pixelformat = V4L2_PIX_FMT_RGB332,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "16-bit RGB 4-4-4",
+		.pixelformat = V4L2_PIX_FMT_RGB444,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit ARGB 4-4-4-4",
+		.pixelformat = V4L2_PIX_FMT_ARGB444,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit XRGB 4-4-4-4",
+		.pixelformat = V4L2_PIX_FMT_XRGB444,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit RGB 5-5-5",
+		.pixelformat = V4L2_PIX_FMT_RGB555,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit ARGB 1-5-5-5",
+		.pixelformat = V4L2_PIX_FMT_ARGB555,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit XRGB 1-5-5-5",
+		.pixelformat = V4L2_PIX_FMT_XRGB555,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit RGB 5-6-5",
+		.pixelformat = V4L2_PIX_FMT_RGB565,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit RGB 5-5-5 BE",
+		.pixelformat = V4L2_PIX_FMT_RGB555X,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit RGB 5-6-5 BE",
+		.pixelformat = V4L2_PIX_FMT_RGB565X,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "18-bit BGR 6-6-6",
+		.pixelformat = V4L2_PIX_FMT_BGR666,
+		.bpp_line = 18,
+		.bpp_image = 18,
+	}, {
+		.name = "24-bit BGR 8-8-8",
+		.pixelformat = V4L2_PIX_FMT_BGR24,
+		.bpp_line = 24,
+		.bpp_image = 24,
+	}, {
+		.name = "24-bit RGB 8-8-8",
+		.pixelformat = V4L2_PIX_FMT_RGB24,
+		.bpp_line = 24,
+		.bpp_image = 24,
+	}, {
+		.name = "32-bit BGR 8-8-8-8",
+		.pixelformat = V4L2_PIX_FMT_BGR32,
+		.bpp_line = 32,
+		.bpp_image = 32,
+	}, {
+		.name = "32-bit BGRA 8-8-8-8",
+		.pixelformat = V4L2_PIX_FMT_ABGR32,
+		.bpp_line = 32,
+		.bpp_image = 32,
+	}, {
+		.name = "32-bit BGRX 8-8-8-8",
+		.pixelformat = V4L2_PIX_FMT_XBGR32,
+		.bpp_line = 32,
+		.bpp_image = 32,
+	}, {
+		.name = "32-bit RGB 8-8-8-8",
+		.pixelformat = V4L2_PIX_FMT_RGB32,
+		.bpp_line = 32,
+		.bpp_image = 32,
+	}, {
+		.name = "32-bit ARGB 8-8-8-8",
+		.pixelformat = V4L2_PIX_FMT_ARGB32,
+		.bpp_line = 32,
+		.bpp_image = 32,
+	}, {
+		.name = "32-bit XRGB 8-8-8-8",
+		.pixelformat = V4L2_PIX_FMT_XRGB32,
+		.bpp_line = 32,
+		.bpp_image = 32,
+	}, {
+		.name = "8-bit Greyscale",
+		.pixelformat = V4L2_PIX_FMT_GREY,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "4-bit Greyscale",
+		.pixelformat = V4L2_PIX_FMT_Y4,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "6-bit Greyscale",
+		.pixelformat = V4L2_PIX_FMT_Y6,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "10-bit Greyscale",
+		.pixelformat = V4L2_PIX_FMT_Y10,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "12-bit Greyscale",
+		.pixelformat = V4L2_PIX_FMT_Y12,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit Greyscale",
+		.pixelformat = V4L2_PIX_FMT_Y16,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "10-bit Greyscale (packed)",
+		.pixelformat = V4L2_PIX_FMT_Y10BPACK,
+		.bpp_line = 10,
+		.bpp_image = 10,
+	}, {
+		.name = "8-bit Palette",
+		.pixelformat = V4L2_PIX_FMT_PAL8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Chrominance UV 4-4",
+		.pixelformat = V4L2_PIX_FMT_UV8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "Planar YVU 4:1:0",
+		.pixelformat = V4L2_PIX_FMT_YVU410,
+		.bpp_line = 8,
+		.bpp_image = 9,
+	}, {
+		.name = "Planar YVU 4:2:0",
+		.pixelformat = V4L2_PIX_FMT_YVU420,
+		.bpp_line = 8,
+		.bpp_image = 12,
+	}, {
+		.name = "YUYV 4:2:2",
+		.pixelformat = V4L2_PIX_FMT_YUYV,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "YYUV 4:2:2",
+		.pixelformat = V4L2_PIX_FMT_YYUV,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "YVYU 4:2:2",
+		.pixelformat = V4L2_PIX_FMT_YVYU,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "UYVY 4:2:2",
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "VYUY 4:2:2",
+		.pixelformat = V4L2_PIX_FMT_VYUY,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "Planar YVU 4:2:2",
+		.pixelformat = V4L2_PIX_FMT_YUV422P,
+		.bpp_line = 8,
+		.bpp_image = 16,
+	}, {
+		.name = "Planar YUV 4:1:1",
+		.pixelformat = V4L2_PIX_FMT_YUV411P,
+		.bpp_line = 8,
+		.bpp_image = 12,
+	}, {
+		.name = "YUV 4:1:1 (packed)",
+		.pixelformat = V4L2_PIX_FMT_Y41P,
+		.bpp_line = 12,
+		.bpp_image = 12,
+	}, {
+		.name = "16-bit YUV 4-4-4",
+		.pixelformat = V4L2_PIX_FMT_YUV444,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit YUV 5-5-5",
+		.pixelformat = V4L2_PIX_FMT_YUV555,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "16-bit YUV 5-6-5",
+		.pixelformat = V4L2_PIX_FMT_YUV565,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "32-bit YUV 8-8-8-8",
+		.pixelformat = V4L2_PIX_FMT_YUV32,
+		.bpp_line = 32,
+		.bpp_image = 32,
+	}, {
+		.name = "Planar YUV 4:1:0",
+		.pixelformat = V4L2_PIX_FMT_YUV410,
+		.bpp_line = 8,
+		.bpp_image = 9,
+	}, {
+		.name = "Planar YUV 4:2:0",
+		.pixelformat = V4L2_PIX_FMT_YUV420,
+		.bpp_line = 8,
+		.bpp_image = 12,
+	}, {
+		.name = "8-bit dithered RGB (BTTV)",
+		.pixelformat = V4L2_PIX_FMT_HI240,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "YUV 4:2:0 (16x16 macroblocks)",
+		.pixelformat = V4L2_PIX_FMT_HM12,
+		/* bpp_line not applicable for macroblock tiled formats */
+		.bpp_image = 12,
+	}, {
+		.name = "YUV 4:2:0 (M420)",
+		.pixelformat = V4L2_PIX_FMT_M420,
+		/* bpp_line not applicable for hybrid line-interleaved planes */
+		.bpp_image = 12,
+	}, {
+		.name = "Y/CbCr 4:2:0",
+		.pixelformat = V4L2_PIX_FMT_NV12,
+		.bpp_line = 8,
+		.bpp_image = 12,
+	}, {
+		.name = "Y/CrCb 4:2:0",
+		.pixelformat = V4L2_PIX_FMT_NV21,
+		.bpp_line = 8,
+		.bpp_image = 12,
+	}, {
+		.name = "Y/CbCr 4:2:2",
+		.pixelformat = V4L2_PIX_FMT_NV16,
+		.bpp_line = 8,
+		.bpp_image = 16,
+	}, {
+		.name = "Y/CrCb 4:2:0",
+		.pixelformat = V4L2_PIX_FMT_NV61,
+		.bpp_line = 8,
+		.bpp_image = 16,
+	}, {
+		.name = "Y/CbCr 4:4:4",
+		.pixelformat = V4L2_PIX_FMT_NV24,
+		.bpp_line = 8,
+		.bpp_image = 24,
+	}, {
+		.name = "Y/CrCb 4:2:0",
+		.pixelformat = V4L2_PIX_FMT_NV42,
+		.bpp_line = 8,
+		.bpp_image = 24,
+	}, {
+		.name = "Y/CbCr 4:2:0 (non-contig.)",
+		.pixelformat = V4L2_PIX_FMT_NV12M,
+		.bpp_line = 8,
+		.bpp_image = 12,
+		.planes = 2,
+	}, {
+		.name = "Y/CrCb 4:2:0 (non-contig.)",
+		.pixelformat = V4L2_PIX_FMT_NV21M,
+		.bpp_line = 8,
+		.bpp_image = 12,
+		.planes = 2,
+	}, {
+		.name = "Y/CbCr 4:2:2 (non-contig.)",
+		.pixelformat = V4L2_PIX_FMT_NV16M,
+		.bpp_line = 8,
+		.bpp_image = 16,
+		.planes = 2,
+	}, {
+		.name = "Y/CrCb 4:2:2 (non-contig.)",
+		.pixelformat = V4L2_PIX_FMT_NV61M,
+		.bpp_line = 8,
+		.bpp_image = 16,
+		.planes = 2,
+	}, {
+		.name = "Y/CbCr 4:2:0 (64x32 MB, non-c.)",
+		.pixelformat = V4L2_PIX_FMT_NV12MT,
+		/* bpp_line not applicable for macroblock tiled formats */
+		.bpp_image = 12,
+	}, {
+		.name = "Y/CbCr 4:2:0 (16x16 MB, non-c.)",
+		.pixelformat = V4L2_PIX_FMT_NV12MT_16X16,
+		/* bpp_line not applicable for macroblock tiled formats */
+		.bpp_image = 12,
+		.planes = 2,
+	}, {
+		.name = "Planar YUV 4:2:0 (non-contig.)",
+		.pixelformat = V4L2_PIX_FMT_YUV420M,
+		.bpp_line = 8,
+		.bpp_image = 12,
+		.planes = 3,
+	}, {
+		.name = "Planar YVU 4:2:0 (non-contig.)",
+		.pixelformat = V4L2_PIX_FMT_YVU420M,
+		.bpp_line = 8,
+		.bpp_image = 12,
+		.planes = 3,
+	}, {
+		.name = "8-bit Bayer BGBG/GRGR",
+		.pixelformat = V4L2_PIX_FMT_SBGGR8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer GBGB/RGRG",
+		.pixelformat = V4L2_PIX_FMT_SGBRG8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer GRGR/BGBG",
+		.pixelformat = V4L2_PIX_FMT_SGRBG8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer RGRG/GBGB",
+		.pixelformat = V4L2_PIX_FMT_SRGGB8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "10-bit Bayer BGBG/GRGR",
+		.pixelformat = V4L2_PIX_FMT_SBGGR10,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "10-bit Bayer GBGB/RGRG",
+		.pixelformat = V4L2_PIX_FMT_SGBRG10,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "10-bit Bayer GRGR/BGBG",
+		.pixelformat = V4L2_PIX_FMT_SGRBG10,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "10-bit Bayer RGRG/GBGB",
+		.pixelformat = V4L2_PIX_FMT_SRGGB10,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "12-bit Bayer BGBG/GRGR",
+		.pixelformat = V4L2_PIX_FMT_SBGGR12,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "12-bit Bayer GBGB/RGRG",
+		.pixelformat = V4L2_PIX_FMT_SGBRG12,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "12-bit Bayer GRGR/BGBG",
+		.pixelformat = V4L2_PIX_FMT_SGRBG12,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "12-bit Bayer RGRG/GBGB",
+		.pixelformat = V4L2_PIX_FMT_SRGGB12,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "8-bit Bayer BGBG/GRGR (A-law)",
+		.pixelformat = V4L2_PIX_FMT_SBGGR10ALAW8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer GBGB/RGRG (A-law)",
+		.pixelformat = V4L2_PIX_FMT_SGBRG10ALAW8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer GRGR/BGBG (A-law)",
+		.pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer RGRG/GBGB (A-law)",
+		.pixelformat = V4L2_PIX_FMT_SRGGB10ALAW8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+
+		.name = "8-bit Bayer BGBG/GRGR (DPCM)",
+		.pixelformat = V4L2_PIX_FMT_SBGGR10DPCM8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer GBGB/RGRG (DPCM)",
+		.pixelformat = V4L2_PIX_FMT_SGBRG10DPCM8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer GRGR/BGBG (DPCM)",
+		.pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "8-bit Bayer RGRG/GBGB (DPCM)",
+		.pixelformat = V4L2_PIX_FMT_SRGGB10DPCM8,
+		.bpp_line = 8,
+		.bpp_image = 8,
+	}, {
+		.name = "16-bit Bayer BGBG/GRGR (exp.)",
+		.pixelformat = V4L2_PIX_FMT_SBGGR16,
+		.bpp_line = 16,
+		.bpp_image = 16,
+	}, {
+		.name = "Motion-JPEG",
+		.pixelformat = V4L2_PIX_FMT_MJPEG,
+	}, {
+		.name = "JFIF JPEG",
+		.pixelformat = V4L2_PIX_FMT_JPEG,
+	}, {
+		.name = "1394",
+		.pixelformat = V4L2_PIX_FMT_DV,
+	}, {
+		.name = "MPEG-1/2/4",
+		.pixelformat = V4L2_PIX_FMT_MPEG,
+	}, {
+		.name = "H.264",
+		.pixelformat = V4L2_PIX_FMT_H264,
+	}, {
+		.name = "H.264 (without start codes)",
+		.pixelformat = V4L2_PIX_FMT_H264_NO_SC,
+	}, {
+		.name = "H.264 MVC",
+		.pixelformat = V4L2_PIX_FMT_H264_MVC,
+	}, {
+		.name = "H.263",
+		.pixelformat = V4L2_PIX_FMT_H263,
+	}, {
+		.name = "MPEG-1 ES",
+		.pixelformat = V4L2_PIX_FMT_MPEG1,
+	}, {
+		.name = "MPEG-2 ES",
+		.pixelformat = V4L2_PIX_FMT_MPEG2,
+	}, {
+		.name = "MPEG-4 part 2 ES",
+		.pixelformat = V4L2_PIX_FMT_MPEG4,
+	}, {
+		.name = "Xvid",
+		.pixelformat = V4L2_PIX_FMT_XVID,
+	}, {
+		.name = "VC-1 (SMPTE 412M Annex G)",
+		.pixelformat = V4L2_PIX_FMT_VC1_ANNEX_G,
+	}, {
+		.name = "VC-1 (SMPTE 412M Annex L)",
+		.pixelformat = V4L2_PIX_FMT_VC1_ANNEX_L,
+	}, {
+		.name = "VP8",
+		.pixelformat = V4L2_PIX_FMT_VP8,
+	},
+};
+
+const struct v4l2_pixfmt *v4l2_pixfmt_by_fourcc(u32 fourcc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(v4l2_pixfmts); i++) {
+		if (v4l2_pixfmts[i].pixelformat == fourcc)
+			return v4l2_pixfmts + i;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_pixfmt_by_fourcc);
+
+int v4l2_fill_fmtdesc(struct v4l2_fmtdesc *f, u32 fourcc)
+{
+	const struct v4l2_pixfmt *fmt;
+
+	fmt = v4l2_pixfmt_by_fourcc(fourcc);
+	if (!fmt)
+		return -EINVAL;
+
+	strlcpy((char *)f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->pixelformat;
+	f->flags = (fmt->bpp_image == 0) ? V4L2_FMT_FLAG_COMPRESSED : 0;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_fill_fmtdesc);
+
+unsigned int v4l2_sizeimage(const struct v4l2_pixfmt *fmt, unsigned int width,
+			    unsigned int height)
+{
+	if (fmt->bpp_image == fmt->bpp_line)
+		return height * v4l2_bytesperline(fmt, width);
+	else
+		return height * width * fmt->bpp_image / 8;
+}
+EXPORT_SYMBOL_GPL(v4l2_sizeimage);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 48f9748..dbf7ea4 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -26,6 +26,7 @@
 #ifndef V4L2_COMMON_H_
 #define V4L2_COMMON_H_
 
+#include <linux/kernel.h>
 #include <media/v4l2-dev.h>
 
 /* Common printk constucts for v4l-i2c drivers. These macros create a unique
@@ -204,4 +205,46 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 
 void v4l2_get_timestamp(struct timeval *tv);
 
+/**
+ * struct v4l2_pixfmt - internal V4L2 pixel format description
+ * @name: format description to be returned by enum_fmt
+ * @pixelformat: v4l2 pixel format fourcc
+ * @bpp_line: bits per pixel, averaged over a line (of the first plane
+ *            for planar formats), used to calculate bytesperline.
+ *            Zero for compressed and macroblock tiled formats.
+ * @bpp_image: bits per pixel, averaged over the whole image. This is used to
+ *             calculate sizeimage for uncompressed formats.
+ *             Zero for compressed formats.
+ * @planes: number of non-contiguous planes for multiplanar formats.
+ *          Zero for contiguous formats.
+ */
+struct v4l2_pixfmt {
+	const char	*name;
+	u32		pixelformat;
+	u8		bpp_line;
+	u8		bpp_image;
+	u8		planes;
+};
+
+const struct v4l2_pixfmt *v4l2_pixfmt_by_fourcc(u32 fourcc);
+int v4l2_fill_fmtdesc(struct v4l2_fmtdesc *f, u32 fourcc);
+unsigned int v4l2_sizeimage(const struct v4l2_pixfmt *fmt, unsigned int width,
+			    unsigned int height);
+
+static inline unsigned int v4l2_bytesperline(const struct v4l2_pixfmt *fmt,
+					     unsigned int width)
+{
+	return DIV_ROUND_UP(width * fmt->bpp_line, 8);
+}
+
+static inline bool v4l2_pixfmt_is_planar(const struct v4l2_pixfmt *fmt)
+{
+	return fmt->bpp_line && (fmt->bpp_line != fmt->bpp_image);
+}
+
+static inline bool v4l2_pixfmt_is_compressed(const struct v4l2_pixfmt *fmt)
+{
+	return fmt->bpp_image == 0;
+}
+
 #endif /* V4L2_COMMON_H_ */
-- 
2.1.0.rc1

