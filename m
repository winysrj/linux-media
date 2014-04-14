Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbaDNJBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:01:00 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 269E4209E8
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:57 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 21/21] smiapp: Add register diversion quirk
Date: Mon, 14 Apr 2014 11:58:46 +0300
Message-Id: <1397465926-29724-22-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a quirk for diverting registers for on some sensors, even the standard
registers are not where they can be expected to be found. Add a quirk to
to help using such sensors.

smiapp_write_no_quirk() and smiapp_read_no_quirk() functions are provided
for the use of quirk implementations.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-quirk.h | 13 +++++++++
 drivers/media/i2c/smiapp/smiapp-regs.c  | 48 ++++++++++++++++++++++++++++-----
 drivers/media/i2c/smiapp/smiapp-regs.h  |  2 ++
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index b8b4087..ddc0548 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -35,6 +35,17 @@ struct smiapp_sensor;
  * @post_poweron: Called always after the sensor has been fully powered on.
  * @pre_streamon: Called just before streaming is enabled.
  * @post_streamon: Called right after stopping streaming.
+ * @reg_access: Register access quirk. The quirk may divert the access
+ *		to another register, or no register at all.
+ *
+ *		@write: Is this read (false) or write (true) access?
+ *		@reg: Pointer to the register to access
+ *		@value: Register value, set by the caller on write, or
+ *			by the quirk on read
+ *
+ *		@return: 0 on success, -ENOIOCTLCMD if no register
+ *			 access may be done by the caller (default read
+ *			 value is zero), else negative error code on error
  */
 struct smiapp_quirk {
 	int (*limits)(struct smiapp_sensor *sensor);
@@ -42,6 +53,8 @@ struct smiapp_quirk {
 	int (*pre_streamon)(struct smiapp_sensor *sensor);
 	int (*post_streamoff)(struct smiapp_sensor *sensor);
 	unsigned long (*pll_flags)(struct smiapp_sensor *sensor);
+	int (*reg_access)(struct smiapp_sensor *sensor, bool write, u32 *reg,
+			  u32 *val);
 	unsigned long flags;
 };
 
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index 47b9e4c..a209800 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -186,7 +186,7 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 	return 0;
 }
 
-int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+int smiapp_read_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 *val)
 {
 	return __smiapp_read(
 		sensor, reg, val,
@@ -194,16 +194,35 @@ int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
 				   SMIAPP_QUIRK_FLAG_8BIT_READ_ONLY));
 }
 
+int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+{
+	int rval;
+
+	*val = 0;
+	rval = smiapp_call_quirk(sensor, reg_access, false, &reg, val);
+	if (rval == -ENOIOCTLCMD)
+		return 0;
+	if (rval < 0)
+		return rval;
+
+	return smiapp_read_no_quirk(sensor, reg, val);
+}
+
 int smiapp_read_8only(struct smiapp_sensor *sensor, u32 reg, u32 *val)
 {
+	int rval;
+
+	*val = 0;
+	rval = smiapp_call_quirk(sensor, reg_access, false, &reg, val);
+	if (rval == -ENOIOCTLCMD)
+		return 0;
+	if (rval < 0)
+		return rval;
+
 	return __smiapp_read(sensor, reg, val, true);
 }
 
-/*
- * Write to a 8/16-bit register.
- * Returns zero if successful, or non-zero otherwise.
- */
-int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
+int smiapp_write_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct i2c_msg msg;
@@ -268,3 +287,20 @@ int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 
 	return r;
 }
+
+/*
+ * Write to a 8/16-bit register.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
+{
+	int rval;
+
+	rval = smiapp_call_quirk(sensor, reg_access, true, &reg, &val);
+	if (rval == -ENOIOCTLCMD)
+		return 0;
+	if (rval < 0)
+		return rval;
+
+	return smiapp_write_no_quirk(sensor, reg, val);
+}
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.h b/drivers/media/i2c/smiapp/smiapp-regs.h
index aeecab8..3552112 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.h
+++ b/drivers/media/i2c/smiapp/smiapp-regs.h
@@ -41,8 +41,10 @@
 
 struct smiapp_sensor;
 
+int smiapp_read_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 *val);
 int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val);
 int smiapp_read_8only(struct smiapp_sensor *sensor, u32 reg, u32 *val);
+int smiapp_write_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 val);
 int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val);
 
 #endif
-- 
1.8.3.2

