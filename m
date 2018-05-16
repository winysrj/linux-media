Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46941 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeEPUca (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 16:32:30 -0400
From: mika.batsman@gmail.com
To: crope@iki.fi, mchehab@kernel.org
Cc: linux-media@vger.kernel.org,
        =?UTF-8?q?Mika=20B=C3=A5tsman?= <mika.batsman@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] media: gl861: fix probe of dvb_usb_gl861
Date: Wed, 16 May 2018 23:32:19 +0300
Message-Id: <1526502739-20887-1-git-send-email-mika.batsman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mika Båtsman <mika.batsman@gmail.com>

Probe of dvb_usb_gl861 was working at least with v4.4. Noticed the issue
with v4.13 but according to similar issues the problem started with v4.9.

[   15.288065] transfer buffer not dma capable
[   15.288090] WARNING: CPU: 2 PID: 493 at drivers/usb/core/hcd.c:1595 usb_hcd_map_urb_for_dma+0x4e2/0x640
...CUT...
[   15.288791] dvb_usb_gl861: probe of 3-7:1.0 failed with error -5

Tested with MSI Mega Sky 580 DVB-T Tuner [GL861]

Cc: stable@vger.kernel.org
Signed-off-by: Mika Båtsman <mika.batsman@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/gl861.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index b1b09c5..0a988e3 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -20,15 +20,22 @@ static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
 	u16 value = addr << (8 + 1);
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
 	u8 req, type;
+	int ret;
+	void *dmadata;
 
 	if (wo) {
 		req = GL861_REQ_I2C_WRITE;
 		type = GL861_WRITE;
+		dmadata = kmemdup(wbuf, wlen, GFP_KERNEL);
 	} else { /* rw */
 		req = GL861_REQ_I2C_READ;
 		type = GL861_READ;
+		dmadata = kmalloc(rlen, GFP_KERNEL);
 	}
 
+	if (!dmadata)
+		return -ENOMEM;
+
 	switch (wlen) {
 	case 1:
 		index = wbuf[0];
@@ -45,8 +52,14 @@ static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
 
 	msleep(1); /* avoid I2C errors */
 
-	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), req, type,
-			       value, index, rbuf, rlen, 2000);
+	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), req, type,
+			       value, index, dmadata, rlen, 2000);
+
+	if (!wo)
+		memcpy(rbuf, dmadata, rlen);
+
+	kfree(dmadata);
+	return ret;
 }
 
 /* I2C */
-- 
2.7.4
