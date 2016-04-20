Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0125.outbound.protection.outlook.com ([157.55.234.125]:54592
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082AbcDTPfB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:01 -0400
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
Subject: [PATCH v7 10/24] [media] rtl2830: convert to use an explicit i2c mux core
Date: Wed, 20 Apr 2016 17:17:50 +0200
Message-ID: <1461165484-2314-11-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select op to be in terms of the i2c mux core instead
of the child adapter.

Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/rtl2830.c      | 20 ++++++++++++--------
 drivers/media/dvb-frontends/rtl2830_priv.h |  2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 3f96429af0e5..d25d1e0cd4ca 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -677,9 +677,9 @@ err:
  * adapter lock is already taken by tuner driver.
  * Gate is closed automatically after single I2C transfer.
  */
-static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
+static int rtl2830_select(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct i2c_client *client = mux_priv;
+	struct i2c_client *client = i2c_mux_priv(muxc);
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
@@ -712,7 +712,7 @@ static struct i2c_adapter *rtl2830_get_i2c_adapter(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	return dev->adapter;
+	return dev->muxc->adapter[0];
 }
 
 /*
@@ -865,12 +865,16 @@ static int rtl2830_probe(struct i2c_client *client,
 		goto err_regmap_exit;
 
 	/* create muxed i2c adapter for tuner */
-	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
-			client, 0, 0, 0, rtl2830_select, NULL);
-	if (dev->adapter == NULL) {
-		ret = -ENODEV;
+	dev->muxc = i2c_mux_alloc(client->adapter, &client->dev, 1, 0, 0,
+				  rtl2830_select, NULL);
+	if (!dev->muxc) {
+		ret = -ENOMEM;
 		goto err_regmap_exit;
 	}
+	dev->muxc->priv = client;
+	ret = i2c_mux_add_adapter(dev->muxc, 0, 0, 0);
+	if (ret)
+		goto err_regmap_exit;
 
 	/* create dvb frontend */
 	memcpy(&dev->fe.ops, &rtl2830_ops, sizeof(dev->fe.ops));
@@ -903,7 +907,7 @@ static int rtl2830_remove(struct i2c_client *client)
 	/* stop statistics polling */
 	cancel_delayed_work_sync(&dev->stat_work);
 
-	i2c_del_mux_adapter(dev->adapter);
+	i2c_mux_del_adapters(dev->muxc);
 	regmap_exit(dev->regmap);
 	kfree(dev);
 
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index cf793f39a09b..da4909543da2 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -29,7 +29,7 @@ struct rtl2830_dev {
 	struct rtl2830_platform_data *pdata;
 	struct i2c_client *client;
 	struct regmap *regmap;
-	struct i2c_adapter *adapter;
+	struct i2c_mux_core *muxc;
 	struct dvb_frontend fe;
 	bool sleeping;
 	unsigned long filters;
-- 
2.1.4

