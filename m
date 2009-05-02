Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3057 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZEBP1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 11:27:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] tvaudio.c audmode/rxsubchans fixes
Date: Sat, 2 May 2009 17:26:50 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6YG/JqnifB9E5GN"
Message-Id: <200905021726.50363.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_6YG/JqnifB9E5GN
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Mauro,

Attached is my untested tvaudio.c patch fixing the audmode/rxsubchans 
processing in tvaudio.c.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

It needs to be tested/reviewed, and bttv-audio-hook.c should also be fixed 
as that contains the same type of errors.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

--Boundary-00=_6YG/JqnifB9E5GN
Content-Type: text/x-diff;
  charset="utf-8";
  name="tvaudio.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="tvaudio.diff"

diff -r 5803e938c67e linux/drivers/media/video/tvaudio.c
--- a/linux/drivers/media/video/tvaudio.c	Sat May 02 16:10:23 2009 +0200
+++ b/linux/drivers/media/video/tvaudio.c	Sat May 02 16:44:46 2009 +0200
@@ -63,7 +63,7 @@
 typedef int  (*getvalue)(int);
 typedef int  (*checkit)(struct CHIPSTATE*);
 typedef int  (*initialize)(struct CHIPSTATE*);
-typedef int  (*getmode)(struct CHIPSTATE*);
+typedef int  (*getsubs)(struct CHIPSTATE*);
 typedef void (*setmode)(struct CHIPSTATE*, int mode);
 
 /* i2c command */
@@ -99,8 +99,9 @@
 	/* functions to convert the values (v4l -> chip) */
 	getvalue volfunc,treblefunc,bassfunc;
 
-	/* get/set mode */
-	getmode  getmode;
+	/* get subchans */
+	getsubs  getsubs;
+	/* set mode */
 	setmode  setmode;
 
 	/* input switch register + values for v4l inputs */
@@ -123,7 +124,7 @@
 
 	/* current settings */
 	__u16 left,right,treble,bass,muted,mode;
-	int prevmode;
+	int prevsubs;
 	int radio;
 	int input;
 
@@ -308,7 +309,7 @@
 	struct CHIPSTATE *chip = data;
 	struct CHIPDESC  *desc = chip->desc;
 	struct v4l2_subdev *sd = &chip->sd;
-	int mode;
+	int subs;
 
 	v4l2_dbg(1, debug, sd, "thread started\n");
 	set_freezable();
@@ -327,23 +328,19 @@
 			continue;
 
 		/* have a look what's going on */
-		mode = desc->getmode(chip);
-		if (mode == chip->prevmode)
+		subs = desc->getsubs(chip);
+		if (subs == chip->prevsubs)
 			continue;
 
 		/* chip detected a new audio mode - set it */
 		v4l2_dbg(1, debug, sd, "thread checkmode\n");
 
-		chip->prevmode = mode;
+		chip->prevsubs = subs;
 
-		if (mode & V4L2_TUNER_MODE_STEREO)
+		if (subs & (V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2))
+			desc->setmode(chip, V4L2_TUNER_MODE_LANG1);
+		else if (subs & V4L2_TUNER_SUB_STEREO)
 			desc->setmode(chip, V4L2_TUNER_MODE_STEREO);
-		if (mode & V4L2_TUNER_MODE_LANG1_LANG2)
-			desc->setmode(chip, V4L2_TUNER_MODE_STEREO);
-		else if (mode & V4L2_TUNER_MODE_LANG1)
-			desc->setmode(chip, V4L2_TUNER_MODE_LANG1);
-		else if (mode & V4L2_TUNER_MODE_LANG2)
-			desc->setmode(chip, V4L2_TUNER_MODE_LANG2);
 		else
 			desc->setmode(chip, V4L2_TUNER_MODE_MONO);
 
@@ -378,19 +375,18 @@
 #define TDA9840_TEST_INT1SN 0x1 /* Integration time 0.5s when set */
 #define TDA9840_TEST_INTFU 0x02 /* Disables integrator function */
 
-static int tda9840_getmode(struct CHIPSTATE *chip)
+static int tda9840_getsubs(struct CHIPSTATE *chip)
 {
 	struct v4l2_subdev *sd = &chip->sd;
-	int val, mode;
+	int val, mode = V4L2_TUNER_SUB_MONO;
 
 	val = chip_read(chip);
-	mode = V4L2_TUNER_MODE_MONO;
 	if (val & TDA9840_DS_DUAL)
-		mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	if (val & TDA9840_ST_STEREO)
-		mode |= V4L2_TUNER_MODE_STEREO;
+		mode |= V4L2_TUNER_SUB_STEREO;
 
-	v4l2_dbg(1, debug, sd, "tda9840_getmode(): raw chip read: %d, return: %d\n",
+	v4l2_dbg(1, debug, sd, "tda9840_getsubs(): raw chip read: %d, return: %d\n",
 		val, mode);
 	return mode;
 }
@@ -533,15 +529,16 @@
 static int tda9855_bass(int val)   { return val/0xccc+0x06; }
 static int tda9855_treble(int val) { return (val/0x1c71+0x3)<<1; }
 
-static int  tda985x_getmode(struct CHIPSTATE *chip)
+static int  tda985x_getsubs(struct CHIPSTATE *chip)
 {
-	int mode;
+	int mode = V4L2_TUNER_SUB_MONO;
+	int val = chip_read(chip);
 
-	mode = ((TDA985x_STP | TDA985x_SAPP) &
-		chip_read(chip)) >> 4;
-	/* Add mono mode regardless of SAP and stereo */
-	/* Allows forced mono */
-	return mode | V4L2_TUNER_MODE_MONO;
+	if (val & TDA985x_STP)
+		mode |= V4L2_TUNER_SUB_STEREO;
+	if (val & TDA985x_SAPP)
+		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
+	return mode;
 }
 
 static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
@@ -684,18 +681,18 @@
 #define TDA9873_STEREO      2 /* Stereo sound is identified     */
 #define TDA9873_DUAL        4 /* Dual sound is identified       */
 
-static int tda9873_getmode(struct CHIPSTATE *chip)
+static int tda9873_getsubs(struct CHIPSTATE *chip)
 {
 	struct v4l2_subdev *sd = &chip->sd;
 	int val,mode;
 
 	val = chip_read(chip);
-	mode = V4L2_TUNER_MODE_MONO;
+	mode = V4L2_TUNER_SUB_MONO;
 	if (val & TDA9873_STEREO)
-		mode |= V4L2_TUNER_MODE_STEREO;
+		mode |= V4L2_TUNER_SUB_STEREO;
 	if (val & TDA9873_DUAL)
-		mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
-	v4l2_dbg(1, debug, sd, "tda9873_getmode(): raw chip read: %d, return: %d\n",
+		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
+	v4l2_dbg(1, debug, sd, "tda9873_getsubs(): raw chip read: %d, return: %d\n",
 		val, mode);
 	return mode;
 }
@@ -879,13 +876,13 @@
 	return 1;
 }
 
-static int tda9874a_getmode(struct CHIPSTATE *chip)
+static int tda9874a_getsubs(struct CHIPSTATE *chip)
 {
 	struct v4l2_subdev *sd = &chip->sd;
 	int dsr,nsr,mode;
 	int necr; /* just for debugging */
 
-	mode = V4L2_TUNER_MODE_MONO;
+	mode = V4L2_TUNER_SUB_MONO;
 
 	if(-1 == (dsr = chip_read2(chip,TDA9874A_DSR)))
 		return mode;
@@ -909,21 +906,21 @@
 		 */
 #if 0
 		if((nsr & 0x02) && !(dsr & 0x10)) /* NSR.S/MB=1 and DSR.AMSTAT=0 */
-			mode |= V4L2_TUNER_MODE_STEREO;
+			mode |= V4L2_TUNER_SUB_STEREO;
 #else
 		if(nsr & 0x02) /* NSR.S/MB=1 */
-			mode |= V4L2_TUNER_MODE_STEREO;
+			mode |= V4L2_TUNER_SUB_STEREO;
 #endif
 		if(nsr & 0x01) /* NSR.D/SB=1 */
-			mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+			mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	} else {
 		if(dsr & 0x02) /* DSR.IDSTE=1 */
-			mode |= V4L2_TUNER_MODE_STEREO;
+			mode |= V4L2_TUNER_SUB_STEREO;
 		if(dsr & 0x04) /* DSR.IDDUA=1 */
-			mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+			mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	}
 
-	v4l2_dbg(1, debug, sd, "tda9874a_getmode(): DSR=0x%X, NSR=0x%X, NECR=0x%X, return: %d.\n",
+	v4l2_dbg(1, debug, sd, "tda9874a_getsubs(): DSR=0x%X, NSR=0x%X, NECR=0x%X, return: %d.\n",
 		 dsr, nsr, necr, mode);
 	return mode;
 }
@@ -1267,21 +1264,29 @@
 {
 	int s1 = chip->shadow.bytes[TDA8425_S1+1] & 0xe1;
 
-	if (mode & V4L2_TUNER_MODE_LANG1) {
+	switch (mode) {
+	case V4L2_TUNER_MODE_LANG1:
 		s1 |= TDA8425_S1_ML_SOUND_A;
 		s1 |= TDA8425_S1_STEREO_PSEUDO;
+		break;
 
-	} else if (mode & V4L2_TUNER_MODE_LANG2) {
+	case V4L2_TUNER_MODE_LANG2:
 		s1 |= TDA8425_S1_ML_SOUND_B;
 		s1 |= TDA8425_S1_STEREO_PSEUDO;
+		break;
 
-	} else {
+	case V4L2_TUNER_MODE_MONO:
 		s1 |= TDA8425_S1_ML_STEREO;
+		s1 |= TDA8425_S1_STEREO_MONO;
+		break;
 
-		if (mode & V4L2_TUNER_MODE_MONO)
-			s1 |= TDA8425_S1_STEREO_MONO;
-		if (mode & V4L2_TUNER_MODE_STEREO)
-			s1 |= TDA8425_S1_STEREO_SPATIAL;
+	case V4L2_TUNER_MODE_STEREO:
+		s1 |= TDA8425_S1_ML_STEREO;
+		s1 |= TDA8425_S1_STEREO_SPATIAL;
+		break;
+	
+	default:
+		return;
 	}
 	chip_write(chip,TDA8425_S1,s1);
 }
@@ -1334,18 +1339,18 @@
  * stereo  L  L
  * BIL     H  L
  */
-static int ta8874z_getmode(struct CHIPSTATE *chip)
+static int ta8874z_getsubs(struct CHIPSTATE *chip)
 {
 	int val, mode;
 
 	val = chip_read(chip);
-	mode = V4L2_TUNER_MODE_MONO;
+	mode = V4L2_TUNER_SUB_MONO;
 	if (val & TA8874Z_B1){
-		mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	}else if (!(val & TA8874Z_B0)){
-		mode |= V4L2_TUNER_MODE_STEREO;
+		mode |= V4L2_TUNER_SUB_STEREO;
 	}
-	/* v4l_dbg(1, debug, chip->c, "ta8874z_getmode(): raw chip read: 0x%02x, return: 0x%02x\n", val, mode); */
+	/* v4l_dbg(1, debug, chip->c, "ta8874z_getsubs(): raw chip read: 0x%02x, return: 0x%02x\n", val, mode); */
 	return mode;
 }
 
@@ -1431,7 +1436,7 @@
 
 		/* callbacks */
 		.checkit    = tda9840_checkit,
-		.getmode    = tda9840_getmode,
+		.getsubs    = tda9840_getsubs,
 		.setmode    = tda9840_setmode,
 
 		.init       = { 2, { TDA9840_TEST, TDA9840_TEST_INT1SN
@@ -1447,7 +1452,7 @@
 
 		/* callbacks */
 		.checkit    = tda9873_checkit,
-		.getmode    = tda9873_getmode,
+		.getsubs    = tda9873_getsubs,
 		.setmode    = tda9873_setmode,
 
 		.init       = { 4, { TDA9873_SW, 0xa4, 0x06, 0x03 } },
@@ -1467,7 +1472,7 @@
 		/* callbacks */
 		.initialize = tda9874a_initialize,
 		.checkit    = tda9874a_checkit,
-		.getmode    = tda9874a_getmode,
+		.getsubs    = tda9874a_getsubs,
 		.setmode    = tda9874a_setmode,
 	},
 	{
@@ -1497,7 +1502,7 @@
 		.addr_hi    = I2C_ADDR_TDA985x_H >> 1,
 		.registers  = 11,
 
-		.getmode    = tda985x_getmode,
+		.getsubs    = tda985x_getsubs,
 		.setmode    = tda985x_setmode,
 
 		.init       = { 8, { TDA9850_C4, 0x08, 0x08, TDA985x_STEREO, 0x07, 0x10, 0x10, 0x03 } }
@@ -1519,7 +1524,7 @@
 		.volfunc    = tda9855_volume,
 		.bassfunc   = tda9855_bass,
 		.treblefunc = tda9855_treble,
-		.getmode    = tda985x_getmode,
+		.getsubs    = tda985x_getsubs,
 		.setmode    = tda985x_setmode,
 
 		.init       = { 12, { 0, 0x6f, 0x6f, 0x0e, 0x07<<1, 0x8<<2,
@@ -1634,7 +1639,7 @@
 		.flags      = CHIP_NEED_CHECKMODE,
 
 		/* callbacks */
-		.getmode    = ta8874z_getmode,
+		.getsubs    = ta8874z_getsubs,
 		.setmode    = ta8874z_setmode,
 
 		.init       = {2, { TA8874Z_MONO_SET, TA8874Z_SEPARATION_DEFAULT}},
@@ -1863,9 +1868,8 @@
 {
 	struct CHIPSTATE *chip = to_state(sd);
 	struct CHIPDESC *desc = chip->desc;
-	int mode = V4L2_TUNER_MODE_MONO;
 
-	if (!desc->getmode)
+	if (!desc->getsubs)
 		return 0;
 	if (chip->radio)
 		return 0;
@@ -1875,18 +1879,8 @@
 	vt->capability = V4L2_TUNER_CAP_STEREO |
 		V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2;
 
-	mode = desc->getmode(chip);
+	vt->rxsubchans = desc->getsubs(chip);
 
-	if (mode & V4L2_TUNER_MODE_MONO)
-		vt->rxsubchans |= V4L2_TUNER_SUB_MONO;
-	if (mode & V4L2_TUNER_MODE_STEREO)
-		vt->rxsubchans |= V4L2_TUNER_SUB_STEREO;
-	/* Note: for SAP it should be mono/lang2 or stereo/lang2.
-	   When this module is converted fully to v4l2, then this
-	   should change for those chips that can detect SAP. */
-	if (mode & V4L2_TUNER_MODE_LANG1)
-		vt->rxsubchans = V4L2_TUNER_SUB_LANG1 |
-			V4L2_TUNER_SUB_LANG2;
 	return 0;
 }
 
@@ -1905,7 +1899,7 @@
 
 	chip->mode = 0; /* automatic */
 
-	/* For chips that provide getmode and setmode, and doesn't
+	/* For chips that provide getsubs and setmode, and doesn't
 	   automatically follows the stereo carrier, a kthread is
 	   created to set the audio standard. In this case, when then
 	   the video channel is changed, tvaudio starts on MONO mode.
@@ -1915,8 +1909,8 @@
 	 */
 	if (chip->thread) {
 		desc->setmode(chip, V4L2_TUNER_MODE_MONO);
-		if (chip->prevmode != V4L2_TUNER_MODE_MONO)
-			chip->prevmode = -1; /* reset previous mode */
+		if (chip->prevsubs != V4L2_TUNER_MODE_MONO)
+			chip->prevsubs = 0; /* reset previous mode */
 		mod_timer(&chip->wt, jiffies+msecs_to_jiffies(2000));
 	}
 	return 0;
@@ -2015,7 +2009,7 @@
 #endif
 	chip->desc = desc;
 	chip->shadow.count = desc->registers+1;
-	chip->prevmode = -1;
+	chip->prevsubs = 0;
 	chip->audmode = V4L2_TUNER_MODE_LANG1;
 
 	/* initialization  */
@@ -2062,7 +2056,7 @@
 	chip->thread = NULL;
 	init_timer(&chip->wt);
 	if (desc->flags & CHIP_NEED_CHECKMODE) {
-		if (!desc->getmode || !desc->setmode) {
+		if (!desc->getsubs || !desc->setmode) {
 			/* This shouldn't be happen. Warn user, but keep working
 			   without kthread
 			 */

--Boundary-00=_6YG/JqnifB9E5GN--
