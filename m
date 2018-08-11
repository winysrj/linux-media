Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:46983 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727263AbeHKNlK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Aug 2018 09:41:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] v4l2-tpg: show either Y'CbCr or HSV encoding
Date: Sat, 11 Aug 2018 13:07:14 +0200
Message-Id: <20180811110715.23872-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When logging the current TPG state detect if we are generating
an Y'CbCr or HSV pattern and report one or the other instead of
both, which is confusing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index abd4c788dffd..e6d13c4fb7b7 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -2038,8 +2038,12 @@ void tpg_log_status(struct tpg_data *tpg)
 			tpg->compose.left, tpg->compose.top);
 	pr_info("tpg colorspace: %d\n", tpg->colorspace);
 	pr_info("tpg transfer function: %d/%d\n", tpg->xfer_func, tpg->real_xfer_func);
-	pr_info("tpg Y'CbCr encoding: %d/%d\n", tpg->ycbcr_enc, tpg->real_ycbcr_enc);
-	pr_info("tpg HSV encoding: %d/%d\n", tpg->hsv_enc, tpg->real_hsv_enc);
+	if (tpg->color_enc == TGP_COLOR_ENC_HSV)
+		pr_info("tpg HSV encoding: %d/%d\n",
+			tpg->hsv_enc, tpg->real_hsv_enc);
+	else if (tpg->color_enc == TGP_COLOR_ENC_YCBCR)
+		pr_info("tpg Y'CbCr encoding: %d/%d\n",
+			tpg->ycbcr_enc, tpg->real_ycbcr_enc);
 	pr_info("tpg quantization: %d/%d\n", tpg->quantization, tpg->real_quantization);
 	pr_info("tpg RGB range: %d/%d\n", tpg->rgb_range, tpg->real_rgb_range);
 }
-- 
2.18.0
