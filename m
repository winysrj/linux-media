Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2HQFKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 01:10:35 -0400
Received: by pbbrr13 with SMTP id rr13so2738820pbb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 22:10:35 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] smiapp: Remove unused function
Date: Fri, 17 Aug 2012 10:38:42 +0530
Message-Id: <1345180122-8922-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smiapp_replace_limit_at() function is not called by the driver.
This was detected by sparse as:
drivers/media/i2c/smiapp/smiapp-quirk.c:64:5: warning:
symbol 'smiapp_replace_limit_at' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/smiapp/smiapp-quirk.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index cf04812..725cf62 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -61,26 +61,6 @@ void smiapp_replace_limit(struct smiapp_sensor *sensor,
 	sensor->limits[limit] = val;
 }
 
-int smiapp_replace_limit_at(struct smiapp_sensor *sensor,
-			    u32 reg, u32 val)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	int i;
-
-	for (i = 0; smiapp_reg_limits[i].addr; i++) {
-		if ((smiapp_reg_limits[i].addr & 0xffff) != reg)
-			continue;
-
-		smiapp_replace_limit(sensor, i, val);
-
-		return 0;
-	}
-
-	dev_dbg(&client->dev, "quirk: bad register 0x%4.4x\n", reg);
-
-	return -EINVAL;
-}
-
 bool smiapp_quirk_reg(struct smiapp_sensor *sensor,
 		      u32 reg, u32 *val)
 {
-- 
1.7.4.1

