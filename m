Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55015 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1GZASI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 20:18:08 -0400
Received: from dyn3-82-128-185-212.psoas.suomi.net ([82.128.185.212] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <crope@iki.fi>)
	id 1QlVLb-0005wD-Fm
	for linux-media@vger.kernel.org; Tue, 26 Jul 2011 03:18:07 +0300
Message-ID: <4E2E07BF.4030507@iki.fi>
Date: Tue, 26 Jul 2011 03:18:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] anysee: use multi-frontend (MFE)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
  drivers/media/dvb/dvb-usb/anysee.c |  299 
++++++++++++++++++++++++-----------
  drivers/media/dvb/dvb-usb/anysee.h |    1 +
  2 files changed, 206 insertions(+), 94 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/anysee.c 
b/drivers/media/dvb/dvb-usb/anysee.c
index 1ec88b6..d4d2420 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -446,6 +446,114 @@ static struct isl6423_config anysee_isl6423_config = {
   * IOE[5] STV0903 1=enabled
   */

+static int anysee_frontend_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct anysee_state *state = adap->dev->priv;
+	int ret;
+
+	deb_info("%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
+
+	/* no frontend sleep control */
+	if (onoff == 0)
+		return 0;
+
+	switch (state->hw) {
+	case ANYSEE_HW_507FA: /* 15 */
+		/* E30 Combo Plus */
+		/* E30 C Plus */
+
+		if ((fe->id ^ dvb_usb_anysee_delsys) == 0)  {
+			/* disable DVB-T demod on IOD[0] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 0),
+				0x01);
+			if (ret)
+				goto error;
+
+			/* enable DVB-C demod on IOD[5] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 5),
+				0x20);
+			if (ret)
+				goto error;
+
+			/* enable DVB-C tuner on IOE[0] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (1 << 0),
+				0x01);
+			if (ret)
+				goto error;
+		} else {
+			/* disable DVB-C demod on IOD[5] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 5),
+				0x20);
+			if (ret)
+				goto error;
+
+			/* enable DVB-T demod on IOD[0] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 0),
+				0x01);
+			if (ret)
+				goto error;
+
+			/* enable DVB-T tuner on IOE[0] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (0 << 0),
+				0x01);
+			if (ret)
+				goto error;
+		}
+
+		break;
+	case ANYSEE_HW_508TC: /* 18 */
+	case ANYSEE_HW_508PTC: /* 21 */
+		/* E7 TC */
+		/* E7 PTC */
+
+		if ((fe->id ^ dvb_usb_anysee_delsys) == 0)  {
+			/* disable DVB-T demod on IOD[6] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 6),
+				0x40);
+			if (ret)
+				goto error;
+
+			/* enable DVB-C demod on IOD[5] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 5),
+				0x20);
+			if (ret)
+				goto error;
+
+			/* enable IF route on IOE[0] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (1 << 0),
+				0x01);
+			if (ret)
+				goto error;
+		} else {
+			/* disable DVB-C demod on IOD[5] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 5),
+				0x20);
+			if (ret)
+				goto error;
+
+			/* enable DVB-T demod on IOD[6] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 6),
+				0x40);
+			if (ret)
+				goto error;
+
+			/* enable IF route on IOE[0] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (0 << 0),
+				0x01);
+			if (ret)
+				goto error;
+		}
+
+		break;
+	default:
+		ret = 0;
+	}
+
+error:
+	return ret;
+}
+
  static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
  {
  	int ret;
@@ -466,27 +574,37 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
  		}
  	};

-	/* Check which hardware we have.
-	 * We must do this call two times to get reliable values (hw bug).
-	 */
-	ret = anysee_get_hw_info(adap->dev, hw_info);
-	if (ret)
-		goto error;
+	/* detect hardware only once */
+	if (adap->fe[0] == NULL) {
+		/* Check which hardware we have.
+		 * We must do this call two times to get reliable values (hw bug).
+		 */
+		ret = anysee_get_hw_info(adap->dev, hw_info);
+		if (ret)
+			goto error;

-	ret = anysee_get_hw_info(adap->dev, hw_info);
-	if (ret)
-		goto error;
+		ret = anysee_get_hw_info(adap->dev, hw_info);
+		if (ret)
+			goto error;
+
+		/* Meaning of these info bytes are guessed. */
+		info("firmware version:%d.%d hardware id:%d",
+			hw_info[1], hw_info[2], hw_info[0]);

-	/* Meaning of these info bytes are guessed. */
-	info("firmware version:%d.%d hardware id:%d",
-		hw_info[1], hw_info[2], hw_info[0]);
+		state->hw = hw_info[0];
+	}

-	state->hw = hw_info[0];
+	/* set current frondend ID for devices having two frondends */
+	if (adap->fe[0])
+		state->fe_id++;

  	switch (state->hw) {
  	case ANYSEE_HW_507T: /* 2 */
  		/* E30 */

+		if (state->fe_id)
+			break;
+
  		/* attach demod */
  		adap->fe[0] = dvb_attach(mt352_attach, &anysee_mt352_config,
  			&adap->dev->i2c_adap);
@@ -501,6 +619,9 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
  	case ANYSEE_HW_507CD: /* 6 */
  		/* E30 Plus */

+		if (state->fe_id)
+			break;
+
  		/* enable DVB-T demod on IOD[0] */
  		ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 0), 0x01);
  		if (ret)
@@ -512,26 +633,32 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
  			goto error;

  		/* attach demod */
-		adap->fe[0] = dvb_attach(zl10353_attach, &anysee_zl10353_config,
-			&adap->dev->i2c_adap);
+		adap->fe[0] = dvb_attach(zl10353_attach,
+			&anysee_zl10353_config, &adap->dev->i2c_adap);

  		break;
  	case ANYSEE_HW_507DC: /* 10 */
  		/* E30 C Plus */

+		if (state->fe_id)
+			break;
+
  		/* enable DVB-C demod on IOD[0] */
  		ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 0), 0x01);
  		if (ret)
  			goto error;

  		/* attach demod */
-		adap->fe[0] = dvb_attach(tda10023_attach, &anysee_tda10023_config,
-			&adap->dev->i2c_adap, 0x48);
+		adap->fe[0] = dvb_attach(tda10023_attach,
+			&anysee_tda10023_config, &adap->dev->i2c_adap, 0x48);

  		break;
  	case ANYSEE_HW_507SI: /* 11 */
  		/* E30 S2 Plus */

+		if (state->fe_id)
+			break;
+
  		/* enable DVB-S/S2 demod on IOD[0] */
  		ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 0), 0x01);
  		if (ret)
@@ -564,55 +691,59 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
  		if (ret)
  			goto error;

-		if (dvb_usb_anysee_delsys) {
-			/* disable DVB-C demod on IOD[5] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 5),
-				0x20);
+		if ((state->fe_id ^ dvb_usb_anysee_delsys) == 0)  {
+			/* disable DVB-T demod on IOD[0] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 0),
+				0x01);
  			if (ret)
  				goto error;

-			/* enable DVB-T demod on IOD[0] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 0),
-				0x01);
+			/* enable DVB-C demod on IOD[5] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 5),
+				0x20);
  			if (ret)
  				goto error;

  			/* attach demod */
  			if (tmp == 0xc7) {
  				/* TDA18212 config */
-				adap->fe[0] = dvb_attach(zl10353_attach,
-					&anysee_zl10353_tda18212_config2,
-					&adap->dev->i2c_adap);
+				adap->fe[state->fe_id] = dvb_attach(
+					tda10023_attach,
+					&anysee_tda10023_tda18212_config,
+					&adap->dev->i2c_adap, 0x48);
  			} else {
  				/* PLL config */
-				adap->fe[0] = dvb_attach(zl10353_attach,
-					&anysee_zl10353_config,
-					&adap->dev->i2c_adap);
+				adap->fe[state->fe_id] = dvb_attach(
+					tda10023_attach,
+					&anysee_tda10023_config,
+					&adap->dev->i2c_adap, 0x48);
  			}
  		} else {
-			/* disable DVB-T demod on IOD[0] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 0),
-				0x01);
+			/* disable DVB-C demod on IOD[5] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 5),
+				0x20);
  			if (ret)
  				goto error;

-			/* enable DVB-C demod on IOD[5] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 5),
-				0x20);
+			/* enable DVB-T demod on IOD[0] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 0),
+				0x01);
  			if (ret)
  				goto error;

  			/* attach demod */
  			if (tmp == 0xc7) {
  				/* TDA18212 config */
-				adap->fe[0] = dvb_attach(tda10023_attach,
-					&anysee_tda10023_tda18212_config,
-					&adap->dev->i2c_adap, 0x48);
+				adap->fe[state->fe_id] = dvb_attach(
+					zl10353_attach,
+					&anysee_zl10353_tda18212_config2,
+					&adap->dev->i2c_adap);
  			} else {
  				/* PLL config */
-				adap->fe[0] = dvb_attach(tda10023_attach,
-					&anysee_tda10023_config,
-					&adap->dev->i2c_adap, 0x48);
+				adap->fe[state->fe_id] = dvb_attach(
+					zl10353_attach,
+					&anysee_zl10353_config,
+					&adap->dev->i2c_adap);
  			}
  		}

@@ -627,52 +758,40 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
  		if (ret)
  			goto error;

-		if (dvb_usb_anysee_delsys) {
-			/* disable DVB-C demod on IOD[5] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 5),
-				0x20);
-			if (ret)
-				goto error;
-
-			/* enable DVB-T demod on IOD[6] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 6),
+		if ((state->fe_id ^ dvb_usb_anysee_delsys) == 0)  {
+			/* disable DVB-T demod on IOD[6] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 6),
  				0x40);
  			if (ret)
  				goto error;

-			/* enable IF route on IOE[0] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (0 << 0),
-				0x01);
+			/* enable DVB-C demod on IOD[5] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 5),
+				0x20);
  			if (ret)
  				goto error;

  			/* attach demod */
-			adap->fe[0] = dvb_attach(zl10353_attach,
-				&anysee_zl10353_tda18212_config,
-				&adap->dev->i2c_adap);
+			adap->fe[state->fe_id] = dvb_attach(tda10023_attach,
+				&anysee_tda10023_tda18212_config,
+				&adap->dev->i2c_adap, 0x48);
  		} else {
-			/* disable DVB-T demod on IOD[6] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 6),
-				0x40);
-			if (ret)
-				goto error;
-
-			/* enable DVB-C demod on IOD[5] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 5),
+			/* disable DVB-C demod on IOD[5] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (0 << 5),
  				0x20);
  			if (ret)
  				goto error;

-			/* enable IF route on IOE[0] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (1 << 0),
-				0x01);
+			/* enable DVB-T demod on IOD[6] */
+			ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 6),
+				0x40);
  			if (ret)
  				goto error;

  			/* attach demod */
-			adap->fe[0] = dvb_attach(tda10023_attach,
-				&anysee_tda10023_tda18212_config,
-				&adap->dev->i2c_adap, 0x48);
+			adap->fe[state->fe_id] = dvb_attach(zl10353_attach,
+				&anysee_zl10353_tda18212_config,
+				&adap->dev->i2c_adap);
  		}

  		break;
@@ -681,6 +800,9 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
  		/* E7 S2 */
  		/* E7 PS2 */

+		if (state->fe_id)
+			break;
+
  		/* enable transport stream on IOA[7] */
  		ret = anysee_wr_reg_mask(adap->dev, REG_IOA, (1 << 7), 0x80);
  		if (ret)
@@ -713,7 +835,7 @@ static int anysee_tuner_attach(struct 
dvb_usb_adapter *adap)
  	struct anysee_state *state = adap->dev->priv;
  	struct dvb_frontend *fe;
  	int ret;
-	deb_info("%s:\n", __func__);
+	deb_info("%s: fe=%d\n", __func__, state->fe_id);

  	switch (state->hw) {
  	case ANYSEE_HW_507T: /* 2 */
@@ -744,28 +866,14 @@ static int anysee_tuner_attach(struct 
dvb_usb_adapter *adap)
  		/* E30 S2 Plus */

  		/* attach LNB controller */
-		fe = dvb_attach(isl6423_attach, adap->fe[0], &adap->dev->i2c_adap,
-			&anysee_isl6423_config);
+		fe = dvb_attach(isl6423_attach, adap->fe[0],
+			&adap->dev->i2c_adap, &anysee_isl6423_config);

  		break;
  	case ANYSEE_HW_507FA: /* 15 */
  		/* E30 Combo Plus */
  		/* E30 C Plus */

-		if (dvb_usb_anysee_delsys) {
-			/* enable DVB-T tuner on IOE[0] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (0 << 0),
-				0x01);
-			if (ret)
-				goto error;
-		} else {
-			/* enable DVB-C tuner on IOE[0] */
-			ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (1 << 0),
-				0x01);
-			if (ret)
-				goto error;
-		}
-
  		/* Try first attach TDA18212 silicon tuner on IOE[4], if that
  		 * fails attach old simple PLL. */

@@ -775,8 +883,8 @@ static int anysee_tuner_attach(struct 
dvb_usb_adapter *adap)
  			goto error;

  		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe[0], &adap->dev->i2c_adap,
-			&anysee_tda18212_config);
+		fe = dvb_attach(tda18212_attach, adap->fe[state->fe_id],
+			&adap->dev->i2c_adap, &anysee_tda18212_config);
  		if (fe)
  			break;

@@ -786,8 +894,9 @@ static int anysee_tuner_attach(struct 
dvb_usb_adapter *adap)
  			goto error;

  		/* attach tuner */
-		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc0 >> 1),
-			&adap->dev->i2c_adap, DVB_PLL_SAMSUNG_DTOS403IH102A);
+		fe = dvb_attach(dvb_pll_attach, adap->fe[state->fe_id],
+			(0xc0 >> 1), &adap->dev->i2c_adap,
+			DVB_PLL_SAMSUNG_DTOS403IH102A);

  		break;
  	case ANYSEE_HW_508TC: /* 18 */
@@ -801,8 +910,8 @@ static int anysee_tuner_attach(struct 
dvb_usb_adapter *adap)
  			goto error;

  		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe[0], &adap->dev->i2c_adap,
-			&anysee_tda18212_config);
+		fe = dvb_attach(tda18212_attach, adap->fe[state->fe_id],
+			&adap->dev->i2c_adap, &anysee_tda18212_config);

  		break;
  	case ANYSEE_HW_508S2: /* 19 */
@@ -918,6 +1027,8 @@ static struct dvb_usb_device_properties 
anysee_properties = {
  	.num_adapters = 1,
  	.adapter = {
  		{
+			.num_frontends    = 2,
+			.frontend_ctrl    = anysee_frontend_ctrl,
  			.streaming_ctrl   = anysee_streaming_ctrl,
  			.frontend_attach  = anysee_frontend_attach,
  			.tuner_attach     = anysee_tuner_attach,
diff --git a/drivers/media/dvb/dvb-usb/anysee.h 
b/drivers/media/dvb/dvb-usb/anysee.h
index ad6ccd1..57ee500 100644
--- a/drivers/media/dvb/dvb-usb/anysee.h
+++ b/drivers/media/dvb/dvb-usb/anysee.h
@@ -59,6 +59,7 @@ enum cmd {
  struct anysee_state {
  	u8 hw; /* PCB ID */
  	u8 seq;
+	u8 fe_id:1; /* frondend ID */
  };

  #define ANYSEE_HW_507T    2 /* E30 */
-- 
1.7.6

-- 
http://palosaari.fi/
