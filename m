Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46780 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbbJJQqA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 12:46:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl28xxu: fix control message flaws
Date: Sat, 10 Oct 2015 19:45:30 +0300
Message-Id: <1444495530-1674-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add lock to prevent concurrent access for control message as control
message function uses shared buffer. Without the lock there may be
remote control polling which messes the buffer causing IO errors.
Increase buffer size and add check for maximum supported message
length.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=103391
Fixes: c56222a6b25c ("[media] rtl28xxu: move usb buffers to state")
Cc: <stable@vger.kernel.org> # 4.0+
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 15 +++++++++++++--
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  2 +-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c3cac4c..197a4f2 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -34,6 +34,14 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 	unsigned int pipe;
 	u8 requesttype;
 
+	mutex_lock(&d->usb_mutex);
+
+	if (req->size > sizeof(dev->buf)) {
+		dev_err(&d->intf->dev, "too large message %u\n", req->size);
+		ret = -EINVAL;
+		goto err_mutex_unlock;
+	}
+
 	if (req->index & CMD_WR_FLAG) {
 		/* write */
 		memcpy(dev->buf, req->data, req->size);
@@ -50,14 +58,17 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 	dvb_usb_dbg_usb_control_msg(d->udev, 0, requesttype, req->value,
 			req->index, dev->buf, req->size);
 	if (ret < 0)
-		goto err;
+		goto err_mutex_unlock;
 
 	/* read request, copy returned data to return buf */
 	if (requesttype == (USB_TYPE_VENDOR | USB_DIR_IN))
 		memcpy(req->data, dev->buf, req->size);
 
+	mutex_unlock(&d->usb_mutex);
+
 	return 0;
-err:
+err_mutex_unlock:
+	mutex_unlock(&d->usb_mutex);
 	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 9f6115a..1380629 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -71,7 +71,7 @@
 
 
 struct rtl28xxu_dev {
-	u8 buf[28];
+	u8 buf[128];
 	u8 chip_id;
 	u8 tuner;
 	char *tuner_name;
-- 
http://palosaari.fi/

