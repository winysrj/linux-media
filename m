Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64202 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3EBMFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 08:05:08 -0400
Received: by mail-pd0-f169.google.com with SMTP id 14so324559pdc.14
        for <linux-media@vger.kernel.org>; Thu, 02 May 2013 05:05:07 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v3 1/2] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in hdmi_drv.c
Date: Thu,  2 May 2013 17:22:14 +0530
Message-Id: <1367495535-12888-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check on clocks obtained using common clock APIs should not
be done. Use IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Changes since v2:
Moved clock reset code to a function.
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 4e86626..2f2d430 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -755,6 +755,17 @@ static const struct dev_pm_ops hdmi_pm_ops = {
 	.runtime_resume	 = hdmi_runtime_resume,
 };
 
+static void hdmi_reset_clocks(struct hdmi_device *hdev)
+{
+	struct hdmi_resources *res = &hdev->res;
+
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
@@ -765,17 +776,18 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
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
+	hdmi_reset_clocks(hdev);
 }
 
 static int hdmi_resources_init(struct hdmi_device *hdev)
@@ -793,8 +805,9 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 	dev_dbg(dev, "HDMI resource init\n");
 
 	memset(res, 0, sizeof(*res));
-	/* get clocks, power */
+	hdmi_reset_clocks(hdev);
 
+	/* get clocks, power */
 	res->hdmi = clk_get(dev, "hdmi");
 	if (IS_ERR(res->hdmi)) {
 		dev_err(dev, "failed to get clock 'hdmi'\n");
-- 
1.7.9.5

