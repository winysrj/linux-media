Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50223 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3L1MQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 01/24] em28xx: move some video-specific functions to em28xx-video
Date: Sat, 28 Dec 2013 10:15:53 -0200
Message-Id: <1388232976-20061-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Now that we want to split the video handling to a separate
module, move all video-specific functions to em28xx-video.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 107 ---------
 drivers/media/usb/em28xx/em28xx-core.c  | 259 ----------------------
 drivers/media/usb/em28xx/em28xx-video.c | 374 +++++++++++++++++++++++++++++++-
 drivers/media/usb/em28xx/em28xx.h       |   1 +
 4 files changed, 371 insertions(+), 370 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 36853f16bf97..19827e79cf53 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2529,113 +2529,6 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 	em28xx_set_mode(dev, EM28XX_SUSPEND);
 }
 
-static void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
-{
-	memset(ctl, 0, sizeof(*ctl));
-
-	ctl->fname   = XC2028_DEFAULT_FIRMWARE;
-	ctl->max_len = 64;
-	ctl->mts = em28xx_boards[dev->model].mts_firmware;
-
-	switch (dev->model) {
-	case EM2880_BOARD_EMPIRE_DUAL_TV:
-	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
-	case EM2882_BOARD_TERRATEC_HYBRID_XS:
-		ctl->demod = XC3028_FE_ZARLINK456;
-		break;
-	case EM2880_BOARD_TERRATEC_HYBRID_XS:
-	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
-	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
-		ctl->demod = XC3028_FE_ZARLINK456;
-		break;
-	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
-	case EM2882_BOARD_PINNACLE_HYBRID_PRO_330E:
-		ctl->demod = XC3028_FE_DEFAULT;
-		break;
-	case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
-		ctl->demod = XC3028_FE_DEFAULT;
-		ctl->fname = XC3028L_DEFAULT_FIRMWARE;
-		break;
-	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850:
-	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
-	case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:
-		/* FIXME: Better to specify the needed IF */
-		ctl->demod = XC3028_FE_DEFAULT;
-		break;
-	case EM2883_BOARD_KWORLD_HYBRID_330U:
-	case EM2882_BOARD_DIKOM_DK300:
-	case EM2882_BOARD_KWORLD_VS_DVBT:
-		ctl->demod = XC3028_FE_CHINA;
-		ctl->fname = XC2028_DEFAULT_FIRMWARE;
-		break;
-	case EM2882_BOARD_EVGA_INDTUBE:
-		ctl->demod = XC3028_FE_CHINA;
-		ctl->fname = XC3028L_DEFAULT_FIRMWARE;
-		break;
-	default:
-		ctl->demod = XC3028_FE_OREN538;
-	}
-}
-
-static void em28xx_tuner_setup(struct em28xx *dev)
-{
-	struct tuner_setup           tun_setup;
-	struct v4l2_frequency        f;
-
-	if (dev->tuner_type == TUNER_ABSENT)
-		return;
-
-	memset(&tun_setup, 0, sizeof(tun_setup));
-
-	tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
-	tun_setup.tuner_callback = em28xx_tuner_callback;
-
-	if (dev->board.radio.type) {
-		tun_setup.type = dev->board.radio.type;
-		tun_setup.addr = dev->board.radio_addr;
-
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
-	}
-
-	if ((dev->tuner_type != TUNER_ABSENT) && (dev->tuner_type)) {
-		tun_setup.type   = dev->tuner_type;
-		tun_setup.addr   = dev->tuner_addr;
-
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
-	}
-
-	if (dev->tda9887_conf) {
-		struct v4l2_priv_tun_config tda9887_cfg;
-
-		tda9887_cfg.tuner = TUNER_TDA9887;
-		tda9887_cfg.priv = &dev->tda9887_conf;
-
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config, &tda9887_cfg);
-	}
-
-	if (dev->tuner_type == TUNER_XC2028) {
-		struct v4l2_priv_tun_config  xc2028_cfg;
-		struct xc2028_ctrl           ctl;
-
-		memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
-		memset(&ctl, 0, sizeof(ctl));
-
-		em28xx_setup_xc3028(dev, &ctl);
-
-		xc2028_cfg.tuner = TUNER_XC2028;
-		xc2028_cfg.priv  = &ctl;
-
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config, &xc2028_cfg);
-	}
-
-	/* configure tuner */
-	f.tuner = 0;
-	f.type = V4L2_TUNER_ANALOG_TV;
-	f.frequency = 9076;     /* just a magic number */
-	dev->ctl_freq = f.frequency;
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
-}
-
 static int em28xx_hint_board(struct em28xx *dev)
 {
 	int i;
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index f6076a512e8f..3012912d2997 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -53,14 +53,6 @@ MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
 		printk(KERN_INFO "%s %s :"fmt, \
 			 dev->name, __func__ , ##arg); } while (0)
 
-static int alt;
-module_param(alt, int, 0644);
-MODULE_PARM_DESC(alt, "alternate setting to use for video endpoint");
-
-static unsigned int disable_vbi;
-module_param(disable_vbi, int, 0644);
-MODULE_PARM_DESC(disable_vbi, "disable vbi support");
-
 /* FIXME */
 #define em28xx_isocdbg(fmt, arg...) do {\
 	if (core_debug) \
@@ -603,24 +595,6 @@ init_audio:
 }
 EXPORT_SYMBOL_GPL(em28xx_audio_setup);
 
-int em28xx_colorlevels_set_default(struct em28xx *dev)
-{
-	em28xx_write_reg(dev, EM28XX_R20_YGAIN, CONTRAST_DEFAULT);
-	em28xx_write_reg(dev, EM28XX_R21_YOFFSET, BRIGHTNESS_DEFAULT);
-	em28xx_write_reg(dev, EM28XX_R22_UVGAIN, SATURATION_DEFAULT);
-	em28xx_write_reg(dev, EM28XX_R23_UOFFSET, BLUE_BALANCE_DEFAULT);
-	em28xx_write_reg(dev, EM28XX_R24_VOFFSET, RED_BALANCE_DEFAULT);
-	em28xx_write_reg(dev, EM28XX_R25_SHARPNESS, SHARPNESS_DEFAULT);
-
-	em28xx_write_reg(dev, EM28XX_R14_GAMMA, 0x20);
-	em28xx_write_reg(dev, EM28XX_R15_RGAIN, 0x20);
-	em28xx_write_reg(dev, EM28XX_R16_GGAIN, 0x20);
-	em28xx_write_reg(dev, EM28XX_R17_BGAIN, 0x20);
-	em28xx_write_reg(dev, EM28XX_R18_ROFFSET, 0x00);
-	em28xx_write_reg(dev, EM28XX_R19_GOFFSET, 0x00);
-	return em28xx_write_reg(dev, EM28XX_R1A_BOFFSET, 0x00);
-}
-
 const struct em28xx_led *em28xx_find_led(struct em28xx *dev,
 					 enum em28xx_led_role role)
 {
@@ -696,227 +670,6 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 	return rc;
 }
 
-int em28xx_vbi_supported(struct em28xx *dev)
-{
-	/* Modprobe option to manually disable */
-	if (disable_vbi == 1)
-		return 0;
-
-	if (dev->board.is_webcam)
-		return 0;
-
-	/* FIXME: check subdevices for VBI support */
-
-	if (dev->chip_id == CHIP_ID_EM2860 ||
-	    dev->chip_id == CHIP_ID_EM2883)
-		return 1;
-
-	/* Version of em28xx that does not support VBI */
-	return 0;
-}
-
-int em28xx_set_outfmt(struct em28xx *dev)
-{
-	int ret;
-	u8 fmt, vinctrl;
-
-	fmt = dev->format->reg;
-	if (!dev->is_em25xx)
-		fmt |= 0x20;
-	/*
-	 * NOTE: it's not clear if this is really needed !
-	 * The datasheets say bit 5 is a reserved bit and devices seem to work
-	 * fine without it. But the Windows driver sets it for em2710/50+em28xx
-	 * devices and we've always been setting it, too.
-	 *
-	 * em2765 (em25xx, em276x/7x/8x) devices do NOT work with this bit set,
-	 * it's likely used for an additional (compressed ?) format there.
-	 */
-	ret = em28xx_write_reg(dev, EM28XX_R27_OUTFMT, fmt);
-	if (ret < 0)
-		return ret;
-
-	ret = em28xx_write_reg(dev, EM28XX_R10_VINMODE, dev->vinmode);
-	if (ret < 0)
-		return ret;
-
-	vinctrl = dev->vinctl;
-	if (em28xx_vbi_supported(dev) == 1) {
-		vinctrl |= EM28XX_VINCTRL_VBI_RAW;
-		em28xx_write_reg(dev, EM28XX_R34_VBI_START_H, 0x00);
-		em28xx_write_reg(dev, EM28XX_R36_VBI_WIDTH, dev->vbi_width/4);
-		em28xx_write_reg(dev, EM28XX_R37_VBI_HEIGHT, dev->vbi_height);
-		if (dev->norm & V4L2_STD_525_60) {
-			/* NTSC */
-			em28xx_write_reg(dev, EM28XX_R35_VBI_START_V, 0x09);
-		} else if (dev->norm & V4L2_STD_625_50) {
-			/* PAL */
-			em28xx_write_reg(dev, EM28XX_R35_VBI_START_V, 0x07);
-		}
-	}
-
-	return em28xx_write_reg(dev, EM28XX_R11_VINCTRL, vinctrl);
-}
-
-static int em28xx_accumulator_set(struct em28xx *dev, u8 xmin, u8 xmax,
-				  u8 ymin, u8 ymax)
-{
-	em28xx_coredbg("em28xx Scale: (%d,%d)-(%d,%d)\n",
-			xmin, ymin, xmax, ymax);
-
-	em28xx_write_regs(dev, EM28XX_R28_XMIN, &xmin, 1);
-	em28xx_write_regs(dev, EM28XX_R29_XMAX, &xmax, 1);
-	em28xx_write_regs(dev, EM28XX_R2A_YMIN, &ymin, 1);
-	return em28xx_write_regs(dev, EM28XX_R2B_YMAX, &ymax, 1);
-}
-
-static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
-				   u16 width, u16 height)
-{
-	u8 cwidth = width >> 2;
-	u8 cheight = height >> 2;
-	u8 overflow = (height >> 9 & 0x02) | (width >> 10 & 0x01);
-	/* NOTE: size limit: 2047x1023 = 2MPix */
-
-	em28xx_coredbg("capture area set to (%d,%d): %dx%d\n",
-		       hstart, vstart,
-		       ((overflow & 2) << 9 | cwidth << 2),
-		       ((overflow & 1) << 10 | cheight << 2));
-
-	em28xx_write_regs(dev, EM28XX_R1C_HSTART, &hstart, 1);
-	em28xx_write_regs(dev, EM28XX_R1D_VSTART, &vstart, 1);
-	em28xx_write_regs(dev, EM28XX_R1E_CWIDTH, &cwidth, 1);
-	em28xx_write_regs(dev, EM28XX_R1F_CHEIGHT, &cheight, 1);
-	em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
-
-	/* FIXME: function/meaning of these registers ? */
-	/* FIXME: align width+height to multiples of 4 ?! */
-	if (dev->is_em25xx) {
-		em28xx_write_reg(dev, 0x34, width >> 4);
-		em28xx_write_reg(dev, 0x35, height >> 4);
-	}
-}
-
-static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
-{
-	u8 mode;
-	/* the em2800 scaler only supports scaling down to 50% */
-
-	if (dev->board.is_em2800) {
-		mode = (v ? 0x20 : 0x00) | (h ? 0x10 : 0x00);
-	} else {
-		u8 buf[2];
-
-		buf[0] = h;
-		buf[1] = h >> 8;
-		em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf, 2);
-
-		buf[0] = v;
-		buf[1] = v >> 8;
-		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
-		/* it seems that both H and V scalers must be active
-		   to work correctly */
-		mode = (h || v) ? 0x30 : 0x00;
-	}
-	return em28xx_write_reg_bits(dev, EM28XX_R26_COMPR, mode, 0x30);
-}
-
-/* FIXME: this only function read values from dev */
-int em28xx_resolution_set(struct em28xx *dev)
-{
-	int width, height;
-	width = norm_maxw(dev);
-	height = norm_maxh(dev);
-
-	/* Properly setup VBI */
-	dev->vbi_width = 720;
-	if (dev->norm & V4L2_STD_525_60)
-		dev->vbi_height = 12;
-	else
-		dev->vbi_height = 18;
-
-	em28xx_set_outfmt(dev);
-
-	em28xx_accumulator_set(dev, 1, (width - 4) >> 2, 1, (height - 4) >> 2);
-
-	/* If we don't set the start position to 2 in VBI mode, we end up
-	   with line 20/21 being YUYV encoded instead of being in 8-bit
-	   greyscale.  The core of the issue is that line 21 (and line 23 for
-	   PAL WSS) are inside of active video region, and as a result they
-	   get the pixelformatting associated with that area.  So by cropping
-	   it out, we end up with the same format as the rest of the VBI
-	   region */
-	if (em28xx_vbi_supported(dev) == 1)
-		em28xx_capture_area_set(dev, 0, 2, width, height);
-	else
-		em28xx_capture_area_set(dev, 0, 0, width, height);
-
-	return em28xx_scaler_set(dev, dev->hscale, dev->vscale);
-}
-
-/* Set USB alternate setting for analog video */
-int em28xx_set_alternate(struct em28xx *dev)
-{
-	int errCode;
-	int i;
-	unsigned int min_pkt_size = dev->width * 2 + 4;
-
-	/* NOTE: for isoc transfers, only alt settings > 0 are allowed
-		 bulk transfers seem to work only with alt=0 ! */
-	dev->alt = 0;
-	if ((alt > 0) && (alt < dev->num_alt)) {
-		em28xx_coredbg("alternate forced to %d\n", dev->alt);
-		dev->alt = alt;
-		goto set_alt;
-	}
-	if (dev->analog_xfer_bulk)
-		goto set_alt;
-
-	/* When image size is bigger than a certain value,
-	   the frame size should be increased, otherwise, only
-	   green screen will be received.
-	 */
-	if (dev->width * 2 * dev->height > 720 * 240 * 2)
-		min_pkt_size *= 2;
-
-	for (i = 0; i < dev->num_alt; i++) {
-		/* stop when the selected alt setting offers enough bandwidth */
-		if (dev->alt_max_pkt_size_isoc[i] >= min_pkt_size) {
-			dev->alt = i;
-			break;
-		/* otherwise make sure that we end up with the maximum bandwidth
-		   because the min_pkt_size equation might be wrong...
-		*/
-		} else if (dev->alt_max_pkt_size_isoc[i] >
-			   dev->alt_max_pkt_size_isoc[dev->alt])
-			dev->alt = i;
-	}
-
-set_alt:
-	/* NOTE: for bulk transfers, we need to call usb_set_interface()
-	 * even if the previous settings were the same. Otherwise streaming
-	 * fails with all urbs having status = -EOVERFLOW ! */
-	if (dev->analog_xfer_bulk) {
-		dev->max_pkt_size = 512; /* USB 2.0 spec */
-		dev->packet_multiplier = EM28XX_BULK_PACKET_MULTIPLIER;
-	} else { /* isoc */
-		em28xx_coredbg("minimum isoc packet size: %u (alt=%d)\n",
-			       min_pkt_size, dev->alt);
-		dev->max_pkt_size =
-				  dev->alt_max_pkt_size_isoc[dev->alt];
-		dev->packet_multiplier = EM28XX_NUM_ISOC_PACKETS;
-	}
-	em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
-		       dev->alt, dev->max_pkt_size);
-	errCode = usb_set_interface(dev->udev, 0, dev->alt);
-	if (errCode < 0) {
-		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
-			      dev->alt, errCode);
-		return errCode;
-	}
-	return 0;
-}
-
 int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio)
 {
 	int rc = 0;
@@ -1282,18 +1035,6 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 EXPORT_SYMBOL_GPL(em28xx_init_usb_xfer);
 
 /*
- * em28xx_wake_i2c()
- * configure i2c attached devices
- */
-void em28xx_wake_i2c(struct em28xx *dev)
-{
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
-			INPUT(dev->ctl_input)->vmux, 0, 0);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
-}
-
-/*
  * Device control list
  */
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index dd19c9ff76e0..70ffe259df5b 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -53,15 +53,23 @@
 
 #define EM28XX_VERSION "0.2.0"
 
+static unsigned int isoc_debug;
+module_param(isoc_debug, int, 0644);
+MODULE_PARM_DESC(isoc_debug, "enable debug messages [isoc transfers]");
+
+static unsigned int disable_vbi;
+module_param(disable_vbi, int, 0644);
+MODULE_PARM_DESC(disable_vbi, "disable vbi support");
+
+static int alt;
+module_param(alt, int, 0644);
+MODULE_PARM_DESC(alt, "alternate setting to use for video endpoint");
+
 #define em28xx_videodbg(fmt, arg...) do {\
 	if (video_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
 			 dev->name, __func__ , ##arg); } while (0)
 
-static unsigned int isoc_debug;
-module_param(isoc_debug, int, 0644);
-MODULE_PARM_DESC(isoc_debug, "enable debug messages [isoc transfers]");
-
 #define em28xx_isocdbg(fmt, arg...) \
 do {\
 	if (isoc_debug) { \
@@ -135,6 +143,257 @@ static struct em28xx_fmt format[] = {
 	},
 };
 
+/*
+ * em28xx_wake_i2c()
+ * configure i2c attached devices
+ */
+void em28xx_wake_i2c(struct em28xx *dev)
+{
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
+			INPUT(dev->ctl_input)->vmux, 0, 0);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+}
+
+int em28xx_colorlevels_set_default(struct em28xx *dev)
+{
+	em28xx_write_reg(dev, EM28XX_R20_YGAIN, CONTRAST_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R21_YOFFSET, BRIGHTNESS_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R22_UVGAIN, SATURATION_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R23_UOFFSET, BLUE_BALANCE_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R24_VOFFSET, RED_BALANCE_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R25_SHARPNESS, SHARPNESS_DEFAULT);
+
+	em28xx_write_reg(dev, EM28XX_R14_GAMMA, 0x20);
+	em28xx_write_reg(dev, EM28XX_R15_RGAIN, 0x20);
+	em28xx_write_reg(dev, EM28XX_R16_GGAIN, 0x20);
+	em28xx_write_reg(dev, EM28XX_R17_BGAIN, 0x20);
+	em28xx_write_reg(dev, EM28XX_R18_ROFFSET, 0x00);
+	em28xx_write_reg(dev, EM28XX_R19_GOFFSET, 0x00);
+	return em28xx_write_reg(dev, EM28XX_R1A_BOFFSET, 0x00);
+}
+
+int em28xx_set_outfmt(struct em28xx *dev)
+{
+	int ret;
+	u8 fmt, vinctrl;
+
+	fmt = dev->format->reg;
+	if (!dev->is_em25xx)
+		fmt |= 0x20;
+	/*
+	 * NOTE: it's not clear if this is really needed !
+	 * The datasheets say bit 5 is a reserved bit and devices seem to work
+	 * fine without it. But the Windows driver sets it for em2710/50+em28xx
+	 * devices and we've always been setting it, too.
+	 *
+	 * em2765 (em25xx, em276x/7x/8x) devices do NOT work with this bit set,
+	 * it's likely used for an additional (compressed ?) format there.
+	 */
+	ret = em28xx_write_reg(dev, EM28XX_R27_OUTFMT, fmt);
+	if (ret < 0)
+		return ret;
+
+	ret = em28xx_write_reg(dev, EM28XX_R10_VINMODE, dev->vinmode);
+	if (ret < 0)
+		return ret;
+
+	vinctrl = dev->vinctl;
+	if (em28xx_vbi_supported(dev) == 1) {
+		vinctrl |= EM28XX_VINCTRL_VBI_RAW;
+		em28xx_write_reg(dev, EM28XX_R34_VBI_START_H, 0x00);
+		em28xx_write_reg(dev, EM28XX_R36_VBI_WIDTH, dev->vbi_width/4);
+		em28xx_write_reg(dev, EM28XX_R37_VBI_HEIGHT, dev->vbi_height);
+		if (dev->norm & V4L2_STD_525_60) {
+			/* NTSC */
+			em28xx_write_reg(dev, EM28XX_R35_VBI_START_V, 0x09);
+		} else if (dev->norm & V4L2_STD_625_50) {
+			/* PAL */
+			em28xx_write_reg(dev, EM28XX_R35_VBI_START_V, 0x07);
+		}
+	}
+
+	return em28xx_write_reg(dev, EM28XX_R11_VINCTRL, vinctrl);
+}
+
+static int em28xx_accumulator_set(struct em28xx *dev, u8 xmin, u8 xmax,
+				  u8 ymin, u8 ymax)
+{
+	em28xx_videodbg("em28xx Scale: (%d,%d)-(%d,%d)\n",
+			xmin, ymin, xmax, ymax);
+
+	em28xx_write_regs(dev, EM28XX_R28_XMIN, &xmin, 1);
+	em28xx_write_regs(dev, EM28XX_R29_XMAX, &xmax, 1);
+	em28xx_write_regs(dev, EM28XX_R2A_YMIN, &ymin, 1);
+	return em28xx_write_regs(dev, EM28XX_R2B_YMAX, &ymax, 1);
+}
+
+static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
+				   u16 width, u16 height)
+{
+	u8 cwidth = width >> 2;
+	u8 cheight = height >> 2;
+	u8 overflow = (height >> 9 & 0x02) | (width >> 10 & 0x01);
+	/* NOTE: size limit: 2047x1023 = 2MPix */
+
+	em28xx_videodbg("capture area set to (%d,%d): %dx%d\n",
+		       hstart, vstart,
+		       ((overflow & 2) << 9 | cwidth << 2),
+		       ((overflow & 1) << 10 | cheight << 2));
+
+	em28xx_write_regs(dev, EM28XX_R1C_HSTART, &hstart, 1);
+	em28xx_write_regs(dev, EM28XX_R1D_VSTART, &vstart, 1);
+	em28xx_write_regs(dev, EM28XX_R1E_CWIDTH, &cwidth, 1);
+	em28xx_write_regs(dev, EM28XX_R1F_CHEIGHT, &cheight, 1);
+	em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
+
+	/* FIXME: function/meaning of these registers ? */
+	/* FIXME: align width+height to multiples of 4 ?! */
+	if (dev->is_em25xx) {
+		em28xx_write_reg(dev, 0x34, width >> 4);
+		em28xx_write_reg(dev, 0x35, height >> 4);
+	}
+}
+
+static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
+{
+	u8 mode;
+	/* the em2800 scaler only supports scaling down to 50% */
+
+	if (dev->board.is_em2800) {
+		mode = (v ? 0x20 : 0x00) | (h ? 0x10 : 0x00);
+	} else {
+		u8 buf[2];
+
+		buf[0] = h;
+		buf[1] = h >> 8;
+		em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf, 2);
+
+		buf[0] = v;
+		buf[1] = v >> 8;
+		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
+		/* it seems that both H and V scalers must be active
+		   to work correctly */
+		mode = (h || v) ? 0x30 : 0x00;
+	}
+	return em28xx_write_reg_bits(dev, EM28XX_R26_COMPR, mode, 0x30);
+}
+
+/* FIXME: this only function read values from dev */
+int em28xx_resolution_set(struct em28xx *dev)
+{
+	int width, height;
+	width = norm_maxw(dev);
+	height = norm_maxh(dev);
+
+	/* Properly setup VBI */
+	dev->vbi_width = 720;
+	if (dev->norm & V4L2_STD_525_60)
+		dev->vbi_height = 12;
+	else
+		dev->vbi_height = 18;
+
+	em28xx_set_outfmt(dev);
+
+	em28xx_accumulator_set(dev, 1, (width - 4) >> 2, 1, (height - 4) >> 2);
+
+	/* If we don't set the start position to 2 in VBI mode, we end up
+	   with line 20/21 being YUYV encoded instead of being in 8-bit
+	   greyscale.  The core of the issue is that line 21 (and line 23 for
+	   PAL WSS) are inside of active video region, and as a result they
+	   get the pixelformatting associated with that area.  So by cropping
+	   it out, we end up with the same format as the rest of the VBI
+	   region */
+	if (em28xx_vbi_supported(dev) == 1)
+		em28xx_capture_area_set(dev, 0, 2, width, height);
+	else
+		em28xx_capture_area_set(dev, 0, 0, width, height);
+
+	return em28xx_scaler_set(dev, dev->hscale, dev->vscale);
+}
+
+int em28xx_vbi_supported(struct em28xx *dev)
+{
+	/* Modprobe option to manually disable */
+	if (disable_vbi == 1)
+		return 0;
+
+	if (dev->board.is_webcam)
+		return 0;
+
+	/* FIXME: check subdevices for VBI support */
+
+	if (dev->chip_id == CHIP_ID_EM2860 ||
+	    dev->chip_id == CHIP_ID_EM2883)
+		return 1;
+
+	/* Version of em28xx that does not support VBI */
+	return 0;
+}
+
+/* Set USB alternate setting for analog video */
+int em28xx_set_alternate(struct em28xx *dev)
+{
+	int errCode;
+	int i;
+	unsigned int min_pkt_size = dev->width * 2 + 4;
+
+	/* NOTE: for isoc transfers, only alt settings > 0 are allowed
+		 bulk transfers seem to work only with alt=0 ! */
+	dev->alt = 0;
+	if ((alt > 0) && (alt < dev->num_alt)) {
+		em28xx_videodbg("alternate forced to %d\n", dev->alt);
+		dev->alt = alt;
+		goto set_alt;
+	}
+	if (dev->analog_xfer_bulk)
+		goto set_alt;
+
+	/* When image size is bigger than a certain value,
+	   the frame size should be increased, otherwise, only
+	   green screen will be received.
+	 */
+	if (dev->width * 2 * dev->height > 720 * 240 * 2)
+		min_pkt_size *= 2;
+
+	for (i = 0; i < dev->num_alt; i++) {
+		/* stop when the selected alt setting offers enough bandwidth */
+		if (dev->alt_max_pkt_size_isoc[i] >= min_pkt_size) {
+			dev->alt = i;
+			break;
+		/* otherwise make sure that we end up with the maximum bandwidth
+		   because the min_pkt_size equation might be wrong...
+		*/
+		} else if (dev->alt_max_pkt_size_isoc[i] >
+			   dev->alt_max_pkt_size_isoc[dev->alt])
+			dev->alt = i;
+	}
+
+set_alt:
+	/* NOTE: for bulk transfers, we need to call usb_set_interface()
+	 * even if the previous settings were the same. Otherwise streaming
+	 * fails with all urbs having status = -EOVERFLOW ! */
+	if (dev->analog_xfer_bulk) {
+		dev->max_pkt_size = 512; /* USB 2.0 spec */
+		dev->packet_multiplier = EM28XX_BULK_PACKET_MULTIPLIER;
+	} else { /* isoc */
+		em28xx_videodbg("minimum isoc packet size: %u (alt=%d)\n",
+			       min_pkt_size, dev->alt);
+		dev->max_pkt_size =
+				  dev->alt_max_pkt_size_isoc[dev->alt];
+		dev->packet_multiplier = EM28XX_NUM_ISOC_PACKETS;
+	}
+	em28xx_videodbg("setting alternate %d with wMaxPacketSize=%u\n",
+		       dev->alt, dev->max_pkt_size);
+	errCode = usb_set_interface(dev->udev, 0, dev->alt);
+	if (errCode < 0) {
+		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
+			      dev->alt, errCode);
+		return errCode;
+	}
+	return 0;
+}
+
 /* ------------------------------------------------------------------
 	DMA and thread functions
    ------------------------------------------------------------------*/
@@ -1817,6 +2076,113 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 	return vfd;
 }
 
+static void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
+{
+	memset(ctl, 0, sizeof(*ctl));
+
+	ctl->fname   = XC2028_DEFAULT_FIRMWARE;
+	ctl->max_len = 64;
+	ctl->mts = em28xx_boards[dev->model].mts_firmware;
+
+	switch (dev->model) {
+	case EM2880_BOARD_EMPIRE_DUAL_TV:
+	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
+	case EM2882_BOARD_TERRATEC_HYBRID_XS:
+		ctl->demod = XC3028_FE_ZARLINK456;
+		break;
+	case EM2880_BOARD_TERRATEC_HYBRID_XS:
+	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
+	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
+		ctl->demod = XC3028_FE_ZARLINK456;
+		break;
+	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
+	case EM2882_BOARD_PINNACLE_HYBRID_PRO_330E:
+		ctl->demod = XC3028_FE_DEFAULT;
+		break;
+	case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
+		ctl->demod = XC3028_FE_DEFAULT;
+		ctl->fname = XC3028L_DEFAULT_FIRMWARE;
+		break;
+	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850:
+	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
+	case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:
+		/* FIXME: Better to specify the needed IF */
+		ctl->demod = XC3028_FE_DEFAULT;
+		break;
+	case EM2883_BOARD_KWORLD_HYBRID_330U:
+	case EM2882_BOARD_DIKOM_DK300:
+	case EM2882_BOARD_KWORLD_VS_DVBT:
+		ctl->demod = XC3028_FE_CHINA;
+		ctl->fname = XC2028_DEFAULT_FIRMWARE;
+		break;
+	case EM2882_BOARD_EVGA_INDTUBE:
+		ctl->demod = XC3028_FE_CHINA;
+		ctl->fname = XC3028L_DEFAULT_FIRMWARE;
+		break;
+	default:
+		ctl->demod = XC3028_FE_OREN538;
+	}
+}
+
+void em28xx_tuner_setup(struct em28xx *dev)
+{
+	struct tuner_setup           tun_setup;
+	struct v4l2_frequency        f;
+
+	if (dev->tuner_type == TUNER_ABSENT)
+		return;
+
+	memset(&tun_setup, 0, sizeof(tun_setup));
+
+	tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
+	tun_setup.tuner_callback = em28xx_tuner_callback;
+
+	if (dev->board.radio.type) {
+		tun_setup.type = dev->board.radio.type;
+		tun_setup.addr = dev->board.radio_addr;
+
+		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
+	}
+
+	if ((dev->tuner_type != TUNER_ABSENT) && (dev->tuner_type)) {
+		tun_setup.type   = dev->tuner_type;
+		tun_setup.addr   = dev->tuner_addr;
+
+		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
+	}
+
+	if (dev->tda9887_conf) {
+		struct v4l2_priv_tun_config tda9887_cfg;
+
+		tda9887_cfg.tuner = TUNER_TDA9887;
+		tda9887_cfg.priv = &dev->tda9887_conf;
+
+		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config, &tda9887_cfg);
+	}
+
+	if (dev->tuner_type == TUNER_XC2028) {
+		struct v4l2_priv_tun_config  xc2028_cfg;
+		struct xc2028_ctrl           ctl;
+
+		memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
+		memset(&ctl, 0, sizeof(ctl));
+
+		em28xx_setup_xc3028(dev, &ctl);
+
+		xc2028_cfg.tuner = TUNER_XC2028;
+		xc2028_cfg.priv  = &ctl;
+
+		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config, &xc2028_cfg);
+	}
+
+	/* configure tuner */
+	f.tuner = 0;
+	f.type = V4L2_TUNER_ANALOG_TV;
+	f.frequency = 9076;     /* just a magic number */
+	dev->ctl_freq = f.frequency;
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
+}
+
 int em28xx_register_analog_devices(struct em28xx *dev)
 {
 	u8 val;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 191ef3593891..0259270dda46 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -748,6 +748,7 @@ void em28xx_init_extension(struct em28xx *dev);
 void em28xx_close_extension(struct em28xx *dev);
 
 /* Provided by em28xx-video.c */
+void em28xx_tuner_setup(struct em28xx *dev);
 int em28xx_vb2_setup(struct em28xx *dev);
 int em28xx_register_analog_devices(struct em28xx *dev);
 void em28xx_release_analog_resources(struct em28xx *dev);
-- 
1.8.3.1

