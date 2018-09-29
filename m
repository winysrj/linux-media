Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53292 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbeI2S3O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 14:29:14 -0400
From: Srinu Gorle <sgorle@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        sgorle@codeaurora.org
Cc: acourbot@chromium.org, vgarodia@codeaurora.org
Subject: [PATCH v1 4/5] media: venus: video decoder drop frames handling
Date: Sat, 29 Sep 2018 17:30:31 +0530
Message-Id: <1538222432-25894-5-git-send-email-sgorle@codeaurora.org>
In-Reply-To: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- when drop frame flag received from venus h/w, reset buffer
  parameters and update v4l2 buffer flags as error buffer.

Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 0035cf2..311f209 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -991,6 +991,12 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 	if (hfi_flags & HFI_BUFFERFLAG_DATACORRUPT)
 		state = VB2_BUF_STATE_ERROR;
 
+	if (hfi_flags & HFI_BUFFERFLAG_DROP_FRAME) {
+		vb->planes[0].bytesused = 0;
+		vb->timestamp = 0;
+		state = VB2_BUF_STATE_ERROR;
+	}
+
 	v4l2_m2m_buf_done(vbuf, state);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
