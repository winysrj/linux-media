Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f217.google.com ([209.85.219.217]:58992 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZIJF3x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 01:29:53 -0400
Received: by ewy17 with SMTP id 17so1601544ewy.39
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 22:29:54 -0700 (PDT)
Date: Thu, 10 Sep 2009 15:25:10 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: tuner, code for discuss
Message-ID: <20090910152510.6970f8ab@glory.loctelecom.ru>
In-Reply-To: <37219a840908250940m3393f73ftbaa28639ca0f93cd@mail.gmail.com>
References: <20090819160700.049985b5@glory.loctelecom.ru>
	<37219a840908250940m3393f73ftbaa28639ca0f93cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/9pBCGjRRgD5LM5yI5tDYmPl"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/9pBCGjRRgD5LM5yI5tDYmPl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

This is my next patch.

Changes:
1. By default charge pump is ON
2. For radio mode charge pump set to OFF
3. Set correct AGC value in radio mode
4. Add control gain of AGC.
5. New function simple_get_tv_gain and simple_set_tv_gain for read/write gain of AGC. 
6. Add some code for control gain from saa7134 part. By default this control is OFF 7. When TV card can
manipulate this control, enable it.

Main changes is control value of AGC TOP in .initdata = tua603x_agc112 array. Use this value for set AGC TOP after set freq of TV.

I don't understand how to correct call new function for read/write value of AGC TOP.

What you think about it??

diff -r 3f7e382dfae5 linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Thu Sep 10 06:05:49 2009 +1000
@@ -144,6 +144,7 @@
 	case TUNER_PHILIPS_FM1256_IH3:
 	case TUNER_LG_NTSC_TAPE:
 	case TUNER_TCL_MF02GIP_5N:
+	case TUNER_TCL_MFPE05_2:
 		return ((status & TUNER_SIGNAL) == TUNER_STEREO_MK3);
 	default:
 		return status & TUNER_STEREO;
@@ -491,6 +492,18 @@
 				   "(should be 4)\n", rc);
 		break;
 	}
+	case TUNER_TCL_MFPE05_2:
+		{
+
+		printk("posttune TCL_MFPE05_2\r\n");
+
+		if (priv->tun->initdata) {
+		printk("write AUX byte = 0x%X",priv->tun->initdata[2]);
+			simple_set_aux_byte(fe, config, priv->tun->initdata[2]);
+		}
+
+		break;
+		}
 	}
 
 	return 0;
@@ -499,6 +512,7 @@
 static int simple_radio_bandswitch(struct dvb_frontend *fe, u8 *buffer)
 {
 	struct tuner_simple_priv *priv = fe->tuner_priv;
+	u8 rc;
 
 	switch (priv->type) {
 	case TUNER_TENA_9533_DI:
@@ -513,6 +527,11 @@
 	case TUNER_LG_NTSC_TAPE:
 	case TUNER_PHILIPS_FM1256_IH3:
 	case TUNER_TCL_MF02GIP_5N:
+		buffer[3] = 0x19;
+		break;
+	case TUNER_TCL_MFPE05_2:
+		rc = buffer[2]&0xbf;
+		buffer[2] = rc;		/* Switch OFF Charge Pump */
 		buffer[3] = 0x19;
 		break;
 	case TUNER_TNF_5335MF:
@@ -754,7 +773,53 @@
 	if (4 != rc)
 		tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
 
+	/* Write AUX byte */
+	switch (priv->type) {
+	case TUNER_TCL_MFPE05_2:
+	printk("write AUX byte\n");
+		simple_set_aux_byte(fe, 0x98, 0x20);
+		break;
+	}
+
 	return 0;
+}
+
+static int simple_set_tv_gain(struct dvb_frontend *fe,
+			      u8 tvgain)
+{
+	struct tuner_simple_priv *priv = fe->tuner_priv;
+	int ret = -EINVAL;
+
+	switch (priv->type) {
+	case TUNER_TCL_MFPE05_2:
+		if (priv->tun->initdata) {
+			priv->tun->initdata[2] = tvgain;
+		printk("set AUX byte = 0x%X",priv->tun->initdata[2]);
+			ret = 0;
+		}
+		break;
+	} /* switch (priv->type) */
+
+	return ret;
+}
+
+static int simple_get_tv_gain(struct dvb_frontend *fe,
+			      u8 *tvgain)
+{
+	struct tuner_simple_priv *priv = fe->tuner_priv;
+	int ret = -EINVAL;
+
+	switch (priv->type) {
+	case TUNER_TCL_MFPE05_2:
+		if (priv->tun->initdata) {
+			*tvgain = priv->tun->initdata[2];
+			printk("read AUX byte = 0x%X",priv->tun->initdata[2]);
+			ret = 0;
+		}
+		break;
+	} /* switch (priv->type) */
+
+	return ret;
 }
 
 static int simple_set_params(struct dvb_frontend *fe,
diff -r 3f7e382dfae5 linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Thu Sep 10 06:05:49 2009 +1000
@@ -1321,6 +1321,31 @@
 	},
 };
 
+/* ------------ TUNER_TCL_MFPE05_2 - TCL MFPE05-2 ALL ------------ */
+
+static struct tuner_range tuner_tcl_mfpe05_2_all_ranges[] = {
+	{ 16 * 158.00 /*MHz*/, 0xc6, 0x01, },
+	{ 16 * 441.00 /*MHz*/, 0xc6, 0x02, },
+	{ 16 * 864.00        , 0xc6, 0x04, },
+};
+
+static struct tuner_params tuner_tcl_mfpe05_2_all_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_PAL,
+		.ranges = tuner_tcl_mfpe05_2_all_ranges,
+		.count  = ARRAY_SIZE(tuner_tcl_mfpe05_2_all_ranges),
+		.cb_first_if_lower_freq = 1,
+		.has_tda9887 = 1,
+		.port1_active = 1,
+		.port2_active = 1,
+		.port2_invert_for_secam_lc = 1,
+		.port1_fm_high_sensitivity = 1,
+		.default_top_mid = -2,
+		.default_top_secam_mid = -2,
+		.default_top_secam_high = -2,
+	},
+};
+
 /* --------------------------------------------------------------------- */
 
 struct tunertype tuners[] = {
@@ -1779,6 +1804,14 @@
 		.params = tuner_partsnic_pti_5nf05_params,
 		.count  = ARRAY_SIZE(tuner_partsnic_pti_5nf05_params),
 	},
+
+	[TUNER_TCL_MFPE05_2] = { /* TCL ALL */
+		.name   = "TCL MFPE05-2 MK3 PAL/SECAM multi (Beholder Lab)",
+		.params = tuner_tcl_mfpe05_2_all_params,
+		.count  = ARRAY_SIZE(tuner_tcl_mfpe05_2_all_params),
+		.initdata = tua603x_agc112,
+		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
+	},
 };
 EXPORT_SYMBOL(tuners);
 
diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Sep 10 06:05:49 2009 +1000
@@ -4500,7 +4500,7 @@
 		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.tuner_type     = TUNER_TCL_MFPE05_2,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4537,7 +4537,7 @@
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV M63",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.tuner_type     = TUNER_TCL_MFPE05_2,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -7099,6 +7099,18 @@
 		}
 		break;
 	}
+	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	{
+		struct v4l2_queryctrl* ctl;
+		struct saa7134_fh *fh;
+		struct file *fl;
+
+		ctl->id = V4L2_CID_GAIN;
+		if (saa7134_queryctrl(fl,fh,ctl)==0){
+			ctl->flags &= ~(V4L2_CTRL_FLAG_DISABLED); /* enable this control */
+		}
+	}
 	} /* switch() */
 
 	/* initialize tuner */
diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Thu Sep 10 06:05:49 2009 +1000
@@ -413,6 +413,15 @@
 		.step          = 1,
 		.default_value = 0,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
+	},{
+		.id 		= V4L2_CID_GAIN,
+		.name 		= "Gain",
+		.minimum 	= 0,
+		.maximum 	= 6,
+		.step 		= 1,
+		.default_value 	= 3,
+		.type 		= V4L2_CTRL_TYPE_INTEGER,
+		.flags 		= V4L2_CTRL_FLAG_DISABLED,
 	},{
 		.id            = V4L2_CID_HFLIP,
 		.name          = "Mirror",
@@ -1128,6 +1137,9 @@
 	case V4L2_CID_HUE:
 		c->value = dev->ctl_hue;
 		break;
+	case V4L2_CID_GAIN:
+		c->value = dev->ctl_gain;
+		break;
 	case V4L2_CID_CONTRAST:
 		c->value = dev->ctl_contrast;
 		break;
@@ -1175,6 +1187,7 @@
 	unsigned long flags;
 	int restart_overlay = 0;
 	int err;
+	unsigned char tgain;
 
 	/* When called from the empress code fh == NULL.
 	   That needs to be fixed somehow, but for now this is
@@ -1214,6 +1227,38 @@
 		dev->ctl_hue = c->value;
 		saa_writeb(SAA7134_DEC_CHROMA_HUE, dev->ctl_hue);
 		break;
+	case V4L2_CID_GAIN:
+		dev->ctl_gain = c->value;
+
+		switch (c->value) {
+		case 0:
+			tgain = 0x80|0x50; /* TOP = 103dB, ATC = OFF */
+			break;
+		case 1:
+			tgain = 0x80|0x40; /* TOP = 106dB, ATC = OFF */
+			break;
+		case 2:
+			tgain = 0x80|0x30; /* TOP = 109dB, ATC = OFF */
+			break;
+		case 3:
+			tgain = 0x80|0x20; /* TOP = 112dB, ATC = OFF */
+			break;
+		case 4:
+			tgain = 0x80|0x10; /* TOP = 115dB, ATC = OFF */
+			break;
+		case 5:
+			tgain = 0x80|0x00; /* TOP = 118dB, ATC = OFF */
+			break;
+		case 6:
+			tgain = 0x80|0x60; /* TOP = External AGC, ATC = OFF */
+			break;
+		default:
+			tgain = 0x80|0x20;
+		break;
+		}
+		/* call simple set AUX byte here */
+		/* simple_set_v_gain(); */
+ 		break;
 	case V4L2_CID_CONTRAST:
 		dev->ctl_contrast = c->value;
 		saa_writeb(SAA7134_DEC_LUMA_CONTRAST,
@@ -2534,6 +2579,7 @@
 	dev->ctl_bright     = ctrl_by_id(V4L2_CID_BRIGHTNESS)->default_value;
 	dev->ctl_contrast   = ctrl_by_id(V4L2_CID_CONTRAST)->default_value;
 	dev->ctl_hue        = ctrl_by_id(V4L2_CID_HUE)->default_value;
+	dev->ctl_gain       = ctrl_by_id(V4L2_CID_GAIN)->default_value;
 	dev->ctl_saturation = ctrl_by_id(V4L2_CID_SATURATION)->default_value;
 	dev->ctl_volume     = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
 	dev->ctl_mute       = 1; // ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value;
diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Thu Sep 10 06:05:49 2009 +1000
@@ -565,6 +565,7 @@
 	int                        ctl_bright;
 	int                        ctl_contrast;
 	int                        ctl_hue;
+	int                        ctl_gain;             /* gain */
 	int                        ctl_saturation;
 	int                        ctl_freq;
 	int                        ctl_mute;             /* audio */
diff -r 3f7e382dfae5 linux/include/media/tuner.h
--- a/linux/include/media/tuner.h	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/include/media/tuner.h	Thu Sep 10 06:05:49 2009 +1000
@@ -127,6 +127,7 @@
 #define TUNER_PHILIPS_FM1216MK5		79
 #define TUNER_PHILIPS_FQ1216LME_MK3	80	/* Active loopthrough, no FM */
 #define TUNER_PARTSNIC_PTI_5NF05	81
+#define TUNER_TCL_MFPE05_2		82	/* TCL clone of the Philips FM1216ME_MK3 */
 
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)


With my best regards, Dmitry.
--MP_/9pBCGjRRgD5LM5yI5tDYmPl
Content-Type: text/x-patch; name=tcl_tuner_1.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tcl_tuner_1.diff

diff -r 3f7e382dfae5 linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Thu Sep 10 06:05:49 2009 +1000
@@ -144,6 +144,7 @@
 	case TUNER_PHILIPS_FM1256_IH3:
 	case TUNER_LG_NTSC_TAPE:
 	case TUNER_TCL_MF02GIP_5N:
+	case TUNER_TCL_MFPE05_2:
 		return ((status & TUNER_SIGNAL) == TUNER_STEREO_MK3);
 	default:
 		return status & TUNER_STEREO;
@@ -491,6 +492,18 @@
 				   "(should be 4)\n", rc);
 		break;
 	}
+	case TUNER_TCL_MFPE05_2:
+		{
+
+		printk("posttune TCL_MFPE05_2\r\n");
+
+		if (priv->tun->initdata) {
+		printk("write AUX byte = 0x%X",priv->tun->initdata[2]);
+			simple_set_aux_byte(fe, config, priv->tun->initdata[2]);
+		}
+
+		break;
+		}
 	}
 
 	return 0;
@@ -499,6 +512,7 @@
 static int simple_radio_bandswitch(struct dvb_frontend *fe, u8 *buffer)
 {
 	struct tuner_simple_priv *priv = fe->tuner_priv;
+	u8 rc;
 
 	switch (priv->type) {
 	case TUNER_TENA_9533_DI:
@@ -513,6 +527,11 @@
 	case TUNER_LG_NTSC_TAPE:
 	case TUNER_PHILIPS_FM1256_IH3:
 	case TUNER_TCL_MF02GIP_5N:
+		buffer[3] = 0x19;
+		break;
+	case TUNER_TCL_MFPE05_2:
+		rc = buffer[2]&0xbf;
+		buffer[2] = rc;		/* Switch OFF Charge Pump */
 		buffer[3] = 0x19;
 		break;
 	case TUNER_TNF_5335MF:
@@ -754,7 +773,53 @@
 	if (4 != rc)
 		tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
 
+	/* Write AUX byte */
+	switch (priv->type) {
+	case TUNER_TCL_MFPE05_2:
+	printk("write AUX byte\n");
+		simple_set_aux_byte(fe, 0x98, 0x20);
+		break;
+	}
+
 	return 0;
+}
+
+static int simple_set_tv_gain(struct dvb_frontend *fe,
+			      u8 tvgain)
+{
+	struct tuner_simple_priv *priv = fe->tuner_priv;
+	int ret = -EINVAL;
+
+	switch (priv->type) {
+	case TUNER_TCL_MFPE05_2:
+		if (priv->tun->initdata) {
+			priv->tun->initdata[2] = tvgain;
+		printk("set AUX byte = 0x%X",priv->tun->initdata[2]);
+			ret = 0;
+		}
+		break;
+	} /* switch (priv->type) */
+
+	return ret;
+}
+
+static int simple_get_tv_gain(struct dvb_frontend *fe,
+			      u8 *tvgain)
+{
+	struct tuner_simple_priv *priv = fe->tuner_priv;
+	int ret = -EINVAL;
+
+	switch (priv->type) {
+	case TUNER_TCL_MFPE05_2:
+		if (priv->tun->initdata) {
+			*tvgain = priv->tun->initdata[2];
+			printk("read AUX byte = 0x%X",priv->tun->initdata[2]);
+			ret = 0;
+		}
+		break;
+	} /* switch (priv->type) */
+
+	return ret;
 }
 
 static int simple_set_params(struct dvb_frontend *fe,
diff -r 3f7e382dfae5 linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Thu Sep 10 06:05:49 2009 +1000
@@ -1321,6 +1321,31 @@
 	},
 };
 
+/* ------------ TUNER_TCL_MFPE05_2 - TCL MFPE05-2 ALL ------------ */
+
+static struct tuner_range tuner_tcl_mfpe05_2_all_ranges[] = {
+	{ 16 * 158.00 /*MHz*/, 0xc6, 0x01, },
+	{ 16 * 441.00 /*MHz*/, 0xc6, 0x02, },
+	{ 16 * 864.00        , 0xc6, 0x04, },
+};
+
+static struct tuner_params tuner_tcl_mfpe05_2_all_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_PAL,
+		.ranges = tuner_tcl_mfpe05_2_all_ranges,
+		.count  = ARRAY_SIZE(tuner_tcl_mfpe05_2_all_ranges),
+		.cb_first_if_lower_freq = 1,
+		.has_tda9887 = 1,
+		.port1_active = 1,
+		.port2_active = 1,
+		.port2_invert_for_secam_lc = 1,
+		.port1_fm_high_sensitivity = 1,
+		.default_top_mid = -2,
+		.default_top_secam_mid = -2,
+		.default_top_secam_high = -2,
+	},
+};
+
 /* --------------------------------------------------------------------- */
 
 struct tunertype tuners[] = {
@@ -1779,6 +1804,14 @@
 		.params = tuner_partsnic_pti_5nf05_params,
 		.count  = ARRAY_SIZE(tuner_partsnic_pti_5nf05_params),
 	},
+
+	[TUNER_TCL_MFPE05_2] = { /* TCL ALL */
+		.name   = "TCL MFPE05-2 MK3 PAL/SECAM multi (Beholder Lab)",
+		.params = tuner_tcl_mfpe05_2_all_params,
+		.count  = ARRAY_SIZE(tuner_tcl_mfpe05_2_all_params),
+		.initdata = tua603x_agc112,
+		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
+	},
 };
 EXPORT_SYMBOL(tuners);
 
diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Sep 10 06:05:49 2009 +1000
@@ -4500,7 +4500,7 @@
 		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.tuner_type     = TUNER_TCL_MFPE05_2,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4537,7 +4537,7 @@
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV M63",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.tuner_type     = TUNER_TCL_MFPE05_2,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -7099,6 +7099,18 @@
 		}
 		break;
 	}
+	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	{
+		struct v4l2_queryctrl* ctl;
+		struct saa7134_fh *fh;
+		struct file *fl;
+
+		ctl->id = V4L2_CID_GAIN;
+		if (saa7134_queryctrl(fl,fh,ctl)==0){
+			ctl->flags &= ~(V4L2_CTRL_FLAG_DISABLED); /* enable this control */
+		}
+	}
 	} /* switch() */
 
 	/* initialize tuner */
diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Thu Sep 10 06:05:49 2009 +1000
@@ -413,6 +413,15 @@
 		.step          = 1,
 		.default_value = 0,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
+	},{
+		.id 		= V4L2_CID_GAIN,
+		.name 		= "Gain",
+		.minimum 	= 0,
+		.maximum 	= 6,
+		.step 		= 1,
+		.default_value 	= 3,
+		.type 		= V4L2_CTRL_TYPE_INTEGER,
+		.flags 		= V4L2_CTRL_FLAG_DISABLED,
 	},{
 		.id            = V4L2_CID_HFLIP,
 		.name          = "Mirror",
@@ -1128,6 +1137,9 @@
 	case V4L2_CID_HUE:
 		c->value = dev->ctl_hue;
 		break;
+	case V4L2_CID_GAIN:
+		c->value = dev->ctl_gain;
+		break;
 	case V4L2_CID_CONTRAST:
 		c->value = dev->ctl_contrast;
 		break;
@@ -1175,6 +1187,7 @@
 	unsigned long flags;
 	int restart_overlay = 0;
 	int err;
+	unsigned char tgain;
 
 	/* When called from the empress code fh == NULL.
 	   That needs to be fixed somehow, but for now this is
@@ -1214,6 +1227,38 @@
 		dev->ctl_hue = c->value;
 		saa_writeb(SAA7134_DEC_CHROMA_HUE, dev->ctl_hue);
 		break;
+	case V4L2_CID_GAIN:
+		dev->ctl_gain = c->value;
+
+		switch (c->value) {
+		case 0:
+			tgain = 0x80|0x50; /* TOP = 103dB, ATC = OFF */
+			break;
+		case 1:
+			tgain = 0x80|0x40; /* TOP = 106dB, ATC = OFF */
+			break;
+		case 2:
+			tgain = 0x80|0x30; /* TOP = 109dB, ATC = OFF */
+			break;
+		case 3:
+			tgain = 0x80|0x20; /* TOP = 112dB, ATC = OFF */
+			break;
+		case 4:
+			tgain = 0x80|0x10; /* TOP = 115dB, ATC = OFF */
+			break;
+		case 5:
+			tgain = 0x80|0x00; /* TOP = 118dB, ATC = OFF */
+			break;
+		case 6:
+			tgain = 0x80|0x60; /* TOP = External AGC, ATC = OFF */
+			break;
+		default:
+			tgain = 0x80|0x20;
+		break;
+		}
+		/* call simple set AUX byte here */
+		/* simple_set_v_gain(); */
+ 		break;
 	case V4L2_CID_CONTRAST:
 		dev->ctl_contrast = c->value;
 		saa_writeb(SAA7134_DEC_LUMA_CONTRAST,
@@ -2534,6 +2579,7 @@
 	dev->ctl_bright     = ctrl_by_id(V4L2_CID_BRIGHTNESS)->default_value;
 	dev->ctl_contrast   = ctrl_by_id(V4L2_CID_CONTRAST)->default_value;
 	dev->ctl_hue        = ctrl_by_id(V4L2_CID_HUE)->default_value;
+	dev->ctl_gain       = ctrl_by_id(V4L2_CID_GAIN)->default_value;
 	dev->ctl_saturation = ctrl_by_id(V4L2_CID_SATURATION)->default_value;
 	dev->ctl_volume     = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
 	dev->ctl_mute       = 1; // ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value;
diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Thu Sep 10 06:05:49 2009 +1000
@@ -565,6 +565,7 @@
 	int                        ctl_bright;
 	int                        ctl_contrast;
 	int                        ctl_hue;
+	int                        ctl_gain;             /* gain */
 	int                        ctl_saturation;
 	int                        ctl_freq;
 	int                        ctl_mute;             /* audio */
diff -r 3f7e382dfae5 linux/include/media/tuner.h
--- a/linux/include/media/tuner.h	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/include/media/tuner.h	Thu Sep 10 06:05:49 2009 +1000
@@ -127,6 +127,7 @@
 #define TUNER_PHILIPS_FM1216MK5		79
 #define TUNER_PHILIPS_FQ1216LME_MK3	80	/* Active loopthrough, no FM */
 #define TUNER_PARTSNIC_PTI_5NF05	81
+#define TUNER_TCL_MFPE05_2		82	/* TCL clone of the Philips FM1216ME_MK3 */
 
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)

--MP_/9pBCGjRRgD5LM5yI5tDYmPl--
