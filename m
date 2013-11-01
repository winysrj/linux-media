Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3KAWld (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 18:41:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/11] cx18: struct i2c_client is too big for stack
Date: Fri,  1 Nov 2013 17:39:23 -0200
Message-Id: <1383334770-27130-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
References: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

/devel/v4l/ktest-build/drivers/media/pci/cx18/cx18-driver.c: In function 'cx18_read_eeprom':
/devel/v4l/ktest-build/drivers/media/pci/cx18/cx18-driver.c:357:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Dynamically allocate/deallocate it when eeprom read is needed

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/cx18/cx18-driver.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index ff7232023f56..87f5bcf29e90 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -324,23 +324,24 @@ static void cx18_eeprom_dump(struct cx18 *cx, unsigned char *eedata, int len)
 /* Hauppauge card? get values from tveeprom */
 void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
 {
-	struct i2c_client c;
+	struct i2c_client *c;
 	u8 eedata[256];
 
-	memset(&c, 0, sizeof(c));
-	strlcpy(c.name, "cx18 tveeprom tmp", sizeof(c.name));
-	c.adapter = &cx->i2c_adap[0];
-	c.addr = 0xA0 >> 1;
+	c = kzalloc(sizeof(*c), GFP_ATOMIC);
+
+	strlcpy(c->name, "cx18 tveeprom tmp", sizeof(c->name));
+	c->adapter = &cx->i2c_adap[0];
+	c->addr = 0xa0 >> 1;
 
 	memset(tv, 0, sizeof(*tv));
-	if (tveeprom_read(&c, eedata, sizeof(eedata)))
-		return;
+	if (tveeprom_read(c, eedata, sizeof(eedata)))
+		goto ret;
 
 	switch (cx->card->type) {
 	case CX18_CARD_HVR_1600_ESMT:
 	case CX18_CARD_HVR_1600_SAMSUNG:
 	case CX18_CARD_HVR_1600_S5H1411:
-		tveeprom_hauppauge_analog(&c, tv, eedata);
+		tveeprom_hauppauge_analog(c, tv, eedata);
 		break;
 	case CX18_CARD_YUAN_MPC718:
 	case CX18_CARD_GOTVIEW_PCI_DVD3:
@@ -354,6 +355,9 @@ void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
 		cx18_eeprom_dump(cx, eedata, sizeof(eedata));
 		break;
 	}
+
+ret:
+	kfree(c);
 }
 
 static void cx18_process_eeprom(struct cx18 *cx)
-- 
1.8.3.1

