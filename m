Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52514 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042AbaIDChB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/37] af9035: do not attach IT9135 tuner
Date: Thu,  4 Sep 2014 05:36:19 +0300
Message-Id: <1409798205-25645-11-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove IT9135 tuner attach for a while as we will convert IT9135
driver to Kernel I2C model.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index f37cf7d..0ec8919 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1235,9 +1235,12 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
 		/* attach tuner */
+		/*
 		fe = dvb_attach(it913x_attach, adap->fe[0], &d->i2c_adap,
 				state->af9033_config[adap->id].i2c_addr,
 				state->af9033_config[0].tuner);
+		*/
+		fe = NULL;
 		break;
 	default:
 		fe = NULL;
-- 
http://palosaari.fi/

