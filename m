Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3KBQdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:39 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCHv2 23/29] cxusb: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:31 -0200
Message-Id: <1383399097-11615-24-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/usb/dvb-usb/cxusb.c:209:1: warning: 'cxusb_i2c_xfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/cxusb.c:69:1: warning: 'cxusb_ctrl_msg' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (80 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/usb/dvb-usb/cxusb.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 3940bb0f9ef6..7d21def6b145 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -57,7 +57,14 @@ static int cxusb_ctrl_msg(struct dvb_usb_device *d,
 			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
-	u8 sndbuf[1+wlen];
+	u8 sndbuf[80];
+
+	if (1 + wlen > sizeof(sndbuf)) {
+		warn("i2c wr: len=%d is too big!\n",
+		     wlen);
+		return -EREMOTEIO;
+	}
+
 	memset(sndbuf, 0, 1+wlen);
 
 	sndbuf[0] = cmd;
@@ -158,7 +165,13 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 
 		if (msg[i].flags & I2C_M_RD) {
 			/* read only */
-			u8 obuf[3], ibuf[1+msg[i].len];
+			u8 obuf[3], ibuf[80];
+
+			if (1 + msg[i].len > sizeof(ibuf)) {
+				warn("i2c rd: len=%d is too big!\n",
+				     msg[i].len);
+				return -EREMOTEIO;
+			}
 			obuf[0] = 0;
 			obuf[1] = msg[i].len;
 			obuf[2] = msg[i].addr;
@@ -172,7 +185,18 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		} else if (i+1 < num && (msg[i+1].flags & I2C_M_RD) &&
 			   msg[i].addr == msg[i+1].addr) {
 			/* write to then read from same address */
-			u8 obuf[3+msg[i].len], ibuf[1+msg[i+1].len];
+			u8 obuf[80], ibuf[80];
+
+			if (3 + msg[i].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[i].len);
+				return -EREMOTEIO;
+			}
+			if (1 + msg[i + 1].len > sizeof(ibuf)) {
+				warn("i2c rd: len=%d is too big!\n",
+				     msg[i + 1].len);
+				return -EREMOTEIO;
+			}
 			obuf[0] = msg[i].len;
 			obuf[1] = msg[i+1].len;
 			obuf[2] = msg[i].addr;
@@ -191,7 +215,13 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			i++;
 		} else {
 			/* write only */
-			u8 obuf[2+msg[i].len], ibuf;
+			u8 obuf[80], ibuf;
+
+			if (2 + msg[i].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[i].len);
+				return -EREMOTEIO;
+			}
 			obuf[0] = msg[i].addr;
 			obuf[1] = msg[i].len;
 			memcpy(&obuf[2], msg[i].buf, msg[i].len);
-- 
1.8.3.1

