Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030297AbbD1PoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:04 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 03/14] saa7134: fix indent issues
Date: Tue, 28 Apr 2015 12:43:42 -0300
Message-Id: <1e8158b3d1f9472fc0ec2776876a907575c5548c.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/pci/saa7134/saa7134-cards.c:7197 saa7134_xc2028_callback() warn: inconsistent indenting
	drivers/media/pci/saa7134/saa7134-cards.c:7846 saa7134_board_init2() warn: inconsistent indenting
	drivers/media/pci/saa7134/saa7134-cards.c:7913 saa7134_board_init2() warn: inconsistent indenting

While here, fix a few CodingStyle issues on the affected code

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 3ca078057755..d48fd5338db5 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7194,7 +7194,7 @@ static int saa7134_xc2028_callback(struct saa7134_dev *dev,
 			saa7134_set_gpio(dev, 20, 1);
 		break;
 		}
-	return 0;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -7842,7 +7842,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 				break;
 			case 0x001d:
 				dev->tuner_type = TUNER_PHILIPS_FMD1216ME_MK3;
-					printk(KERN_INFO "%s Board has DVB-T\n", dev->name);
+				printk(KERN_INFO "%s Board has DVB-T\n",
+				       dev->name);
 				break;
 			default:
 				printk(KERN_ERR "%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
@@ -7903,13 +7904,15 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 	case SAA7134_BOARD_ASUSTeK_TVFM7135:
 	/* The card below is detected as card=53, but is different */
 	       if (dev->autodetected && (dev->eedata[0x27] == 0x03)) {
-		       dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
-		       printk(KERN_INFO "%s: P7131 analog only, using "
-						       "entry of %s\n",
-		       dev->name, saa7134_boards[dev->board].name);
+			dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
+			printk(KERN_INFO
+			       "%s: P7131 analog only, using entry of %s\n",
+			dev->name, saa7134_boards[dev->board].name);
 
-			/* IR init has already happened for other cards, so
-			 * we have to catch up. */
+			/*
+			 * IR init has already happened for other cards, so
+			 * we have to catch up.
+			 */
 			dev->has_remote = SAA7134_REMOTE_GPIO;
 			saa7134_input_init1(dev);
 	       }
-- 
2.1.0

