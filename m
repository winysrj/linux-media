Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:42921 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3CJLYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 07:24:47 -0400
Received: by mail-ee0-f53.google.com with SMTP id e53so1705897eek.12
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 04:24:46 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx-i2c: relax error check in em28xx_i2c_recv_bytes()
Date: Sun, 10 Mar 2013 12:25:25 +0100
Message-Id: <1362914725-5172-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It turned out that some devices return less bytes then requested via i2c when
ALL of the following 3 conditions are met:
- i2c bus B is used
- there was no attempt to write to the specified slave address before
- no device present at the specified slave address

With the current code, this triggers an -EIO error and prints a message to the
system log.
Because it can happen very often during device probing, it is better to ignore
this error and bail out silently after the follwing i2c transaction success
check with -ENODEV.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   22 +++++++++++-----------
 1 Datei geändert, 11 Zeilen hinzugefügt(+), 11 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 6152423..94521bf 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -227,18 +227,18 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 
 	/* Read data from i2c device */
 	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
-	if (ret != len) {
-		if (ret < 0) {
-			em28xx_warn("reading from i2c device at 0x%x failed "
-				    "(error=%i)\n", addr, ret);
-			return ret;
-		} else {
-			em28xx_warn("%i bytes requested from i2c device at "
-				    "0x%x, but %i bytes received\n",
-				    len, addr, ret);
-			return -EIO;
-		}
+	if (ret < 0) {
+		em28xx_warn("reading from i2c device at 0x%x failed "
+			    "(error=%i)\n", addr, ret);
+		return ret;
 	}
+	/* NOTE: some devices with two i2c busses have the bad habit to return 0
+	 * bytes if we are on bus B AND there was no write attempt to the
+	 * specified slave address before AND no device is present at the
+	 * requested slave address.
+	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
+	 * spamming the system log on device probing and do nothing here.
+	 */
 
 	/* Check success of the i2c operation */
 	ret = dev->em28xx_read_reg(dev, 0x05);
-- 
1.7.10.4

