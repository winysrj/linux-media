Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbaDNJBY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:01:24 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id E717C2096A
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:52 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 01/21] smiapp: Remove unused quirk register functionality
Date: Mon, 14 Apr 2014 11:58:26 +0300
Message-Id: <1397465926-29724-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The quirk registers mechanism which allows register to have a static read
access value from the sensor specific quirks, is not used. Remove it. It is
to be replaced by a more generic register diversion quirk soon.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-quirk.c | 46 ---------------------------------
 drivers/media/i2c/smiapp/smiapp-quirk.h | 10 -------
 drivers/media/i2c/smiapp/smiapp-regs.c  |  4 ---
 drivers/media/i2c/smiapp/smiapp-regs.h  |  5 ----
 4 files changed, 65 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index bb8c506..4955289 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -61,52 +61,6 @@ void smiapp_replace_limit(struct smiapp_sensor *sensor,
 	sensor->limits[limit] = val;
 }
 
-bool smiapp_quirk_reg(struct smiapp_sensor *sensor,
-		      u32 reg, u32 *val)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	const struct smia_reg *sreg;
-
-	if (!sensor->minfo.quirk)
-		return false;
-
-	sreg = sensor->minfo.quirk->regs;
-
-	if (!sreg)
-		return false;
-
-	while (sreg->type) {
-		u16 type = reg >> 16;
-		u16 reg16 = reg;
-
-		if (sreg->type != type || sreg->reg != reg16) {
-			sreg++;
-			continue;
-		}
-
-		switch ((u8)type) {
-		case SMIA_REG_8BIT:
-			dev_dbg(&client->dev, "quirk: 0x%8.8x: 0x%2.2x\n",
-				reg, sreg->val);
-			break;
-		case SMIA_REG_16BIT:
-			dev_dbg(&client->dev, "quirk: 0x%8.8x: 0x%4.4x\n",
-				reg, sreg->val);
-			break;
-		case SMIA_REG_32BIT:
-			dev_dbg(&client->dev, "quirk: 0x%8.8x: 0x%8.8x\n",
-				reg, sreg->val);
-			break;
-		}
-
-		*val = sreg->val;
-
-		return true;
-	}
-
-	return false;
-}
-
 static int jt8ew9_limits(struct smiapp_sensor *sensor)
 {
 	if (sensor->minfo.revision_number_major < 0x03)
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index 504a6d8..4f65c4e 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -41,7 +41,6 @@ struct smiapp_quirk {
 	int (*post_poweron)(struct smiapp_sensor *sensor);
 	int (*pre_streamon)(struct smiapp_sensor *sensor);
 	int (*post_streamoff)(struct smiapp_sensor *sensor);
-	const struct smia_reg *regs;
 	unsigned long flags;
 };
 
@@ -56,15 +55,6 @@ struct smiapp_reg_8 {
 
 void smiapp_replace_limit(struct smiapp_sensor *sensor,
 			  u32 limit, u32 val);
-bool smiapp_quirk_reg(struct smiapp_sensor *sensor,
-		      u32 reg, u32 *val);
-
-#define SMIAPP_MK_QUIRK_REG(_reg, _val) \
-	{				\
-		.type = (_reg >> 16),	\
-		.reg = (u16)_reg,	\
-		.val = _val,		\
-	}
 
 #define smiapp_call_quirk(_sensor, _quirk, ...)				\
 	(_sensor->minfo.quirk &&					\
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index 4fac32c..e01644c 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -172,9 +172,6 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 	    && len != SMIA_REG_32BIT)
 		return -EINVAL;
 
-	if (smiapp_quirk_reg(sensor, reg, val))
-		goto found_quirk;
-
 	if (len == SMIA_REG_8BIT && !only8)
 		rval = ____smiapp_read(sensor, (u16)reg, len, val);
 	else
@@ -182,7 +179,6 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 	if (rval < 0)
 		return rval;
 
-found_quirk:
 	if (reg & SMIA_REG_FLAG_FLOAT)
 		*val = float_to_u32_mul_1000000(client, *val);
 
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.h b/drivers/media/i2c/smiapp/smiapp-regs.h
index eefc6c8..e07b30c 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.h
+++ b/drivers/media/i2c/smiapp/smiapp-regs.h
@@ -34,11 +34,6 @@
 #define SMIA_REG_8BIT			1
 #define SMIA_REG_16BIT			2
 #define SMIA_REG_32BIT			4
-struct smia_reg {
-	u16 type;
-	u16 reg;			/* 16-bit offset */
-	u32 val;			/* 8/16/32-bit value */
-};
 
 struct smiapp_sensor;
 
-- 
1.8.3.2

