Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:25255 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2F2Kr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 06:47:28 -0400
Date: Fri, 29 Jun 2012 12:47:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <linux-i2c@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] i2c: Export an unlocked flavor of i2c_transfer
Message-ID: <20120629124719.2cf23f6b@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some drivers (in particular for TV cards) need exclusive access to
their I2C buses for specific operations. Export an unlocked flavor
of i2c_transfer to give them full control.

The unlocked flavor has the following limitations:
* Obviously, caller must hold the i2c adapter lock.
* No debug messages are logged. We don't want to log messages while
  holding a rt_mutex.
* No check is done on the existence of adap->algo->master_xfer. It
  is thus the caller's responsibility to ensure that the function is
  OK to call.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
Mauro, would this be OK with you?

 drivers/i2c/i2c-core.c |   44 +++++++++++++++++++++++++++++++++-----------
 include/linux/i2c.h    |    3 +++
 2 files changed, 36 insertions(+), 11 deletions(-)

--- linux-3.5-rc4.orig/drivers/i2c/i2c-core.c	2012-06-05 16:22:59.000000000 +0200
+++ linux-3.5-rc4/drivers/i2c/i2c-core.c	2012-06-29 12:41:04.707793937 +0200
@@ -1312,6 +1312,37 @@ module_exit(i2c_exit);
  */
 
 /**
+ * __i2c_transfer - unlocked flavor of i2c_transfer
+ * @adap: Handle to I2C bus
+ * @msgs: One or more messages to execute before STOP is issued to
+ *	terminate the operation; each message begins with a START.
+ * @num: Number of messages to be executed.
+ *
+ * Returns negative errno, else the number of messages executed.
+ *
+ * Adapter lock must be held when calling this function. No debug logging
+ * takes place. adap->algo->master_xfer existence isn't checked.
+ */
+int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+{
+	unsigned long orig_jiffies;
+	int ret, try;
+
+	/* Retry automatically on arbitration loss */
+	orig_jiffies = jiffies;
+	for (ret = 0, try = 0; try <= adap->retries; try++) {
+		ret = adap->algo->master_xfer(adap, msgs, num);
+		if (ret != -EAGAIN)
+			break;
+		if (time_after(jiffies, orig_jiffies + adap->timeout))
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(__i2c_transfer);
+
+/**
  * i2c_transfer - execute a single or combined I2C message
  * @adap: Handle to I2C bus
  * @msgs: One or more messages to execute before STOP is issued to
@@ -1325,8 +1356,7 @@ module_exit(i2c_exit);
  */
 int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
-	unsigned long orig_jiffies;
-	int ret, try;
+	int ret;
 
 	/* REVISIT the fault reporting model here is weak:
 	 *
@@ -1364,15 +1394,7 @@ int i2c_transfer(struct i2c_adapter *ada
 			i2c_lock_adapter(adap);
 		}
 
-		/* Retry automatically on arbitration loss */
-		orig_jiffies = jiffies;
-		for (ret = 0, try = 0; try <= adap->retries; try++) {
-			ret = adap->algo->master_xfer(adap, msgs, num);
-			if (ret != -EAGAIN)
-				break;
-			if (time_after(jiffies, orig_jiffies + adap->timeout))
-				break;
-		}
+		ret = __i2c_transfer(adap, msgs, num);
 		i2c_unlock_adapter(adap);
 
 		return ret;
--- linux-3.5-rc4.orig/include/linux/i2c.h	2012-06-05 16:23:05.000000000 +0200
+++ linux-3.5-rc4/include/linux/i2c.h	2012-06-29 10:29:47.865621249 +0200
@@ -68,6 +68,9 @@ extern int i2c_master_recv(const struct
  */
 extern int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			int num);
+/* Unlocked flavor */
+extern int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
+			  int num);
 
 /* This is the very generalized SMBus access routine. You probably do not
    want to use this, though; one of the functions below may be much easier,

-- 
Jean Delvare
