Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0108.outbound.protection.outlook.com ([157.55.234.108]:2593
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750815AbcDTPeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:34:00 -0400
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
Subject: [PATCH v7 01/24] i2c-mux: add common data for every i2c-mux instance
Date: Wed, 20 Apr 2016 17:17:41 +0200
Message-ID: <1461165484-2314-2-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All i2c-muxes have a parent adapter and one or many child
adapters. A mux also has some means of selection. Previously,
this was stored per child adapter, but it is only needed
to keep track of this per mux.

Add an i2c mux core, that keeps track of this consistently.

Also add some glue for users of the old interface, which will
create one implicit mux core per child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-mux.c   | 175 ++++++++++++++++++++++++++++++++++++------------
 include/linux/i2c-mux.h |  34 ++++++++++
 2 files changed, 168 insertions(+), 41 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index d4022878b2f0..5ce1b0704cb5 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -28,33 +28,34 @@
 #include <linux/slab.h>
 
 /* multiplexer per channel data */
+struct i2c_mux_priv_old {
+	void *mux_priv;
+	int (*select)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
+	int (*deselect)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
+};
+
 struct i2c_mux_priv {
 	struct i2c_adapter adap;
 	struct i2c_algorithm algo;
-
-	struct i2c_adapter *parent;
-	struct device *mux_dev;
-	void *mux_priv;
+	struct i2c_mux_core *muxc;
 	u32 chan_id;
-
-	int (*select)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
-	int (*deselect)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
 };
 
 static int i2c_mux_master_xfer(struct i2c_adapter *adap,
 			       struct i2c_msg msgs[], int num)
 {
 	struct i2c_mux_priv *priv = adap->algo_data;
-	struct i2c_adapter *parent = priv->parent;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
 	int ret;
 
 	/* Switch to the right mux port and perform the transfer. */
 
-	ret = priv->select(parent, priv->mux_priv, priv->chan_id);
+	ret = muxc->select(muxc, priv->chan_id);
 	if (ret >= 0)
 		ret = __i2c_transfer(parent, msgs, num);
-	if (priv->deselect)
-		priv->deselect(parent, priv->mux_priv, priv->chan_id);
+	if (muxc->deselect)
+		muxc->deselect(muxc, priv->chan_id);
 
 	return ret;
 }
@@ -65,17 +66,18 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 			      int size, union i2c_smbus_data *data)
 {
 	struct i2c_mux_priv *priv = adap->algo_data;
-	struct i2c_adapter *parent = priv->parent;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
 	int ret;
 
 	/* Select the right mux port and perform the transfer. */
 
-	ret = priv->select(parent, priv->mux_priv, priv->chan_id);
+	ret = muxc->select(muxc, priv->chan_id);
 	if (ret >= 0)
 		ret = parent->algo->smbus_xfer(parent, addr, flags,
 					read_write, command, size, data);
-	if (priv->deselect)
-		priv->deselect(parent, priv->mux_priv, priv->chan_id);
+	if (muxc->deselect)
+		muxc->deselect(muxc, priv->chan_id);
 
 	return ret;
 }
@@ -84,7 +86,7 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 static u32 i2c_mux_functionality(struct i2c_adapter *adap)
 {
 	struct i2c_mux_priv *priv = adap->algo_data;
-	struct i2c_adapter *parent = priv->parent;
+	struct i2c_adapter *parent = priv->muxc->parent;
 
 	return parent->algo->functionality(parent);
 }
@@ -102,6 +104,20 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
 	return class;
 }
 
+static int i2c_mux_select(struct i2c_mux_core *muxc, u32 chan)
+{
+	struct i2c_mux_priv_old *priv = i2c_mux_priv(muxc);
+
+	return priv->select(muxc->parent, priv->mux_priv, chan);
+}
+
+static int i2c_mux_deselect(struct i2c_mux_core *muxc, u32 chan)
+{
+	struct i2c_mux_priv_old *priv = i2c_mux_priv(muxc);
+
+	return priv->deselect(muxc->parent, priv->mux_priv, chan);
+}
+
 struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 				struct device *mux_dev,
 				void *mux_priv, u32 force_nr, u32 chan_id,
@@ -111,21 +127,77 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 				int (*deselect) (struct i2c_adapter *,
 						 void *, u32))
 {
+	struct i2c_mux_core *muxc;
+	struct i2c_mux_priv_old *priv;
+	int ret;
+
+	muxc = i2c_mux_alloc(parent, mux_dev, 1, sizeof(*priv), 0,
+			     i2c_mux_select, i2c_mux_deselect);
+	if (!muxc)
+		return NULL;
+
+	priv = i2c_mux_priv(muxc);
+	priv->select = select;
+	priv->deselect = deselect;
+	priv->mux_priv = mux_priv;
+
+	ret = i2c_mux_add_adapter(muxc, force_nr, chan_id, class);
+	if (ret) {
+		devm_kfree(mux_dev, muxc);
+		return NULL;
+	}
+
+	return muxc->adapter[0];
+}
+EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
+
+struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
+				   struct device *dev, int max_adapters,
+				   int sizeof_priv, u32 flags,
+				   int (*select)(struct i2c_mux_core *, u32),
+				   int (*deselect)(struct i2c_mux_core *, u32))
+{
+	struct i2c_mux_core *muxc;
+
+	muxc = devm_kzalloc(dev, sizeof(*muxc)
+			    + max_adapters * sizeof(muxc->adapter[0])
+			    + sizeof_priv, GFP_KERNEL);
+	if (!muxc)
+		return NULL;
+	if (sizeof_priv)
+		muxc->priv = &muxc->adapter[max_adapters];
+
+	muxc->parent = parent;
+	muxc->dev = dev;
+	muxc->select = select;
+	muxc->deselect = deselect;
+	muxc->max_adapters = max_adapters;
+
+	return muxc;
+}
+EXPORT_SYMBOL_GPL(i2c_mux_alloc);
+
+int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
+			u32 force_nr, u32 chan_id,
+			unsigned int class)
+{
+	struct i2c_adapter *parent = muxc->parent;
 	struct i2c_mux_priv *priv;
 	char symlink_name[20];
 	int ret;
 
-	priv = kzalloc(sizeof(struct i2c_mux_priv), GFP_KERNEL);
+	if (muxc->num_adapters >= muxc->max_adapters) {
+		dev_err(muxc->dev, "No room for more i2c-mux adapters\n");
+		return -EINVAL;
+	}
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-		return NULL;
+		return -ENOMEM;
 
 	/* Set up private adapter data */
-	priv->parent = parent;
-	priv->mux_dev = mux_dev;
-	priv->mux_priv = mux_priv;
+	priv->muxc = muxc;
 	priv->chan_id = chan_id;
-	priv->select = select;
-	priv->deselect = deselect;
 
 	/* Need to do algo dynamically because we don't know ahead
 	 * of time what sort of physical adapter we'll be dealing with.
@@ -159,11 +231,11 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 	 * Try to populate the mux adapter's of_node, expands to
 	 * nothing if !CONFIG_OF.
 	 */
-	if (mux_dev->of_node) {
+	if (muxc->dev->of_node) {
 		struct device_node *child;
 		u32 reg;
 
-		for_each_child_of_node(mux_dev->of_node, child) {
+		for_each_child_of_node(muxc->dev->of_node, child) {
 			ret = of_property_read_u32(child, "reg", &reg);
 			if (ret)
 				continue;
@@ -177,8 +249,9 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 	/*
 	 * Associate the mux channel with an ACPI node.
 	 */
-	if (has_acpi_companion(mux_dev))
-		acpi_preset_companion(&priv->adap.dev, ACPI_COMPANION(mux_dev),
+	if (has_acpi_companion(muxc->dev))
+		acpi_preset_companion(&priv->adap.dev,
+				      ACPI_COMPANION(muxc->dev),
 				      chan_id);
 
 	if (force_nr) {
@@ -192,33 +265,53 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 			"failed to add mux-adapter (error=%d)\n",
 			ret);
 		kfree(priv);
-		return NULL;
+		return ret;
 	}
 
-	WARN(sysfs_create_link(&priv->adap.dev.kobj, &mux_dev->kobj, "mux_device"),
-			       "can't create symlink to mux device\n");
+	WARN(sysfs_create_link(&priv->adap.dev.kobj, &muxc->dev->kobj,
+			       "mux_device"),
+	     "can't create symlink to mux device\n");
 
 	snprintf(symlink_name, sizeof(symlink_name), "channel-%u", chan_id);
-	WARN(sysfs_create_link(&mux_dev->kobj, &priv->adap.dev.kobj, symlink_name),
-			       "can't create symlink for channel %u\n", chan_id);
+	WARN(sysfs_create_link(&muxc->dev->kobj, &priv->adap.dev.kobj,
+			       symlink_name),
+	     "can't create symlink for channel %u\n", chan_id);
 	dev_info(&parent->dev, "Added multiplexed i2c bus %d\n",
 		 i2c_adapter_id(&priv->adap));
 
-	return &priv->adap;
+	muxc->adapter[muxc->num_adapters++] = &priv->adap;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
+EXPORT_SYMBOL_GPL(i2c_mux_add_adapter);
 
-void i2c_del_mux_adapter(struct i2c_adapter *adap)
+void i2c_mux_del_adapters(struct i2c_mux_core *muxc)
 {
-	struct i2c_mux_priv *priv = adap->algo_data;
 	char symlink_name[20];
 
-	snprintf(symlink_name, sizeof(symlink_name), "channel-%u", priv->chan_id);
-	sysfs_remove_link(&priv->mux_dev->kobj, symlink_name);
+	while (muxc->num_adapters) {
+		struct i2c_adapter *adap = muxc->adapter[--muxc->num_adapters];
+		struct i2c_mux_priv *priv = adap->algo_data;
+
+		muxc->adapter[muxc->num_adapters] = NULL;
+
+		snprintf(symlink_name, sizeof(symlink_name),
+			 "channel-%u", priv->chan_id);
+		sysfs_remove_link(&muxc->dev->kobj, symlink_name);
+
+		sysfs_remove_link(&priv->adap.dev.kobj, "mux_device");
+		i2c_del_adapter(adap);
+		kfree(priv);
+	}
+}
+EXPORT_SYMBOL_GPL(i2c_mux_del_adapters);
+
+void i2c_del_mux_adapter(struct i2c_adapter *adap)
+{
+	struct i2c_mux_priv *priv = adap->algo_data;
+	struct i2c_mux_core *muxc = priv->muxc;
 
-	sysfs_remove_link(&priv->adap.dev.kobj, "mux_device");
-	i2c_del_adapter(adap);
-	kfree(priv);
+	i2c_mux_del_adapters(muxc);
+	devm_kfree(muxc->dev, muxc);
 }
 EXPORT_SYMBOL_GPL(i2c_del_mux_adapter);
 
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index b5f9a007a3ab..71ac1b3f4f68 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -27,6 +27,31 @@
 
 #ifdef __KERNEL__
 
+struct i2c_mux_core {
+	struct i2c_adapter *parent;
+	struct device *dev;
+
+	void *priv;
+
+	int (*select)(struct i2c_mux_core *, u32 chan_id);
+	int (*deselect)(struct i2c_mux_core *, u32 chan_id);
+
+	int num_adapters;
+	int max_adapters;
+	struct i2c_adapter *adapter[0];
+};
+
+struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
+				   struct device *dev, int max_adapters,
+				   int sizeof_priv, u32 flags,
+				   int (*select)(struct i2c_mux_core *, u32),
+				   int (*deselect)(struct i2c_mux_core *, u32));
+
+static inline void *i2c_mux_priv(struct i2c_mux_core *muxc)
+{
+	return muxc->priv;
+}
+
 /*
  * Called to create a i2c bus on a multiplexed bus segment.
  * The mux_dev and chan_id parameters are passed to the select
@@ -41,8 +66,17 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 					       void *mux_dev, u32 chan_id),
 				int (*deselect) (struct i2c_adapter *,
 						 void *mux_dev, u32 chan_id));
+/*
+ * Called to create an i2c bus on a multiplexed bus segment.
+ * The chan_id parameter is passed to the select and deselect
+ * callback functions to perform hardware-specific mux control.
+ */
+int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
+			u32 force_nr, u32 chan_id,
+			unsigned int class);
 
 void i2c_del_mux_adapter(struct i2c_adapter *adap);
+void i2c_mux_del_adapters(struct i2c_mux_core *muxc);
 
 #endif /* __KERNEL__ */
 
-- 
2.1.4

