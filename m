Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936303Ab3DRVf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 03/24] mt9t031: fix NULL dereference during probe()
Date: Thu, 18 Apr 2013 23:35:24 +0200
Message-Id: <1366320945-21591-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When .s_power() is called during probing, the video device isn't available
yet. Fix Oops, caused by dereferencing it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/mt9t031.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index ea791e3..e7f0a08 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -619,9 +619,12 @@ static int mt9t031_s_power(struct v4l2_subdev *sd, int on)
 		ret = soc_camera_power_on(&client->dev, ssdd, mt9t031->clk);
 		if (ret < 0)
 			return ret;
-		vdev->dev.type = &mt9t031_dev_type;
+		if (vdev)
+			/* Skip during probing, when vdev isn't available yet */
+			vdev->dev.type = &mt9t031_dev_type;
 	} else {
-		vdev->dev.type = NULL;
+		if (vdev)
+			vdev->dev.type = NULL;
 		soc_camera_power_off(&client->dev, ssdd, mt9t031->clk);
 	}
 
-- 
1.7.2.5

