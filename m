Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44975 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbaLAJEW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 04:04:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 1/9] videodev2.h: improve colorspace support
Date: Mon,  1 Dec 2014 10:03:45 +0100
Message-Id: <1417424633-15781-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl>
References: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the new AdobeRGB and BT.2020 colorspaces as needed for
HDMI 2.0.

Add support to specify the Y'CbCr encoding and quantization range explicitly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 99 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1c2f84f..ced659e 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -178,30 +178,103 @@ enum v4l2_memory {
 
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
@@ -294,6 +367,8 @@ struct v4l2_pix_format {
 	__u32			colorspace;	/* enum v4l2_colorspace */
 	__u32			priv;		/* private data, depends on pixelformat */
 	__u32			flags;		/* format flags (V4L2_PIX_FMT_FLAG_*) */
+	__u32			ycbcr_enc;	/* enum v4l2_ycbcr_encoding */
+	__u32			quantization;	/* enum v4l2_quantization */
 };
 
 /*      Pixel format         FOURCC                          depth  Description  */
@@ -1777,6 +1852,8 @@ struct v4l2_plane_pix_format {
  * @plane_fmt:		per-plane information
  * @num_planes:		number of planes for this format
  * @flags:		format flags (V4L2_PIX_FMT_FLAG_*)
+ * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
+ * @quantization:	enum v4l2_quantization, colorspace quantization
  */
 struct v4l2_pix_format_mplane {
 	__u32				width;
@@ -1788,7 +1865,9 @@ struct v4l2_pix_format_mplane {
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
2.1.3

