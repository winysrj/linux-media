Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33639 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbcGRMmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:42:32 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 07/12] [media] vivid: Introduce TPG_COLOR_ENC_LUMA
Date: Mon, 18 Jul 2016 14:42:11 +0200
Message-Id: <1468845736-19651-8-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplifies handling of Gray formats.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 26 +++++++++++++++++++------
 drivers/media/platform/vivid/vivid-vid-common.c |  6 +++---
 include/media/v4l2-tpg.h                        |  1 +
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index da77cdd4f2e5..41cc402ddeef 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -234,10 +234,12 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_XBGR32:
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
+		tpg->color_enc = TGP_COLOR_ENC_RGB;
+		break;
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y16:
 	case V4L2_PIX_FMT_Y16_BE:
-		tpg->color_enc = TGP_COLOR_ENC_RGB;
+		tpg->color_enc = TGP_COLOR_ENC_LUMA;
 		break;
 	case V4L2_PIX_FMT_YUV444:
 	case V4L2_PIX_FMT_YUV555:
@@ -825,9 +827,9 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		g <<= 4;
 		b <<= 4;
 	}
-	if (tpg->qual == TPG_QUAL_GRAY || tpg->fourcc == V4L2_PIX_FMT_GREY ||
-	    tpg->fourcc == V4L2_PIX_FMT_Y16 ||
-	    tpg->fourcc == V4L2_PIX_FMT_Y16_BE) {
+
+	if (tpg->qual == TPG_QUAL_GRAY ||
+	    tpg->color_enc ==  TGP_COLOR_ENC_LUMA) {
 		/* Rec. 709 Luma function */
 		/* (0.2126, 0.7152, 0.0722) * (255 * 256) */
 		r = g = b = (13879 * r + 46688 * g + 4713 * b) >> 16;
@@ -867,8 +869,9 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		b = (b - (16 << 4)) * 255 / 219;
 	}
 
-	if (tpg->brightness != 128 || tpg->contrast != 128 ||
-	    tpg->saturation != 128 || tpg->hue) {
+	if ((tpg->brightness != 128 || tpg->contrast != 128 ||
+	     tpg->saturation != 128 || tpg->hue) &&
+	    tpg->color_enc != TGP_COLOR_ENC_LUMA) {
 		/* Implement these operations */
 		int y, cb, cr;
 		int tmp_cb, tmp_cr;
@@ -894,6 +897,10 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 			return;
 		}
 		ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
+	} else if ((tpg->brightness != 128 || tpg->contrast != 128) &&
+		   tpg->color_enc == TGP_COLOR_ENC_LUMA) {
+		r = (16 << 4) + ((r - (16 << 4)) * tpg->contrast) / 128;
+		r += (tpg->brightness << 4) - (128 << 4);
 	}
 
 	switch (tpg->color_enc) {
@@ -944,6 +951,11 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		tpg->colors[k][2] = cr;
 		break;
 	}
+	case TGP_COLOR_ENC_LUMA:
+	{
+		tpg->colors[k][0] = r >> 4;
+		break;
+	}
 	case TGP_COLOR_ENC_RGB:
 	{
 		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
@@ -1985,6 +1997,8 @@ static const char *tpg_color_enc_str(enum tgp_color_enc
 		return "HSV";
 	case TGP_COLOR_ENC_YCBCR:
 		return "Y'CbCr";
+	case TGP_COLOR_ENC_LUMA:
+		return "Luma";
 	case TGP_COLOR_ENC_RGB:
 	default:
 		return "R'G'B";
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 20822b5111b3..e0df44151461 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -184,7 +184,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_GREY,
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
-		.color_enc = TGP_COLOR_ENC_YCBCR,
+		.color_enc = TGP_COLOR_ENC_LUMA,
 		.planes   = 1,
 		.buffers = 1,
 	},
@@ -192,7 +192,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_Y16,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
-		.color_enc = TGP_COLOR_ENC_YCBCR,
+		.color_enc = TGP_COLOR_ENC_LUMA,
 		.planes   = 1,
 		.buffers = 1,
 	},
@@ -200,7 +200,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_Y16_BE,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
-		.color_enc = TGP_COLOR_ENC_YCBCR,
+		.color_enc = TGP_COLOR_ENC_LUMA,
 		.planes   = 1,
 		.buffers = 1,
 	},
diff --git a/include/media/v4l2-tpg.h b/include/media/v4l2-tpg.h
index 4a40f9b79053..8abed92317e8 100644
--- a/include/media/v4l2-tpg.h
+++ b/include/media/v4l2-tpg.h
@@ -91,6 +91,7 @@ enum tgp_color_enc {
 	TGP_COLOR_ENC_RGB,
 	TGP_COLOR_ENC_YCBCR,
 	TGP_COLOR_ENC_HSV,
+	TGP_COLOR_ENC_LUMA,
 };
 
 extern const char * const tpg_aspect_strings[];
-- 
2.8.1

