Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56203 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751967AbbESXFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 19:05:33 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, j.anaszewski@samsung.com,
	cooloney@gmail.com, g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
Subject: [PATCH 5/5] leds: max77693: Pass dev and dev->of_node to v4l2_flash_init()
Date: Wed, 20 May 2015 02:04:05 +0300
Message-Id: <1432076645-4799-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
References: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/leds/leds-max77693.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
index fecd0ed..bd12744 100644
--- a/drivers/leds/leds-max77693.c
+++ b/drivers/leds/leds-max77693.c
@@ -961,11 +961,9 @@ static int max77693_register_led(struct max77693_sub_led *sub_led,
 
 	max77693_init_v4l2_flash_config(sub_led, led_cfg, &v4l2_sd_cfg);
 
-	fled_cdev->led_cdev.dev->of_node = sub_node;
-
 	/* Register in the V4L2 subsystem. */
-	sub_led->v4l2_flash = v4l2_flash_init(fled_cdev, &v4l2_flash_ops,
-						&v4l2_sd_cfg);
+	sub_led->v4l2_flash = v4l2_flash_init(dev, sub_node, fled_cdev,
+					      &v4l2_flash_ops, &v4l2_sd_cfg);
 	if (IS_ERR(sub_led->v4l2_flash)) {
 		ret = PTR_ERR(sub_led->v4l2_flash);
 		goto err_v4l2_flash_init;
-- 
1.7.10.4

