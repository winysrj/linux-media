Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaG0T1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 15:27:39 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 4/6] cx231xx: handle errors at read_eeprom()
Date: Sun, 27 Jul 2014 16:27:30 -0300
Message-Id: <1406489252-30636-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
References: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warnings:
	drivers/media/usb/cx231xx/cx231xx-cards.c: In function 'read_eeprom':
	drivers/media/usb/cx231xx/cx231xx-cards.c:979:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index f1cf44af96cf..3f0e309a54d8 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -991,13 +991,20 @@ static int read_eeprom(struct cx231xx *dev, u8 *eedata, int len)
 
 	/* start reading at offset 0 */
 	ret = i2c_transfer(&dev->i2c_bus[1].i2c_adap, &msg_write, 1);
+	if (ret < 0) {
+		cx231xx_err("Can't read eeprom\n");
+		return ret;
+	}
 
 	while (len_todo > 0) {
 		msg_read.len = (len_todo > 64) ? 64 : len_todo;
 		msg_read.buf = eedata_cur;
 
 		ret = i2c_transfer(&dev->i2c_bus[1].i2c_adap, &msg_read, 1);
-
+		if (ret < 0) {
+			cx231xx_err("Can't read eeprom\n");
+			return ret;
+		}
 		eedata_cur += msg_read.len;
 		len_todo -= msg_read.len;
 	}
-- 
1.9.3

