Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:49400 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbcDCIzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 04:55:19 -0400
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
Subject: [PATCH v6 09/24] [media] m88ds3103: convert to use an explicit i2c mux core
Date: Sun,  3 Apr 2016 10:52:39 +0200
Message-Id: <1459673574-11440-10-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select op to be in terms of the i2c mux core instead
of the child adapter.

Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 18 +++++++++---------
 drivers/media/dvb-frontends/m88ds3103_priv.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 76883600ec6f..bf5ffcda7797 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1251,9 +1251,9 @@ static void m88ds3103_release(struct dvb_frontend *fe)
 	i2c_unregister_device(client);
 }
 
-static int m88ds3103_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+static int m88ds3103_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct m88ds3103_dev *dev = mux_priv;
+	struct m88ds3103_dev *dev = i2c_mux_priv(muxc);
 	struct i2c_client *client = dev->client;
 	int ret;
 	struct i2c_msg msg = {
@@ -1374,7 +1374,7 @@ static struct i2c_adapter *m88ds3103_get_i2c_adapter(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	return dev->i2c_adapter;
+	return dev->muxc->adapter[0];
 }
 
 static int m88ds3103_probe(struct i2c_client *client,
@@ -1467,13 +1467,13 @@ static int m88ds3103_probe(struct i2c_client *client,
 		goto err_kfree;
 
 	/* create mux i2c adapter for tuner */
-	dev->i2c_adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
-					       dev, 0, 0, 0, m88ds3103_select,
-					       NULL);
-	if (dev->i2c_adapter == NULL) {
-		ret = -ENOMEM;
+	dev->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0, 0,
+					0, 0, 0, m88ds3103_select, NULL);
+	if (IS_ERR(dev->muxc)) {
+		ret = PTR_ERR(dev->muxc);
 		goto err_kfree;
 	}
+	dev->muxc->priv = dev;
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
@@ -1502,7 +1502,7 @@ static int m88ds3103_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	i2c_del_mux_adapter(dev->i2c_adapter);
+	i2c_mux_del_adapters(dev->muxc);
 
 	kfree(dev);
 	return 0;
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index eee8c22c51ec..c5b4e177c6ea 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -42,7 +42,7 @@ struct m88ds3103_dev {
 	enum fe_status fe_status;
 	u32 dvbv3_ber; /* for old DVBv3 API read_ber */
 	bool warm; /* FW running */
-	struct i2c_adapter *i2c_adapter;
+	struct i2c_mux_core *muxc;
 	/* auto detect chip id to do different config */
 	u8 chip_id;
 	/* main mclk is calculated for M88RS6000 dynamically */
-- 
2.1.4

