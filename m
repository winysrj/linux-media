Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55661 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZGSWe1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 18:34:27 -0400
To: James Guo <jinp65@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134 - ir remote for sinovideo 1300
References: <674891.7036.qm@web39105.mail.mud.yahoo.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 20 Jul 2009 00:34:25 +0200
In-Reply-To: <674891.7036.qm@web39105.mail.mud.yahoo.com> (James Guo's message of "Thu\, 16 Jul 2009 17\:58\:33 -0700 \(PDT\)")
Message-ID: <m3r5wcxpxq.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

James Guo <jinp65@yahoo.com> writes:

> Have a tv tuner believe to be sinovideo 1300, and the remote has h-338 in the
> back, the tuner is detected as saa7134 proteus 2309, and working fine, the
> patch is for the remote.

Since we don't know what exact encoding does it use... Can you test with
the attached patch? You have to add/substitute your card ID in place of
AVERMEDIA_SUPER_007 and "modprobe saa7134 gpio_tracking=1".

Press a single RC button.

It should produce a lot of messages like:
$ dmesg | grep GPIO:
saa7133[0] GPIO: time=1248041038.165525 mode=0x0000000 in=0x0040000 out=0x0000000 [pre-init]
saa7133[0] GPIO: time=1248041061.000769 mode=0x0200000 in=0x0000000 out=0x0200000 [GPIO18 IRQ]
saa7133[0] GPIO: time=1248041061.001691 mode=0x0200000 in=0x0040000 out=0x0200000 [GPIO18 IRQ]
saa7133[0] GPIO: time=1248041061.002539 mode=0x0200000 in=0x0000000 out=0x0200000 [GPIO18 IRQ]
saa7133[0] GPIO: time=1248041061.004376 mode=0x0200000 in=0x0040000 out=0x0200000 [GPIO18 IRQ]
saa7133[0] GPIO: time=1248041061.005198 mode=0x0200000 in=0x0000000 out=0x0200000 [GPIO18 IRQ]
saa7133[0] GPIO: time=1248041061.006124 mode=0x0200000 in=0x0040000 out=0x0200000 [GPIO18 IRQ]
saa7133[0] GPIO: time=1248041061.007858 mode=0x0200000 in=0x0000000 out=0x0200000 [GPIO18 IRQ]
saa7133[0] GPIO: time=1248041061.009672 mode=0x0200000 in=0x0040000 out=0x0200000 [GPIO18 IRQ]

If you send all of that to me I should be able to figure out the code used.
-- 
Krzysztof Halasa

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index fdb1944..73de219 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -6105,6 +6105,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_AVERMEDIA_307:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
+	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_M135A:
 /*      case SAA7134_BOARD_SABRENT_SBTTVFM:  */ /* not finished yet */
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 2def6fe..aeeef0e 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -101,18 +101,22 @@ int (*saa7134_dmasound_exit)(struct saa7134_dev *dev);
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg)
 {
-	unsigned long mode,status;
+	unsigned long mode, status;
+	struct timeval tv;
 
 	if (!gpio_tracking)
 		return;
 	/* rising SAA7134_GPIO_GPRESCAN reads the status */
-	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,0);
-	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,SAA7134_GPIO_GPRESCAN);
+	saa_andorb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN, 0);
+	saa_andorb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN,
+		   SAA7134_GPIO_GPRESCAN);
 	mode   = saa_readl(SAA7134_GPIO_GPMODE0   >> 2) & 0xfffffff;
 	status = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & 0xfffffff;
-	printk(KERN_DEBUG
-	       "%s: gpio: mode=0x%07lx in=0x%07lx out=0x%07lx [%s]\n",
-	       dev->name, mode, (~mode) & status, mode & status, msg);
+	do_gettimeofday(&tv);
+
+	printk(KERN_DEBUG "%s GPIO: time=%lu.%06lu mode=0x%07lx in=0x%07lx"
+	       " out=0x%07lx [%s]\n", dev->name, tv.tv_sec, tv.tv_usec,
+	       mode, (~mode) & status, mode & status, msg);
 }
 
 void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
@@ -566,24 +570,17 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 			}
 		}
 
-		if (report & SAA7134_IRQ_REPORT_GPIO18) {
-			switch (dev->has_remote) {
-				case SAA7134_REMOTE_GPIO:
-					if (!dev->remote)
-						break;
-					if ((dev->remote->mask_keydown & 0x40000) ||
-					    (dev->remote->mask_keyup & 0x40000)) {
-						saa7134_input_irq(dev);
-					}
-					break;
-
-				case SAA7134_REMOTE_I2C:
-					break;			/* FIXME: invoke I2C get_key() */
-
-				default:			/* GPIO18 not used by IR remote */
-					break;
-			}
+		if (report & SAA7134_IRQ_REPORT_GPIO18 &&
+		    dev->has_remote == SAA7134_REMOTE_GPIO && dev->remote &&
+		    (dev->remote->mask_keydown |
+		     dev->remote->mask_keyup) & 0x40000) {
+			if (gpio_tracking)
+				saa7134_track_gpio(dev, "GPIO18 IRQ");
+			saa7134_input_irq(dev);
 		}
+
+		/* SAA7134_REMOTE_I2C: FIXME: invoke I2C get_key() */
+		/* GPIO18 not used by IR remote */
 	}
 
 	if (10 == loop) {
@@ -695,9 +692,9 @@ static int saa7134_hw_enable2(struct saa7134_dev *dev)
 	if (dev->has_remote == SAA7134_REMOTE_GPIO && dev->remote) {
 		if (dev->remote->mask_keydown & 0x10000)
 			irq2_mask |= SAA7134_IRQ2_INTE_GPIO16;
-		else if (dev->remote->mask_keydown & 0x40000)
+		if (dev->remote->mask_keydown & 0x40000) /* raising edge */
 			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18;
-		else if (dev->remote->mask_keyup & 0x40000)
+		if (dev->remote->mask_keyup & 0x40000) /* falling edge */
 			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18A;
 	}
 
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 8a106d3..9d5a433 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -483,6 +483,12 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPMODE1, 0x1);
 		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
+		ir_codes     = ir_codes_avermedia;
+		mask_keyup   = 0x40000; /* show falling edge of GPIO18 */
+		mask_keydown = 0x40000; /* show raising edge of GPIO18 */
+		rc5_gpio     = 1;
+		break;
 	case SAA7134_BOARD_KWORLD_TERMINATOR:
 		ir_codes     = ir_codes_pixelview;
 		mask_keycode = 0x00001f;
