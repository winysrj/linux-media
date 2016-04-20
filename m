Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0108.outbound.protection.outlook.com ([157.55.234.108]:57216
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751277AbcDTPfa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:30 -0400
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
Subject: [PATCH v7 06/24] i2c: i2c-mux-pca954x: convert to use an explicit i2c mux core
Date: Wed, 20 Apr 2016 17:17:46 +0200
Message-ID: <1461165484-2314-7-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Add a mask to handle the case where not all child adapters should
cause a mux deselect to happen, now that there is a common deselect op
for all child adapters.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-pca954x.c | 61 ++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index acfcef3d4068..528e755c468f 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -60,9 +60,10 @@ enum pca_type {
 
 struct pca954x {
 	enum pca_type type;
-	struct i2c_adapter *virt_adaps[PCA954X_MAX_NCHANS];
 
 	u8 last_chan;		/* last register value */
+	u8 deselect;
+	struct i2c_client *client;
 };
 
 struct chip_desc {
@@ -146,10 +147,10 @@ static int pca954x_reg_write(struct i2c_adapter *adap,
 	return ret;
 }
 
-static int pca954x_select_chan(struct i2c_adapter *adap,
-			       void *client, u32 chan)
+static int pca954x_select_chan(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct pca954x *data = i2c_get_clientdata(client);
+	struct pca954x *data = i2c_mux_priv(muxc);
+	struct i2c_client *client = data->client;
 	const struct chip_desc *chip = &chips[data->type];
 	u8 regval;
 	int ret = 0;
@@ -162,21 +163,24 @@ static int pca954x_select_chan(struct i2c_adapter *adap,
 
 	/* Only select the channel if its different from the last channel */
 	if (data->last_chan != regval) {
-		ret = pca954x_reg_write(adap, client, regval);
+		ret = pca954x_reg_write(muxc->parent, client, regval);
 		data->last_chan = regval;
 	}
 
 	return ret;
 }
 
-static int pca954x_deselect_mux(struct i2c_adapter *adap,
-				void *client, u32 chan)
+static int pca954x_deselect_mux(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct pca954x *data = i2c_get_clientdata(client);
+	struct pca954x *data = i2c_mux_priv(muxc);
+	struct i2c_client *client = data->client;
+
+	if (!(data->deselect & (1 << chan)))
+		return 0;
 
 	/* Deselect active channel */
 	data->last_chan = 0;
-	return pca954x_reg_write(adap, client, data->last_chan);
+	return pca954x_reg_write(muxc->parent, client, data->last_chan);
 }
 
 /*
@@ -191,17 +195,22 @@ static int pca954x_probe(struct i2c_client *client,
 	bool idle_disconnect_dt;
 	struct gpio_desc *gpio;
 	int num, force, class;
+	struct i2c_mux_core *muxc;
 	struct pca954x *data;
 	int ret;
 
 	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE))
 		return -ENODEV;
 
-	data = devm_kzalloc(&client->dev, sizeof(struct pca954x), GFP_KERNEL);
-	if (!data)
+	muxc = i2c_mux_alloc(adap, &client->dev,
+			     PCA954X_MAX_NCHANS, sizeof(*data), 0,
+			     pca954x_select_chan, pca954x_deselect_mux);
+	if (!muxc)
 		return -ENOMEM;
+	data = i2c_mux_priv(muxc);
 
-	i2c_set_clientdata(client, data);
+	i2c_set_clientdata(client, muxc);
+	data->client = client;
 
 	/* Get the mux out of reset if a reset GPIO is specified. */
 	gpio = devm_gpiod_get_optional(&client->dev, "reset", GPIOD_OUT_LOW);
@@ -238,16 +247,13 @@ static int pca954x_probe(struct i2c_client *client,
 				/* discard unconfigured channels */
 				break;
 			idle_disconnect_pd = pdata->modes[num].deselect_on_exit;
+			data->deselect |= (idle_disconnect_pd
+					   || idle_disconnect_dt) << num;
 		}
 
-		data->virt_adaps[num] =
-			i2c_add_mux_adapter(adap, &client->dev, client,
-				force, num, class, pca954x_select_chan,
-				(idle_disconnect_pd || idle_disconnect_dt)
-					? pca954x_deselect_mux : NULL);
+		ret = i2c_mux_add_adapter(muxc, force, num, class);
 
-		if (data->virt_adaps[num] == NULL) {
-			ret = -ENODEV;
+		if (ret) {
 			dev_err(&client->dev,
 				"failed to register multiplexed adapter"
 				" %d as bus %d\n", num, force);
@@ -263,23 +269,15 @@ static int pca954x_probe(struct i2c_client *client,
 	return 0;
 
 virt_reg_failed:
-	for (num--; num >= 0; num--)
-		i2c_del_mux_adapter(data->virt_adaps[num]);
+	i2c_mux_del_adapters(muxc);
 	return ret;
 }
 
 static int pca954x_remove(struct i2c_client *client)
 {
-	struct pca954x *data = i2c_get_clientdata(client);
-	const struct chip_desc *chip = &chips[data->type];
-	int i;
-
-	for (i = 0; i < chip->nchans; ++i)
-		if (data->virt_adaps[i]) {
-			i2c_del_mux_adapter(data->virt_adaps[i]);
-			data->virt_adaps[i] = NULL;
-		}
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
 
+	i2c_mux_del_adapters(muxc);
 	return 0;
 }
 
@@ -287,7 +285,8 @@ static int pca954x_remove(struct i2c_client *client)
 static int pca954x_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	struct pca954x *data = i2c_get_clientdata(client);
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
+	struct pca954x *data = i2c_mux_priv(muxc);
 
 	data->last_chan = 0;
 	return i2c_smbus_write_byte(client, 0);
-- 
2.1.4

