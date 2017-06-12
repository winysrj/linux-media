Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:33857 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754712AbdFLQ3u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 12:29:50 -0400
Received: by mail-wr0-f171.google.com with SMTP id g76so101840423wrd.1
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 09:29:49 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v10 10/18] media: venus: hfi: fix mutex unlock
Date: Mon, 12 Jun 2017 19:27:47 +0300
Message-Id: <1497284875-19999-11-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixed a warning when build driver with gcc7:

drivers/media/platform/qcom/venus/hfi.c:171
hfi_core_ping() warn: inconsistent returns 'mutex:&core->lock'.
  Locked on:   line 159
  Unlocked on: line 171

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 20c9205fdbb4..c09490876516 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -156,7 +156,7 @@ int hfi_core_ping(struct venus_core *core)
 
 	ret = core->ops->core_ping(core, 0xbeef);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	ret = wait_for_completion_timeout(&core->done, TIMEOUT);
 	if (!ret) {
-- 
2.7.4
