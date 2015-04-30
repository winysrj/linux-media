Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60164 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbbD3OI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/22] saa7134-dvb: use pr_debug() for the saa7134 dvb module
Date: Thu, 30 Apr 2015 11:08:32 -0300
Message-Id: <c0229182c3ec7b8fcd2b44e2db44080761ddc759.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As this module doesn't use any debug level, it is easy to
just replace all debug printks by pr_debug().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 7e0091343c87..7edb49729489 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -76,16 +76,8 @@ static int use_frontend;
 module_param(use_frontend, int, 0644);
 MODULE_PARM_DESC(use_frontend,"for cards with multiple frontends (0: terrestrial, 1: satellite)");
 
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off module debugging (default:off).");
-
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define dprintk(fmt, arg...)	do { if (debug) \
-	printk(KERN_DEBUG "%s/dvb: " fmt, dev->name , ## arg); } while(0)
-
-
 /* ------------------------------------------------------------------
  * mt352 based DVB-T cards
  */
@@ -110,7 +102,7 @@ static int pinnacle_antenna_pwr(struct saa7134_dev *dev, int on)
 	saa_setl(SAA7134_GPIO_GPSTATUS0 >> 2,   (1 << 28));
 	udelay(10);
 	ok = saa_readl(SAA7134_GPIO_GPSTATUS0) & (1 << 27);
-	dprintk("%s %s\n", __func__, ok ? "on" : "off");
+	pr_debug("%s %s\n", __func__, ok ? "on" : "off");
 
 	if (!ok)
 		saa_clearl(SAA7134_GPIO_GPSTATUS0 >> 2,   (1 << 26));
@@ -128,9 +120,8 @@ static int mt352_pinnacle_init(struct dvb_frontend* fe)
 	static u8 gpp_ctl_cfg []   = { GPP_CTL,    0x0f };
 	static u8 scan_ctl_cfg []  = { SCAN_CTL,   0x0d };
 	static u8 irq_cfg []       = { INTERRUPT_EN_0, 0x00, 0x00, 0x00, 0x00 };
-	struct saa7134_dev *dev= fe->dvb->priv;
 
-	dprintk("%s called\n", __func__);
+	pr_debug("%s called\n", __func__);
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
 	udelay(200);
@@ -568,10 +559,10 @@ static int philips_tda827x_tuner_init(struct dvb_frontend *fe)
 
 	switch (state->config->antenna_switch) {
 	case 0: break;
-	case 1:	dprintk("setting GPIO21 to 0 (TV antenna?)\n");
+	case 1:	pr_debug("setting GPIO21 to 0 (TV antenna?)\n");
 		saa7134_set_gpio(dev, 21, 0);
 		break;
-	case 2: dprintk("setting GPIO21 to 1 (Radio antenna?)\n");
+	case 2: pr_debug("setting GPIO21 to 1 (Radio antenna?)\n");
 		saa7134_set_gpio(dev, 21, 1);
 		break;
 	}
@@ -585,10 +576,10 @@ static int philips_tda827x_tuner_sleep(struct dvb_frontend *fe)
 
 	switch (state->config->antenna_switch) {
 	case 0: break;
-	case 1: dprintk("setting GPIO21 to 1 (Radio antenna?)\n");
+	case 1: pr_debug("setting GPIO21 to 1 (Radio antenna?)\n");
 		saa7134_set_gpio(dev, 21, 1);
 		break;
-	case 2:	dprintk("setting GPIO21 to 0 (TV antenna?)\n");
+	case 2:	pr_debug("setting GPIO21 to 0 (TV antenna?)\n");
 		saa7134_set_gpio(dev, 21, 0);
 		break;
 	}
@@ -1246,7 +1237,7 @@ static int dvb_init(struct saa7134_dev *dev)
 
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_300I_DVBT_PAL:
-		dprintk("pinnacle 300i dvb setup\n");
+		pr_debug("pinnacle 300i dvb setup\n");
 		fe0->dvb.frontend = dvb_attach(mt352_attach, &pinnacle_300i,
 					       &dev->i2c_adap);
 		if (fe0->dvb.frontend) {
@@ -1255,7 +1246,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
-		dprintk("avertv 777 dvb setup\n");
+		pr_debug("avertv 777 dvb setup\n");
 		fe0->dvb.frontend = dvb_attach(mt352_attach, &avermedia_777,
 					       &dev->i2c_adap);
 		if (fe0->dvb.frontend) {
@@ -1265,7 +1256,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		}
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A16D:
-		dprintk("AverMedia A16D dvb setup\n");
+		pr_debug("AverMedia A16D dvb setup\n");
 		fe0->dvb.frontend = dvb_attach(mt352_attach,
 						&avermedia_xc3028_mt352_dev,
 						&dev->i2c_adap);
@@ -1610,7 +1601,7 @@ static int dvb_init(struct saa7134_dev *dev)
 			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
-		dprintk("AverMedia E506R dvb setup\n");
+		pr_debug("AverMedia E506R dvb setup\n");
 		saa7134_set_gpio(dev, 25, 0);
 		msleep(10);
 		saa7134_set_gpio(dev, 25, 1);
-- 
2.1.0

