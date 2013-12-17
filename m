Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53241 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3LQAIT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 19:08:19 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, stable@vger.kernel.org
Subject: [PATCH] anysee: fix non-working E30 Combo Plus DVB-T
Date: Tue, 17 Dec 2013 02:08:04 +0200
Message-Id: <1387238884-29009-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PLL was attached twice to frontend0 leaving frontend1 without a tuner.
frontend0 is DVB-C and frontend1 is DVB-T.

Cc: stable@vger.kernel.org
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 90cfa35..eeab79b 100644
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
@@ -956,7 +957,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 
 		if (fe && adap->fe[1]) {
 			/* attach tuner for 2nd FE */
-			fe = dvb_attach(dvb_pll_attach, adap->fe[0],
+			fe = dvb_attach(dvb_pll_attach, adap->fe[1],
 					(0xc0 >> 1), &d->i2c_adap,
 					DVB_PLL_SAMSUNG_DTOS403IH102A);
 		}
-- 
1.8.4.2

