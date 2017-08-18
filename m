Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.250]:34333 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750846AbdHRQ1u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 12:27:50 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 8C5242BDA7
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 11:07:20 -0500 (CDT)
Date: Fri, 18 Aug 2017 11:07:19 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] venus: fix copy/paste error in return_buf_error
Message-ID: <20170818160719.GA4899@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96fa5d72-66d1-d28e-5d9f-d991e0c1ce83@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call function v4l2_m2m_dst_buf_remove_by_buf() instead of
v4l2_m2m_src_buf_remove_by_buf()

Addresses-Coverity-ID: 1415317
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 Stanimir Varbanov confirmed this is a bug. The correct fix is to call
 function v4l2_m2m_dst_buf_remove_by_buf instead of function
 v4l2_m2m_src_buf_remove_by_buf in the _else_ branch.

 drivers/media/platform/qcom/venus/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 5f4434c..2d61879 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -243,7 +243,7 @@ static void return_buf_error(struct venus_inst *inst,
 	if (vbuf->vb2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
 	else
-		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
+		v4l2_m2m_dst_buf_remove_by_buf(m2m_ctx, vbuf);
 
 	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 }
-- 
2.5.0
