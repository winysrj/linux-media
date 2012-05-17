Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:24154 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760587Ab2EQQaZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:25 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-da01.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGULVP011059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:23 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id F404C1F4C5A
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:20 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3ah-00086W-4e
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:15 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/10] smiapp: Quirk for sensors that only do 8-bit reads
Date: Thu, 17 May 2012 19:30:02 +0300
Message-Id: <1337272209-31061-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors implement only 8-bit read functionality and fail on wider
reads. Add a quirk flag for such sensors.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp/smiapp-quirk.h |    1 +
 drivers/media/video/smiapp/smiapp-regs.c  |   73 +++++++++++++++++++++++++----
 drivers/media/video/smiapp/smiapp-regs.h  |    1 +
 3 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/smiapp/smiapp-quirk.h b/drivers/media/video/smiapp/smiapp-quirk.h
index 7a1b3a0..de82cdf 100644
--- a/drivers/media/video/smiapp/smiapp-quirk.h
+++ b/drivers/media/video/smiapp/smiapp-quirk.h
@@ -46,6 +46,7 @@ struct smiapp_quirk {
 
 /* op pix clock is for all lanes in total normally */
 #define SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE			(1 << 0)
+#define SMIAPP_QUIRK_FLAG_8BIT_READ_ONLY			(1 << 1)
 
 struct smiapp_reg_8 {
 	u16 reg;
diff --git a/drivers/media/video/smiapp/smiapp-regs.c b/drivers/media/video/smiapp/smiapp-regs.c
index e5e5f43..9c43064 100644
--- a/drivers/media/video/smiapp/smiapp-regs.c
+++ b/drivers/media/video/smiapp/smiapp-regs.c
@@ -78,19 +78,15 @@ static uint32_t float_to_u32_mul_1000000(struct i2c_client *client,
  * Read a 8/16/32-bit i2c register.  The value is returned in 'val'.
  * Returns zero if successful, or non-zero otherwise.
  */
-int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+static int ____smiapp_read(struct smiapp_sensor *sensor, u16 reg,
+			   u16 len, u32 *val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct i2c_msg msg;
 	unsigned char data[4];
-	unsigned int len = (u8)(reg >> 16);
 	u16 offset = reg;
 	int r;
 
-	if (len != SMIA_REG_8BIT && len != SMIA_REG_16BIT
-	    && len != SMIA_REG_32BIT)
-		return -EINVAL;
-
 	msg.addr = client->addr;
 	msg.flags = 0;
 	msg.len = 2;
@@ -132,9 +128,6 @@ int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
 		BUG();
 	}
 
-	if (reg & SMIA_REG_FLAG_FLOAT)
-		*val = float_to_u32_mul_1000000(client, *val);
-
 	return 0;
 
 err:
@@ -143,6 +136,68 @@ err:
 	return r;
 }
 
+/* Read a register using 8-bit access only. */
+static int ____smiapp_read_8only(struct smiapp_sensor *sensor, u16 reg,
+				 u16 len, u32 *val)
+{
+	unsigned int i;
+	int rval;
+
+	*val = 0;
+
+	for (i = 0; i < len; i++) {
+		u32 val8;
+
+		rval = ____smiapp_read(sensor, reg + i, 1, &val8);
+		if (rval < 0)
+			return rval;
+		*val |= val8 << ((len - i - 1) << 3);
+	}
+
+	return 0;
+}
+
+/*
+ * Read a 8/16/32-bit i2c register.  The value is returned in 'val'.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
+			 bool only8)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	unsigned int len = (u8)(reg >> 16);
+	int rval;
+
+	if (len != SMIA_REG_8BIT && len != SMIA_REG_16BIT
+	    && len != SMIA_REG_32BIT)
+		return -EINVAL;
+
+	if (len == SMIA_REG_8BIT && !only8)
+		rval = ____smiapp_read(sensor, (u16)reg, len, val);
+	else
+		rval = ____smiapp_read_8only(sensor, (u16)reg, len, val);
+	if (rval < 0)
+		return rval;
+
+	if (reg & SMIA_REG_FLAG_FLOAT)
+		*val = float_to_u32_mul_1000000(client, *val);
+
+	return 0;
+}
+
+int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+{
+	return __smiapp_read(
+		sensor, reg, val,
+		smiapp_needs_quirk(sensor,
+				   SMIAPP_QUIRK_FLAG_8BIT_READ_ONLY));
+}
+
+int smiapp_read_8only(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+{
+	return __smiapp_read(sensor, reg, val, true);
+}
+
 /*
  * Write to a 8/16-bit register.
  * Returns zero if successful, or non-zero otherwise.
diff --git a/drivers/media/video/smiapp/smiapp-regs.h b/drivers/media/video/smiapp/smiapp-regs.h
index 1edfd20..7f9013b 100644
--- a/drivers/media/video/smiapp/smiapp-regs.h
+++ b/drivers/media/video/smiapp/smiapp-regs.h
@@ -43,6 +43,7 @@ struct smia_reg {
 struct smiapp_sensor;
 
 int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val);
+int smiapp_read_8only(struct smiapp_sensor *sensor, u32 reg, u32 *val);
 int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val);
 
 #endif
-- 
1.7.2.5

