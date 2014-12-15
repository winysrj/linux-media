Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60588 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaLOQ05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 11:26:57 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v2 2/3] yavta: Update headers from upstream kernel
Date: Mon, 15 Dec 2014 18:26:48 +0200
Message-Id: <1418660809-30548-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1418660809-30548-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1418660809-30548-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include packed raw 10-bit definitions as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/linux/v4l2-common.h   |   2 +
 include/linux/v4l2-controls.h |   6 +++
 include/linux/videodev2.h     | 121 +++++++++++++++++++++++++++++++++++-------
 3 files changed, 111 insertions(+), 18 deletions(-)

diff --git a/include/linux/v4l2-common.h b/include/linux/v4l2-common.h
index 2f6f8ca..1527398 100644
--- a/include/linux/v4l2-common.h
+++ b/include/linux/v4l2-common.h
@@ -43,6 +43,8 @@
 #define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
 /* Cropping bounds */
 #define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
+/* Native frame size */
+#define V4L2_SEL_TGT_NATIVE_SIZE	0x0003
 /* Current composing area */
 #define V4L2_SEL_TGT_COMPOSE		0x0100
 /* Default composing area */
diff --git a/include/linux/v4l2-controls.h b/include/linux/v4l2-controls.h
index e946e43..661f119 100644
--- a/include/linux/v4l2-controls.h
+++ b/include/linux/v4l2-controls.h
@@ -746,6 +746,8 @@ enum v4l2_auto_focus_range {
 	V4L2_AUTO_FOCUS_RANGE_INFINITY		= 3,
 };
 
+#define V4L2_CID_PAN_SPEED			(V4L2_CID_CAMERA_CLASS_BASE+32)
+#define V4L2_CID_TILT_SPEED			(V4L2_CID_CAMERA_CLASS_BASE+33)
 
 /* FM Modulator class control IDs */
 
@@ -865,6 +867,10 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_VBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 1)
 #define V4L2_CID_HBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
 #define V4L2_CID_ANALOGUE_GAIN			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 3)
+#define V4L2_CID_TEST_PATTERN_RED		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 4)
+#define V4L2_CID_TEST_PATTERN_GREENR		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 5)
+#define V4L2_CID_TEST_PATTERN_BLUE		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 6)
+#define V4L2_CID_TEST_PATTERN_GREENB		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 7)
 
 
 /* Image processing controls */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 87b83c3..14e2129 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -77,6 +77,7 @@
 /*  Four-character-code (FOURCC) */
 #define v4l2_fourcc(a, b, c, d)\
 	((__u32)(a) | ((__u32)(b) << 8) | ((__u32)(c) << 16) | ((__u32)(d) << 24))
+#define v4l2_fourcc_be(a, b, c, d)	(v4l2_fourcc(a, b, c, d) | (1 << 31))
 
 /*
  *	E N U M S
@@ -175,30 +176,103 @@ enum v4l2_memory {
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
 enum v4l2_colorspace {
-	/* ITU-R 601 -- broadcast NTSC/PAL */
+	/* SMPTE 170M: used for broadcast NTSC/PAL SDTV */
 	V4L2_COLORSPACE_SMPTE170M     = 1,
 
-	/* 1125-Line (US) HDTV */
+	/* Obsolete pre-1998 SMPTE 240M HDTV standard, superseded by Rec 709 */
 	V4L2_COLORSPACE_SMPTE240M     = 2,
 
-	/* HD and modern captures. */
+	/* Rec.709: used for HDTV */
 	V4L2_COLORSPACE_REC709        = 3,
 
-	/* broken BT878 extents (601, luma range 16-253 instead of 16-235) */
+	/*
+	 * Deprecated, do not use. No driver will ever return this. This was
+	 * based on a misunderstanding of the bt878 datasheet.
+	 */
 	V4L2_COLORSPACE_BT878         = 4,
 
-	/* These should be useful.  Assume 601 extents. */
+	/*
+	 * NTSC 1953 colorspace. This only makes sense when dealing with
+	 * really, really old NTSC recordings. Superseded by SMPTE 170M.
+	 */
 	V4L2_COLORSPACE_470_SYSTEM_M  = 5,
+
+	/*
+	 * EBU Tech 3213 PAL/SECAM colorspace. This only makes sense when
+	 * dealing with really old PAL/SECAM recordings. Superseded by
+	 * SMPTE 170M.
+	 */
 	V4L2_COLORSPACE_470_SYSTEM_BG = 6,
 
-	/* I know there will be cameras that send this.  So, this is
-	 * unspecified chromaticities and full 0-255 on each of the
-	 * Y'CbCr components
+	/*
+	 * Effectively shorthand for V4L2_COLORSPACE_SRGB, V4L2_YCBCR_ENC_601
+	 * and V4L2_QUANTIZATION_FULL_RANGE. To be used for (Motion-)JPEG.
 	 */
 	V4L2_COLORSPACE_JPEG          = 7,
 
-	/* For RGB colourspaces, this is probably a good start. */
+	/* For RGB colorspaces such as produces by most webcams. */
 	V4L2_COLORSPACE_SRGB          = 8,
+
+	/* AdobeRGB colorspace */
+	V4L2_COLORSPACE_ADOBERGB      = 9,
+
+	/* BT.2020 colorspace, used for UHDTV. */
+	V4L2_COLORSPACE_BT2020        = 10,
+};
+
+enum v4l2_ycbcr_encoding {
+	/*
+	 * Mapping of V4L2_YCBCR_ENC_DEFAULT to actual encodings for the
+	 * various colorspaces:
+	 *
+	 * V4L2_COLORSPACE_SMPTE170M, V4L2_COLORSPACE_470_SYSTEM_M,
+	 * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_ADOBERGB and
+	 * V4L2_COLORSPACE_JPEG: V4L2_YCBCR_ENC_601
+	 *
+	 * V4L2_COLORSPACE_REC709: V4L2_YCBCR_ENC_709
+	 *
+	 * V4L2_COLORSPACE_SRGB: V4L2_YCBCR_ENC_SYCC
+	 *
+	 * V4L2_COLORSPACE_BT2020: V4L2_YCBCR_ENC_BT2020
+	 *
+	 * V4L2_COLORSPACE_SMPTE240M: V4L2_YCBCR_ENC_SMPTE240M
+	 */
+	V4L2_YCBCR_ENC_DEFAULT        = 0,
+
+	/* ITU-R 601 -- SDTV */
+	V4L2_YCBCR_ENC_601            = 1,
+
+	/* Rec. 709 -- HDTV */
+	V4L2_YCBCR_ENC_709            = 2,
+
+	/* ITU-R 601/EN 61966-2-4 Extended Gamut -- SDTV */
+	V4L2_YCBCR_ENC_XV601          = 3,
+
+	/* Rec. 709/EN 61966-2-4 Extended Gamut -- HDTV */
+	V4L2_YCBCR_ENC_XV709          = 4,
+
+	/* sYCC (Y'CbCr encoding of sRGB) */
+	V4L2_YCBCR_ENC_SYCC           = 5,
+
+	/* BT.2020 Non-constant Luminance Y'CbCr */
+	V4L2_YCBCR_ENC_BT2020         = 6,
+
+	/* BT.2020 Constant Luminance Y'CbcCrc */
+	V4L2_YCBCR_ENC_BT2020_CONST_LUM = 7,
+
+	/* SMPTE 240M -- Obsolete HDTV */
+	V4L2_YCBCR_ENC_SMPTE240M      = 8,
+};
+
+enum v4l2_quantization {
+	/*
+	 * The default for R'G'B' quantization is always full range. For
+	 * Y'CbCr the quantization is always limited range, except for
+	 * SYCC, XV601, XV709 or JPEG: those are full range.
+	 */
+	V4L2_QUANTIZATION_DEFAULT     = 0,
+	V4L2_QUANTIZATION_FULL_RANGE  = 1,
+	V4L2_QUANTIZATION_LIM_RANGE   = 2,
 };
 
 enum v4l2_priority {
@@ -291,6 +365,8 @@ struct v4l2_pix_format {
 	__u32			colorspace;	/* enum v4l2_colorspace */
 	__u32			priv;		/* private data, depends on pixelformat */
 	__u32			flags;		/* format flags (V4L2_PIX_FMT_FLAG_*) */
+	__u32			ycbcr_enc;	/* enum v4l2_ycbcr_encoding */
+	__u32			quantization;	/* enum v4l2_quantization */
 };
 
 /*      Pixel format         FOURCC                          depth  Description  */
@@ -305,6 +381,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_XRGB555 v4l2_fourcc('X', 'R', '1', '5') /* 16  XRGB-1-5-5-5  */
 #define V4L2_PIX_FMT_RGB565  v4l2_fourcc('R', 'G', 'B', 'P') /* 16  RGB-5-6-5     */
 #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
+#define V4L2_PIX_FMT_ARGB555X v4l2_fourcc_be('A', 'R', '1', '5') /* 16  ARGB-5-5-5 BE */
+#define V4L2_PIX_FMT_XRGB555X v4l2_fourcc_be('X', 'R', '1', '5') /* 16  XRGB-5-5-5 BE */
 #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
 #define V4L2_PIX_FMT_BGR666  v4l2_fourcc('B', 'G', 'R', 'H') /* 18  BGR-6-6-6	  */
 #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
@@ -383,10 +461,11 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
-#define V4L2_PIX_FMT_SBGGR12 v4l2_fourcc('B', 'G', '1', '2') /* 12  BGBG.. GRGR.. */
-#define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
-#define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
-#define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
+	/* 10bit raw bayer packed, 5 bytes for every 4 pixels */
+#define V4L2_PIX_FMT_SBGGR10P v4l2_fourcc('p', 'B', 'A', 'A')
+#define V4L2_PIX_FMT_SGBRG10P v4l2_fourcc('p', 'G', 'A', 'A')
+#define V4L2_PIX_FMT_SGRBG10P v4l2_fourcc('p', 'g', 'A', 'A')
+#define V4L2_PIX_FMT_SRGGB10P v4l2_fourcc('p', 'R', 'A', 'A')
 	/* 10bit raw bayer a-law compressed to 8 bits */
 #define V4L2_PIX_FMT_SBGGR10ALAW8 v4l2_fourcc('a', 'B', 'A', '8')
 #define V4L2_PIX_FMT_SGBRG10ALAW8 v4l2_fourcc('a', 'G', 'A', '8')
@@ -397,10 +476,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')
 #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
 #define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('b', 'R', 'A', '8')
-	/*
-	 * 10bit raw bayer, expanded to 16 bits
-	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
-	 */
+#define V4L2_PIX_FMT_SBGGR12 v4l2_fourcc('B', 'G', '1', '2') /* 12  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
+#define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
+#define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
@@ -1244,6 +1323,7 @@ struct v4l2_input {
 #define V4L2_IN_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
 #define V4L2_IN_CAP_CUSTOM_TIMINGS	V4L2_IN_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_IN_CAP_STD			0x00000004 /* Supports S_STD */
+#define V4L2_IN_CAP_NATIVE_SIZE		0x00000008 /* Supports setting native size */
 
 /*
  *	V I D E O   O U T P U T S
@@ -1267,6 +1347,7 @@ struct v4l2_output {
 #define V4L2_OUT_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
 #define V4L2_OUT_CAP_CUSTOM_TIMINGS	V4L2_OUT_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_OUT_CAP_STD		0x00000004 /* Supports S_STD */
+#define V4L2_OUT_CAP_NATIVE_SIZE	0x00000008 /* Supports setting native size */
 
 /*
  *	C O N T R O L S
@@ -1772,6 +1853,8 @@ struct v4l2_plane_pix_format {
  * @plane_fmt:		per-plane information
  * @num_planes:		number of planes for this format
  * @flags:		format flags (V4L2_PIX_FMT_FLAG_*)
+ * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
+ * @quantization:	enum v4l2_quantization, colorspace quantization
  */
 struct v4l2_pix_format_mplane {
 	__u32				width;
@@ -1783,7 +1866,9 @@ struct v4l2_pix_format_mplane {
 	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
 	__u8				num_planes;
 	__u8				flags;
-	__u8				reserved[10];
+	__u8				ycbcr_enc;
+	__u8				quantization;
+	__u8				reserved[8];
 } __attribute__ ((packed));
 
 /**
-- 
2.1.0.231.g7484e3b

