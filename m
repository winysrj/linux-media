Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40808 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932782AbaLJVQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 16:16:38 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 6ED1060097
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 23:16:34 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 1/7] smiapp: Access flash capabilities through limits
Date: Wed, 10 Dec 2014 23:16:14 +0200
Message-Id: <1418246180-667-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
References: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The flash capability register is already read as part of the limit
registers. Do no access it separately; instead use the value from the
limits.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    9 +--------
 drivers/media/i2c/smiapp/smiapp.h      |    1 -
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 48e1a1f..4f36be5 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1483,7 +1483,7 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 	if (rval < 0)
 		goto out;
 
-	if ((sensor->flash_capability &
+	if ((sensor->limits[SMIAPP_LIMIT_FLASH_MODE_CAPABILITY] &
 	     (SMIAPP_FLASH_MODE_CAPABILITY_SINGLE_STROBE |
 	      SMIAPP_FLASH_MODE_CAPABILITY_MULTIPLE_STROBE)) &&
 	    sensor->platform_data->strobe_setup != NULL &&
@@ -2529,7 +2529,6 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct smiapp_pll *pll = &sensor->pll;
 	struct smiapp_subdev *last = NULL;
-	u32 tmp;
 	unsigned int i;
 	int rval;
 
@@ -2785,12 +2784,6 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	sensor->streaming = false;
 	sensor->dev_init_done = true;
 
-	/* check flash capability */
-	rval = smiapp_read(sensor, SMIAPP_REG_U8_FLASH_MODE_CAPABILITY, &tmp);
-	sensor->flash_capability = tmp;
-	if (rval)
-		goto out_cleanup;
-
 	smiapp_power_off(sensor);
 
 	return 0;
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index 8fded46..ed010a8 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -216,7 +216,6 @@ struct smiapp_sensor {
 	u8 scaling_mode;
 
 	u8 hvflip_inv_mask; /* H/VFLIP inversion due to sensor orientation */
-	u8 flash_capability;
 	u8 frame_skip;
 
 	int power_count;
-- 
1.7.10.4

