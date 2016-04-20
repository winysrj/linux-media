Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0146.outbound.protection.outlook.com ([157.55.234.146]:54816
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751899AbcDTPfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:16 -0400
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
Subject: [PATCH v7 12/24] [media] si2168: convert to use an explicit i2c mux core
Date: Wed, 20 Apr 2016 17:17:52 +0200
Message-ID: <1461165484-2314-13-git-send-email-peda@axentia.se>
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
 drivers/media/dvb-frontends/si2168.c      | 25 +++++++++++++++----------
 drivers/media/dvb-frontends/si2168_priv.h |  2 +-
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 821a8f481507..5583827c386e 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -615,9 +615,9 @@ static int si2168_get_tune_settings(struct dvb_frontend *fe,
  * We must use unlocked I2C I/O because I2C adapter lock is already taken
  * by the caller (usually tuner driver).
  */
-static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+static int si2168_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct i2c_client *client = mux_priv;
+	struct i2c_client *client = i2c_mux_priv(muxc);
 	int ret;
 	struct si2168_cmd cmd;
 
@@ -635,9 +635,9 @@ err:
 	return ret;
 }
 
-static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+static int si2168_deselect(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct i2c_client *client = mux_priv;
+	struct i2c_client *client = i2c_mux_priv(muxc);
 	int ret;
 	struct si2168_cmd cmd;
 
@@ -709,17 +709,22 @@ static int si2168_probe(struct i2c_client *client,
 	}
 
 	/* create mux i2c adapter for tuner */
-	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
-			client, 0, 0, 0, si2168_select, si2168_deselect);
-	if (dev->adapter == NULL) {
-		ret = -ENODEV;
+	dev->muxc = i2c_mux_alloc(client->adapter, &client->dev,
+				  1, 0, 0,
+				  si2168_select, si2168_deselect);
+	if (!dev->muxc) {
+		ret = -ENOMEM;
 		goto err_kfree;
 	}
+	dev->muxc->priv = client;
+	ret = i2c_mux_add_adapter(dev->muxc, 0, 0, 0);
+	if (ret)
+		goto err_kfree;
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
 	dev->fe.demodulator_priv = client;
-	*config->i2c_adapter = dev->adapter;
+	*config->i2c_adapter = dev->muxc->adapter[0];
 	*config->fe = &dev->fe;
 	dev->ts_mode = config->ts_mode;
 	dev->ts_clock_inv = config->ts_clock_inv;
@@ -743,7 +748,7 @@ static int si2168_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	i2c_del_mux_adapter(dev->adapter);
+	i2c_mux_del_adapters(dev->muxc);
 
 	dev->fe.ops.release = NULL;
 	dev->fe.demodulator_priv = NULL;
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index c07e6fe2cb10..165bf1412063 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -29,7 +29,7 @@
 
 /* state struct */
 struct si2168_dev {
-	struct i2c_adapter *adapter;
+	struct i2c_mux_core *muxc;
 	struct dvb_frontend fe;
 	enum fe_delivery_system delivery_system;
 	enum fe_status fe_status;
-- 
2.1.4

