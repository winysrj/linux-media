Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35027 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3EBMFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 08:05:11 -0400
Received: by mail-pa0-f44.google.com with SMTP id jh10so323846pab.17
        for <linux-media@vger.kernel.org>; Thu, 02 May 2013 05:05:10 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v3 2/2] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in mixer_drv.c
Date: Thu,  2 May 2013 17:22:15 +0530
Message-Id: <1367495535-12888-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367495535-12888-1-git-send-email-sachin.kamat@linaro.org>
References: <1367495535-12888-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check on clocks obtained using common clock APIs should not
be done. Use IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_drv.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 5733033..bdee3bb 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -211,6 +211,17 @@ fail:
 	return ret;
 }
 
+static void mxr_reset_clocks(struct mxr_device *mdev)
+{
+	struct mxr_resources *res = &mdev->res;
+
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
@@ -222,15 +233,15 @@ static void mxr_release_clocks(struct mxr_device *mdev)
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
 
@@ -239,7 +250,9 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
 	struct mxr_resources *res = &mdev->res;
 	struct device *dev = mdev->dev;
 
-	res->mixer = clk_get(dev, "mixer");
+	mxr_reset_clocks(mdev);
+
+	res->mixer	= clk_get(dev, "mixer");
 	if (IS_ERR(res->mixer)) {
 		mxr_err(mdev, "failed to get clock 'mixer'\n");
 		goto fail;
@@ -299,6 +312,7 @@ static void mxr_release_resources(struct mxr_device *mdev)
 	mxr_release_clocks(mdev);
 	mxr_release_plat_resources(mdev);
 	memset(&mdev->res, 0, sizeof(mdev->res));
+	mxr_reset_clocks(mdev);
 }
 
 static void mxr_release_layers(struct mxr_device *mdev)
-- 
1.7.9.5

