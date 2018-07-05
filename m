Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54997 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754207AbeGENFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:12 -0400
Received: by mail-wm0-f66.google.com with SMTP id i139-v6so10960556wmf.4
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:11 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 04/27] venus: hfi_cmds: add set_properties for 4xx version
Date: Thu,  5 Jul 2018 16:03:38 +0300
Message-Id: <20180705130401.24315-5-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds set_properties method to handle newer 4xx properties and
fall-back to 3xx for the rest.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_cmds.c | 62 +++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
index 1cfeb7743041..e8389d8d8c48 100644
--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -1166,6 +1166,63 @@ pkt_session_set_property_3xx(struct hfi_session_set_property_pkt *pkt,
 	return ret;
 }
 
+static int
+pkt_session_set_property_4xx(struct hfi_session_set_property_pkt *pkt,
+			     void *cookie, u32 ptype, void *pdata)
+{
+	void *prop_data;
+
+	if (!pkt || !cookie || !pdata)
+		return -EINVAL;
+
+	prop_data = &pkt->data[1];
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_PROPERTY;
+	pkt->shdr.session_id = hash32_ptr(cookie);
+	pkt->num_properties = 1;
+	pkt->data[0] = ptype;
+
+	/*
+	 * Any session set property which is different in 3XX packetization
+	 * should be added as a new case below. All unchanged session set
+	 * properties will be handled in the default case.
+	 */
+	switch (ptype) {
+	case HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL: {
+		struct hfi_buffer_count_actual *in = pdata;
+		struct hfi_buffer_count_actual_4xx *count = prop_data;
+
+		count->count_actual = in->count_actual;
+		count->type = in->type;
+		count->count_min_host = in->count_actual;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*count);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_WORK_MODE: {
+		struct hfi_video_work_mode *in = pdata, *wm = prop_data;
+
+		wm->video_work_mode = in->video_work_mode;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*wm);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VIDEOCORES_USAGE: {
+		struct hfi_videocores_usage_type *in = pdata, *cu = prop_data;
+
+		cu->video_core_enable_mask = in->video_core_enable_mask;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*cu);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
+		/* not implemented on Venus 4xx */
+		break;
+	default:
+		return pkt_session_set_property_3xx(pkt, cookie, ptype, pdata);
+	}
+
+	return 0;
+}
+
 int pkt_session_get_property(struct hfi_session_get_property_pkt *pkt,
 			     void *cookie, u32 ptype)
 {
@@ -1181,7 +1238,10 @@ int pkt_session_set_property(struct hfi_session_set_property_pkt *pkt,
 	if (hfi_ver == HFI_VERSION_1XX)
 		return pkt_session_set_property_1x(pkt, cookie, ptype, pdata);
 
-	return pkt_session_set_property_3xx(pkt, cookie, ptype, pdata);
+	if (hfi_ver == HFI_VERSION_3XX)
+		return pkt_session_set_property_3xx(pkt, cookie, ptype, pdata);
+
+	return pkt_session_set_property_4xx(pkt, cookie, ptype, pdata);
 }
 
 void pkt_set_version(enum hfi_version version)
-- 
2.14.1
