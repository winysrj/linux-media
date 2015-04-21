Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:45422 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbbDUNun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:50:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 4/4] vivid: drop format description
Date: Tue, 21 Apr 2015 15:50:01 +0200
Message-Id: <1429624201-44743-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
References: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The format description is now filled in by the core, so we can
drop this in this virtual driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h       |  1 -
 drivers/media/platform/vivid/vivid-vid-cap.c    |  4 --
 drivers/media/platform/vivid/vivid-vid-common.c | 50 -------------------------
 3 files changed, 55 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 9e15aee..bf26173 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -77,7 +77,6 @@ extern const struct v4l2_rect vivid_max_rect;
 extern unsigned vivid_debug;
 
 struct vivid_fmt {
-	const char *name;
 	u32	fourcc;          /* v4l2 format id */
 	bool	is_yuv;
 	bool	can_do_overlay;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index dab5990..8a20137 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -40,7 +40,6 @@ static const struct v4l2_fract
 
 static const struct vivid_fmt formats_ovl[] = {
 	{
-		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -48,7 +47,6 @@ static const struct vivid_fmt formats_ovl[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "XRGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_XRGB555, /* gggbbbbb arrrrrgg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -56,7 +54,6 @@ static const struct vivid_fmt formats_ovl[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "ARGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_ARGB555, /* gggbbbbb arrrrrgg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -1030,7 +1027,6 @@ int vidioc_enum_fmt_vid_overlay(struct file *file, void  *priv,
 
 	fmt = &formats_ovl[f->index];
 
-	strlcpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index aa44627..6ba8744 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -45,7 +45,6 @@ const struct v4l2_dv_timings_cap vivid_dv_timings_cap = {
 
 struct vivid_fmt vivid_formats[] = {
 	{
-		.name     = "4:2:2, packed, YUYV",
 		.fourcc   = V4L2_PIX_FMT_YUYV,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -55,7 +54,6 @@ struct vivid_fmt vivid_formats[] = {
 		.data_offset = { PLANE0_DATA_OFFSET },
 	},
 	{
-		.name     = "4:2:2, packed, UYVY",
 		.fourcc   = V4L2_PIX_FMT_UYVY,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -64,7 +62,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "4:2:2, packed, YVYU",
 		.fourcc   = V4L2_PIX_FMT_YVYU,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -73,7 +70,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "4:2:2, packed, VYUY",
 		.fourcc   = V4L2_PIX_FMT_VYUY,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -82,7 +78,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YUV 4:2:2 triplanar",
 		.fourcc   = V4L2_PIX_FMT_YUV422P,
 		.vdownsampling = { 1, 1, 1 },
 		.bit_depth = { 8, 4, 4 },
@@ -91,7 +86,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YUV 4:2:0 triplanar",
 		.fourcc   = V4L2_PIX_FMT_YUV420,
 		.vdownsampling = { 1, 2, 2 },
 		.bit_depth = { 8, 4, 4 },
@@ -100,7 +94,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YVU 4:2:0 triplanar",
 		.fourcc   = V4L2_PIX_FMT_YVU420,
 		.vdownsampling = { 1, 2, 2 },
 		.bit_depth = { 8, 4, 4 },
@@ -109,7 +102,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YUV 4:2:0 biplanar",
 		.fourcc   = V4L2_PIX_FMT_NV12,
 		.vdownsampling = { 1, 2 },
 		.bit_depth = { 8, 8 },
@@ -118,7 +110,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YVU 4:2:0 biplanar",
 		.fourcc   = V4L2_PIX_FMT_NV21,
 		.vdownsampling = { 1, 2 },
 		.bit_depth = { 8, 8 },
@@ -127,7 +118,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YUV 4:2:2 biplanar",
 		.fourcc   = V4L2_PIX_FMT_NV16,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
@@ -136,7 +126,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YVU 4:2:2 biplanar",
 		.fourcc   = V4L2_PIX_FMT_NV61,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
@@ -145,7 +134,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YUV 4:4:4 biplanar",
 		.fourcc   = V4L2_PIX_FMT_NV24,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 16 },
@@ -154,7 +142,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YVU 4:4:4 biplanar",
 		.fourcc   = V4L2_PIX_FMT_NV42,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 16 },
@@ -163,7 +150,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YUV555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_YUV555, /* uuuvvvvv ayyyyyuu */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -172,7 +158,6 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0x8000,
 	},
 	{
-		.name     = "YUV565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_YUV565, /* uuuvvvvv yyyyyuuu */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -180,7 +165,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "YUV444",
 		.fourcc   = V4L2_PIX_FMT_YUV444, /* uuuuvvvv aaaayyyy */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -189,7 +173,6 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0xf000,
 	},
 	{
-		.name     = "YUV32 (LE)",
 		.fourcc   = V4L2_PIX_FMT_YUV32, /* ayuv */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
@@ -198,7 +181,6 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0x000000ff,
 	},
 	{
-		.name     = "Monochrome",
 		.fourcc   = V4L2_PIX_FMT_GREY,
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
@@ -207,7 +189,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "RGB332",
 		.fourcc   = V4L2_PIX_FMT_RGB332, /* rrrgggbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
@@ -215,7 +196,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -224,7 +204,6 @@ struct vivid_fmt vivid_formats[] = {
 		.can_do_overlay = true,
 	},
 	{
-		.name     = "RGB565 (BE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -233,7 +212,6 @@ struct vivid_fmt vivid_formats[] = {
 		.can_do_overlay = true,
 	},
 	{
-		.name     = "RGB444",
 		.fourcc   = V4L2_PIX_FMT_RGB444, /* xxxxrrrr ggggbbbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -241,7 +219,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "XRGB444",
 		.fourcc   = V4L2_PIX_FMT_XRGB444, /* xxxxrrrr ggggbbbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -249,7 +226,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "ARGB444",
 		.fourcc   = V4L2_PIX_FMT_ARGB444, /* aaaarrrr ggggbbbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -258,7 +234,6 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0x00f0,
 	},
 	{
-		.name     = "RGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb xrrrrrgg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -267,7 +242,6 @@ struct vivid_fmt vivid_formats[] = {
 		.can_do_overlay = true,
 	},
 	{
-		.name     = "XRGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_XRGB555, /* gggbbbbb xrrrrrgg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -276,7 +250,6 @@ struct vivid_fmt vivid_formats[] = {
 		.can_do_overlay = true,
 	},
 	{
-		.name     = "ARGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_ARGB555, /* gggbbbbb arrrrrgg */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -286,7 +259,6 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0x8000,
 	},
 	{
-		.name     = "RGB555 (BE)",
 		.fourcc   = V4L2_PIX_FMT_RGB555X, /* xrrrrrgg gggbbbbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -294,7 +266,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "XRGB555 (BE)",
 		.fourcc   = V4L2_PIX_FMT_XRGB555X, /* xrrrrrgg gggbbbbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -302,7 +273,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "ARGB555 (BE)",
 		.fourcc   = V4L2_PIX_FMT_ARGB555X, /* arrrrrgg gggbbbbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
@@ -311,7 +281,6 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0x0080,
 	},
 	{
-		.name     = "RGB24 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB24, /* rgb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 24 },
@@ -319,7 +288,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "RGB24 (BE)",
 		.fourcc   = V4L2_PIX_FMT_BGR24, /* bgr */
 		.vdownsampling = { 1 },
 		.bit_depth = { 24 },
@@ -327,7 +295,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "BGR666",
 		.fourcc   = V4L2_PIX_FMT_BGR666, /* bbbbbbgg ggggrrrr rrxxxxxx */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
@@ -335,7 +302,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "RGB32 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB32, /* xrgb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
@@ -343,7 +309,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "RGB32 (BE)",
 		.fourcc   = V4L2_PIX_FMT_BGR32, /* bgrx */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
@@ -351,7 +316,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "XRGB32 (LE)",
 		.fourcc   = V4L2_PIX_FMT_XRGB32, /* xrgb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
@@ -359,7 +323,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "XRGB32 (BE)",
 		.fourcc   = V4L2_PIX_FMT_XBGR32, /* bgrx */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
@@ -367,7 +330,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "ARGB32 (LE)",
 		.fourcc   = V4L2_PIX_FMT_ARGB32, /* argb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
@@ -376,7 +338,6 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0x000000ff,
 	},
 	{
-		.name     = "ARGB32 (BE)",
 		.fourcc   = V4L2_PIX_FMT_ABGR32, /* bgra */
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
@@ -385,7 +346,6 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0xff000000,
 	},
 	{
-		.name     = "Bayer BG/GR",
 		.fourcc   = V4L2_PIX_FMT_SBGGR8, /* Bayer BG/GR */
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
@@ -393,7 +353,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "Bayer GB/RG",
 		.fourcc   = V4L2_PIX_FMT_SGBRG8, /* Bayer GB/RG */
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
@@ -401,7 +360,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "Bayer GR/BG",
 		.fourcc   = V4L2_PIX_FMT_SGRBG8, /* Bayer GR/BG */
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
@@ -409,7 +367,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "Bayer RG/GB",
 		.fourcc   = V4L2_PIX_FMT_SRGGB8, /* Bayer RG/GB */
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
@@ -417,7 +374,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
-		.name     = "4:2:2, biplanar, YUV",
 		.fourcc   = V4L2_PIX_FMT_NV16M,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
@@ -427,7 +383,6 @@ struct vivid_fmt vivid_formats[] = {
 		.data_offset = { PLANE0_DATA_OFFSET, 0 },
 	},
 	{
-		.name     = "4:2:2, biplanar, YVU",
 		.fourcc   = V4L2_PIX_FMT_NV61M,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
@@ -437,7 +392,6 @@ struct vivid_fmt vivid_formats[] = {
 		.data_offset = { 0, PLANE0_DATA_OFFSET },
 	},
 	{
-		.name     = "4:2:0, triplanar, YUV",
 		.fourcc   = V4L2_PIX_FMT_YUV420M,
 		.vdownsampling = { 1, 2, 2 },
 		.bit_depth = { 8, 4, 4 },
@@ -446,7 +400,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 3,
 	},
 	{
-		.name     = "4:2:0, triplanar, YVU",
 		.fourcc   = V4L2_PIX_FMT_YVU420M,
 		.vdownsampling = { 1, 2, 2 },
 		.bit_depth = { 8, 4, 4 },
@@ -455,7 +408,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 3,
 	},
 	{
-		.name     = "4:2:0, biplanar, YUV",
 		.fourcc   = V4L2_PIX_FMT_NV12M,
 		.vdownsampling = { 1, 2 },
 		.bit_depth = { 8, 8 },
@@ -464,7 +416,6 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 2,
 	},
 	{
-		.name     = "4:2:0, biplanar, YVU",
 		.fourcc   = V4L2_PIX_FMT_NV21M,
 		.vdownsampling = { 1, 2 },
 		.bit_depth = { 8, 8 },
@@ -750,7 +701,6 @@ int vivid_enum_fmt_vid(struct file *file, void  *priv,
 
 	fmt = &vivid_formats[f->index];
 
-	strlcpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 	return 0;
 }
-- 
2.1.4

