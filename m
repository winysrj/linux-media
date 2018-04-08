Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:42564 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752412AbeDHRWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 13:22:31 -0400
Received: by mail-pf0-f194.google.com with SMTP id o16so4310243pfk.9
        for <linux-media@vger.kernel.org>; Sun, 08 Apr 2018 10:22:31 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        crope@iki.fi
Subject: [PATCH v5 5/5] dvb-usb-v2/gl861: ensure  USB message buffers DMA'able
Date: Mon,  9 Apr 2018 02:21:38 +0900
Message-Id: <20180408172138.9974-6-tskd08@gmail.com>
In-Reply-To: <20180408172138.9974-1-tskd08@gmail.com>
References: <20180408172138.9974-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

i2c message buf might be on stack.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v4:
- none

 drivers/media/usb/dvb-usb-v2/gl861.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index cdd7bfcb883..47b614da807 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -22,6 +22,8 @@ static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
 	u16 value = addr << (8 + 1);
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
 	u8 req, type;
+	u8 *buf;
+	int ret;
 
 	if (wo) {
 		req = GL861_REQ_I2C_WRITE;
@@ -44,11 +46,23 @@ static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
 				KBUILD_MODNAME, wlen);
 		return -EINVAL;
 	}
-
+	buf = NULL;
+	if (rlen > 0) {
+		buf = kmalloc(rlen, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+	}
 	usleep_range(1000, 2000); /* avoid I2C errors */
 
-	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), req, type,
-			       value, index, rbuf, rlen, 2000);
+	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), req, type,
+			      value, index, buf, rlen, 2000);
+	if (rlen > 0) {
+		if (ret > 0)
+			memcpy(rbuf, buf, rlen);
+		kfree(buf);
+	}
+
+	return ret;
 }
 
 /* Friio specific I2C read/write */
-- 
2.17.0
