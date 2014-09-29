Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:52075 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaI2Ioa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 04:44:30 -0400
Subject: [PATCH 2/2] af9033: fix snr value not correct issue
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi
Content-Type: multipart/mixed; boundary="=-/XpKs2nAvlpx0Uk5ygu6"
Date: Mon, 29 Sep 2014 16:47:38 +0800
Message-ID: <1411980458.1747.12.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-/XpKs2nAvlpx0Uk5ygu6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Snr returns value not correct. Fix it.

--=-/XpKs2nAvlpx0Uk5ygu6
Content-Disposition: attachment; filename="0002-af9033-fix-snr-value-not-correct-issue.patch"
Content-Type: text/x-patch; name="0002-af9033-fix-snr-value-not-correct-issue.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 427a5c6ef49e3235ac35a0464c375f2a2706619e Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Mon, 29 Sep 2014 16:30:52 +0800
Subject: [PATCH 2/2] af9033: fix snr value not correct issue

Snr returns value not correct. Fix it.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/dvb-frontends/af9033.c      |   52 ++++++++++++++++++++++++++---
 drivers/media/dvb-frontends/af9033_priv.h |    5 ++-
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index e191bd5..30dc366 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -851,8 +851,8 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 
 	/* use DVBv5 CNR */
-	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
-		*snr = div_s64(c->cnr.stat[0].svalue, 100); /* 1000x => 10x */
+	if (c->cnr.stat[0].scale == FE_SCALE_RELATIVE)
+		*snr = c->cnr.stat[0].uvalue;
 	else
 		*snr = 0;
 
@@ -1025,6 +1025,33 @@ static void af9033_stat_work(struct work_struct *work)
 
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
@@ -1048,14 +1075,29 @@ static void af9033_stat_work(struct work_struct *work)
 		}
 
 		for (i = 0; i < len; i++) {
-			tmp = snr_lut[i].snr * 1000;
+			tmp = snr_lut[i].snr;
 			if (snr_val < snr_lut[i].val)
 				break;
 		}
 
+		/* scale value to 0x0000-0xffff */
+		switch ((u8tmp >> 0) & 3) {
+		case 0:
+			tmp = tmp * 0xFFFF / 23;
+			break;
+		case 1:
+			tmp = tmp * 0xFFFF / 26;
+			break;
+		case 2:
+			tmp = tmp * 0xFFFF / 32;
+			break;
+		default:
+			goto err;
+		}
+
 		c->cnr.len = 1;
-		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-		c->cnr.stat[0].svalue = tmp;
+		c->cnr.stat[0].scale = FE_SCALE_RELATIVE;
+		c->cnr.stat[0].uvalue = tmp;
 	} else {
 		c->cnr.len = 1;
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
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


--=-/XpKs2nAvlpx0Uk5ygu6--

