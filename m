Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55998 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3ACS1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 13:27:03 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so8760868wib.7
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 10:27:01 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, saschasommer@freenet.de,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v3 3/5] em28xx: fix the i2c adapter functionality flags
Date: Thu,  3 Jan 2013 19:27:04 +0100
Message-Id: <1357237626-3358-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1357237626-3358-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1357237626-3358-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C_FUNC_SMBUS_EMUL includes flag I2C_FUNC_SMBUS_WRITE_BLOCK_DATA which signals
that up to 31 data bytes can be written to the ic2 client.
But the EM2800 supports only i2c messages with max. 4 data bytes.
I2C_FUNC_IC2 should be set if a master_xfer function pointer is provided in
struct i2c_algorithm.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |    6 +++++-
 1 Datei geändert, 5 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 55308bb..1994083 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -445,7 +445,11 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
  */
 static u32 functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_SMBUS_EMUL;
+	struct em28xx *dev = adap->algo_data;
+	u32 func_flags = I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	if (dev->board.is_em2800)
+		func_flags &= ~I2C_FUNC_SMBUS_WRITE_BLOCK_DATA;
+	return func_flags;
 }
 
 static struct i2c_algorithm em28xx_algo = {
-- 
1.7.10.4

