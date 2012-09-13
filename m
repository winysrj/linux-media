Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56842 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab2IMAY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/16] ec168: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:56 +0300
Message-Id: <1347495837-3244-15-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/ec168.c | 40 +++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/ec168.c b/drivers/media/usb/dvb-usb-v2/ec168.c
index b6a9c5b..5c68f39 100644
--- a/drivers/media/usb/dvb-usb-v2/ec168.c
+++ b/drivers/media/usb/dvb-usb-v2/ec168.c
@@ -61,7 +61,8 @@ static int ec168_ctrl_msg(struct dvb_usb_device *d, struct ec168_req *req)
 		request = DEMOD_RW;
 		break;
 	default:
-		pr_err("%s: unknown command=%02x\n", KBUILD_MODNAME, req->cmd);
+		dev_err(&d->udev->dev, "%s: unknown command=%02x\n",
+				KBUILD_MODNAME, req->cmd);
 		ret = -EINVAL;
 		goto error;
 	}
@@ -104,7 +105,7 @@ static int ec168_ctrl_msg(struct dvb_usb_device *d, struct ec168_req *req)
 err_dealloc:
 	kfree(buf);
 error:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -136,7 +137,8 @@ static int ec168_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				ret = ec168_ctrl_msg(d, &req);
 				i += 2;
 			} else {
-				pr_err("%s: I2C read not implemented\n",
+				dev_err(&d->udev->dev, "%s: I2C read not " \
+						"implemented\n",
 						KBUILD_MODNAME);
 				ret = -EOPNOTSUPP;
 				i += 2;
@@ -187,13 +189,13 @@ static int ec168_identify_state(struct dvb_usb_device *d, const char **name)
 	int ret;
 	u8 reply;
 	struct ec168_req req = {GET_CONFIG, 0, 1, sizeof(reply), &reply};
-	pr_debug("%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	ret = ec168_ctrl_msg(d, &req);
 	if (ret)
 		goto error;
 
-	pr_debug("%s: reply=%02x\n", __func__, reply);
+	dev_dbg(&d->udev->dev, "%s: reply=%02x\n", __func__, reply);
 
 	if (reply == 0x01)
 		ret = WARM;
@@ -202,7 +204,7 @@ static int ec168_identify_state(struct dvb_usb_device *d, const char **name)
 
 	return ret;
 error:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -211,7 +213,7 @@ static int ec168_download_firmware(struct dvb_usb_device *d,
 {
 	int ret, len, remaining;
 	struct ec168_req req = {DOWNLOAD_FIRMWARE, 0, 0, 0, NULL};
-	pr_debug("%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	#define LEN_MAX 2048 /* max packet size */
 	for (remaining = fw->size; remaining > 0; remaining -= LEN_MAX) {
@@ -225,7 +227,8 @@ static int ec168_download_firmware(struct dvb_usb_device *d,
 
 		ret = ec168_ctrl_msg(d, &req);
 		if (ret) {
-			pr_err("%s: firmware download failed=%d\n",
+			dev_err(&d->udev->dev,
+					"%s: firmware download failed=%d\n",
 					KBUILD_MODNAME, ret);
 			goto error;
 		}
@@ -259,7 +262,7 @@ static int ec168_download_firmware(struct dvb_usb_device *d,
 
 	return ret;
 error:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -269,9 +272,11 @@ static struct ec100_config ec168_ec100_config = {
 
 static int ec168_ec100_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	pr_debug("%s:\n", __func__);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
 	adap->fe[0] = dvb_attach(ec100_attach, &ec168_ec100_config,
-			&adap_to_d(adap)->i2c_adap);
+			&d->i2c_adap);
 	if (adap->fe[0] == NULL)
 		return -ENODEV;
 
@@ -297,19 +302,22 @@ static struct mxl5005s_config ec168_mxl5003s_config = {
 
 static int ec168_mxl5003s_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	pr_debug("%s:\n", __func__);
-	return dvb_attach(mxl5005s_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap,
+	struct dvb_usb_device *d = adap_to_d(adap);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	return dvb_attach(mxl5005s_attach, adap->fe[0], &d->i2c_adap,
 			&ec168_mxl5003s_config) == NULL ? -ENODEV : 0;
 }
 
 static int ec168_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 {
+	struct dvb_usb_device *d = fe_to_d(fe);
 	struct ec168_req req = {STREAMING_CTRL, 0x7f01, 0x0202, 0, NULL};
-	pr_debug("%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
+
 	if (onoff)
 		req.index = 0x0102;
-	return ec168_ctrl_msg(fe_to_d(fe), &req);
+	return ec168_ctrl_msg(d, &req);
 }
 
 /* DVB USB Driver stuff */
-- 
1.7.11.4

