Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38464 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933055AbeGBHoS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 03:44:18 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: [PATCH] venus: vdec: fix decoded data size
Date: Mon,  2 Jul 2018 13:14:07 +0530
Message-Id: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exisiting code returns the max of the decoded
size and buffer size. It turns out that buffer
size is always greater due to hardware alignment
requirement. As a result, payload size given to
client is incorrect. This change ensures that
the bytesused is assigned to actual payload size.

Change-Id: Ie6f3429c0cb23f682544748d181fa4fa63ca2e28
Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index d079aeb..ada1d2f 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 
 		vb = &vbuf->vb2_buf;
 		vb->planes[0].bytesused =
-			max_t(unsigned int, opb_sz, bytesused);
+			min_t(unsigned int, opb_sz, bytesused);
 		vb->planes[0].data_offset = data_offset;
 		vb->timestamp = timestamp_us * NSEC_PER_USEC;
 		vbuf->sequence = inst->sequence_cap++;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
