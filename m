Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51975 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaKDBHQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 20:07:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/6] af9033: fix DVBv3 snr value not correct issue
Date: Tue,  4 Nov 2014 03:07:02 +0200
Message-Id: <1415063224-28453-4-git-send-email-crope@iki.fi>
In-Reply-To: <1415063224-28453-1-git-send-email-crope@iki.fi>
References: <1415063224-28453-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bimow Chen <Bimow.Chen@ite.com.tw>

Snr returns value not correct. Fix it.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c      | 61 +++++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/af9033_priv.h |  5 ++-
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 3f688de..a490033 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -849,14 +849,42 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
+	int ret;
+	u8 u8tmp;
 
 	/* use DVBv5 CNR */
-	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
-		*snr = div_s64(c->cnr.stat[0].svalue, 100); /* 1000x => 10x */
-	else
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL) {
+		*snr = div_s64(c->cnr.stat[0].svalue, 1000);
+
+		/* read current modulation */
+		ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
+		if (ret)
+			goto err;
+
+		/* scale value to 0x0000-0xffff */
+		switch ((u8tmp >> 0) & 3) {
+		case 0:
+			*snr = *snr * 0xFFFF / 23;
+			break;
+		case 1:
+			*snr = *snr * 0xFFFF / 26;
+			break;
+		case 2:
+			*snr = *snr * 0xFFFF / 32;
+			break;
+		default:
+			goto err;
+		}
+	} else {
 		*snr = 0;
+	}
 
 	return 0;
+
+err:
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+
+	return ret;
 }
 
 static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
@@ -1044,6 +1072,33 @@ static void af9033_stat_work(struct work_struct *work)
 
 		snr_val = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
 
+		/* read superframe number */
+		ret = af9033_rd_reg(dev, 0x80f78b, &u8tmp);
+		if (ret)
+			goto err;
+
+		if (u8tmp)
+			snr_val /= u8tmp;
+
+		/* read current transmission mode */
+		ret = af9033_rd_reg(dev, 0x80f900, &u8tmp);
+		if (ret)
+			goto err;
+
+		switch ((u8tmp >> 0) & 3) {
+		case 0:
+			snr_val *= 4;
+			break;
+		case 1:
+			snr_val *= 1;
+			break;
+		case 2:
+			snr_val *= 2;
+			break;
+		default:
+			goto err;
+		}
+
 		/* read current modulation */
 		ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
 		if (ret)
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index c9c8798..8e23275 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -181,7 +181,10 @@ static const struct val_snr qam64_snr_lut[] = {
 	{ 0x05570d, 26 },
 	{ 0x059feb, 27 },
 	{ 0x05bf38, 28 },
-	{ 0xffffff, 29 },
+	{ 0x05f78f, 29 },
+	{ 0x0612c3, 30 },
+	{ 0x0626be, 31 },
+	{ 0xffffff, 32 },
 };
 
 static const struct reg_val ofsm_init[] = {
-- 
http://palosaari.fi/

