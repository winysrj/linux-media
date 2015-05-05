Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45200 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbbEEV7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/21] tua9001: various minor changes
Date: Wed,  6 May 2015 00:58:34 +0300
Message-Id: <1430863122-9888-13-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix logging. Style issues. Rename things.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig        |   2 +-
 drivers/media/tuners/tua9001.c      | 153 ++++++++++++++++++------------------
 drivers/media/tuners/tua9001.h      |   6 +-
 drivers/media/tuners/tua9001_priv.h |  16 ++--
 4 files changed, 83 insertions(+), 94 deletions(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index e826453..74973f4 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -234,7 +234,7 @@ config MEDIA_TUNER_M88RS6000T
 	  Montage M88RS6000 internal tuner.
 
 config MEDIA_TUNER_TUA9001
-	tristate "Infineon TUA 9001 silicon tuner"
+	tristate "Infineon TUA9001 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index 87e8518..fe778cd 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -1,5 +1,5 @@
 /*
- * Infineon TUA 9001 silicon tuner driver
+ * Infineon TUA9001 silicon tuner driver
  *
  * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
  *
@@ -12,35 +12,30 @@
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
-#include "tua9001.h"
 #include "tua9001_priv.h"
 
 /* write register */
-static int tua9001_wr_reg(struct tua9001_priv *priv, u8 reg, u16 val)
+static int tua9001_wr_reg(struct tua9001_dev *dev, u8 reg, u16 val)
 {
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[3] = { reg, (val >> 8) & 0xff, (val >> 0) & 0xff };
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf,
 		}
 	};
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x\n",
-				KBUILD_MODNAME, ret, reg);
+		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x\n", ret, reg);
 		ret = -EREMOTEIO;
 	}
 
@@ -49,77 +44,82 @@ static int tua9001_wr_reg(struct tua9001_priv *priv, u8 reg, u16 val)
 
 static int tua9001_init(struct dvb_frontend *fe)
 {
-	struct tua9001_priv *priv = fe->tuner_priv;
-	int ret = 0;
-	u8 i;
-	struct reg_val data[] = {
-		{ 0x1e, 0x6512 },
-		{ 0x25, 0xb888 },
-		{ 0x39, 0x5460 },
-		{ 0x3b, 0x00c0 },
-		{ 0x3a, 0xf000 },
-		{ 0x08, 0x0000 },
-		{ 0x32, 0x0030 },
-		{ 0x41, 0x703a },
-		{ 0x40, 0x1c78 },
-		{ 0x2c, 0x1c00 },
-		{ 0x36, 0xc013 },
-		{ 0x37, 0x6f18 },
-		{ 0x27, 0x0008 },
-		{ 0x2a, 0x0001 },
-		{ 0x34, 0x0a40 },
+	struct tua9001_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
+	int ret, i;
+	static const struct tua9001_reg_val data[] = {
+		{0x1e, 0x6512},
+		{0x25, 0xb888},
+		{0x39, 0x5460},
+		{0x3b, 0x00c0},
+		{0x3a, 0xf000},
+		{0x08, 0x0000},
+		{0x32, 0x0030},
+		{0x41, 0x703a},
+		{0x40, 0x1c78},
+		{0x2c, 0x1c00},
+		{0x36, 0xc013},
+		{0x37, 0x6f18},
+		{0x27, 0x0008},
+		{0x2a, 0x0001},
+		{0x34, 0x0a40},
 	};
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	if (fe->callback) {
-		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-				TUA9001_CMD_RESETN, 0);
-		if (ret < 0)
+		ret = fe->callback(client->adapter,
+				   DVB_FRONTEND_COMPONENT_TUNER,
+				   TUA9001_CMD_RESETN, 0);
+		if (ret)
 			goto err;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
-		ret = tua9001_wr_reg(priv, data[i].reg, data[i].val);
-		if (ret < 0)
+		ret = tua9001_wr_reg(dev, data[i].reg, data[i].val);
+		if (ret)
 			goto err;
 	}
+	return 0;
 err:
-	if (ret < 0)
-		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tua9001_sleep(struct dvb_frontend *fe)
 {
-	struct tua9001_priv *priv = fe->tuner_priv;
-	int ret = 0;
-
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-
-	if (fe->callback)
-		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-				TUA9001_CMD_RESETN, 1);
+	struct tua9001_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
+	int ret;
 
-	if (ret < 0)
-		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "\n");
 
+	if (fe->callback) {
+		ret = fe->callback(client->adapter,
+				   DVB_FRONTEND_COMPONENT_TUNER,
+				   TUA9001_CMD_RESETN, 1);
+		if (ret)
+			goto err;
+	}
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tua9001_set_params(struct dvb_frontend *fe)
 {
-	struct tua9001_priv *priv = fe->tuner_priv;
+	struct tua9001_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret = 0, i;
+	int ret, i;
 	u16 val;
 	u32 frequency;
-	struct reg_val data[2];
+	struct tua9001_reg_val data[2];
 
-	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d frequency=%d " \
-			"bandwidth_hz=%d\n", __func__,
-			c->delivery_system, c->frequency, c->bandwidth_hz);
+	dev_dbg(&client->dev,
+		"delivery_system=%u frequency=%u bandwidth_hz=%u\n",
+		c->delivery_system, c->frequency, c->bandwidth_hz);
 
 	switch (c->delivery_system) {
 	case SYS_DVBT:
@@ -158,49 +158,48 @@ static int tua9001_set_params(struct dvb_frontend *fe)
 	data[1].val = frequency;
 
 	if (fe->callback) {
-		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-				TUA9001_CMD_RXEN, 0);
-		if (ret < 0)
+		ret = fe->callback(client->adapter,
+				   DVB_FRONTEND_COMPONENT_TUNER,
+				   TUA9001_CMD_RXEN, 0);
+		if (ret)
 			goto err;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
-		ret = tua9001_wr_reg(priv, data[i].reg, data[i].val);
-		if (ret < 0)
+		ret = tua9001_wr_reg(dev, data[i].reg, data[i].val);
+		if (ret)
 			goto err;
 	}
 
 	if (fe->callback) {
-		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-				TUA9001_CMD_RXEN, 1);
-		if (ret < 0)
+		ret = fe->callback(client->adapter,
+				   DVB_FRONTEND_COMPONENT_TUNER,
+				   TUA9001_CMD_RXEN, 1);
+		if (ret)
 			goto err;
 	}
+	return 0;
 err:
-	if (ret < 0)
-		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tua9001_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct tua9001_priv *priv = fe->tuner_priv;
+	struct tua9001_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	*frequency = 0; /* Zero-IF */
-
 	return 0;
 }
 
 static const struct dvb_tuner_ops tua9001_tuner_ops = {
 	.info = {
-		.name           = "Infineon TUA 9001",
-
+		.name           = "Infineon TUA9001",
 		.frequency_min  = 170000000,
 		.frequency_max  = 862000000,
-		.frequency_step = 0,
 	},
 
 	.init = tua9001_init,
@@ -213,7 +212,7 @@ static const struct dvb_tuner_ops tua9001_tuner_ops = {
 static int tua9001_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct tua9001_priv *dev;
+	struct tua9001_dev *dev;
 	struct tua9001_platform_data *pdata = client->dev.platform_data;
 	struct dvb_frontend *fe = pdata->dvb_frontend;
 	int ret;
@@ -225,8 +224,6 @@ static int tua9001_probe(struct i2c_client *client,
 	}
 
 	dev->client = client;
-	dev->i2c_addr = client->addr;
-	dev->i2c = client->adapter;
 	dev->fe = pdata->dvb_frontend;
 
 	if (fe->callback) {
@@ -254,7 +251,7 @@ static int tua9001_probe(struct i2c_client *client,
 			sizeof(struct dvb_tuner_ops));
 	i2c_set_clientdata(client, dev);
 
-	dev_info(&client->dev, "Infineon TUA 9001 successfully attached\n");
+	dev_info(&client->dev, "Infineon TUA9001 successfully attached\n");
 	return 0;
 err_kfree:
 	kfree(dev);
@@ -265,7 +262,7 @@ err:
 
 static int tua9001_remove(struct i2c_client *client)
 {
-	struct tua9001_priv *dev = i2c_get_clientdata(client);
+	struct tua9001_dev *dev = i2c_get_clientdata(client);
 	struct dvb_frontend *fe = dev->fe;
 	int ret;
 
@@ -305,6 +302,6 @@ static struct i2c_driver tua9001_driver = {
 
 module_i2c_driver(tua9001_driver);
 
-MODULE_DESCRIPTION("Infineon TUA 9001 silicon tuner driver");
+MODULE_DESCRIPTION("Infineon TUA9001 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
index 5328ab2..7b05481 100644
--- a/drivers/media/tuners/tua9001.h
+++ b/drivers/media/tuners/tua9001.h
@@ -1,5 +1,5 @@
 /*
- * Infineon TUA 9001 silicon tuner driver
+ * Infineon TUA9001 silicon tuner driver
  *
  * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
  *
@@ -12,10 +12,6 @@
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #ifndef TUA9001_H
diff --git a/drivers/media/tuners/tua9001_priv.h b/drivers/media/tuners/tua9001_priv.h
index 3282a1a..e24d843 100644
--- a/drivers/media/tuners/tua9001_priv.h
+++ b/drivers/media/tuners/tua9001_priv.h
@@ -1,5 +1,5 @@
 /*
- * Infineon TUA 9001 silicon tuner driver
+ * Infineon TUA9001 silicon tuner driver
  *
  * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
  *
@@ -12,25 +12,21 @@
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #ifndef TUA9001_PRIV_H
 #define TUA9001_PRIV_H
 
-struct reg_val {
+#include "tua9001.h"
+
+struct tua9001_reg_val {
 	u8 reg;
 	u16 val;
 };
 
-struct tua9001_priv {
-	struct i2c_client *client;
-	struct i2c_adapter *i2c;
-	u8 i2c_addr;
+struct tua9001_dev {
 	struct dvb_frontend *fe;
+	struct i2c_client *client;
 };
 
 #endif
-- 
http://palosaari.fi/

