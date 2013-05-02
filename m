Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46142 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3EBFQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 01:16:23 -0400
Received: by mail-pa0-f52.google.com with SMTP id bg2so149046pad.25
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 22:16:22 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v2 1/2] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in hdmi_drv.c
Date: Thu,  2 May 2013 10:33:28 +0530
Message-Id: <1367471009-7103-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check on clocks obtained using common clock APIs should not
be done. Use IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Changes since v1:
Initialised clocks to invalid value.
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 4e86626..ed1a695 100644
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
@@ -793,8 +793,14 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 	dev_dbg(dev, "HDMI resource init\n");
 
 	memset(res, 0, sizeof(*res));
-	/* get clocks, power */
 
+	res->hdmi	 = ERR_PTR(-EINVAL);
+	res->sclk_hdmi	 = ERR_PTR(-EINVAL);
+	res->sclk_pixel	 = ERR_PTR(-EINVAL);
+	res->sclk_hdmiphy = ERR_PTR(-EINVAL);
+	res->hdmiphy	 = ERR_PTR(-EINVAL);
+
+	/* get clocks, power */
 	res->hdmi = clk_get(dev, "hdmi");
 	if (IS_ERR(res->hdmi)) {
 		dev_err(dev, "failed to get clock 'hdmi'\n");
-- 
1.7.9.5

