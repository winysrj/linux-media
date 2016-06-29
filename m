Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbcF2Wng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/10] xc5000: add support to return RF strength
Date: Wed, 29 Jun 2016 19:43:17 -0300
Message-Id: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The xc5000 tuner is able to return the gain used to adjust the
signal level. With that, it can return an estimation of the
signal strength. So, add support for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/xc5000.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index e6e5e90d8d95..91ad392eb60c 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -569,6 +569,26 @@ static int xc_get_totalgain(struct xc5000_priv *priv, u16 *totalgain)
 	return xc5000_readreg(priv, XREG_TOTALGAIN, totalgain);
 }
 
+static int xc5000_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	int ret;
+	u16 gain = 0;
+
+	*strength = 0;
+
+	ret = xc_get_totalgain(priv, &gain);
+	if (ret < 0)
+		return ret;
+
+	*strength = 65535 - gain;
+
+	dprintk(1, "Signal strength = 0x%04x (gain = 0x%04x)\n",
+		*strength, gain);
+
+	return 0;
+}
+
 static u16 wait_for_lock(struct xc5000_priv *priv)
 {
 	u16 lock_state = 0;
@@ -706,9 +726,10 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	xc_get_analogsnr(priv,  &snr);
 	dprintk(1, "*** Unweighted analog SNR = %d dB\n", snr & 0x3f);
 
+	// With au0828, signal strength is given by (aprox) = 30-gain dBm
 	xc_get_totalgain(priv,  &totalgain);
-	dprintk(1, "*** Total gain = %d.%d dB\n", totalgain / 256,
-		(totalgain % 256) * 100 / 256);
+	dprintk(1, "*** Total gain = %d.%d dB (0x%04x)\n", totalgain / 256,
+		(totalgain % 256) * 100 / 256, totalgain);
 
 	if (priv->pll_register_no) {
 		xc5000_readreg(priv, priv->pll_register_no, &regval);
@@ -1390,7 +1411,8 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.get_frequency	   = xc5000_get_frequency,
 	.get_if_frequency  = xc5000_get_if_frequency,
 	.get_bandwidth	   = xc5000_get_bandwidth,
-	.get_status	   = xc5000_get_status
+	.get_status	   = xc5000_get_status,
+	.get_rf_strength   = xc5000_get_rf_strength
 };
 
 struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
-- 
2.7.4

