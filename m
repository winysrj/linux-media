Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57111 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3EQEoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 00:44:32 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq13so2932999pbb.5
        for <linux-media@vger.kernel.org>; Thu, 16 May 2013 21:44:32 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, sylvester.nawrocki@gmail.com,
	s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v4 1/2] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in hdmi_drv.c
Date: Fri, 17 May 2013 10:01:01 +0530
Message-Id: <1368765062-6194-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check on clocks obtained using common clock APIs should not
be done. Use IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Based on for-next branch of
git://linuxtv.org/snawrocki/samsung.git

Changes since v3:
Renamed the function and changed the prototype of {hdmi,mxr}_reset_clocks
as suggested by Sylwester.
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 4e86626..cd525f1 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -755,6 +755,15 @@ static const struct dev_pm_ops hdmi_pm_ops = {
 	.runtime_resume	 = hdmi_runtime_resume,
 };
 
+static void hdmi_resource_clear_clocks(struct hdmi_resources *res)
+{
+	res->hdmi	 = ERR_PTR(-EINVAL);
+	res->sclk_hdmi	 = ERR_PTR(-EINVAL);
+	res->sclk_pixel	 = ERR_PTR(-EINVAL);
+	res->sclk_hdmiphy = ERR_PTR(-EINVAL);
+	res->hdmiphy	 = ERR_PTR(-EINVAL);
+}
+
 static void hdmi_resources_cleanup(struct hdmi_device *hdev)
 {
 	struct hdmi_resources *res = &hdev->res;
@@ -765,17 +774,18 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
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
+	hdmi_resource_clear_clocks(res);
 }
 
 static int hdmi_resources_init(struct hdmi_device *hdev)
@@ -793,8 +803,9 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 	dev_dbg(dev, "HDMI resource init\n");
 
 	memset(res, 0, sizeof(*res));
-	/* get clocks, power */
+	hdmi_resource_clear_clocks(res);
 
+	/* get clocks, power */
 	res->hdmi = clk_get(dev, "hdmi");
 	if (IS_ERR(res->hdmi)) {
 		dev_err(dev, "failed to get clock 'hdmi'\n");
-- 
1.7.9.5

