Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:59938 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753146AbdHQOOz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 10:14:55 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [RFC PATCH v4 2/6] i2c: add helpers to ease DMA handling
Date: Thu, 17 Aug 2017 16:14:45 +0200
Message-Id: <20170817141449.23958-3-wsa+renesas@sang-engineering.com>
In-Reply-To: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
References: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One helper checks if DMA is suitable and optionally creates a bounce
buffer, if not. The other function returns the bounce buffer and makes
sure the data is properly copied back to the message.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/i2c/i2c-core-base.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c.h         |  3 +++
 2 files changed, 48 insertions(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 12822a4b8f8f09..a104ebc2d05af8 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -2241,6 +2241,51 @@ void i2c_put_adapter(struct i2c_adapter *adap)
 }
 EXPORT_SYMBOL(i2c_put_adapter);
 
+/**
+ * i2c_get_dma_safe_msg_buf() - get a DMA safe buffer for the given i2c_msg
+ * @msg: the message to be checked
+ * @threshold: the amount of byte from which using DMA makes sense
+ *
+ * Return: NULL if a DMA safe buffer was not obtained. Use msg->buf with PIO.
+ *
+ *	   Or a valid pointer to be used with DMA. Note that it can either be
+ *	   msg->buf or a bounce buffer. After use, release it by calling
+ *	   i2c_release_dma_safe_msg_buf().
+ *
+ * This function must only be called from process context!
+ */
+u8 *i2c_get_dma_safe_msg_buf(struct i2c_msg *msg, unsigned int threshold)
+{
+	if (msg->len < threshold)
+		return NULL;
+
+	if (msg->flags & I2C_M_DMA_SAFE)
+		return msg->buf;
+
+	if (msg->flags & I2C_M_RD)
+		return kzalloc(msg->len, GFP_KERNEL);
+	else
+		return kmemdup(msg->buf, msg->len, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(i2c_get_dma_safe_msg_buf);
+
+/**
+ * i2c_release_dma_safe_msg_buf - release DMA safe buffer and sync with i2c_msg
+ * @msg: the message to be synced with
+ * @buf: the buffer obtained from i2c_get_dma_safe_msg_buf(). May be NULL.
+ */
+void i2c_release_dma_safe_msg_buf(struct i2c_msg *msg, u8 *buf)
+{
+	if (!buf || buf == msg->buf)
+		return;
+
+	if (msg->flags & I2C_M_RD)
+		memcpy(msg->buf, buf, msg->len);
+
+	kfree(buf);
+}
+EXPORT_SYMBOL_GPL(i2c_release_dma_safe_msg_buf);
+
 MODULE_AUTHOR("Simon G. Vogl <simon@tk.uni-linz.ac.at>");
 MODULE_DESCRIPTION("I2C-Bus main module");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index d501d3956f13f0..1e99342f180f45 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -767,6 +767,9 @@ static inline u8 i2c_8bit_addr_from_msg(const struct i2c_msg *msg)
 	return (msg->addr << 1) | (msg->flags & I2C_M_RD ? 1 : 0);
 }
 
+u8 *i2c_get_dma_safe_msg_buf(struct i2c_msg *msg, unsigned int threshold);
+void i2c_release_dma_safe_msg_buf(struct i2c_msg *msg, u8 *buf);
+
 int i2c_handle_smbus_host_notify(struct i2c_adapter *adap, unsigned short addr);
 /**
  * module_i2c_driver() - Helper macro for registering a modular I2C driver
-- 
2.11.0
