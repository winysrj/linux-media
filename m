Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37031 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbdFOQdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:33:13 -0400
Received: by mail-wm0-f51.google.com with SMTP id d73so4073930wma.0
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 09:33:13 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v11 13/19] media: venus: hfi_venus: fix variable dereferenced before check
Date: Thu, 15 Jun 2017 19:31:54 +0300
Message-Id: <1497544320-2269-14-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a warning found when building with gcc7:

drivers/media/platform/qcom/venus/hfi_venus.c:998
venus_isr_thread() warn: variable dereferenced before check
'hdev' (see line 994)

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index ab209f3d9498..1caae8feaa36 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -991,13 +991,14 @@ static void venus_process_msg_sys_error(struct venus_hfi_device *hdev,
 static irqreturn_t venus_isr_thread(struct venus_core *core)
 {
 	struct venus_hfi_device *hdev = to_hfi_priv(core);
-	const struct venus_resources *res = hdev->core->res;
+	const struct venus_resources *res;
 	void *pkt;
 	u32 msg_ret;
 
 	if (!hdev)
 		return IRQ_NONE;
 
+	res = hdev->core->res;
 	pkt = hdev->pkt_buf;
 
 	if (hdev->irq_status & WRAPPER_INTR_STATUS_A2HWD_MASK) {
-- 
2.7.4
