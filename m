Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53959 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab2HUX5H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 19:57:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 4/5] rtl2832: implement .read_snr()
Date: Wed, 22 Aug 2012 02:56:21 +0300
Message-Id: <1345593382-11367-4-git-send-email-crope@iki.fi>
In-Reply-To: <1345593382-11367-1-git-send-email-crope@iki.fi>
References: <1345593382-11367-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based rtl2830 implementation.

Cc: Thomas Mair <thomas.mair86@googlemail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 52 +++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 6e28444..dad8ab5 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -19,6 +19,7 @@
  */
 
 #include "rtl2832_priv.h"
+#include "dvb_math.h"
 #include <linux/bitops.h>
 
 int rtl2832_debug;
@@ -355,7 +356,6 @@ err:
 
 }
 
-
 static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	int ret;
@@ -379,8 +379,6 @@ err:
 	return ret;
 }
 
-
-
 static int rtl2832_init(struct dvb_frontend *fe)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
@@ -780,6 +778,52 @@ err:
 	return ret;
 }
 
+static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	int ret, hierarchy, constellation;
+	u8 buf[2], tmp;
+	u16 tmp16;
+#define CONSTELLATION_NUM 3
+#define HIERARCHY_NUM 4
+	static const u32 snr_constant[CONSTELLATION_NUM][HIERARCHY_NUM] = {
+		{ 85387325, 85387325, 85387325, 85387325 },
+		{ 86676178, 86676178, 87167949, 87795660 },
+		{ 87659938, 87659938, 87885178, 88241743 },
+	};
+
+	/* reports SNR in resolution of 0.1 dB */
+
+	ret = rtl2832_rd_reg(priv, 0x3c, 3, &tmp);
+	if (ret)
+		goto err;
+
+	constellation = (tmp >> 2) & 0x03; /* [3:2] */
+	if (constellation > CONSTELLATION_NUM - 1)
+		goto err;
+
+	hierarchy = (tmp >> 4) & 0x07; /* [6:4] */
+	if (hierarchy > HIERARCHY_NUM - 1)
+		goto err;
+
+	ret = rtl2832_rd_regs(priv, 0x0c, 4, buf, 2);
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
+	return 0;
+err:
+	dbg("%s: failed=%d", __func__, ret);
+	return ret;
+}
+
 static struct dvb_frontend_ops rtl2832_ops;
 
 static void rtl2832_release(struct dvb_frontend *fe)
@@ -864,6 +908,8 @@ static struct dvb_frontend_ops rtl2832_ops = {
 	.get_frontend = rtl2832_get_frontend,
 
 	.read_status = rtl2832_read_status,
+	.read_snr = rtl2832_read_snr,
+
 	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
 };
 
-- 
1.7.11.4

