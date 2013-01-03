Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:50659 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3ACS1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 13:27:11 -0500
Received: by mail-we0-f172.google.com with SMTP id r3so7488383wey.17
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 10:27:10 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, saschasommer@freenet.de,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v3 5/5] em28xx: consider the message length limitation of the i2c adapter when reading the eeprom
Date: Thu,  3 Jan 2013 19:27:06 +0100
Message-Id: <1357237626-3358-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1357237626-3358-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1357237626-3358-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

EEPROMs are currently read in blocks of 16 bytes, but the em2800 is limited
to 4 bytes per read. All other chip variants support reading of max. 64 bytes
at once (according to the em258x datasheet; also verified with em2710, em2882,
and em28174).

Since em2800_i2c_recv_bytes() has been fixed to return with -EOPNOTSUPP when
more than 4 bytes are requested, EEPROM reading with this chip is broken.
It was actually broken before that change, too, it just didn't throw an error
because the i2c adapter silently returned trash data (for all reads >1 byte !).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   12 +++++++++---
 1 Datei geändert, 9 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 3ff682e..8dc9267 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -379,7 +379,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 {
 	unsigned char buf, *p = eedata;
 	struct em28xx_eeprom *em_eeprom = (void *)eedata;
-	int i, err, size = len, block;
+	int i, err, size = len, block, block_max;
 
 	if (dev->chip_id == CHIP_ID_EM2874 ||
 	    dev->chip_id == CHIP_ID_EM28174 ||
@@ -412,9 +412,15 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 		       dev->name, err);
 		return err;
 	}
+
+	if (dev->board.is_em2800)
+		block_max = 4;
+	else
+		block_max = 64;
+
 	while (size > 0) {
-		if (size > 16)
-			block = 16;
+		if (size > block_max)
+			block = block_max;
 		else
 			block = size;
 
-- 
1.7.10.4

