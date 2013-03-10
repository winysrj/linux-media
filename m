Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55842 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab3CJCEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:44 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 39/41] af9035: check I/O errors on IR polling
Date: Sun, 10 Mar 2013 04:03:31 +0200
Message-Id: <1362881013-5271-39-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use more careful error checks.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index ecec69d..a1ae5c5 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -98,6 +98,10 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 
 	/* check status */
 	if (buf[2]) {
+		/* fw returns status 1 when IR code was not received */
+		if (req->cmd == CMD_IR_GET || buf[2] == 1)
+			return 1;
+
 		dev_dbg(&d->udev->dev, "%s: command=%02x failed fw error=%d\n",
 				__func__, req->cmd, buf[2]);
 		ret = -EIO;
@@ -1223,7 +1227,9 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, b };
 
 	ret = af9035_ctrl_msg(d, &req);
-	if (ret < 0)
+	if (ret == 1)
+		return 0;
+	else if (ret < 0)
 		goto err;
 
 	if ((b[2] + b[3]) == 0xff) {
@@ -1240,9 +1246,12 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 
 	rc_keydown(d->rc_dev, key, 0);
 
-err:
-	/* ignore errors */
 	return 0;
+
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
 }
 
 static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
-- 
1.7.11.7

