Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:37240 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754684Ab2FJBo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:58 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 8/9] tvaudio: support V4L2_TUNER_MODE_LANG1_LANG2
Date: Sun, 10 Jun 2012 03:43:57 +0200
Message-Id: <1339292638-12205-9-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many of the audio decoders handled by the driver support this mode,
so the driver should support it as well.

Coding style errors are done to blend into the surrounding code.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 04ebdfe..f3ce93a 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -334,6 +334,11 @@ static int chip_thread(void *data)
 			else if (mode & V4L2_TUNER_SUB_STEREO)
 				selected = V4L2_TUNER_MODE_STEREO;
 			break;
+		case V4L2_TUNER_MODE_LANG1_LANG2:
+			if (mode & V4L2_TUNER_SUB_LANG2)
+				selected = V4L2_TUNER_MODE_LANG1_LANG2;
+			else if (mode & V4L2_TUNER_SUB_STEREO)
+				selected = V4L2_TUNER_MODE_STEREO;
 		}
 		desc->setmode(chip, selected);
 
@@ -403,6 +408,9 @@ static void tda9840_setmode(struct CHIPSTATE *chip, int mode)
 	case V4L2_TUNER_MODE_LANG2:
 		t |= TDA9840_DUALB;
 		break;
+	case V4L2_TUNER_MODE_LANG1_LANG2:
+		t |= TDA9840_DUALAB;
+		break;
 	default:
 		update = 0;
 	}
@@ -487,6 +495,7 @@ static int tda9840_checkit(struct CHIPSTATE *chip)
 /* 0x06 - C6 - Control 2 in TDA9855, Control 3 in TDA9850 */
 /* Common to TDA9855 and TDA9850: */
 #define TDA985x_SAP	3<<6 /* Selects SAP output, mute if not received */
+#define TDA985x_MONOSAP	2<<6 /* Selects Mono on left, SAP on right */
 #define TDA985x_STEREO	1<<6 /* Selects Stereo ouput, mono if not received */
 #define TDA985x_MONO	0    /* Forces Mono output */
 #define TDA985x_LMU	1<<3 /* Mute (LOR/LOL for 9855, OUTL/OUTR for 9850) */
@@ -554,6 +563,9 @@ static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
 	case V4L2_TUNER_MODE_SAP:
 		c6 |= TDA985x_SAP;
 		break;
+	case V4L2_TUNER_MODE_LANG1_LANG2:
+		c6 |= TDA985x_MONOSAP;
+		break;
 	default:
 		update = 0;
 	}
@@ -601,6 +613,7 @@ static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
 #define TDA9873_TR_REVERSE  ((1 << 3) | (1 << 2))
 #define TDA9873_TR_DUALA    1 << 2
 #define TDA9873_TR_DUALB    1 << 3
+#define TDA9873_TR_DUALAB   0
 
 /* output level controls
  * B5:  output level switch (0 = reduced gain, 1 = normal gain)
@@ -722,6 +735,9 @@ static void tda9873_setmode(struct CHIPSTATE *chip, int mode)
 	case V4L2_TUNER_MODE_LANG2:
 		sw_data |= TDA9873_TR_DUALB;
 		break;
+	case V4L2_TUNER_MODE_LANG1_LANG2:
+		sw_data |= TDA9873_TR_DUALAB;
+		break;
 	default:
 		return;
 	}
@@ -953,6 +969,10 @@ static void tda9874a_setmode(struct CHIPSTATE *chip, int mode)
 			aosr = 0xa0; /* auto-select, dual B/B */
 			mdacosr = (tda9874a_mode) ? 0x83:0x81;
 			break;
+		case V4L2_TUNER_MODE_LANG1_LANG2:
+			aosr = 0x00; /* always route L to L and R to R */
+			mdacosr = (tda9874a_mode) ? 0x82:0x80;
+			break;
 		default:
 			return;
 		}
@@ -987,6 +1007,10 @@ static void tda9874a_setmode(struct CHIPSTATE *chip, int mode)
 			fmmr = 0x02; /* dual */
 			aosr = 0x20; /* dual B/B */
 			break;
+		case V4L2_TUNER_MODE_LANG1_LANG2:
+			fmmr = 0x02; /* dual */
+			aosr = 0x00; /* dual A/B */
+			break;
 		default:
 			return;
 		}
@@ -1251,6 +1275,10 @@ static void tda8425_setmode(struct CHIPSTATE *chip, int mode)
 		s1 |= TDA8425_S1_ML_SOUND_B;
 		s1 |= TDA8425_S1_STEREO_PSEUDO;
 		break;
+	case V4L2_TUNER_MODE_LANG1_LANG2:
+		s1 |= TDA8425_S1_ML_STEREO;
+		s1 |= TDA8425_S1_STEREO_LINEAR;
+		break;
 	case V4L2_TUNER_MODE_MONO:
 		s1 |= TDA8425_S1_ML_STEREO;
 		s1 |= TDA8425_S1_STEREO_MONO;
@@ -1332,6 +1360,7 @@ static audiocmd ta8874z_stereo = { 2, {0, TA8874Z_SEPARATION_DEFAULT}};
 static audiocmd ta8874z_mono = {2, { TA8874Z_MONO_SET, TA8874Z_SEPARATION_DEFAULT}};
 static audiocmd ta8874z_main = {2, { 0, TA8874Z_SEPARATION_DEFAULT}};
 static audiocmd ta8874z_sub = {2, { TA8874Z_MODE_SUB, TA8874Z_SEPARATION_DEFAULT}};
+static audiocmd ta8874z_both = {2, { TA8874Z_MODE_MAIN | TA8874Z_MODE_SUB, TA8874Z_SEPARATION_DEFAULT}};
 
 static void ta8874z_setmode(struct CHIPSTATE *chip, int mode)
 {
@@ -1354,6 +1383,9 @@ static void ta8874z_setmode(struct CHIPSTATE *chip, int mode)
 	case V4L2_TUNER_MODE_LANG2:
 		t = &ta8874z_sub;
 		break;
+	case V4L2_TUNER_MODE_LANG1_LANG2:
+		t = &ta8874z_both;
+		break;
 	default:
 		update = 0;
 	}
@@ -1818,9 +1850,7 @@ static int tvaudio_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	case V4L2_TUNER_MODE_STEREO:
 	case V4L2_TUNER_MODE_LANG1:
 	case V4L2_TUNER_MODE_LANG2:
-		break;
 	case V4L2_TUNER_MODE_LANG1_LANG2:
-		vt->audmode = V4L2_TUNER_MODE_STEREO;
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.0.5

