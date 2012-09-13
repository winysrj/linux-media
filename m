Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33119 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab2IMRMa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 13:12:30 -0400
Received: by yenl14 with SMTP id l14so735998yen.19
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2012 10:12:30 -0700 (PDT)
From: Guilherme Herrmann Destefani <linuxtv@destefani.eng.br>
To: linux-media@vger.kernel.org
Cc: Guilherme Herrmann Destefani <linuxtv@destefani.eng.br>
Subject: [PATCH] bt8xx: Add video4linux control V4L2_CID_COLOR_KILLER.
Date: Thu, 13 Sep 2012 14:12:11 -0300
Message-Id: <1347556331-7522-1-git-send-email-linuxtv@destefani.eng.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added V4L2_CID_COLOR_KILLER control to the bt8xx driver.
The control V4L2_CID_PRIVATE_CHROMA_AGC was changed too because
with this change the bttv driver must touch two bits in the
SC Loop Control Registers, for controls V4L2_CID_COLOR_KILLER
and V4L2_CID_PRIVATE_CHROMA_AGC.
---
 Documentation/video4linux/bttv/Insmod-options |  1 +
 drivers/media/video/bt8xx/bttv-driver.c       | 36 ++++++++++++++++++++++++---
 drivers/media/video/bt8xx/bttvp.h             |  1 +
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/Documentation/video4linux/bttv/Insmod-options b/Documentation/video4linux/bttv/Insmod-options
index 14c065fa..089e961 100644
--- a/Documentation/video4linux/bttv/Insmod-options
+++ b/Documentation/video4linux/bttv/Insmod-options
@@ -53,6 +53,7 @@ bttv.o
 				quality which leading to unwanted sound
 				dropouts.
 		chroma_agc=0/1	AGC of chroma signal, off by default.
+		color_killer=0/1  Low color detection and removal, off by default
 		adc_crush=0/1	Luminance ADC crush, on by default.
 		i2c_udelay=     Allow reduce I2C speed. Default is 5 usecs
 				(meaning 66,67 Kbps). The default is the
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index e581b37..7208d5a 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -93,6 +93,7 @@ static unsigned int combfilter;
 static unsigned int lumafilter;
 static unsigned int automute    = 1;
 static unsigned int chroma_agc;
+static unsigned int color_killer;
 static unsigned int adc_crush   = 1;
 static unsigned int whitecrush_upper = 0xCF;
 static unsigned int whitecrush_lower = 0x7F;
@@ -125,6 +126,7 @@ module_param(combfilter,        int, 0444);
 module_param(lumafilter,        int, 0444);
 module_param(automute,          int, 0444);
 module_param(chroma_agc,        int, 0444);
+module_param(color_killer,      int, 0444);
 module_param(adc_crush,         int, 0444);
 module_param(whitecrush_upper,  int, 0444);
 module_param(whitecrush_lower,  int, 0444);
@@ -151,6 +153,7 @@ MODULE_PARM_DESC(reset_crop,"reset cropping parameters at open(), default "
 		 "is 1 (yes) for compatibility with older applications");
 MODULE_PARM_DESC(automute,"mute audio on bad/missing video signal, default is 1 (yes)");
 MODULE_PARM_DESC(chroma_agc,"enables the AGC of chroma signal, default is 0 (no)");
+MODULE_PARM_DESC(color_killer,"enables the low color detector and removal, default is 0 (no)");
 MODULE_PARM_DESC(adc_crush,"enables the luminance ADC crush, default is 1 (yes)");
 MODULE_PARM_DESC(whitecrush_upper,"sets the white crush upper value, default is 207");
 MODULE_PARM_DESC(whitecrush_lower,"sets the white crush lower value, default is 127");
@@ -674,6 +677,12 @@ static const struct v4l2_queryctrl bttv_ctls[] = {
 		.default_value = 32768,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
 	},{
+		.id            = V4L2_CID_COLOR_KILLER,
+		.name          = "Color killer",
+		.minimum       = 0,
+		.maximum       = 1,
+		.type          = V4L2_CTRL_TYPE_BOOLEAN,
+	},{
 		.id            = V4L2_CID_HUE,
 		.name          = "Hue",
 		.minimum       = 0,
@@ -1412,6 +1421,8 @@ static void init_bt848(struct bttv *btv)
 		BT848_GPIO_DMA_CTL);
 
 	val = btv->opt_chroma_agc ? BT848_SCLOOP_CAGC : 0;
+	if (btv->opt_color_killer)
+		val |= BT848_SCLOOP_CKILL;
 	btwrite(val, BT848_E_SCLOOP);
 	btwrite(val, BT848_O_SCLOOP);
 
@@ -1475,6 +1486,9 @@ static int bttv_g_ctrl(struct file *file, void *priv,
 	case V4L2_CID_SATURATION:
 		c->value = btv->saturation;
 		break;
+	case V4L2_CID_COLOR_KILLER:
+		c->value = btv->opt_color_killer;
+		break;
 
 	case V4L2_CID_AUDIO_MUTE:
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1527,7 +1541,6 @@ static int bttv_s_ctrl(struct file *file, void *f,
 					struct v4l2_control *c)
 {
 	int err;
-	int val;
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
@@ -1548,6 +1561,16 @@ static int bttv_s_ctrl(struct file *file, void *f,
 	case V4L2_CID_SATURATION:
 		bt848_sat(btv, c->value);
 		break;
+	case V4L2_CID_COLOR_KILLER:
+		btv->opt_color_killer = c->value;
+		if (btv->opt_color_killer) {
+			btor(BT848_SCLOOP_CKILL, BT848_E_SCLOOP);
+			btor(BT848_SCLOOP_CKILL, BT848_O_SCLOOP);
+		} else {
+			btand(~BT848_SCLOOP_CKILL, BT848_E_SCLOOP);
+			btand(~BT848_SCLOOP_CKILL, BT848_O_SCLOOP);
+		}
+		break;
 	case V4L2_CID_AUDIO_MUTE:
 		audio_mute(btv, c->value);
 		/* fall through */
@@ -1565,9 +1588,13 @@ static int bttv_s_ctrl(struct file *file, void *f,
 
 	case V4L2_CID_PRIVATE_CHROMA_AGC:
 		btv->opt_chroma_agc = c->value;
-		val = btv->opt_chroma_agc ? BT848_SCLOOP_CAGC : 0;
-		btwrite(val, BT848_E_SCLOOP);
-		btwrite(val, BT848_O_SCLOOP);
+		if (btv->opt_chroma_agc) {
+			btor(BT848_SCLOOP_CAGC, BT848_E_SCLOOP);
+			btor(BT848_SCLOOP_CAGC, BT848_O_SCLOOP);
+		} else {
+			btand(~BT848_SCLOOP_CAGC, BT848_E_SCLOOP);
+			btand(~BT848_SCLOOP_CAGC, BT848_O_SCLOOP);
+		}
 		break;
 	case V4L2_CID_PRIVATE_COMBFILTER:
 		btv->opt_combfilter = c->value;
@@ -4349,6 +4376,7 @@ static int __devinit bttv_probe(struct pci_dev *dev,
 	btv->opt_lumafilter = lumafilter;
 	btv->opt_automute   = automute;
 	btv->opt_chroma_agc = chroma_agc;
+	btv->opt_color_killer = color_killer;
 	btv->opt_adc_crush  = adc_crush;
 	btv->opt_vcr_hack   = vcr_hack;
 	btv->opt_whitecrush_upper  = whitecrush_upper;
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index db943a8d..3979b7c 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -429,6 +429,7 @@ struct bttv {
 	int opt_lumafilter;
 	int opt_automute;
 	int opt_chroma_agc;
+	int opt_color_killer;
 	int opt_adc_crush;
 	int opt_vcr_hack;
 	int opt_whitecrush_upper;
-- 
1.7.11.4

