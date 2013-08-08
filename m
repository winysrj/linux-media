Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:62838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934265Ab3HHO4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 10:56:16 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 5/6] V4L2: mt9t031: don't Oops if asynchronous probing is attempted
Date: Thu,  8 Aug 2013 16:52:36 +0200
Message-Id: <1375973557-23333-6-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1375973557-23333-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375973557-23333-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mt9t031 driver hasn't yet been updated to support asynchronous
subdevice probing. If such a probing is attempted, the driver is allowed
to fail, but it shouldn't Oops. This patch fixes such a potential NULL
pointer dereference.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/mt9t031.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 47d18d0..ee7bb0f 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -594,9 +594,12 @@ static int mt9t031_s_power(struct v4l2_subdev *sd, int on)
 		ret = soc_camera_power_on(&client->dev, ssdd, mt9t031->clk);
 		if (ret < 0)
 			return ret;
-		vdev->dev.type = &mt9t031_dev_type;
+		if (vdev)
+			/* Not needed during probing, when vdev isn't available yet */
+			vdev->dev.type = &mt9t031_dev_type;
 	} else {
-		vdev->dev.type = NULL;
+		if (vdev)
+			vdev->dev.type = NULL;
 		soc_camera_power_off(&client->dev, ssdd, mt9t031->clk);
 	}
 
-- 
1.7.2.5

