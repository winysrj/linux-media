Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:52868 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754626Ab2FJBo5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:57 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 6/9] tvaudio: use V4L2_TUNER_SUB_* for bitfields
Date: Sun, 10 Jun 2012 03:43:55 +0200
Message-Id: <1339292638-12205-7-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_TUNER_MODE_* constants are not suited for use in bitfields.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |   63 +++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 0e77d49..58a0e9c 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -315,13 +315,13 @@ static int chip_thread(void *data)
 
 		chip->prevmode = mode;
 
-		if (mode & V4L2_TUNER_MODE_STEREO)
+		if (mode & V4L2_TUNER_SUB_STEREO)
 			desc->setmode(chip, V4L2_TUNER_MODE_STEREO);
-		if (mode & V4L2_TUNER_MODE_LANG1_LANG2)
+		if (mode & V4L2_TUNER_SUB_LANG1_LANG2)
 			desc->setmode(chip, V4L2_TUNER_MODE_STEREO);
-		else if (mode & V4L2_TUNER_MODE_LANG1)
+		else if (mode & V4L2_SUB_MODE_LANG1)
 			desc->setmode(chip, V4L2_TUNER_MODE_LANG1);
-		else if (mode & V4L2_TUNER_MODE_LANG2)
+		else if (mode & V4L2_SUB_MODE_LANG2)
 			desc->setmode(chip, V4L2_TUNER_MODE_LANG2);
 		else
 			desc->setmode(chip, V4L2_TUNER_MODE_MONO);
@@ -363,11 +363,11 @@ static int tda9840_getmode(struct CHIPSTATE *chip)
 	int val, mode;
 
 	val = chip_read(chip);
-	mode = V4L2_TUNER_MODE_MONO;
+	mode = V4L2_TUNER_SUB_MONO;
 	if (val & TDA9840_DS_DUAL)
-		mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	if (val & TDA9840_ST_STEREO)
-		mode |= V4L2_TUNER_MODE_STEREO;
+		mode |= V4L2_TUNER_SUB_STEREO;
 
 	v4l2_dbg(1, debug, sd, "tda9840_getmode(): raw chip read: %d, return: %d\n",
 		val, mode);
@@ -514,13 +514,17 @@ static int tda9855_treble(int val) { return (val/0x1c71+0x3)<<1; }
 
 static int  tda985x_getmode(struct CHIPSTATE *chip)
 {
-	int mode;
+	int mode, val;
 
-	mode = ((TDA985x_STP | TDA985x_SAPP) &
-		chip_read(chip)) >> 4;
 	/* Add mono mode regardless of SAP and stereo */
 	/* Allows forced mono */
-	return mode | V4L2_TUNER_MODE_MONO;
+	mode = V4L2_TUNER_SUB_MONO;
+	val = chip_read(chip);
+	if (val & TDA985x_STP)
+		mode |= V4L2_TUNER_SUB_STEREO;
+	if (val & TDA985x_SAPP)
+		mode |= V4L2_TUNER_SUB_SAP;
+	return mode;
 }
 
 static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
@@ -670,11 +674,11 @@ static int tda9873_getmode(struct CHIPSTATE *chip)
 	int val,mode;
 
 	val = chip_read(chip);
-	mode = V4L2_TUNER_MODE_MONO;
+	mode = V4L2_TUNER_SUB_MONO;
 	if (val & TDA9873_STEREO)
-		mode |= V4L2_TUNER_MODE_STEREO;
+		mode |= V4L2_TUNER_SUB_STEREO;
 	if (val & TDA9873_DUAL)
-		mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	v4l2_dbg(1, debug, sd, "tda9873_getmode(): raw chip read: %d, return: %d\n",
 		val, mode);
 	return mode;
@@ -865,7 +869,7 @@ static int tda9874a_getmode(struct CHIPSTATE *chip)
 	int dsr,nsr,mode;
 	int necr; /* just for debugging */
 
-	mode = V4L2_TUNER_MODE_MONO;
+	mode = V4L2_TUNER_SUB_MONO;
 
 	if(-1 == (dsr = chip_read2(chip,TDA9874A_DSR)))
 		return mode;
@@ -888,14 +892,14 @@ static int tda9874a_getmode(struct CHIPSTATE *chip)
 		 * external 4052 multiplexer in audio_hook().
 		 */
 		if(nsr & 0x02) /* NSR.S/MB=1 */
-			mode |= V4L2_TUNER_MODE_STEREO;
+			mode |= V4L2_TUNER_SUB_STEREO;
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
 
 	v4l2_dbg(1, debug, sd, "tda9874a_getmode(): DSR=0x%X, NSR=0x%X, NECR=0x%X, return: %d.\n",
@@ -1306,11 +1310,11 @@ static int ta8874z_getmode(struct CHIPSTATE *chip)
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
 	/* v4l_dbg(1, debug, chip->c, "ta8874z_getmode(): raw chip read: 0x%02x, return: 0x%02x\n", val, mode); */
 	return mode;
@@ -1829,7 +1833,6 @@ static int tvaudio_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 {
 	struct CHIPSTATE *chip = to_state(sd);
 	struct CHIPDESC *desc = chip->desc;
-	int mode = V4L2_TUNER_MODE_MONO;
 
 	if (!desc->getmode)
 		return 0;
@@ -1837,22 +1840,10 @@ static int tvaudio_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 		return 0;
 
 	vt->audmode = chip->audmode;
-	vt->rxsubchans = 0;
+	vt->rxsubchans = desc->getmode(chip);
 	vt->capability = V4L2_TUNER_CAP_STEREO |
 		V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2;
 
-	mode = desc->getmode(chip);
-
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
 
-- 
1.7.0.5

