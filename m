Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:42207 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbcDCI4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 04:56:32 -0400
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v6 15/24] i2c-mux: drop old unused i2c-mux api
Date: Sun,  3 Apr 2016 10:52:45 +0200
Message-Id: <1459673574-11440-16-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

All i2c mux users are using an explicit i2c mux core, drop support
for implicit i2c mux cores.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-mux.c   | 59 -------------------------------------------------
 include/linux/i2c-mux.h | 15 -------------
 2 files changed, 74 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index d95eb66e11bf..08d99e776a69 100644
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
@@ -290,48 +284,6 @@ struct i2c_mux_core *i2c_mux_one_adapter(struct i2c_adapter *parent,
 }
 EXPORT_SYMBOL_GPL(i2c_mux_one_adapter);
 
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
-					struct device *mux_dev, void *mux_priv,
-					u32 force_nr, u32 chan_id,
-					unsigned int class,
-					int (*select)(struct i2c_adapter *,
-						      void *, u32),
-					int (*deselect)(struct i2c_adapter *,
-							void *, u32))
-{
-	struct i2c_mux_core *muxc;
-	struct i2c_mux_priv_old *priv;
-
-	muxc = i2c_mux_one_adapter(parent, mux_dev, sizeof(*priv), 0,
-				   force_nr, chan_id, class,
-				   i2c_mux_select,
-				   deselect ? i2c_mux_deselect : NULL);
-	if (IS_ERR(muxc))
-		return NULL;
-
-	priv = i2c_mux_priv(muxc);
-	priv->select = select;
-	priv->deselect = deselect;
-	priv->mux_priv = mux_priv;
-
-	return muxc->adapter[0];
-}
-EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
-
 void i2c_mux_del_adapters(struct i2c_mux_core *muxc)
 {
 	char symlink_name[20];
@@ -353,17 +305,6 @@ void i2c_mux_del_adapters(struct i2c_mux_core *muxc)
 }
 EXPORT_SYMBOL_GPL(i2c_mux_del_adapters);
 
-void i2c_del_mux_adapter(struct i2c_adapter *adap)
-{
-	struct i2c_mux_priv *priv = adap->algo_data;
-	struct i2c_mux_core *muxc = priv->muxc;
-
-	i2c_mux_del_adapters(muxc);
-	devm_kfree(muxc->dev, muxc->adapter);
-	devm_kfree(muxc->dev, muxc);
-}
-EXPORT_SYMBOL_GPL(i2c_del_mux_adapter);
-
 MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
 MODULE_DESCRIPTION("I2C driver for multiplexed I2C busses");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index 0d97d7a3f03c..25c88ccf9c38 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -55,20 +55,6 @@ int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters);
 
 /*
  * Called to create a i2c bus on a multiplexed bus segment.
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
- * Called to create a i2c bus on a multiplexed bus segment.
  * The chan_id parameter is passed to the select and deselect
  * callback functions to perform hardware-specific mux control.
  */
@@ -88,7 +74,6 @@ struct i2c_mux_core *i2c_mux_one_adapter(struct i2c_adapter *parent,
 					 int (*deselect)(struct i2c_mux_core *,
 							 u32));
 
-void i2c_del_mux_adapter(struct i2c_adapter *adap);
 void i2c_mux_del_adapters(struct i2c_mux_core *muxc);
 
 #endif /* __KERNEL__ */
-- 
2.1.4

