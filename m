Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39340 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaLWVWt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:22:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 61/66] rtl28xxu: move usb buffers to state
Date: Tue, 23 Dec 2014 22:49:54 +0200
Message-Id: <1419367799-14263-61-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Buffer needed for USB control message is small so move it to state
and get rid of alloc/free used for each control message.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 31 +++++++++----------------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  1 +
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index e3312a2..b0d2467 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -29,20 +29,14 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 {
+	struct rtl28xxu_dev *dev = d->priv;
 	int ret;
 	unsigned int pipe;
 	u8 requesttype;
-	u8 *buf;
-
-	buf = kmalloc(req->size, GFP_KERNEL);
-	if (!buf) {
-		ret = -ENOMEM;
-		goto err;
-	}
 
 	if (req->index & CMD_WR_FLAG) {
 		/* write */
-		memcpy(buf, req->data, req->size);
+		memcpy(dev->buf, req->data, req->size);
 		requesttype = (USB_TYPE_VENDOR | USB_DIR_OUT);
 		pipe = usb_sndctrlpipe(d->udev, 0);
 	} else {
@@ -52,24 +46,17 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 	}
 
 	ret = usb_control_msg(d->udev, pipe, 0, requesttype, req->value,
-			req->index, buf, req->size, 1000);
-
+			req->index, dev->buf, req->size, 1000);
 	dvb_usb_dbg_usb_control_msg(d->udev, 0, requesttype, req->value,
-			req->index, buf, req->size);
-
-	if (ret > 0)
-		ret = 0;
+			req->index, dev->buf, req->size);
+	if (ret < 0)
+		goto err;
 
 	/* read request, copy returned data to return buf */
-	if (!ret && requesttype == (USB_TYPE_VENDOR | USB_DIR_IN))
-		memcpy(req->data, buf, req->size);
-
-	kfree(buf);
+	if (requesttype == (USB_TYPE_VENDOR | USB_DIR_IN))
+		memcpy(req->data, dev->buf, req->size);
 
-	if (ret)
-		goto err;
-
-	return ret;
+	return 0;
 err:
 	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index abf0111..1b5d7ff 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -69,6 +69,7 @@
 
 
 struct rtl28xxu_dev {
+	u8 buf[28];
 	u8 chip_id;
 	u8 tuner;
 	char *tuner_name;
-- 
http://palosaari.fi/

