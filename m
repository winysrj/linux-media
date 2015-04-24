Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45333 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900AbbDXORB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 10:17:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/5] vivid-tpg: add full range SMPTE 240M support
Date: Fri, 24 Apr 2015 16:16:23 +0200
Message-Id: <1429884986-38671-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
References: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to be consistent with the other Y'CbCr encodings add
support for full range V4L2_YCBCR_ENC_SMPTE240M.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 69cd8fb..59bdbae 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -479,6 +479,11 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 		{ COEFF(-0.116, 224), COEFF(-0.384, 224), COEFF(0.5, 224)    },
 		{ COEFF(0.5, 224),    COEFF(-0.445, 224), COEFF(-0.055, 224) },
 	};
+	static const int smpte240m_full[3][3] = {
+		{ COEFF(0.212, 255),  COEFF(0.701, 255),  COEFF(0.087, 255)  },
+		{ COEFF(-0.116, 255), COEFF(-0.384, 255), COEFF(0.5, 255)    },
+		{ COEFF(0.5, 255),    COEFF(-0.445, 255), COEFF(-0.055, 255) },
+	};
 	static const int bt2020[3][3] = {
 		{ COEFF(0.2627, 219),  COEFF(0.6780, 219),  COEFF(0.0593, 219)  },
 		{ COEFF(-0.1396, 224), COEFF(-0.3604, 224), COEFF(0.5, 224)     },
@@ -513,7 +518,7 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 			*cr = (((r - yc) * COEFF(1.0 / 0.9936, 224)) >> 16) + (128 << 4);
 		break;
 	case V4L2_YCBCR_ENC_SMPTE240M:
-		rgb2ycbcr(smpte240m, r, g, b, 16, y, cb, cr);
+		rgb2ycbcr(full ? smpte240m_full : smpte240m, r, g, b, y_offset, y, cb, cr);
 		break;
 	case V4L2_YCBCR_ENC_709:
 	case V4L2_YCBCR_ENC_XV709:
@@ -567,6 +572,11 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 		{ COEFF(1, 219), COEFF(-0.2253, 224), COEFF(-0.4767, 224) },
 		{ COEFF(1, 219), COEFF(1.8270, 224),  COEFF(0, 224)       },
 	};
+	static const int smpte240m_full[3][3] = {
+		{ COEFF(1, 255), COEFF(0, 255),       COEFF(1.5756, 255)  },
+		{ COEFF(1, 255), COEFF(-0.2253, 255), COEFF(-0.4767, 255) },
+		{ COEFF(1, 255), COEFF(1.8270, 255),  COEFF(0, 255)       },
+	};
 	static const int bt2020[3][3] = {
 		{ COEFF(1, 219), COEFF(0, 224),       COEFF(1.4746, 224)  },
 		{ COEFF(1, 219), COEFF(-0.1646, 224), COEFF(-0.5714, 224) },
@@ -610,7 +620,7 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 		*g = linear_to_rec709(lin_g >> 12);
 		break;
 	case V4L2_YCBCR_ENC_SMPTE240M:
-		ycbcr2rgb(smpte240m, y, cb, cr, 16, r, g, b);
+		ycbcr2rgb(full ? smpte240m_full : smpte240m, y, cb, cr, y_offset, r, g, b);
 		break;
 	case V4L2_YCBCR_ENC_709:
 	case V4L2_YCBCR_ENC_XV709:
-- 
2.1.4

