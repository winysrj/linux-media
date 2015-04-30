Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60230 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbbD3OI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Takashi Iwai <tiwai@suse.de>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Mikhail Domrachev <mihail.domrychev@comexp.ru>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH 08/22] saa7134: instead of usinr printk KERN_foo, use pr_foo
Date: Thu, 30 Apr 2015 11:08:28 -0300
Message-Id: <ca4ebb4982b7a1af5406c3e47a83702fdc69edfb.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replaces all occurrences of printk with KERN_INFO, KERN_WARNING
and KERN_ERR to pr_info/pr_warning, pr_err, using this small
shell script:

for i in drivers/media/pci/saa7134/*.[ch]; do sed s,'printk(KERN_INFO ','pr_info(',g <$i >a && mv a $i; done
for i in drivers/media/pci/saa7134/*.[ch]; do sed s,'printk(KERN_ERR ','pr_err(',g <$i >a && mv a $i; done
for i in drivers/media/pci/saa7134/*.[ch]; do sed s,'printk(KERN_WARNING ','pr_warn(',g <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index d5b0610a91fb..f8764a4c2f15 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -821,7 +821,7 @@ static int snd_card_saa7134_capture_open(struct snd_pcm_substream * substream)
 	int amux, err;
 
 	if (!saa7134) {
-		printk(KERN_ERR "BUG: saa7134 can't find device struct."
+		pr_err("BUG: saa7134 can't find device struct."
 				" Can't proceed with open\n");
 		return -ENODEV;
 	}
@@ -1175,7 +1175,7 @@ static int alsa_card_saa7134_create(struct saa7134_dev *dev, int devnum)
 				(void*) &dev->dmasound);
 
 	if (err < 0) {
-		printk(KERN_ERR "%s: can't get IRQ %d for ALSA\n",
+		pr_err("%s: can't get IRQ %d for ALSA\n",
 			dev->name, dev->pci->irq);
 		goto __nodev;
 	}
@@ -1196,7 +1196,7 @@ static int alsa_card_saa7134_create(struct saa7134_dev *dev, int devnum)
 	sprintf(card->longname, "%s at 0x%lx irq %d",
 		chip->dev->name, chip->iobase, chip->irq);
 
-	printk(KERN_INFO "%s/alsa: %s registered as card %d\n",dev->name,card->longname,index[devnum]);
+	pr_info("%s/alsa: %s registered as card %d\n",dev->name,card->longname,index[devnum]);
 
 	if ((err = snd_card_register(card)) == 0) {
 		snd_saa7134_cards[devnum] = card;
@@ -1240,19 +1240,19 @@ static int saa7134_alsa_init(void)
 	saa7134_dmasound_init = alsa_device_init;
 	saa7134_dmasound_exit = alsa_device_exit;
 
-	printk(KERN_INFO "saa7134 ALSA driver for DMA sound loaded\n");
+	pr_info("saa7134 ALSA driver for DMA sound loaded\n");
 
 	list_for_each(list,&saa7134_devlist) {
 		dev = list_entry(list, struct saa7134_dev, devlist);
 		if (dev->pci->device == PCI_DEVICE_ID_PHILIPS_SAA7130)
-			printk(KERN_INFO "%s/alsa: %s doesn't support digital audio\n",
+			pr_info("%s/alsa: %s doesn't support digital audio\n",
 				dev->name, saa7134_boards[dev->board].name);
 		else
 			alsa_device_init(dev);
 	}
 
 	if (dev == NULL)
-		printk(KERN_INFO "saa7134 ALSA: no saa7134 cards found\n");
+		pr_info("saa7134 ALSA: no saa7134 cards found\n");
 
 	return 0;
 
@@ -1272,7 +1272,7 @@ static void saa7134_alsa_exit(void)
 
 	saa7134_dmasound_init = NULL;
 	saa7134_dmasound_exit = NULL;
-	printk(KERN_INFO "saa7134 ALSA driver for DMA sound unloaded\n");
+	pr_info("saa7134 ALSA driver for DMA sound unloaded\n");
 
 	return;
 }
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 20de0b12c818..3159e15a57d4 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7381,7 +7381,7 @@ int saa7134_tuner_callback(void *priv, int component, int command, int arg)
 			return saa7134_xc5000_callback(dev, command, arg);
 		}
 	} else {
-		printk(KERN_ERR "saa7134: Error - device struct undefined.\n");
+		pr_err("saa7134: Error - device struct undefined.\n");
 		return -EINVAL;
 	}
 	return -EINVAL;
@@ -7412,12 +7412,12 @@ static void hauppauge_eeprom(struct saa7134_dev *dev, u8 *eeprom_data)
 	case 67659: /* WinTV-HVR1110 (OEM, no IR, hybrid, FM, SVid/Comp, RCA aud) */
 		break;
 	default:
-		printk(KERN_WARNING "%s: warning: "
+		pr_warn("%s: warning: "
 		       "unknown hauppauge model #%d\n", dev->name, tv.model);
 		break;
 	}
 
-	printk(KERN_INFO "%s: hauppauge eeprom: model=%d\n",
+	pr_info("%s: hauppauge eeprom: model=%d\n",
 	       dev->name, tv.model);
 }
 
@@ -7428,7 +7428,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	/* Always print gpio, often manufacturers encode tuner type and other info. */
 	saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0);
 	dev->gpio_value = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
-	printk(KERN_INFO "%s: board init: gpio is %x\n", dev->name, dev->gpio_value);
+	pr_info("%s: board init: gpio is %x\n", dev->name, dev->gpio_value);
 
 	switch (dev->board) {
 	case SAA7134_BOARD_FLYVIDEO2000:
@@ -7811,7 +7811,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		 */
 		ret = i2c_transfer(&dev->i2c_adap, msg, 2);
 		if (ret != 2) {
-			printk(KERN_ERR "EEPROM read failure\n");
+			pr_err("EEPROM read failure\n");
 		} else if ((data[0] != 0) && (data[0] != 0xff)) {
 			/* old config structure */
 			subaddr = data[0] + 2;
@@ -7826,7 +7826,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 				dev->tuner_type = TUNER_PHILIPS_FM1216ME_MK3;
 				break;
 			default:
-				printk(KERN_ERR "%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
+				pr_err("%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
 			}
 		} else if ((data[1] != 0) && (data[1] != 0xff)) {
 			/* new config structure */
@@ -7843,17 +7843,17 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 				break;
 			case 0x001d:
 				dev->tuner_type = TUNER_PHILIPS_FMD1216ME_MK3;
-				printk(KERN_INFO "%s Board has DVB-T\n",
+				pr_info("%s Board has DVB-T\n",
 				       dev->name);
 				break;
 			default:
-				printk(KERN_ERR "%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
+				pr_err("%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
 			}
 		} else {
-			printk(KERN_ERR "%s unexpected config structure\n", dev->name);
+			pr_err("%s unexpected config structure\n", dev->name);
 		}
 
-		printk(KERN_INFO "%s Tuner type is %d\n", dev->name, dev->tuner_type);
+		pr_info("%s Tuner type is %d\n", dev->name, dev->tuner_type);
 		break;
 	}
 	case SAA7134_BOARD_PHILIPS_EUROPA:
@@ -7861,7 +7861,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 			/* Reconfigure board as Snake reference design */
 			dev->board = SAA7134_BOARD_PHILIPS_SNAKE;
 			dev->tuner_type = saa7134_boards[dev->board].tuner_type;
-			printk(KERN_INFO "%s: Reconfigured board as %s\n",
+			pr_info("%s: Reconfigured board as %s\n",
 				dev->name, saa7134_boards[dev->board].name);
 			break;
 		}
@@ -7889,7 +7889,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
 		if (dev->autodetected && (dev->eedata[0x49] == 0x50)) {
 			dev->board = SAA7134_BOARD_PHILIPS_TIGER_S;
-			printk(KERN_INFO "%s: Reconfigured board as %s\n",
+			pr_info("%s: Reconfigured board as %s\n",
 				dev->name, saa7134_boards[dev->board].name);
 		}
 		if (dev->board == SAA7134_BOARD_PHILIPS_TIGER_S) {
@@ -7976,12 +7976,12 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		msg.addr = 0x0b;
 		msg.len = 1;
 		if (1 != i2c_transfer(&dev->i2c_adap, &msg, 1)) {
-			printk(KERN_WARNING "%s: send wake up byte to pic16C505"
+			pr_warn("%s: send wake up byte to pic16C505"
 					"(IR chip) failed\n", dev->name);
 		} else {
 			msg.flags = I2C_M_RD;
 			rc = i2c_transfer(&dev->i2c_adap, &msg, 1);
-			printk(KERN_INFO "%s: probe IR chip @ i2c 0x%02x: %s\n",
+			pr_info("%s: probe IR chip @ i2c 0x%02x: %s\n",
 				   dev->name, msg.addr,
 				   (1 == rc) ? "yes" : "no");
 			if (rc == 1)
@@ -8022,10 +8022,10 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 			dev->board = SAA7134_BOARD_VIDEOMATE_DVBT_200A;
 			dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
 			dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
-			printk(KERN_INFO "%s: Reconfigured board as %s\n",
+			pr_info("%s: Reconfigured board as %s\n",
 				dev->name, saa7134_boards[dev->board].name);
 		} else {
-			printk(KERN_WARNING "%s: Unexpected tuner type info: %x in eeprom\n",
+			pr_warn("%s: Unexpected tuner type info: %x in eeprom\n",
 				dev->name, dev->eedata[0x41]);
 			break;
 		}
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 76e8ba98e4aa..9ffdcdcfd2b0 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -614,24 +614,24 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 		print_irqstatus(dev,loop,report,status);
 		if (report & SAA7134_IRQ_REPORT_PE) {
 			/* disable all parity error */
-			printk(KERN_WARNING "%s/irq: looping -- "
+			pr_warn("%s/irq: looping -- "
 			       "clearing PE (parity error!) enable bit\n",dev->name);
 			saa_clearl(SAA7134_IRQ2,SAA7134_IRQ2_INTE_PE);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			/* disable gpio16 IRQ */
-			printk(KERN_WARNING "%s/irq: looping -- "
+			pr_warn("%s/irq: looping -- "
 			       "clearing GPIO16 enable bit\n",dev->name);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_P);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_N);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO18) {
 			/* disable gpio18 IRQs */
-			printk(KERN_WARNING "%s/irq: looping -- "
+			pr_warn("%s/irq: looping -- "
 			       "clearing GPIO18 enable bit\n",dev->name);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_N);
 		} else {
 			/* disable all irqs */
-			printk(KERN_WARNING "%s/irq: looping -- "
+			pr_warn("%s/irq: looping -- "
 			       "clearing all enable bits\n",dev->name);
 			saa_writel(SAA7134_IRQ1,0);
 			saa_writel(SAA7134_IRQ2,0);
@@ -790,7 +790,7 @@ static void must_configure_manually(int has_eeprom)
 		       "saa7134: The supported cards are:\n");
 
 	for (i = 0; i < saa7134_bcount; i++) {
-		printk(KERN_WARNING "saa7134:   card=%d -> %-40.40s",
+		pr_warn("saa7134:   card=%d -> %-40.40s",
 		       i,saa7134_boards[i].name);
 		for (p = 0; saa7134_pci_tbl[p].driver_data; p++) {
 			if (saa7134_pci_tbl[p].driver_data != i)
@@ -903,31 +903,31 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	/* pci quirks */
 	if (pci_pci_problems) {
 		if (pci_pci_problems & PCIPCI_TRITON)
-			printk(KERN_INFO "%s: quirk: PCIPCI_TRITON\n", dev->name);
+			pr_info("%s: quirk: PCIPCI_TRITON\n", dev->name);
 		if (pci_pci_problems & PCIPCI_NATOMA)
-			printk(KERN_INFO "%s: quirk: PCIPCI_NATOMA\n", dev->name);
+			pr_info("%s: quirk: PCIPCI_NATOMA\n", dev->name);
 		if (pci_pci_problems & PCIPCI_VIAETBF)
-			printk(KERN_INFO "%s: quirk: PCIPCI_VIAETBF\n", dev->name);
+			pr_info("%s: quirk: PCIPCI_VIAETBF\n", dev->name);
 		if (pci_pci_problems & PCIPCI_VSFX)
-			printk(KERN_INFO "%s: quirk: PCIPCI_VSFX\n",dev->name);
+			pr_info("%s: quirk: PCIPCI_VSFX\n",dev->name);
 #ifdef PCIPCI_ALIMAGIK
 		if (pci_pci_problems & PCIPCI_ALIMAGIK) {
-			printk(KERN_INFO "%s: quirk: PCIPCI_ALIMAGIK -- latency fixup\n",
+			pr_info("%s: quirk: PCIPCI_ALIMAGIK -- latency fixup\n",
 			       dev->name);
 			latency = 0x0A;
 		}
 #endif
 		if (pci_pci_problems & (PCIPCI_FAIL|PCIAGP_FAIL)) {
-			printk(KERN_INFO "%s: quirk: this driver and your "
+			pr_info("%s: quirk: this driver and your "
 					"chipset may not work together"
 					" in overlay mode.\n",dev->name);
 			if (!saa7134_no_overlay) {
-				printk(KERN_INFO "%s: quirk: overlay "
+				pr_info("%s: quirk: overlay "
 						"mode will be disabled.\n",
 						dev->name);
 				saa7134_no_overlay = 1;
 			} else {
-				printk(KERN_INFO "%s: quirk: overlay "
+				pr_info("%s: quirk: overlay "
 						"mode will be forced. Use this"
 						" option at your own risk.\n",
 						dev->name);
@@ -935,7 +935,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		}
 	}
 	if (UNSET != latency) {
-		printk(KERN_INFO "%s: setting pci latency timer to %d\n",
+		pr_info("%s: setting pci latency timer to %d\n",
 		       dev->name,latency);
 		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, latency);
 	}
@@ -943,7 +943,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	printk(KERN_INFO "%s: found at %s, rev: %d, irq: %d, "
+	pr_info("%s: found at %s, rev: %d, irq: %d, "
 	       "latency: %d, mmio: 0x%llx\n", dev->name,
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
@@ -972,7 +972,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
 	if (UNSET != tuner[dev->nr])
 		dev->tuner_type = tuner[dev->nr];
-	printk(KERN_INFO "%s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
+	pr_info("%s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
 		dev->name,pci_dev->subsystem_vendor,
 		pci_dev->subsystem_device,saa7134_boards[dev->board].name,
 		dev->board, dev->autodetected ?
@@ -983,7 +983,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 				pci_resource_len(pci_dev,0),
 				dev->name)) {
 		err = -EBUSY;
-		printk(KERN_ERR "%s: can't get MMIO memory @ 0x%llx\n",
+		pr_err("%s: can't get MMIO memory @ 0x%llx\n",
 		       dev->name,(unsigned long long)pci_resource_start(pci_dev,0));
 		goto fail1;
 	}
@@ -992,7 +992,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	dev->bmmio = (__u8 __iomem *)dev->lmmio;
 	if (NULL == dev->lmmio) {
 		err = -EIO;
-		printk(KERN_ERR "%s: can't ioremap() MMIO memory\n",
+		pr_err("%s: can't ioremap() MMIO memory\n",
 		       dev->name);
 		goto fail2;
 	}
@@ -1010,7 +1010,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	err = request_irq(pci_dev->irq, saa7134_irq,
 			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
-		printk(KERN_ERR "%s: can't get IRQ %d\n",
+		pr_err("%s: can't get IRQ %d\n",
 		       dev->name,pci_dev->irq);
 		goto fail4;
 	}
@@ -1040,7 +1040,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 				&dev->i2c_adap, "saa6588",
 				0, I2C_ADDRS(saa7134_boards[dev->board].rds_addr));
 		if (sd) {
-			printk(KERN_INFO "%s: found RDS decoder\n", dev->name);
+			pr_info("%s: found RDS decoder\n", dev->name);
 			dev->has_rds = 1;
 		}
 	}
@@ -1059,7 +1059,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 
 	/* register v4l devices */
 	if (saa7134_no_overlay > 0)
-		printk(KERN_INFO "%s: Overlay support disabled.\n", dev->name);
+		pr_info("%s: Overlay support disabled.\n", dev->name);
 
 	dev->video_dev = vdev_init(dev,&saa7134_video_template,"video");
 	dev->video_dev->ctrl_handler = &dev->ctrl_handler;
@@ -1068,11 +1068,11 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
 				    video_nr[dev->nr]);
 	if (err < 0) {
-		printk(KERN_INFO "%s: can't register video device\n",
+		pr_info("%s: can't register video device\n",
 		       dev->name);
 		goto fail5;
 	}
-	printk(KERN_INFO "%s: registered device %s [v4l2]\n",
+	pr_info("%s: registered device %s [v4l2]\n",
 	       dev->name, video_device_node_name(dev->video_dev));
 
 	dev->vbi_dev = vdev_init(dev, &saa7134_video_template, "vbi");
@@ -1084,7 +1084,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 				    vbi_nr[dev->nr]);
 	if (err < 0)
 		goto fail5;
-	printk(KERN_INFO "%s: registered device %s\n",
+	pr_info("%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vbi_dev));
 
 	if (card_has_radio(dev)) {
@@ -1095,7 +1095,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 					    radio_nr[dev->nr]);
 		if (err < 0)
 			goto fail5;
-		printk(KERN_INFO "%s: registered device %s\n",
+		pr_info("%s: registered device %s\n",
 		       dev->name, video_device_node_name(dev->radio_dev));
 	}
 
@@ -1358,7 +1358,7 @@ static struct pci_driver saa7134_pci_driver = {
 static int __init saa7134_init(void)
 {
 	INIT_LIST_HEAD(&saa7134_devlist);
-	printk(KERN_INFO "saa7130/34: v4l2 driver version %s loaded\n",
+	pr_info("saa7130/34: v4l2 driver version %s loaded\n",
 	       SAA7134_VERSION);
 	return pci_register_driver(&saa7134_pci_driver);
 }
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index e1fe006c8ff9..c7d9896a454e 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -87,7 +87,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* Print a warning */
 #define wprintk(fmt, arg...) \
-	printk(KERN_WARNING "%s/dvb: " fmt, dev->name, ## arg)
+	pr_warn("%s/dvb: " fmt, dev->name, ## arg)
 
 /* ------------------------------------------------------------------
  * mt352 based DVB-T cards
@@ -1223,10 +1223,10 @@ static int dvb_init(struct saa7134_dev *dev)
 	mutex_init(&dev->frontends.lock);
 	INIT_LIST_HEAD(&dev->frontends.felist);
 
-	printk(KERN_INFO "%s() allocating 1 frontend\n", __func__);
+	pr_info("%s() allocating 1 frontend\n", __func__);
 	fe0 = vb2_dvb_alloc_frontend(&dev->frontends, 1);
 	if (!fe0) {
-		printk(KERN_ERR "%s() failed to alloc\n", __func__);
+		pr_err("%s() failed to alloc\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -1872,14 +1872,14 @@ static int dvb_init(struct saa7134_dev *dev)
 
 		fe = dvb_attach(xc2028_attach, fe0->dvb.frontend, &cfg);
 		if (!fe) {
-			printk(KERN_ERR "%s/2: xc3028 attach failed\n",
+			pr_err("%s/2: xc3028 attach failed\n",
 			       dev->name);
 			goto detach_frontend;
 		}
 	}
 
 	if (NULL == fe0->dvb.frontend) {
-		printk(KERN_ERR "%s/dvb: frontend initialization failed\n", dev->name);
+		pr_err("%s/dvb: frontend initialization failed\n", dev->name);
 		goto detach_frontend;
 	}
 	/* define general-purpose callback pointer */
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index d421c279a01a..5d687bcb74ce 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -302,13 +302,13 @@ static int empress_init(struct saa7134_dev *dev)
 	err = video_register_device(dev->empress_dev,VFL_TYPE_GRABBER,
 				    empress_nr[dev->nr]);
 	if (err < 0) {
-		printk(KERN_INFO "%s: can't register video device\n",
+		pr_info("%s: can't register video device\n",
 		       dev->name);
 		video_device_release(dev->empress_dev);
 		dev->empress_dev = NULL;
 		return err;
 	}
-	printk(KERN_INFO "%s: registered device %s [mpeg]\n",
+	pr_info("%s: registered device %s [mpeg]\n",
 	       dev->name, video_device_node_name(dev->empress_dev));
 
 	empress_signal_update(&dev->empress_workqueue);
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index b69c47546d29..2dcc497fb166 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -360,18 +360,18 @@ saa7134_i2c_eeprom(struct saa7134_dev *dev, unsigned char *eedata, int len)
 	dev->i2c_client.addr = 0xa0 >> 1;
 	buf = 0;
 	if (1 != (err = i2c_master_send(&dev->i2c_client,&buf,1))) {
-		printk(KERN_INFO "%s: Huh, no eeprom present (err=%d)?\n",
+		pr_info("%s: Huh, no eeprom present (err=%d)?\n",
 		       dev->name,err);
 		return -1;
 	}
 	if (len != (err = i2c_master_recv(&dev->i2c_client,eedata,len))) {
-		printk(KERN_WARNING "%s: i2c eeprom read error (err=%d)\n",
+		pr_warn("%s: i2c eeprom read error (err=%d)\n",
 		       dev->name,err);
 		return -1;
 	}
 	for (i = 0; i < len; i++) {
 		if (0 == (i % 16))
-			printk(KERN_INFO "%s: i2c eeprom %02x:",dev->name,i);
+			pr_info("%s: i2c eeprom %02x:",dev->name,i);
 		printk(" %02x",eedata[i]);
 		if (15 == (i % 16))
 			printk("\n");
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index d020dff04bfe..e8aeea4cf422 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -673,7 +673,7 @@ static inline int saa_dsp_wait_bit(struct saa7134_dev *dev, int bit)
 
 	state = saa_readb(SAA7135_DSP_RWSTATE);
 	if (unlikely(state & SAA7135_DSP_RWSTATE_ERR)) {
-		printk(KERN_WARNING "%s: dsp access error\n", dev->name);
+		pr_warn("%s: dsp access error\n", dev->name);
 		saa_dsp_reset_error_bit(dev);
 		return -EIO;
 	}
@@ -1031,7 +1031,7 @@ int saa7134_tvaudio_init2(struct saa7134_dev *dev)
 		/* start tvaudio thread */
 		dev->thread.thread = kthread_run(my_thread, dev, "%s", dev->name);
 		if (IS_ERR(dev->thread.thread)) {
-			printk(KERN_WARNING "%s: kernel_thread() failed\n",
+			pr_warn("%s: kernel_thread() failed\n",
 			       dev->name);
 			/* XXX: missing error handling here */
 		}
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 5cef84a84863..f7dcdccfc307 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1229,7 +1229,7 @@ static int saa7134_g_fmt_vid_overlay(struct file *file, void *priv,
 	int i;
 
 	if (saa7134_no_overlay > 0) {
-		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
+		pr_err("V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
 	f->fmt.win = dev->win;
@@ -1305,7 +1305,7 @@ static int saa7134_try_fmt_vid_overlay(struct file *file, void *priv,
 	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (saa7134_no_overlay > 0) {
-		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
+		pr_err("V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
 
@@ -1339,7 +1339,7 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 	unsigned long flags;
 
 	if (saa7134_no_overlay > 0) {
-		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
+		pr_err("V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
 	if (f->fmt.win.clips == NULL)
@@ -1738,7 +1738,7 @@ static int saa7134_enum_fmt_vid_overlay(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
 	if (saa7134_no_overlay > 0) {
-		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
+		pr_err("V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
 
-- 
2.1.0

