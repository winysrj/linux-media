Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbbD3OIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 21/22] saa7134-i2c: simplify debug dump and use pr_info()
Date: Thu, 30 Apr 2015 11:08:41 -0300
Message-Id: <8d5ae1f75b73956520a8e497c3ff02c10ed59cfa.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of implement its own hexdump logic, use the printk
format, and convert to use pr_info().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index b140143dba7d..ef3c33e3757d 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -369,13 +369,12 @@ saa7134_i2c_eeprom(struct saa7134_dev *dev, unsigned char *eedata, int len)
 		       dev->name,err);
 		return -1;
 	}
-	for (i = 0; i < len; i++) {
-		if (0 == (i % 16))
-			pr_info("%s: i2c eeprom %02x:",dev->name,i);
-		printk(" %02x",eedata[i]);
-		if (15 == (i % 16))
-			printk("\n");
+
+	for (i = 0; i < len; i+= 16) {
+		int size = (len - i) > 16 ? 16 : len - i;
+		pr_info("i2c eeprom %02x: %*ph\n", i, size, &eedata[i]);
 	}
+
 	return 0;
 }
 
-- 
2.1.0

