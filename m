Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:44820 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751733AbdKDUU1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Nov 2017 16:20:27 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH v6 5/9] i2c: add i2c_master_{send|recv}_dmasafe
Date: Sat,  4 Nov 2017 21:20:05 +0100
Message-Id: <20171104202009.3818-6-wsa+renesas@sang-engineering.com>
In-Reply-To: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new helper to create variants of i2c_master_{send|recv} which
mark their buffers as DMA safe.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 include/linux/i2c.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index ef1a8791c1ae24..8c144e3cbfb261 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -81,6 +81,22 @@ static inline int i2c_master_recv(const struct i2c_client *client,
 };
 
 /**
+ * i2c_master_recv_dmasafe - issue a single I2C message in master receive mode
+ *			     using a DMA safe buffer
+ * @client: Handle to slave device
+ * @buf: Where to store data read from slave, must be safe to use with DMA
+ * @count: How many bytes to read, must be less than 64k since msg.len is u16
+ *
+ * Returns negative errno, or else the number of bytes read.
+ */
+static inline int i2c_master_recv_dmasafe(const struct i2c_client *client,
+					  char *buf, int count)
+{
+	return i2c_transfer_buffer_flags(client, buf, count,
+					 I2C_M_RD | I2C_M_DMA_SAFE);
+};
+
+/**
  * i2c_master_send - issue a single I2C message in master transmit mode
  * @client: Handle to slave device
  * @buf: Data that will be written to the slave
@@ -93,6 +109,21 @@ static inline int i2c_master_send(const struct i2c_client *client,
 {
 	return i2c_transfer_buffer_flags(client, (char *)buf, count, 0);
 };
+/**
+ * i2c_master_send_dmasafe - issue a single I2C message in master transmit mode
+ *			     using a DMA safe buffer
+ * @client: Handle to slave device
+ * @buf: Data that will be written to the slave, must be safe to use with DMA
+ * @count: How many bytes to write, must be less than 64k since msg.len is u16
+ *
+ * Returns negative errno, or else the number of bytes written.
+ */
+static inline int i2c_master_send_dmasafe(const struct i2c_client *client,
+					  const char *buf, int count)
+{
+	return i2c_transfer_buffer_flags(client, (char *)buf, count,
+					 I2C_M_DMA_SAFE);
+};
 
 /* Transfer num messages.
  */
-- 
2.11.0
