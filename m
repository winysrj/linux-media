Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0111.outbound.protection.outlook.com ([157.55.234.111]:32534
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbcDTPfq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:46 -0400
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
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	<linux-i2c@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<devicetree@vger.kernel.org>, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v7 18/24] i2c-mux: relax locking of the top i2c adapter during mux-locked muxing
Date: Wed, 20 Apr 2016 17:17:58 +0200
Message-ID: <1461165484-2314-19-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

Introduce this new locking concept as "mux-locked" muxes, and call the
pre-existing mux locking scheme "parent-locked".

Modify the i2c mux locking so that muxes that are "mux-locked" locks only
the muxes on the parent adapter instead of the whole i2c bus when there is
a transfer to the slave side of the mux. This lock serializes transfers to
the slave side of the muxes on the parent adapter.

Add code to i2c-mux-gpio and i2c-mux-pinctrl that checks if all involved
gpio/pinctrl devices have a parent that is an i2c adapter in the same
adapter tree that is muxed, and request a "mux-locked mux" if that is the
case.

Modify the select-transfer-deselect code for "mux-locked" muxes so
that each of the select-transfer-deselect ops locks the mux parent
adapter individually.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-core.c              |   1 +
 drivers/i2c/i2c-mux.c               | 152 +++++++++++++++++++++++++++++++++---
 drivers/i2c/muxes/i2c-mux-gpio.c    |  18 +++++
 drivers/i2c/muxes/i2c-mux-pinctrl.c |  38 +++++++++
 include/linux/i2c-mux.h             |   6 ++
 include/linux/i2c.h                 |   1 +
 6 files changed, 203 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 5314434c2b5d..53514ea314cd 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1543,6 +1543,7 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 	}
 
 	rt_mutex_init(&adap->bus_lock);
+	rt_mutex_init(&adap->mux_lock);
 	mutex_init(&adap->userspace_clients_lock);
 	INIT_LIST_HEAD(&adap->userspace_clients);
 
diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index dc958eebdbb4..364319c3c95f 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -35,6 +35,25 @@ struct i2c_mux_priv {
 	u32 chan_id;
 };
 
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
+		ret = __i2c_transfer(parent, msgs, num);
+	if (muxc->deselect)
+		muxc->deselect(muxc, priv->chan_id);
+
+	return ret;
+}
+
 static int i2c_mux_master_xfer(struct i2c_adapter *adap,
 			       struct i2c_msg msgs[], int num)
 {
@@ -47,7 +66,29 @@ static int i2c_mux_master_xfer(struct i2c_adapter *adap,
 
 	ret = muxc->select(muxc, priv->chan_id);
 	if (ret >= 0)
-		ret = __i2c_transfer(parent, msgs, num);
+		ret = i2c_transfer(parent, msgs, num);
+	if (muxc->deselect)
+		muxc->deselect(muxc, priv->chan_id);
+
+	return ret;
+}
+
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
+		ret = parent->algo->smbus_xfer(parent, addr, flags,
+					read_write, command, size, data);
 	if (muxc->deselect)
 		muxc->deselect(muxc, priv->chan_id);
 
@@ -68,8 +109,8 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 
 	ret = muxc->select(muxc, priv->chan_id);
 	if (ret >= 0)
-		ret = parent->algo->smbus_xfer(parent, addr, flags,
-					read_write, command, size, data);
+		ret = i2c_smbus_xfer(parent, addr, flags,
+				     read_write, command, size, data);
 	if (muxc->deselect)
 		muxc->deselect(muxc, priv->chan_id);
 
@@ -98,12 +139,49 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
 	return class;
 }
 
+static void i2c_mux_lock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	rt_mutex_lock(&parent->mux_lock);
+	if (!(flags & I2C_LOCK_ADAPTER))
+		return;
+	i2c_lock_bus(parent, flags);
+}
+
+static int i2c_mux_trylock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	if (!rt_mutex_trylock(&parent->mux_lock))
+		return 0;
+	if (!(flags & I2C_LOCK_ADAPTER))
+		return 1;
+	if (parent->trylock_bus(parent, flags))
+		return 1;
+	rt_mutex_unlock(&parent->mux_lock);
+	return 0;
+}
+
+static void i2c_mux_unlock_bus(struct i2c_adapter *adapter, int flags)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_adapter *parent = priv->muxc->parent;
+
+	if (flags & I2C_LOCK_ADAPTER)
+		i2c_unlock_bus(parent, flags);
+	rt_mutex_unlock(&parent->mux_lock);
+}
+
 static void i2c_parent_lock_bus(struct i2c_adapter *adapter, int flags)
 {
 	struct i2c_mux_priv *priv = adapter->algo_data;
 	struct i2c_adapter *parent = priv->muxc->parent;
 
-	parent->lock_bus(parent, flags);
+	rt_mutex_lock(&parent->mux_lock);
+	i2c_lock_bus(parent, flags);
 }
 
 static int i2c_parent_trylock_bus(struct i2c_adapter *adapter, int flags)
@@ -111,7 +189,12 @@ static int i2c_parent_trylock_bus(struct i2c_adapter *adapter, int flags)
 	struct i2c_mux_priv *priv = adapter->algo_data;
 	struct i2c_adapter *parent = priv->muxc->parent;
 
-	return parent->trylock_bus(parent, flags);
+	if (!rt_mutex_trylock(&parent->mux_lock))
+		return 0;
+	if (parent->trylock_bus(parent, flags))
+		return 1;
+	rt_mutex_unlock(&parent->mux_lock);
+	return 0;
 }
 
 static void i2c_parent_unlock_bus(struct i2c_adapter *adapter, int flags)
@@ -119,8 +202,35 @@ static void i2c_parent_unlock_bus(struct i2c_adapter *adapter, int flags)
 	struct i2c_mux_priv *priv = adapter->algo_data;
 	struct i2c_adapter *parent = priv->muxc->parent;
 
-	parent->unlock_bus(parent, flags);
+	i2c_unlock_bus(parent, flags);
+	rt_mutex_unlock(&parent->mux_lock);
+}
+
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
 }
+EXPORT_SYMBOL_GPL(i2c_root_adapter);
 
 struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 				   struct device *dev, int max_adapters,
@@ -140,6 +250,8 @@ struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 
 	muxc->parent = parent;
 	muxc->dev = dev;
+	if (flags & I2C_MUX_LOCKED)
+		muxc->mux_locked = 1;
 	muxc->select = select;
 	muxc->deselect = deselect;
 	muxc->max_adapters = max_adapters;
@@ -173,10 +285,18 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	/* Need to do algo dynamically because we don't know ahead
 	 * of time what sort of physical adapter we'll be dealing with.
 	 */
-	if (parent->algo->master_xfer)
-		priv->algo.master_xfer = i2c_mux_master_xfer;
-	if (parent->algo->smbus_xfer)
-		priv->algo.smbus_xfer = i2c_mux_smbus_xfer;
+	if (parent->algo->master_xfer) {
+		if (muxc->mux_locked)
+			priv->algo.master_xfer = i2c_mux_master_xfer;
+		else
+			priv->algo.master_xfer = __i2c_mux_master_xfer;
+	}
+	if (parent->algo->smbus_xfer) {
+		if (muxc->mux_locked)
+			priv->algo.smbus_xfer = i2c_mux_smbus_xfer;
+		else
+			priv->algo.smbus_xfer = __i2c_mux_smbus_xfer;
+	}
 	priv->algo.functionality = i2c_mux_functionality;
 
 	/* Now fill out new adapter structure */
@@ -189,9 +309,15 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	priv->adap.retries = parent->retries;
 	priv->adap.timeout = parent->timeout;
 	priv->adap.quirks = parent->quirks;
-	priv->adap.lock_bus = i2c_parent_lock_bus;
-	priv->adap.trylock_bus = i2c_parent_trylock_bus;
-	priv->adap.unlock_bus = i2c_parent_unlock_bus;
+	if (muxc->mux_locked) {
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
index f6270ee934f9..e5cf26eefa97 100644
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
 
@@ -184,6 +186,9 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, muxc);
 
+	root = i2c_root_adapter(&parent->dev);
+
+	muxc->mux_locked = true;
 	mux->gpio_base = gpio_base;
 
 	if (mux->data.idle != I2C_MUX_GPIO_NO_IDLE) {
@@ -194,6 +199,9 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < mux->data.n_gpios; i++) {
+		struct device *gpio_dev;
+		struct gpio_desc *gpio_desc;
+
 		ret = gpio_request(gpio_base + mux->data.gpios[i], "i2c-mux-gpio");
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to request GPIO %d\n",
@@ -210,8 +218,18 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 			i++;	/* gpio_request above succeeded, so must free */
 			goto err_request_gpio;
 		}
+
+		if (!muxc->mux_locked)
+			continue;
+
+		gpio_desc = gpio_to_desc(gpio_base + mux->data.gpios[i]);
+		gpio_dev = &gpio_desc->gdev->dev;
+		muxc->mux_locked = i2c_root_adapter(gpio_dev) == root;
 	}
 
+	if (muxc->mux_locked)
+		dev_info(&pdev->dev, "mux-locked i2c mux\n");
+
 	for (i = 0; i < mux->data.n_values; i++) {
 		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 1b8dc711815e..bfc9d3989a9b 100644
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
 
 	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
@@ -202,6 +224,22 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+	root = i2c_root_adapter(&muxc->parent->dev);
+
+	muxc->mux_locked = true;
+	for (i = 0; i < mux->pdata->bus_count; i++) {
+		if (root != i2c_mux_pinctrl_root_adapter(mux->states[i])) {
+			muxc->mux_locked = false;
+			break;
+		}
+	}
+	if (muxc->mux_locked && mux->pdata->pinctrl_state_idle
+	    && root != i2c_mux_pinctrl_root_adapter(mux->state_idle))
+		muxc->mux_locked = false;
+
+	if (muxc->mux_locked)
+		dev_info(&pdev->dev, "mux-locked i2c mux\n");
+
 	for (i = 0; i < mux->pdata->bus_count; i++) {
 		u32 bus = mux->pdata->base_bus_num ?
 				(mux->pdata->base_bus_num + i) : 0;
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index 2fa93fe1345e..56a136927321 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -30,6 +30,7 @@
 struct i2c_mux_core {
 	struct i2c_adapter *parent;
 	struct device *dev;
+	bool mux_locked;
 
 	void *priv;
 
@@ -47,11 +48,16 @@ struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 				   int (*select)(struct i2c_mux_core *, u32),
 				   int (*deselect)(struct i2c_mux_core *, u32));
 
+/* flags for i2c_mux_alloc */
+#define I2C_MUX_LOCKED (1<<0)
+
 static inline void *i2c_mux_priv(struct i2c_mux_core *muxc)
 {
 	return muxc->priv;
 }
 
+struct i2c_adapter *i2c_root_adapter(struct device *dev);
+
 /*
  * Called to create an i2c bus on a multiplexed bus segment.
  * The chan_id parameter is passed to the select and deselect
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index c5f79fec1bfb..e682d41fa4a6 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -524,6 +524,7 @@ struct i2c_adapter {
 
 	/* data fields that are valid for all devices	*/
 	struct rt_mutex bus_lock;
+	struct rt_mutex mux_lock;
 
 	int timeout;			/* in jiffies */
 	int retries;
-- 
2.1.4

