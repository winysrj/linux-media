Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:45670 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbdGEIpK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 04:45:10 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hansverk@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 1/3] [media] ov5645: Set media entity function
Date: Wed,  5 Jul 2017 11:44:47 +0300
Message-Id: <1499244289-7791-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set media entity function to MEDIA_ENT_F_CAM_SENSOR.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/i2c/ov5645.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index d1e844f..bb3dd0d 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -1229,6 +1229,7 @@ static int ov5645_probe(struct i2c_client *client,
 	ov5645->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	ov5645->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ov5645->sd.dev = &client->dev;
+	ov5645->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 
 	ret = media_entity_pads_init(&ov5645->sd.entity, 1, &ov5645->pad);
 	if (ret < 0) {
-- 
1.9.1
