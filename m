Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53364 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab2IQU6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 16:58:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/7] rtl28xxu: do not return error for unimplemented fe callback
Date: Mon, 17 Sep 2012 23:58:08 +0300
Message-Id: <1347915492-24924-3-git-send-email-crope@iki.fi>
In-Reply-To: <1347915492-24924-1-git-send-email-crope@iki.fi>
References: <1347915492-24924-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of frontend callback is highly hardware design dependent
and whole callback could be optional in many cases. Returning
error by default when callback is not implemented is stupid.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a1fe982..1f18244 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -591,7 +591,6 @@ static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 		goto err;
 	}
 	return 0;
-
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
@@ -643,7 +642,6 @@ static int rtl2832u_tua9001_tuner_callback(struct dvb_usb_device *d,
 	}
 
 	return 0;
-
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
@@ -656,17 +654,15 @@ static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
 	switch (priv->tuner) {
 	case TUNER_RTL2832_FC0012:
 		return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
-
 	case TUNER_RTL2832_FC0013:
 		return rtl2832u_fc0013_tuner_callback(d, cmd, arg);
-
 	case TUNER_RTL2832_TUA9001:
 		return rtl2832u_tua9001_tuner_callback(d, cmd, arg);
 	default:
 		break;
 	}
 
-	return -ENODEV;
+	return 0;
 }
 
 static int rtl2832u_frontend_callback(void *adapter_priv, int component,
@@ -682,7 +678,7 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 		break;
 	}
 
-	return -EINVAL;
+	return 0;
 }
 
 static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
-- 
1.7.11.4

