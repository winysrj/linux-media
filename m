Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:51429 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbbCMLRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:17:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 37/39] vivid: add support for packed YUV formats
Date: Fri, 13 Mar 2015 12:16:15 +0100
Message-Id: <1426245377-17704-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the packed YUV formats YUV444, YUV555, YUV565 and YUV32.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 40 +++++++++++++++++++++++--
 drivers/media/platform/vivid/vivid-vid-common.c | 35 ++++++++++++++++++++++
 2 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 059e98e..246c3e7 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -212,6 +212,12 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_GREY:
 		tpg->is_yuv = false;
 		break;
+	case V4L2_PIX_FMT_YUV444:
+	case V4L2_PIX_FMT_YUV555:
+	case V4L2_PIX_FMT_YUV565:
+	case V4L2_PIX_FMT_YUV32:
+		tpg->is_yuv = true;
+		break;
 	case V4L2_PIX_FMT_YUV420M:
 	case V4L2_PIX_FMT_YVU420M:
 		tpg->buffers = 3;
@@ -294,6 +300,9 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YVYU:
 	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YUV444:
+	case V4L2_PIX_FMT_YUV555:
+	case V4L2_PIX_FMT_YUV565:
 		tpg->twopixelsize[0] = 2 * 2;
 		break;
 	case V4L2_PIX_FMT_RGB24:
@@ -307,6 +316,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_XBGR32:
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
+	case V4L2_PIX_FMT_YUV32:
 		tpg->twopixelsize[0] = 2 * 4;
 		break;
 	case V4L2_PIX_FMT_GREY:
@@ -713,9 +723,29 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 			cb = clamp(cb, 16 << 4, 240 << 4);
 			cr = clamp(cr, 16 << 4, 240 << 4);
 		}
-		tpg->colors[k][0] = clamp(y >> 4, 1, 254);
-		tpg->colors[k][1] = clamp(cb >> 4, 1, 254);
-		tpg->colors[k][2] = clamp(cr >> 4, 1, 254);
+		y = clamp(y >> 4, 1, 254);
+		cb = clamp(cb >> 4, 1, 254);
+		cr = clamp(cr >> 4, 1, 254);
+		switch (tpg->fourcc) {
+		case V4L2_PIX_FMT_YUV444:
+			y >>= 4;
+			cb >>= 4;
+			cr >>= 4;
+			break;
+		case V4L2_PIX_FMT_YUV555:
+			y >>= 3;
+			cb >>= 3;
+			cr >>= 3;
+			break;
+		case V4L2_PIX_FMT_YUV565:
+			y >>= 3;
+			cb >>= 2;
+			cr >>= 3;
+			break;
+		}
+		tpg->colors[k][0] = y;
+		tpg->colors[k][1] = cb;
+		tpg->colors[k][2] = cr;
 	} else {
 		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
 			r = (r * 219) / 255 + (16 << 4);
@@ -909,6 +939,7 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_RGB332:
 		buf[0][offset] = (r_y << 5) | (g_u << 2) | b_v;
 		break;
+	case V4L2_PIX_FMT_YUV565:
 	case V4L2_PIX_FMT_RGB565:
 		buf[0][offset] = (g_u << 5) | b_v;
 		buf[0][offset + 1] = (r_y << 3) | (g_u >> 3);
@@ -921,6 +952,7 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_XRGB444:
 		alpha = 0;
 		/* fall through */
+	case V4L2_PIX_FMT_YUV444:
 	case V4L2_PIX_FMT_ARGB444:
 		buf[0][offset] = (g_u << 4) | b_v;
 		buf[0][offset + 1] = (alpha & 0xf0) | r_y;
@@ -929,6 +961,7 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_XRGB555:
 		alpha = 0;
 		/* fall through */
+	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_ARGB555:
 		buf[0][offset] = (g_u << 5) | b_v;
 		buf[0][offset + 1] = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
@@ -961,6 +994,7 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_XRGB32:
 		alpha = 0;
 		/* fall through */
+	case V4L2_PIX_FMT_YUV32:
 	case V4L2_PIX_FMT_ARGB32:
 		buf[0][offset] = alpha;
 		buf[0][offset + 1] = r_y;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 58b42d2..8f0910d 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -162,6 +162,41 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.name     = "YUV555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_YUV555, /* uuuvvvvv ayyyyyuu */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+		.alpha_mask = 0x8000,
+	},
+	{
+		.name     = "YUV565 (LE)",
+		.fourcc   = V4L2_PIX_FMT_YUV565, /* uuuvvvvv yyyyyuuu */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.name     = "YUV444",
+		.fourcc   = V4L2_PIX_FMT_YUV444, /* uuuuvvvv aaaayyyy */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+		.alpha_mask = 0xf000,
+	},
+	{
+		.name     = "YUV32 (LE)",
+		.fourcc   = V4L2_PIX_FMT_YUV32, /* ayuv */
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
+		.planes   = 1,
+		.buffers = 1,
+		.alpha_mask = 0x000000ff,
+	},
+	{
 		.name     = "Monochrome",
 		.fourcc   = V4L2_PIX_FMT_GREY,
 		.vdownsampling = { 1 },
-- 
2.1.4

