Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37044 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3EBFQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 01:16:26 -0400
Received: by mail-pd0-f171.google.com with SMTP id r11so149097pdi.30
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 22:16:25 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v2 2/2] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in mixer_drv.c
Date: Thu,  2 May 2013 10:33:29 +0530
Message-Id: <1367471009-7103-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367471009-7103-1-git-send-email-sachin.kamat@linaro.org>
References: <1367471009-7103-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check on clocks obtained using common clock APIs should not
be done. Use IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Changes since v1:
Initialised clocks to invalid value.
---
 drivers/media/platform/s5p-tv/mixer_drv.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 5733033..506a5aa 100644
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
 
@@ -239,7 +239,14 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
 	struct mxr_resources *res = &mdev->res;
 	struct device *dev = mdev->dev;
 
-	res->mixer = clk_get(dev, "mixer");
+
+	res->mixer	= ERR_PTR(-EINVAL);
+	res->vp		= ERR_PTR(-EINVAL);
+	res->sclk_mixer	= ERR_PTR(-EINVAL);
+	res->sclk_hdmi	= ERR_PTR(-EINVAL);
+	res->sclk_dac	= ERR_PTR(-EINVAL);
+
+	res->mixer	= clk_get(dev, "mixer");
 	if (IS_ERR(res->mixer)) {
 		mxr_err(mdev, "failed to get clock 'mixer'\n");
 		goto fail;
-- 
1.7.9.5

