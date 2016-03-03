Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:40700 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbcCCWa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 17:30:29 -0500
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
Subject: [PATCH v4 18/18] i2c-mux: relax locking of the top i2c adapter during i2c controlled muxing
Date: Thu,  3 Mar 2016 23:27:30 +0100
Message-Id: <1457044050-15230-19-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

With a i2c topology like the following

                       GPIO ---|  ------ BAT1
                        |      v /
   I2C  -----+----------+---- MUX
             |                   \
           EEPROM                 ------ BAT2

there is a locking problem with the GPIO controller since it is a client
on the same i2c bus that it muxes. Transfers to the mux clients (e.g. BAT1)
will lock the whole i2c bus prior to attempting to switch the mux to the
correct i2c segment. In the above case, the GPIO device is an I/O expander
with an i2c interface, and since the GPIO subsystem knows nothing (and
rightfully so) about the lockless needs of the i2c mux code, this results
in a deadlock when the GPIO driver issues i2c transfers to modify the
mux.

So, observing that while it is needed to have the i2c bus locked during the
actual MUX update in order to avoid random garbage on the slave side, it
is not strictly a must to have it locked over the whole sequence of a full
select-transfer-deselect mux client operation. The mux itself needs to be
locked, so transfers to clients behind the mux are serialized, and the mux
needs to be stable during all i2c traffic (otherwise individual mux slave
segments might see garbage, or worse).

Add code to i2c-mux-gpio and i2c-mux-pinctrl that checks if all involved
gpio/pinctrl devices have a parent that is an i2c adapter in the same
adapter tree that is muxed.

Modify the i2c mux locking so that muxes that are "i2c-controlled" locks
the mux instead of the whole i2c bus when there is a transfer to the slave
side of the mux. This lock serializes transfers to the slave side of the
mux.

Modify the select-transfer-deselect code for "i2c-controlled" muxes so
that each of the select-transfer-deselect ops locks the mux parent
adapter individually.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-mux.c               | 136 ++++++++++++++++++++++++++++++++++--
 drivers/i2c/muxes/i2c-mux-gpio.c    |  19 +++++
 drivers/i2c/muxes/i2c-mux-pinctrl.c |  39 +++++++++++
 include/linux/i2c-mux.h             |   7 ++
 4 files changed, 194 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 6f5c70c527b8..40a4e0397826 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -54,6 +54,25 @@ static int i2c_mux_master_xfer(struct i2c_adapter *adap,
 	return ret;
 }
 
+static int __i2c_mux_master_xfer(struct i2c_adapter *adap,
+				 struct i2c_msg msgs[], int num)
+{
+	struct i2c_mux_priv *priv = adap->algo_data;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
+	int ret;
+
+	/* Switch to the right mux port and perform the transfer. */
+
+	ret = muxc->select(muxc, priv->chan_id);
+	if (ret >= 0)
+		ret = i2c_transfer(parent, msgs, num);
+	if (muxc->deselect)
+		muxc->deselect(muxc, priv->chan_id);
+
+	return ret;
+}
+
 static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 			      u16 addr, unsigned short flags,
 			      char read_write, u8 command,
@@ -76,6 +95,28 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 	return ret;
 }
 
+static int __i2c_mux_smbus_xfer(struct i2c_adapter *adap,
+				u16 addr, unsigned short flags,
+				char read_write, u8 command,
+				int size, union i2c_smbus_data *data)
+{
+	struct i2c_mux_priv *priv = adap->algo_data;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
+	int ret;
+
+	/* Select the right mux port and perform the transfer. */
+
+	ret = muxc->select(muxc, priv->chan_id);
+	if (ret >= 0)
+		ret = i2c_smbus_xfer(parent, addr, flags,
+				     read_write, command, size, data);
+	if (muxc->deselect)
+		muxc->deselect(muxc, priv->chan_id);
+
+	return ret;
+}
+
 /* Return the parent's functionality */
 static u32 i2c_mux_functionality(struct i2c_adapter *adap)
 {
@@ -98,6 +139,45 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
 	return class;
 }
 
+static void i2c_mux_lock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
+
+	rt_mutex_lock(&muxc->bus_lock);
+	if (!(flags & I2C_LOCK_ADAPTER))
+		return;
+	i2c_lock_bus(parent, flags);
+}
+
+static int i2c_mux_trylock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
+
+	if (!rt_mutex_trylock(&muxc->bus_lock))
+		return 0;
+	if (!(flags & I2C_LOCK_ADAPTER))
+		return 1;
+	if (parent->trylock_bus(parent, flags))
+		return 1;
+	rt_mutex_unlock(&muxc->bus_lock);
+	return 0;
+}
+
+static void i2c_mux_unlock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
+
+	if (flags & I2C_LOCK_ADAPTER)
+		i2c_unlock_bus(parent, flags);
+	rt_mutex_unlock(&muxc->bus_lock);
+}
+
 static void i2c_parent_lock_bus(struct i2c_adapter *adapter, int flags)
 {
 	struct i2c_mux_priv *priv = adapter->algo_data;
@@ -122,6 +202,31 @@ static void i2c_parent_unlock_bus(struct i2c_adapter *adapter, int flags)
 	parent->unlock_bus(parent, flags);
 }
 
+struct i2c_adapter *i2c_root_adapter(struct device *dev)
+{
+	struct device *i2c;
+	struct i2c_adapter *i2c_root;
+
+	/*
+	 * Walk up the device tree to find an i2c adapter, indicating
+	 * that this is an i2c client device. Check all ancestors to
+	 * handle mfd devices etc.
+	 */
+	for (i2c = dev; i2c; i2c = i2c->parent) {
+		if (i2c->type == &i2c_adapter_type)
+			break;
+	}
+	if (!i2c)
+		return NULL;
+
+	/* Continue up the tree to find the root i2c adapter */
+	i2c_root = to_i2c_adapter(i2c);
+	while (i2c_parent_is_i2c_adapter(i2c_root))
+		i2c_root = i2c_parent_is_i2c_adapter(i2c_root);
+
+	return i2c_root;
+}
+
 int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters)
 {
 	struct i2c_adapter **adapter;
@@ -163,9 +268,12 @@ struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 
 	muxc->parent = parent;
 	muxc->dev = dev;
+	if (flags & I2C_CONTROLLED_MUX)
+		muxc->i2c_controlled = 1;
 	muxc->select = select;
 	muxc->deselect = deselect;
 
+	rt_mutex_init(&muxc->bus_lock);
 	return muxc;
 }
 EXPORT_SYMBOL_GPL(i2c_mux_alloc);
@@ -200,10 +308,18 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	/* Need to do algo dynamically because we don't know ahead
 	 * of time what sort of physical adapter we'll be dealing with.
 	 */
-	if (parent->algo->master_xfer)
-		priv->algo.master_xfer = i2c_mux_master_xfer;
-	if (parent->algo->smbus_xfer)
-		priv->algo.smbus_xfer = i2c_mux_smbus_xfer;
+	if (parent->algo->master_xfer) {
+		if (muxc->i2c_controlled)
+			priv->algo.master_xfer = __i2c_mux_master_xfer;
+		else
+			priv->algo.master_xfer = i2c_mux_master_xfer;
+	}
+	if (parent->algo->smbus_xfer) {
+		if (muxc->i2c_controlled)
+			priv->algo.smbus_xfer = __i2c_mux_smbus_xfer;
+		else
+			priv->algo.smbus_xfer = i2c_mux_smbus_xfer;
+	}
 	priv->algo.functionality = i2c_mux_functionality;
 
 	/* Now fill out new adapter structure */
@@ -216,9 +332,15 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	priv->adap.retries = parent->retries;
 	priv->adap.timeout = parent->timeout;
 	priv->adap.quirks = parent->quirks;
-	priv->adap.lock_bus = i2c_parent_lock_bus;
-	priv->adap.trylock_bus = i2c_parent_trylock_bus;
-	priv->adap.unlock_bus = i2c_parent_unlock_bus;
+	if (muxc->i2c_controlled) {
+		priv->adap.lock_bus = i2c_mux_lock_bus;
+		priv->adap.trylock_bus = i2c_mux_trylock_bus;
+		priv->adap.unlock_bus = i2c_mux_unlock_bus;
+	} else {
+		priv->adap.lock_bus = i2c_parent_lock_bus;
+		priv->adap.trylock_bus = i2c_parent_trylock_bus;
+		priv->adap.unlock_bus = i2c_parent_unlock_bus;
+	}
 
 	/* Sanity check on class */
 	if (i2c_mux_parent_classes(parent) & class)
diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 1bcc26737359..f7a9d36b5e09 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
+#include "../../gpio/gpiolib.h"
 #include <linux/of_gpio.h>
 
 struct gpiomux {
@@ -137,6 +138,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	struct i2c_mux_core *muxc;
 	struct gpiomux *mux;
 	struct i2c_adapter *parent;
+	struct i2c_adapter *root;
 	unsigned initial_state, gpio_base;
 	int i, ret;
 
@@ -178,6 +180,9 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	if (!parent)
 		return -EPROBE_DEFER;
 
+	root = i2c_root_adapter(&parent->dev);
+
+	muxc->i2c_controlled = true;
 	muxc->parent = parent;
 	mux->gpio_base = gpio_base;
 
@@ -193,6 +198,9 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < mux->data.n_gpios; i++) {
+		struct device *gpio_dev;
+		struct gpio_desc *gpio_desc;
+
 		ret = gpio_request(gpio_base + mux->data.gpios[i], "i2c-mux-gpio");
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to request GPIO %d\n",
@@ -209,8 +217,19 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 			i++;	/* gpio_request above succeeded, so must free */
 			goto err_request_gpio;
 		}
+
+		if (!muxc->i2c_controlled)
+			continue;
+
+		gpio_desc = gpio_to_desc(gpio_base + mux->data.gpios[i]);
+		gpio_dev = gpio_desc->chip->parent;
+		muxc->i2c_controlled = i2c_root_adapter(gpio_dev) == root;
 	}
 
+	if (muxc->i2c_controlled)
+		dev_info(&pdev->dev,
+			"lock select-transfer-deselect individually\n");
+
 	for (i = 0; i < mux->data.n_values; i++) {
 		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index bbfabf4f52be..d2532959e8bc 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include "../../pinctrl/core.h"
 
 struct i2c_mux_pinctrl {
 	struct i2c_mux_pinctrl_platform_data *pdata;
@@ -120,10 +121,31 @@ static inline int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 }
 #endif
 
+static struct i2c_adapter *i2c_mux_pinctrl_root_adapter(
+	struct pinctrl_state *state)
+{
+	struct i2c_adapter *root = NULL;
+	struct pinctrl_setting *setting;
+	struct i2c_adapter *pin_root;
+
+	list_for_each_entry(setting, &state->settings, node) {
+		pin_root = i2c_root_adapter(setting->pctldev->dev);
+		if (!pin_root)
+			return NULL;
+		if (!root)
+			root = pin_root;
+		else if (root != pin_root)
+			return NULL;
+	}
+
+	return root;
+}
+
 static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 {
 	struct i2c_mux_core *muxc;
 	struct i2c_mux_pinctrl *mux;
+	struct i2c_adapter *root;
 	int i, ret;
 
 	muxc = i2c_mux_alloc(NULL, &pdev->dev, sizeof(*mux), 0,
@@ -199,6 +221,23 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+	root = i2c_root_adapter(&muxc->parent->dev);
+
+	muxc->i2c_controlled = true;
+	for (i = 0; i < mux->pdata->bus_count; i++) {
+		if (root != i2c_mux_pinctrl_root_adapter(mux->states[i])) {
+			muxc->i2c_controlled = false;
+			break;
+		}
+	}
+	if (muxc->i2c_controlled && mux->pdata->pinctrl_state_idle
+	    && root != i2c_mux_pinctrl_root_adapter(mux->state_idle))
+		muxc->i2c_controlled = false;
+
+	if (muxc->i2c_controlled)
+		dev_info(&pdev->dev,
+			"lock select-transfer-deselect individually\n");
+
 	for (i = 0; i < mux->pdata->bus_count; i++) {
 		u32 bus = mux->pdata->base_bus_num ?
 				(mux->pdata->base_bus_num + i) : 0;
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index 25c88ccf9c38..d0b7e2d9f4dd 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -33,6 +33,8 @@ struct i2c_mux_core {
 	int adapters;
 	int max_adapters;
 	struct device *dev;
+	struct rt_mutex bus_lock;
+	bool i2c_controlled;
 
 	void *priv;
 
@@ -46,11 +48,16 @@ struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 				   int (*select)(struct i2c_mux_core *, u32),
 				   int (*deselect)(struct i2c_mux_core *, u32));
 
+/* flags for i2c_mux_alloc */
+#define I2C_CONTROLLED_MUX (1<<0)
+
 static inline void *i2c_mux_priv(struct i2c_mux_core *muxc)
 {
 	return muxc->priv;
 }
 
+struct i2c_adapter *i2c_root_adapter(struct device *dev);
+
 int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters);
 
 /*
-- 
2.1.4

