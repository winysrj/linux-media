Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36596 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768303AbcHROfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 10:35:46 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 08/12] [media] vivid: Fix YUV555 and YUV565 handling
Date: Thu, 18 Aug 2016 16:33:34 +0200
Message-Id: <1471530818-7928-9-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

precalculate_color() had a optimization that avoided duplicated
conversion for YUV formats. This optimization did not take into
consideration YUV444, YUV555, YUV565 or limited range quantization.

This patch keeps the optimization, but fixes the wrong handling.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 920c8495f3dd..7364ced09abc 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -795,6 +795,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 	int r = tpg_colors[col].r;
 	int g = tpg_colors[col].g;
 	int b = tpg_colors[col].b;
+	int y, cb, cr;
+	bool ycbcr_valid = false;
 
 	if (k == TPG_COLOR_TEXTBG) {
 		col = tpg_get_textbg_color(tpg);
@@ -871,7 +873,6 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 	     tpg->saturation != 128 || tpg->hue) &&
 	    tpg->color_enc != TGP_COLOR_ENC_LUMA) {
 		/* Implement these operations */
-		int y, cb, cr;
 		int tmp_cb, tmp_cr;
 
 		/* First convert to YCbCr */
@@ -888,13 +889,10 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 
 		cb = (128 << 4) + (tmp_cb * tpg->contrast * tpg->saturation) / (128 * 128);
 		cr = (128 << 4) + (tmp_cr * tpg->contrast * tpg->saturation) / (128 * 128);
-		if (tpg->color_enc == TGP_COLOR_ENC_YCBCR) {
-			tpg->colors[k][0] = clamp(y >> 4, 1, 254);
-			tpg->colors[k][1] = clamp(cb >> 4, 1, 254);
-			tpg->colors[k][2] = clamp(cr >> 4, 1, 254);
-			return;
-		}
-		ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
+		if (tpg->color_enc == TGP_COLOR_ENC_YCBCR)
+			ycbcr_valid = true;
+		else
+			ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
 	} else if ((tpg->brightness != 128 || tpg->contrast != 128) &&
 		   tpg->color_enc == TGP_COLOR_ENC_LUMA) {
 		r = (16 << 4) + ((r - (16 << 4)) * tpg->contrast) / 128;
@@ -915,9 +913,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 	case TGP_COLOR_ENC_YCBCR:
 	{
 		/* Convert to YCbCr */
-		int y, cb, cr;
-
-		color_to_ycbcr(tpg, r, g, b, &y, &cb, &cr);
+		if (!ycbcr_valid)
+			color_to_ycbcr(tpg, r, g, b, &y, &cb, &cr);
 
 		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
 			y = clamp(y, 16 << 4, 235 << 4);
-- 
2.8.1

