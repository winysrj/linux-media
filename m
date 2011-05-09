Return-path: <mchehab@gaivota>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:57239 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228Ab1EITyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:11 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 02/16] tm6000: add tm6010 audio mode setup
Date: Mon,  9 May 2011 21:53:50 +0200
Message-Id: <1304970844-20955-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

add tm6010 audio mode setup


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-stds.c  |  149 ++++++++++++++++++---------------
 drivers/staging/tm6000/tm6000-video.c |   35 +++++---
 drivers/staging/tm6000/tm6000.h       |    1 +
 3 files changed, 107 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index da3e51b..588b1fc 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -22,6 +22,9 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 
+static unsigned int tm6010_a_mode = 0;
+module_param(tm6010_a_mode, int, 0644);
+MODULE_PARM_DESC(tm6010_a_mode, "set tm6010 sif audio mode");
 struct tm6000_reg_settings {
 	unsigned char req;
 	unsigned char reg;
@@ -947,9 +950,8 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 				enum tm6000_audio_std std)
 {
 	uint8_t areg_02 = 0x04; /* GC1 Fixed gain 0dB */
-	uint8_t areg_05 = 0x09; /* Auto 4.5 = M Japan, Auto 6.5 = DK */
+	uint8_t areg_05 = 0x01; /* Auto 4.5 = M Japan, Auto 6.5 = DK */
 	uint8_t areg_06 = 0x02; /* Auto de-emphasis, mannual channel mode */
-	uint8_t mono_flag = 0;  /* No mono */
 	uint8_t nicam_flag = 0; /* No NICAM */
 
 	if (dev->radio) {
@@ -958,81 +960,99 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
 		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80);
 		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0c);
-		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
+		/* set mono or stereo */
+		if (dev->amode == V4L2_TUNER_MODE_MONO)
+			tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
+		else if (dev->amode == V4L2_TUNER_MODE_STEREO)
+			tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x02);
 		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x18);
 		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a);
 		tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x40);
-		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
+		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe);
 		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
 		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
 		return 0;
 	}
 
-	switch (std) {
-#if 0
-	case DK_MONO:
-		mono_flag = 1;
-		break;
-	case DK_A2_1:
-		break;
-	case DK_A2_3:
-		areg_05 = 0x0b;
-		break;
-	case BG_MONO:
-		mono_flag = 1;
-		areg_05 = 0x05;
-		break;
-#endif
-	case BG_NICAM:
-		areg_05 = 0x07;
-		nicam_flag = 1;
-		break;
-	case BTSC:
-		areg_05 = 0x02;
-		break;
-	case BG_A2:
-		areg_05 = 0x05;
-		break;
-	case DK_NICAM:
-		areg_05 = 0x06;
-		nicam_flag = 1;
-		break;
-	case EIAJ:
-		areg_05 = 0x02;
-		break;
-	case I_NICAM:
-		areg_05 = 0x08;
-		nicam_flag = 1;
+	switch (tm6010_a_mode) {
+	/* auto */
+	case 0:
+		switch (dev->norm) {
+		case V4L2_STD_NTSC_M_KR:
+			areg_05 |= 0x00;
+			break;
+		case V4L2_STD_NTSC_M_JP:
+			areg_05 |= 0x40;
+			break;
+		case V4L2_STD_NTSC_M:
+		case V4L2_STD_PAL_M:
+		case V4L2_STD_PAL_N:
+			areg_05 |= 0x20;
+			break;
+		case V4L2_STD_PAL_Nc:
+			areg_05 |= 0x60;
+			break;
+		case V4L2_STD_SECAM_L:
+			areg_05 |= 0x00;
+			break;
+		case V4L2_STD_DK:
+			areg_05 |= 0x10;
+			break;
+		}
 		break;
-	case KOREA_A2:
-		areg_05 = 0x04;
+	/* A2 */
+	case 1:
+		switch (dev->norm) {
+		case V4L2_STD_B:
+		case V4L2_STD_GH:
+			areg_05 = 0x05;
+			break;
+		case V4L2_STD_DK:
+			areg_05 = 0x09;
+			break;
+		}
 		break;
-	case L_NICAM:
-		areg_02 = 0x02; /* GC1 Fixed gain +12dB */
-		areg_05 = 0x0a;
+	/* NICAM */
+	case 2:
+		switch (dev->norm) {
+		case V4L2_STD_B:
+		case V4L2_STD_GH:
+			areg_05 = 0x07;
+			break;
+		case V4L2_STD_DK:
+			areg_05 = 0x06;
+			break;
+		case V4L2_STD_PAL_I:
+			areg_05 = 0x08;
+			break;
+		case V4L2_STD_SECAM_L:
+			areg_05 = 0x0a;
+			areg_02 = 0x02;
+			break;
+		}
 		nicam_flag = 1;
 		break;
-	default:
-		/* do nothink */
-		break;
-	}
-
-#if 0
-	switch (tv_audio_mode) {
-	case TV_MONO:
-		areg_06 = (nicam_flag) ? 0x03 : 0x00;
-		break;
-	case TV_LANG_A:
-		areg_06 = 0x00;
-		break;
-	case TV_LANG_B:
-		areg_06 = 0x01;
+	/* other */
+	case 3:
+		switch (dev->norm) {
+		/* DK3_A2 */
+		case V4L2_STD_DK:
+			areg_05 = 0x0b;
+			break;
+		/* Korea */
+		case V4L2_STD_NTSC_M_KR:
+			areg_05 = 0x04;
+			break;
+		/* EIAJ */
+		case V4L2_STD_NTSC_M_JP:
+			areg_05 = 0x03;
+			break;
+		default:
+			areg_05 = 0x02;
+			break;
+		}
 		break;
 	}
-#endif
-
-	if (mono_flag)
-		areg_06 = 0x00;
 
 	tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
 	tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, areg_02);
@@ -1066,9 +1086,6 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 	tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
 	tm6000_set_reg(dev, TM6010_REQ08_R1F_A_TEST_INTF_SEL, 0x00);
 	tm6000_set_reg(dev, TM6010_REQ08_R20_A_TEST_PIN_SEL, 0x00);
-	tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
-	tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
-	tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
 	tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
 
 	return 0;
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index a434a32..e1a7eb2 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -34,6 +34,7 @@
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
+#include <media/tuner.h>
 #include <linux/interrupt.h>
 #include <linux/kthread.h>
 #include <linux/highmem.h>
@@ -883,14 +884,19 @@ static void res_free(struct tm6000_core *dev, struct tm6000_fh *fh)
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
+	struct tm6000_core *dev = ((struct tm6000_fh *)priv)->dev;
 
 	strlcpy(cap->driver, "tm6000", sizeof(cap->driver));
 	strlcpy(cap->card, "Trident TVMaster TM5600/6000/6010", sizeof(cap->card));
 	cap->version = TM6000_VERSION;
 	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_STREAMING     |
-				V4L2_CAP_TUNER	       |
+				V4L2_CAP_AUDIO         |
 				V4L2_CAP_READWRITE;
+
+	if (dev->tuner_type != TUNER_ABSENT)
+		cap->capabilities |= V4L2_CAP_TUNER;
+
 	return 0;
 }
 
@@ -1150,7 +1156,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return rc;
 }
 
-	/* --- controls ---------------------------------------------- */
+/* --- controls ---------------------------------------------- */
 static int vidioc_queryctrl(struct file *file, void *priv,
 				struct v4l2_queryctrl *qc)
 {
@@ -1251,7 +1257,11 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	t->type       = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM;
 	t->rangehigh  = 0xffffffffUL;
-	t->rxsubchans = V4L2_TUNER_SUB_MONO;
+	t->rxsubchans = V4L2_TUNER_SUB_STEREO;
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
+
+	t->audmode = dev->amode;
 
 	return 0;
 }
@@ -1267,6 +1277,10 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
+	dev->amode = t->audmode;
+	dprintk(dev, 3, "audio mode: %x\n", t->audmode);
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
 	return 0;
 }
 
@@ -1320,7 +1334,11 @@ static int radio_querycap(struct file *file, void *priv,
 		le16_to_cpu(dev->udev->descriptor.idVendor),
 		le16_to_cpu(dev->udev->descriptor.idProduct));
 	cap->version = dev->dev_type;
-	cap->capabilities = V4L2_CAP_TUNER;
+	cap->capabilities = V4L2_CAP_TUNER |
+			V4L2_CAP_AUDIO     |
+			V4L2_CAP_RADIO     |
+			V4L2_CAP_READWRITE |
+			V4L2_CAP_STREAMING;
 
 	return 0;
 }
@@ -1337,17 +1355,10 @@ static int radio_g_tuner(struct file *file, void *priv,
 	memset(t, 0, sizeof(*t));
 	strcpy(t->name, "Radio");
 	t->type = V4L2_TUNER_RADIO;
+	t->rxsubchans = V4L2_TUNER_SUB_STEREO;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
 
-	if ((dev->aradio == TM6000_AIP_LINE1) ||
-				(dev->aradio == TM6000_AIP_LINE2)) {
-		t->rxsubchans = V4L2_TUNER_SUB_MONO;
-	}
-	else {
-		t->rxsubchans = V4L2_TUNER_SUB_STEREO;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 8cdc992..43b0d62 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -221,6 +221,7 @@ struct tm6000_core {
 
 	int				ctl_mute;             /* audio */
 	int				ctl_volume;
+	int				amode;
 
 	/* DVB-T support */
 	struct tm6000_dvb		*dvb;
-- 
1.7.4.2

