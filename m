Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab0DFSSU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:20 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIKbJ022085
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:20 -0400
Date: Tue, 6 Apr 2010 15:18:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/26] V4L/DVB: saa7134: Fix IRQ2 bit names for the register
 map
Message-ID: <20100406151802.57f84c38@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's an error at the IRQ2 bit map registers. Also, it doesn't
show what bits are needed for positive and for negative edge.

In the case of IR raw decoding, for some protocols, it is important
to detect both positive and negative edges. So, a latter patch
will need to use the other values.

Also, the code that detects problems on IRQ handling is incomplete,
as it disables only one of the IRQ bits for GPIO16 and GPIO18.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 68cda10..0612fff 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -471,7 +471,7 @@ static char *irqbits[] = {
 	"DONE_RA0", "DONE_RA1", "DONE_RA2", "DONE_RA3",
 	"AR", "PE", "PWR_ON", "RDCAP", "INTL", "FIDT", "MMC",
 	"TRIG_ERR", "CONF_ERR", "LOAD_ERR",
-	"GPIO16?", "GPIO18", "GPIO22", "GPIO23"
+	"GPIO16", "GPIO18", "GPIO22", "GPIO23"
 };
 #define IRQBITS ARRAY_SIZE(irqbits)
 
@@ -601,12 +601,14 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 			/* disable gpio16 IRQ */
 			printk(KERN_WARNING "%s/irq: looping -- "
 			       "clearing GPIO16 enable bit\n",dev->name);
-			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16);
+			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_P);
+			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_N);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO18) {
 			/* disable gpio18 IRQs */
 			printk(KERN_WARNING "%s/irq: looping -- "
 			       "clearing GPIO18 enable bit\n",dev->name);
-			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
+			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
+			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_N);
 		} else {
 			/* disable all irqs */
 			printk(KERN_WARNING "%s/irq: looping -- "
@@ -698,11 +700,11 @@ static int saa7134_hw_enable2(struct saa7134_dev *dev)
 
 	if (dev->has_remote == SAA7134_REMOTE_GPIO && dev->remote) {
 		if (dev->remote->mask_keydown & 0x10000)
-			irq2_mask |= SAA7134_IRQ2_INTE_GPIO16;
+			irq2_mask |= SAA7134_IRQ2_INTE_GPIO16_N;
 		else if (dev->remote->mask_keydown & 0x40000)
-			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18;
+			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18_P;
 		else if (dev->remote->mask_keyup & 0x40000)
-			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18A;
+			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18_N;
 	}
 
 	if (dev->has_remote == SAA7134_REMOTE_I2C) {
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 0459ae6..fd3225c 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -1188,14 +1188,14 @@ static void nec_task(unsigned long data)
 	/* Keep repeating the last key */
 	mod_timer(&ir->timer_keyup, jiffies + msecs_to_jiffies(150));
 
-	saa_setl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
+	saa_setl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
 }
 
 static int saa7134_nec_irq(struct saa7134_dev *dev)
 {
 	struct card_ir *ir = dev->remote;
 
-	saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
+	saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
 	tasklet_schedule(&ir->tlet);
 
 	return 1;
diff --git a/drivers/media/video/saa7134/saa7134-reg.h b/drivers/media/video/saa7134/saa7134-reg.h
index cf89d96..e7e0af1 100644
--- a/drivers/media/video/saa7134/saa7134-reg.h
+++ b/drivers/media/video/saa7134/saa7134-reg.h
@@ -112,17 +112,17 @@
 #define   SAA7134_IRQ1_INTE_RA0_0               (1 <<  0)
 
 #define SAA7134_IRQ2                            (0x2c8 >> 2)
-#define   SAA7134_IRQ2_INTE_GPIO23A             (1 << 17)
-#define   SAA7134_IRQ2_INTE_GPIO23              (1 << 16)
-#define   SAA7134_IRQ2_INTE_GPIO22A             (1 << 15)
-#define   SAA7134_IRQ2_INTE_GPIO22              (1 << 14)
-#define   SAA7134_IRQ2_INTE_GPIO18A             (1 << 13)
-#define   SAA7134_IRQ2_INTE_GPIO18              (1 << 12)
-#define   SAA7134_IRQ2_INTE_GPIO16              (1 << 11) /* not certain */
-#define   SAA7134_IRQ2_INTE_SC2                 (1 << 10)
-#define   SAA7134_IRQ2_INTE_SC1                 (1 <<  9)
-#define   SAA7134_IRQ2_INTE_SC0                 (1 <<  8)
-#define   SAA7134_IRQ2_INTE_DEC5                (1 <<  7)
+#define   SAA7134_IRQ2_INTE_GPIO23_N             (1 << 17)	/* negative edge */
+#define   SAA7134_IRQ2_INTE_GPIO23_P             (1 << 16)	/* positive edge */
+#define   SAA7134_IRQ2_INTE_GPIO22_N             (1 << 15)	/* negative edge */
+#define   SAA7134_IRQ2_INTE_GPIO22_P             (1 << 14)	/* positive edge */
+#define   SAA7134_IRQ2_INTE_GPIO18_N             (1 << 13)	/* negative edge */
+#define   SAA7134_IRQ2_INTE_GPIO18_P             (1 << 12)	/* positive edge */
+#define   SAA7134_IRQ2_INTE_GPIO16_N             (1 << 11)	/* negative edge */
+#define   SAA7134_IRQ2_INTE_GPIO16_P             (1 << 10)	/* positive edge */
+#define   SAA7134_IRQ2_INTE_SC2                 (1 <<  9)
+#define   SAA7134_IRQ2_INTE_SC1                 (1 <<  8)
+#define   SAA7134_IRQ2_INTE_SC0                 (1 <<  7)
 #define   SAA7134_IRQ2_INTE_DEC4                (1 <<  6)
 #define   SAA7134_IRQ2_INTE_DEC3                (1 <<  5)
 #define   SAA7134_IRQ2_INTE_DEC2                (1 <<  4)
@@ -135,7 +135,7 @@
 #define   SAA7134_IRQ_REPORT_GPIO23             (1 << 17)
 #define   SAA7134_IRQ_REPORT_GPIO22             (1 << 16)
 #define   SAA7134_IRQ_REPORT_GPIO18             (1 << 15)
-#define   SAA7134_IRQ_REPORT_GPIO16             (1 << 14) /* not certain */
+#define   SAA7134_IRQ_REPORT_GPIO16             (1 << 14)
 #define   SAA7134_IRQ_REPORT_LOAD_ERR           (1 << 13)
 #define   SAA7134_IRQ_REPORT_CONF_ERR           (1 << 12)
 #define   SAA7134_IRQ_REPORT_TRIG_ERR           (1 << 11)
-- 
1.6.6.1


