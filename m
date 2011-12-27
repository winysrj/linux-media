Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1L0BJk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:40 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19dAU017888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 89/91] [media] dvb: don't use DVBv3 bandwidth macros
Date: Mon, 26 Dec 2011 23:09:17 -0200
Message-Id: <1324948159-23709-90-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-89-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
 <1324948159-23709-64-git-send-email-mchehab@redhat.com>
 <1324948159-23709-65-git-send-email-mchehab@redhat.com>
 <1324948159-23709-66-git-send-email-mchehab@redhat.com>
 <1324948159-23709-67-git-send-email-mchehab@redhat.com>
 <1324948159-23709-68-git-send-email-mchehab@redhat.com>
 <1324948159-23709-69-git-send-email-mchehab@redhat.com>
 <1324948159-23709-70-git-send-email-mchehab@redhat.com>
 <1324948159-23709-71-git-send-email-mchehab@redhat.com>
 <1324948159-23709-72-git-send-email-mchehab@redhat.com>
 <1324948159-23709-73-git-send-email-mchehab@redhat.com>
 <1324948159-23709-74-git-send-email-mchehab@redhat.com>
 <1324948159-23709-75-git-send-email-mchehab@redhat.com>
 <1324948159-23709-76-git-send-email-mchehab@redhat.com>
 <1324948159-23709-77-git-send-email-mchehab@redhat.com>
 <1324948159-23709-78-git-send-email-mchehab@redhat.com>
 <1324948159-23709-79-git-send-email-mchehab@redhat.com>
 <1324948159-23709-80-git-send-email-mchehab@redhat.com>
 <1324948159-23709-81-git-send-email-mchehab@redhat.com>
 <1324948159-23709-82-git-send-email-mchehab@redhat.com>
 <1324948159-23709-83-git-send-email-mchehab@redhat.com>
 <1324948159-23709-84-git-send-email-mchehab@redhat.com>
 <1324948159-23709-85-git-send-email-mchehab@redhat.com>
 <1324948159-23709-86-git-send-email-mchehab@redhat.com>
 <1324948159-23709-87-git-send-email-mchehab@redhat.com>
 <1324948159-23709-88-git-send-email-mchehab@redhat.com>
 <1324948159-23709-89-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Every frontend now uses DVBv5 way. So, let's not use the DVBv3
macros internally anymore.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2266.c         |    4 +---
 drivers/media/common/tuners/mxl5007t.c       |    5 +----
 drivers/media/common/tuners/tda18271-fe.c    |    7 +------
 drivers/media/common/tuners/tda827x.c        |   14 ++------------
 drivers/media/common/tuners/tuner-simple.c   |   12 +-----------
 drivers/media/common/tuners/xc4000.c         |   11 +++--------
 drivers/media/common/tuners/xc5000.c         |   12 +++---------
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c   |    5 +----
 drivers/media/dvb/frontends/af9013.c         |    2 +-
 drivers/media/dvb/frontends/af9013_priv.h    |    2 +-
 drivers/media/dvb/frontends/dib3000mb_priv.h |    2 +-
 drivers/media/dvb/frontends/dvb-pll.c        |    7 +------
 12 files changed, 17 insertions(+), 66 deletions(-)

diff --git a/drivers/media/common/tuners/mt2266.c b/drivers/media/common/tuners/mt2266.c
index 2fb5a60..bca4d75 100644
--- a/drivers/media/common/tuners/mt2266.c
+++ b/drivers/media/common/tuners/mt2266.c
@@ -150,20 +150,18 @@ static int mt2266_set_params(struct dvb_frontend *fe)
 	case 6000000:
 		mt2266_writeregs(priv, mt2266_init_6mhz,
 				 sizeof(mt2266_init_6mhz));
-		priv->bandwidth = BANDWIDTH_6_MHZ;
 		break;
 	case 8000000:
 		mt2266_writeregs(priv, mt2266_init_8mhz,
 				 sizeof(mt2266_init_8mhz));
-		priv->bandwidth = BANDWIDTH_8_MHZ;
 		break;
 	case 7000000:
 	default:
 		mt2266_writeregs(priv, mt2266_init_7mhz,
 				 sizeof(mt2266_init_7mhz));
-		priv->bandwidth = BANDWIDTH_7_MHZ;
 		break;
 	}
+	priv->bandwidth = c->bandwidth_hz;
 
 	if (band == MT2266_VHF && priv->band == MT2266_UHF) {
 		dprintk("Switch from UHF to VHF");
diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
index 5d71e22..88bbc21 100644
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -624,7 +624,6 @@ static int mxl5007t_set_params(struct dvb_frontend *fe)
 	enum mxl5007t_mode mode;
 	int ret;
 	u32 freq = c->frequency;
-	u32 band = BANDWIDTH_6_MHZ;
 
 	switch (delsys) {
 	case SYS_ATSC:
@@ -644,10 +643,8 @@ static int mxl5007t_set_params(struct dvb_frontend *fe)
 			break;
 		case 7000000:
 			bw = MxL_BW_7MHz;
-			band = BANDWIDTH_7_MHZ;
 		case 8000000:
 			bw = MxL_BW_8MHz;
-			band = BANDWIDTH_8_MHZ;
 		default:
 			return -EINVAL;
 		}
@@ -671,7 +668,7 @@ static int mxl5007t_set_params(struct dvb_frontend *fe)
 		goto fail;
 
 	state->frequency = freq;
-	state->bandwidth = band;
+	state->bandwidth = c->bandwidth_hz;
 fail:
 	mutex_unlock(&state->lock);
 
diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
index 53299b0..d3d91ea 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -934,7 +934,6 @@ static int tda18271_set_params(struct dvb_frontend *fe)
 	u32 delsys = c->delivery_system;
 	u32 bw = c->bandwidth_hz;
 	u32 freq = c->frequency;
-	u32 band = BANDWIDTH_6_MHZ;
 	struct tda18271_priv *priv = fe->tuner_priv;
 	struct tda18271_std_map *std_map = &priv->std;
 	struct tda18271_std_map_item *map;
@@ -953,10 +952,8 @@ static int tda18271_set_params(struct dvb_frontend *fe)
 			map = &std_map->dvbt_6;
 		} else if (bw <= 7000000) {
 			map = &std_map->dvbt_7;
-			band = BANDWIDTH_7_MHZ;
 		} else {
 			map = &std_map->dvbt_8;
-			band = BANDWIDTH_8_MHZ;
 		}
 		break;
 	case SYS_DVBC_ANNEX_B:
@@ -968,10 +965,8 @@ static int tda18271_set_params(struct dvb_frontend *fe)
 			map = &std_map->qam_6;
 		} else if (bw <= 7000000) {
 			map = &std_map->qam_7;
-			band = BANDWIDTH_7_MHZ;
 		} else {
 			map = &std_map->qam_8;
-			band = BANDWIDTH_8_MHZ;
 		}
 		break;
 	default:
@@ -990,7 +985,7 @@ static int tda18271_set_params(struct dvb_frontend *fe)
 
 	priv->if_freq   = map->if_freq;
 	priv->frequency = freq;
-	priv->bandwidth = band;
+	priv->bandwidth = bw;
 fail:
 	return ret;
 }
diff --git a/drivers/media/common/tuners/tda827x.c b/drivers/media/common/tuners/tda827x.c
index d96d0b9..e180def 100644
--- a/drivers/media/common/tuners/tda827x.c
+++ b/drivers/media/common/tuners/tda827x.c
@@ -158,7 +158,6 @@ static int tda827xo_set_params(struct dvb_frontend *fe)
 	struct tda827x_priv *priv = fe->tuner_priv;
 	u8 buf[14];
 	int rc;
-	u32 band;
 
 	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
 			       .buf = buf, .len = sizeof(buf) };
@@ -168,16 +167,12 @@ static int tda827xo_set_params(struct dvb_frontend *fe)
 	dprintk("%s:\n", __func__);
 	if (c->bandwidth_hz == 0) {
 		if_freq = 5000000;
-		band = BANDWIDTH_8_MHZ;
 	} else if (c->bandwidth_hz <= 6000000) {
 		if_freq = 4000000;
-		band = BANDWIDTH_6_MHZ;
 	} else if (c->bandwidth_hz <= 7000000) {
 		if_freq = 4500000;
-		band = BANDWIDTH_7_MHZ;
 	} else {	/* 8 MHz */
 		if_freq = 5000000;
-		band = BANDWIDTH_8_MHZ;
 	}
 	tuner_freq = c->frequency;
 
@@ -224,7 +219,7 @@ static int tda827xo_set_params(struct dvb_frontend *fe)
 		goto err;
 
 	priv->frequency = c->frequency;
-	priv->bandwidth = band;
+	priv->bandwidth = c->bandwidth_hz;
 
 	return 0;
 
@@ -522,7 +517,6 @@ static int tda827xa_set_params(struct dvb_frontend *fe)
 	struct tda827x_priv *priv = fe->tuner_priv;
 	struct tda827xa_data *frequency_map = tda827xa_dvbt;
 	u8 buf[11];
-	u32 band;
 
 	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
 			       .buf = buf, .len = sizeof(buf) };
@@ -537,16 +531,12 @@ static int tda827xa_set_params(struct dvb_frontend *fe)
 
 	if (c->bandwidth_hz == 0) {
 		if_freq = 5000000;
-		band = BANDWIDTH_8_MHZ;
 	} else if (c->bandwidth_hz <= 6000000) {
 		if_freq = 4000000;
-		band = BANDWIDTH_6_MHZ;
 	} else if (c->bandwidth_hz <= 7000000) {
 		if_freq = 4500000;
-		band = BANDWIDTH_7_MHZ;
 	} else {	/* 8 MHz */
 		if_freq = 5000000;
-		band = BANDWIDTH_8_MHZ;
 	}
 	tuner_freq = c->frequency;
 
@@ -652,7 +642,7 @@ static int tda827xa_set_params(struct dvb_frontend *fe)
 		goto err;
 
 	priv->frequency = c->frequency;
-	priv->bandwidth = band;
+	priv->bandwidth = c->bandwidth_hz;
 
 	return 0;
 
diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index ce91c43..39e7e58 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -1028,17 +1028,7 @@ static int simple_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int simple_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 {
 	struct tuner_simple_priv *priv = fe->tuner_priv;
-	switch (priv->bandwidth) {
-	case 6000000:
-		*bandwidth = BANDWIDTH_6_MHZ;
-		break;
-	case 7000000:
-		*bandwidth = BANDWIDTH_7_MHZ;
-		break;
-	case 8000000:
-		*bandwidth = BANDWIDTH_8_MHZ;
-		break;
-	}
+	*bandwidth = priv->bandwidth;
 	return 0;
 }
 
diff --git a/drivers/media/common/tuners/xc4000.c b/drivers/media/common/tuners/xc4000.c
index d17c0f5..7b5a46e 100644
--- a/drivers/media/common/tuners/xc4000.c
+++ b/drivers/media/common/tuners/xc4000.c
@@ -1139,7 +1139,6 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 		dprintk(1, "%s() VSB modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_AIR;
 		priv->freq_hz = c->frequency - 1750000;
-		priv->bandwidth = BANDWIDTH_6_MHZ;
 		priv->video_standard = XC4000_DTV6;
 		type = DTV6;
 		break;
@@ -1147,7 +1146,6 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
 		priv->freq_hz = c->frequency - 1750000;
-		priv->bandwidth = BANDWIDTH_6_MHZ;
 		priv->video_standard = XC4000_DTV6;
 		type = DTV6;
 		break;
@@ -1156,26 +1154,21 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 		dprintk(1, "%s() OFDM\n", __func__);
 		if (bw == 0) {
 			if (c->frequency < 400000000) {
-				priv->bandwidth = BANDWIDTH_7_MHZ;
 				priv->freq_hz = c->frequency - 2250000;
 			} else {
-				priv->bandwidth = BANDWIDTH_8_MHZ;
 				priv->freq_hz = c->frequency - 2750000;
 			}
 			priv->video_standard = XC4000_DTV7_8;
 			type = DTV78;
 		} else if (bw <= 6000000) {
-			priv->bandwidth = BANDWIDTH_6_MHZ;
 			priv->video_standard = XC4000_DTV6;
 			priv->freq_hz = c->frequency - 1750000;
 			type = DTV6;
 		} else if (bw <= 7000000) {
-			priv->bandwidth = BANDWIDTH_7_MHZ;
 			priv->video_standard = XC4000_DTV7;
 			priv->freq_hz = c->frequency - 2250000;
 			type = DTV7;
 		} else {
-			priv->bandwidth = BANDWIDTH_8_MHZ;
 			priv->video_standard = XC4000_DTV8;
 			priv->freq_hz = c->frequency - 2750000;
 			type = DTV8;
@@ -1195,6 +1188,8 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 	if (check_firmware(fe, type, 0, priv->if_khz) != 0)
 		goto fail;
 
+	priv->bandwidth = c->bandwidth_hz;
+
 	ret = xc_set_signal_source(priv, priv->rf_mode);
 	if (ret != 0) {
 		printk(KERN_ERR "xc4000: xc_set_signal_source(%d) failed\n",
@@ -1591,7 +1586,7 @@ struct dvb_frontend *xc4000_attach(struct dvb_frontend *fe,
 		break;
 	case 1:
 		/* new tuner instance */
-		priv->bandwidth = BANDWIDTH_6_MHZ;
+		priv->bandwidth = 6000000;
 		/* set default configuration */
 		priv->if_khz = 4560;
 		priv->default_pm = 0;
diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 7796339..296df05 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -650,14 +650,12 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		dprintk(1, "%s() VSB modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_AIR;
 		priv->freq_hz = freq - 1750000;
-		priv->bandwidth = BANDWIDTH_6_MHZ;
 		priv->video_standard = DTV6;
 		break;
 	case SYS_DVBC_ANNEX_B:
 		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
 		priv->freq_hz = freq - 1750000;
-		priv->bandwidth = BANDWIDTH_6_MHZ;
 		priv->video_standard = DTV6;
 		break;
 	case SYS_DVBT:
@@ -665,17 +663,14 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		dprintk(1, "%s() OFDM\n", __func__);
 		switch (bw) {
 		case 6000000:
-			priv->bandwidth = BANDWIDTH_6_MHZ;
 			priv->video_standard = DTV6;
 			priv->freq_hz = freq - 1750000;
 			break;
 		case 7000000:
-			priv->bandwidth = BANDWIDTH_7_MHZ;
 			priv->video_standard = DTV7;
 			priv->freq_hz = freq - 2250000;
 			break;
 		case 8000000:
-			priv->bandwidth = BANDWIDTH_8_MHZ;
 			priv->video_standard = DTV8;
 			priv->freq_hz = freq - 2750000;
 			break;
@@ -689,17 +684,14 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
 		if (bw <= 6000000) {
-			priv->bandwidth = BANDWIDTH_6_MHZ;
 			priv->video_standard = DTV6;
 			priv->freq_hz = freq - 1750000;
 			b = 6;
 		} else if (bw <= 7000000) {
-			priv->bandwidth = BANDWIDTH_7_MHZ;
 			priv->video_standard = DTV7;
 			priv->freq_hz = freq - 2250000;
 			b = 7;
 		} else {
-			priv->bandwidth = BANDWIDTH_8_MHZ;
 			priv->video_standard = DTV7_8;
 			priv->freq_hz = freq - 2750000;
 			b = 8;
@@ -745,6 +737,8 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	if (debug)
 		xc_debug_dump(priv);
 
+	priv->bandwidth = bw;
+
 	return 0;
 }
 
@@ -1126,7 +1120,7 @@ struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 		break;
 	case 1:
 		/* new tuner instance */
-		priv->bandwidth = BANDWIDTH_6_MHZ;
+		priv->bandwidth = 6000000;
 		fe->tuner_priv = priv;
 		break;
 	default:
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
index 3a533df..72db6ee 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
@@ -279,7 +279,6 @@ static int mxl111sf_tuner_set_params(struct dvb_frontend *fe)
 	struct mxl111sf_tuner_state *state = fe->tuner_priv;
 	int ret;
 	u8 bw;
-	u32 band = BANDWIDTH_6_MHZ;
 
 	mxl_dbg("()");
 
@@ -297,11 +296,9 @@ static int mxl111sf_tuner_set_params(struct dvb_frontend *fe)
 			break;
 		case 7000000:
 			bw = 7;
-			band = BANDWIDTH_7_MHZ;
 			break;
 		case 8000000:
 			bw = 8;
-			band = BANDWIDTH_8_MHZ;
 			break;
 		default:
 			err("%s: bandwidth not set!", __func__);
@@ -317,7 +314,7 @@ static int mxl111sf_tuner_set_params(struct dvb_frontend *fe)
 		goto fail;
 
 	state->frequency = c->frequency;
-	state->bandwidth = band;
+	state->bandwidth = c->bandwidth_hz;
 fail:
 	return ret;
 }
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 08a0364..a8aefe9 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -220,7 +220,7 @@ static u32 af913_div(u32 a, u32 b, u32 x)
 	return r;
 }
 
-static int af9013_set_coeff(struct af9013_state *state, fe_bandwidth_t bw)
+static int af9013_set_coeff(struct af9013_state *state, u32 bw)
 {
 	int ret, i, j, found;
 	deb_info("%s: adc_clock:%d bw:%d\n", __func__,
diff --git a/drivers/media/dvb/frontends/af9013_priv.h b/drivers/media/dvb/frontends/af9013_priv.h
index 67efd16..80e6be3 100644
--- a/drivers/media/dvb/frontends/af9013_priv.h
+++ b/drivers/media/dvb/frontends/af9013_priv.h
@@ -62,7 +62,7 @@ struct snr_table {
 
 struct coeff {
 	u32 adc_clock;
-	fe_bandwidth_t bw;
+	u32 bw;
 	u8 val[24];
 };
 
diff --git a/drivers/media/dvb/frontends/dib3000mb_priv.h b/drivers/media/dvb/frontends/dib3000mb_priv.h
index 16c5265..9dc235a 100644
--- a/drivers/media/dvb/frontends/dib3000mb_priv.h
+++ b/drivers/media/dvb/frontends/dib3000mb_priv.h
@@ -98,7 +98,7 @@ struct dib3000_state {
 	int timing_offset;
 	int timing_offset_comp_done;
 
-	fe_bandwidth_t last_tuned_bw;
+	u32 last_tuned_bw;
 	u32 last_tuned_freq;
 };
 
diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb/frontends/dvb-pll.c
index 0625e61..95cb042 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -634,12 +634,7 @@ static int dvb_pll_set_params(struct dvb_frontend *fe)
 	}
 
 	priv->frequency = frequency;
-	if (c->bandwidth_hz <= 6000000)
-		priv->bandwidth = BANDWIDTH_6_MHZ;
-	else if (c->bandwidth_hz <= 7000000)
-		priv->bandwidth = BANDWIDTH_7_MHZ;
-	if (c->bandwidth_hz <= 8000000)
-		priv->bandwidth = BANDWIDTH_8_MHZ;
+	priv->bandwidth = c->bandwidth_hz;
 
 	return 0;
 }
-- 
1.7.8.352.g876a6

