Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab1K1XXk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 18:23:40 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pASNNdrj010224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 18:23:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] [media] tm6000: Fix tm6010 audio standard selection
Date: Mon, 28 Nov 2011 21:23:31 -0200
Message-Id: <1322522611-26392-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1322522611-26392-1-git-send-email-mchehab@redhat.com>
References: <1322522611-26392-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A V4L2 standards mask may contain several standards. A more restricted
mask with just one standard is used when user needs to bind to an specific
standard that can't be auto-detect among a more generic mask.

So, Improve the autodetection logic to detect the correct audio standard
most of the time.

Based on a patch made by Dmitri Belimov <d.belimov@gmail.com>.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-core.c |    5 ++
 drivers/media/video/tm6000/tm6000-stds.c |   89 ++++++++++++------------------
 2 files changed, 40 insertions(+), 54 deletions(-)

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
-- 
1.7.7.3

