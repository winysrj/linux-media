Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52993 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2AOUWY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 15:22:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] anysee: do not attach same frontend twice
Date: Sun, 15 Jan 2012 22:21:53 +0200
Message-Id: <1326658914-3451-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cxd2820r implements only one frontend currently which
handles all the standards.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/anysee.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index df46015..ecc3add 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -877,24 +877,18 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 	case ANYSEE_HW_508T2C: /* 20 */
 		/* E7 T2C */
 
+		if (state->fe_id)
+			break;
+
 		/* enable DVB-T/T2/C demod on IOE[5] */
 		ret = anysee_wr_reg_mask(adap->dev, REG_IOE, (1 << 5), 0x20);
 		if (ret)
 			goto error;
 
-		if (state->fe_id == 0)  {
-			/* DVB-T/T2 */
-			adap->fe_adap[state->fe_id].fe =
-				dvb_attach(cxd2820r_attach,
-				&anysee_cxd2820r_config,
-				&adap->dev->i2c_adap, NULL);
-		} else {
-			/* DVB-C */
-			adap->fe_adap[state->fe_id].fe =
-				dvb_attach(cxd2820r_attach,
-				&anysee_cxd2820r_config,
-				&adap->dev->i2c_adap, adap->fe_adap[0].fe);
-		}
+		/* attach demod */
+		adap->fe_adap[state->fe_id].fe = dvb_attach(cxd2820r_attach,
+				&anysee_cxd2820r_config, &adap->dev->i2c_adap,
+				NULL);
 
 		state->has_ci = true;
 
-- 
1.7.4.4

