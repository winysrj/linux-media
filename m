Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab1C1S4J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 14:56:09 -0400
Message-ID: <4D90D9BE.2080606@redhat.com>
Date: Mon, 28 Mar 2011 15:55:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Dmitry Belimov <d.belimov@gmail.com>,
	"Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org
Subject: [media] xc5000: Improve it to work better with 6MHz-spaced channels
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Brazil uses 6MHz-spaced channels. So, the nyquist filter for
DVB-C should be different, otherwise, inter-channel interference
may badly affect the device, and signal may not be properly decoded.

On my tests here, without this patch, sometimes channels are seen,
but, most of the time, PID filter returns with timeout.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 1e28f7d..3cb8473 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -628,6 +628,15 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality);
 }
 
+/*
+ * As defined on EN 300 429, the DVB-C roll-off factor is 0.15.
+ * So, the amount of the needed bandwith is given by:
+ * 	Bw = Symbol_rate * (1 + 0.15)
+ * As such, the maximum symbol rate supported by 6 MHz is given by:
+ *	max_symbol_rate = 6 MHz / 1.15 = 5217391 Bauds
+ */
+#define MAX_SYMBOL_RATE_6MHz	5217391
+
 static int xc5000_set_params(struct dvb_frontend *fe,
 	struct dvb_frontend_parameters *params)
 {
@@ -688,7 +697,6 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 		}
 		priv->rf_mode = XC_RF_MODE_AIR;
 	} else if (fe->ops.info.type == FE_QAM) {
-		dprintk(1, "%s() QAM\n", __func__);
 		switch (params->u.qam.modulation) {
 		case QAM_16:
 		case QAM_32:
@@ -697,12 +705,24 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 		case QAM_256:
 		case QAM_AUTO:
 			dprintk(1, "%s() QAM modulation\n", __func__);
-			priv->bandwidth = BANDWIDTH_8_MHZ;
-			priv->video_standard = DTV7_8;
-			priv->freq_hz = params->frequency - 2750000;
 			priv->rf_mode = XC_RF_MODE_CABLE;
+			/*
+			 * Using a 8MHz bandwidth sometimes fail
+			 * with 6MHz-spaced channels, due to inter-carrier
+			 * interference. So, use DTV6 firmware
+			 */
+			if (params->u.qam.symbol_rate <= MAX_SYMBOL_RATE_6MHz) {
+				priv->bandwidth = BANDWIDTH_6_MHZ;
+				priv->video_standard = DTV6;
+				priv->freq_hz = params->frequency - 1750000;
+			} else {
+				priv->bandwidth = BANDWIDTH_8_MHZ;
+				priv->video_standard = DTV7_8;
+				priv->freq_hz = params->frequency - 2750000;
+			}
 			break;
 		default:
+			dprintk(1, "%s() Unsupported QAM type\n", __func__);
 			return -EINVAL;
 		}
 	} else {
