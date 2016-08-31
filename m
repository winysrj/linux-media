Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:11915 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755315AbcHaHnf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 03:43:35 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 1/5] smiapp: Unify enforced and need-based 8-bit read
Date: Wed, 31 Aug 2016 10:42:01 +0300
Message-Id: <1472629325-30875-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Unify enforced 8-bit read access with that based on actual need.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-regs.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index 6b6c20b..1e501c0 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -188,7 +188,8 @@ int smiapp_read_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 *val)
 				   SMIAPP_QUIRK_FLAG_8BIT_READ_ONLY));
 }
 
-int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+static int smiapp_read_quirk(struct smiapp_sensor *sensor, u32 reg, u32 *val,
+			     bool force8)
 {
 	int rval;
 
@@ -199,21 +200,20 @@ int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
 	if (rval < 0)
 		return rval;
 
+	if (force8)
+		return __smiapp_read(sensor, reg, val, true);
+
 	return smiapp_read_no_quirk(sensor, reg, val);
 }
 
-int smiapp_read_8only(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
 {
-	int rval;
-
-	*val = 0;
-	rval = smiapp_call_quirk(sensor, reg_access, false, &reg, val);
-	if (rval == -ENOIOCTLCMD)
-		return 0;
-	if (rval < 0)
-		return rval;
+	return smiapp_read_quirk(sensor, reg, val, false);
+}
 
-	return __smiapp_read(sensor, reg, val, true);
+int smiapp_read_8only(struct smiapp_sensor *sensor, u32 reg, u32 *val)
+{
+	return smiapp_read_quirk(sensor, reg, val, true);
 }
 
 int smiapp_write_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 val)
-- 
2.7.4

