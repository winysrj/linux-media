Return-path: <linux-media-owner@vger.kernel.org>
Received: from twinsen.zall.org ([109.74.194.249]:57563 "EHLO twinsen.zall.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751661AbdDARjn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Apr 2017 13:39:43 -0400
Date: Sat, 1 Apr 2017 17:34:32 +0000
From: Alyssa Milburn <amilburn@zall.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/4] ttusb2: limit messages to buffer size
Message-ID: <6f19a57e8f0cee89aa8b1a68c7cd4cb4be032ebd.1491066251.git.amilburn@zall.org>
References: <cover.1491066251.git.amilburn@zall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <cover.1491066251.git.amilburn@zall.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise ttusb2_i2c_xfer can read or write beyond the end of static and
heap buffers.

Signed-off-by: Alyssa Milburn <amilburn@zall.org>
---
 drivers/media/usb/dvb-usb/ttusb2.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-usb/ttusb2.c
index ecc207fbaf3c..9e0d6a4166d2 100644
--- a/drivers/media/usb/dvb-usb/ttusb2.c
+++ b/drivers/media/usb/dvb-usb/ttusb2.c
@@ -78,6 +78,9 @@ static int ttusb2_msg(struct dvb_usb_device *d, u8 cmd,
 	u8 *s, *r = NULL;
 	int ret = 0;
 
+	if (4 + rlen > 64)
+		return -EIO;
+
 	s = kzalloc(wlen+4, GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
@@ -381,6 +384,22 @@ static int ttusb2_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num
 		write_read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
 		read = msg[i].flags & I2C_M_RD;
 
+		if (3 + msg[i].len > sizeof(obuf)) {
+			err("i2c wr len=%d too high", msg[i].len);
+			break;
+		}
+		if (write_read) {
+			if (3 + msg[i+1].len > sizeof(ibuf)) {
+				err("i2c rd len=%d too high", msg[i+1].len);
+				break;
+			}
+		} else if (read) {
+			if (3 + msg[i].len > sizeof(ibuf)) {
+				err("i2c rd len=%d too high", msg[i].len);
+				break;
+			}
+		}
+
 		obuf[0] = (msg[i].addr << 1) | (write_read | read);
 		if (read)
 			obuf[1] = 0;
-- 
2.11.0
