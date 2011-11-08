Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41856 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1KHApI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 19:45:08 -0500
Received: by wwi36 with SMTP id 36so7544915wwi.1
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2011 16:45:06 -0800 (PST)
Date: Tue, 8 Nov 2011 10:45:00 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [PATCH] Fix tm6010 audio
Message-ID: <20111108104500.2f0fc14f@glory.local>
In-Reply-To: <4E9C65CD.2070409@arcor.de>
References: <4E8C5675.8070604@arcor.de>
	<20111017155537.6c55aec8@glory.local>
	<4E9C65CD.2070409@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/2+M9bqFU9rnUupMViv7Zl4n"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/2+M9bqFU9rnUupMViv7Zl4n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

I found why audio dosn't work for me and fix it.

2Stefan:
The V4L2_STD_DK has V4L2_STD_SECAM_DK but not equal 
switch-case statement not worked

you can use 
if (dev->norm & V4L2_STD_DK) { 
}

This patch fix this problem.

Other, please don't remove any workarounds without important reason.
For your chip revision it can be work but for other audio will be bad.

I can watch TV but radio not work. After start Gnomeradio I see 
VIDIOCGAUDIO incorrect
VIDIOCSAUDIO incorrect
VIDIOCSFREQ incorrect

Try found what happens with radio.

diff -r -U 3 tm6000.old/tm6000-core.c tm6000/tm6000-core.c
--- tm6000.old/tm6000-core.c	2011-08-29 14:16:01.000000000 +1000
+++ tm6000/tm6000-core.c	2011-11-08 02:31:48.000000000 +1000
@@ -640,11 +640,13 @@
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
@@ -664,6 +666,9 @@
 		/* Set audio input crossbar */
 		tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 							areg_f0, 0x0f);
+		/* Mux overflow workaround */
+		tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+			areg_07, 0xf0);
 	} else {
 		u8 areg_eb;
 		/* Audio setting, default LINE1 */
diff -r -U 3 tm6000.old/tm6000-stds.c tm6000/tm6000-stds.c
--- tm6000.old/tm6000-stds.c	2011-08-29 14:16:01.000000000 +1000
+++ tm6000/tm6000-stds.c	2011-11-08 03:04:37.000000000 +1000
@@ -394,7 +394,14 @@
 		case V4L2_STD_SECAM_L:
 			areg_05 |= 0x00;
 			break;
-		case V4L2_STD_DK:
+		case V4L2_STD_SECAM_D:
+		case V4L2_STD_SECAM_K:
+		case V4L2_STD_SECAM_K1:
+		case V4L2_STD_SECAM_DK:
+		case V4L2_STD_PAL_D:
+		case V4L2_STD_PAL_D1:
+		case V4L2_STD_PAL_K:
+		case V4L2_STD_PAL_DK:
 			areg_05 |= 0x10;
 			break;
 		}
@@ -402,11 +409,23 @@
 	/* A2 */
 	case 1:
 		switch (dev->norm) {
-		case V4L2_STD_B:
-		case V4L2_STD_GH:
+		case V4L2_STD_PAL_B:
+		case V4L2_STD_PAL_B1:
+		case V4L2_STD_SECAM_B:
+		case V4L2_STD_PAL_G:
+		case V4L2_STD_PAL_H:
+		case V4L2_STD_SECAM_G:
+		case V4L2_STD_SECAM_H:
 			areg_05 = 0x05;
 			break;
-		case V4L2_STD_DK:
+		case V4L2_STD_SECAM_D:
+		case V4L2_STD_SECAM_K:
+		case V4L2_STD_SECAM_K1:
+		case V4L2_STD_SECAM_DK:
+		case V4L2_STD_PAL_D:
+		case V4L2_STD_PAL_D1:
+		case V4L2_STD_PAL_K:
+		case V4L2_STD_PAL_DK:
 			areg_05 = 0x09;
 			break;
 		}
@@ -414,11 +433,23 @@
 	/* NICAM */
 	case 2:
 		switch (dev->norm) {
-		case V4L2_STD_B:
-		case V4L2_STD_GH:
+		case V4L2_STD_PAL_B:
+		case V4L2_STD_PAL_B1:
+		case V4L2_STD_SECAM_B:
+		case V4L2_STD_PAL_G:
+		case V4L2_STD_PAL_H:
+		case V4L2_STD_SECAM_G:
+		case V4L2_STD_SECAM_H:
 			areg_05 = 0x07;
 			break;
-		case V4L2_STD_DK:
+		case V4L2_STD_SECAM_D:
+		case V4L2_STD_SECAM_K:
+		case V4L2_STD_SECAM_K1:
+		case V4L2_STD_SECAM_DK:
+		case V4L2_STD_PAL_D:
+		case V4L2_STD_PAL_D1:
+		case V4L2_STD_PAL_K:
+		case V4L2_STD_PAL_DK:
 			areg_05 = 0x06;
 			break;
 		case V4L2_STD_PAL_I:
@@ -435,7 +466,14 @@
 	case 3:
 		switch (dev->norm) {
 		/* DK3_A2 */
-		case V4L2_STD_DK:
+		case V4L2_STD_SECAM_D:
+		case V4L2_STD_SECAM_K:
+		case V4L2_STD_SECAM_K1:
+		case V4L2_STD_SECAM_DK:
+		case V4L2_STD_PAL_D:
+		case V4L2_STD_PAL_D1:
+		case V4L2_STD_PAL_K:
+		case V4L2_STD_PAL_DK:
 			areg_05 = 0x0b;
 			break;
 		/* Korea */
@@ -571,10 +609,16 @@
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
@@ -584,6 +628,9 @@
 			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x02, 0x0f);
+			/* Mux overflow workaround */
+			tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+				0x30, 0xf0);
 			break;
 		case TM6000_AMUX_SIF2:
 			reg_08_e2 |= 0x02;
@@ -593,6 +640,9 @@
 			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf7);
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x02, 0x0f);
+			/* Mux overflow workaround */
+			tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+				0x30, 0xf0);
 			break;
 		default:
 			break;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/2+M9bqFU9rnUupMViv7Zl4n
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6010_audio_fix.patch

diff -r -U 3 tm6000.old/tm6000-core.c tm6000/tm6000-core.c
--- tm6000.old/tm6000-core.c	2011-08-29 14:16:01.000000000 +1000
+++ tm6000/tm6000-core.c	2011-11-08 02:31:48.000000000 +1000
@@ -640,11 +640,13 @@
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
@@ -664,6 +666,9 @@
 		/* Set audio input crossbar */
 		tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 							areg_f0, 0x0f);
+		/* Mux overflow workaround */
+		tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+			areg_07, 0xf0);
 	} else {
 		u8 areg_eb;
 		/* Audio setting, default LINE1 */
diff -r -U 3 tm6000.old/tm6000-stds.c tm6000/tm6000-stds.c
--- tm6000.old/tm6000-stds.c	2011-08-29 14:16:01.000000000 +1000
+++ tm6000/tm6000-stds.c	2011-11-08 03:04:37.000000000 +1000
@@ -394,7 +394,14 @@
 		case V4L2_STD_SECAM_L:
 			areg_05 |= 0x00;
 			break;
-		case V4L2_STD_DK:
+		case V4L2_STD_SECAM_D:
+		case V4L2_STD_SECAM_K:
+		case V4L2_STD_SECAM_K1:
+		case V4L2_STD_SECAM_DK:
+		case V4L2_STD_PAL_D:
+		case V4L2_STD_PAL_D1:
+		case V4L2_STD_PAL_K:
+		case V4L2_STD_PAL_DK:
 			areg_05 |= 0x10;
 			break;
 		}
@@ -402,11 +409,23 @@
 	/* A2 */
 	case 1:
 		switch (dev->norm) {
-		case V4L2_STD_B:
-		case V4L2_STD_GH:
+		case V4L2_STD_PAL_B:
+		case V4L2_STD_PAL_B1:
+		case V4L2_STD_SECAM_B:
+		case V4L2_STD_PAL_G:
+		case V4L2_STD_PAL_H:
+		case V4L2_STD_SECAM_G:
+		case V4L2_STD_SECAM_H:
 			areg_05 = 0x05;
 			break;
-		case V4L2_STD_DK:
+		case V4L2_STD_SECAM_D:
+		case V4L2_STD_SECAM_K:
+		case V4L2_STD_SECAM_K1:
+		case V4L2_STD_SECAM_DK:
+		case V4L2_STD_PAL_D:
+		case V4L2_STD_PAL_D1:
+		case V4L2_STD_PAL_K:
+		case V4L2_STD_PAL_DK:
 			areg_05 = 0x09;
 			break;
 		}
@@ -414,11 +433,23 @@
 	/* NICAM */
 	case 2:
 		switch (dev->norm) {
-		case V4L2_STD_B:
-		case V4L2_STD_GH:
+		case V4L2_STD_PAL_B:
+		case V4L2_STD_PAL_B1:
+		case V4L2_STD_SECAM_B:
+		case V4L2_STD_PAL_G:
+		case V4L2_STD_PAL_H:
+		case V4L2_STD_SECAM_G:
+		case V4L2_STD_SECAM_H:
 			areg_05 = 0x07;
 			break;
-		case V4L2_STD_DK:
+		case V4L2_STD_SECAM_D:
+		case V4L2_STD_SECAM_K:
+		case V4L2_STD_SECAM_K1:
+		case V4L2_STD_SECAM_DK:
+		case V4L2_STD_PAL_D:
+		case V4L2_STD_PAL_D1:
+		case V4L2_STD_PAL_K:
+		case V4L2_STD_PAL_DK:
 			areg_05 = 0x06;
 			break;
 		case V4L2_STD_PAL_I:
@@ -435,7 +466,14 @@
 	case 3:
 		switch (dev->norm) {
 		/* DK3_A2 */
-		case V4L2_STD_DK:
+		case V4L2_STD_SECAM_D:
+		case V4L2_STD_SECAM_K:
+		case V4L2_STD_SECAM_K1:
+		case V4L2_STD_SECAM_DK:
+		case V4L2_STD_PAL_D:
+		case V4L2_STD_PAL_D1:
+		case V4L2_STD_PAL_K:
+		case V4L2_STD_PAL_DK:
 			areg_05 = 0x0b;
 			break;
 		/* Korea */
@@ -571,10 +609,16 @@
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
@@ -584,6 +628,9 @@
 			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x02, 0x0f);
+			/* Mux overflow workaround */
+			tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+				0x30, 0xf0);
 			break;
 		case TM6000_AMUX_SIF2:
 			reg_08_e2 |= 0x02;
@@ -593,6 +640,9 @@
 			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf7);
 			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 				0x02, 0x0f);
+			/* Mux overflow workaround */
+			tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
+				0x30, 0xf0);
 			break;
 		default:
 			break;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/2+M9bqFU9rnUupMViv7Zl4n--
