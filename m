Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:34104 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbdFOQdW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:33:22 -0400
Received: by mail-wr0-f169.google.com with SMTP id 77so25378075wrb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 09:33:16 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v11 12/19] media: venus: helpers: fix variable dereferenced before check
Date: Thu, 15 Jun 2017 19:31:53 +0300
Message-Id: <1497544320-2269-13-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a warning found when building the driver with gcc7:

drivers/media/platform/qcom/venus/helpers.c:157
load_per_instance() warn: variable dereferenced before check
'inst' (see line 153)

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index f777ef80b941..5f4434c0a8f1 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -150,14 +150,12 @@ static int intbufs_free(struct venus_inst *inst)
 
 static u32 load_per_instance(struct venus_inst *inst)
 {
-	u32 w = inst->width;
-	u32 h = inst->height;
 	u32 mbs;
 
 	if (!inst || !(inst->state >= INST_INIT && inst->state < INST_STOP))
 		return 0;
 
-	mbs = (ALIGN(w, 16) / 16) * (ALIGN(h, 16) / 16);
+	mbs = (ALIGN(inst->width, 16) / 16) * (ALIGN(inst->height, 16) / 16);
 
 	return mbs * inst->fps;
 }
-- 
2.7.4
