Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:34939 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbcCCWaQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 17:30:16 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Adriana Reus <adriana.reus@intel.com>,
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v4 16/18] i2c: allow adapter drivers to override the adapter locking
Date: Thu,  3 Mar 2016 23:27:28 +0100
Message-Id: <1457044050-15230-17-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Add i2c_lock_bus() and i2c_unlock_bus(), which call the new lock_bus and
unlock_bus ops in the adapter. These funcs/ops take an additional flags
argument that indicates for what purpose the adapter is locked.

There are two flags, I2C_LOCK_ADAPTER and I2C_LOCK_SEGMENT, but they are
both implemented the same. For now. Locking the adapter means that the
whole bus is locked, locking the segment means that only the current bus
segment is locked (i.e. i2c traffic on the parent side of mux is still
allowed even if the child side of the mux is locked.

Also support a trylock_bus op (but no function to call it, as it is not
expected to be needed outside of the i2c core).

Implement i2c_lock_adapter/i2c_unlock_adapter in terms of the new locking
scheme (i.e. lock with the I2C_LOCK_ADAPTER flag).

Annotate some of the locking with explicit I2C_LOCK_SEGMENT flags.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-core.c | 40 ++++++++++++++++++++++------------------
 include/linux/i2c.h    | 28 ++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index ffe715d346d8..946afd8e9f78 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -959,10 +959,10 @@ static int i2c_check_addr_busy(struct i2c_adapter *adapter, int addr)
 }
 
 /**
- * i2c_lock_adapter - Get exclusive access to an I2C bus segment
+ * i2c_adapter_lock_bus - Get exclusive access to an I2C bus segment
  * @adapter: Target I2C bus segment
  */
-void i2c_lock_adapter(struct i2c_adapter *adapter)
+static void i2c_adapter_lock_bus(struct i2c_adapter *adapter, int flags)
 {
 	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
 
@@ -971,27 +971,26 @@ void i2c_lock_adapter(struct i2c_adapter *adapter)
 	else
 		rt_mutex_lock(&adapter->bus_lock);
 }
-EXPORT_SYMBOL_GPL(i2c_lock_adapter);
 
 /**
- * i2c_trylock_adapter - Try to get exclusive access to an I2C bus segment
+ * i2c_adapter_trylock_bus - Try to get exclusive access to an I2C bus segment
  * @adapter: Target I2C bus segment
  */
-static int i2c_trylock_adapter(struct i2c_adapter *adapter)
+static int i2c_adapter_trylock_bus(struct i2c_adapter *adapter, int flags)
 {
 	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
 
 	if (parent)
-		return i2c_trylock_adapter(parent);
+		return parent->trylock_bus(parent, flags);
 	else
 		return rt_mutex_trylock(&adapter->bus_lock);
 }
 
 /**
- * i2c_unlock_adapter - Release exclusive access to an I2C bus segment
+ * i2c_adapter_unlock_bus - Release exclusive access to an I2C bus segment
  * @adapter: Target I2C bus segment
  */
-void i2c_unlock_adapter(struct i2c_adapter *adapter)
+static void i2c_adapter_unlock_bus(struct i2c_adapter *adapter, int flags)
 {
 	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
 
@@ -1000,7 +999,6 @@ void i2c_unlock_adapter(struct i2c_adapter *adapter)
 	else
 		rt_mutex_unlock(&adapter->bus_lock);
 }
-EXPORT_SYMBOL_GPL(i2c_unlock_adapter);
 
 static void i2c_dev_set_name(struct i2c_adapter *adap,
 			     struct i2c_client *client)
@@ -1546,6 +1544,12 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 		return -EINVAL;
 	}
 
+	if (!adap->lock_bus) {
+		adap->lock_bus = i2c_adapter_lock_bus;
+		adap->trylock_bus = i2c_adapter_trylock_bus;
+		adap->unlock_bus = i2c_adapter_unlock_bus;
+	}
+
 	rt_mutex_init(&adap->bus_lock);
 	mutex_init(&adap->userspace_clients_lock);
 	INIT_LIST_HEAD(&adap->userspace_clients);
@@ -2310,16 +2314,16 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 #endif
 
 		if (in_atomic() || irqs_disabled()) {
-			ret = i2c_trylock_adapter(adap);
+			ret = adap->trylock_bus(adap, I2C_LOCK_SEGMENT);
 			if (!ret)
 				/* I2C activity is ongoing. */
 				return -EAGAIN;
 		} else {
-			i2c_lock_adapter(adap);
+			i2c_lock_bus(adap, I2C_LOCK_SEGMENT);
 		}
 
 		ret = __i2c_transfer(adap, msgs, num);
-		i2c_unlock_adapter(adap);
+		i2c_unlock_bus(adap, I2C_LOCK_SEGMENT);
 
 		return ret;
 	} else {
@@ -3094,7 +3098,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 	flags &= I2C_M_TEN | I2C_CLIENT_PEC | I2C_CLIENT_SCCB;
 
 	if (adapter->algo->smbus_xfer) {
-		i2c_lock_adapter(adapter);
+		i2c_lock_bus(adapter, I2C_LOCK_SEGMENT);
 
 		/* Retry automatically on arbitration loss */
 		orig_jiffies = jiffies;
@@ -3108,7 +3112,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 				       orig_jiffies + adapter->timeout))
 				break;
 		}
-		i2c_unlock_adapter(adapter);
+		i2c_unlock_bus(adapter, I2C_LOCK_SEGMENT);
 
 		if (res != -EOPNOTSUPP || !adapter->algo->master_xfer)
 			goto trace;
@@ -3219,9 +3223,9 @@ int i2c_slave_register(struct i2c_client *client, i2c_slave_cb_t slave_cb)
 
 	client->slave_cb = slave_cb;
 
-	i2c_lock_adapter(client->adapter);
+	i2c_lock_bus(client->adapter, I2C_LOCK_SEGMENT);
 	ret = client->adapter->algo->reg_slave(client);
-	i2c_unlock_adapter(client->adapter);
+	i2c_unlock_bus(client->adapter, I2C_LOCK_SEGMENT);
 
 	if (ret) {
 		client->slave_cb = NULL;
@@ -3241,9 +3245,9 @@ int i2c_slave_unregister(struct i2c_client *client)
 		return -EOPNOTSUPP;
 	}
 
-	i2c_lock_adapter(client->adapter);
+	i2c_lock_bus(client->adapter, I2C_LOCK_SEGMENT);
 	ret = client->adapter->algo->unreg_slave(client);
-	i2c_unlock_adapter(client->adapter);
+	i2c_unlock_bus(client->adapter, I2C_LOCK_SEGMENT);
 
 	if (ret == 0)
 		client->slave_cb = NULL;
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 200cf13b00f6..c5f79fec1bfb 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -538,6 +538,10 @@ struct i2c_adapter {
 
 	struct i2c_bus_recovery_info *bus_recovery_info;
 	const struct i2c_adapter_quirks *quirks;
+
+	void (*lock_bus)(struct i2c_adapter *, int flags);
+	int (*trylock_bus)(struct i2c_adapter *, int flags);
+	void (*unlock_bus)(struct i2c_adapter *, int flags);
 };
 #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
 
@@ -567,8 +571,28 @@ i2c_parent_is_i2c_adapter(const struct i2c_adapter *adapter)
 int i2c_for_each_dev(void *data, int (*fn)(struct device *, void *));
 
 /* Adapter locking functions, exported for shared pin cases */
-void i2c_lock_adapter(struct i2c_adapter *);
-void i2c_unlock_adapter(struct i2c_adapter *);
+#define I2C_LOCK_ADAPTER 0x01
+#define I2C_LOCK_SEGMENT 0x02
+static inline void
+i2c_lock_bus(struct i2c_adapter *adapter, int flags)
+{
+	adapter->lock_bus(adapter, flags);
+}
+static inline void
+i2c_unlock_bus(struct i2c_adapter *adapter, int flags)
+{
+	adapter->unlock_bus(adapter, flags);
+}
+static inline void
+i2c_lock_adapter(struct i2c_adapter *adapter)
+{
+	i2c_lock_bus(adapter, I2C_LOCK_ADAPTER);
+}
+static inline void
+i2c_unlock_adapter(struct i2c_adapter *adapter)
+{
+	i2c_unlock_bus(adapter, I2C_LOCK_ADAPTER);
+}
 
 /*flags for the client struct: */
 #define I2C_CLIENT_PEC		0x04	/* Use Packet Error Checking */
-- 
2.1.4

