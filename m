Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:64396 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3EQEog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 00:44:36 -0400
Received: by mail-da0-f41.google.com with SMTP id y19so2117607dan.14
        for <linux-media@vger.kernel.org>; Thu, 16 May 2013 21:44:35 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, sylvester.nawrocki@gmail.com,
	s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v4 2/2] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in mixer_drv.c
Date: Fri, 17 May 2013 10:01:02 +0530
Message-Id: <1368765062-6194-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1368765062-6194-1-git-send-email-sachin.kamat@linaro.org>
References: <1368765062-6194-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check on clocks obtained using common clock APIs should not
be done. Use IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_drv.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 5733033..7aeefdb 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -211,6 +211,15 @@ fail:
 	return ret;
 }
 
+static void mxr_resource_clear_clocks(struct mxr_resources *res)
+{
+	res->mixer	= ERR_PTR(-EINVAL);
+	res->vp		= ERR_PTR(-EINVAL);
+	res->sclk_mixer	= ERR_PTR(-EINVAL);
+	res->sclk_hdmi	= ERR_PTR(-EINVAL);
+	res->sclk_dac	= ERR_PTR(-EINVAL);
+}
+
 static void mxr_release_plat_resources(struct mxr_device *mdev)
 {
 	free_irq(mdev->res.irq, mdev);
@@ -222,15 +231,15 @@ static void mxr_release_clocks(struct mxr_device *mdev)
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
 
@@ -239,7 +248,9 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
 	struct mxr_resources *res = &mdev->res;
 	struct device *dev = mdev->dev;
 
-	res->mixer = clk_get(dev, "mixer");
+	mxr_resource_clear_clocks(res);
+
+	res->mixer	= clk_get(dev, "mixer");
 	if (IS_ERR(res->mixer)) {
 		mxr_err(mdev, "failed to get clock 'mixer'\n");
 		goto fail;
@@ -299,6 +310,7 @@ static void mxr_release_resources(struct mxr_device *mdev)
 	mxr_release_clocks(mdev);
 	mxr_release_plat_resources(mdev);
 	memset(&mdev->res, 0, sizeof(mdev->res));
+	mxr_resource_clear_clocks(&mdev->res);
 }
 
 static void mxr_release_layers(struct mxr_device *mdev)
-- 
1.7.9.5

