Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39259 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074Ab1G1VuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 17:50:13 -0400
Received: from dyn3-82-128-185-212.psoas.suomi.net ([82.128.185.212] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <crope@iki.fi>)
	id 1QmYT5-0007Pt-5x
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 00:50:11 +0300
Message-ID: <4E31D992.2000209@iki.fi>
Date: Fri, 29 Jul 2011 00:50:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVB USB MFE resend with patches attached
Content-Type: multipart/mixed;
 boundary="------------000200010204060101020202"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000200010204060101020202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Still didn't find all configurations for Thuderbird so I attached
patches as files.

Sorry about spamming many times!


regards
Antti


-- 
http://palosaari.fi/

--------------000200010204060101020202
Content-Type: text/plain;
 name="0000-cover-letter.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0000-cover-letter.patch"

>From f42168386609556ae94c844a52f94c6292e0153b Mon Sep 17 00:00:00 2001
From: Antti Palosaari <crope@iki.fi>
Date: Tue, 26 Jul 2011 03:07:51 +0300
Subject: [PATCH 0/3] *** SUBJECT HERE ***

*** BLURB HERE ***

Antti Palosaari (3):
  dvb-usb: prepare for multi-frontend support (MFE)
  dvb-usb: multi-frontend support (MFE)
  anysee: use multi-frontend (MFE)

 drivers/media/dvb/dvb-usb/af9005.c          |    2 +-
 drivers/media/dvb/dvb-usb/af9015.c          |   22 +-
 drivers/media/dvb/dvb-usb/anysee.c          |  321 ++++++++++++++++++---------
 drivers/media/dvb/dvb-usb/anysee.h          |    1 +
 drivers/media/dvb/dvb-usb/au6610.c          |    6 +-
 drivers/media/dvb/dvb-usb/az6027.c          |   10 +-
 drivers/media/dvb/dvb-usb/ce6230.c          |    6 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c  |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c           |   60 +++---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  262 +++++++++++-----------
 drivers/media/dvb/dvb-usb/dibusb-common.c   |   18 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c       |   16 +-
 drivers/media/dvb/dvb-usb/digitv.c          |    8 +-
 drivers/media/dvb/dvb-usb/dtt200u.c         |    2 +-
 drivers/media/dvb/dvb-usb/dtv5100.c         |    8 +-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     |   85 ++++++--
 drivers/media/dvb/dvb-usb/dvb-usb-init.c    |    4 +
 drivers/media/dvb/dvb-usb/dvb-usb.h         |   11 +-
 drivers/media/dvb/dvb-usb/dw2102.c          |   92 ++++----
 drivers/media/dvb/dvb-usb/ec168.c           |    6 +-
 drivers/media/dvb/dvb-usb/friio.c           |    4 +-
 drivers/media/dvb/dvb-usb/gl861.c           |    6 +-
 drivers/media/dvb/dvb-usb/gp8psk.c          |    2 +-
 drivers/media/dvb/dvb-usb/lmedm04.c         |   28 ++--
 drivers/media/dvb/dvb-usb/m920x.c           |   14 +-
 drivers/media/dvb/dvb-usb/opera1.c          |    6 +-
 drivers/media/dvb/dvb-usb/technisat-usb2.c  |   24 +-
 drivers/media/dvb/dvb-usb/ttusb2.c          |   10 +-
 drivers/media/dvb/dvb-usb/umt-010.c         |    4 +-
 drivers/media/dvb/dvb-usb/vp702x.c          |    2 +-
 drivers/media/dvb/dvb-usb/vp7045.c          |    2 +-
 31 files changed, 606 insertions(+), 438 deletions(-)

-- 
1.7.6


--------------000200010204060101020202
Content-Type: text/plain;
 name="0001-dvb-usb-prepare-for-multi-frontend-support-MFE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-dvb-usb-prepare-for-multi-frontend-support-MFE.patch"

>From c0bcf184bff9e99f147f72647757d8bc6fc2bd41 Mon Sep 17 00:00:00 2001
From: Antti Palosaari <crope@iki.fi>
Date: Mon, 25 Jul 2011 02:29:16 +0300
Subject: [PATCH 1/3] dvb-usb: prepare for multi-frontend support (MFE)

Change adapter FE pointer as array of FE pointers.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/af9005.c          |    2 +-
 drivers/media/dvb/dvb-usb/af9015.c          |   22 +-
 drivers/media/dvb/dvb-usb/anysee.c          |   46 +++---
 drivers/media/dvb/dvb-usb/au6610.c          |    6 +-
 drivers/media/dvb/dvb-usb/az6027.c          |   10 +-
 drivers/media/dvb/dvb-usb/ce6230.c          |    6 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c  |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c           |   60 +++---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  262 +++++++++++++-------------
 drivers/media/dvb/dvb-usb/dibusb-common.c   |   18 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c       |   16 +-
 drivers/media/dvb/dvb-usb/digitv.c          |    8 +-
 drivers/media/dvb/dvb-usb/dtt200u.c         |    2 +-
 drivers/media/dvb/dvb-usb/dtv5100.c         |    8 +-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     |   18 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h         |    2 +-
 drivers/media/dvb/dvb-usb/dw2102.c          |   92 +++++-----
 drivers/media/dvb/dvb-usb/ec168.c           |    6 +-
 drivers/media/dvb/dvb-usb/friio.c           |    4 +-
 drivers/media/dvb/dvb-usb/gl861.c           |    6 +-
 drivers/media/dvb/dvb-usb/gp8psk.c          |    2 +-
 drivers/media/dvb/dvb-usb/lmedm04.c         |   28 ++--
 drivers/media/dvb/dvb-usb/m920x.c           |   14 +-
 drivers/media/dvb/dvb-usb/opera1.c          |    6 +-
 drivers/media/dvb/dvb-usb/technisat-usb2.c  |   24 ++--
 drivers/media/dvb/dvb-usb/ttusb2.c          |   10 +-
 drivers/media/dvb/dvb-usb/umt-010.c         |    4 +-
 drivers/media/dvb/dvb-usb/vp702x.c          |    2 +-
 drivers/media/dvb/dvb-usb/vp7045.c          |    2 +-
 29 files changed, 344 insertions(+), 344 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
index 51f6439..753b86e 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -815,7 +815,7 @@ static int af9005_frontend_attach(struct dvb_usb_adapter *adap)
 			debug_dump(buf, 8, printk);
 		}
 	}
-	adap->fe = af9005_fe_attach(adap->dev);
+	adap->fe[0] = af9005_fe_attach(adap->dev);
 	return 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index d7ad05f..f966b0b 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1111,10 +1111,10 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	/* attach demodulator */
-	adap->fe = dvb_attach(af9013_attach, &af9015_af9013_config[adap->id],
+	adap->fe[0] = dvb_attach(af9013_attach, &af9015_af9013_config[adap->id],
 		&adap->dev->i2c_adap);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static struct mt2060_config af9015_mt2060_config = {
@@ -1188,49 +1188,49 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 	switch (af9015_af9013_config[adap->id].tuner) {
 	case AF9013_TUNER_MT2060:
 	case AF9013_TUNER_MT2060_2:
-		ret = dvb_attach(mt2060_attach, adap->fe, &adap->dev->i2c_adap,
+		ret = dvb_attach(mt2060_attach, adap->fe[0], &adap->dev->i2c_adap,
 			&af9015_mt2060_config,
 			af9015_config.mt2060_if1[adap->id])
 			== NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_QT1010:
 	case AF9013_TUNER_QT1010A:
-		ret = dvb_attach(qt1010_attach, adap->fe, &adap->dev->i2c_adap,
+		ret = dvb_attach(qt1010_attach, adap->fe[0], &adap->dev->i2c_adap,
 			&af9015_qt1010_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_TDA18271:
-		ret = dvb_attach(tda18271_attach, adap->fe, 0xc0,
+		ret = dvb_attach(tda18271_attach, adap->fe[0], 0xc0,
 			&adap->dev->i2c_adap,
 			&af9015_tda18271_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_TDA18218:
-		ret = dvb_attach(tda18218_attach, adap->fe,
+		ret = dvb_attach(tda18218_attach, adap->fe[0],
 			&adap->dev->i2c_adap,
 			&af9015_tda18218_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5003D:
-		ret = dvb_attach(mxl5005s_attach, adap->fe,
+		ret = dvb_attach(mxl5005s_attach, adap->fe[0],
 			&adap->dev->i2c_adap,
 			&af9015_mxl5003_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5005D:
 	case AF9013_TUNER_MXL5005R:
-		ret = dvb_attach(mxl5005s_attach, adap->fe,
+		ret = dvb_attach(mxl5005s_attach, adap->fe[0],
 			&adap->dev->i2c_adap,
 			&af9015_mxl5005_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_ENV77H11D5:
-		ret = dvb_attach(dvb_pll_attach, adap->fe, 0xc0,
+		ret = dvb_attach(dvb_pll_attach, adap->fe[0], 0xc0,
 			&adap->dev->i2c_adap,
 			DVB_PLL_TDA665X) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MC44S803:
-		ret = dvb_attach(mc44s803_attach, adap->fe,
+		ret = dvb_attach(mc44s803_attach, adap->fe[0],
 			&adap->dev->i2c_adap,
 			&af9015_mc44s803_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5007T:
-		ret = dvb_attach(mxl5007t_attach, adap->fe,
+		ret = dvb_attach(mxl5007t_attach, adap->fe[0],
 			&adap->dev->i2c_adap,
 			0xc0, &af9015_mxl5007t_config) == NULL ? -ENODEV : 0;
 		break;
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 2cbf19a..1ec88b6 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -488,13 +488,13 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 		/* E30 */
 
 		/* attach demod */
-		adap->fe = dvb_attach(mt352_attach, &anysee_mt352_config,
+		adap->fe[0] = dvb_attach(mt352_attach, &anysee_mt352_config,
 			&adap->dev->i2c_adap);
-		if (adap->fe)
+		if (adap->fe[0])
 			break;
 
 		/* attach demod */
-		adap->fe = dvb_attach(zl10353_attach, &anysee_zl10353_config,
+		adap->fe[0] = dvb_attach(zl10353_attach, &anysee_zl10353_config,
 			&adap->dev->i2c_adap);
 
 		break;
@@ -512,7 +512,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach demod */
-		adap->fe = dvb_attach(zl10353_attach, &anysee_zl10353_config,
+		adap->fe[0] = dvb_attach(zl10353_attach, &anysee_zl10353_config,
 			&adap->dev->i2c_adap);
 
 		break;
@@ -525,7 +525,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach demod */
-		adap->fe = dvb_attach(tda10023_attach, &anysee_tda10023_config,
+		adap->fe[0] = dvb_attach(tda10023_attach, &anysee_tda10023_config,
 			&adap->dev->i2c_adap, 0x48);
 
 		break;
@@ -538,7 +538,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach demod */
-		adap->fe = dvb_attach(cx24116_attach, &anysee_cx24116_config,
+		adap->fe[0] = dvb_attach(cx24116_attach, &anysee_cx24116_config,
 			&adap->dev->i2c_adap);
 
 		break;
@@ -580,12 +580,12 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 			/* attach demod */
 			if (tmp == 0xc7) {
 				/* TDA18212 config */
-				adap->fe = dvb_attach(zl10353_attach,
+				adap->fe[0] = dvb_attach(zl10353_attach,
 					&anysee_zl10353_tda18212_config2,
 					&adap->dev->i2c_adap);
 			} else {
 				/* PLL config */
-				adap->fe = dvb_attach(zl10353_attach,
+				adap->fe[0] = dvb_attach(zl10353_attach,
 					&anysee_zl10353_config,
 					&adap->dev->i2c_adap);
 			}
@@ -605,12 +605,12 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 			/* attach demod */
 			if (tmp == 0xc7) {
 				/* TDA18212 config */
-				adap->fe = dvb_attach(tda10023_attach,
+				adap->fe[0] = dvb_attach(tda10023_attach,
 					&anysee_tda10023_tda18212_config,
 					&adap->dev->i2c_adap, 0x48);
 			} else {
 				/* PLL config */
-				adap->fe = dvb_attach(tda10023_attach,
+				adap->fe[0] = dvb_attach(tda10023_attach,
 					&anysee_tda10023_config,
 					&adap->dev->i2c_adap, 0x48);
 			}
@@ -647,7 +647,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 				goto error;
 
 			/* attach demod */
-			adap->fe = dvb_attach(zl10353_attach,
+			adap->fe[0] = dvb_attach(zl10353_attach,
 				&anysee_zl10353_tda18212_config,
 				&adap->dev->i2c_adap);
 		} else {
@@ -670,7 +670,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 				goto error;
 
 			/* attach demod */
-			adap->fe = dvb_attach(tda10023_attach,
+			adap->fe[0] = dvb_attach(tda10023_attach,
 				&anysee_tda10023_tda18212_config,
 				&adap->dev->i2c_adap, 0x48);
 		}
@@ -692,13 +692,13 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach demod */
-		adap->fe = dvb_attach(stv0900_attach, &anysee_stv0900_config,
+		adap->fe[0] = dvb_attach(stv0900_attach, &anysee_stv0900_config,
 			&adap->dev->i2c_adap, 0);
 
 		break;
 	}
 
-	if (!adap->fe) {
+	if (!adap->fe[0]) {
 		/* we have no frontend :-( */
 		ret = -ENODEV;
 		err("Unsupported Anysee version. " \
@@ -720,7 +720,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 		/* E30 */
 
 		/* attach tuner */
-		fe = dvb_attach(dvb_pll_attach, adap->fe, (0xc2 >> 1),
+		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc2 >> 1),
 			NULL, DVB_PLL_THOMSON_DTT7579);
 
 		break;
@@ -728,7 +728,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 		/* E30 Plus */
 
 		/* attach tuner */
-		fe = dvb_attach(dvb_pll_attach, adap->fe, (0xc2 >> 1),
+		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc2 >> 1),
 			&adap->dev->i2c_adap, DVB_PLL_THOMSON_DTT7579);
 
 		break;
@@ -736,7 +736,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 		/* E30 C Plus */
 
 		/* attach tuner */
-		fe = dvb_attach(dvb_pll_attach, adap->fe, (0xc0 >> 1),
+		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc0 >> 1),
 			&adap->dev->i2c_adap, DVB_PLL_SAMSUNG_DTOS403IH102A);
 
 		break;
@@ -744,7 +744,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 		/* E30 S2 Plus */
 
 		/* attach LNB controller */
-		fe = dvb_attach(isl6423_attach, adap->fe, &adap->dev->i2c_adap,
+		fe = dvb_attach(isl6423_attach, adap->fe[0], &adap->dev->i2c_adap,
 			&anysee_isl6423_config);
 
 		break;
@@ -775,7 +775,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe, &adap->dev->i2c_adap,
+		fe = dvb_attach(tda18212_attach, adap->fe[0], &adap->dev->i2c_adap,
 			&anysee_tda18212_config);
 		if (fe)
 			break;
@@ -786,7 +786,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach tuner */
-		fe = dvb_attach(dvb_pll_attach, adap->fe, (0xc0 >> 1),
+		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc0 >> 1),
 			&adap->dev->i2c_adap, DVB_PLL_SAMSUNG_DTOS403IH102A);
 
 		break;
@@ -801,7 +801,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe, &adap->dev->i2c_adap,
+		fe = dvb_attach(tda18212_attach, adap->fe[0], &adap->dev->i2c_adap,
 			&anysee_tda18212_config);
 
 		break;
@@ -811,12 +811,12 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 		/* E7 PS2 */
 
 		/* attach tuner */
-		fe = dvb_attach(stv6110_attach, adap->fe,
+		fe = dvb_attach(stv6110_attach, adap->fe[0],
 			&anysee_stv6110_config, &adap->dev->i2c_adap);
 
 		if (fe) {
 			/* attach LNB controller */
-			fe = dvb_attach(isl6423_attach, adap->fe,
+			fe = dvb_attach(isl6423_attach, adap->fe[0],
 				&adap->dev->i2c_adap, &anysee_isl6423_config);
 		}
 
diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
index 2351077..ebe6e1f 100644
--- a/drivers/media/dvb/dvb-usb/au6610.c
+++ b/drivers/media/dvb/dvb-usb/au6610.c
@@ -140,9 +140,9 @@ static struct zl10353_config au6610_zl10353_config = {
 
 static int au6610_zl10353_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe = dvb_attach(zl10353_attach, &au6610_zl10353_config,
+	adap->fe[0] = dvb_attach(zl10353_attach, &au6610_zl10353_config,
 		&adap->dev->i2c_adap);
-	if (adap->fe == NULL)
+	if (adap->fe[0] == NULL)
 		return -ENODEV;
 
 	return 0;
@@ -155,7 +155,7 @@ static struct qt1010_config au6610_qt1010_config = {
 static int au6610_qt1010_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	return dvb_attach(qt1010_attach,
-			  adap->fe, &adap->dev->i2c_adap,
+			  adap->fe[0], &adap->dev->i2c_adap,
 			  &au6610_qt1010_config) == NULL ? -ENODEV : 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 57e2444..d59430c 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -910,16 +910,16 @@ static int az6027_frontend_attach(struct dvb_usb_adapter *adap)
 	az6027_frontend_reset(adap);
 
 	deb_info("adap = %p, dev = %p\n", adap, adap->dev);
-	adap->fe = stb0899_attach(&az6027_stb0899_config, &adap->dev->i2c_adap);
+	adap->fe[0] = stb0899_attach(&az6027_stb0899_config, &adap->dev->i2c_adap);
 
-	if (adap->fe) {
+	if (adap->fe[0]) {
 		deb_info("found STB0899 DVB-S/DVB-S2 frontend @0x%02x", az6027_stb0899_config.demod_address);
-		if (stb6100_attach(adap->fe, &az6027_stb6100_config, &adap->dev->i2c_adap)) {
+		if (stb6100_attach(adap->fe[0], &az6027_stb6100_config, &adap->dev->i2c_adap)) {
 			deb_info("found STB6100 DVB-S/DVB-S2 frontend @0x%02x", az6027_stb6100_config.tuner_address);
-			adap->fe->ops.set_voltage = az6027_set_voltage;
+			adap->fe[0]->ops.set_voltage = az6027_set_voltage;
 			az6027_ci_init(adap);
 		} else {
-			adap->fe = NULL;
+			adap->fe[0] = NULL;
 		}
 	} else
 		warn("no front-end attached\n");
diff --git a/drivers/media/dvb/dvb-usb/ce6230.c b/drivers/media/dvb/dvb-usb/ce6230.c
index 6d1a304..5655ce4 100644
--- a/drivers/media/dvb/dvb-usb/ce6230.c
+++ b/drivers/media/dvb/dvb-usb/ce6230.c
@@ -186,9 +186,9 @@ static struct zl10353_config ce6230_zl10353_config = {
 static int ce6230_zl10353_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	deb_info("%s:\n", __func__);
-	adap->fe = dvb_attach(zl10353_attach, &ce6230_zl10353_config,
+	adap->fe[0] = dvb_attach(zl10353_attach, &ce6230_zl10353_config,
 		&adap->dev->i2c_adap);
-	if (adap->fe == NULL)
+	if (adap->fe[0] == NULL)
 		return -ENODEV;
 	return 0;
 }
@@ -214,7 +214,7 @@ static int ce6230_mxl5003s_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
 	deb_info("%s:\n", __func__);
-	ret = dvb_attach(mxl5005s_attach, adap->fe, &adap->dev->i2c_adap,
+	ret = dvb_attach(mxl5005s_attach, adap->fe[0], &adap->dev->i2c_adap,
 			&ce6230_mxl5003s_config) == NULL ? -ENODEV : 0;
 	return ret;
 }
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
index 16f2ce2..0dd42bd 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
@@ -69,7 +69,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 	char state[3];
 	int ret;
 
-	adap->fe = cinergyt2_fe_attach(adap->dev);
+	adap->fe[0] = cinergyt2_fe_attach(adap->dev);
 
 	ret = dvb_usb_generic_rw(adap->dev, query, sizeof(query), state,
 				sizeof(state), 0);
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index acb5fb2..a76f431 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -725,7 +725,7 @@ static struct max2165_config mygica_d689_max2165_cfg = {
 /* Callbacks for DVB USB */
 static int cxusb_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(simple_tuner_attach, adap->fe,
+	dvb_attach(simple_tuner_attach, adap->fe[0],
 		   &adap->dev->i2c_adap, 0x61,
 		   TUNER_PHILIPS_FMD1216ME_MK3);
 	return 0;
@@ -733,27 +733,27 @@ static int cxusb_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
 
 static int cxusb_dee1601_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(dvb_pll_attach, adap->fe, 0x61,
+	dvb_attach(dvb_pll_attach, adap->fe[0], 0x61,
 		   NULL, DVB_PLL_THOMSON_DTT7579);
 	return 0;
 }
 
 static int cxusb_lgz201_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(dvb_pll_attach, adap->fe, 0x61, NULL, DVB_PLL_LG_Z201);
+	dvb_attach(dvb_pll_attach, adap->fe[0], 0x61, NULL, DVB_PLL_LG_Z201);
 	return 0;
 }
 
 static int cxusb_dtt7579_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(dvb_pll_attach, adap->fe, 0x60,
+	dvb_attach(dvb_pll_attach, adap->fe[0], 0x60,
 		   NULL, DVB_PLL_THOMSON_DTT7579);
 	return 0;
 }
 
 static int cxusb_lgh064f_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(simple_tuner_attach, adap->fe,
+	dvb_attach(simple_tuner_attach, adap->fe[0],
 		   &adap->dev->i2c_adap, 0x61, TUNER_LG_TDVS_H06XF);
 	return 0;
 }
@@ -795,9 +795,9 @@ static int cxusb_dvico_xc3028_tuner_attach(struct dvb_usb_adapter *adap)
 	};
 
 	/* FIXME: generalize & move to common area */
-	adap->fe->callback = dvico_bluebird_xc2028_callback;
+	adap->fe[0]->callback = dvico_bluebird_xc2028_callback;
 
-	fe = dvb_attach(xc2028_attach, adap->fe, &cfg);
+	fe = dvb_attach(xc2028_attach, adap->fe[0], &cfg);
 	if (fe == NULL || fe->ops.tuner_ops.set_config == NULL)
 		return -EIO;
 
@@ -808,7 +808,7 @@ static int cxusb_dvico_xc3028_tuner_attach(struct dvb_usb_adapter *adap)
 
 static int cxusb_mxl5003s_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(mxl5005s_attach, adap->fe,
+	dvb_attach(mxl5005s_attach, adap->fe[0],
 		   &adap->dev->i2c_adap, &aver_a868r_tuner);
 	return 0;
 }
@@ -816,7 +816,7 @@ static int cxusb_mxl5003s_tuner_attach(struct dvb_usb_adapter *adap)
 static int cxusb_d680_dmb_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_frontend *fe;
-	fe = dvb_attach(mxl5005s_attach, adap->fe,
+	fe = dvb_attach(mxl5005s_attach, adap->fe[0],
 			&adap->dev->i2c_adap, &d680_dmb_tuner);
 	return (fe == NULL) ? -EIO : 0;
 }
@@ -824,7 +824,7 @@ static int cxusb_d680_dmb_tuner_attach(struct dvb_usb_adapter *adap)
 static int cxusb_mygica_d689_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_frontend *fe;
-	fe = dvb_attach(max2165_attach, adap->fe,
+	fe = dvb_attach(max2165_attach, adap->fe[0],
 			&adap->dev->i2c_adap, &mygica_d689_max2165_cfg);
 	return (fe == NULL) ? -EIO : 0;
 }
@@ -837,7 +837,7 @@ static int cxusb_cx22702_frontend_attach(struct dvb_usb_adapter *adap)
 
 	cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, &b, 1);
 
-	if ((adap->fe = dvb_attach(cx22702_attach, &cxusb_cx22702_config,
+	if ((adap->fe[0] = dvb_attach(cx22702_attach, &cxusb_cx22702_config,
 				   &adap->dev->i2c_adap)) != NULL)
 		return 0;
 
@@ -851,7 +851,7 @@ static int cxusb_lgdt3303_frontend_attach(struct dvb_usb_adapter *adap)
 
 	cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, NULL, 0);
 
-	if ((adap->fe = dvb_attach(lgdt330x_attach, &cxusb_lgdt3303_config,
+	if ((adap->fe[0] = dvb_attach(lgdt330x_attach, &cxusb_lgdt3303_config,
 				   &adap->dev->i2c_adap)) != NULL)
 		return 0;
 
@@ -860,9 +860,9 @@ static int cxusb_lgdt3303_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int cxusb_aver_lgdt3303_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe = dvb_attach(lgdt330x_attach, &cxusb_aver_lgdt3303_config,
+	adap->fe[0] = dvb_attach(lgdt330x_attach, &cxusb_aver_lgdt3303_config,
 			      &adap->dev->i2c_adap);
-	if (adap->fe != NULL)
+	if (adap->fe[0] != NULL)
 		return 0;
 
 	return -EIO;
@@ -876,7 +876,7 @@ static int cxusb_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 
 	cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, NULL, 0);
 
-	if ((adap->fe = dvb_attach(mt352_attach, &cxusb_mt352_config,
+	if ((adap->fe[0] = dvb_attach(mt352_attach, &cxusb_mt352_config,
 				   &adap->dev->i2c_adap)) != NULL)
 		return 0;
 
@@ -890,9 +890,9 @@ static int cxusb_dee1601_frontend_attach(struct dvb_usb_adapter *adap)
 
 	cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, NULL, 0);
 
-	if (((adap->fe = dvb_attach(mt352_attach, &cxusb_dee1601_config,
+	if (((adap->fe[0] = dvb_attach(mt352_attach, &cxusb_dee1601_config,
 				    &adap->dev->i2c_adap)) != NULL) ||
-		((adap->fe = dvb_attach(zl10353_attach,
+		((adap->fe[0] = dvb_attach(zl10353_attach,
 					&cxusb_zl10353_dee1601_config,
 					&adap->dev->i2c_adap)) != NULL))
 		return 0;
@@ -917,7 +917,7 @@ static int cxusb_dualdig4_frontend_attach(struct dvb_usb_adapter *adap)
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x01, 1);
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
 
-	if ((adap->fe = dvb_attach(zl10353_attach,
+	if ((adap->fe[0] = dvb_attach(zl10353_attach,
 				   &cxusb_zl10353_xc3028_config_no_i2c_gate,
 				   &adap->dev->i2c_adap)) == NULL)
 		return -EIO;
@@ -1031,9 +1031,9 @@ static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
 			      &cxusb_dualdig4_rev2_config);
-	if (adap->fe == NULL)
+	if (adap->fe[0] == NULL)
 		return -EIO;
 
 	return 0;
@@ -1084,15 +1084,15 @@ static int cxusb_dualdig4_rev2_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
 	struct i2c_adapter *tun_i2c =
-		dib7000p_get_i2c_master(adap->fe,
+		dib7000p_get_i2c_master(adap->fe[0],
 					DIBX000_I2C_INTERFACE_TUNER, 1);
 
-	if (dvb_attach(dib0070_attach, adap->fe, tun_i2c,
+	if (dvb_attach(dib0070_attach, adap->fe[0], tun_i2c,
 	    &dib7070p_dib0070_config) == NULL)
 		return -ENODEV;
 
-	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	adap->fe->ops.tuner_ops.set_params = dib7070_set_param_override;
+	st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	adap->fe[0]->ops.tuner_ops.set_params = dib7070_set_param_override;
 	return 0;
 }
 
@@ -1108,12 +1108,12 @@ static int cxusb_nano2_frontend_attach(struct dvb_usb_adapter *adap)
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x01, 1);
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
 
-	if ((adap->fe = dvb_attach(zl10353_attach,
+	if ((adap->fe[0] = dvb_attach(zl10353_attach,
 				   &cxusb_zl10353_xc3028_config,
 				   &adap->dev->i2c_adap)) != NULL)
 		return 0;
 
-	if ((adap->fe = dvb_attach(mt352_attach,
+	if ((adap->fe[0] = dvb_attach(mt352_attach,
 				   &cxusb_mt352_xc3028_config,
 				   &adap->dev->i2c_adap)) != NULL)
 		return 0;
@@ -1172,8 +1172,8 @@ static int cxusb_d680_dmb_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(100);
 
 	/* Attach frontend */
-	adap->fe = dvb_attach(lgs8gxx_attach, &d680_lgs8gl5_cfg, &d->i2c_adap);
-	if (adap->fe == NULL)
+	adap->fe[0] = dvb_attach(lgs8gxx_attach, &d680_lgs8gl5_cfg, &d->i2c_adap);
+	if (adap->fe[0] == NULL)
 		return -EIO;
 
 	return 0;
@@ -1223,9 +1223,9 @@ static int cxusb_mygica_d689_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(100);
 
 	/* Attach frontend */
-	adap->fe = dvb_attach(atbm8830_attach, &mygica_d689_atbm8830_cfg,
+	adap->fe[0] = dvb_attach(atbm8830_attach, &mygica_d689_atbm8830_cfg,
 		&d->i2c_adap);
-	if (adap->fe == NULL)
+	if (adap->fe[0] == NULL)
 		return -EIO;
 
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index d0ea5b6..754f8ec 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -101,7 +101,7 @@ static int bristol_frontend_attach(struct dvb_usb_adapter *adap)
 		}
 	}
 	st->mt2060_if1[adap->id] = 1220;
-	return (adap->fe = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap,
+	return (adap->fe[0] = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap,
 		(10 + adap->id) << 1, &bristol_dib3000mc_config[adap->id])) == NULL ? -ENODEV : 0;
 }
 
@@ -118,14 +118,14 @@ static int eeprom_read(struct i2c_adapter *adap,u8 adrs,u8 *pval)
 static int bristol_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct i2c_adapter *prim_i2c = &adap->dev->i2c_adap;
-	struct i2c_adapter *tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe, 1);
+	struct i2c_adapter *tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe[0], 1);
 	s8 a;
 	int if1=1220;
 	if (adap->dev->udev->descriptor.idVendor  == cpu_to_le16(USB_VID_HAUPPAUGE) &&
 		adap->dev->udev->descriptor.idProduct == cpu_to_le16(USB_PID_HAUPPAUGE_NOVA_T_500_2)) {
 		if (!eeprom_read(prim_i2c,0x59 + adap->id,&a)) if1=1220+a;
 	}
-	return dvb_attach(mt2060_attach,adap->fe, tun_i2c,&bristol_mt2060_config[adap->id],
+	return dvb_attach(mt2060_attach,adap->fe[0], tun_i2c,&bristol_mt2060_config[adap->id],
 		if1) == NULL ? -ENODEV : 0;
 }
 
@@ -279,10 +279,10 @@ static int stk7700P2_frontend_attach(struct dvb_usb_adapter *adap)
 		}
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
 				&stk7700d_dib7000p_mt2266_config[adap->id]);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
@@ -306,17 +306,17 @@ static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
 		}
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
 				&stk7700d_dib7000p_mt2266_config[adap->id]);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static int stk7700d_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct i2c_adapter *tun_i2c;
-	tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
-	return dvb_attach(mt2266_attach, adap->fe, tun_i2c,
+	tun_i2c = dib7000p_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_TUNER, 1);
+	return dvb_attach(mt2266_attach, adap->fe[0], tun_i2c,
 		&stk7700d_mt2266_config[adap->id]) == NULL ? -ENODEV : 0;
 }
 
@@ -396,8 +396,8 @@ static int stk7700ph_xc3028_callback(void *ptr, int component,
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		/* Send the tuner in then out of reset */
-		dib7000p_set_gpio(adap->fe, 8, 0, 0); msleep(10);
-		dib7000p_set_gpio(adap->fe, 8, 0, 1);
+		dib7000p_set_gpio(adap->fe[0], 8, 0, 0); msleep(10);
+		dib7000p_set_gpio(adap->fe[0], 8, 0, 1);
 		break;
 	case XC2028_RESET_CLK:
 		break;
@@ -447,25 +447,25 @@ static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
 		&stk7700ph_dib7700_xc3028_config);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static int stk7700ph_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct i2c_adapter *tun_i2c;
 
-	tun_i2c = dib7000p_get_i2c_master(adap->fe,
+	tun_i2c = dib7000p_get_i2c_master(adap->fe[0],
 		DIBX000_I2C_INTERFACE_TUNER, 1);
 
 	stk7700ph_xc3028_config.i2c_adap = tun_i2c;
 
 	/* FIXME: generalize & move to common area */
-	adap->fe->callback = stk7700ph_xc3028_callback;
+	adap->fe[0]->callback = stk7700ph_xc3028_callback;
 
-	return dvb_attach(xc2028_attach, adap->fe, &stk7700ph_xc3028_config)
+	return dvb_attach(xc2028_attach, adap->fe[0], &stk7700ph_xc3028_config)
 		== NULL ? -ENODEV : 0;
 }
 
@@ -685,12 +685,12 @@ static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
 	st->mt2060_if1[0] = 1220;
 
 	if (dib7000pc_detection(&adap->dev->i2c_adap)) {
-		adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
+		adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
 		st->is_dib7000pc = 1;
 	} else
-		adap->fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
+		adap->fe[0] = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static struct mt2060_config stk7700p_mt2060_config = {
@@ -709,11 +709,11 @@ static int stk7700p_tuner_attach(struct dvb_usb_adapter *adap)
 		if (!eeprom_read(prim_i2c,0x58,&a)) if1=1220+a;
 	}
 	if (st->is_dib7000pc)
-		tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+		tun_i2c = dib7000p_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_TUNER, 1);
 	else
-		tun_i2c = dib7000m_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+		tun_i2c = dib7000m_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_TUNER, 1);
 
-	return dvb_attach(mt2060_attach, adap->fe, tun_i2c, &stk7700p_mt2060_config,
+	return dvb_attach(mt2060_attach, adap->fe[0], tun_i2c, &stk7700p_mt2060_config,
 		if1) == NULL ? -ENODEV : 0;
 }
 
@@ -843,33 +843,33 @@ static int dib7770_set_param_override(struct dvb_frontend *fe,
 static int dib7770p_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	 struct dib0700_adapter_state *st = adap->priv;
-	 struct i2c_adapter *tun_i2c = dib7000p_get_i2c_master(adap->fe,
+	 struct i2c_adapter *tun_i2c = dib7000p_get_i2c_master(adap->fe[0],
 			 DIBX000_I2C_INTERFACE_TUNER, 1);
 
-	 if (dvb_attach(dib0070_attach, adap->fe, tun_i2c,
+	 if (dvb_attach(dib0070_attach, adap->fe[0], tun_i2c,
 				 &dib7770p_dib0070_config) == NULL)
 		 return -ENODEV;
 
-	 st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	 adap->fe->ops.tuner_ops.set_params = dib7770_set_param_override;
+	 st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	 adap->fe[0]->ops.tuner_ops.set_params = dib7770_set_param_override;
 	 return 0;
 }
 
 static int dib7070p_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+	struct i2c_adapter *tun_i2c = dib7000p_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_TUNER, 1);
 
 	if (adap->id == 0) {
-		if (dvb_attach(dib0070_attach, adap->fe, tun_i2c, &dib7070p_dib0070_config[0]) == NULL)
+		if (dvb_attach(dib0070_attach, adap->fe[0], tun_i2c, &dib7070p_dib0070_config[0]) == NULL)
 			return -ENODEV;
 	} else {
-		if (dvb_attach(dib0070_attach, adap->fe, tun_i2c, &dib7070p_dib0070_config[1]) == NULL)
+		if (dvb_attach(dib0070_attach, adap->fe[0], tun_i2c, &dib7070p_dib0070_config[1]) == NULL)
 			return -ENODEV;
 	}
 
-	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	adap->fe->ops.tuner_ops.set_params = dib7070_set_param_override;
+	st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	adap->fe[0]->ops.tuner_ops.set_params = dib7070_set_param_override;
 	return 0;
 }
 
@@ -878,26 +878,26 @@ static int stk7700p_pid_filter(struct dvb_usb_adapter *adapter, int index,
 {
 	struct dib0700_state *st = adapter->dev->priv;
 	if (st->is_dib7000pc)
-		return dib7000p_pid_filter(adapter->fe, index, pid, onoff);
-	return dib7000m_pid_filter(adapter->fe, index, pid, onoff);
+		return dib7000p_pid_filter(adapter->fe[0], index, pid, onoff);
+	return dib7000m_pid_filter(adapter->fe[0], index, pid, onoff);
 }
 
 static int stk7700p_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
 {
 	struct dib0700_state *st = adapter->dev->priv;
 	if (st->is_dib7000pc)
-		return dib7000p_pid_filter_ctrl(adapter->fe, onoff);
-	return dib7000m_pid_filter_ctrl(adapter->fe, onoff);
+		return dib7000p_pid_filter_ctrl(adapter->fe[0], onoff);
+	return dib7000m_pid_filter_ctrl(adapter->fe[0], onoff);
 }
 
 static int stk70x0p_pid_filter(struct dvb_usb_adapter *adapter, int index, u16 pid, int onoff)
 {
-    return dib7000p_pid_filter(adapter->fe, index, pid, onoff);
+    return dib7000p_pid_filter(adapter->fe[0], index, pid, onoff);
 }
 
 static int stk70x0p_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
 {
-    return dib7000p_pid_filter_ctrl(adapter->fe, onoff);
+    return dib7000p_pid_filter_ctrl(adapter->fe[0], onoff);
 }
 
 static struct dibx000_bandwidth_config dib7070_bw_config_12_mhz = {
@@ -955,9 +955,9 @@ static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
 		&dib7070p_dib7000p_config);
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 /* STK7770P */
@@ -1007,9 +1007,9 @@ static int stk7770p_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
 		&dib7770p_dib7000p_config);
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 /* DIB807x generic */
@@ -1225,34 +1225,34 @@ static int dib807x_set_param_override(struct dvb_frontend *fe,
 static int dib807x_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib8000_get_i2c_master(adap->fe,
+	struct i2c_adapter *tun_i2c = dib8000_get_i2c_master(adap->fe[0],
 			DIBX000_I2C_INTERFACE_TUNER, 1);
 
 	if (adap->id == 0) {
-		if (dvb_attach(dib0070_attach, adap->fe, tun_i2c,
+		if (dvb_attach(dib0070_attach, adap->fe[0], tun_i2c,
 				&dib807x_dib0070_config[0]) == NULL)
 			return -ENODEV;
 	} else {
-		if (dvb_attach(dib0070_attach, adap->fe, tun_i2c,
+		if (dvb_attach(dib0070_attach, adap->fe[0], tun_i2c,
 				&dib807x_dib0070_config[1]) == NULL)
 			return -ENODEV;
 	}
 
-	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	adap->fe->ops.tuner_ops.set_params = dib807x_set_param_override;
+	st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	adap->fe[0]->ops.tuner_ops.set_params = dib807x_set_param_override;
 	return 0;
 }
 
 static int stk80xx_pid_filter(struct dvb_usb_adapter *adapter, int index,
 	u16 pid, int onoff)
 {
-	return dib8000_pid_filter(adapter->fe, index, pid, onoff);
+	return dib8000_pid_filter(adapter->fe[0], index, pid, onoff);
 }
 
 static int stk80xx_pid_filter_ctrl(struct dvb_usb_adapter *adapter,
 		int onoff)
 {
-	return dib8000_pid_filter_ctrl(adapter->fe, onoff);
+	return dib8000_pid_filter_ctrl(adapter->fe[0], onoff);
 }
 
 /* STK807x */
@@ -1276,10 +1276,10 @@ static int stk807x_frontend_attach(struct dvb_usb_adapter *adap)
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
 				0x80);
 
-	adap->fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe[0] = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80,
 			      &dib807x_dib8000_config[0]);
 
-	return adap->fe == NULL ?  -ENODEV : 0;
+	return adap->fe[0] == NULL ?  -ENODEV : 0;
 }
 
 /* STK807xPVR */
@@ -1305,10 +1305,10 @@ static int stk807xpvr_frontend_attach0(struct dvb_usb_adapter *adap)
 	/* initialize IC 0 */
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x22, 0x80);
 
-	adap->fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80,
+	adap->fe[0] = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80,
 			      &dib807x_dib8000_config[0]);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static int stk807xpvr_frontend_attach1(struct dvb_usb_adapter *adap)
@@ -1316,10 +1316,10 @@ static int stk807xpvr_frontend_attach1(struct dvb_usb_adapter *adap)
 	/* initialize IC 1 */
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x12, 0x82);
 
-	adap->fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x82,
+	adap->fe[0] = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x82,
 			      &dib807x_dib8000_config[1]);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 /* STK8096GP */
@@ -1546,13 +1546,13 @@ static int dib8096_set_param_override(struct dvb_frontend *fe,
 static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib8000_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+	struct i2c_adapter *tun_i2c = dib8000_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_TUNER, 1);
 
-	if (dvb_attach(dib0090_register, adap->fe, tun_i2c, &dib809x_dib0090_config) == NULL)
+	if (dvb_attach(dib0090_register, adap->fe[0], tun_i2c, &dib809x_dib0090_config) == NULL)
 		return -ENODEV;
 
-	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	adap->fe->ops.tuner_ops.set_params = dib8096_set_param_override;
+	st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	adap->fe[0]->ops.tuner_ops.set_params = dib8096_set_param_override;
 	return 0;
 }
 
@@ -1575,30 +1575,30 @@ static int stk809x_frontend_attach(struct dvb_usb_adapter *adap)
 
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 18, 0x80);
 
-	adap->fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
+	adap->fe[0] = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
 
-	return adap->fe == NULL ?  -ENODEV : 0;
+	return adap->fe[0] == NULL ?  -ENODEV : 0;
 }
 
 static int nim8096md_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
 	struct i2c_adapter *tun_i2c;
-	struct dvb_frontend *fe_slave  = dib8000_get_slave_frontend(adap->fe, 1);
+	struct dvb_frontend *fe_slave  = dib8000_get_slave_frontend(adap->fe[0], 1);
 
 	if (fe_slave) {
 		tun_i2c = dib8000_get_i2c_master(fe_slave, DIBX000_I2C_INTERFACE_TUNER, 1);
 		if (dvb_attach(dib0090_register, fe_slave, tun_i2c, &dib809x_dib0090_config) == NULL)
 			return -ENODEV;
-		fe_slave->dvb = adap->fe->dvb;
+		fe_slave->dvb = adap->fe[0]->dvb;
 		fe_slave->ops.tuner_ops.set_params = dib8096_set_param_override;
 	}
-	tun_i2c = dib8000_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
-	if (dvb_attach(dib0090_register, adap->fe, tun_i2c, &dib809x_dib0090_config) == NULL)
+	tun_i2c = dib8000_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_TUNER, 1);
+	if (dvb_attach(dib0090_register, adap->fe[0], tun_i2c, &dib809x_dib0090_config) == NULL)
 		return -ENODEV;
 
-	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	adap->fe->ops.tuner_ops.set_params = dib8096_set_param_override;
+	st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	adap->fe[0]->ops.tuner_ops.set_params = dib8096_set_param_override;
 
 	return 0;
 }
@@ -1626,12 +1626,12 @@ static int nim8096md_frontend_attach(struct dvb_usb_adapter *adap)
 
 	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 2, 18, 0x80);
 
-	adap->fe = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
-	if (adap->fe == NULL)
+	adap->fe[0] = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
+	if (adap->fe[0] == NULL)
 		return -ENODEV;
 
 	fe_slave = dvb_attach(dib8000_attach, &adap->dev->i2c_adap, 0x82, &dib809x_dib8000_config[1]);
-	dib8000_set_slave_frontend(adap->fe, fe_slave);
+	dib8000_set_slave_frontend(adap->fe[0], fe_slave);
 
 	return fe_slave == NULL ?  -ENODEV : 0;
 }
@@ -1639,12 +1639,12 @@ static int nim8096md_frontend_attach(struct dvb_usb_adapter *adap)
 /* STK9090M */
 static int dib90x0_pid_filter(struct dvb_usb_adapter *adapter, int index, u16 pid, int onoff)
 {
-	return dib9000_fw_pid_filter(adapter->fe, index, pid, onoff);
+	return dib9000_fw_pid_filter(adapter->fe[0], index, pid, onoff);
 }
 
 static int dib90x0_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
 {
-	return dib9000_fw_pid_filter_ctrl(adapter->fe, onoff);
+	return dib9000_fw_pid_filter_ctrl(adapter->fe[0], onoff);
 }
 
 static int dib90x0_tuner_reset(struct dvb_frontend *fe, int onoff)
@@ -1856,15 +1856,15 @@ static int stk9090m_frontend_attach(struct dvb_usb_adapter *adap)
 	stk9090m_config.microcode_B_fe_size = state->frontend_firmware->size;
 	stk9090m_config.microcode_B_fe_buffer = state->frontend_firmware->data;
 
-	adap->fe = dvb_attach(dib9000_attach, &adap->dev->i2c_adap, 0x80, &stk9090m_config);
+	adap->fe[0] = dvb_attach(dib9000_attach, &adap->dev->i2c_adap, 0x80, &stk9090m_config);
 
-	return adap->fe == NULL ?  -ENODEV : 0;
+	return adap->fe[0] == NULL ?  -ENODEV : 0;
 }
 
 static int dib9090_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *state = adap->priv;
-	struct i2c_adapter *i2c = dib9000_get_tuner_interface(adap->fe);
+	struct i2c_adapter *i2c = dib9000_get_tuner_interface(adap->fe[0]);
 	u16 data_dib190[10] = {
 		1, 0x1374,
 		2, 0x01a2,
@@ -1873,13 +1873,13 @@ static int dib9090_tuner_attach(struct dvb_usb_adapter *adap)
 		8, 0x0486,
 	};
 
-	if (dvb_attach(dib0090_fw_register, adap->fe, i2c, &dib9090_dib0090_config) == NULL)
+	if (dvb_attach(dib0090_fw_register, adap->fe[0], i2c, &dib9090_dib0090_config) == NULL)
 		return -ENODEV;
-	i2c = dib9000_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
+	i2c = dib9000_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
 	if (dib01x0_pmu_update(i2c, data_dib190, 10) != 0)
 		return -ENODEV;
 	dib0700_set_i2c_speed(adap->dev, 2000);
-	if (dib9000_firmware_post_pll_init(adap->fe) < 0)
+	if (dib9000_firmware_post_pll_init(adap->fe[0]) < 0)
 		return -ENODEV;
 	release_firmware(state->frontend_firmware);
 	return 0;
@@ -1925,16 +1925,16 @@ static int nim9090md_frontend_attach(struct dvb_usb_adapter *adap)
 	nim9090md_config[1].microcode_B_fe_buffer = state->frontend_firmware->data;
 
 	dib9000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x20, 0x80);
-	adap->fe = dvb_attach(dib9000_attach, &adap->dev->i2c_adap, 0x80, &nim9090md_config[0]);
+	adap->fe[0] = dvb_attach(dib9000_attach, &adap->dev->i2c_adap, 0x80, &nim9090md_config[0]);
 
-	if (adap->fe == NULL)
+	if (adap->fe[0] == NULL)
 		return -ENODEV;
 
-	i2c = dib9000_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_GPIO_3_4, 0);
+	i2c = dib9000_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_GPIO_3_4, 0);
 	dib9000_i2c_enumeration(i2c, 1, 0x12, 0x82);
 
 	fe_slave = dvb_attach(dib9000_attach, i2c, 0x82, &nim9090md_config[1]);
-	dib9000_set_slave_frontend(adap->fe, fe_slave);
+	dib9000_set_slave_frontend(adap->fe[0], fe_slave);
 
 	return fe_slave == NULL ?  -ENODEV : 0;
 }
@@ -1951,26 +1951,26 @@ static int nim9090md_tuner_attach(struct dvb_usb_adapter *adap)
 		0, 0x00ef,
 		8, 0x0406,
 	};
-	i2c = dib9000_get_tuner_interface(adap->fe);
-	if (dvb_attach(dib0090_fw_register, adap->fe, i2c, &nim9090md_dib0090_config[0]) == NULL)
+	i2c = dib9000_get_tuner_interface(adap->fe[0]);
+	if (dvb_attach(dib0090_fw_register, adap->fe[0], i2c, &nim9090md_dib0090_config[0]) == NULL)
 		return -ENODEV;
-	i2c = dib9000_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
+	i2c = dib9000_get_i2c_master(adap->fe[0], DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
 	if (dib01x0_pmu_update(i2c, data_dib190, 10) < 0)
 		return -ENODEV;
 	dib0700_set_i2c_speed(adap->dev, 2000);
-	if (dib9000_firmware_post_pll_init(adap->fe) < 0)
+	if (dib9000_firmware_post_pll_init(adap->fe[0]) < 0)
 		return -ENODEV;
 
-	fe_slave = dib9000_get_slave_frontend(adap->fe, 1);
+	fe_slave = dib9000_get_slave_frontend(adap->fe[0], 1);
 	if (fe_slave != NULL) {
-		i2c = dib9000_get_component_bus_interface(adap->fe);
+		i2c = dib9000_get_component_bus_interface(adap->fe[0]);
 		dib9000_set_i2c_adapter(fe_slave, i2c);
 
 		i2c = dib9000_get_tuner_interface(fe_slave);
 		if (dvb_attach(dib0090_fw_register, fe_slave, i2c, &nim9090md_dib0090_config[1]) == NULL)
 			return -ENODEV;
-		fe_slave->dvb = adap->fe->dvb;
-		dib9000_fw_set_component_bus_speed(adap->fe, 2000);
+		fe_slave->dvb = adap->fe[0]->dvb;
+		dib9000_fw_set_component_bus_speed(adap->fe[0], 2000);
 		if (dib9000_firmware_post_pll_init(fe_slave) < 0)
 			return -ENODEV;
 	}
@@ -2393,23 +2393,23 @@ static int nim7090_frontend_attach(struct dvb_usb_adapter *adap)
 		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n", __func__);
 		return -ENODEV;
 	}
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &nim7090_dib7000p_config);
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &nim7090_dib7000p_config);
 
-	return adap->fe == NULL ?  -ENODEV : 0;
+	return adap->fe[0] == NULL ?  -ENODEV : 0;
 }
 
 static int nim7090_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe);
+	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe[0]);
 
-	if (dvb_attach(dib0090_register, adap->fe, tun_i2c, &nim7090_dib0090_config) == NULL)
+	if (dvb_attach(dib0090_register, adap->fe[0], tun_i2c, &nim7090_dib0090_config) == NULL)
 		return -ENODEV;
 
-	dib7000p_set_gpio(adap->fe, 8, 0, 1);
+	dib7000p_set_gpio(adap->fe[0], 8, 0, 1);
 
-	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	adap->fe->ops.tuner_ops.set_params = dib7090_agc_startup;
+	st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	adap->fe[0]->ops.tuner_ops.set_params = dib7090_agc_startup;
 	return 0;
 }
 
@@ -2439,11 +2439,11 @@ static int tfe7090pvr_frontend0_attach(struct dvb_usb_adapter *adap)
 	}
 
 	dib0700_set_i2c_speed(adap->dev, 340);
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x90, &tfe7090pvr_dib7000p_config[0]);
-	if (adap->fe == NULL)
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x90, &tfe7090pvr_dib7000p_config[0]);
+	if (adap->fe[0] == NULL)
 		return -ENODEV;
 
-	dib7090_slave_reset(adap->fe);
+	dib7090_slave_reset(adap->fe[0]);
 
 	return 0;
 }
@@ -2452,50 +2452,50 @@ static int tfe7090pvr_frontend1_attach(struct dvb_usb_adapter *adap)
 {
 	struct i2c_adapter *i2c;
 
-	if (adap->dev->adapter[0].fe == NULL) {
+	if (adap->dev->adapter[0].fe[0] == NULL) {
 		err("the master dib7090 has to be initialized first");
 		return -ENODEV; /* the master device has not been initialized */
 	}
 
-	i2c = dib7000p_get_i2c_master(adap->dev->adapter[0].fe, DIBX000_I2C_INTERFACE_GPIO_6_7, 1);
+	i2c = dib7000p_get_i2c_master(adap->dev->adapter[0].fe[0], DIBX000_I2C_INTERFACE_GPIO_6_7, 1);
 	if (dib7000p_i2c_enumeration(i2c, 1, 0x10, &tfe7090pvr_dib7000p_config[1]) != 0) {
 		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n", __func__);
 		return -ENODEV;
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, i2c, 0x92, &tfe7090pvr_dib7000p_config[1]);
+	adap->fe[0] = dvb_attach(dib7000p_attach, i2c, 0x92, &tfe7090pvr_dib7000p_config[1]);
 	dib0700_set_i2c_speed(adap->dev, 200);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static int tfe7090pvr_tuner0_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe);
+	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe[0]);
 
-	if (dvb_attach(dib0090_register, adap->fe, tun_i2c, &tfe7090pvr_dib0090_config[0]) == NULL)
+	if (dvb_attach(dib0090_register, adap->fe[0], tun_i2c, &tfe7090pvr_dib0090_config[0]) == NULL)
 		return -ENODEV;
 
-	dib7000p_set_gpio(adap->fe, 8, 0, 1);
+	dib7000p_set_gpio(adap->fe[0], 8, 0, 1);
 
-	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	adap->fe->ops.tuner_ops.set_params = dib7090_agc_startup;
+	st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	adap->fe[0]->ops.tuner_ops.set_params = dib7090_agc_startup;
 	return 0;
 }
 
 static int tfe7090pvr_tuner1_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe);
+	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe[0]);
 
-	if (dvb_attach(dib0090_register, adap->fe, tun_i2c, &tfe7090pvr_dib0090_config[1]) == NULL)
+	if (dvb_attach(dib0090_register, adap->fe[0], tun_i2c, &tfe7090pvr_dib0090_config[1]) == NULL)
 		return -ENODEV;
 
-	dib7000p_set_gpio(adap->fe, 8, 0, 1);
+	dib7000p_set_gpio(adap->fe[0], 8, 0, 1);
 
-	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
-	adap->fe->ops.tuner_ops.set_params = dib7090_agc_startup;
+	st->set_param_save = adap->fe[0]->ops.tuner_ops.set_params;
+	adap->fe[0]->ops.tuner_ops.set_params = dib7090_agc_startup;
 	return 0;
 }
 
@@ -2555,14 +2555,14 @@ static int stk7070pd_frontend_attach0(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &stk7070pd_dib7000p_config[0]);
-	return adap->fe == NULL ? -ENODEV : 0;
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &stk7070pd_dib7000p_config[0]);
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
 {
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x82, &stk7070pd_dib7000p_config[1]);
-	return adap->fe == NULL ? -ENODEV : 0;
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x82, &stk7070pd_dib7000p_config[1]);
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 /* S5H1411 */
@@ -2617,9 +2617,9 @@ static int s5h1411_frontend_attach(struct dvb_usb_adapter *adap)
 	dib0700_set_gpio(adap->dev, GPIO2, GPIO_OUT, 1);
 
 	/* GPIOs are initialized, do the attach */
-	adap->fe = dvb_attach(s5h1411_attach, &pinnacle_801e_config,
+	adap->fe[0] = dvb_attach(s5h1411_attach, &pinnacle_801e_config,
 			      &adap->dev->i2c_adap);
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static int dib0700_xc5000_tuner_callback(void *priv, int component,
@@ -2649,9 +2649,9 @@ static struct xc5000_config s5h1411_xc5000_tunerconfig = {
 static int xc5000_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	/* FIXME: generalize & move to common area */
-	adap->fe->callback = dib0700_xc5000_tuner_callback;
+	adap->fe[0]->callback = dib0700_xc5000_tuner_callback;
 
-	return dvb_attach(xc5000_attach, adap->fe, &adap->dev->i2c_adap,
+	return dvb_attach(xc5000_attach, adap->fe[0], &adap->dev->i2c_adap,
 			  &s5h1411_xc5000_tunerconfig)
 		== NULL ? -ENODEV : 0;
 }
@@ -2663,9 +2663,9 @@ static int dib0700_xc4000_tuner_callback(void *priv, int component,
 
 	if (command == XC4000_TUNER_RESET) {
 		/* Reset the tuner */
-		dib7000p_set_gpio(adap->fe, 8, 0, 0);
+		dib7000p_set_gpio(adap->fe[0], 8, 0, 0);
 		msleep(10);
-		dib7000p_set_gpio(adap->fe, 8, 0, 1);
+		dib7000p_set_gpio(adap->fe[0], 8, 0, 1);
 	} else {
 		err("xc4000: unknown tuner callback command: %d\n", command);
 		return -EINVAL;
@@ -2771,11 +2771,11 @@ static int pctv340e_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x12,
+	adap->fe[0] = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x12,
 			      &pctv_340e_config);
 	st->is_dib7000pc = 1;
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static struct xc4000_config dib7000p_xc4000_tunerconfig = {
@@ -2791,7 +2791,7 @@ static int xc4000_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *tun_i2c;
 
 	/* The xc4000 is not on the main i2c bus */
-	tun_i2c = dib7000p_get_i2c_master(adap->fe,
+	tun_i2c = dib7000p_get_i2c_master(adap->fe[0],
 					  DIBX000_I2C_INTERFACE_TUNER, 1);
 	if (tun_i2c == NULL) {
 		printk(KERN_ERR "Could not reach tuner i2c bus\n");
@@ -2799,9 +2799,9 @@ static int xc4000_tuner_attach(struct dvb_usb_adapter *adap)
 	}
 
 	/* Setup the reset callback */
-	adap->fe->callback = dib0700_xc4000_tuner_callback;
+	adap->fe[0]->callback = dib0700_xc4000_tuner_callback;
 
-	return dvb_attach(xc4000_attach, adap->fe, tun_i2c,
+	return dvb_attach(xc4000_attach, adap->fe[0], tun_i2c,
 			  &dib7000p_xc4000_tunerconfig)
 		== NULL ? -ENODEV : 0;
 }
@@ -2857,16 +2857,16 @@ static int lgdt3305_frontend_attach(struct dvb_usb_adapter *adap)
 	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
 	msleep(30);
 
-	adap->fe = dvb_attach(lgdt3305_attach,
+	adap->fe[0] = dvb_attach(lgdt3305_attach,
 			      &hcw_lgdt3305_config,
 			      &adap->dev->i2c_adap);
 
-	return adap->fe == NULL ? -ENODEV : 0;
+	return adap->fe[0] == NULL ? -ENODEV : 0;
 }
 
 static int mxl5007t_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	return dvb_attach(mxl5007t_attach, adap->fe,
+	return dvb_attach(mxl5007t_attach, adap->fe[0],
 			  &adap->dev->i2c_adap, 0x60,
 			  &hcw_mxl5007t_config) == NULL ? -ENODEV : 0;
 }
diff --git a/drivers/media/dvb/dvb-usb/dibusb-common.c b/drivers/media/dvb/dvb-usb/dibusb-common.c
index 4c2a689..263235e 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-common.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-common.c
@@ -23,7 +23,7 @@ int dibusb_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	if (adap->priv != NULL) {
 		struct dibusb_state *st = adap->priv;
 		if (st->ops.fifo_ctrl != NULL)
-			if (st->ops.fifo_ctrl(adap->fe,onoff)) {
+			if (st->ops.fifo_ctrl(adap->fe[0],onoff)) {
 				err("error while controlling the fifo of the demod.");
 				return -ENODEV;
 			}
@@ -37,7 +37,7 @@ int dibusb_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onof
 	if (adap->priv != NULL) {
 		struct dibusb_state *st = adap->priv;
 		if (st->ops.pid_ctrl != NULL)
-			st->ops.pid_ctrl(adap->fe,index,pid,onoff);
+			st->ops.pid_ctrl(adap->fe[0],index,pid,onoff);
 	}
 	return 0;
 }
@@ -48,7 +48,7 @@ int dibusb_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	if (adap->priv != NULL) {
 		struct dibusb_state *st = adap->priv;
 		if (st->ops.pid_parse != NULL)
-			if (st->ops.pid_parse(adap->fe,onoff) < 0)
+			if (st->ops.pid_parse(adap->fe[0],onoff) < 0)
 				err("could not handle pid_parser");
 	}
 	return 0;
@@ -254,8 +254,8 @@ int dibusb_dib3000mc_frontend_attach(struct dvb_usb_adapter *adap)
 		msleep(1000);
 	}
 
-	if ((adap->fe = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap, DEFAULT_DIB3000P_I2C_ADDRESS,  &mod3000p_dib3000p_config)) != NULL ||
-		(adap->fe = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap, DEFAULT_DIB3000MC_I2C_ADDRESS, &mod3000p_dib3000p_config)) != NULL) {
+	if ((adap->fe[0] = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap, DEFAULT_DIB3000P_I2C_ADDRESS,  &mod3000p_dib3000p_config)) != NULL ||
+		(adap->fe[0] = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap, DEFAULT_DIB3000MC_I2C_ADDRESS, &mod3000p_dib3000p_config)) != NULL) {
 		if (adap->priv != NULL) {
 			struct dibusb_state *st = adap->priv;
 			st->ops.pid_parse = dib3000mc_pid_parse;
@@ -309,15 +309,15 @@ int dibusb_dib3000mc_tuner_attach(struct dvb_usb_adapter *adap)
 		}
 	}
 
-	tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe, 1);
-	if (dvb_attach(mt2060_attach, adap->fe, tun_i2c, &stk3000p_mt2060_config, if1) == NULL) {
+	tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe[0], 1);
+	if (dvb_attach(mt2060_attach, adap->fe[0], tun_i2c, &stk3000p_mt2060_config, if1) == NULL) {
 		/* not found - use panasonic pll parameters */
-		if (dvb_attach(dvb_pll_attach, adap->fe, 0x60, tun_i2c, DVB_PLL_ENV57H1XD5) == NULL)
+		if (dvb_attach(dvb_pll_attach, adap->fe[0], 0x60, tun_i2c, DVB_PLL_ENV57H1XD5) == NULL)
 			return -ENOMEM;
 	} else {
 		st->mt2060_present = 1;
 		/* set the correct parameters for the dib3000p */
-		dib3000mc_set_config(adap->fe, &stk3000p_dib3000p_config);
+		dib3000mc_set_config(adap->fe[0], &stk3000p_dib3000p_config);
 	}
 	return 0;
 }
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index 04d91bd..c653b32 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -31,11 +31,11 @@ static int dibusb_dib3000mb_frontend_attach(struct dvb_usb_adapter *adap)
 
 	demod_cfg.demod_address = 0x8;
 
-	if ((adap->fe = dvb_attach(dib3000mb_attach, &demod_cfg,
+	if ((adap->fe[0] = dvb_attach(dib3000mb_attach, &demod_cfg,
 				   &adap->dev->i2c_adap, &st->ops)) == NULL)
 		return -ENODEV;
 
-	adap->fe->ops.i2c_gate_ctrl = dib3000mb_i2c_gate_ctrl;
+	adap->fe[0]->ops.i2c_gate_ctrl = dib3000mb_i2c_gate_ctrl;
 
 	return 0;
 }
@@ -46,7 +46,7 @@ static int dibusb_thomson_tuner_attach(struct dvb_usb_adapter *adap)
 
 	st->tuner_addr = 0x61;
 
-	dvb_attach(dvb_pll_attach, adap->fe, 0x61, &adap->dev->i2c_adap,
+	dvb_attach(dvb_pll_attach, adap->fe[0], 0x61, &adap->dev->i2c_adap,
 		   DVB_PLL_TUA6010XS);
 	return 0;
 }
@@ -57,7 +57,7 @@ static int dibusb_panasonic_tuner_attach(struct dvb_usb_adapter *adap)
 
 	st->tuner_addr = 0x60;
 
-	dvb_attach(dvb_pll_attach, adap->fe, 0x60, &adap->dev->i2c_adap,
+	dvb_attach(dvb_pll_attach, adap->fe[0], 0x60, &adap->dev->i2c_adap,
 		   DVB_PLL_TDA665X);
 	return 0;
 }
@@ -78,16 +78,16 @@ static int dibusb_tuner_probe_and_attach(struct dvb_usb_adapter *adap)
 	/* the Panasonic sits on I2C addrass 0x60, the Thomson on 0x61 */
 	msg[0].addr = msg[1].addr = st->tuner_addr = 0x60;
 
-	if (adap->fe->ops.i2c_gate_ctrl)
-		adap->fe->ops.i2c_gate_ctrl(adap->fe,1);
+	if (adap->fe[0]->ops.i2c_gate_ctrl)
+		adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0],1);
 
 	if (i2c_transfer(&adap->dev->i2c_adap, msg, 2) != 2) {
 		err("tuner i2c write failed.");
 		ret = -EREMOTEIO;
 	}
 
-	if (adap->fe->ops.i2c_gate_ctrl)
-		adap->fe->ops.i2c_gate_ctrl(adap->fe,0);
+	if (adap->fe[0]->ops.i2c_gate_ctrl)
+		adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0],0);
 
 	if (b2[0] == 0xfe) {
 		info("This device has the Thomson Cable onboard. Which is default.");
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index f6344cd..1e17d15 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -137,11 +137,11 @@ static int digitv_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct digitv_state *st = adap->dev->priv;
 
-	if ((adap->fe = dvb_attach(mt352_attach, &digitv_mt352_config, &adap->dev->i2c_adap)) != NULL) {
+	if ((adap->fe[0] = dvb_attach(mt352_attach, &digitv_mt352_config, &adap->dev->i2c_adap)) != NULL) {
 		st->is_nxt6000 = 0;
 		return 0;
 	}
-	if ((adap->fe = dvb_attach(nxt6000_attach, &digitv_nxt6000_config, &adap->dev->i2c_adap)) != NULL) {
+	if ((adap->fe[0] = dvb_attach(nxt6000_attach, &digitv_nxt6000_config, &adap->dev->i2c_adap)) != NULL) {
 		st->is_nxt6000 = 1;
 		return 0;
 	}
@@ -152,11 +152,11 @@ static int digitv_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct digitv_state *st = adap->dev->priv;
 
-	if (!dvb_attach(dvb_pll_attach, adap->fe, 0x60, NULL, DVB_PLL_TDED4))
+	if (!dvb_attach(dvb_pll_attach, adap->fe[0], 0x60, NULL, DVB_PLL_TDED4))
 		return -ENODEV;
 
 	if (st->is_nxt6000)
-		adap->fe->ops.tuner_ops.set_params = digitv_nxt6000_tuner_set_params;
+		adap->fe[0]->ops.tuner_ops.set_params = digitv_nxt6000_tuner_set_params;
 
 	return 0;
 }
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/dvb/dvb-usb/dtt200u.c
index ecd86ec..ea2a46f 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u.c
@@ -90,7 +90,7 @@ static int dtt200u_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 static int dtt200u_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe = dtt200u_fe_attach(adap->dev);
+	adap->fe[0] = dtt200u_fe_attach(adap->dev);
 	return 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/dtv5100.c b/drivers/media/dvb/dvb-usb/dtv5100.c
index 078ce92..75ed55c 100644
--- a/drivers/media/dvb/dvb-usb/dtv5100.c
+++ b/drivers/media/dvb/dvb-usb/dtv5100.c
@@ -115,13 +115,13 @@ static struct zl10353_config dtv5100_zl10353_config = {
 
 static int dtv5100_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe = dvb_attach(zl10353_attach, &dtv5100_zl10353_config,
+	adap->fe[0] = dvb_attach(zl10353_attach, &dtv5100_zl10353_config,
 			      &adap->dev->i2c_adap);
-	if (adap->fe == NULL)
+	if (adap->fe[0] == NULL)
 		return -EIO;
 
 	/* disable i2c gate, or it won't work... is this safe? */
-	adap->fe->ops.i2c_gate_ctrl = NULL;
+	adap->fe[0]->ops.i2c_gate_ctrl = NULL;
 
 	return 0;
 }
@@ -133,7 +133,7 @@ static struct qt1010_config dtv5100_qt1010_config = {
 static int dtv5100_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	return dvb_attach(qt1010_attach,
-			  adap->fe, &adap->dev->i2c_adap,
+			  adap->fe[0], &adap->dev->i2c_adap,
 			  &dtv5100_qt1010_config) == NULL ? -ENODEV : 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
index b3cb626..d8c0bd9 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
@@ -186,14 +186,14 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 	}
 
 	/* re-assign sleep and wakeup functions */
-	if (adap->props.frontend_attach(adap) == 0 && adap->fe != NULL) {
-		adap->fe_init  = adap->fe->ops.init;  adap->fe->ops.init  = dvb_usb_fe_wakeup;
-		adap->fe_sleep = adap->fe->ops.sleep; adap->fe->ops.sleep = dvb_usb_fe_sleep;
+	if (adap->props.frontend_attach(adap) == 0 && adap->fe[0] != NULL) {
+		adap->fe_init  = adap->fe[0]->ops.init;  adap->fe[0]->ops.init  = dvb_usb_fe_wakeup;
+		adap->fe_sleep = adap->fe[0]->ops.sleep; adap->fe[0]->ops.sleep = dvb_usb_fe_sleep;
 
-		if (dvb_register_frontend(&adap->dvb_adap, adap->fe)) {
+		if (dvb_register_frontend(&adap->dvb_adap, adap->fe[0])) {
 			err("Frontend registration failed.");
-			dvb_frontend_detach(adap->fe);
-			adap->fe = NULL;
+			dvb_frontend_detach(adap->fe[0]);
+			adap->fe[0] = NULL;
 			return -ENODEV;
 		}
 
@@ -208,9 +208,9 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 
 int dvb_usb_adapter_frontend_exit(struct dvb_usb_adapter *adap)
 {
-	if (adap->fe != NULL) {
-		dvb_unregister_frontend(adap->fe);
-		dvb_frontend_detach(adap->fe);
+	if (adap->fe[0] != NULL) {
+		dvb_unregister_frontend(adap->fe[0]);
+		dvb_frontend_detach(adap->fe[0]);
 	}
 	return 0;
 }
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 7d35d07..2e57bff 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -363,7 +363,7 @@ struct dvb_usb_adapter {
 	struct dmxdev        dmxdev;
 	struct dvb_demux     demux;
 	struct dvb_net       dvb_net;
-	struct dvb_frontend *fe;
+	struct dvb_frontend *fe[1];
 	int                  max_feed_count;
 
 	int (*fe_init)  (struct dvb_frontend *);
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 058b231..eb5dff5 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -992,18 +992,18 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 	struct dvb_tuner_ops *tuner_ops = NULL;
 
 	if (demod_probe & 4) {
-		d->fe = dvb_attach(stv0900_attach, &dw2104a_stv0900_config,
+		d->fe[0] = dvb_attach(stv0900_attach, &dw2104a_stv0900_config,
 				&d->dev->i2c_adap, 0);
-		if (d->fe != NULL) {
-			if (dvb_attach(stb6100_attach, d->fe,
+		if (d->fe[0] != NULL) {
+			if (dvb_attach(stb6100_attach, d->fe[0],
 					&dw2104a_stb6100_config,
 					&d->dev->i2c_adap)) {
-				tuner_ops = &d->fe->ops.tuner_ops;
+				tuner_ops = &d->fe[0]->ops.tuner_ops;
 				tuner_ops->set_frequency = stb6100_set_freq;
 				tuner_ops->get_frequency = stb6100_get_freq;
 				tuner_ops->set_bandwidth = stb6100_set_bandw;
 				tuner_ops->get_bandwidth = stb6100_get_bandw;
-				d->fe->ops.set_voltage = dw210x_set_voltage;
+				d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 				info("Attached STV0900+STB6100!\n");
 				return 0;
 			}
@@ -1011,13 +1011,13 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 	}
 
 	if (demod_probe & 2) {
-		d->fe = dvb_attach(stv0900_attach, &dw2104_stv0900_config,
+		d->fe[0] = dvb_attach(stv0900_attach, &dw2104_stv0900_config,
 				&d->dev->i2c_adap, 0);
-		if (d->fe != NULL) {
-			if (dvb_attach(stv6110_attach, d->fe,
+		if (d->fe[0] != NULL) {
+			if (dvb_attach(stv6110_attach, d->fe[0],
 					&dw2104_stv6110_config,
 					&d->dev->i2c_adap)) {
-				d->fe->ops.set_voltage = dw210x_set_voltage;
+				d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 				info("Attached STV0900+STV6110A!\n");
 				return 0;
 			}
@@ -1025,19 +1025,19 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 	}
 
 	if (demod_probe & 1) {
-		d->fe = dvb_attach(cx24116_attach, &dw2104_config,
+		d->fe[0] = dvb_attach(cx24116_attach, &dw2104_config,
 				&d->dev->i2c_adap);
-		if (d->fe != NULL) {
-			d->fe->ops.set_voltage = dw210x_set_voltage;
+		if (d->fe[0] != NULL) {
+			d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 			info("Attached cx24116!\n");
 			return 0;
 		}
 	}
 
-	d->fe = dvb_attach(ds3000_attach, &dw2104_ds3000_config,
+	d->fe[0] = dvb_attach(ds3000_attach, &dw2104_ds3000_config,
 			&d->dev->i2c_adap);
-	if (d->fe != NULL) {
-		d->fe->ops.set_voltage = dw210x_set_voltage;
+	if (d->fe[0] != NULL) {
+		d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 		info("Attached DS3000!\n");
 		return 0;
 	}
@@ -1053,22 +1053,22 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
 {
 	if (dw2102_properties.i2c_algo == &dw2102_serit_i2c_algo) {
 		/*dw2102_properties.adapter->tuner_attach = NULL;*/
-		d->fe = dvb_attach(si21xx_attach, &serit_sp1511lhb_config,
+		d->fe[0] = dvb_attach(si21xx_attach, &serit_sp1511lhb_config,
 					&d->dev->i2c_adap);
-		if (d->fe != NULL) {
-			d->fe->ops.set_voltage = dw210x_set_voltage;
+		if (d->fe[0] != NULL) {
+			d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 			info("Attached si21xx!\n");
 			return 0;
 		}
 	}
 
 	if (dw2102_properties.i2c_algo == &dw2102_earda_i2c_algo) {
-		d->fe = dvb_attach(stv0288_attach, &earda_config,
+		d->fe[0] = dvb_attach(stv0288_attach, &earda_config,
 					&d->dev->i2c_adap);
-		if (d->fe != NULL) {
-			if (dvb_attach(stb6000_attach, d->fe, 0x61,
+		if (d->fe[0] != NULL) {
+			if (dvb_attach(stb6000_attach, d->fe[0], 0x61,
 					&d->dev->i2c_adap)) {
-				d->fe->ops.set_voltage = dw210x_set_voltage;
+				d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 				info("Attached stv0288!\n");
 				return 0;
 			}
@@ -1077,10 +1077,10 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
 
 	if (dw2102_properties.i2c_algo == &dw2102_i2c_algo) {
 		/*dw2102_properties.adapter->tuner_attach = dw2102_tuner_attach;*/
-		d->fe = dvb_attach(stv0299_attach, &sharp_z0194a_config,
+		d->fe[0] = dvb_attach(stv0299_attach, &sharp_z0194a_config,
 					&d->dev->i2c_adap);
-		if (d->fe != NULL) {
-			d->fe->ops.set_voltage = dw210x_set_voltage;
+		if (d->fe[0] != NULL) {
+			d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 			info("Attached stv0299!\n");
 			return 0;
 		}
@@ -1090,9 +1090,9 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
 
 static int dw3101_frontend_attach(struct dvb_usb_adapter *d)
 {
-	d->fe = dvb_attach(tda10023_attach, &dw3101_tda10023_config,
+	d->fe[0] = dvb_attach(tda10023_attach, &dw3101_tda10023_config,
 				&d->dev->i2c_adap, 0x48);
-	if (d->fe != NULL) {
+	if (d->fe[0] != NULL) {
 		info("Attached tda10023!\n");
 		return 0;
 	}
@@ -1101,12 +1101,12 @@ static int dw3101_frontend_attach(struct dvb_usb_adapter *d)
 
 static int zl100313_frontend_attach(struct dvb_usb_adapter *d)
 {
-	d->fe = dvb_attach(mt312_attach, &zl313_config,
+	d->fe[0] = dvb_attach(mt312_attach, &zl313_config,
 			&d->dev->i2c_adap);
-	if (d->fe != NULL) {
-		if (dvb_attach(zl10039_attach, d->fe, 0x60,
+	if (d->fe[0] != NULL) {
+		if (dvb_attach(zl10039_attach, d->fe[0], 0x60,
 				&d->dev->i2c_adap)) {
-			d->fe->ops.set_voltage = dw210x_set_voltage;
+			d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 			info("Attached zl100313+zl10039!\n");
 			return 0;
 		}
@@ -1119,16 +1119,16 @@ static int stv0288_frontend_attach(struct dvb_usb_adapter *d)
 {
 	u8 obuf[] = {7, 1};
 
-	d->fe = dvb_attach(stv0288_attach, &earda_config,
+	d->fe[0] = dvb_attach(stv0288_attach, &earda_config,
 			&d->dev->i2c_adap);
 
-	if (d->fe == NULL)
+	if (d->fe[0] == NULL)
 		return -EIO;
 
-	if (NULL == dvb_attach(stb6000_attach, d->fe, 0x61, &d->dev->i2c_adap))
+	if (NULL == dvb_attach(stb6000_attach, d->fe[0], 0x61, &d->dev->i2c_adap))
 		return -EIO;
 
-	d->fe->ops.set_voltage = dw210x_set_voltage;
+	d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 
 	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
 
@@ -1143,14 +1143,14 @@ static int ds3000_frontend_attach(struct dvb_usb_adapter *d)
 	struct s6x0_state *st = (struct s6x0_state *)d->dev->priv;
 	u8 obuf[] = {7, 1};
 
-	d->fe = dvb_attach(ds3000_attach, &dw2104_ds3000_config,
+	d->fe[0] = dvb_attach(ds3000_attach, &dw2104_ds3000_config,
 			&d->dev->i2c_adap);
 
-	if (d->fe == NULL)
+	if (d->fe[0] == NULL)
 		return -EIO;
 
-	st->old_set_voltage = d->fe->ops.set_voltage;
-	d->fe->ops.set_voltage = s660_set_voltage;
+	st->old_set_voltage = d->fe[0]->ops.set_voltage;
+	d->fe[0]->ops.set_voltage = s660_set_voltage;
 
 	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
 
@@ -1163,12 +1163,12 @@ static int prof_7500_frontend_attach(struct dvb_usb_adapter *d)
 {
 	u8 obuf[] = {7, 1};
 
-	d->fe = dvb_attach(stv0900_attach, &prof_7500_stv0900_config,
+	d->fe[0] = dvb_attach(stv0900_attach, &prof_7500_stv0900_config,
 					&d->dev->i2c_adap, 0);
-	if (d->fe == NULL)
+	if (d->fe[0] == NULL)
 		return -EIO;
 
-	d->fe->ops.set_voltage = dw210x_set_voltage;
+	d->fe[0]->ops.set_voltage = dw210x_set_voltage;
 
 	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
 
@@ -1204,9 +1204,9 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
 		err("command 0x51 transfer failed.");
 
-	d->fe = dvb_attach(ds3000_attach, &su3000_ds3000_config,
+	d->fe[0] = dvb_attach(ds3000_attach, &su3000_ds3000_config,
 					&d->dev->i2c_adap);
-	if (d->fe == NULL)
+	if (d->fe[0] == NULL)
 		return -EIO;
 
 	info("Attached DS3000!\n");
@@ -1216,14 +1216,14 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 
 static int dw2102_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(dvb_pll_attach, adap->fe, 0x60,
+	dvb_attach(dvb_pll_attach, adap->fe[0], 0x60,
 		&adap->dev->i2c_adap, DVB_PLL_OPERA1);
 	return 0;
 }
 
 static int dw3101_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(dvb_pll_attach, adap->fe, 0x60,
+	dvb_attach(dvb_pll_attach, adap->fe[0], 0x60,
 		&adap->dev->i2c_adap, DVB_PLL_TUA6034);
 
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/ec168.c b/drivers/media/dvb/dvb-usb/ec168.c
index 1ba3e5d..581bdfc 100644
--- a/drivers/media/dvb/dvb-usb/ec168.c
+++ b/drivers/media/dvb/dvb-usb/ec168.c
@@ -200,9 +200,9 @@ static struct ec100_config ec168_ec100_config = {
 static int ec168_ec100_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	deb_info("%s:\n", __func__);
-	adap->fe = dvb_attach(ec100_attach, &ec168_ec100_config,
+	adap->fe[0] = dvb_attach(ec100_attach, &ec168_ec100_config,
 		&adap->dev->i2c_adap);
-	if (adap->fe == NULL)
+	if (adap->fe[0] == NULL)
 		return -ENODEV;
 
 	return 0;
@@ -228,7 +228,7 @@ static struct mxl5005s_config ec168_mxl5003s_config = {
 static int ec168_mxl5003s_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	deb_info("%s:\n", __func__);
-	return dvb_attach(mxl5005s_attach, adap->fe, &adap->dev->i2c_adap,
+	return dvb_attach(mxl5005s_attach, adap->fe[0], &adap->dev->i2c_adap,
 		&ec168_mxl5003s_config) == NULL ? -ENODEV : 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/friio.c b/drivers/media/dvb/dvb-usb/friio.c
index 76159ae..0e4b559 100644
--- a/drivers/media/dvb/dvb-usb/friio.c
+++ b/drivers/media/dvb/dvb-usb/friio.c
@@ -403,8 +403,8 @@ static int friio_frontend_attach(struct dvb_usb_adapter *adap)
 	if (friio_initialize(adap->dev) < 0)
 		return -EIO;
 
-	adap->fe = jdvbt90502_attach(adap->dev);
-	if (adap->fe == NULL)
+	adap->fe[0] = jdvbt90502_attach(adap->dev);
+	if (adap->fe[0] == NULL)
 		return -EIO;
 
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/gl861.c b/drivers/media/dvb/dvb-usb/gl861.c
index 6f596ed..fba24ed 100644
--- a/drivers/media/dvb/dvb-usb/gl861.c
+++ b/drivers/media/dvb/dvb-usb/gl861.c
@@ -103,9 +103,9 @@ static struct zl10353_config gl861_zl10353_config = {
 static int gl861_frontend_attach(struct dvb_usb_adapter *adap)
 {
 
-	adap->fe = dvb_attach(zl10353_attach, &gl861_zl10353_config,
+	adap->fe[0] = dvb_attach(zl10353_attach, &gl861_zl10353_config,
 		&adap->dev->i2c_adap);
-	if (adap->fe == NULL)
+	if (adap->fe[0] == NULL)
 		return -EIO;
 
 	return 0;
@@ -118,7 +118,7 @@ static struct qt1010_config gl861_qt1010_config = {
 static int gl861_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	return dvb_attach(qt1010_attach,
-			  adap->fe, &adap->dev->i2c_adap,
+			  adap->fe[0], &adap->dev->i2c_adap,
 			  &gl861_qt1010_config) == NULL ? -ENODEV : 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index 1cb3d9a..f254e13 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -230,7 +230,7 @@ static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 static int gp8psk_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe = gp8psk_fe_attach(adap->dev);
+	adap->fe[0] = gp8psk_fe_attach(adap->dev);
 	return 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 37b1469..ef5911a 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -941,7 +941,7 @@ static int lme_name(struct dvb_usb_adapter *adap)
 	const char *desc = adap->dev->desc->name;
 	char *fe_name[] = {"", " LG TDQY-P001F", " SHARP:BS2F7HZ7395",
 				" SHARP:BS2F7HZ0194"};
-	char *name = adap->fe->ops.info.name;
+	char *name = adap->fe[0]->ops.info.name;
 
 	strlcpy(name, desc, 128);
 	strlcat(name, fe_name[st->tuner_config], 128);
@@ -958,10 +958,10 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 	st->i2c_talk_onoff = 1;
 
 	st->i2c_gate = 4;
-	adap->fe = dvb_attach(tda10086_attach, &tda10086_config,
+	adap->fe[0] = dvb_attach(tda10086_attach, &tda10086_config,
 		&adap->dev->i2c_adap);
 
-	if (adap->fe) {
+	if (adap->fe[0]) {
 		info("TUN Found Frontend TDA10086");
 		st->i2c_tuner_gate_w = 4;
 		st->i2c_tuner_gate_r = 4;
@@ -975,9 +975,9 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	st->i2c_gate = 4;
-	adap->fe = dvb_attach(stv0299_attach, &sharp_z0194_config,
+	adap->fe[0] = dvb_attach(stv0299_attach, &sharp_z0194_config,
 			&adap->dev->i2c_adap);
-	if (adap->fe) {
+	if (adap->fe[0]) {
 		info("FE Found Stv0299");
 		st->i2c_tuner_gate_w = 4;
 		st->i2c_tuner_gate_r = 5;
@@ -991,9 +991,9 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	st->i2c_gate = 5;
-	adap->fe = dvb_attach(stv0288_attach, &lme_config,
+	adap->fe[0] = dvb_attach(stv0288_attach, &lme_config,
 			&adap->dev->i2c_adap);
-	if (adap->fe) {
+	if (adap->fe[0]) {
 		info("FE Found Stv0288");
 		st->i2c_tuner_gate_w = 4;
 		st->i2c_tuner_gate_r = 5;
@@ -1010,15 +1010,15 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 
 
 end:	if (ret) {
-		if (adap->fe) {
-			dvb_frontend_detach(adap->fe);
-			adap->fe = NULL;
+		if (adap->fe[0]) {
+			dvb_frontend_detach(adap->fe[0]);
+			adap->fe[0] = NULL;
 		}
 		adap->dev->props.rc.core.rc_codes = NULL;
 		return -ENODEV;
 	}
 
-	adap->fe->ops.set_voltage = dm04_lme2510_set_voltage;
+	adap->fe[0]->ops.set_voltage = dm04_lme2510_set_voltage;
 	ret = lme_name(adap);
 	return ret;
 }
@@ -1031,17 +1031,17 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 
 	switch (st->tuner_config) {
 	case TUNER_LG:
-		if (dvb_attach(tda826x_attach, adap->fe, 0xc0,
+		if (dvb_attach(tda826x_attach, adap->fe[0], 0xc0,
 			&adap->dev->i2c_adap, 1))
 			ret = st->tuner_config;
 		break;
 	case TUNER_S7395:
-		if (dvb_attach(ix2505v_attach , adap->fe, &lme_tuner,
+		if (dvb_attach(ix2505v_attach , adap->fe[0], &lme_tuner,
 			&adap->dev->i2c_adap))
 			ret = st->tuner_config;
 		break;
 	case TUNER_S0194:
-		if (dvb_attach(dvb_pll_attach , adap->fe, 0xc0,
+		if (dvb_attach(dvb_pll_attach , adap->fe[0], 0xc0,
 			&adap->dev->i2c_adap, DVB_PLL_OPERA1))
 			ret = st->tuner_config;
 		break;
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index 9456792..ed5c161 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -501,7 +501,7 @@ static int m920x_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	deb("%s\n",__func__);
 
-	if ((adap->fe = dvb_attach(mt352_attach,
+	if ((adap->fe[0] = dvb_attach(mt352_attach,
 				   &m920x_mt352_config,
 				   &adap->dev->i2c_adap)) == NULL)
 		return -EIO;
@@ -513,7 +513,7 @@ static int m920x_tda10046_08_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	deb("%s\n",__func__);
 
-	if ((adap->fe = dvb_attach(tda10046_attach,
+	if ((adap->fe[0] = dvb_attach(tda10046_attach,
 				   &m920x_tda10046_08_config,
 				   &adap->dev->i2c_adap)) == NULL)
 		return -EIO;
@@ -525,7 +525,7 @@ static int m920x_tda10046_0b_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	deb("%s\n",__func__);
 
-	if ((adap->fe = dvb_attach(tda10046_attach,
+	if ((adap->fe[0] = dvb_attach(tda10046_attach,
 				   &m920x_tda10046_0b_config,
 				   &adap->dev->i2c_adap)) == NULL)
 		return -EIO;
@@ -537,7 +537,7 @@ static int m920x_qt1010_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	deb("%s\n",__func__);
 
-	if (dvb_attach(qt1010_attach, adap->fe, &adap->dev->i2c_adap, &m920x_qt1010_config) == NULL)
+	if (dvb_attach(qt1010_attach, adap->fe[0], &adap->dev->i2c_adap, &m920x_qt1010_config) == NULL)
 		return -ENODEV;
 
 	return 0;
@@ -547,7 +547,7 @@ static int m920x_tda8275_60_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	deb("%s\n",__func__);
 
-	if (dvb_attach(tda827x_attach, adap->fe, 0x60, &adap->dev->i2c_adap, NULL) == NULL)
+	if (dvb_attach(tda827x_attach, adap->fe[0], 0x60, &adap->dev->i2c_adap, NULL) == NULL)
 		return -ENODEV;
 
 	return 0;
@@ -557,7 +557,7 @@ static int m920x_tda8275_61_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	deb("%s\n",__func__);
 
-	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, NULL) == NULL)
+	if (dvb_attach(tda827x_attach, adap->fe[0], 0x61, &adap->dev->i2c_adap, NULL) == NULL)
 		return -ENODEV;
 
 	return 0;
@@ -565,7 +565,7 @@ static int m920x_tda8275_61_tuner_attach(struct dvb_usb_adapter *adap)
 
 static int m920x_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	dvb_attach(simple_tuner_attach, adap->fe,
+	dvb_attach(simple_tuner_attach, adap->fe[0],
 		   &adap->dev->i2c_adap, 0x61,
 		   TUNER_PHILIPS_FMD1216ME_MK3);
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index 2e4fab7..170b1ef 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -263,10 +263,10 @@ static struct stv0299_config opera1_stv0299_config = {
 
 static int opera1_frontend_attach(struct dvb_usb_adapter *d)
 {
-	if ((d->fe =
+	if ((d->fe[0] =
 	     dvb_attach(stv0299_attach, &opera1_stv0299_config,
 			&d->dev->i2c_adap)) != NULL) {
-		d->fe->ops.set_voltage = opera1_set_voltage;
+		d->fe[0]->ops.set_voltage = opera1_set_voltage;
 		return 0;
 	}
 	info("not attached stv0299");
@@ -276,7 +276,7 @@ static int opera1_frontend_attach(struct dvb_usb_adapter *d)
 static int opera1_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	dvb_attach(
-		dvb_pll_attach, adap->fe, 0xc0>>1,
+		dvb_pll_attach, adap->fe[0], 0xc0>>1,
 		&adap->dev->i2c_adap, DVB_PLL_OPERA1
 	);
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/technisat-usb2.c b/drivers/media/dvb/dvb-usb/technisat-usb2.c
index 473b95e..2a89d1e 100644
--- a/drivers/media/dvb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/dvb/dvb-usb/technisat-usb2.c
@@ -292,7 +292,7 @@ static void technisat_usb2_green_led_control(struct work_struct *work)
 {
 	struct technisat_usb2_state *state =
 		container_of(work, struct technisat_usb2_state, green_led_work.work);
-	struct dvb_frontend *fe = state->dev->adapter[0].fe;
+	struct dvb_frontend *fe = state->dev->adapter[0].fe[0];
 
 	if (state->power_state == 0)
 		goto schedule;
@@ -505,14 +505,14 @@ static int technisat_usb2_frontend_attach(struct dvb_usb_adapter *a)
 	struct usb_device *udev = a->dev->udev;
 	int ret;
 
-	a->fe = dvb_attach(stv090x_attach, &technisat_usb2_stv090x_config,
+	a->fe[0] = dvb_attach(stv090x_attach, &technisat_usb2_stv090x_config,
 			&a->dev->i2c_adap, STV090x_DEMODULATOR_0);
 
-	if (a->fe) {
+	if (a->fe[0]) {
 		struct stv6110x_devctl *ctl;
 
 		ctl = dvb_attach(stv6110x_attach,
-				a->fe,
+				a->fe[0],
 				&technisat_usb2_stv6110x_config,
 				&a->dev->i2c_adap);
 
@@ -532,8 +532,8 @@ static int technisat_usb2_frontend_attach(struct dvb_usb_adapter *a)
 			/* call the init function once to initialize
 			   tuner's clock output divider and demod's
 			   master clock */
-			if (a->fe->ops.init)
-				a->fe->ops.init(a->fe);
+			if (a->fe[0]->ops.init)
+				a->fe[0]->ops.init(a->fe[0]);
 
 			if (mutex_lock_interruptible(&a->dev->i2c_mutex) < 0)
 				return -EAGAIN;
@@ -548,20 +548,20 @@ static int technisat_usb2_frontend_attach(struct dvb_usb_adapter *a)
 			if (ret != 0)
 				err("could not set IF_CLK to external");
 
-			a->fe->ops.set_voltage = technisat_usb2_set_voltage;
+			a->fe[0]->ops.set_voltage = technisat_usb2_set_voltage;
 
 			/* if everything was successful assign a nice name to the frontend */
-			strlcpy(a->fe->ops.info.name, a->dev->desc->name,
-					sizeof(a->fe->ops.info.name));
+			strlcpy(a->fe[0]->ops.info.name, a->dev->desc->name,
+					sizeof(a->fe[0]->ops.info.name));
 		} else {
-			dvb_frontend_detach(a->fe);
-			a->fe = NULL;
+			dvb_frontend_detach(a->fe[0]);
+			a->fe[0] = NULL;
 		}
 	}
 
 	technisat_usb2_set_led_timer(a->dev, 1, 1);
 
-	return a->fe == NULL ? -ENODEV : 0;
+	return a->fe[0] == NULL ? -ENODEV : 0;
 }
 
 /* Remote control */
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index 0d4709f..c0f5ef5 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -195,7 +195,7 @@ static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
 	if (usb_set_interface(adap->dev->udev,0,3) < 0)
 		err("set interface to alts=3 failed");
 
-	if ((adap->fe = dvb_attach(tda10086_attach, &tda10086_config, &adap->dev->i2c_adap)) == NULL) {
+	if ((adap->fe[0] = dvb_attach(tda10086_attach, &tda10086_config, &adap->dev->i2c_adap)) == NULL) {
 		deb_info("TDA10086 attach failed\n");
 		return -ENODEV;
 	}
@@ -207,7 +207,7 @@ static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev, 0, 3) < 0)
 		err("set interface to alts=3 failed");
-	if ((adap->fe = dvb_attach(tda10023_attach, &tda10023_config, &adap->dev->i2c_adap, 0x48)) == NULL) {
+	if ((adap->fe[0] = dvb_attach(tda10023_attach, &tda10023_config, &adap->dev->i2c_adap, 0x48)) == NULL) {
 		deb_info("TDA10023 attach failed\n");
 		return -ENODEV;
 	}
@@ -216,7 +216,7 @@ static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *adap)
 
 static int ttusb2_tuner_tda827x_attach(struct dvb_usb_adapter *adap)
 {
-	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, NULL) == NULL) {
+	if (dvb_attach(tda827x_attach, adap->fe[0], 0x61, &adap->dev->i2c_adap, NULL) == NULL) {
 		printk(KERN_ERR "%s: No tda827x found!\n", __func__);
 		return -ENODEV;
 	}
@@ -225,12 +225,12 @@ static int ttusb2_tuner_tda827x_attach(struct dvb_usb_adapter *adap)
 
 static int ttusb2_tuner_tda826x_attach(struct dvb_usb_adapter *adap)
 {
-	if (dvb_attach(tda826x_attach, adap->fe, 0x60, &adap->dev->i2c_adap, 0) == NULL) {
+	if (dvb_attach(tda826x_attach, adap->fe[0], 0x60, &adap->dev->i2c_adap, 0) == NULL) {
 		deb_info("TDA8263 attach failed\n");
 		return -ENODEV;
 	}
 
-	if (dvb_attach(lnbp21_attach, adap->fe, &adap->dev->i2c_adap, 0, 0) == NULL) {
+	if (dvb_attach(lnbp21_attach, adap->fe[0], &adap->dev->i2c_adap, 0, 0) == NULL) {
 		deb_info("LNBP21 attach failed\n");
 		return -ENODEV;
 	}
diff --git a/drivers/media/dvb/dvb-usb/umt-010.c b/drivers/media/dvb/dvb-usb/umt-010.c
index 118aab1..ed4765a 100644
--- a/drivers/media/dvb/dvb-usb/umt-010.c
+++ b/drivers/media/dvb/dvb-usb/umt-010.c
@@ -60,14 +60,14 @@ static int umt_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 	umt_config.demod_init = umt_mt352_demod_init;
 	umt_config.demod_address = 0xf;
 
-	adap->fe = dvb_attach(mt352_attach, &umt_config, &adap->dev->i2c_adap);
+	adap->fe[0] = dvb_attach(mt352_attach, &umt_config, &adap->dev->i2c_adap);
 
 	return 0;
 }
 
 static int umt_tuner_attach (struct dvb_usb_adapter *adap)
 {
-	dvb_attach(dvb_pll_attach, adap->fe, 0x61, NULL, DVB_PLL_TUA6034);
+	dvb_attach(dvb_pll_attach, adap->fe[0], 0x61, NULL, DVB_PLL_TUA6034);
 	return 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 54355f8..47b3462 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -320,7 +320,7 @@ static int vp702x_frontend_attach(struct dvb_usb_adapter *adap)
 
 	vp702x_init_pid_filter(adap);
 
-	adap->fe = vp702x_fe_attach(adap->dev);
+	adap->fe[0] = vp702x_fe_attach(adap->dev);
 	vp702x_usb_out_op(adap->dev, SET_TUNER_POWER_REQ, 1, 7, NULL, 0);
 
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index 3db89e3..4264523 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -214,7 +214,7 @@ static int vp7045_frontend_attach(struct dvb_usb_adapter *adap)
 /*	Dump the EEPROM */
 /*	vp7045_read_eeprom(d,buf, 255, FX2_ID_ADDR); */
 
-	adap->fe = vp7045_fe_attach(adap->dev);
+	adap->fe[0] = vp7045_fe_attach(adap->dev);
 
 	return 0;
 }
-- 
1.7.6


--------------000200010204060101020202
Content-Type: text/plain;
 name="0002-dvb-usb-multi-frontend-support-MFE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-dvb-usb-multi-frontend-support-MFE.patch"

>From 1853f9f9b900374ceec266ab3dbc0c4295fd91cc Mon Sep 17 00:00:00 2001
From: Antti Palosaari <crope@iki.fi>
Date: Tue, 26 Jul 2011 02:16:13 +0300
Subject: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c  |   85 +++++++++++++++++++++++-------
 drivers/media/dvb/dvb-usb/dvb-usb-init.c |    4 ++
 drivers/media/dvb/dvb-usb/dvb-usb.h      |   11 +++-
 3 files changed, 78 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
index d8c0bd9..5e34df7 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
@@ -162,8 +162,11 @@ static int dvb_usb_fe_wakeup(struct dvb_frontend *fe)
 
 	dvb_usb_device_power_ctrl(adap->dev, 1);
 
-	if (adap->fe_init)
-		adap->fe_init(fe);
+	if (adap->props.frontend_ctrl)
+		adap->props.frontend_ctrl(fe, 1);
+
+	if (adap->fe_init[fe->id])
+		adap->fe_init[fe->id](fe);
 
 	return 0;
 }
@@ -172,45 +175,89 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 {
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 
-	if (adap->fe_sleep)
-		adap->fe_sleep(fe);
+	if (adap->fe_sleep[fe->id])
+		adap->fe_sleep[fe->id](fe);
+
+	if (adap->props.frontend_ctrl)
+		adap->props.frontend_ctrl(fe, 0);
 
 	return dvb_usb_device_power_ctrl(adap->dev, 0);
 }
 
 int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 {
+	int ret, i, x;
+
+	memset(adap->fe, 0, sizeof(adap->fe));
+
 	if (adap->props.frontend_attach == NULL) {
-		err("strange: '%s' #%d doesn't want to attach a frontend.",adap->dev->desc->name, adap->id);
+		err("strange: '%s' #%d doesn't want to attach a frontend.",
+			adap->dev->desc->name, adap->id);
+
 		return 0;
 	}
 
-	/* re-assign sleep and wakeup functions */
-	if (adap->props.frontend_attach(adap) == 0 && adap->fe[0] != NULL) {
-		adap->fe_init  = adap->fe[0]->ops.init;  adap->fe[0]->ops.init  = dvb_usb_fe_wakeup;
-		adap->fe_sleep = adap->fe[0]->ops.sleep; adap->fe[0]->ops.sleep = dvb_usb_fe_sleep;
+	/* register all given adapter frontends */
+	if (adap->props.num_frontends)
+		x = adap->props.num_frontends - 1;
+	else
+		x = 0;
+
+	for (i = 0; i <= x; i++) {
+		ret = adap->props.frontend_attach(adap);
+		if (ret || adap->fe[i] == NULL) {
+			/* only print error when there is no FE at all */
+			if (i == 0)
+				err("no frontend was attached by '%s'",
+					adap->dev->desc->name);
+
+			return 0;
+		}
 
-		if (dvb_register_frontend(&adap->dvb_adap, adap->fe[0])) {
-			err("Frontend registration failed.");
-			dvb_frontend_detach(adap->fe[0]);
-			adap->fe[0] = NULL;
-			return -ENODEV;
+		adap->fe[i]->id = i;
+
+		/* re-assign sleep and wakeup functions */
+		adap->fe_init[i] = adap->fe[i]->ops.init;
+		adap->fe[i]->ops.init  = dvb_usb_fe_wakeup;
+		adap->fe_sleep[i] = adap->fe[i]->ops.sleep;
+		adap->fe[i]->ops.sleep = dvb_usb_fe_sleep;
+
+		if (dvb_register_frontend(&adap->dvb_adap, adap->fe[i])) {
+			err("Frontend %d registration failed.", i);
+			dvb_frontend_detach(adap->fe[i]);
+			adap->fe[i] = NULL;
+			/* In error case, do not try register more FEs,
+			 * still leaving already registered FEs alive. */
+			if (i == 0)
+				return -ENODEV;
+			else
+				return 0;
 		}
 
 		/* only attach the tuner if the demod is there */
 		if (adap->props.tuner_attach != NULL)
 			adap->props.tuner_attach(adap);
-	} else
-		err("no frontend was attached by '%s'",adap->dev->desc->name);
+	}
 
 	return 0;
 }
 
 int dvb_usb_adapter_frontend_exit(struct dvb_usb_adapter *adap)
 {
-	if (adap->fe[0] != NULL) {
-		dvb_unregister_frontend(adap->fe[0]);
-		dvb_frontend_detach(adap->fe[0]);
+	int i;
+
+	/* unregister all given adapter frontends */
+	if (adap->props.num_frontends)
+		i = adap->props.num_frontends - 1;
+	else
+		i = 0;
+
+	for (; i >= 0; i--) {
+		if (adap->fe[i] != NULL) {
+			dvb_unregister_frontend(adap->fe[i]);
+			dvb_frontend_detach(adap->fe[i]);
+		}
 	}
+
 	return 0;
 }
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
index 2e3ea0f..f9af348 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
@@ -77,6 +77,10 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 			return ret;
 		}
 
+		/* use exclusive FE lock if there is multiple shared FEs */
+		if (adap->fe[1])
+			adap->dvb_adap.mfe_shared = 1;
+
 		d->num_adapters_initialized++;
 		d->state |= DVB_USB_STATE_DVB;
 	}
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 2e57bff..a3e77b2 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -124,6 +124,8 @@ struct usb_data_stream_properties {
  * @caps: capabilities of the DVB USB device.
  * @pid_filter_count: number of PID filter position in the optional hardware
  *  PID-filter.
+ * @num_frontends: number of frontends of the DVB USB adapter.
+ * @frontend_ctrl: called to power on/off active frontend.
  * @streaming_ctrl: called to start and stop the MPEG2-TS streaming of the
  *  device (not URB submitting/killing).
  * @pid_filter_ctrl: called to en/disable the PID filter, if any.
@@ -141,7 +143,9 @@ struct dvb_usb_adapter_properties {
 #define DVB_USB_ADAP_RECEIVES_204_BYTE_TS         0x08
 	int caps;
 	int pid_filter_count;
+	int num_frontends;
 
+	int (*frontend_ctrl)   (struct dvb_frontend *, int);
 	int (*streaming_ctrl)  (struct dvb_usb_adapter *, int);
 	int (*pid_filter_ctrl) (struct dvb_usb_adapter *, int);
 	int (*pid_filter)      (struct dvb_usb_adapter *, int, u16, int);
@@ -345,6 +349,7 @@ struct usb_data_stream {
  *
  * @stream: the usb data stream.
  */
+#define MAX_NO_OF_FE_PER_ADAP 2
 struct dvb_usb_adapter {
 	struct dvb_usb_device *dev;
 	struct dvb_usb_adapter_properties props;
@@ -363,11 +368,11 @@ struct dvb_usb_adapter {
 	struct dmxdev        dmxdev;
 	struct dvb_demux     demux;
 	struct dvb_net       dvb_net;
-	struct dvb_frontend *fe[1];
+	struct dvb_frontend *fe[MAX_NO_OF_FE_PER_ADAP];
 	int                  max_feed_count;
 
-	int (*fe_init)  (struct dvb_frontend *);
-	int (*fe_sleep) (struct dvb_frontend *);
+	int (*fe_init[MAX_NO_OF_FE_PER_ADAP])  (struct dvb_frontend *);
+	int (*fe_sleep[MAX_NO_OF_FE_PER_ADAP]) (struct dvb_frontend *);
 
 	struct usb_data_stream stream;
 
-- 
1.7.6


--------------000200010204060101020202
Content-Type: text/plain;
 name="0003-anysee-use-multi-frontend-MFE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-anysee-use-multi-frontend-MFE.patch"

>From f42168386609556ae94c844a52f94c6292e0153b Mon Sep 17 00:00:00 2001
From: Antti Palosaari <crope@iki.fi>
Date: Tue, 26 Jul 2011 02:25:21 +0300
Subject: [PATCH 3/3] anysee: use multi-frontend (MFE)

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/anysee.c |  299 ++++++++++++++++++++++++-----------
 drivers/media/dvb/dvb-usb/anysee.h |    1 +
 2 files changed, 206 insertions(+), 94 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
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
@@ -466,27 +574,37 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
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
@@ -501,6 +619,9 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 	case ANYSEE_HW_507CD: /* 6 */
 		/* E30 Plus */
 
+		if (state->fe_id)
+			break;
+
 		/* enable DVB-T demod on IOD[0] */
 		ret = anysee_wr_reg_mask(adap->dev, REG_IOD, (1 << 0), 0x01);
 		if (ret)
@@ -512,26 +633,32 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
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
@@ -564,55 +691,59 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
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
 
@@ -627,52 +758,40 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
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
@@ -681,6 +800,9 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 		/* E7 S2 */
 		/* E7 PS2 */
 
+		if (state->fe_id)
+			break;
+
 		/* enable transport stream on IOA[7] */
 		ret = anysee_wr_reg_mask(adap->dev, REG_IOA, (1 << 7), 0x80);
 		if (ret)
@@ -713,7 +835,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 	struct anysee_state *state = adap->dev->priv;
 	struct dvb_frontend *fe;
 	int ret;
-	deb_info("%s:\n", __func__);
+	deb_info("%s: fe=%d\n", __func__, state->fe_id);
 
 	switch (state->hw) {
 	case ANYSEE_HW_507T: /* 2 */
@@ -744,28 +866,14 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
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
 
@@ -775,8 +883,8 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe[0], &adap->dev->i2c_adap,
-			&anysee_tda18212_config);
+		fe = dvb_attach(tda18212_attach, adap->fe[state->fe_id],
+			&adap->dev->i2c_adap, &anysee_tda18212_config);
 		if (fe)
 			break;
 
@@ -786,8 +894,9 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach tuner */
-		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc0 >> 1),
-			&adap->dev->i2c_adap, DVB_PLL_SAMSUNG_DTOS403IH102A);
+		fe = dvb_attach(dvb_pll_attach, adap->fe[state->fe_id],
+			(0xc0 >> 1), &adap->dev->i2c_adap,
+			DVB_PLL_SAMSUNG_DTOS403IH102A);
 
 		break;
 	case ANYSEE_HW_508TC: /* 18 */
@@ -801,8 +910,8 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 			goto error;
 
 		/* attach tuner */
-		fe = dvb_attach(tda18212_attach, adap->fe[0], &adap->dev->i2c_adap,
-			&anysee_tda18212_config);
+		fe = dvb_attach(tda18212_attach, adap->fe[state->fe_id],
+			&adap->dev->i2c_adap, &anysee_tda18212_config);
 
 		break;
 	case ANYSEE_HW_508S2: /* 19 */
@@ -918,6 +1027,8 @@ static struct dvb_usb_device_properties anysee_properties = {
 	.num_adapters = 1,
 	.adapter = {
 		{
+			.num_frontends    = 2,
+			.frontend_ctrl    = anysee_frontend_ctrl,
 			.streaming_ctrl   = anysee_streaming_ctrl,
 			.frontend_attach  = anysee_frontend_attach,
 			.tuner_attach     = anysee_tuner_attach,
diff --git a/drivers/media/dvb/dvb-usb/anysee.h b/drivers/media/dvb/dvb-usb/anysee.h
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


--------------000200010204060101020202--
