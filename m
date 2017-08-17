Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.1]:31913 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752872AbdHQXfq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 19:35:46 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 40F941BC7462
        for <linux-media@vger.kernel.org>; Thu, 17 Aug 2017 18:12:35 -0500 (CDT)
Date: Thu, 17 Aug 2017 18:12:34 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] media: venus: fix duplicated code for different branches
Message-ID: <20170817231234.GA6674@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor code in order to avoid identical code for different branches.

This issue was detected with the help of Coccinelle.

Addresses-Coverity-ID: 1415317
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
This code was reported by Coverity and it was tested by compilation only.
Please, verify if this is an actual bug.

 drivers/media/platform/qcom/venus/helpers.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 5f4434c..8a5c467 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -240,11 +240,7 @@ static void return_buf_error(struct venus_inst *inst,
 {
 	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
 
-	if (vbuf->vb2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
-	else
-		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
-
+	v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
 	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 }
 
-- 
2.5.0
