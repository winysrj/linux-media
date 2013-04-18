Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55164 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936494Ab3DRVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 18/24] V4L2: mt9p031: power down the sensor if no supported device has been detected
Date: Thu, 18 Apr 2013 23:35:39 +0200
Message-Id: <1366320945-21591-19-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mt9p031 driver first accesses the I2C device in its .registered()
method. While doing that it furst powers the device up, but if probing
fails, it doesn't power the chip back down. This patch fixes that bug.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/mt9p031.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index eb2de22..70f4525 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -844,7 +844,7 @@ static int mt9p031_registered(struct v4l2_subdev *subdev)
 	ret = mt9p031_power_on(mt9p031);
 	if (ret < 0) {
 		dev_err(&client->dev, "MT9P031 power up failed\n");
-		return ret;
+		goto done;
 	}
 
 	/* Read out the chip version register */
@@ -852,13 +852,15 @@ static int mt9p031_registered(struct v4l2_subdev *subdev)
 	if (data != MT9P031_CHIP_VERSION_VALUE) {
 		dev_err(&client->dev, "MT9P031 not detected, wrong version "
 			"0x%04x\n", data);
-		return -ENODEV;
+		ret = -ENODEV;
 	}
 
+done:
 	mt9p031_power_off(mt9p031);
 
-	dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
-		 client->addr);
+	if (!ret)
+		dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
+			 client->addr);
 
 	return ret;
 }
-- 
1.7.2.5

