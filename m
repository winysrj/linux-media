Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:34126 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752739AbdFOQdj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:33:39 -0400
Received: by mail-wr0-f182.google.com with SMTP id 77so25379050wrb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 09:33:39 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v11 14/19] media: venus: hfi_msgs: fix set but not used variables
Date: Thu, 15 Jun 2017 19:31:55 +0300
Message-Id: <1497544320-2269-15-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a warning found when building with gcc7:

drivers/media/platform/qcom/venus/hfi_msgs.c:465:40:
warning: variable 'domain' set but not used [-Wunused-but-set-variable]
  u32 rem_bytes, num_props, codecs = 0, domain = 0;
                                        ^~~~~~
drivers/media/platform/qcom/venus/hfi_msgs.c:465:28:
warning: variable 'codecs' set but not used [-Wunused-but-set-variable]
  u32 rem_bytes, num_props, codecs = 0, domain = 0;

The warning is avoided by deleting the variables declaration.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_msgs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index 88898118f6af..f8841713e417 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -462,7 +462,7 @@ static u32 init_done_read_prop(struct venus_core *core, struct venus_inst *inst,
 			       struct hfi_msg_session_init_done_pkt *pkt)
 {
 	struct device *dev = core->dev;
-	u32 rem_bytes, num_props, codecs = 0, domain = 0;
+	u32 rem_bytes, num_props;
 	u32 ptype, next_offset = 0;
 	u32 err;
 	u8 *data;
@@ -490,8 +490,6 @@ static u32 init_done_read_prop(struct venus_core *core, struct venus_inst *inst,
 				(struct hfi_codec_mask_supported *)
 				(data + next_offset);
 
-			codecs = masks->codecs;
-			domain = masks->video_domains;
 			next_offset += sizeof(*masks);
 			num_props--;
 			break;
-- 
2.7.4
