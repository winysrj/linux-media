Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46680 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754682Ab2FJBo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:58 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 7/9] tvaudio: obey V4L2 tuner audio matrix
Date: Sun, 10 Jun 2012 03:43:56 +0200
Message-Id: <1339292638-12205-8-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 specifies the audio mode to use for combinations of possible
(rxsubchans) and requested (audmode) audio modes. Up to now tvaudio
has made these decisions automatically based on the possible audio
modes from setting of the frequency until VIDIOC_S_TUNER was called.
It then forced the hardware to use the mode requested by the user.
With this patch it continues to adjust the audio mode while taking
the requested mode into account.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |   61 +++++++++++++++++++++-------------------
 1 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 58a0e9c..04ebdfe 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -118,7 +118,7 @@ struct CHIPSTATE {
 	audiocmd   shadow;
 
 	/* current settings */
-	__u16 left,right,treble,bass,muted,mode;
+	__u16 left, right, treble, bass, muted;
 	int prevmode;
 	int radio;
 	int input;
@@ -287,7 +287,7 @@ static int chip_thread(void *data)
 	struct CHIPSTATE *chip = data;
 	struct CHIPDESC  *desc = chip->desc;
 	struct v4l2_subdev *sd = &chip->sd;
-	int mode;
+	int mode, selected;
 
 	v4l2_dbg(1, debug, sd, "thread started\n");
 	set_freezable();
@@ -301,8 +301,8 @@ static int chip_thread(void *data)
 			break;
 		v4l2_dbg(1, debug, sd, "thread wakeup\n");
 
-		/* don't do anything for radio or if mode != auto */
-		if (chip->radio || chip->mode != 0)
+		/* don't do anything for radio */
+		if (chip->radio)
 			continue;
 
 		/* have a look what's going on */
@@ -315,16 +315,27 @@ static int chip_thread(void *data)
 
 		chip->prevmode = mode;
 
-		if (mode & V4L2_TUNER_SUB_STEREO)
-			desc->setmode(chip, V4L2_TUNER_MODE_STEREO);
-		if (mode & V4L2_TUNER_SUB_LANG1_LANG2)
-			desc->setmode(chip, V4L2_TUNER_MODE_STEREO);
-		else if (mode & V4L2_SUB_MODE_LANG1)
-			desc->setmode(chip, V4L2_TUNER_MODE_LANG1);
-		else if (mode & V4L2_SUB_MODE_LANG2)
-			desc->setmode(chip, V4L2_TUNER_MODE_LANG2);
-		else
-			desc->setmode(chip, V4L2_TUNER_MODE_MONO);
+		selected = V4L2_TUNER_MODE_MONO;
+		switch (chip->audmode) {
+		case V4L2_TUNER_MODE_MONO:
+			if (mode & V4L2_TUNER_SUB_LANG1)
+				selected = V4L2_TUNER_MODE_LANG1;
+			break;
+		case V4L2_TUNER_MODE_STEREO:
+		case V4L2_TUNER_MODE_LANG1:
+			if (mode & V4L2_TUNER_SUB_LANG1)
+				selected = V4L2_TUNER_MODE_LANG1;
+			else if (mode & V4L2_TUNER_SUB_STEREO)
+				selected = V4L2_TUNER_MODE_STEREO;
+			break;
+		case V4L2_TUNER_MODE_LANG2:
+			if (mode & V4L2_TUNER_SUB_LANG2)
+				selected = V4L2_TUNER_MODE_LANG2;
+			else if (mode & V4L2_TUNER_SUB_STEREO)
+				selected = V4L2_TUNER_MODE_STEREO;
+			break;
+		}
+		desc->setmode(chip, selected);
 
 		/* schedule next check */
 		mod_timer(&chip->wt, jiffies+msecs_to_jiffies(2000));
@@ -712,7 +723,6 @@ static void tda9873_setmode(struct CHIPSTATE *chip, int mode)
 		sw_data |= TDA9873_TR_DUALB;
 		break;
 	default:
-		chip->mode = 0;
 		return;
 	}
 
@@ -944,7 +954,6 @@ static void tda9874a_setmode(struct CHIPSTATE *chip, int mode)
 			mdacosr = (tda9874a_mode) ? 0x83:0x81;
 			break;
 		default:
-			chip->mode = 0;
 			return;
 		}
 		chip_write(chip, TDA9874A_AOSR, aosr);
@@ -979,7 +988,6 @@ static void tda9874a_setmode(struct CHIPSTATE *chip, int mode)
 			aosr = 0x20; /* dual B/B */
 			break;
 		default:
-			chip->mode = 0;
 			return;
 		}
 		chip_write(chip, TDA9874A_FMMR, fmmr);
@@ -1799,7 +1807,6 @@ static int tvaudio_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 {
 	struct CHIPSTATE *chip = to_state(sd);
 	struct CHIPDESC *desc = chip->desc;
-	int mode = 0;
 
 	if (!desc->setmode)
 		return 0;
@@ -1811,21 +1818,20 @@ static int tvaudio_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	case V4L2_TUNER_MODE_STEREO:
 	case V4L2_TUNER_MODE_LANG1:
 	case V4L2_TUNER_MODE_LANG2:
-		mode = vt->audmode;
 		break;
 	case V4L2_TUNER_MODE_LANG1_LANG2:
-		mode = V4L2_TUNER_MODE_STEREO;
+		vt->audmode = V4L2_TUNER_MODE_STEREO;
 		break;
 	default:
 		return -EINVAL;
 	}
 	chip->audmode = vt->audmode;
 
-	if (mode) {
-		/* del_timer(&chip->wt); */
-		chip->mode = mode;
-		desc->setmode(chip, mode);
-	}
+	if (chip->thread)
+		wake_up_process(chip->thread);
+	else
+		desc->setmode(chip, vt->audmode);
+
 	return 0;
 }
 
@@ -1860,8 +1866,6 @@ static int tvaudio_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *fr
 	struct CHIPSTATE *chip = to_state(sd);
 	struct CHIPDESC *desc = chip->desc;
 
-	chip->mode = 0; /* automatic */
-
 	/* For chips that provide getmode and setmode, and doesn't
 	   automatically follows the stereo carrier, a kthread is
 	   created to set the audio standard. In this case, when then
@@ -1872,8 +1876,7 @@ static int tvaudio_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *fr
 	 */
 	if (chip->thread) {
 		desc->setmode(chip, V4L2_TUNER_MODE_MONO);
-		if (chip->prevmode != V4L2_TUNER_MODE_MONO)
-			chip->prevmode = -1; /* reset previous mode */
+		chip->prevmode = -1; /* reset previous mode */
 		mod_timer(&chip->wt, jiffies+msecs_to_jiffies(2000));
 	}
 	return 0;
-- 
1.7.0.5

