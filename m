Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:57819 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550AbcCCW3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 17:29:31 -0500
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
Subject: [PATCH v4 10/18] [media] rtl2830: convert to use an explicit i2c mux core
Date: Thu,  3 Mar 2016 23:27:22 +0100
Message-Id: <1457044050-15230-11-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select op to be in terms of the i2c mux core instead
of the child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/rtl2830.c      | 17 +++++++++--------
 drivers/media/dvb-frontends/rtl2830_priv.h |  2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index b792f305cf15..0fa60fe09b81 100644
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
@@ -865,12 +865,13 @@ static int rtl2830_probe(struct i2c_client *client,
 		goto err_regmap_exit;
 
 	/* create muxed i2c adapter for tuner */
-	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
-			client, 0, 0, 0, rtl2830_select, NULL);
-	if (dev->adapter == NULL) {
-		ret = -ENODEV;
+	dev->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0, 0,
+					0, 0, 0, rtl2830_select, NULL);
+	if (IS_ERR(dev->muxc)) {
+		ret = PTR_ERR(dev->muxc);
 		goto err_regmap_exit;
 	}
+	dev->muxc->priv = client;
 
 	/* create dvb frontend */
 	memcpy(&dev->fe.ops, &rtl2830_ops, sizeof(dev->fe.ops));
@@ -900,7 +901,7 @@ static int rtl2830_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
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

