Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55655 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbbEEV7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 21/21] rtl28xxu: load SDR module for fc2580 based devices
Date: Wed,  6 May 2015 00:58:42 +0300
Message-Id: <1430863122-9888-21-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Load rtl2832_sdr driver for devices having fc2580 tuner.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 41f8808..d8866af 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1119,6 +1119,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				break;
 			}
 			dev->i2c_client_tuner = client;
+			subdev = fc2580_pdata.get_v4l2_subdev(client);
 		}
 		break;
 	case TUNER_RTL2832_TUA9001: {
@@ -1184,6 +1185,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 
 	/* register SDR */
 	switch (dev->tuner) {
+	case TUNER_RTL2832_FC2580:
 	case TUNER_RTL2832_FC0012:
 	case TUNER_RTL2832_FC0013:
 	case TUNER_RTL2832_E4000:
-- 
http://palosaari.fi/

