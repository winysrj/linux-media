Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:44988 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3D2Jhq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 05:37:46 -0400
Received: by mail-da0-f44.google.com with SMTP id z20so1422158dae.17
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 02:37:46 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/3] [media] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in hdmi_drv.c
Date: Mon, 29 Apr 2013 14:54:57 +0530
Message-Id: <1367227499-543-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check on clocks obtained using common clock APIs should not
be done. Use IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 4e86626..b3344cb 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -765,15 +765,15 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
 		regulator_bulk_free(res->regul_count, res->regul_bulk);
 	/* kfree is NULL-safe */
 	kfree(res->regul_bulk);
-	if (!IS_ERR_OR_NULL(res->hdmiphy))
+	if (!IS_ERR(res->hdmiphy))
 		clk_put(res->hdmiphy);
-	if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
+	if (!IS_ERR(res->sclk_hdmiphy))
 		clk_put(res->sclk_hdmiphy);
-	if (!IS_ERR_OR_NULL(res->sclk_pixel))
+	if (!IS_ERR(res->sclk_pixel))
 		clk_put(res->sclk_pixel);
-	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
+	if (!IS_ERR(res->sclk_hdmi))
 		clk_put(res->sclk_hdmi);
-	if (!IS_ERR_OR_NULL(res->hdmi))
+	if (!IS_ERR(res->hdmi))
 		clk_put(res->hdmi);
 	memset(res, 0, sizeof(*res));
 }
-- 
1.7.9.5

