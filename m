Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52914 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbaIDVnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 17:43:51 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] dvb-usb-v2: add frontend_detach callback
Date: Fri,  5 Sep 2014 00:43:41 +0300
Message-Id: <1409867023-8362-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add frontend_detach callback in order to allow custom detach. It is
needed when demod driver is implemented I2C client or some other
kernel bus, but not proprietary dvb_attach / dvb_detach.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  2 ++
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 124b4ba..7e36ee0 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -214,6 +214,7 @@ struct dvb_usb_adapter_properties {
  * @read_config: called to resolve device configuration
  * @read_mac_address: called to resolve adapter mac-address
  * @frontend_attach: called to attach the possible frontends
+ * @frontend_detach: called to detach the possible frontends
  * @tuner_attach: called to attach the possible tuners
  * @frontend_ctrl: called to power on/off active frontend
  * @streaming_ctrl: called to start/stop the usb streaming of adapter
@@ -254,6 +255,7 @@ struct dvb_usb_device_properties {
 	int (*read_config) (struct dvb_usb_device *d);
 	int (*read_mac_address) (struct dvb_usb_adapter *, u8 []);
 	int (*frontend_attach) (struct dvb_usb_adapter *);
+	int (*frontend_detach)(struct dvb_usb_adapter *);
 	int (*tuner_attach) (struct dvb_usb_adapter *);
 	int (*frontend_ctrl) (struct dvb_frontend *, int);
 	int (*streaming_ctrl) (struct dvb_frontend *, int);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 6c33d85..92bb297 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -664,9 +664,10 @@ err:
 
 static int dvb_usbv2_adapter_frontend_exit(struct dvb_usb_adapter *adap)
 {
-	int i;
-	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=%d\n", __func__,
-			adap->id);
+	int ret, i;
+	struct dvb_usb_device *d = adap_to_d(adap);
+
+	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, adap->id);
 
 	for (i = MAX_NO_OF_FE_PER_ADAP - 1; i >= 0; i--) {
 		if (adap->fe[i]) {
@@ -675,6 +676,15 @@ static int dvb_usbv2_adapter_frontend_exit(struct dvb_usb_adapter *adap)
 		}
 	}
 
+	if (d->props->frontend_detach) {
+		ret = d->props->frontend_detach(adap);
+		if (ret < 0) {
+			dev_dbg(&d->udev->dev,
+					"%s: frontend_detach() failed=%d\n",
+					__func__, ret);
+		}
+	}
+
 	return 0;
 }
 
-- 
http://palosaari.fi/

