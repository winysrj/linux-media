Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:55323 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534AbcCCW2u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 17:28:50 -0500
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
Subject: [PATCH v4 05/18] i2c: i2c-mux-pca9541: convert to use an explicit i2c mux core
Date: Thu,  3 Mar 2016 23:27:17 +0100
Message-Id: <1457044050-15230-6-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-pca9541.c | 55 ++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pca9541.c b/drivers/i2c/muxes/i2c-mux-pca9541.c
index d0ba424adebc..93bea073ed13 100644
--- a/drivers/i2c/muxes/i2c-mux-pca9541.c
+++ b/drivers/i2c/muxes/i2c-mux-pca9541.c
@@ -73,7 +73,7 @@
 #define SELECT_DELAY_LONG	1000
 
 struct pca9541 {
-	struct i2c_adapter *mux_adap;
+	struct i2c_client *client;
 	unsigned long select_timeout;
 	unsigned long arb_timeout;
 };
@@ -217,7 +217,8 @@ static const u8 pca9541_control[16] = {
  */
 static int pca9541_arbitrate(struct i2c_client *client)
 {
-	struct pca9541 *data = i2c_get_clientdata(client);
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
+	struct pca9541 *data = i2c_mux_priv(muxc);
 	int reg;
 
 	reg = pca9541_reg_read(client, PCA9541_CONTROL);
@@ -285,9 +286,10 @@ static int pca9541_arbitrate(struct i2c_client *client)
 	return 0;
 }
 
-static int pca9541_select_chan(struct i2c_adapter *adap, void *client, u32 chan)
+static int pca9541_select_chan(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct pca9541 *data = i2c_get_clientdata(client);
+	struct pca9541 *data = i2c_mux_priv(muxc);
+	struct i2c_client *client = data->client;
 	int ret;
 	unsigned long timeout = jiffies + ARB2_TIMEOUT;
 		/* give up after this time */
@@ -309,9 +311,11 @@ static int pca9541_select_chan(struct i2c_adapter *adap, void *client, u32 chan)
 	return -ETIMEDOUT;
 }
 
-static int pca9541_release_chan(struct i2c_adapter *adap,
-				void *client, u32 chan)
+static int pca9541_release_chan(struct i2c_mux_core *muxc, u32 chan)
 {
+	struct pca9541 *data = i2c_mux_priv(muxc);
+	struct i2c_client *client = data->client;
+
 	pca9541_release_bus(client);
 	return 0;
 }
@@ -324,20 +328,12 @@ static int pca9541_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adap = client->adapter;
 	struct pca954x_platform_data *pdata = dev_get_platdata(&client->dev);
+	struct i2c_mux_core *muxc;
 	struct pca9541 *data;
 	int force;
-	int ret = -ENODEV;
 
 	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE_DATA))
-		goto err;
-
-	data = kzalloc(sizeof(struct pca9541), GFP_KERNEL);
-	if (!data) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	i2c_set_clientdata(client, data);
+		return -ENODEV;
 
 	/*
 	 * I2C accesses are unprotected here.
@@ -352,34 +348,29 @@ static int pca9541_probe(struct i2c_client *client,
 	force = 0;
 	if (pdata)
 		force = pdata->modes[0].adap_id;
-	data->mux_adap = i2c_add_mux_adapter(adap, &client->dev, client,
-					     force, 0, 0,
-					     pca9541_select_chan,
-					     pca9541_release_chan);
-
-	if (data->mux_adap == NULL) {
+	muxc = i2c_mux_one_adapter(adap, &client->dev, sizeof(*data), 0,
+				   force, 0, 0,
+				   pca9541_select_chan, pca9541_release_chan);
+	if (IS_ERR(muxc)) {
 		dev_err(&client->dev, "failed to register master selector\n");
-		goto exit_free;
+		return PTR_ERR(muxc);
 	}
+	data = i2c_mux_priv(muxc);
+	data->client = client;
+
+	i2c_set_clientdata(client, muxc);
 
 	dev_info(&client->dev, "registered master selector for I2C %s\n",
 		 client->name);
 
 	return 0;
-
-exit_free:
-	kfree(data);
-err:
-	return ret;
 }
 
 static int pca9541_remove(struct i2c_client *client)
 {
-	struct pca9541 *data = i2c_get_clientdata(client);
-
-	i2c_del_mux_adapter(data->mux_adap);
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
 
-	kfree(data);
+	i2c_mux_del_adapters(muxc);
 	return 0;
 }
 
-- 
2.1.4

