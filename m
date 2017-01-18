Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45673 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdARXcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 18:32:06 -0500
Received: from avalon.bb.dnainternet.fi (dfj-tpyj40kccf8214dxy-3.rev.dnainternet.fi [IPv6:2001:14ba:21ff:600:f8f2:422:72d5:c0e6])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 0DD8420097
        for <linux-media@vger.kernel.org>; Thu, 19 Jan 2017 00:31:31 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: mt9v032: Remove unneeded gpiod NULL check
Date: Thu, 19 Jan 2017 01:32:20 +0200
Message-Id: <20170118233220.20879-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The gpiod API checks for NULL descriptors, there's no need to duplicate
the check in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 58eb62f1ba21..107eb3baa11f 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -266,8 +266,7 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
 	struct regmap *map = mt9v032->regmap;
 	int ret;
 
-	if (mt9v032->reset_gpio)
-		gpiod_set_value_cansleep(mt9v032->reset_gpio, 1);
+	gpiod_set_value_cansleep(mt9v032->reset_gpio, 1);
 
 	ret = clk_set_rate(mt9v032->clk, mt9v032->sysclk);
 	if (ret < 0)
-- 
Regards,

Laurent Pinchart

