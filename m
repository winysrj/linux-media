Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48389 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbbA0Qxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 11:53:30 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3655F2A0092
	for <linux-media@vger.kernel.org>; Tue, 27 Jan 2015 17:52:58 +0100 (CET)
Message-ID: <54C7C26A.2050004@xs4all.nl>
Date: Tue, 27 Jan 2015 17:52:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.19] vivid: Y offset should depend on quant. range
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When converting to or from Y'CbCr and R'G'B' the Y offset depends
on the quantization range: it's 0 for full and 16 for limited range.
But in the code it was hardcoded to 16. This messed up the brightness
of the generated pattern.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index fc9c653..34493f4 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -352,13 +352,14 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 		{ COEFF(0.5, 224),     COEFF(-0.4629, 224), COEFF(-0.0405, 224) },
 	};
 	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
+	unsigned y_offset = full ? 0 : 16;
 	int lin_y, yc;
 
 	switch (tpg->real_ycbcr_enc) {
 	case V4L2_YCBCR_ENC_601:
 	case V4L2_YCBCR_ENC_XV601:
 	case V4L2_YCBCR_ENC_SYCC:
-		rgb2ycbcr(full ? bt601_full : bt601, r, g, b, 16, y, cb, cr);
+		rgb2ycbcr(full ? bt601_full : bt601, r, g, b, y_offset, y, cb, cr);
 		break;
 	case V4L2_YCBCR_ENC_BT2020:
 		rgb2ycbcr(bt2020, r, g, b, 16, y, cb, cr);
@@ -384,7 +385,7 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 	case V4L2_YCBCR_ENC_709:
 	case V4L2_YCBCR_ENC_XV709:
 	default:
-		rgb2ycbcr(full ? rec709_full : rec709, r, g, b, 0, y, cb, cr);
+		rgb2ycbcr(full ? rec709_full : rec709, r, g, b, y_offset, y, cb, cr);
 		break;
 	}
 }
@@ -439,13 +440,14 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 		{ COEFF(1, 219), COEFF(1.8814, 224),  COEFF(0, 224)       },
 	};
 	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
+	unsigned y_offset = full ? 0 : 16;
 	int lin_r, lin_g, lin_b, lin_y;
 
 	switch (tpg->real_ycbcr_enc) {
 	case V4L2_YCBCR_ENC_601:
 	case V4L2_YCBCR_ENC_XV601:
 	case V4L2_YCBCR_ENC_SYCC:
-		ycbcr2rgb(full ? bt601_full : bt601, y, cb, cr, 16, r, g, b);
+		ycbcr2rgb(full ? bt601_full : bt601, y, cb, cr, y_offset, r, g, b);
 		break;
 	case V4L2_YCBCR_ENC_BT2020:
 		ycbcr2rgb(bt2020, y, cb, cr, 16, r, g, b);
@@ -480,7 +482,7 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 	case V4L2_YCBCR_ENC_709:
 	case V4L2_YCBCR_ENC_XV709:
 	default:
-		ycbcr2rgb(full ? rec709_full : rec709, y, cb, cr, 16, r, g, b);
+		ycbcr2rgb(full ? rec709_full : rec709, y, cb, cr, y_offset, r, g, b);
 		break;
 	}
 }
-- 
2.1.4

