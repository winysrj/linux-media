Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:33966 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754805AbdFLQaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 12:30:04 -0400
Received: by mail-wr0-f169.google.com with SMTP id g76so101845672wrd.1
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 09:30:03 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v10 15/18] media: venus: vdec: fix compile error in vdec_close
Date: Mon, 12 Jun 2017 19:27:52 +0300
Message-Id: <1497284875-19999-16-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the following compile error ocured when building
with gcc7:

drivers/media/platform/qcom/venus/vdec.c:1022
vdec_close() error: dereferencing freed memory 'inst'

by moving kfree as a last call.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 96e7e7e71e5f..594315b55b1f 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1017,9 +1017,10 @@ static int vdec_close(struct file *file)
 	mutex_destroy(&inst->lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
-	kfree(inst);
 
 	pm_runtime_put_sync(inst->core->dev_dec);
+
+	kfree(inst);
 	return 0;
 }
 
-- 
2.7.4
