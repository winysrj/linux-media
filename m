Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934337AbaDITZB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:25:01 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id B455C20EB6
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:55 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 17/17] smiapp: Add register diversion quirk
Date: Wed,  9 Apr 2014 22:25:09 +0300
Message-Id: <1397071509-2071-18-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a quirk for diverting registers for on some sensors, even the standard
registers are not where they can be expected to be found. Add a quirk to
to help using such sensors.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-quirk.c |  8 ++++++++
 drivers/media/i2c/smiapp/smiapp-quirk.h |  4 ++++
 drivers/media/i2c/smiapp/smiapp-regs.c  | 14 +++++++++++---
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index 580132d..9d86217 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -107,6 +107,14 @@ bool smiapp_quirk_reg(struct smiapp_sensor *sensor,
 	return false;
 }
 
+u32 smiapp_quirk_reg_divert(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+{
+	if (sensor->minfo.quirk && sensor->minfo.quirk->reg_divert)
+		return sensor->minfo.quirk->reg_divert(sensor, reg, val);
+	else
+		return reg;
+}
+
 static int jt8ew9_limits(struct smiapp_sensor *sensor)
 {
 	if (sensor->minfo.revision_number_major < 0x03)
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index 15ef0af6..295931c 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -35,6 +35,8 @@ struct smiapp_sensor;
  * @post_poweron: Called always after the sensor has been fully powered on.
  * @pre_streamon: Called just before streaming is enabled.
  * @post_streamon: Called right after stopping streaming.
+ * @reg_divert: reg is diverted to point to the location of the actual
+ *		register. For sensors that loosely conform to SMIA.
  */
 struct smiapp_quirk {
 	int (*limits)(struct smiapp_sensor *sensor);
@@ -42,6 +44,7 @@ struct smiapp_quirk {
 	int (*pre_streamon)(struct smiapp_sensor *sensor);
 	int (*post_streamoff)(struct smiapp_sensor *sensor);
 	unsigned long (*pll_flags)(struct smiapp_sensor *sensor);
+	u32 (*reg_divert)(struct smiapp_sensor *sensor, u32 reg, u32 *val);
 	const struct smia_reg *regs;
 	unsigned long flags;
 };
@@ -57,6 +60,7 @@ void smiapp_replace_limit(struct smiapp_sensor *sensor,
 			  u32 limit, u64 val);
 bool smiapp_quirk_reg(struct smiapp_sensor *sensor,
 		      u32 reg, u32 *val);
+u32 smiapp_quirk_reg_divert(struct smiapp_sensor *sensor, u32 reg, u32 *val);
 
 #define SMIAPP_MK_QUIRK_REG(_reg, _val) \
 	{				\
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index e88a59a..57ebd51 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -165,7 +165,7 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 			 bool only8)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	unsigned int len = (u8)(reg >> 16);
+	u8 len = reg >> 16;
 	int rval;
 
 	if (len != SMIA_REG_8BIT && len != SMIA_REG_16BIT
@@ -175,6 +175,9 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 	if (smiapp_quirk_reg(sensor, reg, val))
 		goto found_quirk;
 
+	reg = smiapp_quirk_reg_divert(sensor, reg, val);
+	len = reg >> 16;
+
 	if (len == SMIA_REG_8BIT && !only8)
 		rval = ____smiapp_read(sensor, (u16)reg, len, val);
 	else
@@ -213,8 +216,8 @@ int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 	unsigned char data[6];
 	unsigned int retries;
 	unsigned int flags = reg >> 24;
-	unsigned int len = (u8)(reg >> 16);
-	u16 offset = reg;
+	u8 len = reg >> 16;
+	u16 offset;
 	int r;
 
 	if ((len != SMIA_REG_8BIT && len != SMIA_REG_16BIT &&
@@ -228,6 +231,11 @@ int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 		return 0;
 	}
 
+	reg = smiapp_quirk_reg_divert(sensor, reg, &val);
+	offset = reg;
+	flags = reg >> 24;
+	len = reg >> 16;
+
 	msg.addr = client->addr;
 	msg.flags = 0; /* Write */
 	msg.len = 2 + len;
-- 
1.8.3.2

