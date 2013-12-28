Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3L1MQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 08/24] em28xx: add warn messages for timeout
Date: Sat, 28 Dec 2013 10:16:00 -0200
Message-Id: <1388232976-20061-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

changeset 45f04e82d035 added a logic to check if em28xx got
a timeout on an I2C transfer.

That patch started to produce a series of errors that is present
with HVR-950, like:

[ 4032.218656] xc2028 19-0061: Error on line 1299: -19

However, as there are several places where -ENODEV is produced,
there's no way to know what's happening.

So, let's add a printk to report what error condition was reached:

[ 4032.218652] em2882/3 #0: I2C transfer timeout on writing to addr 0xc2
[ 4032.218656] xc2028 19-0061: Error on line 1299: -19

Interesting enough, when connected to an USB3 port, the number of
errors increase:

[ 4249.941375] em2882/3 #0: I2C transfer timeout on writing to addr 0xb8
[ 4249.941378] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 4250.023854] em2882/3 #0: I2C transfer timeout on writing to addr 0xc2
[ 4250.023857] xc2028 19-0061: Error on line 1299: -19

Due to that, I suspect that the logic in the driver is wrong: instead
of just returning an error if 0x10 is returned, it should be waiting for
a while and read the I2C status register again.

However, more tests are needed.

For now, instead of just returning -ENODEV, output an error message
to help debug what's happening.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index c4ff9739a7ae..9e6a11d01858 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -80,6 +80,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x80 + len - 1) {
 			return len;
 		} else if (ret == 0x94 + len - 1) {
+			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
 			return -ENODEV;
 		} else if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -123,6 +124,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		if (ret == 0x84 + len - 1) {
 			break;
 		} else if (ret == 0x94 + len - 1) {
+			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
 			return -ENODEV;
 		} else if (ret < 0) {
 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
@@ -198,6 +200,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		if (ret == 0) { /* success */
 			return len;
 		} else if (ret == 0x10) {
+			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x", addr);
 			return -ENODEV;
 		} else if (ret < 0) {
 			em28xx_warn("failed to read i2c transfer status from bridge (error=%i)\n",
@@ -255,6 +258,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	}
 	if (ret > 0) {
 		if (ret == 0x10) {
+			em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
 			return -ENODEV;
 		} else {
 			em28xx_warn("unknown i2c error (status=%i)\n", ret);
@@ -316,8 +320,10 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 */
 	if (!ret)
 		return len;
-	else if (ret > 0)
+	else if (ret > 0) {
+		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
 		return -ENODEV;
+	}
 
 	return ret;
 	/*
@@ -367,8 +373,10 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	 */
 	if (!ret)
 		return len;
-	else if (ret > 0)
+	else if (ret > 0) {
+		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
 		return -ENODEV;
+	}
 
 	return ret;
 	/*
-- 
1.8.3.1

