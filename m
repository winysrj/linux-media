Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45333 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404AbbDXORF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 10:17:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] vivid-tpg: add full range BT.2020C support
Date: Fri, 24 Apr 2015 16:16:25 +0200
Message-Id: <1429884986-38671-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
References: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to be consistent with the other Y'CbCr encodings add
support for full range V4L2_YCBCR_ENC_BT2020_CONST_LUM.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 40 +++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index a7ead15..097d299 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -494,6 +494,14 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 		{ COEFF(-0.1396, 255), COEFF(-0.3604, 255), COEFF(0.5, 255)     },
 		{ COEFF(0.5, 255),     COEFF(-0.4698, 255), COEFF(-0.0402, 255) },
 	};
+	static const int bt2020c[4] = {
+		COEFF(1.0 / 1.9404, 224), COEFF(1.0 / 1.5816, 224),
+		COEFF(1.0 / 1.7184, 224), COEFF(1.0 / 0.9936, 224),
+	};
+	static const int bt2020c_full[4] = {
+		COEFF(1.0 / 1.9404, 255), COEFF(1.0 / 1.5816, 255),
+		COEFF(1.0 / 1.7184, 255), COEFF(1.0 / 0.9936, 255),
+	};
 
 	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
 	unsigned y_offset = full ? 0 : 16;
@@ -513,15 +521,15 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 			 COEFF(0.6780, 255) * rec709_to_linear(g) +
 			 COEFF(0.0593, 255) * rec709_to_linear(b)) >> 16;
 		yc = linear_to_rec709(lin_y);
-		*y = (yc * 219) / 255 + (16 << 4);
+		*y = full ? yc : (yc * 219) / 255 + (16 << 4);
 		if (b <= yc)
-			*cb = (((b - yc) * COEFF(1.0 / 1.9404, 224)) >> 16) + (128 << 4);
+			*cb = (((b - yc) * (full ? bt2020c_full[0] : bt2020c[0])) >> 16) + (128 << 4);
 		else
-			*cb = (((b - yc) * COEFF(1.0 / 1.5816, 224)) >> 16) + (128 << 4);
+			*cb = (((b - yc) * (full ? bt2020c_full[1] : bt2020c[1])) >> 16) + (128 << 4);
 		if (r <= yc)
-			*cr = (((r - yc) * COEFF(1.0 / 1.7184, 224)) >> 16) + (128 << 4);
+			*cr = (((r - yc) * (full ? bt2020c_full[2] : bt2020c[2])) >> 16) + (128 << 4);
 		else
-			*cr = (((r - yc) * COEFF(1.0 / 0.9936, 224)) >> 16) + (128 << 4);
+			*cr = (((r - yc) * (full ? bt2020c_full[3] : bt2020c[3])) >> 16) + (128 << 4);
 		break;
 	case V4L2_YCBCR_ENC_SMPTE240M:
 		rgb2ycbcr(full ? smpte240m_full : smpte240m, r, g, b, y_offset, y, cb, cr);
@@ -593,8 +601,18 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 		{ COEFF(1, 255), COEFF(-0.1646, 255), COEFF(-0.5714, 255) },
 		{ COEFF(1, 255), COEFF(1.8814, 255),  COEFF(0, 255)       },
 	};
+	static const int bt2020c[4] = {
+		COEFF(1.9404, 224), COEFF(1.5816, 224),
+		COEFF(1.7184, 224), COEFF(0.9936, 224),
+	};
+	static const int bt2020c_full[4] = {
+		COEFF(1.9404, 255), COEFF(1.5816, 255),
+		COEFF(1.7184, 255), COEFF(0.9936, 255),
+	};
+
 	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
 	unsigned y_offset = full ? 0 : 16;
+	int y_fac = full ? COEFF(1.0, 255) : COEFF(1.0, 219);
 	int lin_r, lin_g, lin_b, lin_y;
 
 	switch (tpg->real_ycbcr_enc) {
@@ -607,23 +625,23 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 		ycbcr2rgb(full ? bt2020_full : bt2020, y, cb, cr, y_offset, r, g, b);
 		break;
 	case V4L2_YCBCR_ENC_BT2020_CONST_LUM:
-		y -= 16 << 4;
+		y -= full ? 0 : 16 << 4;
 		cb -= 128 << 4;
 		cr -= 128 << 4;
 
 		if (cb <= 0)
-			*b = COEFF(1.0, 219) * y + COEFF(1.9404, 224) * cb;
+			*b = y_fac * y + (full ? bt2020c_full[0] : bt2020c[0]) * cb;
 		else
-			*b = COEFF(1.0, 219) * y + COEFF(1.5816, 224) * cb;
+			*b = y_fac * y + (full ? bt2020c_full[1] : bt2020c[1]) * cb;
 		*b = *b >> 12;
 		if (cr <= 0)
-			*r = COEFF(1.0, 219) * y + COEFF(1.7184, 224) * cr;
+			*r = y_fac * y + (full ? bt2020c_full[2] : bt2020c[2]) * cr;
 		else
-			*r = COEFF(1.0, 219) * y + COEFF(0.9936, 224) * cr;
+			*r = y_fac * y + (full ? bt2020c_full[3] : bt2020c[3]) * cr;
 		*r = *r >> 12;
 		lin_r = rec709_to_linear(*r);
 		lin_b = rec709_to_linear(*b);
-		lin_y = rec709_to_linear((y * 255) / 219);
+		lin_y = rec709_to_linear((y * 255) / (full ? 255 : 219));
 
 		lin_g = COEFF(1.0 / 0.6780, 255) * lin_y -
 			COEFF(0.2627 / 0.6780, 255) * lin_r -
-- 
2.1.4

