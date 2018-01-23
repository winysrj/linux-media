Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.149.13]:35878 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751721AbeAWSPD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 13:15:03 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 62C7E19179A0
        for <linux-media@vger.kernel.org>; Tue, 23 Jan 2018 11:54:55 -0600 (CST)
Date: Tue, 23 Jan 2018 11:54:53 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] venus: hfi: use true for boolean values
Message-ID: <20180123175453.GA12327@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Assign true or false to boolean variables instead of an integer value.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/qcom/venus/hfi_msgs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index a681ae5..90c93d9 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -659,10 +659,10 @@ static u32 init_done_read_prop(struct venus_core *core, struct venus_inst *inst,
 				    prop->buffer_type == HFI_BUFFER_OUTPUT2) {
 					switch (prop->data[i]) {
 					case HFI_BUFFER_MODE_STATIC:
-						inst->cap_bufs_mode_static = 1;
+						inst->cap_bufs_mode_static = true;
 						break;
 					case HFI_BUFFER_MODE_DYNAMIC:
-						inst->cap_bufs_mode_dynamic = 1;
+						inst->cap_bufs_mode_dynamic = true;
 						break;
 					default:
 						break;
-- 
2.7.4
