Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbeI2S3S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 14:29:18 -0400
From: Srinu Gorle <sgorle@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        sgorle@codeaurora.org
Cc: acourbot@chromium.org, vgarodia@codeaurora.org
Subject: [PATCH v1 5/5] media: venus: update number of bytes used field properly for EOS frames
Date: Sat, 29 Sep 2018 17:30:32 +0530
Message-Id: <1538222432-25894-6-git-send-email-sgorle@codeaurora.org>
In-Reply-To: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- In video decoder session, update number of bytes used for
  yuv buffers appropriately for EOS buffers.

Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 311f209..a48eed1 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -978,7 +978,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 
 		if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
 			const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
-
+			vb->planes[0].bytesused = bytesused;
 			v4l2_event_queue_fh(&inst->fh, &ev);
 		}
 	} else {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
