Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab2KZEzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:46 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so4742413pad.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:45 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 4/9] [media] s5p-tv: Add missing braces around sizeof in mixer_drv.c
Date: Mon, 26 Nov 2012 10:19:03 +0530
Message-Id: <1353905348-15475-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences checkpatch warnings of type:
WARNING: sizeof mdev->res should be sizeof(mdev->res)
FILE: media/platform/s5p-tv/mixer_drv.c:301:
	memset(&mdev->res, 0, sizeof mdev->res);

WARNING: sizeof *mdev should be sizeof(*mdev)
FILE: media/platform/s5p-tv/mixer_drv.c:385:
	mdev = kzalloc(sizeof *mdev, GFP_KERNEL);

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index ca0f297..a6dee4d 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -298,7 +298,7 @@ static void mxr_release_resources(struct mxr_device *mdev)
 {
 	mxr_release_clocks(mdev);
 	mxr_release_plat_resources(mdev);
-	memset(&mdev->res, 0, sizeof mdev->res);
+	memset(&mdev->res, 0, sizeof(mdev->res));
 }
 
 static void mxr_release_layers(struct mxr_device *mdev)
@@ -382,7 +382,7 @@ static int __devinit mxr_probe(struct platform_device *pdev)
 	/* mdev does not exist yet so no mxr_dbg is used */
 	dev_info(dev, "probe start\n");
 
-	mdev = kzalloc(sizeof *mdev, GFP_KERNEL);
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev) {
 		dev_err(dev, "not enough memory.\n");
 		ret = -ENOMEM;
-- 
1.7.4.1

