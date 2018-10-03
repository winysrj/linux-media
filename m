Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbeJCSSh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 14:18:37 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: [PATCH] venus: vdec: fix decoded data size
Date: Wed,  3 Oct 2018 17:00:21 +0530
Message-Id: <1538566221-21369-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exisiting code returns the max of the decoded size and buffer size.
It turns out that buffer size is always greater due to hardware
alignment requirement. As a result, payload size given to client
is incorrect. This change ensures that the bytesused is assigned
to actual payload size, when available.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 991e158..189ec97 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -888,8 +888,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 		unsigned int opb_sz = venus_helper_get_opb_size(inst);
 
 		vb = &vbuf->vb2_buf;
-		vb->planes[0].bytesused =
-			max_t(unsigned int, opb_sz, bytesused);
+		vb2_set_plane_payload(vb, 0, bytesused ? : opb_sz);
 		vb->planes[0].data_offset = data_offset;
 		vb->timestamp = timestamp_us * NSEC_PER_USEC;
 		vbuf->sequence = inst->sequence_cap++;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
