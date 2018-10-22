Return-path: <linux-media-owner@vger.kernel.org>
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:62590 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbeJVUYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 16:24:24 -0400
From: Malathi Gottam <mgottam@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: [PATCH v2] media: venus: handle peak bitrate set property
Date: Mon, 22 Oct 2018 17:35:12 +0530
Message-Id: <1540209912-24834-1-git-send-email-mgottam@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Max bitrate property is not supported for venus version 4xx.
Return unsupported from packetization layer. Handle it in 
hfi_venus layer to exit gracefully to venc layer.

Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
---
 drivers/media/platform/qcom/venus/hfi_cmds.c  | 2 +-
 drivers/media/platform/qcom/venus/hfi_venus.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
index e8389d8..87a4414 100644
--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -1215,7 +1215,7 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	}
 	case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
 		/* not implemented on Venus 4xx */
-		break;
+		return -ENOTSUPP;
 	default:
 		return pkt_session_set_property_3xx(pkt, cookie, ptype, pdata);
 	}
diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 1240855..9d086b9 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1355,6 +1355,8 @@ static int venus_session_set_property(struct venus_inst *inst, u32 ptype,
 	pkt = (struct hfi_session_set_property_pkt *)packet;
 
 	ret = pkt_session_set_property(pkt, inst, ptype, pdata);
+	if (ret == -ENOTSUPP)
+		return 0;
 	if (ret)
 		return ret;
 
-- 
1.9.1
