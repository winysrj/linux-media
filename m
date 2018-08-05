Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.50.28]:16748 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726069AbeHECfg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 22:35:36 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id B213B400D22A3
        for <linux-media@vger.kernel.org>; Sat,  4 Aug 2018 19:12:59 -0500 (CDT)
Date: Sat, 4 Aug 2018 19:12:57 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] venus: helpers: use true and false for boolean values
Message-ID: <20180805001257.GA21110@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return statements in functions returning bool should use true or false
instead of an integer value.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/qcom/venus/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index cd3b96e..e436385 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -472,7 +472,7 @@ static bool is_dynamic_bufmode(struct venus_inst *inst)
 
 	caps = venus_caps_by_codec(core, inst->hfi_codec, inst->session_type);
 	if (!caps)
-		return 0;
+		return false;
 
 	return caps->cap_bufs_mode_dynamic;
 }
-- 
2.7.4
