Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53375 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab3BZRYJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:24:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/5] af9035: do not use buffers from stack for usb_bulk_msg()
Date: Tue, 26 Feb 2013 19:23:04 +0200
Message-Id: <1361899386-22946-3-git-send-email-crope@iki.fi>
In-Reply-To: <1361899386-22946-1-git-send-email-crope@iki.fi>
References: <1361899386-22946-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 44 +++++++++++++++++------------------
 drivers/media/usb/dvb-usb-v2/af9035.h |  2 ++
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index f11cc42..565d8da 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -41,43 +41,45 @@ static u16 af9035_checksum(const u8 *buf, size_t len)
 
 static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 {
-#define BUF_LEN 64
 #define REQ_HDR_LEN 4 /* send header size */
 #define ACK_HDR_LEN 3 /* rece header size */
 #define CHECKSUM_LEN 2
 #define USB_TIMEOUT 2000
 	struct state *state = d_to_priv(d);
 	int ret, wlen, rlen;
-	u8 buf[BUF_LEN];
 	u16 checksum, tmp_checksum;
 
+	mutex_lock(&d->usb_mutex);
+
 	/* buffer overflow check */
 	if (req->wlen > (BUF_LEN - REQ_HDR_LEN - CHECKSUM_LEN) ||
 			req->rlen > (BUF_LEN - ACK_HDR_LEN - CHECKSUM_LEN)) {
 		dev_err(&d->udev->dev, "%s: too much data wlen=%d rlen=%d\n",
 				__func__, req->wlen, req->rlen);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
-	buf[0] = REQ_HDR_LEN + req->wlen + CHECKSUM_LEN - 1;
-	buf[1] = req->mbox;
-	buf[2] = req->cmd;
-	buf[3] = state->seq++;
-	memcpy(&buf[REQ_HDR_LEN], req->wbuf, req->wlen);
+	state->buf[0] = REQ_HDR_LEN + req->wlen + CHECKSUM_LEN - 1;
+	state->buf[1] = req->mbox;
+	state->buf[2] = req->cmd;
+	state->buf[3] = state->seq++;
+	memcpy(&state->buf[REQ_HDR_LEN], req->wbuf, req->wlen);
 
 	wlen = REQ_HDR_LEN + req->wlen + CHECKSUM_LEN;
 	rlen = ACK_HDR_LEN + req->rlen + CHECKSUM_LEN;
 
 	/* calc and add checksum */
-	checksum = af9035_checksum(buf, buf[0] - 1);
-	buf[buf[0] - 1] = (checksum >> 8);
-	buf[buf[0] - 0] = (checksum & 0xff);
+	checksum = af9035_checksum(state->buf, state->buf[0] - 1);
+	state->buf[state->buf[0] - 1] = (checksum >> 8);
+	state->buf[state->buf[0] - 0] = (checksum & 0xff);
 
 	/* no ack for these packets */
 	if (req->cmd == CMD_FW_DL)
 		rlen = 0;
 
-	ret = dvb_usbv2_generic_rw(d, buf, wlen, buf, rlen);
+	ret = dvb_usbv2_generic_rw_locked(d,
+			state->buf, wlen, state->buf, rlen);
 	if (ret)
 		goto err;
 
@@ -86,8 +88,8 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 		goto exit;
 
 	/* verify checksum */
-	checksum = af9035_checksum(buf, rlen - 2);
-	tmp_checksum = (buf[rlen - 2] << 8) | buf[rlen - 1];
+	checksum = af9035_checksum(state->buf, rlen - 2);
+	tmp_checksum = (state->buf[rlen - 2] << 8) | state->buf[rlen - 1];
 	if (tmp_checksum != checksum) {
 		dev_err(&d->udev->dev, "%s: command=%02x checksum mismatch " \
 				"(%04x != %04x)\n", KBUILD_MODNAME, req->cmd,
@@ -97,23 +99,21 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 	}
 
 	/* check status */
-	if (buf[2]) {
+	if (state->buf[2]) {
 		dev_dbg(&d->udev->dev, "%s: command=%02x failed fw error=%d\n",
-				__func__, req->cmd, buf[2]);
+				__func__, req->cmd, state->buf[2]);
 		ret = -EIO;
 		goto err;
 	}
 
 	/* read request, copy returned data to return buf */
 	if (req->rlen)
-		memcpy(req->rbuf, &buf[ACK_HDR_LEN], req->rlen);
-
+		memcpy(req->rbuf, &state->buf[ACK_HDR_LEN], req->rlen);
 exit:
-	return 0;
-
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-
+	mutex_unlock(&d->usb_mutex);
+	if (ret)
+		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 29f3eec..6d098a9 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -52,6 +52,8 @@ struct usb_req {
 };
 
 struct state {
+#define BUF_LEN 64
+	u8 buf[BUF_LEN];
 	u8 seq; /* packet sequence number */
 	bool dual_mode;
 	struct af9033_config af9033_config[2];
-- 
1.7.11.7

