Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0146.outbound.protection.outlook.com ([157.55.234.146]:54816
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082AbcDTPfS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:18 -0400
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
Subject: [PATCH v7 11/24] [media] rtl2832: convert to use an explicit i2c mux core
Date: Wed, 20 Apr 2016 17:17:51 +0200
Message-ID: <1461165484-2314-12-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/rtl2832.c      | 25 ++++++++++++++-----------
 drivers/media/dvb-frontends/rtl2832_priv.h |  2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 7c96f7679669..1b23788797b5 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -847,9 +847,9 @@ err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 }
 
-static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
+static int rtl2832_select(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct rtl2832_dev *dev = mux_priv;
+	struct rtl2832_dev *dev = i2c_mux_priv(muxc);
 	struct i2c_client *client = dev->client;
 	int ret;
 
@@ -870,10 +870,9 @@ err:
 	return ret;
 }
 
-static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv,
-			    u32 chan_id)
+static int rtl2832_deselect(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct rtl2832_dev *dev = mux_priv;
+	struct rtl2832_dev *dev = i2c_mux_priv(muxc);
 
 	schedule_delayed_work(&dev->i2c_gate_work, usecs_to_jiffies(100));
 	return 0;
@@ -1059,7 +1058,7 @@ static struct i2c_adapter *rtl2832_get_i2c_adapter(struct i2c_client *client)
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
-	return dev->i2c_adapter_tuner;
+	return dev->muxc->adapter[0];
 }
 
 static int rtl2832_slave_ts_ctrl(struct i2c_client *client, bool enable)
@@ -1242,12 +1241,16 @@ static int rtl2832_probe(struct i2c_client *client,
 		goto err_regmap_exit;
 
 	/* create muxed i2c adapter for demod tuner bus */
-	dev->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, dev,
-			0, 0, 0, rtl2832_select, rtl2832_deselect);
-	if (dev->i2c_adapter_tuner == NULL) {
-		ret = -ENODEV;
+	dev->muxc = i2c_mux_alloc(i2c, &i2c->dev, 1, 0, 0,
+				  rtl2832_select, rtl2832_deselect);
+	if (!dev->muxc) {
+		ret = -ENOMEM;
 		goto err_regmap_exit;
 	}
+	dev->muxc->priv = dev;
+	ret = i2c_mux_add_adapter(dev->muxc, 0, 0, 0);
+	if (ret)
+		goto err_regmap_exit;
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
@@ -1282,7 +1285,7 @@ static int rtl2832_remove(struct i2c_client *client)
 
 	cancel_delayed_work_sync(&dev->i2c_gate_work);
 
-	i2c_del_mux_adapter(dev->i2c_adapter_tuner);
+	i2c_mux_del_adapters(dev->muxc);
 
 	regmap_exit(dev->regmap);
 
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 6b875f462f8b..d8f97d14f6fd 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -36,7 +36,7 @@ struct rtl2832_dev {
 	struct mutex regmap_mutex;
 	struct regmap_config regmap_config;
 	struct regmap *regmap;
-	struct i2c_adapter *i2c_adapter_tuner;
+	struct i2c_mux_core *muxc;
 	struct dvb_frontend fe;
 	enum fe_status fe_status;
 	u64 post_bit_error_prev; /* for old DVBv3 read_ber() calculation */
-- 
2.1.4

