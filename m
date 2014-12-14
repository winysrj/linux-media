Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54165 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaLNI3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/18] rtl2830: style related changes
Date: Sun, 14 Dec 2014 10:28:33 +0200
Message-Id: <1418545723-9536-8-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trivial changes proposed by checkpatch.pl and some more.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 125 ++++++++++++++---------------
 drivers/media/dvb-frontends/rtl2830.h      |   4 -
 drivers/media/dvb-frontends/rtl2830_priv.h |   3 -
 3 files changed, 60 insertions(+), 72 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index ea68c7e..8025b19 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -13,16 +13,6 @@
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
  *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- */
-
-
-/*
- * Driver implements own I2C-adapter for tuner I2C access. That's since chip
- * have unusual I2C-gate control which closes gate automatically after each
- * I2C transfer. Using own I2C adapter we can workaround that.
  */
 
 #include "rtl2830_priv.h"
@@ -46,7 +36,7 @@ static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 
 	if (1 + len > sizeof(buf)) {
 		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
-				reg, len);
+			 reg, len);
 		return -EINVAL;
 	}
 
@@ -58,9 +48,10 @@ static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 		ret = 0;
 	} else {
 		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
+
 	return ret;
 }
 
@@ -87,9 +78,10 @@ static int rtl2830_rd(struct i2c_client *client, u8 reg, u8 *val, int len)
 		ret = 0;
 	} else {
 		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
+
 	return ret;
 }
 
@@ -187,47 +179,47 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret, i;
 	struct rtl2830_reg_val_mask tab[] = {
-		{ 0x00d, 0x01, 0x03 },
-		{ 0x00d, 0x10, 0x10 },
-		{ 0x104, 0x00, 0x1e },
-		{ 0x105, 0x80, 0x80 },
-		{ 0x110, 0x02, 0x03 },
-		{ 0x110, 0x08, 0x0c },
-		{ 0x17b, 0x00, 0x40 },
-		{ 0x17d, 0x05, 0x0f },
-		{ 0x17d, 0x50, 0xf0 },
-		{ 0x18c, 0x08, 0x0f },
-		{ 0x18d, 0x00, 0xc0 },
-		{ 0x188, 0x05, 0x0f },
-		{ 0x189, 0x00, 0xfc },
-		{ 0x2d5, 0x02, 0x02 },
-		{ 0x2f1, 0x02, 0x06 },
-		{ 0x2f1, 0x20, 0xf8 },
-		{ 0x16d, 0x00, 0x01 },
-		{ 0x1a6, 0x00, 0x80 },
-		{ 0x106, dev->pdata->vtop, 0x3f },
-		{ 0x107, dev->pdata->krf, 0x3f },
-		{ 0x112, 0x28, 0xff },
-		{ 0x103, dev->pdata->agc_targ_val, 0xff },
-		{ 0x00a, 0x02, 0x07 },
-		{ 0x140, 0x0c, 0x3c },
-		{ 0x140, 0x40, 0xc0 },
-		{ 0x15b, 0x05, 0x07 },
-		{ 0x15b, 0x28, 0x38 },
-		{ 0x15c, 0x05, 0x07 },
-		{ 0x15c, 0x28, 0x38 },
-		{ 0x115, dev->pdata->spec_inv, 0x01 },
-		{ 0x16f, 0x01, 0x07 },
-		{ 0x170, 0x18, 0x38 },
-		{ 0x172, 0x0f, 0x0f },
-		{ 0x173, 0x08, 0x38 },
-		{ 0x175, 0x01, 0x07 },
-		{ 0x176, 0x00, 0xc0 },
+		{0x00d, 0x01, 0x03},
+		{0x00d, 0x10, 0x10},
+		{0x104, 0x00, 0x1e},
+		{0x105, 0x80, 0x80},
+		{0x110, 0x02, 0x03},
+		{0x110, 0x08, 0x0c},
+		{0x17b, 0x00, 0x40},
+		{0x17d, 0x05, 0x0f},
+		{0x17d, 0x50, 0xf0},
+		{0x18c, 0x08, 0x0f},
+		{0x18d, 0x00, 0xc0},
+		{0x188, 0x05, 0x0f},
+		{0x189, 0x00, 0xfc},
+		{0x2d5, 0x02, 0x02},
+		{0x2f1, 0x02, 0x06},
+		{0x2f1, 0x20, 0xf8},
+		{0x16d, 0x00, 0x01},
+		{0x1a6, 0x00, 0x80},
+		{0x106, dev->pdata->vtop, 0x3f},
+		{0x107, dev->pdata->krf, 0x3f},
+		{0x112, 0x28, 0xff},
+		{0x103, dev->pdata->agc_targ_val, 0xff},
+		{0x00a, 0x02, 0x07},
+		{0x140, 0x0c, 0x3c},
+		{0x140, 0x40, 0xc0},
+		{0x15b, 0x05, 0x07},
+		{0x15b, 0x28, 0x38},
+		{0x15c, 0x05, 0x07},
+		{0x15c, 0x28, 0x38},
+		{0x115, dev->pdata->spec_inv, 0x01},
+		{0x16f, 0x01, 0x07},
+		{0x170, 0x18, 0x38},
+		{0x172, 0x0f, 0x0f},
+		{0x173, 0x08, 0x38},
+		{0x175, 0x01, 0x07},
+		{0x176, 0x00, 0xc0},
 	};
 
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
 		ret = rtl2830_wr_reg_mask(client, tab[i].reg, tab[i].val,
-			tab[i].mask);
+					  tab[i].mask);
 		if (ret)
 			goto err;
 	}
@@ -237,7 +229,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
 		goto err;
 
 	ret = rtl2830_wr_regs(client, 0x195,
-		"\x04\x06\x0a\x12\x0a\x12\x1e\x28", 8);
+			      "\x04\x06\x0a\x12\x0a\x12\x1e\x28", 8);
 	if (ret)
 		goto err;
 
@@ -264,12 +256,14 @@ static int rtl2830_sleep(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
+
 	dev->sleeping = true;
+
 	return 0;
 }
 
 static int rtl2830_get_tune_settings(struct dvb_frontend *fe,
-	struct dvb_frontend_tune_settings *s)
+				     struct dvb_frontend_tune_settings *s)
 {
 	s->min_delay_ms = 500;
 	s->step_size = fe->ops.info.frequency_stepsize * 2;
@@ -312,7 +306,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	};
 
 	dev_dbg(&client->dev, "frequency=%u bandwidth_hz=%u inversion=%u\n",
-			c->frequency, c->bandwidth_hz, c->inversion);
+		c->frequency, c->bandwidth_hz, c->inversion);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -330,7 +324,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		break;
 	default:
 		dev_err(&client->dev, "invalid bandwidth_hz %u\n",
-				c->bandwidth_hz);
+			c->bandwidth_hz);
 		return -EINVAL;
 	}
 
@@ -343,8 +337,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 	else
 		ret = -EINVAL;
-
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	num = if_frequency % dev->pdata->clk;
@@ -353,7 +346,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	num = -num;
 	if_ctl = num & 0x3fffff;
 	dev_dbg(&client->dev, "if_frequency=%d if_ctl=%08x\n",
-			if_frequency, if_ctl);
+		if_frequency, if_ctl);
 
 	ret = rtl2830_rd_reg_mask(client, 0x119, &tmp, 0xc0); /* b[7:6] */
 	if (ret)
@@ -507,6 +500,7 @@ static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	u8 tmp;
+
 	*status = 0;
 
 	if (dev->sleeping)
@@ -540,9 +534,9 @@ static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 #define CONSTELLATION_NUM 3
 #define HIERARCHY_NUM 4
 	static const u32 snr_constant[CONSTELLATION_NUM][HIERARCHY_NUM] = {
-		{ 70705899, 70705899, 70705899, 70705899 },
-		{ 82433173, 82433173, 87483115, 94445660 },
-		{ 92888734, 92888734, 95487525, 99770748 },
+		{70705899, 70705899, 70705899, 70705899},
+		{82433173, 82433173, 87483115, 94445660},
+		{92888734, 92888734, 95487525, 99770748},
 	};
 
 	if (dev->sleeping)
@@ -605,6 +599,7 @@ err:
 static int rtl2830_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	*ucblocks = 0;
+
 	return 0;
 }
 
@@ -630,7 +625,7 @@ static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	else
 		if_agc = if_agc_raw;
 
-	*strength = (u8) (55 - if_agc / 182);
+	*strength = (u8)(55 - if_agc / 182);
 	*strength |= *strength << 8;
 
 	return 0;
@@ -640,7 +635,7 @@ err:
 }
 
 static struct dvb_frontend_ops rtl2830_ops = {
-	.delsys = { SYS_DVBT },
+	.delsys = {SYS_DVBT},
 	.info = {
 		.name = "Realtek RTL2830 (DVB-T)",
 		.caps = FE_CAN_FEC_1_2 |
@@ -723,7 +718,6 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	}
 
 	return 0;
-
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -748,7 +742,7 @@ static struct i2c_adapter *rtl2830_get_i2c_adapter(struct i2c_client *client)
 }
 
 static int rtl2830_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
+			 const struct i2c_device_id *id)
 {
 	struct rtl2830_platform_data *pdata = client->dev.platform_data;
 	struct rtl2830_dev *dev;
@@ -796,8 +790,8 @@ static int rtl2830_probe(struct i2c_client *client,
 	pdata->get_i2c_adapter = rtl2830_get_i2c_adapter;
 
 	dev_info(&client->dev, "Realtek RTL2830 successfully attached\n");
-	return 0;
 
+	return 0;
 err_kfree:
 	kfree(dev);
 err:
@@ -813,6 +807,7 @@ static int rtl2830_remove(struct i2c_client *client)
 
 	i2c_del_mux_adapter(dev->adapter);
 	kfree(dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index 1d7784d..61f784c 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -13,15 +13,11 @@
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
  *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #ifndef RTL2830_H
 #define RTL2830_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct rtl2830_platform_data {
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 5276fb2..5f9973a 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -13,9 +13,6 @@
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
  *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #ifndef RTL2830_PRIV_H
-- 
http://palosaari.fi/

