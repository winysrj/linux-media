Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37895 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965941Ab2EOWcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 18:32:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl2830: implement .read_snr()
Date: Wed, 16 May 2012 01:32:33 +0300
Message-Id: <1337121153-16982-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reports value as a 0.1 dB.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/rtl2830.c      |   42 +++++++++++++++++++++++++++-
 drivers/media/dvb/frontends/rtl2830_priv.h |    1 +
 2 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/rtl2830.c b/drivers/media/dvb/frontends/rtl2830.c
index 45196c5..bd18dbe 100644
--- a/drivers/media/dvb/frontends/rtl2830.c
+++ b/drivers/media/dvb/frontends/rtl2830.c
@@ -404,8 +404,48 @@ err:
 
 static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	*snr = 0;
+	struct rtl2830_priv *priv = fe->demodulator_priv;
+	int ret, hierarchy, constellation;
+	u8 buf[2], tmp;
+	u16 tmp16;
+#define CONSTELLATION_NUM 3
+#define HIERARCHY_NUM 4
+	static const u32 snr_constant[CONSTELLATION_NUM][HIERARCHY_NUM] = {
+		{ 70705899, 70705899, 70705899, 70705899 },
+		{ 82433173, 82433173, 87483115, 94445660 },
+		{ 92888734, 92888734, 95487525, 99770748 },
+	};
+
+	/* reports SNR in resolution of 0.1 dB */
+
+	ret = rtl2830_rd_reg(priv, 0x33c, &tmp);
+	if (ret)
+		goto err;
+
+	constellation = (tmp >> 2) & 0x03; /* [3:2] */
+	if (constellation > CONSTELLATION_NUM - 1)
+		goto err;
+
+	hierarchy = (tmp >> 4) & 0x03; /* [5:4] */
+	if (hierarchy > HIERARCHY_NUM - 1)
+		goto err;
+
+	ret = rtl2830_rd_regs(priv, 0x40c, buf, 2);
+	if (ret)
+		goto err;
+
+	tmp16 = buf[0] << 8 | buf[1];
+
+	if (tmp16)
+		*snr = (snr_constant[constellation][hierarchy] -
+				intlog10(tmp16)) / ((1 << 24) / 100);
+	else
+		*snr = 0;
+
 	return 0;
+err:
+	dbg("%s: failed=%d", __func__, ret);
+	return ret;
 }
 
 static int rtl2830_read_ber(struct dvb_frontend *fe, u32 *ber)
diff --git a/drivers/media/dvb/frontends/rtl2830_priv.h b/drivers/media/dvb/frontends/rtl2830_priv.h
index 4a46476..9b20557 100644
--- a/drivers/media/dvb/frontends/rtl2830_priv.h
+++ b/drivers/media/dvb/frontends/rtl2830_priv.h
@@ -22,6 +22,7 @@
 #define RTL2830_PRIV_H
 
 #include "dvb_frontend.h"
+#include "dvb_math.h"
 #include "rtl2830.h"
 
 #define LOG_PREFIX "rtl2830"
-- 
1.7.7.6

