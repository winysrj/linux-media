Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51164 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab2AOSVM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 13:21:12 -0500
Received: from dyn3-82-128-184-189.psoas.suomi.net ([82.128.184.189] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1RmUhZ-0004f8-PR
	for linux-media@vger.kernel.org; Sun, 15 Jan 2012 20:21:09 +0200
Message-ID: <4F131902.8060305@iki.fi>
Date: Sun, 15 Jan 2012 20:20:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH FOR 3.3] anysee: do not attach same frontend twice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cxd2820r implements only one frontend currently which
handles all the standards.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
  drivers/media/dvb/dvb-usb/anysee.c |   20 +++++++-------------
  1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/anysee.c 
b/drivers/media/dvb/dvb-usb/anysee.c
index df46015..ecc3add 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -877,24 +877,18 @@ static int anysee_frontend_attach(struct 
dvb_usb_adapter *adap)
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
