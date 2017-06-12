Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:36821 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754859AbdFLQ34 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 12:29:56 -0400
Received: by mail-wr0-f181.google.com with SMTP id v111so103598565wrc.3
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 09:29:56 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v10 11/18] media: venus: hfi_cmds: fix variable dereferenced before check
Date: Mon, 12 Jun 2017 19:27:48 +0300
Message-Id: <1497284875-19999-12-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a warning found when building the driver with gcc7:

drivers/media/platform/qcom/venus/hfi_cmds.c:415
pkt_session_set_property_1x() warn: variable dereferenced before
check 'pkt' (see line 412)
drivers/media/platform/qcom/venus/hfi_cmds.c:1177
pkt_session_set_property_3xx() warn: variable dereferenced before
check 'pkt' (see line 1174)

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_cmds.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
index dad41a6af42e..b83c5b8ddccb 100644
--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -409,12 +409,14 @@ static int pkt_session_get_property_1x(struct hfi_session_get_property_pkt *pkt,
 static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 				       void *cookie, u32 ptype, void *pdata)
 {
-	void *prop_data = &pkt->data[1];
+	void *prop_data;
 	int ret = 0;
 
 	if (!pkt || !cookie || !pdata)
 		return -EINVAL;
 
+	prop_data = &pkt->data[1];
+
 	pkt->shdr.hdr.size = sizeof(*pkt);
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_PROPERTY;
 	pkt->shdr.session_id = hash32_ptr(cookie);
@@ -1171,12 +1173,14 @@ static int
 pkt_session_set_property_3xx(struct hfi_session_set_property_pkt *pkt,
 			     void *cookie, u32 ptype, void *pdata)
 {
-	void *prop_data = &pkt->data[1];
+	void *prop_data;
 	int ret = 0;
 
 	if (!pkt || !cookie || !pdata)
 		return -EINVAL;
 
+	prop_data = &pkt->data[1];
+
 	pkt->shdr.hdr.size = sizeof(*pkt);
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_PROPERTY;
 	pkt->shdr.session_id = hash32_ptr(cookie);
-- 
2.7.4
