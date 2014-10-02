Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:41488 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaJBFbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 01:31:19 -0400
Subject: [PATCH 2/2] af9033: fix DVBv3 snr value not correct issue
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi
Content-Type: multipart/mixed; boundary="=-abxS3wMHSXrBY9XvznDh"
Date: Thu, 02 Oct 2014 13:34:38 +0800
Message-ID: <1412228078.1699.4.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-abxS3wMHSXrBY9XvznDh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Snr returns value not correct. Fix it.

--=-abxS3wMHSXrBY9XvznDh
Content-Disposition: attachment; filename="0002-af9033-fix-DVBv3-snr-value-not-correct-issue.patch"
Content-Type: text/x-patch; name="0002-af9033-fix-DVBv3-snr-value-not-correct-issue.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 7b7d83e669e1c7a041241c7412fd05a5ca73815c Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Thu, 2 Oct 2014 10:37:13 +0800
Subject: [PATCH 2/2] af9033: fix DVBv3 snr value not correct issue

Snr returns value not correct. Fix it.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/dvb-frontends/af9033.c      |   61 +++++++++++++++++++++++++++-
 drivers/media/dvb-frontends/af9033_priv.h |    5 ++-
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 2b3d2f0..ad4ff78 100644
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
@@ -1038,6 +1066,33 @@ static void af9033_stat_work(struct work_struct *work)
 
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
1.7.0.4


--=-abxS3wMHSXrBY9XvznDh--

