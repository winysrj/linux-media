Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2KZEzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:49 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so4742413pad.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:48 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 5/9] [media] s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
Date: Mon, 26 Nov 2012 10:19:04 +0530
Message-Id: <1353905348-15475-6-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch warning:
WARNING: sizeof *ctx should be sizeof(*ctx)
FILE: media/platform/s5p-tv/hdmiphy_drv.c:287:
	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/hdmiphy_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index f67b386..94c2a13 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -284,7 +284,7 @@ static int __devinit hdmiphy_probe(struct i2c_client *client,
 {
 	struct hdmiphy_ctx *ctx;
 
-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-- 
1.7.4.1

