Return-path: <mchehab@gaivota>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:51786 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754253Ab0KFKE6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Nov 2010 06:04:58 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, root <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: add revision check
Date: Sat,  6 Nov 2010 11:04:53 +0100
Message-Id: <1289037893-6907-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: root <stefan.ringel@arcor.de>

adding chip revision check

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    7 -------
 drivers/staging/tm6000/tm6000-core.c  |   26 +++++++++++++++++++-------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 664e603..1c9374a 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -521,13 +521,6 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 				printk(KERN_ERR "Error %i doing tuner reset\n", rc);
 				return rc;
 			}
-			msleep(10);
-
-			if (!i) {
-				rc = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
-				if (rc >= 0)
-					printk(KERN_DEBUG "board=0x%08x\n", rc);
-			}
 		}
 	} else {
 		printk(KERN_ERR "Tuner reset is not configured\n");
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index df3f187..efefa6a 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -542,6 +542,25 @@ int tm6000_init(struct tm6000_core *dev)
 	int board, rc = 0, i, size;
 	struct reg_init *tab;
 
+	/* Check board revision */
+	board = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
+	if (board >= 0) {
+		switch (board & 0xff)
+		case 0xf3:
+			printk(KERN_INFO "Found tm6000\n");
+			if (dev->dev_type != TM6000)
+				dev->dev_type = TM6000;
+			break;
+		case 0xf4:
+			printk(KERN_INFO "Found tm6010\n");
+			if (dev->dev_type != TM6010)
+				dev->dev_type = TM6010;
+			break;
+		default:
+			printk(KERN_INFO "Unknown board version = 0x%08x\n", board);
+	} else
+		printk(KERN_ERR "Error %i while retrieving board version\n", board);
+
 	if (dev->dev_type == TM6010) {
 		tab = tm6010_init_tab;
 		size = ARRAY_SIZE(tm6010_init_tab);
@@ -563,13 +582,6 @@ int tm6000_init(struct tm6000_core *dev)
 
 	msleep(5); /* Just to be conservative */
 
-	/* Check board version - maybe 10Moons specific */
-	board = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
-	if (board >= 0)
-		printk(KERN_INFO "Board version = 0x%08x\n", board);
-	else
-		printk(KERN_ERR "Error %i while retrieving board version\n", board);
-
 	rc = tm6000_cards_setup(dev);
 
 	return rc;
-- 
1.7.1

