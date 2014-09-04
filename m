Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48594 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbaIDVnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 17:43:51 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] dvb-usb-v2: add tuner_detach callback
Date: Fri,  5 Sep 2014 00:43:42 +0300
Message-Id: <1409867023-8362-2-git-send-email-crope@iki.fi>
In-Reply-To: <1409867023-8362-1-git-send-email-crope@iki.fi>
References: <1409867023-8362-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add tuner_detach callback in order to allow custom detach. It is
needed when tuner driver is implemented I2C client or some other
kernel bus, but not proprietary dvb_attach / dvb_detach.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      | 1 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 7e36ee0..14e111e 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -257,6 +257,7 @@ struct dvb_usb_device_properties {
 	int (*frontend_attach) (struct dvb_usb_adapter *);
 	int (*frontend_detach)(struct dvb_usb_adapter *);
 	int (*tuner_attach) (struct dvb_usb_adapter *);
+	int (*tuner_detach)(struct dvb_usb_adapter *);
 	int (*frontend_ctrl) (struct dvb_frontend *, int);
 	int (*streaming_ctrl) (struct dvb_frontend *, int);
 	int (*init) (struct dvb_usb_device *);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 92bb297..a05be7d 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -676,6 +676,14 @@ static int dvb_usbv2_adapter_frontend_exit(struct dvb_usb_adapter *adap)
 		}
 	}
 
+	if (d->props->tuner_detach) {
+		ret = d->props->tuner_detach(adap);
+		if (ret < 0) {
+			dev_dbg(&d->udev->dev, "%s: tuner_detach() failed=%d\n",
+					__func__, ret);
+		}
+	}
+
 	if (d->props->frontend_detach) {
 		ret = d->props->frontend_detach(adap);
 		if (ret < 0) {
-- 
http://palosaari.fi/

