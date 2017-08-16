Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:27734 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbdHPHgE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 03:36:04 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 1/1] et8ek8: Decrease stack usage
Date: Wed, 16 Aug 2017 10:33:45 +0300
Message-Id: <1502868825-4531-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The et8ek8 driver combines I²C register writes to a single array that it
passes to i2c_transfer(). The maximum number of writes is 48 at once,
decrease it to 8 and make more transfers if needed, thus avoiding a
warning on stack usage.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Pavel: this is just compile tested. Could you test it on N900, please?

 drivers/media/i2c/et8ek8/et8ek8_driver.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index f39f517..c14f0fd 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -43,7 +43,7 @@
 
 #define ET8EK8_NAME		"et8ek8"
 #define ET8EK8_PRIV_MEM_SIZE	128
-#define ET8EK8_MAX_MSG		48
+#define ET8EK8_MAX_MSG		8
 
 struct et8ek8_sensor {
 	struct v4l2_subdev subdev;
@@ -220,7 +220,8 @@ static void et8ek8_i2c_create_msg(struct i2c_client *client, u16 len, u16 reg,
 
 /*
  * A buffered write method that puts the wanted register write
- * commands in a message list and passes the list to the i2c framework
+ * commands in smaller number of message lists and passes the lists to
+ * the i2c framework
  */
 static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
 					  const struct et8ek8_reg *wnext,
@@ -231,11 +232,7 @@ static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
 	int wcnt = 0;
 	u16 reg, data_length;
 	u32 val;
-
-	if (WARN_ONCE(cnt > ET8EK8_MAX_MSG,
-		      ET8EK8_NAME ": %s: too many messages.\n", __func__)) {
-		return -EINVAL;
-	}
+	int rval;
 
 	/* Create new write messages for all writes */
 	while (wcnt < cnt) {
@@ -249,10 +246,21 @@ static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
 
 		/* Update write count */
 		wcnt++;
+
+		if (wcnt < ET8EK8_MAX_MSG)
+			continue;
+
+		rval = i2c_transfer(client->adapter, msg, wcnt);
+		if (rval < 0)
+			return rval;
+
+		cnt -= wcnt;
+		wcnt = 0;
 	}
 
-	/* Now we send everything ... */
-	return i2c_transfer(client->adapter, msg, wcnt);
+	rval = i2c_transfer(client->adapter, msg, wcnt);
+
+	return rval < 0 ? rval : 0;
 }
 
 /*
-- 
2.7.4
