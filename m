Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:44807 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751709AbdKDUUZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Nov 2017 16:20:25 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH v6 4/9] i2c: refactor i2c_master_{send_recv}
Date: Sat,  4 Nov 2017 21:20:04 +0100
Message-Id: <20171104202009.3818-5-wsa+renesas@sang-engineering.com>
In-Reply-To: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two functions are very similar, the only differences are that one
needs the I2C_M_RD flag for its message while the other one needs the
buffer casted to drop the const. Introduce a generic helper which
allows to specify the flags (also needed later for DMA safe variants of
these calls) and let the casting be done in the inlining fuctions which
are now calling the new helper function.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/i2c/i2c-core-base.c | 64 +++++++++++++--------------------------------
 include/linux/i2c.h         | 34 +++++++++++++++++++++---
 2 files changed, 48 insertions(+), 50 deletions(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index de1850bd440659..206c47c85c98c5 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1972,63 +1972,35 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 EXPORT_SYMBOL(i2c_transfer);
 
 /**
- * i2c_master_send - issue a single I2C message in master transmit mode
+ * i2c_transfer_buffer_flags - issue a single I2C message transferring data
+ * 			       to/from a buffer
  * @client: Handle to slave device
- * @buf: Data that will be written to the slave
- * @count: How many bytes to write, must be less than 64k since msg.len is u16
+ * @buf: Where the data is stored
+ * @count: How many bytes to transfer, must be less than 64k since msg.len is u16
+ * @flags: The flags to be used for the message, e.g. I2C_M_RD for reads
  *
- * Returns negative errno, or else the number of bytes written.
+ * Returns negative errno, or else the number of bytes transferred.
  */
-int i2c_master_send(const struct i2c_client *client, const char *buf, int count)
+int i2c_transfer_buffer_flags(const struct i2c_client *client, char *buf,
+			      int count, u16 flags)
 {
 	int ret;
-	struct i2c_adapter *adap = client->adapter;
-	struct i2c_msg msg;
-
-	msg.addr = client->addr;
-	msg.flags = client->flags & I2C_M_TEN;
-	msg.len = count;
-	msg.buf = (char *)buf;
-
-	ret = i2c_transfer(adap, &msg, 1);
-
-	/*
-	 * If everything went ok (i.e. 1 msg transmitted), return #bytes
-	 * transmitted, else error code.
-	 */
-	return (ret == 1) ? count : ret;
-}
-EXPORT_SYMBOL(i2c_master_send);
-
-/**
- * i2c_master_recv - issue a single I2C message in master receive mode
- * @client: Handle to slave device
- * @buf: Where to store data read from slave
- * @count: How many bytes to read, must be less than 64k since msg.len is u16
- *
- * Returns negative errno, or else the number of bytes read.
- */
-int i2c_master_recv(const struct i2c_client *client, char *buf, int count)
-{
-	struct i2c_adapter *adap = client->adapter;
-	struct i2c_msg msg;
-	int ret;
-
-	msg.addr = client->addr;
-	msg.flags = client->flags & I2C_M_TEN;
-	msg.flags |= I2C_M_RD;
-	msg.len = count;
-	msg.buf = buf;
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.flags = flags | (client->flags & I2C_M_TEN),
+		.len = count,
+		.buf = buf,
+	};
 
-	ret = i2c_transfer(adap, &msg, 1);
+	ret = i2c_transfer(client->adapter, &msg, 1);
 
 	/*
-	 * If everything went ok (i.e. 1 msg received), return #bytes received,
-	 * else error code.
+	 * If everything went ok (i.e. 1 msg transferred), return #bytes
+	 * transferred, else error code.
 	 */
 	return (ret == 1) ? count : ret;
 }
-EXPORT_SYMBOL(i2c_master_recv);
+EXPORT_SYMBOL(i2c_transfer_buffer_flags);
 
 /* ----------------------------------------------------
  * the i2c address scanning function
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a0b57de91e21d3..ef1a8791c1ae24 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -63,10 +63,36 @@ struct property_entry;
  * transmit an arbitrary number of messages without interruption.
  * @count must be be less than 64k since msg.len is u16.
  */
-extern int i2c_master_send(const struct i2c_client *client, const char *buf,
-			   int count);
-extern int i2c_master_recv(const struct i2c_client *client, char *buf,
-			   int count);
+extern int i2c_transfer_buffer_flags(const struct i2c_client *client,
+				     char *buf, int count, u16 flags);
+
+/**
+ * i2c_master_recv - issue a single I2C message in master receive mode
+ * @client: Handle to slave device
+ * @buf: Where to store data read from slave
+ * @count: How many bytes to read, must be less than 64k since msg.len is u16
+ *
+ * Returns negative errno, or else the number of bytes read.
+ */
+static inline int i2c_master_recv(const struct i2c_client *client,
+				  char *buf, int count)
+{
+	return i2c_transfer_buffer_flags(client, buf, count, I2C_M_RD);
+};
+
+/**
+ * i2c_master_send - issue a single I2C message in master transmit mode
+ * @client: Handle to slave device
+ * @buf: Data that will be written to the slave
+ * @count: How many bytes to write, must be less than 64k since msg.len is u16
+ *
+ * Returns negative errno, or else the number of bytes written.
+ */
+static inline int i2c_master_send(const struct i2c_client *client,
+				  const char *buf, int count)
+{
+	return i2c_transfer_buffer_flags(client, (char *)buf, count, 0);
+};
 
 /* Transfer num messages.
  */
-- 
2.11.0
