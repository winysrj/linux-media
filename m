Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0097.outbound.protection.outlook.com ([104.47.2.97]:51128
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752698AbcEDUQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 16:16:09 -0400
From: Peter Rosin <peda@axentia.se>
To: <linux-kernel@vger.kernel.org>
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	<linux-i2c@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<devicetree@vger.kernel.org>
Subject: [PATCH v9 1/9] i2c: allow adapter drivers to override the adapter locking
Date: Wed, 4 May 2016 22:15:27 +0200
Message-ID: <1462392935-28011-2-git-send-email-peda@axentia.se>
In-Reply-To: <1462392935-28011-1-git-send-email-peda@axentia.se>
References: <1462392935-28011-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add i2c_lock_bus() and i2c_unlock_bus(), which call the new lock_bus and
unlock_bus ops in the adapter. These funcs/ops take an additional flags
argument that indicates for what purpose the adapter is locked.

There are two flags, I2C_LOCK_ROOT_ADAPTER and I2C_LOCK_SEGMENT, but they
are both implemented the same. For now. Locking the root adapter means
that the whole bus is locked, locking the segment means that only the
current bus segment is locked (i.e. i2c traffic on the parent side of
a mux is still allowed even if the child side of the mux is locked).

Also support a trylock_bus op (but no function to call it, as it is not
expected to be needed outside of the i2c core).

Implement i2c_lock_adapter/i2c_unlock_adapter in terms of the new locking
scheme (i.e. lock with the I2C_LOCK_ROOT_ADAPTER flag).

Locking the root adapter and locking the segment is the same thing for
all root adapters (e.g. in the normal case of a simple topology with no
i2c muxes). The two locking variants are also the same for traditional
muxes (aka parent-locked muxes). These muxes traverse the tree, locking
each level as they go until they reach the root. This patch is preparatory
for a later patch in the series introducing mux-locked muxes, which behave
differently depending on the requested locking. Since all current users
are using i2c_lock_adapter, which is a wrapper for I2C_LOCK_ROOT_ADAPTER,
we only need to annotate the calls that will not need to lock the root
adapter for mux-locked muxes. I.e. the instances that needs to use
I2C_LOCK_SEGMENT instead of i2c_lock_adapter/I2C_LOCK_ROOT_ADAPTER. Those
instances are in the i2c_transfer and i2c_smbus_xfer functions, so that
mux-locked muxes can single out normal i2c accesses to its slave side
and adjust the locking for those accesses.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-core.c | 41 +++++++++++++++++++++++++++--------------
 include/linux/i2c.h    | 44 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 4979728f7fb2..7ef5bd085476 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -954,10 +954,13 @@ static int i2c_check_addr_busy(struct i2c_adapter *adapter, int addr)
 }
 
 /**
- * i2c_lock_adapter - Get exclusive access to an I2C bus segment
+ * i2c_adapter_lock_bus - Get exclusive access to an I2C bus segment
  * @adapter: Target I2C bus segment
+ * @flags: I2C_LOCK_ROOT_ADAPTER locks the root i2c adapter, I2C_LOCK_SEGMENT
+ *	locks only this branch in the adapter tree
  */
-void i2c_lock_adapter(struct i2c_adapter *adapter)
+static void i2c_adapter_lock_bus(struct i2c_adapter *adapter,
+				 unsigned int flags)
 {
 	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
 
@@ -966,27 +969,32 @@ void i2c_lock_adapter(struct i2c_adapter *adapter)
 	else
 		rt_mutex_lock(&adapter->bus_lock);
 }
-EXPORT_SYMBOL_GPL(i2c_lock_adapter);
 
 /**
- * i2c_trylock_adapter - Try to get exclusive access to an I2C bus segment
+ * i2c_adapter_trylock_bus - Try to get exclusive access to an I2C bus segment
  * @adapter: Target I2C bus segment
+ * @flags: I2C_LOCK_ROOT_ADAPTER trylocks the root i2c adapter, I2C_LOCK_SEGMENT
+ *	trylocks only this branch in the adapter tree
  */
-static int i2c_trylock_adapter(struct i2c_adapter *adapter)
+static int i2c_adapter_trylock_bus(struct i2c_adapter *adapter,
+				   unsigned int flags)
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
+ * @flags: I2C_LOCK_ROOT_ADAPTER unlocks the root i2c adapter, I2C_LOCK_SEGMENT
+ *	unlocks only this branch in the adapter tree
  */
-void i2c_unlock_adapter(struct i2c_adapter *adapter)
+static void i2c_adapter_unlock_bus(struct i2c_adapter *adapter,
+				   unsigned int flags)
 {
 	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
 
@@ -995,7 +1003,6 @@ void i2c_unlock_adapter(struct i2c_adapter *adapter)
 	else
 		rt_mutex_unlock(&adapter->bus_lock);
 }
-EXPORT_SYMBOL_GPL(i2c_unlock_adapter);
 
 static void i2c_dev_set_name(struct i2c_adapter *adap,
 			     struct i2c_client *client)
@@ -1541,6 +1548,12 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
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
@@ -2310,16 +2323,16 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
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
@@ -3094,7 +3107,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 	flags &= I2C_M_TEN | I2C_CLIENT_PEC | I2C_CLIENT_SCCB;
 
 	if (adapter->algo->smbus_xfer) {
-		i2c_lock_adapter(adapter);
+		i2c_lock_bus(adapter, I2C_LOCK_SEGMENT);
 
 		/* Retry automatically on arbitration loss */
 		orig_jiffies = jiffies;
@@ -3108,7 +3121,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 				       orig_jiffies + adapter->timeout))
 				break;
 		}
-		i2c_unlock_adapter(adapter);
+		i2c_unlock_bus(adapter, I2C_LOCK_SEGMENT);
 
 		if (res != -EOPNOTSUPP || !adapter->algo->master_xfer)
 			goto trace;
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index c30833b7b073..50934d6e1050 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -538,6 +538,10 @@ struct i2c_adapter {
 
 	struct i2c_bus_recovery_info *bus_recovery_info;
 	const struct i2c_adapter_quirks *quirks;
+
+	void (*lock_bus)(struct i2c_adapter *, unsigned int flags);
+	int (*trylock_bus)(struct i2c_adapter *, unsigned int flags);
+	void (*unlock_bus)(struct i2c_adapter *, unsigned int flags);
 };
 #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
 
@@ -567,8 +571,44 @@ i2c_parent_is_i2c_adapter(const struct i2c_adapter *adapter)
 int i2c_for_each_dev(void *data, int (*fn)(struct device *, void *));
 
 /* Adapter locking functions, exported for shared pin cases */
-void i2c_lock_adapter(struct i2c_adapter *);
-void i2c_unlock_adapter(struct i2c_adapter *);
+#define I2C_LOCK_ROOT_ADAPTER BIT(0)
+#define I2C_LOCK_SEGMENT      BIT(1)
+
+/**
+ * i2c_lock_bus - Get exclusive access to an I2C bus segment
+ * @adapter: Target I2C bus segment
+ * @flags: I2C_LOCK_ROOT_ADAPTER locks the root i2c adapter, I2C_LOCK_SEGMENT
+ *	locks only this branch in the adapter tree
+ */
+static inline void
+i2c_lock_bus(struct i2c_adapter *adapter, unsigned int flags)
+{
+	adapter->lock_bus(adapter, flags);
+}
+
+/**
+ * i2c_unlock_bus - Release exclusive access to an I2C bus segment
+ * @adapter: Target I2C bus segment
+ * @flags: I2C_LOCK_ROOT_ADAPTER unlocks the root i2c adapter, I2C_LOCK_SEGMENT
+ *	unlocks only this branch in the adapter tree
+ */
+static inline void
+i2c_unlock_bus(struct i2c_adapter *adapter, unsigned int flags)
+{
+	adapter->unlock_bus(adapter, flags);
+}
+
+static inline void
+i2c_lock_adapter(struct i2c_adapter *adapter)
+{
+	i2c_lock_bus(adapter, I2C_LOCK_ROOT_ADAPTER);
+}
+
+static inline void
+i2c_unlock_adapter(struct i2c_adapter *adapter)
+{
+	i2c_unlock_bus(adapter, I2C_LOCK_ROOT_ADAPTER);
+}
 
 /*flags for the client struct: */
 #define I2C_CLIENT_PEC		0x04	/* Use Packet Error Checking */
-- 
2.1.4

