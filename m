Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:37602 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751266AbdDJHyf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 03:54:35 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.12] v4l2-tpg: don't clamp XV601/709 to lim range
Message-ID: <2e34e74f-6f18-4601-a590-4a12e6963c3a@xs4all.nl>
Date: Mon, 10 Apr 2017 09:54:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The XV601/709 encodings are special: they signal limited range, but use the full range
to encode a larger gamut with R', G' and B' values outside the [0-1] range.

So don't clamp to limited range for these two encodings.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index e47b46e2d26c..3dd22da7e17d 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -927,7 +927,14 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		y >>= 4;
 		cb >>= 4;
 		cr >>= 4;
-		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
+		/*
+		 * XV601/709 use the header/footer margins to encode R', G'
+		 * and B' values outside the range [0-1]. So do not clamp
+		 * XV601/709 values.
+		 */
+		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE &&
+		    tpg->real_ycbcr_enc != V4L2_YCBCR_ENC_XV601 &&
+		    tpg->real_ycbcr_enc != V4L2_YCBCR_ENC_XV709) {
 			y = clamp(y, 16, 235);
 			cb = clamp(cb, 16, 240);
 			cr = clamp(cr, 16, 240);
