Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55162 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab2EIM4C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 08:56:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/3] mt9p031: Implement V4L2_CID_PIXEL_RATE control
Date: Wed,  9 May 2012 14:55:58 +0200
Message-Id: <1336568159-23378-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1336568159-23378-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1336568159-23378-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pixel rate control is required by the OMAP3 ISP driver and should be
implemented by all media controller-compatible sensor drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index d0b8e36..e790100 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -968,7 +968,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->vdd_core = devm_regulator_get(&client->dev, "cam_core");
 	mt9p031->vdd_io = devm_regulator_get(&client->dev, "cam_io");
 
-	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 4);
+	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 5);
 
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
 			  V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
@@ -981,6 +981,9 @@ static int mt9p031_probe(struct i2c_client *client,
 			  V4L2_CID_HFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
+			  V4L2_CID_PIXEL_RATE, pdata->target_freq,
+			  pdata->target_freq, 1, pdata->target_freq);
 
 	for (i = 0; i < ARRAY_SIZE(mt9p031_ctrls); ++i)
 		v4l2_ctrl_new_custom(&mt9p031->ctrls, &mt9p031_ctrls[i], NULL);
-- 
1.7.3.4

