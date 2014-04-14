Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbaDNJBD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:01:03 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id C7F5C209A7
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:56 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 20/21] smiapp: Define macros for obtaining properties of register definitions
Date: Mon, 14 Apr 2014 11:58:45 +0300
Message-Id: <1397465926-29724-21-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The register address, width and flags are encoded as a 32-bit value. Add
macros for obtaining these separately. Use the macros in register access
functions.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-regs.c | 13 +++++++------
 drivers/media/i2c/smiapp/smiapp-regs.h |  4 ++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index c2db205..47b9e4c 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -165,7 +165,7 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 			 bool only8)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	unsigned int len = (u8)(reg >> 16);
+	u8 len = SMIAPP_REG_WIDTH(reg);
 	int rval;
 
 	if (len != SMIAPP_REG_8BIT && len != SMIAPP_REG_16BIT
@@ -173,9 +173,10 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 		return -EINVAL;
 
 	if (len == SMIAPP_REG_8BIT || !only8)
-		rval = ____smiapp_read(sensor, (u16)reg, len, val);
+		rval = ____smiapp_read(sensor, SMIAPP_REG_ADDR(reg), len, val);
 	else
-		rval = ____smiapp_read_8only(sensor, (u16)reg, len, val);
+		rval = ____smiapp_read_8only(sensor, SMIAPP_REG_ADDR(reg), len,
+					     val);
 	if (rval < 0)
 		return rval;
 
@@ -208,9 +209,9 @@ int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 	struct i2c_msg msg;
 	unsigned char data[6];
 	unsigned int retries;
-	unsigned int flags = reg >> 24;
-	unsigned int len = (u8)(reg >> 16);
-	u16 offset = reg;
+	u8 flags = SMIAPP_REG_FLAGS(reg);
+	u8 len = SMIAPP_REG_WIDTH(reg);
+	u16 offset = SMIAPP_REG_ADDR(reg);
 	int r;
 
 	if ((len != SMIAPP_REG_8BIT && len != SMIAPP_REG_16BIT &&
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.h b/drivers/media/i2c/smiapp/smiapp-regs.h
index 934130b..aeecab8 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.h
+++ b/drivers/media/i2c/smiapp/smiapp-regs.h
@@ -28,6 +28,10 @@
 #include <linux/i2c.h>
 #include <linux/types.h>
 
+#define SMIAPP_REG_ADDR(reg)		((u16)reg)
+#define SMIAPP_REG_WIDTH(reg)		((u8)(reg >> 16))
+#define SMIAPP_REG_FLAGS(reg)		((u8)(reg >> 24))
+
 /* Use upper 8 bits of the type field for flags */
 #define SMIAPP_REG_FLAG_FLOAT		(1 << 24)
 
-- 
1.8.3.2

