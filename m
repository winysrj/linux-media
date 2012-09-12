Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56494 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab2ILC1m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 22:27:42 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <mair.thomas86@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/8] af9035: relax frontend callback error handling
Date: Wed, 12 Sep 2012 05:27:06 +0300
Message-Id: <1347416831-1413-3-git-send-email-crope@iki.fi>
In-Reply-To: <1347416831-1413-1-git-send-email-crope@iki.fi>
References: <1347416831-1413-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not good idea to return error for missing callback
handler as whole callback as optional and could be missing
by intentionally.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index b700444..fdec3b1 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -652,7 +652,7 @@ static int af9035_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
 		break;
 	}
 
-	return -ENODEV;
+	return 0;
 }
 
 static int af9035_frontend_callback(void *adapter_priv, int component,
@@ -661,6 +661,9 @@ static int af9035_frontend_callback(void *adapter_priv, int component,
 	struct i2c_adapter *adap = adapter_priv;
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 
+	dev_dbg(&d->udev->dev, "%s: component=%d cmd=%d arg=%d\n",
+			__func__, component, cmd, arg);
+
 	switch (component) {
 	case DVB_FRONTEND_COMPONENT_TUNER:
 		return af9035_tuner_callback(d, cmd, arg);
@@ -668,7 +671,7 @@ static int af9035_frontend_callback(void *adapter_priv, int component,
 		break;
 	}
 
-	return -EINVAL;
+	return 0;
 }
 
 static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
-- 
1.7.11.4

