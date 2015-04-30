Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbD3OI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:56 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 14/22] saa7134: use pr_warn() on some places where no KERN_foo were used
Date: Thu, 30 Apr 2015 11:08:34 -0300
Message-Id: <0eaea469493102d06e885e474f9cfd4b69bd290c.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On a few places, mostly during board detection, some printk()
macros were called without especifying any message level.

Those are actually warnings. So, use pr_warn() for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 5b81157a5003..abbeeb923114 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7159,10 +7159,10 @@ MODULE_DEVICE_TABLE(pci, saa7134_pci_tbl);
 
 static void board_flyvideo(struct saa7134_dev *dev)
 {
-	printk("%s: there are different flyvideo cards with different tuners\n"
-	       "%s: out there, you might have to use the tuner=<nr> insmod\n"
-	       "%s: option to override the default value.\n",
-	       dev->name, dev->name, dev->name);
+	pr_warn("%s: there are different flyvideo cards with different tuners\n"
+		"%s: out there, you might have to use the tuner=<nr> insmod\n"
+		"%s: option to override the default value.\n",
+		dev->name, dev->name, dev->name);
 }
 
 static int saa7134_xc2028_callback(struct saa7134_dev *dev,
@@ -7513,10 +7513,10 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
 	case SAA7134_BOARD_MD5044:
-		printk("%s: seems there are two different versions of the MD5044\n"
-		       "%s: (with the same ID) out there.  If sound doesn't work for\n"
-		       "%s: you try the audio_clock_override=0x200000 insmod option.\n",
-		       dev->name,dev->name,dev->name);
+		pr_warn("%s: seems there are two different versions of the MD5044\n"
+			"%s: (with the same ID) out there.  If sound doesn't work for\n"
+			"%s: you try the audio_clock_override=0x200000 insmod option.\n",
+			dev->name,dev->name,dev->name);
 		break;
 	case SAA7134_BOARD_CINERGY400_CARDBUS:
 		/* power-up tuner chip */
@@ -7641,10 +7641,10 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
-		printk("%s: %s: dual saa713x broadcast decoders\n"
-		       "%s: Sorry, none of the inputs to this chip are supported yet.\n"
-		       "%s: Dual decoder functionality is disabled for now, use the other chip.\n",
-		       dev->name,card(dev).name,dev->name,dev->name);
+		pr_warn("%s: %s: dual saa713x broadcast decoders\n"
+			"%s: Sorry, none of the inputs to this chip are supported yet.\n"
+			"%s: Dual decoder functionality is disabled for now, use the other chip.\n",
+			dev->name,card(dev).name,dev->name,dev->name);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M102:
 		/* enable tuner */
@@ -7790,7 +7790,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		if (board == dev->board)
 			break;
 		dev->board = board;
-		printk("%s: board type fixup: %s\n", dev->name,
+		pr_warn("%s: board type fixup: %s\n", dev->name,
 		saa7134_boards[dev->board].name);
 		dev->tuner_type = saa7134_boards[dev->board].tuner_type;
 
@@ -8047,7 +8047,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 			msg.len = ARRAY_SIZE(buffer[0]);
 			if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1)
 				pr_warn("%s: Unable to enable tuner(%i).\n",
-				        dev->name, i);
+					dev->name, i);
 		}
 		break;
 	}
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index c206148f816b..83dbb443214e 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -947,7 +947,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 	pci_set_master(pci_dev);
 	if (!pci_dma_supported(pci_dev, DMA_BIT_MASK(32))) {
-		printk("%s: Oops: no 32bit PCI DMA ???\n",dev->name);
+		pr_warn("%s: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail1;
 	}
-- 
2.1.0

