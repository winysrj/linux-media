Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45333 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599AbbDXORG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 10:17:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] vivid-tpg: fix XV601/709 Y'CbCr encoding
Date: Fri, 24 Apr 2015 16:16:26 +0200
Message-Id: <1429884986-38671-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
References: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For these encodings the quantization range should be ignored, since
there is only one possible Y'CbCr encoding.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 097d299..4df755a 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -509,10 +509,19 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 
 	switch (tpg->real_ycbcr_enc) {
 	case V4L2_YCBCR_ENC_601:
-	case V4L2_YCBCR_ENC_XV601:
 	case V4L2_YCBCR_ENC_SYCC:
 		rgb2ycbcr(full ? bt601_full : bt601, r, g, b, y_offset, y, cb, cr);
 		break;
+	case V4L2_YCBCR_ENC_XV601:
+		/* Ignore quantization range, there is only one possible
+		 * Y'CbCr encoding. */
+		rgb2ycbcr(bt601, r, g, b, 16, y, cb, cr);
+		break;
+	case V4L2_YCBCR_ENC_XV709:
+		/* Ignore quantization range, there is only one possible
+		 * Y'CbCr encoding. */
+		rgb2ycbcr(rec709, r, g, b, 16, y, cb, cr);
+		break;
 	case V4L2_YCBCR_ENC_BT2020:
 		rgb2ycbcr(full ? bt2020_full : bt2020, r, g, b, y_offset, y, cb, cr);
 		break;
@@ -535,7 +544,6 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 		rgb2ycbcr(full ? smpte240m_full : smpte240m, r, g, b, y_offset, y, cb, cr);
 		break;
 	case V4L2_YCBCR_ENC_709:
-	case V4L2_YCBCR_ENC_XV709:
 	default:
 		rgb2ycbcr(full ? rec709_full : rec709, r, g, b, y_offset, y, cb, cr);
 		break;
@@ -617,10 +625,19 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 
 	switch (tpg->real_ycbcr_enc) {
 	case V4L2_YCBCR_ENC_601:
-	case V4L2_YCBCR_ENC_XV601:
 	case V4L2_YCBCR_ENC_SYCC:
 		ycbcr2rgb(full ? bt601_full : bt601, y, cb, cr, y_offset, r, g, b);
 		break;
+	case V4L2_YCBCR_ENC_XV601:
+		/* Ignore quantization range, there is only one possible
+		 * Y'CbCr encoding. */
+		ycbcr2rgb(bt601, y, cb, cr, 16, r, g, b);
+		break;
+	case V4L2_YCBCR_ENC_XV709:
+		/* Ignore quantization range, there is only one possible
+		 * Y'CbCr encoding. */
+		ycbcr2rgb(rec709, y, cb, cr, 16, r, g, b);
+		break;
 	case V4L2_YCBCR_ENC_BT2020:
 		ycbcr2rgb(full ? bt2020_full : bt2020, y, cb, cr, y_offset, r, g, b);
 		break;
@@ -652,7 +669,6 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 		ycbcr2rgb(full ? smpte240m_full : smpte240m, y, cb, cr, y_offset, r, g, b);
 		break;
 	case V4L2_YCBCR_ENC_709:
-	case V4L2_YCBCR_ENC_XV709:
 	default:
 		ycbcr2rgb(full ? rec709_full : rec709, y, cb, cr, y_offset, r, g, b);
 		break;
-- 
2.1.4

