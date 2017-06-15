Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:33635 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbdFOQdT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:33:19 -0400
Received: by mail-wr0-f170.google.com with SMTP id r103so25474943wrb.0
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 09:33:18 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v11 16/19] media: venus: venc: fix compile error in venc_close
Date: Thu, 15 Jun 2017 19:31:57 +0300
Message-Id: <1497544320-2269-17-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the following compile error ocured when building
with gcc7:

drivers/media/platform/qcom/venus/venc.c:1150
venc_close() error: dereferencing freed memory 'inst'

by moving kfree as a last call.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/venc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index d5b4b5bf10a2..39748e7a08e4 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1145,10 +1145,10 @@ static int venc_close(struct file *file)
 	mutex_destroy(&inst->lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
-	kfree(inst);
 
 	pm_runtime_put_sync(inst->core->dev_enc);
 
+	kfree(inst);
 	return 0;
 }
 
-- 
2.7.4
