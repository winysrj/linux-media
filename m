Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60602 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbbDXORE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 10:17:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/5] vivid-tpg: add full range BT.2020 support
Date: Fri, 24 Apr 2015 16:16:24 +0200
Message-Id: <1429884986-38671-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
References: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to be consistent with the other Y'CbCr encodings add
support for full range V4L2_YCBCR_ENC_BT2020.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 59bdbae..a7ead15 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -489,6 +489,12 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 		{ COEFF(-0.1396, 224), COEFF(-0.3604, 224), COEFF(0.5, 224)     },
 		{ COEFF(0.5, 224),     COEFF(-0.4598, 224), COEFF(-0.0402, 224) },
 	};
+	static const int bt2020_full[3][3] = {
+		{ COEFF(0.2627, 255),  COEFF(0.6780, 255),  COEFF(0.0593, 255)  },
+		{ COEFF(-0.1396, 255), COEFF(-0.3604, 255), COEFF(0.5, 255)     },
+		{ COEFF(0.5, 255),     COEFF(-0.4698, 255), COEFF(-0.0402, 255) },
+	};
+
 	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
 	unsigned y_offset = full ? 0 : 16;
 	int lin_y, yc;
@@ -500,7 +506,7 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 		rgb2ycbcr(full ? bt601_full : bt601, r, g, b, y_offset, y, cb, cr);
 		break;
 	case V4L2_YCBCR_ENC_BT2020:
-		rgb2ycbcr(bt2020, r, g, b, 16, y, cb, cr);
+		rgb2ycbcr(full ? bt2020_full : bt2020, r, g, b, y_offset, y, cb, cr);
 		break;
 	case V4L2_YCBCR_ENC_BT2020_CONST_LUM:
 		lin_y = (COEFF(0.2627, 255) * rec709_to_linear(r) +
@@ -582,6 +588,11 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 		{ COEFF(1, 219), COEFF(-0.1646, 224), COEFF(-0.5714, 224) },
 		{ COEFF(1, 219), COEFF(1.8814, 224),  COEFF(0, 224)       },
 	};
+	static const int bt2020_full[3][3] = {
+		{ COEFF(1, 255), COEFF(0, 255),       COEFF(1.4746, 255)  },
+		{ COEFF(1, 255), COEFF(-0.1646, 255), COEFF(-0.5714, 255) },
+		{ COEFF(1, 255), COEFF(1.8814, 255),  COEFF(0, 255)       },
+	};
 	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
 	unsigned y_offset = full ? 0 : 16;
 	int lin_r, lin_g, lin_b, lin_y;
@@ -593,7 +604,7 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 		ycbcr2rgb(full ? bt601_full : bt601, y, cb, cr, y_offset, r, g, b);
 		break;
 	case V4L2_YCBCR_ENC_BT2020:
-		ycbcr2rgb(bt2020, y, cb, cr, 16, r, g, b);
+		ycbcr2rgb(full ? bt2020_full : bt2020, y, cb, cr, y_offset, r, g, b);
 		break;
 	case V4L2_YCBCR_ENC_BT2020_CONST_LUM:
 		y -= 16 << 4;
-- 
2.1.4

