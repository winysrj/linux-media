Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45794 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2IVHmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 03:42:55 -0400
Received: by pbbrr4 with SMTP id rr4so4115481pbb.19
        for <linux-media@vger.kernel.org>; Sat, 22 Sep 2012 00:42:55 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	mchehab@infradead.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-tv: Fix potential NULL pointer dereference error
Date: Sat, 22 Sep 2012 13:09:19 +0530
Message-Id: <1348299559-20952-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When mdev is NULL, the error print statement will try to dereference
the NULL pointer.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index a15ca05..ca0f297 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -384,7 +384,7 @@ static int __devinit mxr_probe(struct platform_device *pdev)
 
 	mdev = kzalloc(sizeof *mdev, GFP_KERNEL);
 	if (!mdev) {
-		mxr_err(mdev, "not enough memory.\n");
+		dev_err(dev, "not enough memory.\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
-- 
1.7.4.1

