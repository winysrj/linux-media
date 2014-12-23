Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42425 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaLWVXW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:23:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 56/66] rtl28xxu: do not refcount rtl2832_sdr module
Date: Tue, 23 Dec 2014 22:49:49 +0200
Message-Id: <1419367799-14263-56-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver, rtl28xxu, offers frontend service for rtl2832_sdr
module, thus we are producer and rtl2832_sdr module is consumer.
Due to that, reference counting should be done in way rtl2832_sdr
takes refrence to rtl28xxu. Remove wrong refcount.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index f475018..27cf341 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1142,16 +1142,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		pdata.v4l2_subdev = subdev;
 
 		request_module("%s", "rtl2832_sdr");
-		pdev = platform_device_register_data(&priv->i2c_client_demod->dev,
+		pdev = platform_device_register_data(&d->intf->dev,
 						     "rtl2832_sdr",
 						     PLATFORM_DEVID_AUTO,
 						     &pdata, sizeof(pdata));
 		if (pdev == NULL || pdev->dev.driver == NULL)
 			break;
-		if (!try_module_get(pdev->dev.driver->owner)) {
-			platform_device_unregister(pdev);
-			break;
-		}
 		priv->platform_device_sdr = pdev;
 		break;
 	default:
@@ -1175,10 +1171,8 @@ static int rtl2832u_tuner_detach(struct dvb_usb_adapter *adap)
 
 	/* remove platform SDR */
 	pdev = priv->platform_device_sdr;
-	if (pdev) {
-		module_put(pdev->dev.driver->owner);
+	if (pdev)
 		platform_device_unregister(pdev);
-	}
 
 	/* remove I2C tuner */
 	client = priv->i2c_client_tuner;
-- 
http://palosaari.fi/

