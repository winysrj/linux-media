Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40756 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1KLP40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:56:26 -0500
Received: by wyh15 with SMTP id 15so4693629wyh.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:56:25 -0800 (PST)
Message-ID: <4ebe9728.4dc6e30a.47c5.ffff8fc3@mx.google.com>
Subject: [PATCH 5/7] af9015 usb bus repeater.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 15:56:20 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This a bus repeater for af9015 devices. Commands usually fail because of other
activity on the usb bus. 

Afatech drivers can repeat up to ten times on the usb bus.

bulk failures that report -ETIMEDOUT or -EBUSY are repeated. If the device fails
it usually return 0x55 in the first byte.

I am working on a patch to move parts of this to the dvb-usb common area to
be used by other drivers.


Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb/af9015.c |   61 ++++++++++++++++++++++--------------
 1 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 9077ac4..ac134b6 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -68,7 +68,7 @@ static struct af9013_config af9015_af9013_config[] = {
 	}
 };
 
-static int af9015_rw_udev(struct usb_device *udev, struct req_t *req)
+static int af9015_io_udev(struct usb_device *udev, struct req_t *req)
 {
 #define BUF_LEN 63
 #define REQ_HDR_LEN 8 /* send header size */
@@ -79,9 +79,6 @@ static int af9015_rw_udev(struct usb_device *udev, struct req_t *req)
 	u8 msg_len = REQ_HDR_LEN;
 	static u8 seq; /* packet sequence number */
 
-	if (mutex_lock_interruptible(&af9015_usb_mutex) < 0)
-		return -EAGAIN;
-
 	buf[0] = req->cmd;
 	buf[1] = seq++;
 	buf[2] = req->i2c_addr;
@@ -114,16 +111,14 @@ static int af9015_rw_udev(struct usb_device *udev, struct req_t *req)
 		break;
 	default:
 		err("unknown command:%d", req->cmd);
-		ret = -1;
-		goto error_unlock;
+		return -EINVAL;
 	}
 
 	/* buffer overflow check */
 	if ((write && (req->data_len > BUF_LEN - REQ_HDR_LEN)) ||
 		(!write && (req->data_len > BUF_LEN - ACK_HDR_LEN))) {
 		err("too much data; cmd:%d len:%d", req->cmd, req->data_len);
-		ret = -EINVAL;
-		goto error_unlock;
+		return -EINVAL;
 	}
 
 	/* write requested */
@@ -142,13 +137,13 @@ static int af9015_rw_udev(struct usb_device *udev, struct req_t *req)
 		err("bulk message failed:%d (%d/%d)", ret, msg_len, act_len);
 	else
 		if (act_len != msg_len)
-			ret = -1; /* all data is not send */
+			return -EAGAIN; /* all data is not send */
 	if (ret)
-		goto error_unlock;
+		goto error;
 
 	/* no ack for those packets */
 	if (req->cmd == DOWNLOAD_FIRMWARE || req->cmd == RECONNECT_USB)
-		goto exit_unlock;
+		return 0;
 
 	/* write receives seq + status = 2 bytes
 	   read receives seq + status + data = 2 + N bytes */
@@ -158,30 +153,48 @@ static int af9015_rw_udev(struct usb_device *udev, struct req_t *req)
 
 	ret = usb_bulk_msg(udev, usb_rcvbulkpipe(udev, 0x81), buf, msg_len,
 		&act_len, AF9015_USB_TIMEOUT);
-	if (ret) {
-		err("recv bulk message failed:%d", ret);
-		ret = -1;
-		goto error_unlock;
-	}
+	if (ret)
+		goto error;
 
 	deb_xfer("<<< ");
 	debug_dump(buf, act_len, deb_xfer);
 
 	/* check status */
-	if (buf[1]) {
-		err("command failed:%d", buf[1]);
-		ret = -1;
-		goto error_unlock;
-	}
+	if (buf[1])
+		return -EAGAIN;
 
 	/* read request, copy returned data to return buf */
 	if (!write)
 		memcpy(req->data, &buf[ACK_HDR_LEN], req->data_len);
 
-error_unlock:
-exit_unlock:
-	mutex_unlock(&af9015_usb_mutex);
+error:
+	if (ret == -ETIMEDOUT || ret == -EBUSY)
+		return -EAGAIN;
+
+	return ret;
+}
+
+#define AF9015_RETRY 5
+static int af9015_rw_udev(struct usb_device *udev, struct req_t *req)
+{
+	int ret = 0, i;
+
+	if (mutex_lock_interruptible(&af9015_usb_mutex) < 0)
+		return -EAGAIN;
+
+	for (i = 0; i < AF9015_RETRY; i++) {
+		if (req == NULL)
+			break;
+		ret = af9015_io_udev(udev, req);
+		if (ret != -EAGAIN)
+			break;
+		udelay(250);
+	}
+	if (ret && req)
+		err("Command failed:%x i2c addr:%x error:%d",
+			req->cmd, req->i2c_addr, ret);
 
+	mutex_unlock(&af9015_usb_mutex);
 	return ret;
 }
 
-- 
1.7.5.4




