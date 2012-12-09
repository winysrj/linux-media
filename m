Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38153 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758878Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 02/17] af9035: support for Fitipower FC0012 tuner devices
Date: Sun,  9 Dec 2012 21:56:13 +0200
Message-Id: <1355082988-6211-2-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 26 ++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/af9035.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 61ae7f9..c1ec18c 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -514,6 +514,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		case AF9033_TUNER_MXL5007T:
 		case AF9033_TUNER_TDA18218:
 		case AF9033_TUNER_FC2580:
+		case AF9033_TUNER_FC0012:
 			state->af9033_config[i].spec_inv = 1;
 			break;
 		default:
@@ -907,6 +908,31 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		fe = dvb_attach(fc2580_attach, adap->fe[0],
 				&d->i2c_adap, &af9035_fc2580_config);
 		break;
+	case AF9033_TUNER_FC0012:
+		/*
+		 * AF9035 gpiot2 = FC0012 enable
+		 * XXX: there seems to be something on gpioh8 too, but on my
+		 * my test I didn't find any difference.
+		 */
+
+		/* configure gpiot2 as output and high */
+		ret = af9035_wr_reg_mask(d, 0xd8eb, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg_mask(d, 0xd8ec, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg_mask(d, 0xd8ed, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		usleep_range(10000, 50000);
+
+		fe = dvb_attach(fc0012_attach, adap->fe[0], &d->i2c_adap, 0x63,
+				1, FC_XTAL_36_MHZ);
+		break;
 	default:
 		fe = NULL;
 	}
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 75ef1ec..f509d35 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -26,6 +26,7 @@
 #include "af9033.h"
 #include "tua9001.h"
 #include "fc0011.h"
+#include "fc0012.h"
 #include "mxl5007t.h"
 #include "tda18218.h"
 #include "fc2580.h"
-- 
1.7.11.7

