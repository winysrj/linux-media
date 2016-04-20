Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0108.outbound.protection.outlook.com ([157.55.234.108]:57216
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751811AbcDTPfc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:32 -0400
From: Peter Rosin <peda@axentia.se>
To: <linux-kernel@vger.kernel.org>
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	"Jonathan Corbet" <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	"Guenter Roeck" <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	"Hartmut Knaack" <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	"Peter Meerwald" <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	"Frank Rowand" <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Kalle Valo" <kvalo@codeaurora.org>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>,
	"Arnd Bergmann" <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	"Crestez Dan Leonard" <leonard.crestez@intel.com>,
	<linux-i2c@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<devicetree@vger.kernel.org>, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v7 15/24] i2c-mux: drop old unused i2c-mux api
Date: Wed, 20 Apr 2016 17:17:55 +0200
Message-ID: <1461165484-2314-16-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All i2c mux users are using an explicit i2c mux core, drop support
for implicit i2c mux cores.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-mux.c   | 63 -------------------------------------------------
 include/linux/i2c-mux.h | 15 ------------
 2 files changed, 78 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 5ce1b0704cb5..25e9336b0e6e 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -28,12 +28,6 @@
 #include <linux/slab.h>
 
 /* multiplexer per channel data */
-struct i2c_mux_priv_old {
-	void *mux_priv;
-	int (*select)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
-	int (*deselect)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
-};
-
 struct i2c_mux_priv {
 	struct i2c_adapter adap;
 	struct i2c_algorithm algo;
@@ -104,53 +98,6 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
 	return class;
 }
 
-static int i2c_mux_select(struct i2c_mux_core *muxc, u32 chan)
-{
-	struct i2c_mux_priv_old *priv = i2c_mux_priv(muxc);
-
-	return priv->select(muxc->parent, priv->mux_priv, chan);
-}
-
-static int i2c_mux_deselect(struct i2c_mux_core *muxc, u32 chan)
-{
-	struct i2c_mux_priv_old *priv = i2c_mux_priv(muxc);
-
-	return priv->deselect(muxc->parent, priv->mux_priv, chan);
-}
-
-struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
-				struct device *mux_dev,
-				void *mux_priv, u32 force_nr, u32 chan_id,
-				unsigned int class,
-				int (*select) (struct i2c_adapter *,
-					       void *, u32),
-				int (*deselect) (struct i2c_adapter *,
-						 void *, u32))
-{
-	struct i2c_mux_core *muxc;
-	struct i2c_mux_priv_old *priv;
-	int ret;
-
-	muxc = i2c_mux_alloc(parent, mux_dev, 1, sizeof(*priv), 0,
-			     i2c_mux_select, i2c_mux_deselect);
-	if (!muxc)
-		return NULL;
-
-	priv = i2c_mux_priv(muxc);
-	priv->select = select;
-	priv->deselect = deselect;
-	priv->mux_priv = mux_priv;
-
-	ret = i2c_mux_add_adapter(muxc, force_nr, chan_id, class);
-	if (ret) {
-		devm_kfree(mux_dev, muxc);
-		return NULL;
-	}
-
-	return muxc->adapter[0];
-}
-EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
-
 struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 				   struct device *dev, int max_adapters,
 				   int sizeof_priv, u32 flags,
@@ -305,16 +252,6 @@ void i2c_mux_del_adapters(struct i2c_mux_core *muxc)
 }
 EXPORT_SYMBOL_GPL(i2c_mux_del_adapters);
 
-void i2c_del_mux_adapter(struct i2c_adapter *adap)
-{
-	struct i2c_mux_priv *priv = adap->algo_data;
-	struct i2c_mux_core *muxc = priv->muxc;
-
-	i2c_mux_del_adapters(muxc);
-	devm_kfree(muxc->dev, muxc);
-}
-EXPORT_SYMBOL_GPL(i2c_del_mux_adapter);
-
 MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
 MODULE_DESCRIPTION("I2C driver for multiplexed I2C busses");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index 71ac1b3f4f68..2fa93fe1345e 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -53,20 +53,6 @@ static inline void *i2c_mux_priv(struct i2c_mux_core *muxc)
 }
 
 /*
- * Called to create a i2c bus on a multiplexed bus segment.
- * The mux_dev and chan_id parameters are passed to the select
- * and deselect callback functions to perform hardware-specific
- * mux control.
- */
-struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
-				struct device *mux_dev,
-				void *mux_priv, u32 force_nr, u32 chan_id,
-				unsigned int class,
-				int (*select) (struct i2c_adapter *,
-					       void *mux_dev, u32 chan_id),
-				int (*deselect) (struct i2c_adapter *,
-						 void *mux_dev, u32 chan_id));
-/*
  * Called to create an i2c bus on a multiplexed bus segment.
  * The chan_id parameter is passed to the select and deselect
  * callback functions to perform hardware-specific mux control.
@@ -75,7 +61,6 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 			u32 force_nr, u32 chan_id,
 			unsigned int class);
 
-void i2c_del_mux_adapter(struct i2c_adapter *adap);
 void i2c_mux_del_adapters(struct i2c_mux_core *muxc);
 
 #endif /* __KERNEL__ */
-- 
2.1.4

