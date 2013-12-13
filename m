Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58615 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab3LMAoU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 19:44:20 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] anysee: fix non-working E30 Combo Plus DVB-T
Date: Fri, 13 Dec 2013 02:43:59 +0200
Message-Id: <1386895439-8434-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PLL was attached twice to frontend0 leaving frontend1 without a tuner.
frontend0 is DVB-C and frontend1 is DVB-T.

Power also demods properly in order to provide gated I2C for tuner
during attach. dvb-pll attaches PLL even probing fails, but correct
it still...

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 90cfa35..8d0d3a7 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -442,6 +442,7 @@ static struct cxd2820r_config anysee_cxd2820r_config = {
  * IOD[0] ZL10353 1=enabled
  * IOE[0] tuner 0=enabled
  * tuner is behind ZL10353 I2C-gate
+ * tuner is behind TDA10023 I2C-gate
  *
  * E7 TC VID=1c73 PID=861f HW=18 FW=0.7 AMTCI=0.5 "anysee-E7TC(LP)"
  * PCB: 508TC (rev0.6)
@@ -950,17 +951,24 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 			break;
 		}
 
+		anysee_frontend_ctrl(adap->fe[0], 1);
+
 		/* attach tuner */
 		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc0 >> 1),
 				&d->i2c_adap, DVB_PLL_SAMSUNG_DTOS403IH102A);
 
+		anysee_frontend_ctrl(adap->fe[0], 0);
+
 		if (fe && adap->fe[1]) {
+			anysee_frontend_ctrl(adap->fe[1], 1);
+
 			/* attach tuner for 2nd FE */
-			fe = dvb_attach(dvb_pll_attach, adap->fe[0],
+			fe = dvb_attach(dvb_pll_attach, adap->fe[1],
 					(0xc0 >> 1), &d->i2c_adap,
 					DVB_PLL_SAMSUNG_DTOS403IH102A);
-		}
 
+			anysee_frontend_ctrl(adap->fe[1], 0);
+		}
 		break;
 	case ANYSEE_HW_508TC: /* 18 */
 	case ANYSEE_HW_508PTC: /* 21 */
-- 
1.8.4.2

