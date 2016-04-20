Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0126.outbound.protection.outlook.com ([157.55.234.126]:55378
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751811AbcDTPfZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:25 -0400
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
Subject: [PATCH v7 14/24] of/unittest: convert to use an explicit i2c mux core
Date: Wed, 20 Apr 2016 17:17:54 +0200
Message-ID: <1461165484-2314-15-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select op to be in terms of the i2c mux core instead
of the child adapter.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/of/unittest.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index e986e6ee52e0..c1ebbfb79453 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1692,13 +1692,7 @@ static struct i2c_driver unittest_i2c_dev_driver = {
 
 #if IS_BUILTIN(CONFIG_I2C_MUX)
 
-struct unittest_i2c_mux_data {
-	int nchans;
-	struct i2c_adapter *adap[];
-};
-
-static int unittest_i2c_mux_select_chan(struct i2c_adapter *adap,
-			       void *client, u32 chan)
+static int unittest_i2c_mux_select_chan(struct i2c_mux_core *muxc, u32 chan)
 {
 	return 0;
 }
@@ -1706,11 +1700,11 @@ static int unittest_i2c_mux_select_chan(struct i2c_adapter *adap,
 static int unittest_i2c_mux_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
-	int ret, i, nchans, size;
+	int ret, i, nchans;
 	struct device *dev = &client->dev;
 	struct i2c_adapter *adap = to_i2c_adapter(dev->parent);
 	struct device_node *np = client->dev.of_node, *child;
-	struct unittest_i2c_mux_data *stm;
+	struct i2c_mux_core *muxc;
 	u32 reg, max_reg;
 
 	dev_dbg(dev, "%s for node @%s\n", __func__, np->full_name);
@@ -1734,25 +1728,20 @@ static int unittest_i2c_mux_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	size = offsetof(struct unittest_i2c_mux_data, adap[nchans]);
-	stm = devm_kzalloc(dev, size, GFP_KERNEL);
-	if (!stm) {
-		dev_err(dev, "Out of memory\n");
+	muxc = i2c_mux_alloc(adap, dev, nchans, 0, 0,
+			     unittest_i2c_mux_select_chan, NULL);
+	if (!muxc)
 		return -ENOMEM;
-	}
-	stm->nchans = nchans;
 	for (i = 0; i < nchans; i++) {
-		stm->adap[i] = i2c_add_mux_adapter(adap, dev, client,
-				0, i, 0, unittest_i2c_mux_select_chan, NULL);
-		if (!stm->adap[i]) {
+		ret = i2c_mux_add_adapter(muxc, 0, i, 0);
+		if (ret) {
 			dev_err(dev, "Failed to register mux #%d\n", i);
-			for (i--; i >= 0; i--)
-				i2c_del_mux_adapter(stm->adap[i]);
+			i2c_mux_del_adapters(muxc);
 			return -ENODEV;
 		}
 	}
 
-	i2c_set_clientdata(client, stm);
+	i2c_set_clientdata(client, muxc);
 
 	return 0;
 };
@@ -1761,12 +1750,10 @@ static int unittest_i2c_mux_remove(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct device_node *np = client->dev.of_node;
-	struct unittest_i2c_mux_data *stm = i2c_get_clientdata(client);
-	int i;
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
 
 	dev_dbg(dev, "%s for node @%s\n", __func__, np->full_name);
-	for (i = stm->nchans - 1; i >= 0; i--)
-		i2c_del_mux_adapter(stm->adap[i]);
+	i2c_mux_del_adapters(muxc);
 	return 0;
 }
 
-- 
2.1.4

