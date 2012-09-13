Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39145 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653Ab2IMAY2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:28 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/16] ce6230: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:57 +0300
Message-Id: <1347495837-3244-16-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/ce6230.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/ce6230.c b/drivers/media/usb/dvb-usb-v2/ce6230.c
index 1c4357d..f67b14b 100644
--- a/drivers/media/usb/dvb-usb-v2/ce6230.c
+++ b/drivers/media/usb/dvb-usb-v2/ce6230.c
@@ -49,7 +49,8 @@ static int ce6230_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 		requesttype = (USB_TYPE_VENDOR | USB_DIR_OUT);
 		break;
 	default:
-		pr_debug("%s: unknown command=%02x\n", __func__, req->cmd);
+		dev_err(&d->udev->dev, "%s: unknown command=%02x\n",
+				KBUILD_MODNAME, req->cmd);
 		ret = -EINVAL;
 		goto error;
 	}
@@ -78,8 +79,8 @@ static int ce6230_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 			buf, req->data_len);
 
 	if (ret < 0)
-		pr_err("%s: usb_control_msg() failed=%d\n", KBUILD_MODNAME,
-				ret);
+		dev_err(&d->udev->dev, "%s: usb_control_msg() failed=%d\n",
+				KBUILD_MODNAME, ret);
 	else
 		ret = 0;
 
@@ -121,7 +122,8 @@ static int ce6230_i2c_master_xfer(struct i2c_adapter *adap,
 				req.data = &msg[i+1].buf[0];
 				ret = ce6230_ctrl_msg(d, &req);
 			} else {
-				pr_err("%s: I2C read not implemented\n",
+				dev_err(&d->udev->dev, "%s: I2C read not " \
+						"implemented\n",
 						KBUILD_MODNAME);
 				ret = -EOPNOTSUPP;
 			}
@@ -176,10 +178,12 @@ static struct zl10353_config ce6230_zl10353_config = {
 
 static int ce6230_zl10353_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	pr_debug("%s:\n", __func__);
+	struct dvb_usb_device *d = adap_to_d(adap);
+
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	adap->fe[0] = dvb_attach(zl10353_attach, &ce6230_zl10353_config,
-			&adap_to_d(adap)->i2c_adap);
+			&d->i2c_adap);
 	if (adap->fe[0] == NULL)
 		return -ENODEV;
 
@@ -205,12 +209,12 @@ static struct mxl5005s_config ce6230_mxl5003s_config = {
 
 static int ce6230_mxl5003s_tuner_attach(struct dvb_usb_adapter *adap)
 {
+	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
 
-	pr_debug("%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-	ret = dvb_attach(mxl5005s_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap,
+	ret = dvb_attach(mxl5005s_attach, adap->fe[0], &d->i2c_adap,
 			&ce6230_mxl5003s_config) == NULL ? -ENODEV : 0;
 	return ret;
 }
@@ -219,14 +223,14 @@ static int ce6230_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	int ret;
 
-	pr_debug("%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
 
 	/* InterfaceNumber 1 / AlternateSetting 0     idle
 	   InterfaceNumber 1 / AlternateSetting 1     streaming */
 	ret = usb_set_interface(d->udev, 1, onoff);
 	if (ret)
-		pr_err("%s: usb_set_interface() failed=%d\n", KBUILD_MODNAME,
-				ret);
+		dev_err(&d->udev->dev, "%s: usb_set_interface() failed=%d\n",
+				KBUILD_MODNAME, ret);
 
 	return ret;
 }
-- 
1.7.11.4

