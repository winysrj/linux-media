Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43960 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757836AbeDXMpS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:45:18 -0400
Received: by mail-wr0-f195.google.com with SMTP id v15-v6so31693408wrm.10
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 05:45:18 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 10/28] venus: vdec: call session_continue in insufficient event
Date: Tue, 24 Apr 2018 15:44:18 +0300
Message-Id: <20180424124436.26955-11-stanimir.varbanov@linaro.org>
In-Reply-To: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call session_continue for Venus 4xx version even when the event
says that the buffer resources are not sufficient. Leaving a
comment with more information about the workaround.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index c45452634e7e..91c7384ff9c8 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -873,6 +873,14 @@ static void vdec_event_notify(struct venus_inst *inst, u32 event,
 
 			dev_dbg(dev, "event not sufficient resources (%ux%u)\n",
 				data->width, data->height);
+			/*
+			 * Workaround: Even that the firmware send and event for
+			 * insufficient buffer resources it is safe to call
+			 * session_continue because actually the event says that
+			 * the number of capture buffers is lower.
+			 */
+			if (IS_V4(core))
+				hfi_session_continue(inst);
 			break;
 		case HFI_EVENT_RELEASE_BUFFER_REFERENCE:
 			venus_helper_release_buf_ref(inst, data->tag);
-- 
2.14.1
