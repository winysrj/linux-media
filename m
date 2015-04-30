Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbbD3OIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:52 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 09/22] saa7134: fix a few other occurrences of KERN_INFO/KERN_WARNING
Date: Thu, 30 Apr 2015 11:08:29 -0300
Message-Id: <7d98fb44c7da38ae812b290d43a702caa6f3b157.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On a few places, the search expression used on the script that
replaced pr_info/pr_warn didn't match, because the string were
on the next line.

It is best to manually edit those lines, and re-indent the
paragraphs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 3159e15a57d4..5b81157a5003 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7906,9 +7906,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 	/* The card below is detected as card=53, but is different */
 	       if (dev->autodetected && (dev->eedata[0x27] == 0x03)) {
 			dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
-			printk(KERN_INFO
-			       "%s: P7131 analog only, using entry of %s\n",
-			dev->name, saa7134_boards[dev->board].name);
+			pr_info("%s: P7131 analog only, using entry of %s\n",
+				dev->name, saa7134_boards[dev->board].name);
 
 			/*
 			 * IR init has already happened for other cards, so
@@ -8047,9 +8046,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 			msg.buf = &buffer[i][0];
 			msg.len = ARRAY_SIZE(buffer[0]);
 			if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1)
-				printk(KERN_WARNING
-				       "%s: Unable to enable tuner(%i).\n",
-				       dev->name, i);
+				pr_warn("%s: Unable to enable tuner(%i).\n",
+				        dev->name, i);
 		}
 		break;
 	}
@@ -8065,9 +8063,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		/* watch TV without software reboot. For solve this problem */
 		/* switch the tuner to analog TV mode manually.             */
 		if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1)
-				printk(KERN_WARNING
-				      "%s: Unable to enable IF of the tuner.\n",
-				       dev->name);
+			pr_warn("%s: Unable to enable IF of the tuner.\n",
+				dev->name);
 		break;
 	}
 	case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 9ffdcdcfd2b0..c206148f816b 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -772,22 +772,20 @@ static void must_configure_manually(int has_eeprom)
 	unsigned int i,p;
 
 	if (!has_eeprom)
-		printk(KERN_WARNING
-		       "saa7134: <rant>\n"
-		       "saa7134:  Congratulations!  Your TV card vendor saved a few\n"
-		       "saa7134:  cents for a eeprom, thus your pci board has no\n"
-		       "saa7134:  subsystem ID and I can't identify it automatically\n"
-		       "saa7134: </rant>\n"
-		       "saa7134: I feel better now.  Ok, here are the good news:\n"
-		       "saa7134: You can use the card=<nr> insmod option to specify\n"
-		       "saa7134: which board do you have.  The list:\n");
+		pr_warn("saa7134: <rant>\n"
+			"saa7134:  Congratulations!  Your TV card vendor saved a few\n"
+			"saa7134:  cents for a eeprom, thus your pci board has no\n"
+			"saa7134:  subsystem ID and I can't identify it automatically\n"
+			"saa7134: </rant>\n"
+			"saa7134: I feel better now.  Ok, here are the good news:\n"
+			"saa7134: You can use the card=<nr> insmod option to specify\n"
+			"saa7134: which board do you have.  The list:\n");
 	else
-		printk(KERN_WARNING
-		       "saa7134: Board is currently unknown. You might try to use the card=<nr>\n"
-		       "saa7134: insmod option to specify which board do you have, but this is\n"
-		       "saa7134: somewhat risky, as might damage your card. It is better to ask\n"
-		       "saa7134: for support at linux-media@vger.kernel.org.\n"
-		       "saa7134: The supported cards are:\n");
+		pr_warn("saa7134: Board is currently unknown. You might try to use the card=<nr>\n"
+			"saa7134: insmod option to specify which board do you have, but this is\n"
+			"saa7134: somewhat risky, as might damage your card. It is better to ask\n"
+			"saa7134: for support at linux-media@vger.kernel.org.\n"
+			"saa7134: The supported cards are:\n");
 
 	for (i = 0; i < saa7134_bcount; i++) {
 		pr_warn("saa7134:   card=%d -> %-40.40s",
-- 
2.1.0

