Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1KXQUU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 11:20:20 -0500
Message-ID: <4ECE6EBC.8020006@redhat.com>
Date: Thu, 24 Nov 2011 14:20:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Stefan Ringel <stefan.ringel@arcor.de>,
	linux-media@vger.kernel.org, fabbione@redhat.com
Subject: Re: [PATCH] Fix tm6010 audio
References: <4E8C5675.8070604@arcor.de> <20111017155537.6c55aec8@glory.local> <4E9C65CD.2070409@arcor.de> <20111108104500.2f0fc14f@glory.local>
In-Reply-To: <20111108104500.2f0fc14f@glory.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-11-2011 22:45, Dmitri Belimov escreveu:
> Hi
> 
> I found why audio dosn't work for me and fix it.
> 
> 2Stefan:
> The V4L2_STD_DK has V4L2_STD_SECAM_DK but not equal 
> switch-case statement not worked
> 
> you can use 
> if (dev->norm & V4L2_STD_DK) { 
> }
> 
> This patch fix this problem.
> 
> Other, please don't remove any workarounds without important reason.
> For your chip revision it can be work but for other audio will be bad.
> 
> I can watch TV but radio not work. After start Gnomeradio I see 
> VIDIOCGAUDIO incorrect
> VIDIOCSAUDIO incorrect
> VIDIOCSFREQ incorrect
> 
> Try found what happens with radio.

This patch has several issues. The usage of switch for video doesn't work
well. A better approach follows. Not tested yet.

PS.: I couldn't test it: not sure why, but the audio source is not working
for me: arecord is not able to read from the device input.


-
[media] tm6000: Fix tm6010 audio standard selection

A V4L2 standards mask may contain several standards. A more restricted
mask with just one standard is used when user needs to bind to an specific
standard that can't be auto-detect among a more generic mask.

So, Improve the autodetection logic to detect the correct audio standard
most of the time.

Based on a patch made by Dmitri Belimov <d.belimov@gmail.com>.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/media/video/tm6000/tm6000-core.c b/drivers/media/video/tm6000/tm6000-core.c
index 9783616..55d097e 100644
--- a/drivers/media/video/tm6000/tm6000-core.c
+++ b/drivers/media/video/tm6000/tm6000-core.c
@@ -696,11 +696,13 @@ int tm6000_set_audio_rinput(struct tm6000_core *dev)
 	if (dev->dev_type == TM6010) {
 		/* Audio crossbar setting, default SIF1 */
 		u8 areg_f0;
+		u8 areg_07 = 0x10;
 
 		switch (dev->rinput.amux) {
 		case TM6000_AMUX_SIF1:
 		case TM6000_AMUX_SIF2:
 			areg_f0 = 0x03;
+			areg_07 = 0x30;
 			break;
 		case TM6000_AMUX_ADC1:
 			areg_f0 = 0x00;
@@ -720,6 +722,9 @@ int tm6000_set_audio_rinput(struct tm6000_core *dev)
 		/* Set audio input crossbar */
 		tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 							areg_f0, 0x0f);
+		/* Mux overflow workaround */
+		tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+			areg_07, 0xf0);
 	} else {
 		u8 areg_eb;
 		/* Audio setting, default LINE1 */
diff --git a/drivers/media/video/tm6000/tm6000-stds.c b/drivers/media/video/tm6000/tm6000-stds.c
index 9a4145d..9dc0831 100644
--- a/drivers/media/video/tm6000/tm6000-stds.c
+++ b/drivers/media/video/tm6000/tm6000-stds.c
@@ -361,82 +361,51 @@ static int tm6000_set_audio_std(struct tm6000_core *dev)
 		return 0;
 	}
 
-	switch (tm6010_a_mode) {
+	/*
+	 * STD/MN shouldn't be affected by tm6010_a_mode, as there's just one
+	 * audio standard for each V4L2_STD type.
+	 */
+	if ((dev->norm & V4L2_STD_NTSC) == V4L2_STD_NTSC_M_KR) {
+		areg_05 |= 0x04;
+	} else if ((dev->norm & V4L2_STD_NTSC) == V4L2_STD_NTSC_M_JP) {
+		areg_05 |= 0x43;
+	} else if (dev->norm & V4L2_STD_MN) {
+		areg_05 |= 0x22;
+	} else switch (tm6010_a_mode) {
 	/* auto */
 	case 0:
-		switch (dev->norm) {
-		case V4L2_STD_NTSC_M_KR:
+		if ((dev->norm & V4L2_STD_SECAM) == V4L2_STD_SECAM_L)
 			areg_05 |= 0x00;
-			break;
-		case V4L2_STD_NTSC_M_JP:
-			areg_05 |= 0x40;
-			break;
-		case V4L2_STD_NTSC_M:
-		case V4L2_STD_PAL_M:
-		case V4L2_STD_PAL_N:
-			areg_05 |= 0x20;
-			break;
-		case V4L2_STD_PAL_Nc:
-			areg_05 |= 0x60;
-			break;
-		case V4L2_STD_SECAM_L:
-			areg_05 |= 0x00;
-			break;
-		case V4L2_STD_DK:
+		else	/* Other PAL/SECAM standards */
 			areg_05 |= 0x10;
-			break;
-		}
 		break;
 	/* A2 */
 	case 1:
-		switch (dev->norm) {
-		case V4L2_STD_B:
-		case V4L2_STD_GH:
-			areg_05 = 0x05;
-			break;
-		case V4L2_STD_DK:
+		if (dev->norm & V4L2_STD_DK)
 			areg_05 = 0x09;
-			break;
-		}
+		else
+			areg_05 = 0x05;
 		break;
 	/* NICAM */
 	case 2:
-		switch (dev->norm) {
-		case V4L2_STD_B:
-		case V4L2_STD_GH:
-			areg_05 = 0x07;
-			break;
-		case V4L2_STD_DK:
+		if (dev->norm & V4L2_STD_DK) {
 			areg_05 = 0x06;
-			break;
-		case V4L2_STD_PAL_I:
+		} else if (dev->norm & V4L2_STD_PAL_I) {
 			areg_05 = 0x08;
-			break;
-		case V4L2_STD_SECAM_L:
+		} else if (dev->norm & V4L2_STD_SECAM_L) {
 			areg_05 = 0x0a;
 			areg_02 = 0x02;
-			break;
+		} else {
+			areg_05 = 0x07;
 		}
 		nicam_flag = 1;
 		break;
 	/* other */
 	case 3:
-		switch (dev->norm) {
-		/* DK3_A2 */
-		case V4L2_STD_DK:
+		if (dev->norm & V4L2_STD_DK) {
 			areg_05 = 0x0b;
-			break;
-		/* Korea */
-		case V4L2_STD_NTSC_M_KR:
-			areg_05 = 0x04;
-			break;
-		/* EIAJ */
-		case V4L2_STD_NTSC_M_JP:
-			areg_05 = 0x03;
-			break;
-		default:
+		} else {
 			areg_05 = 0x02;
-			break;
 		}
 		break;
 	}
@@ -557,10 +526,16 @@ int tm6000_set_standard(struct tm6000_core *dev)
 		case TM6000_AMUX_ADC1:
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x00, 0x0f);
+			/* Mux overflow workaround */
+			tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+				0x10, 0xf0);
 			break;
 		case TM6000_AMUX_ADC2:
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x08, 0x0f);
+			/* Mux overflow workaround */
+			tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+				0x10, 0xf0);
 			break;
 		case TM6000_AMUX_SIF1:
 			reg_08_e2 |= 0x02;
@@ -570,6 +545,9 @@ int tm6000_set_standard(struct tm6000_core *dev)
 			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x02, 0x0f);
+			/* Mux overflow workaround */
+			tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+				0x30, 0xf0);
 			break;
 		case TM6000_AMUX_SIF2:
 			reg_08_e2 |= 0x02;
@@ -579,6 +557,9 @@ int tm6000_set_standard(struct tm6000_core *dev)
 			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf7);
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x02, 0x0f);
+			/* Mux overflow workaround */
+			tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+				0x30, 0xf0);
 			break;
 		default:
 			break;
