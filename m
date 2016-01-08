Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:36716 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbcAHPGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2016 10:06:11 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Peter Rosin <peda@axentia.se>,
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
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Peter Rosin <peda@lysator.liu.se>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3 7/8] i2c: muxes always lock the parent adapter
Date: Fri,  8 Jan 2016 16:04:55 +0100
Message-Id: <1452265496-22475-8-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
References: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Instead of checking for i2c parent adapters for every lock/unlock, simply
override the locking for muxes to always lock/unlock the parent adapter
directly.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-core.c | 21 +++------------------
 drivers/i2c/i2c-mux.c  | 27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 34a7748b4652..4683777f81ca 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -963,12 +963,7 @@ static int i2c_check_addr_busy(struct i2c_adapter *adapter, int addr)
  */
 static void i2c_adapter_lock_bus(struct i2c_adapter *adapter, int flags)
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
@@ -977,12 +972,7 @@ static void i2c_adapter_lock_bus(struct i2c_adapter *adapter, int flags)
  */
 static int i2c_adapter_trylock_bus(struct i2c_adapter *adapter, int flags)
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
@@ -991,12 +981,7 @@ static int i2c_adapter_trylock_bus(struct i2c_adapter *adapter, int flags)
  */
 static void i2c_adapter_unlock_bus(struct i2c_adapter *adapter, int flags)
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
index 9bdebbdcbc61..fcfe51b023c0 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -98,6 +98,30 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
 	return class;
 }
 
+static void i2c_parent_lock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	parent->lock_bus(parent, flags);
+}
+
+static int i2c_parent_trylock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	return parent->trylock_bus(parent, flags);
+}
+
+static void i2c_parent_unlock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	parent->unlock_bus(parent, flags);
+}
+
 int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters)
 {
 	struct i2c_adapter **adapter;
@@ -183,6 +207,9 @@ int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
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

