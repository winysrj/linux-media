Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2KZEzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:37 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7718128pbc.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:36 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/9] [media] s5p-tv: Add missing braces around sizeof in sdo_drv.c
Date: Mon, 26 Nov 2012 10:19:00 +0530
Message-Id: <1353905348-15475-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following checkpatch warnings:
WARNING: sizeof *sdev should be sizeof(*sdev)
FILE: media/platform/s5p-tv/sdo_drv.c:304:
	sdev = devm_kzalloc(&pdev->dev, sizeof *sdev, GFP_KERNEL);
WARNING: sizeof sdev->sd.name should be sizeof(sdev->sd.name)
FILE: media/platform/s5p-tv/sdo_drv.c:394:
	strlcpy(sdev->sd.name, "s5p-sdo", sizeof sdev->sd.name);

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/sdo_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ad68bbe..91e2de3 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -301,7 +301,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	struct clk *sclk_vpll;
 
 	dev_info(dev, "probe start\n");
-	sdev = devm_kzalloc(&pdev->dev, sizeof *sdev, GFP_KERNEL);
+	sdev = devm_kzalloc(&pdev->dev, sizeof(*sdev), GFP_KERNEL);
 	if (!sdev) {
 		dev_err(dev, "not enough memory.\n");
 		ret = -ENOMEM;
@@ -394,7 +394,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	/* configuration of interface subdevice */
 	v4l2_subdev_init(&sdev->sd, &sdo_sd_ops);
 	sdev->sd.owner = THIS_MODULE;
-	strlcpy(sdev->sd.name, "s5p-sdo", sizeof sdev->sd.name);
+	strlcpy(sdev->sd.name, "s5p-sdo", sizeof(sdev->sd.name));
 
 	/* set default format */
 	sdev->fmt = sdo_find_format(SDO_DEFAULT_STD);
-- 
1.7.4.1

