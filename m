Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3KCPAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 10:00:12 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 04/29] cx18: struct i2c_client is too big for stack
Date: Sat,  2 Nov 2013 11:31:12 -0200
Message-Id: <1383399097-11615-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	drivers/media/pci/cx18/cx18-driver.c: In function 'cx18_read_eeprom':
	drivers/media/pci/cx18/cx18-driver.c:357:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]

That happens because the routine allocates 256 bytes for an eeprom buffer, plus
the size of struct i2c_client, with is big.

Change the logic to dynamically allocate/deallocate space for struct i2c_client,
instead of  using the stack.

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

