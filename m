Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:38073 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753004AbeC1RBm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 13:01:42 -0400
Received: by mail-pl0-f68.google.com with SMTP id m22-v6so1962291pls.5
        for <linux-media@vger.kernel.org>; Wed, 28 Mar 2018 10:01:42 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        crope@iki.fi
Subject: [PATCH v4 5/5] dvb-usb-v2/gl861: ensure  USB message buffers DMA'able
Date: Thu, 29 Mar 2018 02:01:01 +0900
Message-Id: <20180328170101.29385-6-tskd08@gmail.com>
In-Reply-To: <20180328170101.29385-1-tskd08@gmail.com>
References: <20180328170101.29385-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

i2c message buf might be on stack.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v3:
- none

 drivers/media/usb/dvb-usb-v2/gl861.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index 6f6dfa65bba..a5c83b561a4 100644
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
2.16.3
