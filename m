Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51003 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbaLWUuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 33/66] rtl2832: wrap DVBv5 CNR to DVBv3 SNR
Date: Tue, 23 Dec 2014 22:49:26 +0200
Message-Id: <1419367799-14263-33-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change legacy DVBv3 read SNR to return values calculated by DVBv5
statistics.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 42 +++---------------------------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 2 files changed, 5 insertions(+), 38 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index cd53311..b5a8c79 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -791,49 +791,15 @@ err:
 
 static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct rtl2832_dev *dev = fe->demodulator_priv;
-	struct i2c_client *client = dev->client;
-	int ret, hierarchy, constellation;
-	u8 buf[2], tmp;
-	u16 tmp16;
-#define CONSTELLATION_NUM 3
-#define HIERARCHY_NUM 4
-	static const u32 snr_constant[CONSTELLATION_NUM][HIERARCHY_NUM] = {
-		{ 85387325, 85387325, 85387325, 85387325 },
-		{ 86676178, 86676178, 87167949, 87795660 },
-		{ 87659938, 87659938, 87885178, 88241743 },
-	};
-
-	/* reports SNR in resolution of 0.1 dB */
-
-	ret = rtl2832_rd_reg(dev, 0x3c, 3, &tmp);
-	if (ret)
-		goto err;
-
-	constellation = (tmp >> 2) & 0x03; /* [3:2] */
-	if (constellation > CONSTELLATION_NUM - 1)
-		goto err;
-
-	hierarchy = (tmp >> 4) & 0x07; /* [6:4] */
-	if (hierarchy > HIERARCHY_NUM - 1)
-		goto err;
-
-	ret = rtl2832_rd_regs(dev, 0x0c, 4, buf, 2);
-	if (ret)
-		goto err;
-
-	tmp16 = buf[0] << 8 | buf[1];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	if (tmp16)
-		*snr = (snr_constant[constellation][hierarchy] -
-				intlog10(tmp16)) / ((1 << 24) / 100);
+	/* report SNR in resolution of 0.1 dB */
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
+		*snr = div_s64(c->cnr.stat[0].svalue, 100);
 	else
 		*snr = 0;
 
 	return 0;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
 }
 
 static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index a5f5ccd..5e90cd4 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -25,6 +25,7 @@
 #include "rtl2832.h"
 #include <linux/i2c-mux.h>
 #include <linux/regmap.h>
+#include <linux/math64.h>
 
 struct rtl2832_dev {
 	struct rtl2832_platform_data *pdata;
-- 
http://palosaari.fi/

