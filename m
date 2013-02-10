Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3557 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab3BJMu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 12/19] bttv: convert to the control framework.
Date: Sun, 10 Feb 2013 13:50:07 +0100
Message-Id: <d9e888a3dff387cb4e2ed0d5e07cb02645132dc4.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Note that the private chroma agc control has been replaced with the standard
CHROMA_AGC control.

Also fixes a mute/automute problem where closing the file handle would force
mute on. That's not what you want since that would make the mute state out of
sync with the mute control. Instead check against the user count.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-cards.c  |    5 +-
 drivers/media/pci/bt8xx/bttv-driver.c |  682 +++++++++++++--------------------
 drivers/media/pci/bt8xx/bttvp.h       |   16 +-
 include/uapi/linux/v4l2-controls.h    |    5 +
 4 files changed, 271 insertions(+), 437 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index c4c5917..682ed89 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -3554,8 +3554,9 @@ void bttv_init_card2(struct bttv *btv)
 			I2C_CLIENT_END
 		};
 
-		if (v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, "tda7432", 0, addrs))
+		btv->sd_tda7432 = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
+				&btv->c.i2c_adap, "tda7432", 0, addrs);
+		if (btv->sd_tda7432)
 			return;
 	}
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 21b38ee..09f58f3 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -94,7 +94,7 @@ static unsigned int combfilter;
 static unsigned int lumafilter;
 static unsigned int automute    = 1;
 static unsigned int chroma_agc;
-static unsigned int adc_crush   = 1;
+static unsigned int agc_crush   = 1;
 static unsigned int whitecrush_upper = 0xCF;
 static unsigned int whitecrush_lower = 0x7F;
 static unsigned int vcr_hack;
@@ -126,7 +126,7 @@ module_param(combfilter,        int, 0444);
 module_param(lumafilter,        int, 0444);
 module_param(automute,          int, 0444);
 module_param(chroma_agc,        int, 0444);
-module_param(adc_crush,         int, 0444);
+module_param(agc_crush,         int, 0444);
 module_param(whitecrush_upper,  int, 0444);
 module_param(whitecrush_lower,  int, 0444);
 module_param(vcr_hack,          int, 0444);
@@ -139,27 +139,27 @@ module_param_array(video_nr,    int, NULL, 0444);
 module_param_array(radio_nr,    int, NULL, 0444);
 module_param_array(vbi_nr,      int, NULL, 0444);
 
-MODULE_PARM_DESC(radio,"The TV card supports radio, default is 0 (no)");
-MODULE_PARM_DESC(bigendian,"byte order of the framebuffer, default is native endian");
-MODULE_PARM_DESC(bttv_verbose,"verbose startup messages, default is 1 (yes)");
-MODULE_PARM_DESC(bttv_gpio,"log gpio changes, default is 0 (no)");
-MODULE_PARM_DESC(bttv_debug,"debug messages, default is 0 (no)");
-MODULE_PARM_DESC(irq_debug,"irq handler debug messages, default is 0 (no)");
+MODULE_PARM_DESC(radio, "The TV card supports radio, default is 0 (no)");
+MODULE_PARM_DESC(bigendian, "byte order of the framebuffer, default is native endian");
+MODULE_PARM_DESC(bttv_verbose, "verbose startup messages, default is 1 (yes)");
+MODULE_PARM_DESC(bttv_gpio, "log gpio changes, default is 0 (no)");
+MODULE_PARM_DESC(bttv_debug, "debug messages, default is 0 (no)");
+MODULE_PARM_DESC(irq_debug, "irq handler debug messages, default is 0 (no)");
 MODULE_PARM_DESC(disable_ir, "disable infrared remote support");
-MODULE_PARM_DESC(gbuffers,"number of capture buffers. range 2-32, default 8");
-MODULE_PARM_DESC(gbufsize,"size of the capture buffers, default is 0x208000");
-MODULE_PARM_DESC(reset_crop,"reset cropping parameters at open(), default "
+MODULE_PARM_DESC(gbuffers, "number of capture buffers. range 2-32, default 8");
+MODULE_PARM_DESC(gbufsize, "size of the capture buffers, default is 0x208000");
+MODULE_PARM_DESC(reset_crop, "reset cropping parameters at open(), default "
 		 "is 1 (yes) for compatibility with older applications");
-MODULE_PARM_DESC(automute,"mute audio on bad/missing video signal, default is 1 (yes)");
-MODULE_PARM_DESC(chroma_agc,"enables the AGC of chroma signal, default is 0 (no)");
-MODULE_PARM_DESC(adc_crush,"enables the luminance ADC crush, default is 1 (yes)");
-MODULE_PARM_DESC(whitecrush_upper,"sets the white crush upper value, default is 207");
-MODULE_PARM_DESC(whitecrush_lower,"sets the white crush lower value, default is 127");
-MODULE_PARM_DESC(vcr_hack,"enables the VCR hack (improves synch on poor VCR tapes), default is 0 (no)");
-MODULE_PARM_DESC(irq_iswitch,"switch inputs in irq handler");
-MODULE_PARM_DESC(uv_ratio,"ratio between u and v gains, default is 50");
-MODULE_PARM_DESC(full_luma_range,"use the full luma range, default is 0 (no)");
-MODULE_PARM_DESC(coring,"set the luma coring level, default is 0 (no)");
+MODULE_PARM_DESC(automute, "mute audio on bad/missing video signal, default is 1 (yes)");
+MODULE_PARM_DESC(chroma_agc, "enables the AGC of chroma signal, default is 0 (no)");
+MODULE_PARM_DESC(agc_crush, "enables the luminance AGC crush, default is 1 (yes)");
+MODULE_PARM_DESC(whitecrush_upper, "sets the white crush upper value, default is 207");
+MODULE_PARM_DESC(whitecrush_lower, "sets the white crush lower value, default is 127");
+MODULE_PARM_DESC(vcr_hack, "enables the VCR hack (improves synch on poor VCR tapes), default is 0 (no)");
+MODULE_PARM_DESC(irq_iswitch, "switch inputs in irq handler");
+MODULE_PARM_DESC(uv_ratio, "ratio between u and v gains, default is 50");
+MODULE_PARM_DESC(full_luma_range, "use the full luma range, default is 0 (no)");
+MODULE_PARM_DESC(coring, "set the luma coring level, default is 0 (no)");
 MODULE_PARM_DESC(video_nr, "video device numbers");
 MODULE_PARM_DESC(vbi_nr, "vbi device numbers");
 MODULE_PARM_DESC(radio_nr, "radio device numbers");
@@ -169,6 +169,17 @@ MODULE_AUTHOR("Ralph Metzler & Marcus Metzler & Gerd Knorr");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(BTTV_VERSION);
 
+#define V4L2_CID_PRIVATE_COMBFILTER		(V4L2_CID_USER_BTTV_BASE + 0)
+#define V4L2_CID_PRIVATE_AUTOMUTE		(V4L2_CID_USER_BTTV_BASE + 1)
+#define V4L2_CID_PRIVATE_LUMAFILTER		(V4L2_CID_USER_BTTV_BASE + 2)
+#define V4L2_CID_PRIVATE_AGC_CRUSH		(V4L2_CID_USER_BTTV_BASE + 3)
+#define V4L2_CID_PRIVATE_VCR_HACK		(V4L2_CID_USER_BTTV_BASE + 4)
+#define V4L2_CID_PRIVATE_WHITECRUSH_LOWER	(V4L2_CID_USER_BTTV_BASE + 5)
+#define V4L2_CID_PRIVATE_WHITECRUSH_UPPER	(V4L2_CID_USER_BTTV_BASE + 6)
+#define V4L2_CID_PRIVATE_UV_RATIO		(V4L2_CID_USER_BTTV_BASE + 7)
+#define V4L2_CID_PRIVATE_FULL_LUMA_RANGE	(V4L2_CID_USER_BTTV_BASE + 8)
+#define V4L2_CID_PRIVATE_CORING			(V4L2_CID_USER_BTTV_BASE + 9)
+
 /* ----------------------------------------------------------------------- */
 /* sysfs                                                                   */
 
@@ -623,198 +634,6 @@ static const struct bttv_format formats[] = {
 static const unsigned int FORMATS = ARRAY_SIZE(formats);
 
 /* ----------------------------------------------------------------------- */
-
-#define V4L2_CID_PRIVATE_CHROMA_AGC  (V4L2_CID_PRIVATE_BASE + 0)
-#define V4L2_CID_PRIVATE_COMBFILTER  (V4L2_CID_PRIVATE_BASE + 1)
-#define V4L2_CID_PRIVATE_AUTOMUTE    (V4L2_CID_PRIVATE_BASE + 2)
-#define V4L2_CID_PRIVATE_LUMAFILTER  (V4L2_CID_PRIVATE_BASE + 3)
-#define V4L2_CID_PRIVATE_AGC_CRUSH   (V4L2_CID_PRIVATE_BASE + 4)
-#define V4L2_CID_PRIVATE_VCR_HACK    (V4L2_CID_PRIVATE_BASE + 5)
-#define V4L2_CID_PRIVATE_WHITECRUSH_UPPER   (V4L2_CID_PRIVATE_BASE + 6)
-#define V4L2_CID_PRIVATE_WHITECRUSH_LOWER   (V4L2_CID_PRIVATE_BASE + 7)
-#define V4L2_CID_PRIVATE_UV_RATIO    (V4L2_CID_PRIVATE_BASE + 8)
-#define V4L2_CID_PRIVATE_FULL_LUMA_RANGE    (V4L2_CID_PRIVATE_BASE + 9)
-#define V4L2_CID_PRIVATE_CORING      (V4L2_CID_PRIVATE_BASE + 10)
-#define V4L2_CID_PRIVATE_LASTP1      (V4L2_CID_PRIVATE_BASE + 11)
-
-static const struct v4l2_queryctrl no_ctl = {
-	.name  = "42",
-	.flags = V4L2_CTRL_FLAG_DISABLED,
-};
-static const struct v4l2_queryctrl bttv_ctls[] = {
-	/* --- video --- */
-	{
-		.id            = V4L2_CID_BRIGHTNESS,
-		.name          = "Brightness",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 256,
-		.default_value = 32768,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_CONTRAST,
-		.name          = "Contrast",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 128,
-		.default_value = 27648,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_SATURATION,
-		.name          = "Saturation",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 128,
-		.default_value = 32768,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_COLOR_KILLER,
-		.name          = "Color killer",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	}, {
-		.id            = V4L2_CID_HUE,
-		.name          = "Hue",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 256,
-		.default_value = 32768,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},
-	/* --- audio --- */
-	{
-		.id            = V4L2_CID_AUDIO_MUTE,
-		.name          = "Mute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_AUDIO_VOLUME,
-		.name          = "Volume",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535/100,
-		.default_value = 65535,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_AUDIO_BALANCE,
-		.name          = "Balance",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535/100,
-		.default_value = 32768,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_AUDIO_BASS,
-		.name          = "Bass",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535/100,
-		.default_value = 32768,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_AUDIO_TREBLE,
-		.name          = "Treble",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535/100,
-		.default_value = 32768,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},
-	/* --- private --- */
-	{
-		.id            = V4L2_CID_PRIVATE_CHROMA_AGC,
-		.name          = "chroma agc",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_PRIVATE_COMBFILTER,
-		.name          = "combfilter",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_PRIVATE_AUTOMUTE,
-		.name          = "automute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_PRIVATE_LUMAFILTER,
-		.name          = "luma decimation filter",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_PRIVATE_AGC_CRUSH,
-		.name          = "agc crush",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_PRIVATE_VCR_HACK,
-		.name          = "vcr hack",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_PRIVATE_WHITECRUSH_UPPER,
-		.name          = "whitecrush upper",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 1,
-		.default_value = 0xCF,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_PRIVATE_WHITECRUSH_LOWER,
-		.name          = "whitecrush lower",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 1,
-		.default_value = 0x7F,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_PRIVATE_UV_RATIO,
-		.name          = "uv ratio",
-		.minimum       = 0,
-		.maximum       = 100,
-		.step          = 1,
-		.default_value = 50,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_PRIVATE_FULL_LUMA_RANGE,
-		.name          = "full luma range",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_PRIVATE_CORING,
-		.name          = "coring",
-		.minimum       = 0,
-		.maximum       = 3,
-		.step          = 1,
-		.default_value = 0,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	}
-
-
-
-};
-
-static const struct v4l2_queryctrl *ctrl_by_id(int id)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(bttv_ctls); i++)
-		if (bttv_ctls[i].id == id)
-			return bttv_ctls+i;
-
-	return NULL;
-}
-
-/* ----------------------------------------------------------------------- */
 /* resource management                                                     */
 
 /*
@@ -1173,7 +992,7 @@ static int
 audio_mux(struct bttv *btv, int input, int mute)
 {
 	int gpio_val, signal;
-	struct v4l2_control ctrl;
+	struct v4l2_ctrl *ctrl;
 
 	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
 		   bttv_tvcards[btv->c.type].gpiomask);
@@ -1183,7 +1002,8 @@ audio_mux(struct bttv *btv, int input, int mute)
 	btv->audio = input;
 
 	/* automute */
-	mute = mute || (btv->opt_automute && !signal && !btv->radio_user);
+	mute = mute || (btv->opt_automute && (!signal || !btv->users)
+				&& !btv->radio_user);
 
 	if (mute)
 		gpio_val = bttv_tvcards[btv->c.type].gpiomute;
@@ -1205,12 +1025,13 @@ audio_mux(struct bttv *btv, int input, int mute)
 	if (in_interrupt())
 		return 0;
 
-	ctrl.id = V4L2_CID_AUDIO_MUTE;
-	ctrl.value = btv->mute;
-	bttv_call_all(btv, core, s_ctrl, &ctrl);
 	if (btv->sd_msp34xx) {
 		u32 in;
 
+		ctrl = v4l2_ctrl_find(btv->sd_msp34xx->ctrl_handler, V4L2_CID_AUDIO_MUTE);
+		if (ctrl)
+			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
+
 		/* Note: the inputs tuner/radio/extern/intern are translated
 		   to msp routings. This assumes common behavior for all msp3400
 		   based TV cards. When this assumption fails, then the
@@ -1255,9 +1076,19 @@ audio_mux(struct bttv *btv, int input, int mute)
 			       in, MSP_OUTPUT_DEFAULT, 0);
 	}
 	if (btv->sd_tvaudio) {
+		ctrl = v4l2_ctrl_find(btv->sd_tvaudio->ctrl_handler, V4L2_CID_AUDIO_MUTE);
+
+		if (ctrl)
+			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
 		v4l2_subdev_call(btv->sd_tvaudio, audio, s_routing,
 				input, 0, 0);
 	}
+	if (btv->sd_tda7432) {
+		ctrl = v4l2_ctrl_find(btv->sd_tda7432->ctrl_handler, V4L2_CID_AUDIO_MUTE);
+
+		if (ctrl)
+			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
+	}
 	return 0;
 }
 
@@ -1395,8 +1226,6 @@ static void init_irqreg(struct bttv *btv)
 
 static void init_bt848(struct bttv *btv)
 {
-	int val;
-
 	if (bttv_tvcards[btv->c.type].no_video) {
 		/* very basic init only */
 		init_irqreg(btv);
@@ -1416,30 +1245,10 @@ static void init_bt848(struct bttv *btv)
 		BT848_GPIO_DMA_CTL_GPINTI,
 		BT848_GPIO_DMA_CTL);
 
-	val = btv->opt_chroma_agc ? BT848_SCLOOP_CAGC : 0;
-	btwrite(val, BT848_E_SCLOOP);
-	btwrite(val, BT848_O_SCLOOP);
-
 	btwrite(0x20, BT848_E_VSCALE_HI);
 	btwrite(0x20, BT848_O_VSCALE_HI);
-	btwrite(BT848_ADC_RESERVED | (btv->opt_adc_crush ? BT848_ADC_CRUSH : 0),
-		BT848_ADC);
 
-	btwrite(whitecrush_upper, BT848_WC_UP);
-	btwrite(whitecrush_lower, BT848_WC_DOWN);
-
-	if (btv->opt_lumafilter) {
-		btwrite(0, BT848_E_CONTROL);
-		btwrite(0, BT848_O_CONTROL);
-	} else {
-		btwrite(BT848_CONTROL_LDEC, BT848_E_CONTROL);
-		btwrite(BT848_CONTROL_LDEC, BT848_O_CONTROL);
-	}
-
-	bt848_bright(btv,   btv->bright);
-	bt848_hue(btv,      btv->hue);
-	bt848_contrast(btv, btv->contrast);
-	bt848_sat(btv,      btv->saturation);
+	v4l2_ctrl_handler_setup(&btv->ctrl_handler);
 
 	/* interrupt */
 	init_irqreg(btv);
@@ -1461,103 +1270,26 @@ static void bttv_reinit_bt848(struct bttv *btv)
 	set_input(btv, btv->input, btv->tvnorm);
 }
 
-static int bttv_g_ctrl(struct file *file, void *priv,
-					struct v4l2_control *c)
+static int bttv_s_ctrl(struct v4l2_ctrl *c)
 {
-	struct bttv_fh *fh = priv;
-	struct bttv *btv = fh->btv;
-
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		c->value = btv->bright;
-		break;
-	case V4L2_CID_HUE:
-		c->value = btv->hue;
-		break;
-	case V4L2_CID_CONTRAST:
-		c->value = btv->contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		c->value = btv->saturation;
-		break;
-	case V4L2_CID_COLOR_KILLER:
-		c->value = btv->opt_color_killer;
-		break;
-
-	case V4L2_CID_AUDIO_MUTE:
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-		bttv_call_all(btv, core, g_ctrl, c);
-		break;
-
-	case V4L2_CID_PRIVATE_CHROMA_AGC:
-		c->value = btv->opt_chroma_agc;
-		break;
-	case V4L2_CID_PRIVATE_COMBFILTER:
-		c->value = btv->opt_combfilter;
-		break;
-	case V4L2_CID_PRIVATE_LUMAFILTER:
-		c->value = btv->opt_lumafilter;
-		break;
-	case V4L2_CID_PRIVATE_AUTOMUTE:
-		c->value = btv->opt_automute;
-		break;
-	case V4L2_CID_PRIVATE_AGC_CRUSH:
-		c->value = btv->opt_adc_crush;
-		break;
-	case V4L2_CID_PRIVATE_VCR_HACK:
-		c->value = btv->opt_vcr_hack;
-		break;
-	case V4L2_CID_PRIVATE_WHITECRUSH_UPPER:
-		c->value = btv->opt_whitecrush_upper;
-		break;
-	case V4L2_CID_PRIVATE_WHITECRUSH_LOWER:
-		c->value = btv->opt_whitecrush_lower;
-		break;
-	case V4L2_CID_PRIVATE_UV_RATIO:
-		c->value = btv->opt_uv_ratio;
-		break;
-	case V4L2_CID_PRIVATE_FULL_LUMA_RANGE:
-		c->value = btv->opt_full_luma_range;
-		break;
-	case V4L2_CID_PRIVATE_CORING:
-		c->value = btv->opt_coring;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int bttv_s_ctrl(struct file *file, void *f,
-					struct v4l2_control *c)
-{
-	int err;
-	struct bttv_fh *fh = f;
-	struct bttv *btv = fh->btv;
-
-	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (0 != err)
-		return err;
+	struct bttv *btv = container_of(c->handler, struct bttv, ctrl_handler);
+	int val;
 
 	switch (c->id) {
 	case V4L2_CID_BRIGHTNESS:
-		bt848_bright(btv, c->value);
+		bt848_bright(btv, c->val);
 		break;
 	case V4L2_CID_HUE:
-		bt848_hue(btv, c->value);
+		bt848_hue(btv, c->val);
 		break;
 	case V4L2_CID_CONTRAST:
-		bt848_contrast(btv, c->value);
+		bt848_contrast(btv, c->val);
 		break;
 	case V4L2_CID_SATURATION:
-		bt848_sat(btv, c->value);
+		bt848_sat(btv, c->val);
 		break;
 	case V4L2_CID_COLOR_KILLER:
-		btv->opt_color_killer = c->value;
-		if (btv->opt_color_killer) {
+		if (c->val) {
 			btor(BT848_SCLOOP_CKILL, BT848_E_SCLOOP);
 			btor(BT848_SCLOOP_CKILL, BT848_O_SCLOOP);
 		} else {
@@ -1566,36 +1298,22 @@ static int bttv_s_ctrl(struct file *file, void *f,
 		}
 		break;
 	case V4L2_CID_AUDIO_MUTE:
-		audio_mute(btv, c->value);
-		/* fall through */
-	case V4L2_CID_AUDIO_VOLUME:
-		if (btv->volume_gpio)
-			btv->volume_gpio(btv, c->value);
-
-		bttv_call_all(btv, core, s_ctrl, c);
+		audio_mute(btv, c->val);
 		break;
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-		bttv_call_all(btv, core, s_ctrl, c);
+	case V4L2_CID_AUDIO_VOLUME:
+		btv->volume_gpio(btv, c->val);
 		break;
 
-	case V4L2_CID_PRIVATE_CHROMA_AGC:
-		btv->opt_chroma_agc = c->value;
-		if (btv->opt_chroma_agc) {
-			btor(BT848_SCLOOP_CAGC, BT848_E_SCLOOP);
-			btor(BT848_SCLOOP_CAGC, BT848_O_SCLOOP);
-		} else {
-			btand(~BT848_SCLOOP_CAGC, BT848_E_SCLOOP);
-			btand(~BT848_SCLOOP_CAGC, BT848_O_SCLOOP);
-		}
+	case V4L2_CID_CHROMA_AGC:
+		val = c->val ? BT848_SCLOOP_CAGC : 0;
+		btwrite(val, BT848_E_SCLOOP);
+		btwrite(val, BT848_O_SCLOOP);
 		break;
 	case V4L2_CID_PRIVATE_COMBFILTER:
-		btv->opt_combfilter = c->value;
+		btv->opt_combfilter = c->val;
 		break;
 	case V4L2_CID_PRIVATE_LUMAFILTER:
-		btv->opt_lumafilter = c->value;
-		if (btv->opt_lumafilter) {
+		if (c->val) {
 			btand(~BT848_CONTROL_LDEC, BT848_E_CONTROL);
 			btand(~BT848_CONTROL_LDEC, BT848_O_CONTROL);
 		} else {
@@ -1604,36 +1322,31 @@ static int bttv_s_ctrl(struct file *file, void *f,
 		}
 		break;
 	case V4L2_CID_PRIVATE_AUTOMUTE:
-		btv->opt_automute = c->value;
+		btv->opt_automute = c->val;
 		break;
 	case V4L2_CID_PRIVATE_AGC_CRUSH:
-		btv->opt_adc_crush = c->value;
 		btwrite(BT848_ADC_RESERVED |
-				(btv->opt_adc_crush ? BT848_ADC_CRUSH : 0),
+				(c->val ? BT848_ADC_CRUSH : 0),
 				BT848_ADC);
 		break;
 	case V4L2_CID_PRIVATE_VCR_HACK:
-		btv->opt_vcr_hack = c->value;
+		btv->opt_vcr_hack = c->val;
 		break;
 	case V4L2_CID_PRIVATE_WHITECRUSH_UPPER:
-		btv->opt_whitecrush_upper = c->value;
-		btwrite(c->value, BT848_WC_UP);
+		btwrite(c->val, BT848_WC_UP);
 		break;
 	case V4L2_CID_PRIVATE_WHITECRUSH_LOWER:
-		btv->opt_whitecrush_lower = c->value;
-		btwrite(c->value, BT848_WC_DOWN);
+		btwrite(c->val, BT848_WC_DOWN);
 		break;
 	case V4L2_CID_PRIVATE_UV_RATIO:
-		btv->opt_uv_ratio = c->value;
+		btv->opt_uv_ratio = c->val;
 		bt848_sat(btv, btv->saturation);
 		break;
 	case V4L2_CID_PRIVATE_FULL_LUMA_RANGE:
-		btv->opt_full_luma_range = c->value;
-		btaor((c->value<<7), ~BT848_OFORM_RANGE, BT848_OFORM);
+		btaor((c->val << 7), ~BT848_OFORM_RANGE, BT848_OFORM);
 		break;
 	case V4L2_CID_PRIVATE_CORING:
-		btv->opt_coring = c->value;
-		btaor((c->value<<5), ~BT848_OFORM_CORE32, BT848_OFORM);
+		btaor((c->val << 5), ~BT848_OFORM_CORE32, BT848_OFORM);
 		break;
 	default:
 		return -EINVAL;
@@ -1643,6 +1356,121 @@ static int bttv_s_ctrl(struct file *file, void *f,
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops bttv_ctrl_ops = {
+	.s_ctrl = bttv_s_ctrl,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_combfilter = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_COMBFILTER,
+	.name = "Comb Filter",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_automute = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_AUTOMUTE,
+	.name = "Auto Mute",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_lumafilter = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_LUMAFILTER,
+	.name = "Luma Decimation Filter",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_agc_crush = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_AGC_CRUSH,
+	.name = "AGC Crush",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_vcr_hack = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_VCR_HACK,
+	.name = "VCR Hack",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_whitecrush_lower = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_WHITECRUSH_LOWER,
+	.name = "Whitecrush Lower",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 255,
+	.step = 1,
+	.def = 0x7f,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_whitecrush_upper = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_WHITECRUSH_UPPER,
+	.name = "Whitecrush Upper",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 255,
+	.step = 1,
+	.def = 0xcf,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_uv_ratio = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_UV_RATIO,
+	.name = "UV Ratio",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 100,
+	.step = 1,
+	.def = 50,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_full_luma = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_FULL_LUMA_RANGE,
+	.name = "Full Luma Range",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+};
+
+static struct v4l2_ctrl_config bttv_ctrl_coring = {
+	.ops = &bttv_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_CORING,
+	.name = "Coring",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 3,
+	.step = 1,
+};
+
+
+/* ----------------------------------------------------------------------- */
+
 void bttv_gpio_tracking(struct bttv *btv, char *comment)
 {
 	unsigned int outbits, data;
@@ -2047,9 +1875,11 @@ static int bttv_s_frequency(struct file *file, void *priv,
 
 static int bttv_log_status(struct file *file, void *f)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct bttv_fh *fh  = f;
 	struct bttv *btv = fh->btv;
 
+	v4l2_ctrl_handler_log_status(vdev->ctrl_handler, btv->c.v4l2_dev.name);
 	bttv_call_all(btv, core, log_status);
 	return 0;
 }
@@ -2939,30 +2769,6 @@ static int bttv_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
-static int bttv_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *c)
-{
-	struct bttv_fh *fh = priv;
-	struct bttv *btv = fh->btv;
-	const struct v4l2_queryctrl *ctrl;
-
-	if ((c->id <  V4L2_CID_BASE ||
-	     c->id >= V4L2_CID_LASTP1) &&
-	    (c->id <  V4L2_CID_PRIVATE_BASE ||
-	     c->id >= V4L2_CID_PRIVATE_LASTP1))
-		return -EINVAL;
-
-	if (!btv->volume_gpio && (c->id == V4L2_CID_AUDIO_VOLUME))
-		*c = no_ctl;
-	else {
-		ctrl = ctrl_by_id(c->id);
-
-		*c = (NULL != ctrl) ? *ctrl : no_ctl;
-	}
-
-	return 0;
-}
-
 static int bttv_g_parm(struct file *file, void *f,
 				struct v4l2_streamparm *parm)
 {
@@ -3246,6 +3052,7 @@ static int bttv_open(struct file *file)
 	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
 	if (unlikely(!fh))
 		return -ENOMEM;
+	btv->users++;
 	file->private_data = fh;
 
 	*fh = btv->init;
@@ -3270,7 +3077,6 @@ static int bttv_open(struct file *file)
 	set_tvnorm(btv,btv->tvnorm);
 	set_input(btv, btv->input, btv->tvnorm);
 
-	btv->users++;
 
 	/* The V4L2 spec requires one global set of cropping parameters
 	   which only change on request. These are stored in btv->crop[1].
@@ -3332,7 +3138,7 @@ static int bttv_release(struct file *file)
 	bttv_field_count(btv);
 
 	if (!btv->users)
-		audio_mute(btv, 1);
+		audio_mute(btv, btv->mute);
 
 	return 0;
 }
@@ -3381,9 +3187,6 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_enum_input              = bttv_enum_input,
 	.vidioc_g_input                 = bttv_g_input,
 	.vidioc_s_input                 = bttv_s_input,
-	.vidioc_queryctrl               = bttv_queryctrl,
-	.vidioc_g_ctrl                  = bttv_g_ctrl,
-	.vidioc_s_ctrl                  = bttv_s_ctrl,
 	.vidioc_streamon                = bttv_streamon,
 	.vidioc_streamoff               = bttv_streamoff,
 	.vidioc_g_tuner                 = bttv_g_tuner,
@@ -3492,24 +3295,6 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *c)
-{
-	const struct v4l2_queryctrl *ctrl;
-
-	if (c->id <  V4L2_CID_BASE ||
-			c->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-
-	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		ctrl = ctrl_by_id(c->id);
-		*c = *ctrl;
-	} else
-		*c = no_ctl;
-
-	return 0;
-}
-
 static ssize_t radio_read(struct file *file, char __user *data,
 			 size_t count, loff_t *ppos)
 {
@@ -3551,11 +3336,9 @@ static const struct v4l2_file_operations radio_fops =
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap        = bttv_querycap,
+	.vidioc_log_status	= bttv_log_status,
 	.vidioc_g_tuner         = radio_g_tuner,
 	.vidioc_s_tuner         = radio_s_tuner,
-	.vidioc_queryctrl       = radio_queryctrl,
-	.vidioc_g_ctrl          = bttv_g_ctrl,
-	.vidioc_s_ctrl          = bttv_s_ctrl,
 	.vidioc_g_frequency     = bttv_g_frequency,
 	.vidioc_s_frequency     = bttv_s_frequency,
 };
@@ -4201,6 +3984,7 @@ static int bttv_register_video(struct bttv *btv)
 	btv->radio_dev = vdev_init(btv, &radio_template, "radio");
 	if (NULL == btv->radio_dev)
 		goto err;
+	btv->radio_dev->ctrl_handler = &btv->radio_ctrl_handler;
 	if (video_register_device(btv->radio_dev, VFL_TYPE_RADIO,
 				  radio_nr[btv->c.nr]) < 0)
 		goto err;
@@ -4239,6 +4023,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	int result;
 	unsigned char lat;
 	struct bttv *btv;
+	struct v4l2_ctrl_handler *hdl;
 
 	if (bttv_num == BTTV_MAX)
 		return -ENOMEM;
@@ -4298,6 +4083,10 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 		pr_warn("%d: v4l2_device_register() failed\n", btv->c.nr);
 		goto fail0;
 	}
+	hdl = &btv->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 20);
+	btv->c.v4l2_dev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(&btv->radio_ctrl_handler, 6);
 
 	btv->revision = dev->revision;
 	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
@@ -4334,16 +4123,19 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 
 	/* init options from insmod args */
 	btv->opt_combfilter = combfilter;
-	btv->opt_lumafilter = lumafilter;
+	bttv_ctrl_combfilter.def = combfilter;
+	bttv_ctrl_lumafilter.def = lumafilter;
 	btv->opt_automute   = automute;
-	btv->opt_chroma_agc = chroma_agc;
-	btv->opt_adc_crush  = adc_crush;
+	bttv_ctrl_automute.def = automute;
+	bttv_ctrl_agc_crush.def = agc_crush;
 	btv->opt_vcr_hack   = vcr_hack;
-	btv->opt_whitecrush_upper  = whitecrush_upper;
-	btv->opt_whitecrush_lower  = whitecrush_lower;
+	bttv_ctrl_vcr_hack.def = vcr_hack;
+	bttv_ctrl_whitecrush_upper.def = whitecrush_upper;
+	bttv_ctrl_whitecrush_lower.def = whitecrush_lower;
 	btv->opt_uv_ratio   = uv_ratio;
-	btv->opt_full_luma_range   = full_luma_range;
-	btv->opt_coring     = coring;
+	bttv_ctrl_uv_ratio.def = uv_ratio;
+	bttv_ctrl_full_luma.def = full_luma_range;
+	bttv_ctrl_coring.def = coring;
 
 	/* fill struct bttv with some useful defaults */
 	btv->init.btv         = btv;
@@ -4354,6 +4146,34 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	btv->init.height      = 240;
 	btv->input = 0;
 
+	v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 0xff00, 0x100, 32768);
+	v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 0xff80, 0x80, 0x6c00);
+	v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 0xff80, 0x80, 32768);
+	v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
+			V4L2_CID_COLOR_KILLER, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
+			V4L2_CID_HUE, 0, 0xff00, 0x100, 32768);
+	v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
+			V4L2_CID_CHROMA_AGC, 0, 1, 1, !!chroma_agc);
+	v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
+		V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	if (btv->volume_gpio)
+		v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 0xff00, 0x100, 0xff00);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_combfilter, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_automute, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_lumafilter, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_agc_crush, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_vcr_hack, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_whitecrush_lower, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_whitecrush_upper, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_uv_ratio, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_full_luma, NULL);
+	v4l2_ctrl_new_custom(hdl, &bttv_ctrl_coring, NULL);
+
 	/* initialize hardware */
 	if (bttv_gpio)
 		bttv_gpio_tracking(btv,"pre-init");
@@ -4381,20 +4201,26 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 		btv->radio_freq = 90500 * 16; /* 90.5Mhz default */
 	}
 	init_irqreg(btv);
+	v4l2_ctrl_handler_setup(hdl);
 
+	if (hdl->error) {
+		result = hdl->error;
+		goto fail2;
+	}
 	/* register video4linux + input */
 	if (!bttv_tvcards[btv->c.type].no_video) {
-		bttv_register_video(btv);
-		bt848_bright(btv,32768);
-		bt848_contrast(btv, 27648);
-		bt848_hue(btv,32768);
-		bt848_sat(btv,32768);
-		audio_mute(btv, 1);
+		v4l2_ctrl_add_handler(&btv->radio_ctrl_handler, hdl,
+				v4l2_ctrl_radio_filter);
+		if (btv->radio_ctrl_handler.error) {
+			result = btv->radio_ctrl_handler.error;
+			goto fail2;
+		}
 		set_input(btv, 0, btv->tvnorm);
 		bttv_crop_reset(&btv->crop[0], btv->tvnorm);
 		btv->crop[1] = btv->crop[0]; /* current = default */
 		disclaim_vbi_lines(btv);
 		disclaim_video_lines(btv);
+		bttv_register_video(btv);
 	}
 
 	/* add subdevices and autoload dvb-bt8xx if needed */
@@ -4416,6 +4242,8 @@ fail2:
 	free_irq(btv->c.pci->irq,btv);
 
 fail1:
+	v4l2_ctrl_handler_free(&btv->ctrl_handler);
+	v4l2_ctrl_handler_free(&btv->radio_ctrl_handler);
 	v4l2_device_unregister(&btv->c.v4l2_dev);
 
 fail0:
@@ -4457,9 +4285,11 @@ static void bttv_remove(struct pci_dev *pci_dev)
 	bttv_unregister_video(btv);
 
 	/* free allocated memory */
+	v4l2_ctrl_handler_free(&btv->ctrl_handler);
+	v4l2_ctrl_handler_free(&btv->radio_ctrl_handler);
 	btcx_riscmem_free(btv->c.pci,&btv->main);
 
-	/* free ressources */
+	/* free resources */
 	free_irq(btv->c.pci->irq,btv);
 	iounmap(btv->bt848_mmio);
 	release_mem_region(pci_resource_start(btv->c.pci,0),
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 528e03e..c3882ef 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -33,9 +33,10 @@
 #include <linux/input.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
+#include <linux/device.h>
 #include <asm/io.h>
 #include <media/v4l2-common.h>
-#include <linux/device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/tveeprom.h>
 #include <media/rc-core.h>
@@ -393,12 +394,17 @@ struct bttv {
 	wait_queue_head_t          i2c_queue;
 	struct v4l2_subdev 	  *sd_msp34xx;
 	struct v4l2_subdev 	  *sd_tvaudio;
+	struct v4l2_subdev	  *sd_tda7432;
 
 	/* video4linux (1) */
 	struct video_device *video_dev;
 	struct video_device *radio_dev;
 	struct video_device *vbi_dev;
 
+	/* controls */
+	struct v4l2_ctrl_handler   ctrl_handler;
+	struct v4l2_ctrl_handler   radio_ctrl_handler;
+
 	/* infrared remote */
 	int has_remote;
 	struct bttv_ir *remote;
@@ -426,17 +432,9 @@ struct bttv {
 
 	/* various options */
 	int opt_combfilter;
-	int opt_lumafilter;
 	int opt_automute;
-	int opt_chroma_agc;
-	int opt_color_killer;
-	int opt_adc_crush;
 	int opt_vcr_hack;
-	int opt_whitecrush_upper;
-	int opt_whitecrush_lower;
 	int opt_uv_ratio;
-	int opt_full_luma_range;
-	int opt_coring;
 
 	/* radio data/state */
 	int has_radio;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index dcd6374..1d00ca9 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -146,6 +146,11 @@ enum v4l2_colorfx {
  * of controls. We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_MEYE_BASE			(V4L2_CID_USER_BASE + 0x1000)
 
+/* The base for the bttv driver controls.
+ * We reserve 32 controls for this driver. */
+#define V4L2_CID_USER_BTTV_BASE			(V4L2_CID_USER_BASE + 0x1010)
+
+
 /* MPEG-class control IDs */
 
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.7.10.4

