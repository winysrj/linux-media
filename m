Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43048 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab3CJCEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:44 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 40/41] af9035: style changes for remote controller polling
Date: Sun, 10 Mar 2013 04:03:32 +0200
Message-Id: <1362881013-5271-40-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index a1ae5c5..c35fab8 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1221,10 +1221,10 @@ err:
 #if IS_ENABLED(CONFIG_RC_CORE)
 static int af9035_rc_query(struct dvb_usb_device *d)
 {
-	unsigned int key;
-	unsigned char b[4];
 	int ret;
-	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, b };
+	u32 key;
+	u8 buf[4];
+	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, buf };
 
 	ret = af9035_ctrl_msg(d, &req);
 	if (ret == 1)
@@ -1232,18 +1232,21 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 	else if (ret < 0)
 		goto err;
 
-	if ((b[2] + b[3]) == 0xff) {
-		if ((b[0] + b[1]) == 0xff) {
-			/* NEC */
-			key = b[0] << 8 | b[2];
+	if ((buf[2] + buf[3]) == 0xff) {
+		if ((buf[0] + buf[1]) == 0xff) {
+			/* NEC standard 16bit */
+			key = buf[0] << 8 | buf[2];
 		} else {
-			/* ext. NEC */
-			key = b[0] << 16 | b[1] << 8 | b[2];
+			/* NEC extended 24bit */
+			key = buf[0] << 16 | buf[1] << 8 | buf[2];
 		}
 	} else {
-		key = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
+		/* NEC full code 32bit */
+		key = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
 	}
 
+	dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 4, buf);
+
 	rc_keydown(d->rc_dev, key, 0);
 
 	return 0;
-- 
1.7.11.7

