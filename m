Return-path: <linux-media-owner@vger.kernel.org>
Received: from twinsen.zall.org ([109.74.194.249]:57566 "EHLO twinsen.zall.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbdDARjw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Apr 2017 13:39:52 -0400
Date: Sat, 1 Apr 2017 17:34:49 +0000
From: Alyssa Milburn <amilburn@zall.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/4] dw2102: limit messages to buffer size
Message-ID: <132cabdea7f471f6f2d1b3416d188eb1d5dff542.1491066251.git.amilburn@zall.org>
References: <cover.1491066251.git.amilburn@zall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <cover.1491066251.git.amilburn@zall.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise the i2c transfer functions can read or write beyond the end of
stack or heap buffers.

Signed-off-by: Alyssa Milburn <amilburn@zall.org>
---
 drivers/media/usb/dvb-usb/dw2102.c | 54 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 4f42d57f81d9..6e654e5026dd 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -204,6 +204,20 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 
 	switch (num) {
 	case 2:
+		if (msg[0].len != 1) {
+			warn("i2c rd: len=%d is not 1!\n",
+			     msg[0].len);
+			num = -EOPNOTSUPP;
+			break;
+		}
+
+		if (2 + msg[1].len > sizeof(buf6)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[1].len);
+			num = -EOPNOTSUPP;
+			break;
+		}
+
 		/* read si2109 register by number */
 		buf6[0] = msg[0].addr << 1;
 		buf6[1] = msg[0].len;
@@ -219,6 +233,13 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 	case 1:
 		switch (msg[0].addr) {
 		case 0x68:
+			if (2 + msg[0].len > sizeof(buf6)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[0].len);
+				num = -EOPNOTSUPP;
+				break;
+			}
+
 			/* write to si2109 register */
 			buf6[0] = msg[0].addr << 1;
 			buf6[1] = msg[0].len;
@@ -262,6 +283,13 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		/* first write first register number */
 		u8 ibuf[MAX_XFER_SIZE], obuf[3];
 
+		if (2 + msg[0].len != sizeof(obuf)) {
+			warn("i2c rd: len=%d is not 1!\n",
+			     msg[0].len);
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+
 		if (2 + msg[1].len > sizeof(ibuf)) {
 			warn("i2c rd: len=%d is too big!\n",
 			     msg[1].len);
@@ -462,6 +490,12 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		/* first write first register number */
 		u8 ibuf[MAX_XFER_SIZE], obuf[3];
 
+		if (2 + msg[0].len != sizeof(obuf)) {
+			warn("i2c rd: len=%d is not 1!\n",
+			     msg[0].len);
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
 		if (2 + msg[1].len > sizeof(ibuf)) {
 			warn("i2c rd: len=%d is too big!\n",
 			     msg[1].len);
@@ -696,6 +730,13 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			msg[0].buf[0] = state->data[1];
 			break;
 		default:
+			if (3 + msg[0].len > sizeof(state->data)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[0].len);
+				num = -EOPNOTSUPP;
+				break;
+			}
+
 			/* always i2c write*/
 			state->data[0] = 0x08;
 			state->data[1] = msg[0].addr;
@@ -711,6 +752,19 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		break;
 	case 2:
 		/* always i2c read */
+		if (4 + msg[0].len > sizeof(state->data)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[0].len);
+			num = -EOPNOTSUPP;
+			break;
+		}
+		if (1 + msg[1].len > sizeof(state->data)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[1].len);
+			num = -EOPNOTSUPP;
+			break;
+		}
+
 		state->data[0] = 0x09;
 		state->data[1] = msg[0].len;
 		state->data[2] = msg[1].len;
-- 
2.11.0
