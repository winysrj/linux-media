Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:37459 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752261AbeBIONg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 09:13:36 -0500
Received: by mail-pl0-f67.google.com with SMTP id ay8so1520171plb.4
        for <linux-media@vger.kernel.org>; Fri, 09 Feb 2018 06:13:35 -0800 (PST)
From: Antonio Cardace <anto.cardace@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        Antonio Cardace <anto.cardace@gmail.com>
Subject: [PATCH] em28xx: use %*phC to print small buffers
Date: Fri,  9 Feb 2018 14:13:26 +0000
Message-Id: <20180209141326.12910-1-anto.cardace@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use %*phC format to print small buffers as hex strings

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Antonio Cardace <anto.cardace@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9bf49d666e5a..9ad958004990 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -710,8 +710,8 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		mc_start = (data[1] << 8) + 4;	/* usually 0x0004 */
 
 		dev_info(&dev->intf->dev,
-			 "EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
-			 data[0], data[1], data[2], data[3], dev->hash);
+			 "EEPROM ID = %4ph, EEPROM hash = 0x%08lx\n",
+			 data, dev->hash);
 		dev_info(&dev->intf->dev,
 			 "EEPROM info:\n");
 		dev_info(&dev->intf->dev,
@@ -776,8 +776,8 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		   data[2] == 0x67 && data[3] == 0x95) {
 		dev->hash = em28xx_hash_mem(data, len, 32);
 		dev_info(&dev->intf->dev,
-			 "EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
-			 data[0], data[1], data[2], data[3], dev->hash);
+			 "EEPROM ID = %4ph, EEPROM hash = 0x%08lx\n",
+			 data, dev->hash);
 		dev_info(&dev->intf->dev,
 			 "EEPROM info:\n");
 	} else {
-- 
2.15.1.354.g95ec6b1b3
