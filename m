Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46225 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab2LNQ3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 11:29:01 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so1374805eaa.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 08:29:00 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/5] em28xx: respect the message size constraints for i2c transfers
Date: Fri, 14 Dec 2012 17:28:50 +0100
Message-Id: <1355502533-25636-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em2800 can transfer up to 4 bytes per i2c message.
All other em25xx/em27xx/28xx chips can transfer at least 64 bytes per message.

I2C adapters should never split messages transferred via the I2C subsystem
into multiple message transfers, because the result will almost always NOT be
the same as when the whole data is transferred to the I2C client in a single
message.
If the message size exceeds the capabilities of the I2C adapter, -EOPNOTSUPP
should be returned.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   44 ++++++++++++++-------------------
 1 Datei geändert, 18 Zeilen hinzugefügt(+), 26 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 44533e4..c508c12 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -50,14 +50,18 @@ do {							\
 } while (0)
 
 /*
- * em2800_i2c_send_max4()
- * send up to 4 bytes to the i2c device
+ * em2800_i2c_send_bytes()
+ * send up to 4 bytes to the em2800 i2c device
  */
-static int em2800_i2c_send_max4(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
+static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
 	int ret;
 	int write_timeout;
 	u8 b2[6];
+
+	if (len < 1 || len > 4)
+		return -EOPNOTSUPP;
+
 	BUG_ON(len < 1 || len > 4);
 	b2[5] = 0x80 + len - 1;
 	b2[4] = addr;
@@ -86,29 +90,6 @@ static int em2800_i2c_send_max4(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 }
 
 /*
- * em2800_i2c_send_bytes()
- */
-static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
-{
-	u8 *bufPtr = buf;
-	int ret;
-	int wrcount = 0;
-	int count;
-	int maxLen = 4;
-	while (len > 0) {
-		count = (len > maxLen) ? maxLen : len;
-		ret = em2800_i2c_send_max4(dev, addr, bufPtr, count);
-		if (ret > 0) {
-			len -= count;
-			bufPtr += count;
-			wrcount += count;
-		} else
-			return (ret < 0) ? ret : -EFAULT;
-	}
-	return wrcount;
-}
-
-/*
  * em2800_i2c_check_for_device()
  * check if there is a i2c_device at the supplied address
  */
@@ -150,6 +131,10 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
 	int ret;
+
+	if (len < 1 || len > 4)
+		return -EOPNOTSUPP;
+
 	/* check for the device and set i2c read address */
 	ret = em2800_i2c_check_for_device(dev, addr);
 	if (ret) {
@@ -176,6 +161,9 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	int wrcount = 0;
 	int write_timeout, ret;
 
+	if (len < 1 || len > 64)
+		return -EOPNOTSUPP;
+
 	wrcount = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
 
 	/* Seems to be required after a write */
@@ -197,6 +185,10 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 {
 	int ret;
+
+	if (len < 1 || len > 64)
+		return -EOPNOTSUPP;
+
 	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
 	if (ret < 0) {
 		em28xx_warn("reading i2c device failed (error=%i)\n", ret);
-- 
1.7.10.4

