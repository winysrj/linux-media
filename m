Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8916C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 23:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AFAE21773
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 23:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="eKzwW7eI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfAHXI2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 18:08:28 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:56336 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728112AbfAHXI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 18:08:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=References:In-Reply-To:Message-Id:Date:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SSXpGBvGr92bvnjl6XsytnZAIXJo1Id/u0bu79tzMm8=; b=eKzwW7eIASl2WbNidLJWY8E88
        r+DQQ5dzARcn8VFsdRKxPMXC0d0/FlWqLroYCPpIyIIumpyvxbxbX5ztc6C9KeZA9FUZTiwmXPBag
        Jf9Syt8TfNsZIPPvmeXfOZPsUldj6hta+bQjEFL5agAyfCA343d9qEvq46rOhtpyWTLIw=;
Received: from [78.134.43.6] (port=50994 helo=melee.fritz.box)
        by hostingweb31.netsons.net with esmtpa (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1gh02Y-00FWab-Un; Tue, 08 Jan 2019 23:40:07 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
To:     linux-media@vger.kernel.org
Cc:     Luca Ceresoli <luca.ceresoli@aim-sportline.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Rosin <peda@axentia.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Luca Ceresoli <luca@lucaceresoli.net>
Subject: [RFC 2/4] i2c: mux: notify client attach/detach, add ATR
Date:   Tue,  8 Jan 2019 23:39:51 +0100
Message-Id: <20190108223953.9969-3-luca@lucaceresoli.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190108223953.9969-1-luca@lucaceresoli.net>
References: <20190108223953.9969-1-luca@lucaceresoli.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Luca Ceresoli <luca.ceresoli@aim-sportline.com>

**** Note! This patch is not 100% complete - see NOTES/TODO below ****

Add the "address translator" feature (ATR for short) to i2c-mux.

An ATR is a device that looks similar to an i2c-mux: it has an I2C
slave "upstream" port and N master "downstream" ports, and forwards
transactions from upstream to the appropriate downstream port. But is
is different in that the forwarded transaction has a different slave
address. The address used on the upstream bus is called the "alias"
and is (potentially) different from the physical slave address of the
downstream chip.

The ATR maintains a translation table mapping each i2c_client to its
alias. The table is looked up at every transaction to modify the
messages on the fly. After the transaction completes, the old
addresses are written back into the messages: this is needed because
chip drivers can reuse the same messages without reinitializing them.

Choosing the aliases is not done here, but by the user device driver.

Note that the ATR hardware can be a part of a more complex chip, such
as the TI DS90UB9xx video serializer/deserializer chips which also
allow access to remote I2C chips.

A typical example follows.

Topology:
                      Slave X @ 0x10
              .-----.   |
  .-----.     |     |---+---- B
  | CPU |--A--| ATR |
  `-----'     |     |---+---- C
              `-----'   |
                      Slave Y @ 0x10

Table:

  Client  Alias
  -------------
     X    0x20
     Y    0x30

Transaction:

 - Slave X driver sends a transaction (on adapter B), slave address 0x10
 - ATR driver rewrites messages with address 0x20, forwards to adapter A
 - Physical I2C transaction on bus A, slave address 0x20
 - ATR chip propagates transaction on bus B with address translated to 0x10
 - Slave X chip replies on bus B
 - ATR chip forwards reply on bus A
 - ATR driver rewrites messages with address 0x10
 - Slave X driver gets back the msgs[], with reply and address 0x10

Usage:

 1. When instantiating the mux core, pass your attadh/detach callbacks
    to i2c_mux_alloc()
 2. When the attach callback is called pick an appropriate alias,
    configure it in your chip and return the chosen alias in the
    alias_id parameter
 3. When the detach callback is called, deconfigure the alias from
    your chip and put is back in the pool for later usage

NOTES:
 * I added this feature to i2c-mux, but in the end I realized it is
   very invasive. Perhaps it's better to create a new i2c-atr.c file
   with only the ATR features and leave i2c-mux alone. However the
   bulk of the ATR implementation should not be much different.
 * This code has been tested only on a limited setup

TODO:
 * Add i2c_mux_del_adapters() variant to delete only one adapter:
   the DS90UB9xx driver expects to add and remove each downstream
   adapter independently, i2c-mux can only remove all adapters at
   once.
 * Implement remapping also in i2c_mux_smbus_xfer
   - Perhaps collapse the two master_xfer functions into one (and the
     same for the smbus_xfer functions) to avoid duplication of the
     remapping code
 * Maybe split in 2 commits: one to add attach_ops which is
   potentially useful on its own, another to add the actual ATR
 * Update all calls to i2c_mux_alloc (add NULL as last parameter), not
   only pca954x
 * Document devicetree binding, new callbacks and I2C_MUX_ATR

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/i2c/i2c-mux.c               | 218 +++++++++++++++++++++++++++-
 drivers/i2c/muxes/i2c-mux-pca954x.c |   2 +-
 include/linux/i2c-mux.h             |  20 ++-
 3 files changed, 233 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index f330690b4125..80c610cfe990 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -24,17 +24,131 @@
 #include <linux/i2c-mux.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/slab.h>
 
+/**
+ * Hold the alias that as been assigned to a client.
+ */
+struct i2c_mux_cli2alias_pair {
+	struct list_head node;
+	struct i2c_client *client;
+	u16 alias;
+};
+
 /* multiplexer per channel data */
 struct i2c_mux_priv {
 	struct i2c_adapter adap;
 	struct i2c_algorithm algo;
 	struct i2c_mux_core *muxc;
 	u32 chan_id;
+
+	/* ATR */
+	struct list_head alias_list;
+	struct mutex atr_lock; /* Locks orig_addrs during ATR operation */
+	u16 *orig_addrs;
+	unsigned orig_addrs_size;
 };
 
+static struct i2c_mux_cli2alias_pair *
+i2c_mux_find_mapping_by_client(struct list_head *list,
+			       struct i2c_client *client)
+{
+	struct i2c_mux_cli2alias_pair *c2a;
+
+	list_for_each_entry(c2a, list, node) {
+		if (c2a->client == client)
+			return c2a;
+	}
+
+	return NULL;
+}
+
+static struct i2c_mux_cli2alias_pair *
+i2c_mux_find_mapping_by_addr(struct list_head *list,
+			     u16 phys_addr)
+{
+	struct i2c_mux_cli2alias_pair *c2a;
+
+	list_for_each_entry(c2a, list, node) {
+		if (c2a->client->addr == phys_addr)
+			return c2a;
+	}
+
+	return NULL;
+}
+
+/**
+ * Replace all message addresses with their aliases, saving the
+ * original addresses.
+ *
+ * This function is internal for use in i2c_mux_master_xfer() and
+ * similar. It must be followed by i2c_mux_unmap_msgs() to restore the
+ * original addresses.
+ */
+static int i2c_mux_map_msgs(struct i2c_mux_priv *priv,
+			    struct i2c_msg msgs[], int num)
+
+{
+	struct i2c_mux_core *muxc = priv->muxc;
+	static struct i2c_mux_cli2alias_pair *c2a;
+	int i;
+
+	if (list_empty(&priv->alias_list))
+		return 0;
+
+	/* Ensure we have enough room to save the original addresses */
+	if (unlikely(priv->orig_addrs_size < num)) {
+		void *new_buf = kmalloc(num * sizeof(priv->orig_addrs[0]),
+					GFP_KERNEL);
+		if (new_buf == NULL) {
+			dev_err(muxc->dev,
+				"Cannot allocate %d orig_addrs array", num);
+			return -ENOMEM;
+		}
+
+		kfree(priv->orig_addrs);
+		priv->orig_addrs = new_buf;
+		priv->orig_addrs_size = num;
+	}
+
+	for (i = 0; i < num; i++) {
+		priv->orig_addrs[i] = msgs[i].addr;
+
+		c2a = i2c_mux_find_mapping_by_addr(&priv->alias_list,
+						   msgs[i].addr);
+		if (c2a) {
+			msgs[i].addr = c2a->alias;
+		} else {
+			dev_warn(muxc->dev, "client 0x%02x not mapped!\n",
+				 msgs[i].addr);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * Restore all message addres aliases with the original addresses.
+ *
+ * This function is internal for use in i2c_mux_master_xfer() and
+ * similar.
+ *
+ * @see i2c_mux_map_msgs()
+ */
+static void i2c_mux_unmap_msgs(struct i2c_mux_priv *priv,
+			       struct i2c_msg msgs[], int num)
+{
+	int i;
+
+	if (list_empty(&priv->alias_list))
+		return;
+
+	for (i = 0; i < num; i++)
+		msgs[i].addr = priv->orig_addrs[i];
+}
+
 static int __i2c_mux_master_xfer(struct i2c_adapter *adap,
 				 struct i2c_msg msgs[], int num)
 {
@@ -62,11 +176,31 @@ static int i2c_mux_master_xfer(struct i2c_adapter *adap,
 	struct i2c_adapter *parent = muxc->parent;
 	int ret;
 
-	/* Switch to the right mux port and perform the transfer. */
-
+	/* Switch to the right mux port */
 	ret = muxc->select(muxc, priv->chan_id);
-	if (ret >= 0)
-		ret = i2c_transfer(parent, msgs, num);
+	if (ret < 0)
+		goto out;
+
+	/* Translate addresses if ATR enabled */
+	if (muxc->atr) {
+		mutex_lock(&priv->atr_lock);
+		ret = i2c_mux_map_msgs(priv, msgs, num);
+		if (ret < 0) {
+			mutex_unlock(&priv->atr_lock);
+			goto out;
+		}
+	}
+
+	/* Perform the transfer */
+	ret = i2c_transfer(parent, msgs, num);
+
+	/* Restore addresses if ATR enabled */
+	if (muxc->atr) {
+		i2c_mux_unmap_msgs(priv, msgs, num);
+		mutex_unlock(&priv->atr_lock);
+	}
+
+out:
 	if (muxc->deselect)
 		muxc->deselect(muxc, priv->chan_id);
 
@@ -235,11 +369,73 @@ struct i2c_adapter *i2c_root_adapter(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(i2c_root_adapter);
 
+static int i2c_mux_attach_client(struct i2c_adapter *adapter,
+				 const struct i2c_board_info *info,
+				 struct i2c_client *client)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_mux_core *muxc = priv->muxc;
+	const struct i2c_mux_attach_operations *ops = muxc->attach_ops;
+	struct i2c_mux_cli2alias_pair *c2a;
+	u16 alias_id = 0;
+	int err = 0;
+
+	if (ops && ops->i2c_mux_attach_client)
+		err = ops->i2c_mux_attach_client(muxc, priv->chan_id,
+						 info, client, &alias_id);
+	if (err)
+		goto err_attach;
+
+	if (alias_id != 0) {
+		c2a = kzalloc(sizeof(struct i2c_mux_cli2alias_pair), GFP_KERNEL);
+		if (!c2a) {
+			err = -ENOMEM;
+			goto err_alloc;
+		}
+
+		c2a->client = client;
+		c2a->alias = alias_id;
+		list_add(&c2a->node, &priv->alias_list);
+	}
+
+	return 0;
+
+err_alloc:
+	if (ops && ops->i2c_mux_detach_client)
+		ops->i2c_mux_detach_client(muxc, priv->chan_id, client);
+err_attach:
+	return err;
+}
+
+static void i2c_mux_detach_client(struct i2c_adapter *adapter,
+				  struct i2c_client *client)
+{
+	struct i2c_mux_priv *priv = adapter->algo_data;
+	struct i2c_mux_core *muxc = priv->muxc;
+	const struct i2c_mux_attach_operations *ops = muxc->attach_ops;
+	struct i2c_mux_cli2alias_pair *c2a;
+
+	if (ops && ops->i2c_mux_detach_client)
+		ops->i2c_mux_detach_client(muxc, priv->chan_id, client);
+
+	c2a = i2c_mux_find_mapping_by_client(&priv->alias_list, client);
+	if (c2a != NULL) {
+		list_del(&c2a->node);
+		kfree(c2a);
+	}
+}
+
+static const struct i2c_attach_operations i2c_mux_attach_operations = {
+	.attach_client = i2c_mux_attach_client,
+	.detach_client = i2c_mux_detach_client,
+};
+
 struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 				   struct device *dev, int max_adapters,
 				   int sizeof_priv, u32 flags,
 				   int (*select)(struct i2c_mux_core *, u32),
-				   int (*deselect)(struct i2c_mux_core *, u32))
+				   int (*deselect)(struct i2c_mux_core *, u32),
+				   const struct i2c_mux_attach_operations *attach_ops)
 {
 	struct i2c_mux_core *muxc;
 
@@ -259,8 +455,11 @@ struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 		muxc->arbitrator = true;
 	if (flags & I2C_MUX_GATE)
 		muxc->gate = true;
+	if (flags & I2C_MUX_ATR)
+		muxc->atr = true;
 	muxc->select = select;
 	muxc->deselect = deselect;
+	muxc->attach_ops = attach_ops;
 	muxc->max_adapters = max_adapters;
 
 	return muxc;
@@ -300,6 +499,8 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	/* Set up private adapter data */
 	priv->muxc = muxc;
 	priv->chan_id = chan_id;
+	INIT_LIST_HEAD(&priv->alias_list);
+	mutex_init(&priv->atr_lock);
 
 	/* Need to do algo dynamically because we don't know ahead
 	 * of time what sort of physical adapter we'll be dealing with.
@@ -328,6 +529,11 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	priv->adap.retries = parent->retries;
 	priv->adap.timeout = parent->timeout;
 	priv->adap.quirks = parent->quirks;
+
+	if (muxc->attach_ops) {
+		priv->adap.attach_ops = &i2c_mux_attach_operations;
+	}
+
 	if (muxc->mux_locked)
 		priv->adap.lock_ops = &i2c_mux_lock_ops;
 	else
@@ -426,6 +632,7 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	return 0;
 
 err_free_priv:
+	mutex_destroy(&priv->atr_lock);
 	kfree(priv);
 	return ret;
 }
@@ -449,6 +656,7 @@ void i2c_mux_del_adapters(struct i2c_mux_core *muxc)
 		sysfs_remove_link(&priv->adap.dev.kobj, "mux_device");
 		i2c_del_adapter(adap);
 		of_node_put(np);
+		mutex_destroy(&priv->atr_lock);
 		kfree(priv);
 	}
 }
diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index bfabf985e830..a777e765ce86 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -362,7 +362,7 @@ static int pca954x_probe(struct i2c_client *client,
 		return -ENODEV;
 
 	muxc = i2c_mux_alloc(adap, dev, PCA954X_MAX_NCHANS, sizeof(*data), 0,
-			     pca954x_select_chan, pca954x_deselect_mux);
+			     pca954x_select_chan, pca954x_deselect_mux, NULL);
 	if (!muxc)
 		return -ENOMEM;
 	data = i2c_mux_priv(muxc);
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index bd74d5706f3b..493eab3e8dbc 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -28,6 +28,20 @@
 #ifdef __KERNEL__
 
 #include <linux/bitops.h>
+#include <linux/i2c.h>
+
+struct i2c_mux_core;
+
+struct i2c_mux_attach_operations {
+	int  (*i2c_mux_attach_client)(struct i2c_mux_core *muxc,
+				      u32 chan_id,
+				      const struct i2c_board_info *info,
+				      struct i2c_client *client,
+				      u16 *alias_id);
+	void (*i2c_mux_detach_client)(struct i2c_mux_core *muxc,
+				      u32 chan_id,
+				      struct i2c_client *client);
+};
 
 struct i2c_mux_core {
 	struct i2c_adapter *parent;
@@ -35,11 +49,13 @@ struct i2c_mux_core {
 	unsigned int mux_locked:1;
 	unsigned int arbitrator:1;
 	unsigned int gate:1;
+	unsigned int atr:1;
 
 	void *priv;
 
 	int (*select)(struct i2c_mux_core *, u32 chan_id);
 	int (*deselect)(struct i2c_mux_core *, u32 chan_id);
+	const struct i2c_mux_attach_operations *attach_ops;
 
 	int num_adapters;
 	int max_adapters;
@@ -50,12 +66,14 @@ struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 				   struct device *dev, int max_adapters,
 				   int sizeof_priv, u32 flags,
 				   int (*select)(struct i2c_mux_core *, u32),
-				   int (*deselect)(struct i2c_mux_core *, u32));
+				   int (*deselect)(struct i2c_mux_core *, u32),
+				   const struct i2c_mux_attach_operations *attach_ops);
 
 /* flags for i2c_mux_alloc */
 #define I2C_MUX_LOCKED     BIT(0)
 #define I2C_MUX_ARBITRATOR BIT(1)
 #define I2C_MUX_GATE       BIT(2)
+#define I2C_MUX_ATR        BIT(3) /* Address translator */
 
 static inline void *i2c_mux_priv(struct i2c_mux_core *muxc)
 {
-- 
2.17.1

