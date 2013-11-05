Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3KENDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 22/29] [media] cxusb: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:35 -0200
Message-Id: <1383645702-30636-23-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb/cxusb.c:209:1: warning: 'cxusb_i2c_xfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/cxusb.c:69:1: warning: 'cxusb_ctrl_msg' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb/cxusb.c | 41 +++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 3940bb0f9ef6..20e345d9fe8f 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -43,6 +43,9 @@
 #include "lgs8gxx.h"
 #include "atbm8830.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /* debug */
 static int dvb_usb_cxusb_debug;
 module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
@@ -57,7 +60,14 @@ static int cxusb_ctrl_msg(struct dvb_usb_device *d,
 			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
-	u8 sndbuf[1+wlen];
+	u8 sndbuf[MAX_XFER_SIZE];
+
+	if (1 + wlen > sizeof(sndbuf)) {
+		warn("i2c wr: len=%d is too big!\n",
+		     wlen);
+		return -EOPNOTSUPP;
+	}
+
 	memset(sndbuf, 0, 1+wlen);
 
 	sndbuf[0] = cmd;
@@ -158,7 +168,13 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 
 		if (msg[i].flags & I2C_M_RD) {
 			/* read only */
-			u8 obuf[3], ibuf[1+msg[i].len];
+			u8 obuf[3], ibuf[MAX_XFER_SIZE];
+
+			if (1 + msg[i].len > sizeof(ibuf)) {
+				warn("i2c rd: len=%d is too big!\n",
+				     msg[i].len);
+				return -EOPNOTSUPP;
+			}
 			obuf[0] = 0;
 			obuf[1] = msg[i].len;
 			obuf[2] = msg[i].addr;
@@ -172,7 +188,18 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		} else if (i+1 < num && (msg[i+1].flags & I2C_M_RD) &&
 			   msg[i].addr == msg[i+1].addr) {
 			/* write to then read from same address */
-			u8 obuf[3+msg[i].len], ibuf[1+msg[i+1].len];
+			u8 obuf[MAX_XFER_SIZE], ibuf[MAX_XFER_SIZE];
+
+			if (3 + msg[i].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[i].len);
+				return -EOPNOTSUPP;
+			}
+			if (1 + msg[i + 1].len > sizeof(ibuf)) {
+				warn("i2c rd: len=%d is too big!\n",
+				     msg[i + 1].len);
+				return -EOPNOTSUPP;
+			}
 			obuf[0] = msg[i].len;
 			obuf[1] = msg[i+1].len;
 			obuf[2] = msg[i].addr;
@@ -191,7 +218,13 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			i++;
 		} else {
 			/* write only */
-			u8 obuf[2+msg[i].len], ibuf;
+			u8 obuf[MAX_XFER_SIZE], ibuf;
+
+			if (2 + msg[i].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[i].len);
+				return -EOPNOTSUPP;
+			}
 			obuf[0] = msg[i].addr;
 			obuf[1] = msg[i].len;
 			memcpy(&obuf[2], msg[i].buf, msg[i].len);
-- 
1.8.3.1

