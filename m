Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47099 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616AbaLWUu3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:29 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 18/66] rtl2830: wrap DVBv5 CNR to DVBv3 SNR
Date: Tue, 23 Dec 2014 22:49:11 +0200
Message-Id: <1419367799-14263-18-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change legacy DVBv3 read SNR to return values calculated by DVBv5
statistics.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 44 ++----------------------------
 drivers/media/dvb-frontends/rtl2830_priv.h |  1 +
 2 files changed, 4 insertions(+), 41 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 0112b3f..f1f1cfb 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -544,52 +544,14 @@ err:
 
 static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct i2c_client *client = fe->demodulator_priv;
-	struct rtl2830_dev *dev = i2c_get_clientdata(client);
-	int ret, hierarchy, constellation;
-	u8 buf[2], tmp;
-	u16 tmp16;
-#define CONSTELLATION_NUM 3
-#define HIERARCHY_NUM 4
-	static const u32 snr_constant[CONSTELLATION_NUM][HIERARCHY_NUM] = {
-		{70705899, 70705899, 70705899, 70705899},
-		{82433173, 82433173, 87483115, 94445660},
-		{92888734, 92888734, 95487525, 99770748},
-	};
-
-	if (dev->sleeping)
-		return 0;
-
-	/* reports SNR in resolution of 0.1 dB */
-
-	ret = rtl2830_rd_reg(client, 0x33c, &tmp);
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
-	ret = rtl2830_rd_regs(client, 0x40c, buf, 2);
-	if (ret)
-		goto err;
-
-	tmp16 = buf[0] << 8 | buf[1];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	if (tmp16)
-		*snr = (snr_constant[constellation][hierarchy] -
-				intlog10(tmp16)) / ((1 << 24) / 100);
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
+		*snr = div_s64(c->cnr.stat[0].svalue, 100);
 	else
 		*snr = 0;
 
 	return 0;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
 }
 
 static int rtl2830_read_ber(struct dvb_frontend *fe, u32 *ber)
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 6636834..6a0e982 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -22,6 +22,7 @@
 #include "dvb_math.h"
 #include "rtl2830.h"
 #include <linux/i2c-mux.h>
+#include <linux/math64.h>
 
 struct rtl2830_dev {
 	struct rtl2830_platform_data *pdata;
-- 
http://palosaari.fi/

