Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34021 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbcGPKmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 06:42:14 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 6/9] [media] vivid: Rename variable
Date: Sat, 16 Jul 2016 12:41:53 +0200
Message-Id: <1468665716-10178-7-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

r_y and g_u now also contain the H and V components on the HSV formats.
Rename the variables to reflect this.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 209 +++++++++++++-------------
 1 file changed, 105 insertions(+), 104 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 53e512f5a6b6..ba3fe65ceb98 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1014,7 +1014,7 @@ static void gen_twopix(struct tpg_data *tpg,
 {
 	unsigned offset = odd * tpg->twopixelsize[0] / 2;
 	u8 alpha = tpg->alpha_component;
-	u8 r_y, g_u, b_v;
+	u8 r_y_h, g_u_s, b_v;
 
 	if (tpg->alpha_red_only && color != TPG_COLOR_CSC_RED &&
 				   color != TPG_COLOR_100_RED &&
@@ -1022,161 +1022,161 @@ static void gen_twopix(struct tpg_data *tpg,
 		alpha = 0;
 	if (color == TPG_COLOR_RANDOM)
 		precalculate_color(tpg, color);
-	r_y = tpg->colors[color][0]; /* R or precalculated Y, H */
-	g_u = tpg->colors[color][1]; /* G or precalculated U, V */
+	r_y_h = tpg->colors[color][0]; /* R or precalculated Y, H */
+	g_u_s = tpg->colors[color][1]; /* G or precalculated U, V */
 	b_v = tpg->colors[color][2]; /* B or precalculated V */
 
 	switch (tpg->fourcc) {
 	case V4L2_PIX_FMT_GREY:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		break;
 	case V4L2_PIX_FMT_Y16:
 		/*
-		 * Ideally both bytes should be set to r_y, but then you won't
+		 * Ideally both bytes should be set to r_y_h, but then you won't
 		 * be able to detect endian problems. So keep it 0 except for
-		 * the corner case where r_y is 0xff so white really will be
+		 * the corner case where r_y_h is 0xff so white really will be
 		 * white (0xffff).
 		 */
-		buf[0][offset] = r_y == 0xff ? r_y : 0;
-		buf[0][offset+1] = r_y;
+		buf[0][offset] = r_y_h == 0xff ? r_y_h : 0;
+		buf[0][offset+1] = r_y_h;
 		break;
 	case V4L2_PIX_FMT_Y16_BE:
 		/* See comment for V4L2_PIX_FMT_Y16 above */
-		buf[0][offset] = r_y;
-		buf[0][offset+1] = r_y == 0xff ? r_y : 0;
+		buf[0][offset] = r_y_h;
+		buf[0][offset+1] = r_y_h == 0xff ? r_y_h : 0;
 		break;
 	case V4L2_PIX_FMT_YUV422M:
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YUV420M:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		if (odd) {
-			buf[1][0] = (buf[1][0] + g_u) / 2;
+			buf[1][0] = (buf[1][0] + g_u_s) / 2;
 			buf[2][0] = (buf[2][0] + b_v) / 2;
 			buf[1][1] = buf[1][0];
 			buf[2][1] = buf[2][0];
 			break;
 		}
-		buf[1][0] = g_u;
+		buf[1][0] = g_u_s;
 		buf[2][0] = b_v;
 		break;
 	case V4L2_PIX_FMT_YVU422M:
 	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_YVU420M:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		if (odd) {
 			buf[1][0] = (buf[1][0] + b_v) / 2;
-			buf[2][0] = (buf[2][0] + g_u) / 2;
+			buf[2][0] = (buf[2][0] + g_u_s) / 2;
 			buf[1][1] = buf[1][0];
 			buf[2][1] = buf[2][0];
 			break;
 		}
 		buf[1][0] = b_v;
-		buf[2][0] = g_u;
+		buf[2][0] = g_u_s;
 		break;
 
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV12M:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV16M:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		if (odd) {
-			buf[1][0] = (buf[1][0] + g_u) / 2;
+			buf[1][0] = (buf[1][0] + g_u_s) / 2;
 			buf[1][1] = (buf[1][1] + b_v) / 2;
 			break;
 		}
-		buf[1][0] = g_u;
+		buf[1][0] = g_u_s;
 		buf[1][1] = b_v;
 		break;
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV21M:
 	case V4L2_PIX_FMT_NV61:
 	case V4L2_PIX_FMT_NV61M:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		if (odd) {
 			buf[1][0] = (buf[1][0] + b_v) / 2;
-			buf[1][1] = (buf[1][1] + g_u) / 2;
+			buf[1][1] = (buf[1][1] + g_u_s) / 2;
 			break;
 		}
 		buf[1][0] = b_v;
-		buf[1][1] = g_u;
+		buf[1][1] = g_u_s;
 		break;
 
 	case V4L2_PIX_FMT_YUV444M:
-		buf[0][offset] = r_y;
-		buf[1][offset] = g_u;
+		buf[0][offset] = r_y_h;
+		buf[1][offset] = g_u_s;
 		buf[2][offset] = b_v;
 		break;
 
 	case V4L2_PIX_FMT_YVU444M:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		buf[1][offset] = b_v;
-		buf[2][offset] = g_u;
+		buf[2][offset] = g_u_s;
 		break;
 
 	case V4L2_PIX_FMT_NV24:
-		buf[0][offset] = r_y;
-		buf[1][2 * offset] = g_u;
+		buf[0][offset] = r_y_h;
+		buf[1][2 * offset] = g_u_s;
 		buf[1][2 * offset + 1] = b_v;
 		break;
 
 	case V4L2_PIX_FMT_NV42:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		buf[1][2 * offset] = b_v;
-		buf[1][2 * offset + 1] = g_u;
+		buf[1][2 * offset + 1] = g_u_s;
 		break;
 
 	case V4L2_PIX_FMT_YUYV:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		if (odd) {
-			buf[0][1] = (buf[0][1] + g_u) / 2;
+			buf[0][1] = (buf[0][1] + g_u_s) / 2;
 			buf[0][3] = (buf[0][3] + b_v) / 2;
 			break;
 		}
-		buf[0][1] = g_u;
+		buf[0][1] = g_u_s;
 		buf[0][3] = b_v;
 		break;
 	case V4L2_PIX_FMT_UYVY:
-		buf[0][offset + 1] = r_y;
+		buf[0][offset + 1] = r_y_h;
 		if (odd) {
-			buf[0][0] = (buf[0][0] + g_u) / 2;
+			buf[0][0] = (buf[0][0] + g_u_s) / 2;
 			buf[0][2] = (buf[0][2] + b_v) / 2;
 			break;
 		}
-		buf[0][0] = g_u;
+		buf[0][0] = g_u_s;
 		buf[0][2] = b_v;
 		break;
 	case V4L2_PIX_FMT_YVYU:
-		buf[0][offset] = r_y;
+		buf[0][offset] = r_y_h;
 		if (odd) {
 			buf[0][1] = (buf[0][1] + b_v) / 2;
-			buf[0][3] = (buf[0][3] + g_u) / 2;
+			buf[0][3] = (buf[0][3] + g_u_s) / 2;
 			break;
 		}
 		buf[0][1] = b_v;
-		buf[0][3] = g_u;
+		buf[0][3] = g_u_s;
 		break;
 	case V4L2_PIX_FMT_VYUY:
-		buf[0][offset + 1] = r_y;
+		buf[0][offset + 1] = r_y_h;
 		if (odd) {
 			buf[0][0] = (buf[0][0] + b_v) / 2;
-			buf[0][2] = (buf[0][2] + g_u) / 2;
+			buf[0][2] = (buf[0][2] + g_u_s) / 2;
 			break;
 		}
 		buf[0][0] = b_v;
-		buf[0][2] = g_u;
+		buf[0][2] = g_u_s;
 		break;
 	case V4L2_PIX_FMT_RGB332:
-		buf[0][offset] = (r_y << 5) | (g_u << 2) | b_v;
+		buf[0][offset] = (r_y_h << 5) | (g_u_s << 2) | b_v;
 		break;
 	case V4L2_PIX_FMT_YUV565:
 	case V4L2_PIX_FMT_RGB565:
-		buf[0][offset] = (g_u << 5) | b_v;
-		buf[0][offset + 1] = (r_y << 3) | (g_u >> 3);
+		buf[0][offset] = (g_u_s << 5) | b_v;
+		buf[0][offset + 1] = (r_y_h << 3) | (g_u_s >> 3);
 		break;
 	case V4L2_PIX_FMT_RGB565X:
-		buf[0][offset] = (r_y << 3) | (g_u >> 3);
-		buf[0][offset + 1] = (g_u << 5) | b_v;
+		buf[0][offset] = (r_y_h << 3) | (g_u_s >> 3);
+		buf[0][offset + 1] = (g_u_s << 5) | b_v;
 		break;
 	case V4L2_PIX_FMT_RGB444:
 	case V4L2_PIX_FMT_XRGB444:
@@ -1184,8 +1184,8 @@ static void gen_twopix(struct tpg_data *tpg,
 		/* fall through */
 	case V4L2_PIX_FMT_YUV444:
 	case V4L2_PIX_FMT_ARGB444:
-		buf[0][offset] = (g_u << 4) | b_v;
-		buf[0][offset + 1] = (alpha & 0xf0) | r_y;
+		buf[0][offset] = (g_u_s << 4) | b_v;
+		buf[0][offset + 1] = (alpha & 0xf0) | r_y_h;
 		break;
 	case V4L2_PIX_FMT_RGB555:
 	case V4L2_PIX_FMT_XRGB555:
@@ -1193,32 +1193,33 @@ static void gen_twopix(struct tpg_data *tpg,
 		/* fall through */
 	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_ARGB555:
-		buf[0][offset] = (g_u << 5) | b_v;
-		buf[0][offset + 1] = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
+		buf[0][offset] = (g_u_s << 5) | b_v;
+		buf[0][offset + 1] = (alpha & 0x80) | (r_y_h << 2)
+						    | (g_u_s >> 3);
 		break;
 	case V4L2_PIX_FMT_RGB555X:
 	case V4L2_PIX_FMT_XRGB555X:
 		alpha = 0;
 		/* fall through */
 	case V4L2_PIX_FMT_ARGB555X:
-		buf[0][offset] = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
-		buf[0][offset + 1] = (g_u << 5) | b_v;
+		buf[0][offset] = (alpha & 0x80) | (r_y_h << 2) | (g_u_s >> 3);
+		buf[0][offset + 1] = (g_u_s << 5) | b_v;
 		break;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_HSV24:
-		buf[0][offset] = r_y;
-		buf[0][offset + 1] = g_u;
+		buf[0][offset] = r_y_h;
+		buf[0][offset + 1] = g_u_s;
 		buf[0][offset + 2] = b_v;
 		break;
 	case V4L2_PIX_FMT_BGR24:
 		buf[0][offset] = b_v;
-		buf[0][offset + 1] = g_u;
-		buf[0][offset + 2] = r_y;
+		buf[0][offset + 1] = g_u_s;
+		buf[0][offset + 2] = r_y_h;
 		break;
 	case V4L2_PIX_FMT_BGR666:
-		buf[0][offset] = (b_v << 2) | (g_u >> 4);
-		buf[0][offset + 1] = (g_u << 4) | (r_y >> 2);
-		buf[0][offset + 2] = r_y << 6;
+		buf[0][offset] = (b_v << 2) | (g_u_s >> 4);
+		buf[0][offset + 1] = (g_u_s << 4) | (r_y_h >> 2);
+		buf[0][offset + 2] = r_y_h << 6;
 		buf[0][offset + 3] = 0;
 		break;
 	case V4L2_PIX_FMT_RGB32:
@@ -1229,8 +1230,8 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_YUV32:
 	case V4L2_PIX_FMT_ARGB32:
 		buf[0][offset] = alpha;
-		buf[0][offset + 1] = r_y;
-		buf[0][offset + 2] = g_u;
+		buf[0][offset + 1] = r_y_h;
+		buf[0][offset + 2] = g_u_s;
 		buf[0][offset + 3] = b_v;
 		break;
 	case V4L2_PIX_FMT_BGR32:
@@ -1239,87 +1240,87 @@ static void gen_twopix(struct tpg_data *tpg,
 		/* fall through */
 	case V4L2_PIX_FMT_ABGR32:
 		buf[0][offset] = b_v;
-		buf[0][offset + 1] = g_u;
-		buf[0][offset + 2] = r_y;
+		buf[0][offset + 1] = g_u_s;
+		buf[0][offset + 2] = r_y_h;
 		buf[0][offset + 3] = alpha;
 		break;
 	case V4L2_PIX_FMT_SBGGR8:
-		buf[0][offset] = odd ? g_u : b_v;
-		buf[1][offset] = odd ? r_y : g_u;
+		buf[0][offset] = odd ? g_u_s : b_v;
+		buf[1][offset] = odd ? r_y_h : g_u_s;
 		break;
 	case V4L2_PIX_FMT_SGBRG8:
-		buf[0][offset] = odd ? b_v : g_u;
-		buf[1][offset] = odd ? g_u : r_y;
+		buf[0][offset] = odd ? b_v : g_u_s;
+		buf[1][offset] = odd ? g_u_s : r_y_h;
 		break;
 	case V4L2_PIX_FMT_SGRBG8:
-		buf[0][offset] = odd ? r_y : g_u;
-		buf[1][offset] = odd ? g_u : b_v;
+		buf[0][offset] = odd ? r_y_h : g_u_s;
+		buf[1][offset] = odd ? g_u_s : b_v;
 		break;
 	case V4L2_PIX_FMT_SRGGB8:
-		buf[0][offset] = odd ? g_u : r_y;
-		buf[1][offset] = odd ? b_v : g_u;
+		buf[0][offset] = odd ? g_u_s : r_y_h;
+		buf[1][offset] = odd ? b_v : g_u_s;
 		break;
 	case V4L2_PIX_FMT_SBGGR10:
-		buf[0][offset] = odd ? g_u << 2 : b_v << 2;
-		buf[0][offset + 1] = odd ? g_u >> 6 : b_v >> 6;
-		buf[1][offset] = odd ? r_y << 2 : g_u << 2;
-		buf[1][offset + 1] = odd ? r_y >> 6 : g_u >> 6;
+		buf[0][offset] = odd ? g_u_s << 2 : b_v << 2;
+		buf[0][offset + 1] = odd ? g_u_s >> 6 : b_v >> 6;
+		buf[1][offset] = odd ? r_y_h << 2 : g_u_s << 2;
+		buf[1][offset + 1] = odd ? r_y_h >> 6 : g_u_s >> 6;
 		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
 		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
 		break;
 	case V4L2_PIX_FMT_SGBRG10:
-		buf[0][offset] = odd ? b_v << 2 : g_u << 2;
-		buf[0][offset + 1] = odd ? b_v >> 6 : g_u >> 6;
-		buf[1][offset] = odd ? g_u << 2 : r_y << 2;
-		buf[1][offset + 1] = odd ? g_u >> 6 : r_y >> 6;
+		buf[0][offset] = odd ? b_v << 2 : g_u_s << 2;
+		buf[0][offset + 1] = odd ? b_v >> 6 : g_u_s >> 6;
+		buf[1][offset] = odd ? g_u_s << 2 : r_y_h << 2;
+		buf[1][offset + 1] = odd ? g_u_s >> 6 : r_y_h >> 6;
 		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
 		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
 		break;
 	case V4L2_PIX_FMT_SGRBG10:
-		buf[0][offset] = odd ? r_y << 2 : g_u << 2;
-		buf[0][offset + 1] = odd ? r_y >> 6 : g_u >> 6;
-		buf[1][offset] = odd ? g_u << 2 : b_v << 2;
-		buf[1][offset + 1] = odd ? g_u >> 6 : b_v >> 6;
+		buf[0][offset] = odd ? r_y_h << 2 : g_u_s << 2;
+		buf[0][offset + 1] = odd ? r_y_h >> 6 : g_u_s >> 6;
+		buf[1][offset] = odd ? g_u_s << 2 : b_v << 2;
+		buf[1][offset + 1] = odd ? g_u_s >> 6 : b_v >> 6;
 		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
 		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
 		break;
 	case V4L2_PIX_FMT_SRGGB10:
-		buf[0][offset] = odd ? g_u << 2 : r_y << 2;
-		buf[0][offset + 1] = odd ? g_u >> 6 : r_y >> 6;
-		buf[1][offset] = odd ? b_v << 2 : g_u << 2;
-		buf[1][offset + 1] = odd ? b_v >> 6 : g_u >> 6;
+		buf[0][offset] = odd ? g_u_s << 2 : r_y_h << 2;
+		buf[0][offset + 1] = odd ? g_u_s >> 6 : r_y_h >> 6;
+		buf[1][offset] = odd ? b_v << 2 : g_u_s << 2;
+		buf[1][offset + 1] = odd ? b_v >> 6 : g_u_s >> 6;
 		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
 		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
 		break;
 	case V4L2_PIX_FMT_SBGGR12:
-		buf[0][offset] = odd ? g_u << 4 : b_v << 4;
-		buf[0][offset + 1] = odd ? g_u >> 4 : b_v >> 4;
-		buf[1][offset] = odd ? r_y << 4 : g_u << 4;
-		buf[1][offset + 1] = odd ? r_y >> 4 : g_u >> 4;
+		buf[0][offset] = odd ? g_u_s << 4 : b_v << 4;
+		buf[0][offset + 1] = odd ? g_u_s >> 4 : b_v >> 4;
+		buf[1][offset] = odd ? r_y_h << 4 : g_u_s << 4;
+		buf[1][offset + 1] = odd ? r_y_h >> 4 : g_u_s >> 4;
 		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
 		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
 		break;
 	case V4L2_PIX_FMT_SGBRG12:
-		buf[0][offset] = odd ? b_v << 4 : g_u << 4;
-		buf[0][offset + 1] = odd ? b_v >> 4 : g_u >> 4;
-		buf[1][offset] = odd ? g_u << 4 : r_y << 4;
-		buf[1][offset + 1] = odd ? g_u >> 4 : r_y >> 4;
+		buf[0][offset] = odd ? b_v << 4 : g_u_s << 4;
+		buf[0][offset + 1] = odd ? b_v >> 4 : g_u_s >> 4;
+		buf[1][offset] = odd ? g_u_s << 4 : r_y_h << 4;
+		buf[1][offset + 1] = odd ? g_u_s >> 4 : r_y_h >> 4;
 		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
 		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
 		break;
 	case V4L2_PIX_FMT_SGRBG12:
-		buf[0][offset] = odd ? r_y << 4 : g_u << 4;
-		buf[0][offset + 1] = odd ? r_y >> 4 : g_u >> 4;
-		buf[1][offset] = odd ? g_u << 4 : b_v << 4;
-		buf[1][offset + 1] = odd ? g_u >> 4 : b_v >> 4;
+		buf[0][offset] = odd ? r_y_h << 4 : g_u_s << 4;
+		buf[0][offset + 1] = odd ? r_y_h >> 4 : g_u_s >> 4;
+		buf[1][offset] = odd ? g_u_s << 4 : b_v << 4;
+		buf[1][offset + 1] = odd ? g_u_s >> 4 : b_v >> 4;
 		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
 		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
 		break;
 	case V4L2_PIX_FMT_SRGGB12:
-		buf[0][offset] = odd ? g_u << 4 : r_y << 4;
-		buf[0][offset + 1] = odd ? g_u >> 4 : r_y >> 4;
-		buf[1][offset] = odd ? b_v << 4 : g_u << 4;
-		buf[1][offset + 1] = odd ? b_v >> 4 : g_u >> 4;
+		buf[0][offset] = odd ? g_u_s << 4 : r_y_h << 4;
+		buf[0][offset + 1] = odd ? g_u_s >> 4 : r_y_h >> 4;
+		buf[1][offset] = odd ? b_v << 4 : g_u_s << 4;
+		buf[1][offset + 1] = odd ? b_v >> 4 : g_u_s >> 4;
 		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
 		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
 		break;
-- 
2.8.1

