Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab3CZFcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 01:32:21 -0400
Received: by mail-bk0-f46.google.com with SMTP id je9so1116442bkc.5
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 22:32:20 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 13:32:19 +0800
Message-ID: <CAPgLHd8Ow5eV=zrOJ7PxWtOFn2qLwVd_Ys2LNE3ddL4gf3EFQg@mail.gmail.com>
Subject: [PATCH -next] [media] af9035: fix missing unlock on error in af9035_ctrl_msg()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: crope@iki.fi, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function af9035_ctrl_msg()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index b1f7059..b638fc1 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -57,7 +57,7 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 		dev_err(&d->udev->dev, "%s: too much data wlen=%d rlen=%d\n",
 				__func__, req->wlen, req->rlen);
 		ret = -EINVAL;
-		goto err;
+		goto exit;
 	}
 
 	state->buf[0] = REQ_HDR_LEN + req->wlen + CHECKSUM_LEN - 1;
@@ -81,7 +81,7 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 	ret = dvb_usbv2_generic_rw_locked(d,
 			state->buf, wlen, state->buf, rlen);
 	if (ret)
-		goto err;
+		goto exit;
 
 	/* no ack for those packets */
 	if (req->cmd == CMD_FW_DL)
@@ -95,28 +95,29 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 				"(%04x != %04x)\n", KBUILD_MODNAME, req->cmd,
 				tmp_checksum, checksum);
 		ret = -EIO;
-		goto err;
+		goto exit;
 	}
 
 	/* check status */
 	if (state->buf[2]) {
 		/* fw returns status 1 when IR code was not received */
-		if (req->cmd == CMD_IR_GET || state->buf[2] == 1)
-			return 1;
+		if (req->cmd == CMD_IR_GET || state->buf[2] == 1) {
+			ret = 1;
+			goto exit;
+		}
 
 		dev_dbg(&d->udev->dev, "%s: command=%02x failed fw error=%d\n",
 				__func__, req->cmd, state->buf[2]);
 		ret = -EIO;
-		goto err;
+		goto exit;
 	}
 
 	/* read request, copy returned data to return buf */
 	if (req->rlen)
 		memcpy(req->rbuf, &state->buf[ACK_HDR_LEN], req->rlen);
 exit:
-err:
 	mutex_unlock(&d->usb_mutex);
-	if (ret)
+	if (ret < 0)
 		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }


