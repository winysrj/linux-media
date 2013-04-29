Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46827 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3D2Jht (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 05:37:49 -0400
Received: by mail-pb0-f42.google.com with SMTP id up15so414195pbc.1
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 02:37:49 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/3] [media] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in mixer_drv.c
Date: Mon, 29 Apr 2013 14:54:58 +0530
Message-Id: <1367227499-543-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367227499-543-1-git-send-email-sachin.kamat@linaro.org>
References: <1367227499-543-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check on clocks obtained using common clock APIs should not
be done. Use IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_drv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 5733033..8dd8b88 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -222,15 +222,15 @@ static void mxr_release_clocks(struct mxr_device *mdev)
 {
 	struct mxr_resources *res = &mdev->res;
 
-	if (!IS_ERR_OR_NULL(res->sclk_dac))
+	if (!IS_ERR(res->sclk_dac))
 		clk_put(res->sclk_dac);
-	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
+	if (!IS_ERR(res->sclk_hdmi))
 		clk_put(res->sclk_hdmi);
-	if (!IS_ERR_OR_NULL(res->sclk_mixer))
+	if (!IS_ERR(res->sclk_mixer))
 		clk_put(res->sclk_mixer);
-	if (!IS_ERR_OR_NULL(res->vp))
+	if (!IS_ERR(res->vp))
 		clk_put(res->vp);
-	if (!IS_ERR_OR_NULL(res->mixer))
+	if (!IS_ERR(res->mixer))
 		clk_put(res->mixer);
 }
 
-- 
1.7.9.5

