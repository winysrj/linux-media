Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43908 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaHDE3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Aug 2014 00:29:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/9] anysee: convert tda18212 tuner to I2C client
Date: Mon,  4 Aug 2014 07:29:25 +0300
Message-Id: <1407126571-21629-3-git-send-email-crope@iki.fi>
In-Reply-To: <1407126571-21629-1-git-send-email-crope@iki.fi>
References: <1407126571-21629-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used tda18212 tuner is implemented as I2C driver. Implement I2C
client to anysee and use it for tda18212.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 183 +++++++++++++++++++++++++++-------
 drivers/media/usb/dvb-usb-v2/anysee.h |   3 +
 2 files changed, 150 insertions(+), 36 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index e4a2382..c5ea0ee 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -332,7 +332,6 @@ static struct tda10023_config anysee_tda10023_tda18212_config = {
 };
 
 static struct tda18212_config anysee_tda18212_config = {
-	.i2c_address = (0xc0 >> 1),
 	.if_dvbt_6 = 4150,
 	.if_dvbt_7 = 4150,
 	.if_dvbt_8 = 4150,
@@ -340,7 +339,6 @@ static struct tda18212_config anysee_tda18212_config = {
 };
 
 static struct tda18212_config anysee_tda18212_config2 = {
-	.i2c_address = 0x60 /* (0xc0 >> 1) */,
 	.if_dvbt_6 = 3550,
 	.if_dvbt_7 = 3700,
 	.if_dvbt_8 = 4150,
@@ -632,6 +630,90 @@ error:
 	return ret;
 }
 
+static int anysee_load_subdev(struct dvb_usb_device *d, char *type, u8 addr,
+		void *platform_data)
+{
+	int ret, num;
+	struct anysee_state *state = d_to_priv(d);
+	struct i2c_client *client;
+	struct i2c_adapter *adapter = &d->i2c_adap;
+	struct i2c_board_info board_info = {
+		.addr = addr,
+		.platform_data = platform_data,
+	};
+
+	strlcpy(board_info.type, type, I2C_NAME_SIZE);
+
+	/* find first free client */
+	for (num = 0; num < ANYSEE_I2C_CLIENT_MAX; num++) {
+		if (state->i2c_client[num] == NULL)
+			break;
+	}
+
+	dev_dbg(&d->udev->dev, "%s: num=%d\n", __func__, num);
+
+	if (num == ANYSEE_I2C_CLIENT_MAX) {
+		dev_err(&d->udev->dev, "%s: I2C client out of index\n",
+				KBUILD_MODNAME);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	request_module(board_info.type);
+
+	/* register I2C device */
+	client = i2c_new_device(adapter, &board_info);
+	if (client == NULL || client->dev.driver == NULL) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	/* increase I2C driver usage count */
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	state->i2c_client[num] = client;
+	return 0;
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static void anysee_unload_subdev(struct dvb_usb_device *d)
+{
+	int num;
+	struct anysee_state *state = d_to_priv(d);
+	struct i2c_client *client;
+
+	/* find last used client */
+	num = ANYSEE_I2C_CLIENT_MAX;
+	while (num--) {
+		if (state->i2c_client[num] != NULL)
+			break;
+	}
+
+	dev_dbg(&d->udev->dev, "%s: num=%d\n", __func__, num);
+
+	if (num == -1) {
+		dev_err(&d->udev->dev, "%s: I2C client out of index\n",
+				KBUILD_MODNAME);
+		goto err;
+	}
+
+	client = state->i2c_client[num];
+
+	/* decrease I2C driver usage count */
+	module_put(client->dev.driver->owner);
+
+	/* unregister I2C device */
+	i2c_unregister_device(client);
+err:
+	dev_dbg(&d->udev->dev, "%s: failed\n", __func__);
+}
+
 static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct anysee_state *state = adap_to_priv(adap);
@@ -640,12 +722,12 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 	u8 tmp;
 	struct i2c_msg msg[2] = {
 		{
-			.addr = anysee_tda18212_config.i2c_address,
+			.addr = 0x60,
 			.flags = 0,
 			.len = 1,
 			.buf = "\x00",
 		}, {
-			.addr = anysee_tda18212_config.i2c_address,
+			.addr = 0x60,
 			.flags = I2C_M_RD,
 			.len = 1,
 			.buf = &tmp,
@@ -723,9 +805,11 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 		/* probe TDA18212 */
 		tmp = 0;
 		ret = i2c_transfer(&d->i2c_adap, msg, 2);
-		if (ret == 2 && tmp == 0xc7)
+		if (ret == 2 && tmp == 0xc7) {
 			dev_dbg(&d->udev->dev, "%s: TDA18212 found\n",
 					__func__);
+			state->has_tda18212 = true;
+		}
 		else
 			tmp = 0;
 
@@ -939,46 +1023,63 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 		 * fails attach old simple PLL. */
 
 		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe[0], &d->i2c_adap,
-				&anysee_tda18212_config);
+		if (state->has_tda18212) {
+			struct tda18212_config tda18212_config =
+					anysee_tda18212_config;
 
-		if (fe && adap->fe[1]) {
-			/* attach tuner for 2nd FE */
-			fe = dvb_attach(tda18212_attach, adap->fe[1],
-					&d->i2c_adap, &anysee_tda18212_config);
-			break;
-		} else if (fe) {
-			break;
-		}
-
-		/* attach tuner */
-		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc0 >> 1),
-				&d->i2c_adap, DVB_PLL_SAMSUNG_DTOS403IH102A);
+			tda18212_config.fe = adap->fe[0];
+			ret = anysee_load_subdev(d, "tda18212", 0x60,
+					&tda18212_config);
+			if (ret)
+				goto err;
+
+			/* copy tuner ops for 2nd FE as tuner is shared */
+			if (adap->fe[1]) {
+				adap->fe[1]->tuner_priv =
+						adap->fe[0]->tuner_priv;
+				memcpy(&adap->fe[1]->ops.tuner_ops,
+						&adap->fe[0]->ops.tuner_ops,
+						sizeof(struct dvb_tuner_ops));
+			}
 
-		if (fe && adap->fe[1]) {
-			/* attach tuner for 2nd FE */
-			fe = dvb_attach(dvb_pll_attach, adap->fe[1],
+			return 0;
+		} else {
+			/* attach tuner */
+			fe = dvb_attach(dvb_pll_attach, adap->fe[0],
 					(0xc0 >> 1), &d->i2c_adap,
 					DVB_PLL_SAMSUNG_DTOS403IH102A);
+
+			if (fe && adap->fe[1]) {
+				/* attach tuner for 2nd FE */
+				fe = dvb_attach(dvb_pll_attach, adap->fe[1],
+						(0xc0 >> 1), &d->i2c_adap,
+						DVB_PLL_SAMSUNG_DTOS403IH102A);
+			}
 		}
 
 		break;
 	case ANYSEE_HW_508TC: /* 18 */
 	case ANYSEE_HW_508PTC: /* 21 */
+	{
 		/* E7 TC */
 		/* E7 PTC */
+		struct tda18212_config tda18212_config = anysee_tda18212_config;
 
-		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe[0], &d->i2c_adap,
-				&anysee_tda18212_config);
-
-		if (fe) {
-			/* attach tuner for 2nd FE */
-			fe = dvb_attach(tda18212_attach, adap->fe[1],
-					&d->i2c_adap, &anysee_tda18212_config);
+		tda18212_config.fe = adap->fe[0];
+		ret = anysee_load_subdev(d, "tda18212", 0x60, &tda18212_config);
+		if (ret)
+			goto err;
+
+		/* copy tuner ops for 2nd FE as tuner is shared */
+		if (adap->fe[1]) {
+			adap->fe[1]->tuner_priv = adap->fe[0]->tuner_priv;
+			memcpy(&adap->fe[1]->ops.tuner_ops,
+					&adap->fe[0]->ops.tuner_ops,
+					sizeof(struct dvb_tuner_ops));
 		}
 
-		break;
+		return 0;
+	}
 	case ANYSEE_HW_508S2: /* 19 */
 	case ANYSEE_HW_508PS2: /* 22 */
 		/* E7 S2 */
@@ -997,13 +1098,18 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 
 	case ANYSEE_HW_508T2C: /* 20 */
+	{
 		/* E7 T2C */
+		struct tda18212_config tda18212_config =
+				anysee_tda18212_config2;
 
-		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe[0], &d->i2c_adap,
-				&anysee_tda18212_config2);
+		tda18212_config.fe = adap->fe[0];
+		ret = anysee_load_subdev(d, "tda18212", 0x60, &tda18212_config);
+		if (ret)
+			goto err;
 
-		break;
+		return 0;
+	}
 	default:
 		fe = NULL;
 	}
@@ -1012,7 +1118,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 		ret = 0;
 	else
 		ret = -ENODEV;
-
+err:
 	return ret;
 }
 
@@ -1270,6 +1376,11 @@ static int anysee_init(struct dvb_usb_device *d)
 
 static void anysee_exit(struct dvb_usb_device *d)
 {
+	struct anysee_state *state = d_to_priv(d);
+
+	if (state->i2c_client[0])
+		anysee_unload_subdev(d);
+
 	return anysee_ci_release(d);
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.h b/drivers/media/usb/dvb-usb-v2/anysee.h
index 8f426d9..3ca2bca 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.h
+++ b/drivers/media/usb/dvb-usb-v2/anysee.h
@@ -55,8 +55,11 @@ struct anysee_state {
 	u8 buf[64];
 	u8 seq;
 	u8 hw; /* PCB ID */
+	#define ANYSEE_I2C_CLIENT_MAX 1
+	struct i2c_client *i2c_client[ANYSEE_I2C_CLIENT_MAX];
 	u8 fe_id:1; /* frondend ID */
 	u8 has_ci:1;
+	u8 has_tda18212:1;
 	u8 ci_attached:1;
 	struct dvb_ca_en50221 ci;
 	unsigned long ci_cam_ready; /* jiffies */
-- 
http://palosaari.fi/

