Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:37539 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbcDCI6L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 04:58:11 -0400
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
Subject: [PATCH v6 24/24] [media] rtl2832: regmap is aware of lockdep, drop local locking hack
Date: Sun,  3 Apr 2016 10:52:54 +0200
Message-Id: <1459673574-11440-25-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/rtl2832.c      | 30 ------------------------------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 -
 2 files changed, 31 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index ac5ac5f7a335..23459fed2516 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -890,32 +890,6 @@ static bool rtl2832_volatile_reg(struct device *dev, unsigned int reg)
 	return false;
 }
 
-/*
- * FIXME: Hack. Implement own regmap locking in order to silence lockdep
- * recursive lock warning. That happens when regmap I2C client calls I2C mux
- * adapter, which leads demod I2C repeater enable via demod regmap. Operation
- * takes two regmap locks recursively - but those are different regmap instances
- * in a two different I2C drivers, so it is not deadlock. Proper fix is to make
- * regmap aware of lockdep.
- */
-static void rtl2832_regmap_lock(void *__dev)
-{
-	struct rtl2832_dev *dev = __dev;
-	struct i2c_client *client = dev->client;
-
-	dev_dbg(&client->dev, "\n");
-	mutex_lock(&dev->regmap_mutex);
-}
-
-static void rtl2832_regmap_unlock(void *__dev)
-{
-	struct rtl2832_dev *dev = __dev;
-	struct i2c_client *client = dev->client;
-
-	dev_dbg(&client->dev, "\n");
-	mutex_unlock(&dev->regmap_mutex);
-}
-
 static struct dvb_frontend *rtl2832_get_dvb_frontend(struct i2c_client *client)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
@@ -1082,12 +1056,8 @@ static int rtl2832_probe(struct i2c_client *client,
 	dev->sleeping = true;
 	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
 	/* create regmap */
-	mutex_init(&dev->regmap_mutex);
 	dev->regmap_config.reg_bits =  8,
 	dev->regmap_config.val_bits =  8,
-	dev->regmap_config.lock = rtl2832_regmap_lock,
-	dev->regmap_config.unlock = rtl2832_regmap_unlock,
-	dev->regmap_config.lock_arg = dev,
 	dev->regmap_config.volatile_reg = rtl2832_volatile_reg,
 	dev->regmap_config.max_register = 5 * 0x100,
 	dev->regmap_config.ranges = regmap_range_cfg,
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index d8f97d14f6fd..c1a8a69e9015 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -33,7 +33,6 @@
 struct rtl2832_dev {
 	struct rtl2832_platform_data *pdata;
 	struct i2c_client *client;
-	struct mutex regmap_mutex;
 	struct regmap_config regmap_config;
 	struct regmap *regmap;
 	struct i2c_mux_core *muxc;
-- 
2.1.4

