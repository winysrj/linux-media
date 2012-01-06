Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64978 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962Ab2AFS0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 13:26:46 -0500
Received: by yenm11 with SMTP id m11so791810yen.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:26:46 -0800 (PST)
Date: Fri, 6 Jan 2012 12:26:41 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Hunold <michael@mihu.de>,
	Johannes Stezenbach <js@sig21.net>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/2] [media] dvb-bt8xx: convert printks to pr_err()
Message-ID: <20120106182641.GG15740@elie.hsd1.il.comcast.net>
References: <E1RjBAD-0006Ue-NL@www.linuxtv.org>
 <20120106182519.GE15740@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106182519.GE15740@elie.hsd1.il.comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This module does some printks with the loglevel missing.

pr_err() takes care of adding the KERN_ERR tag and the module name.
So we can simplify the code and add the missing printk loglevel by
using it.

Also add a #define pr_fmt() to make this work, and remove a few
unnecessary periods at the end of messages and bump the loglevel of
"Unknown bttv card type" from KERN_WARNING to KERN_ERR while at it.

Inspired-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/bt8xx/dvb-bt8xx.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 2f38cca7604b..f9087a0f0cc3 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) "dvb_bt8xx: " fmt
+
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -666,7 +668,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 		/*	DST is not a frontend driver !!!		*/
 		state = kmalloc(sizeof (struct dst_state), GFP_KERNEL);
 		if (!state) {
-			printk("dvb_bt8xx: No memory\n");
+			pr_err("No memory\n");
 			break;
 		}
 		/*	Setup the Card					*/
@@ -676,7 +678,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 		state->dst_ca = NULL;
 		/*	DST is not a frontend, attaching the ASIC	*/
 		if (dvb_attach(dst_attach, state, &card->dvb_adapter) == NULL) {
-			printk("%s: Could not find a Twinhan DST.\n", __func__);
+			pr_err("%s: Could not find a Twinhan DST\n", __func__);
 			break;
 		}
 		/*	Attach other DST peripherals if any		*/
@@ -705,14 +707,14 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 	}
 
 	if (card->fe == NULL)
-		printk("dvb-bt8xx: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
+		pr_err("A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       card->bt->dev->vendor,
 		       card->bt->dev->device,
 		       card->bt->dev->subsystem_vendor,
 		       card->bt->dev->subsystem_device);
 	else
 		if (dvb_register_frontend(&card->dvb_adapter, card->fe)) {
-			printk("dvb-bt8xx: Frontend registration failed!\n");
+			pr_err("Frontend registration failed!\n");
 			dvb_frontend_detach(card->fe);
 			card->fe = NULL;
 		}
@@ -726,7 +728,7 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 				      THIS_MODULE, &card->bt->dev->dev,
 				      adapter_nr);
 	if (result < 0) {
-		printk("dvb_bt8xx: dvb_register_adapter failed (errno = %d)\n", result);
+		pr_err("dvb_register_adapter failed (errno = %d)\n", result);
 		return result;
 	}
 	card->dvb_adapter.priv = card;
@@ -746,7 +748,7 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 
 	result = dvb_dmx_init(&card->demux);
 	if (result < 0) {
-		printk("dvb_bt8xx: dvb_dmx_init failed (errno = %d)\n", result);
+		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
 		goto err_unregister_adaptor;
 	}
 
@@ -756,7 +758,7 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 
 	result = dvb_dmxdev_init(&card->dmxdev, &card->dvb_adapter);
 	if (result < 0) {
-		printk("dvb_bt8xx: dvb_dmxdev_init failed (errno = %d)\n", result);
+		pr_err("dvb_dmxdev_init failed (errno = %d)\n", result);
 		goto err_dmx_release;
 	}
 
@@ -764,7 +766,7 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 
 	result = card->demux.dmx.add_frontend(&card->demux.dmx, &card->fe_hw);
 	if (result < 0) {
-		printk("dvb_bt8xx: dvb_dmx_init failed (errno = %d)\n", result);
+		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
 		goto err_dmxdev_release;
 	}
 
@@ -772,19 +774,19 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 
 	result = card->demux.dmx.add_frontend(&card->demux.dmx, &card->fe_mem);
 	if (result < 0) {
-		printk("dvb_bt8xx: dvb_dmx_init failed (errno = %d)\n", result);
+		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
 		goto err_remove_hw_frontend;
 	}
 
 	result = card->demux.dmx.connect_frontend(&card->demux.dmx, &card->fe_hw);
 	if (result < 0) {
-		printk("dvb_bt8xx: dvb_dmx_init failed (errno = %d)\n", result);
+		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
 		goto err_remove_mem_frontend;
 	}
 
 	result = dvb_net_init(&card->dvb_adapter, &card->dvbnet, &card->demux.dmx);
 	if (result < 0) {
-		printk("dvb_bt8xx: dvb_net_init failed (errno = %d)\n", result);
+		pr_err("dvb_net_init failed (errno = %d)\n", result);
 		goto err_disconnect_frontend;
 	}
 
@@ -887,8 +889,7 @@ static int __devinit dvb_bt8xx_probe(struct bttv_sub_device *sub)
 		break;
 
 	default:
-		printk(KERN_WARNING "dvb_bt8xx: Unknown bttv card type: %d.\n",
-				sub->core->type);
+		pr_err("Unknown bttv card type: %d\n", sub->core->type);
 		kfree(card);
 		return -ENODEV;
 	}
@@ -896,16 +897,14 @@ static int __devinit dvb_bt8xx_probe(struct bttv_sub_device *sub)
 	dprintk("dvb_bt8xx: identified card%d as %s\n", card->bttv_nr, card->card_name);
 
 	if (!(bttv_pci_dev = bttv_get_pcidev(card->bttv_nr))) {
-		printk("dvb_bt8xx: no pci device for card %d\n", card->bttv_nr);
+		pr_err("no pci device for card %d\n", card->bttv_nr);
 		kfree(card);
 		return -ENODEV;
 	}
 
 	if (!(card->bt = dvb_bt8xx_878_match(card->bttv_nr, bttv_pci_dev))) {
-		printk("dvb_bt8xx: unable to determine DMA core of card %d,\n",
-		       card->bttv_nr);
-		printk("dvb_bt8xx: if you have the ALSA bt87x audio driver "
-		       "installed, try removing it.\n");
+		pr_err("unable to determine DMA core of card %d,\n", card->bttv_nr);
+		pr_err("if you have the ALSA bt87x audio driver installed, try removing it.\n");
 
 		kfree(card);
 		return -ENODEV;
-- 
1.7.8.2

