Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56196 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752305AbbESXFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 19:05:31 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, j.anaszewski@samsung.com,
	cooloney@gmail.com, g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
Subject: [PATCH 4/5] leds: aat1290: Pass dev and dev->of_node to v4l2_flash_init()
Date: Wed, 20 May 2015 02:04:04 +0300
Message-Id: <1432076645-4799-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
References: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/leds/leds-aat1290.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
index c656a2d..71bf6bb 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -524,9 +524,8 @@ static int aat1290_led_probe(struct platform_device *pdev)
 	led_cdev->dev->of_node = sub_node;
 
 	/* Create V4L2 Flash subdev. */
-	led->v4l2_flash = v4l2_flash_init(fled_cdev,
-					  &v4l2_flash_ops,
-					  &v4l2_sd_cfg);
+	led->v4l2_flash = v4l2_flash_init(dev, NULL, fled_cdev,
+					  &v4l2_flash_ops, &v4l2_sd_cfg);
 	if (IS_ERR(led->v4l2_flash)) {
 		ret = PTR_ERR(led->v4l2_flash);
 		goto error_v4l2_flash_init;
-- 
1.7.10.4

