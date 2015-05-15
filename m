Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59880 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934489AbbEOM3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:29:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/6] vivid: use new V4L2_MAP_*_DEFAULT defines
Date: Fri, 15 May 2015 14:29:10 +0200
Message-Id: <1431692950-17453-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
References: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use these defines instead of hardcoding this in any driver that needs it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 51 ++++++--------------------------
 1 file changed, 9 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 4df755a..5f98ca0 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1640,48 +1640,15 @@ static void tpg_recalc(struct tpg_data *tpg)
 		tpg->recalc_lines = true;
 		tpg->real_ycbcr_enc = tpg->ycbcr_enc;
 		tpg->real_quantization = tpg->quantization;
-		if (tpg->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
-			switch (tpg->colorspace) {
-			case V4L2_COLORSPACE_REC709:
-				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_709;
-				break;
-			case V4L2_COLORSPACE_SRGB:
-				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_SYCC;
-				break;
-			case V4L2_COLORSPACE_BT2020:
-				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_BT2020;
-				break;
-			case V4L2_COLORSPACE_SMPTE240M:
-				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_SMPTE240M;
-				break;
-			case V4L2_COLORSPACE_SMPTE170M:
-			case V4L2_COLORSPACE_470_SYSTEM_M:
-			case V4L2_COLORSPACE_470_SYSTEM_BG:
-			case V4L2_COLORSPACE_ADOBERGB:
-			default:
-				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_601;
-				break;
-			}
-		}
-		if (tpg->quantization == V4L2_QUANTIZATION_DEFAULT) {
-			tpg->real_quantization = V4L2_QUANTIZATION_FULL_RANGE;
-			if (tpg->is_yuv) {
-				switch (tpg->real_ycbcr_enc) {
-				case V4L2_YCBCR_ENC_SYCC:
-				case V4L2_YCBCR_ENC_XV601:
-				case V4L2_YCBCR_ENC_XV709:
-					break;
-				default:
-					tpg->real_quantization =
-						V4L2_QUANTIZATION_LIM_RANGE;
-					break;
-				}
-			} else if (tpg->colorspace == V4L2_COLORSPACE_BT2020) {
-				/* R'G'B' BT.2020 is limited range */
-				tpg->real_quantization =
-					V4L2_QUANTIZATION_LIM_RANGE;
-			}
-		}
+		if (tpg->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
+			tpg->real_ycbcr_enc =
+				V4L2_MAP_YCBCR_ENC_DEFAULT(tpg->colorspace);
+
+		if (tpg->quantization == V4L2_QUANTIZATION_DEFAULT)
+			tpg->real_quantization =
+				V4L2_MAP_QUANTIZATION_DEFAULT(!tpg->is_yuv,
+					tpg->colorspace, tpg->real_ycbcr_enc);
+
 		tpg_precalculate_colors(tpg);
 	}
 	if (tpg->recalc_square_border) {
-- 
2.1.4

