Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48165 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbdFVR13 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 13:27:29 -0400
From: Colin King <colin.king@canonical.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media-next] media: venus: fix loop wrap in cleanup of clks
Date: Thu, 22 Jun 2017 18:27:21 +0100
Message-Id: <20170622172721.25844-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The current pre-decrement is incorrect and should be replaced
with a post-decrement. Consider the case where the very first
clk_prepare_enable fails when i is 0; in this case the error
clean up will decrement the unsigned int which wraps to the
largest unsigned int value causing an array out of bounds read
on core->clks[i].

Detected by CoverityScan, CID#1446590 ("Out-of-bounds read")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/qcom/venus/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 776d2bae6979..d8cbe8549d97 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -137,7 +137,7 @@ static int venus_clks_enable(struct venus_core *core)
 
 	return 0;
 err:
-	while (--i)
+	while (i--)
 		clk_disable_unprepare(core->clks[i]);
 
 	return ret;
-- 
2.11.0
