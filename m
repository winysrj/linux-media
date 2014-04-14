Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10238 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaDNJA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:56 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id E6958203D6
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:52 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 02/21] smiapp: Rename SMIA_REG to SMIAPP_REG for consistency
Date: Mon, 14 Apr 2014 11:58:27 +0300
Message-Id: <1397465926-29724-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SMIAPP_REG_ is the common prefix used in the driver for register related
definitions. Use it consistently.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-quirk.c    |  2 +-
 drivers/media/i2c/smiapp/smiapp-reg-defs.h |  8 ++++----
 drivers/media/i2c/smiapp/smiapp-regs.c     | 24 ++++++++++++------------
 drivers/media/i2c/smiapp/smiapp-regs.h     |  8 ++++----
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index 4955289..06a0c21 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -28,7 +28,7 @@
 
 static int smiapp_write_8(struct smiapp_sensor *sensor, u16 reg, u8 val)
 {
-	return smiapp_write(sensor, (SMIA_REG_8BIT << 16) | reg, val);
+	return smiapp_write(sensor, SMIAPP_REG_MK_U8(reg), val);
 }
 
 static int smiapp_write_8s(struct smiapp_sensor *sensor,
diff --git a/drivers/media/i2c/smiapp/smiapp-reg-defs.h b/drivers/media/i2c/smiapp/smiapp-reg-defs.h
index 3aa0ca9..c488ef0 100644
--- a/drivers/media/i2c/smiapp/smiapp-reg-defs.h
+++ b/drivers/media/i2c/smiapp/smiapp-reg-defs.h
@@ -21,11 +21,11 @@
  * 02110-1301 USA
  *
  */
-#define SMIAPP_REG_MK_U8(r) ((SMIA_REG_8BIT << 16) | (r))
-#define SMIAPP_REG_MK_U16(r) ((SMIA_REG_16BIT << 16) | (r))
-#define SMIAPP_REG_MK_U32(r) ((SMIA_REG_32BIT << 16) | (r))
+#define SMIAPP_REG_MK_U8(r) ((SMIAPP_REG_8BIT << 16) | (r))
+#define SMIAPP_REG_MK_U16(r) ((SMIAPP_REG_16BIT << 16) | (r))
+#define SMIAPP_REG_MK_U32(r) ((SMIAPP_REG_32BIT << 16) | (r))
 
-#define SMIAPP_REG_MK_F32(r) (SMIA_REG_FLAG_FLOAT | (SMIA_REG_32BIT << 16) | (r))
+#define SMIAPP_REG_MK_F32(r) (SMIAPP_REG_FLAG_FLOAT | (SMIAPP_REG_32BIT << 16) | (r))
 
 #define SMIAPP_REG_U16_MODEL_ID					SMIAPP_REG_MK_U16(0x0000)
 #define SMIAPP_REG_U8_REVISION_NUMBER_MAJOR			SMIAPP_REG_MK_U8(0x0002)
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index e01644c..5d0151a 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -114,14 +114,14 @@ static int ____smiapp_read(struct smiapp_sensor *sensor, u16 reg,
 	*val = 0;
 	/* high byte comes first */
 	switch (len) {
-	case SMIA_REG_32BIT:
+	case SMIAPP_REG_32BIT:
 		*val = (data[0] << 24) + (data[1] << 16) + (data[2] << 8) +
 			data[3];
 		break;
-	case SMIA_REG_16BIT:
+	case SMIAPP_REG_16BIT:
 		*val = (data[0] << 8) + data[1];
 		break;
-	case SMIA_REG_8BIT:
+	case SMIAPP_REG_8BIT:
 		*val = data[0];
 		break;
 	default:
@@ -168,18 +168,18 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 	unsigned int len = (u8)(reg >> 16);
 	int rval;
 
-	if (len != SMIA_REG_8BIT && len != SMIA_REG_16BIT
-	    && len != SMIA_REG_32BIT)
+	if (len != SMIAPP_REG_8BIT && len != SMIAPP_REG_16BIT
+	    && len != SMIAPP_REG_32BIT)
 		return -EINVAL;
 
-	if (len == SMIA_REG_8BIT && !only8)
+	if (len == SMIAPP_REG_8BIT && !only8)
 		rval = ____smiapp_read(sensor, (u16)reg, len, val);
 	else
 		rval = ____smiapp_read_8only(sensor, (u16)reg, len, val);
 	if (rval < 0)
 		return rval;
 
-	if (reg & SMIA_REG_FLAG_FLOAT)
+	if (reg & SMIAPP_REG_FLAG_FLOAT)
 		*val = float_to_u32_mul_1000000(client, *val);
 
 	return 0;
@@ -213,8 +213,8 @@ int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 	u16 offset = reg;
 	int r;
 
-	if ((len != SMIA_REG_8BIT && len != SMIA_REG_16BIT &&
-	     len != SMIA_REG_32BIT) || flags)
+	if ((len != SMIAPP_REG_8BIT && len != SMIAPP_REG_16BIT &&
+	     len != SMIAPP_REG_32BIT) || flags)
 		return -EINVAL;
 
 	msg.addr = client->addr;
@@ -227,14 +227,14 @@ int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 	data[1] = (u8) (reg & 0xff);
 
 	switch (len) {
-	case SMIA_REG_8BIT:
+	case SMIAPP_REG_8BIT:
 		data[2] = val;
 		break;
-	case SMIA_REG_16BIT:
+	case SMIAPP_REG_16BIT:
 		data[2] = val >> 8;
 		data[3] = val;
 		break;
-	case SMIA_REG_32BIT:
+	case SMIAPP_REG_32BIT:
 		data[2] = val >> 24;
 		data[3] = val >> 16;
 		data[4] = val >> 8;
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.h b/drivers/media/i2c/smiapp/smiapp-regs.h
index e07b30c..934130b 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.h
+++ b/drivers/media/i2c/smiapp/smiapp-regs.h
@@ -29,11 +29,11 @@
 #include <linux/types.h>
 
 /* Use upper 8 bits of the type field for flags */
-#define SMIA_REG_FLAG_FLOAT		(1 << 24)
+#define SMIAPP_REG_FLAG_FLOAT		(1 << 24)
 
-#define SMIA_REG_8BIT			1
-#define SMIA_REG_16BIT			2
-#define SMIA_REG_32BIT			4
+#define SMIAPP_REG_8BIT			1
+#define SMIAPP_REG_16BIT		2
+#define SMIAPP_REG_32BIT		4
 
 struct smiapp_sensor;
 
-- 
1.8.3.2

