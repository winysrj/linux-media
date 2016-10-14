Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59042 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756294AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Takashi Iwai <tiwai@suse.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geliang Tang <geliangtang@163.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 08/57] [media] bt8xx: don't break long lines
Date: Fri, 14 Oct 2016 17:19:56 -0300
Message-Id: <eb1d210b4f04e9a675790dfc69f26f78c3ea8a79.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/bt8xx/bttv-cards.c  | 9 +++------
 drivers/media/pci/bt8xx/bttv-driver.c | 6 ++----
 drivers/media/pci/bt8xx/bttv-i2c.c    | 6 ++----
 drivers/media/pci/bt8xx/bttv-input.c  | 3 +--
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 8a17cc0bfa07..4ad50f978e0e 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -125,10 +125,8 @@ module_param_array(remote,   int, NULL, 0444);
 module_param_array(audiodev, int, NULL, 0444);
 module_param_array(audiomux, int, NULL, 0444);
 
-MODULE_PARM_DESC(triton1,"set ETBF pci config bit "
-		 "[enable bug compatibility for triton1 + others]");
-MODULE_PARM_DESC(vsfx,"set VSFX pci config bit "
-		 "[yet another chipset flaw workaround]");
+MODULE_PARM_DESC(triton1,"set ETBF pci config bit [enable bug compatibility for triton1 + others]");
+MODULE_PARM_DESC(vsfx,"set VSFX pci config bit [yet another chipset flaw workaround]");
 MODULE_PARM_DESC(latency,"pci latency timer");
 MODULE_PARM_DESC(card,"specify TV/grabber card model, see CARDLIST file for a list");
 MODULE_PARM_DESC(pll, "specify installed crystal (0=none, 28=28 MHz, 35=35 MHz, 14=14 MHz)");
@@ -141,8 +139,7 @@ MODULE_PARM_DESC(audiodev, "specify audio device:\n"
 		"\t\t 2 = tda7432\n"
 		"\t\t 3 = tvaudio");
 MODULE_PARM_DESC(saa6588, "if 1, then load the saa6588 RDS module, default (0) is to use the card definition.");
-MODULE_PARM_DESC(no_overlay,"allow override overlay default (0 disables, 1 enables)"
-		" [some VIA/SIS chipsets are known to have problem with overlay]");
+MODULE_PARM_DESC(no_overlay,"allow override overlay default (0 disables, 1 enables) [some VIA/SIS chipsets are known to have problem with overlay]");
 
 /* ----------------------------------------------------------------------- */
 /* list of card IDs for bt878+ cards                                       */
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 97b91a9f9fa9..fb4aefbcc8f8 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -148,8 +148,7 @@ MODULE_PARM_DESC(irq_debug, "irq handler debug messages, default is 0 (no)");
 MODULE_PARM_DESC(disable_ir, "disable infrared remote support");
 MODULE_PARM_DESC(gbuffers, "number of capture buffers. range 2-32, default 8");
 MODULE_PARM_DESC(gbufsize, "size of the capture buffers, default is 0x208000");
-MODULE_PARM_DESC(reset_crop, "reset cropping parameters at open(), default "
-		 "is 1 (yes) for compatibility with older applications");
+MODULE_PARM_DESC(reset_crop, "reset cropping parameters at open(), default is 1 (yes) for compatibility with older applications");
 MODULE_PARM_DESC(automute, "mute audio on bad/missing video signal, default is 1 (yes)");
 MODULE_PARM_DESC(chroma_agc, "enables the AGC of chroma signal, default is 0 (no)");
 MODULE_PARM_DESC(agc_crush, "enables the luminance AGC crush, default is 1 (yes)");
@@ -3506,8 +3505,7 @@ static void bttv_irq_debug_low_latency(struct bttv *btv, u32 rc)
 		(unsigned long)rc);
 
 	if (0 == (btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC)) {
-		pr_notice("%d: Oh, there (temporarily?) is no input signal. "
-			  "Ok, then this is harmless, don't worry ;)\n",
+		pr_notice("%d: Oh, there (temporarily?) is no input signal. Ok, then this is harmless, don't worry ;)\n",
 			  btv->c.nr);
 		return;
 	}
diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index d43911deb617..830437471038 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -44,15 +44,13 @@ static int i2c_scan;
 module_param(i2c_debug, int, 0644);
 MODULE_PARM_DESC(i2c_debug, "configure i2c debug level");
 module_param(i2c_hw,    int, 0444);
-MODULE_PARM_DESC(i2c_hw,"force use of hardware i2c support, "
-			"instead of software bitbang");
+MODULE_PARM_DESC(i2c_hw,"force use of hardware i2c support, instead of software bitbang");
 module_param(i2c_scan,  int, 0444);
 MODULE_PARM_DESC(i2c_scan,"scan i2c bus at insmod time");
 
 static unsigned int i2c_udelay = 5;
 module_param(i2c_udelay, int, 0444);
-MODULE_PARM_DESC(i2c_udelay,"soft i2c delay at insmod time, in usecs "
-		"(should be 5 or higher). Lower value means higher bus speed.");
+MODULE_PARM_DESC(i2c_udelay,"soft i2c delay at insmod time, in usecs (should be 5 or higher). Lower value means higher bus speed.");
 
 /* ----------------------------------------------------------------------- */
 /* I2C functions - bitbanging adapter (software i2c)                       */
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index a75c53da224a..de2270e1ccc3 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -185,8 +185,7 @@ static u32 bttv_rc5_decode(unsigned int code)
 			return 0;
 		}
 	}
-	dprintk("code=%x, rc5=%x, start=%x, toggle=%x, address=%x, "
-		"instr=%x\n", rc5, org_code, RC5_START(rc5),
+	dprintk("code=%x, rc5=%x, start=%x, toggle=%x, address=%x, instr=%x\n", rc5, org_code, RC5_START(rc5),
 		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
 	return rc5;
 }
-- 
2.7.4


