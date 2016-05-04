Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0097.outbound.protection.outlook.com ([104.47.2.97]:51128
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754220AbcEDUQN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 16:16:13 -0400
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
Subject: [PATCH v9 2/9] i2c: muxes always lock the parent adapter
Date: Wed, 4 May 2016 22:15:28 +0200
Message-ID: <1462392935-28011-3-git-send-email-peda@axentia.se>
In-Reply-To: <1462392935-28011-1-git-send-email-peda@axentia.se>
References: <1462392935-28011-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking for i2c parent adapters for every lock/unlock, simply
override the locking for muxes to always lock/unlock the parent adapter
directly.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-core.c | 21 +++------------------
 drivers/i2c/i2c-mux.c  | 30 ++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 7ef5bd085476..afdee66002db 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -962,12 +962,7 @@ static int i2c_check_addr_busy(struct i2c_adapter *adapter, int addr)
 static void i2c_adapter_lock_bus(struct i2c_adapter *adapter,
 				 unsigned int flags)
 {
-	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
-
-	if (parent)
-		i2c_lock_adapter(parent);
-	else
-		rt_mutex_lock(&adapter->bus_lock);
+	rt_mutex_lock(&adapter->bus_lock);
 }
 
 /**
@@ -979,12 +974,7 @@ static void i2c_adapter_lock_bus(struct i2c_adapter *adapter,
 static int i2c_adapter_trylock_bus(struct i2c_adapter *adapter,
 				   unsigned int flags)
 {
-	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
-
-	if (parent)
-		return parent->trylock_bus(parent, flags);
-	else
-		return rt_mutex_trylock(&adapter->bus_lock);
+	return rt_mutex_trylock(&adapter->bus_lock);
 }
 
 /**
@@ -996,12 +986,7 @@ static int i2c_adapter_trylock_bus(struct i2c_adapter *adapter,
 static void i2c_adapter_unlock_bus(struct i2c_adapter *adapter,
 				   unsigned int flags)
 {
-	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
-
-	if (parent)
-		i2c_unlock_adapter(parent);
-	else
-		rt_mutex_unlock(&adapter->bus_lock);
+	rt_mutex_unlock(&adapter->bus_lock);
 }
 
 static void i2c_dev_set_name(struct i2c_adapter *adap,
diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 25e9336b0e6e..5fa8af715e24 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -98,6 +98,33 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
 	return class;
 }
 
+static void i2c_parent_lock_bus(struct i2c_adapter *adapter,
+				unsigned int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	parent->lock_bus(parent, flags);
+}
+
+static int i2c_parent_trylock_bus(struct i2c_adapter *adapter,
+				  unsigned int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	return parent->trylock_bus(parent, flags);
+}
+
+static void i2c_parent_unlock_bus(struct i2c_adapter *adapter,
+				  unsigned int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	parent->unlock_bus(parent, flags);
+}
+
 struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 				   struct device *dev, int max_adapters,
 				   int sizeof_priv, u32 flags,
@@ -165,6 +192,9 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	priv->adap.retries = parent->retries;
 	priv->adap.timeout = parent->timeout;
 	priv->adap.quirks = parent->quirks;
+	priv->adap.lock_bus = i2c_parent_lock_bus;
+	priv->adap.trylock_bus = i2c_parent_trylock_bus;
+	priv->adap.unlock_bus = i2c_parent_unlock_bus;
 
 	/* Sanity check on class */
 	if (i2c_mux_parent_classes(parent) & class)
-- 
2.1.4

