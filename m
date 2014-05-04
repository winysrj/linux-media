Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54431 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753460AbaEDA31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 May 2014 20:29:27 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id CE17260097
	for <linux-media@vger.kernel.org>; Sun,  4 May 2014 03:29:24 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] smiapp: Return correct return value in smiapp_registered()
Date: Sun,  4 May 2014 03:31:57 +0300
Message-Id: <1399163517-5220-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi>
References: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare for supporting systems using the Device tree. Should the resources
not be available at the time of driver probe(), the EPROBE_DEFER error code
must be also returned from its probe function.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e4037c8..3c7be76 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2358,14 +2358,14 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	sensor->vana = devm_regulator_get(&client->dev, "vana");
 	if (IS_ERR(sensor->vana)) {
 		dev_err(&client->dev, "could not get regulator for vana\n");
-		return -ENODEV;
+		return PTR_ERR(sensor->vana);
 	}
 
 	if (!sensor->platform_data->set_xclk) {
 		sensor->ext_clk = devm_clk_get(&client->dev, "ext_clk");
 		if (IS_ERR(sensor->ext_clk)) {
 			dev_err(&client->dev, "could not get clock\n");
-			return -ENODEV;
+			return PTR_ERR(sensor->ext_clk);
 		}
 
 		rval = clk_set_rate(sensor->ext_clk,
@@ -2374,18 +2374,19 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 			dev_err(&client->dev,
 				"unable to set clock freq to %u\n",
 				sensor->platform_data->ext_clk);
-			return -ENODEV;
+			return rval;
 		}
 	}
 
 	if (gpio_is_valid(sensor->platform_data->xshutdown)) {
-		if (devm_gpio_request_one(&client->dev,
-					  sensor->platform_data->xshutdown, 0,
-					  "SMIA++ xshutdown") != 0) {
+		rval = devm_gpio_request_one(
+			&client->dev, sensor->platform_data->xshutdown, 0,
+			"SMIA++ xshutdown");
+		if (rval < 0) {
 			dev_err(&client->dev,
 				"unable to acquire reset gpio %d\n",
 				sensor->platform_data->xshutdown);
-			return -ENODEV;
+			return rval;
 		}
 	}
 
-- 
1.7.10.4

