Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4621 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1FNHO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 09/10] tuner-core: simplify the standard fixup.
Date: Tue, 14 Jun 2011 09:14:41 +0200
Message-Id: <11cb0322047ecff89db7fb7063184128a805dd3d.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Get rid of a number of unnecessary tuner_dbg messages by simplifying
the std fixup function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |   93 +++++++++++--------------------------
 1 files changed, 28 insertions(+), 65 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 8dffe50..9b0d833 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -841,7 +841,8 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 /**
  * tuner_fixup_std - force a given video standard variant
  *
- * @t:	tuner internal struct
+ * @t: tuner internal struct
+ * @std:	TV standard
  *
  * A few devices or drivers have problem to detect some standard variations.
  * On other operational systems, the drivers generally have a per-country
@@ -851,57 +852,39 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
  * to distinguish all video standard variations, a modprobe parameter can
  * be used to force a video standard match.
  */
-static int tuner_fixup_std(struct tuner *t)
+static v4l2_std_id tuner_fixup_std(struct tuner *t, v4l2_std_id std)
 {
-	if ((t->std & V4L2_STD_PAL) == V4L2_STD_PAL) {
+	if (pal[0] != '-' && (std & V4L2_STD_PAL) == V4L2_STD_PAL) {
 		switch (pal[0]) {
 		case '6':
-			tuner_dbg("insmod fixup: PAL => PAL-60\n");
-			t->std = V4L2_STD_PAL_60;
-			break;
+			return V4L2_STD_PAL_60;
 		case 'b':
 		case 'B':
 		case 'g':
 		case 'G':
-			tuner_dbg("insmod fixup: PAL => PAL-BG\n");
-			t->std = V4L2_STD_PAL_BG;
-			break;
+			return V4L2_STD_PAL_BG;
 		case 'i':
 		case 'I':
-			tuner_dbg("insmod fixup: PAL => PAL-I\n");
-			t->std = V4L2_STD_PAL_I;
-			break;
+			return V4L2_STD_PAL_I;
 		case 'd':
 		case 'D':
 		case 'k':
 		case 'K':
-			tuner_dbg("insmod fixup: PAL => PAL-DK\n");
-			t->std = V4L2_STD_PAL_DK;
-			break;
+			return V4L2_STD_PAL_DK;
 		case 'M':
 		case 'm':
-			tuner_dbg("insmod fixup: PAL => PAL-M\n");
-			t->std = V4L2_STD_PAL_M;
-			break;
+			return V4L2_STD_PAL_M;
 		case 'N':
 		case 'n':
-			if (pal[1] == 'c' || pal[1] == 'C') {
-				tuner_dbg("insmod fixup: PAL => PAL-Nc\n");
-				t->std = V4L2_STD_PAL_Nc;
-			} else {
-				tuner_dbg("insmod fixup: PAL => PAL-N\n");
-				t->std = V4L2_STD_PAL_N;
-			}
-			break;
-		case '-':
-			/* default parameter, do nothing */
-			break;
+			if (pal[1] == 'c' || pal[1] == 'C')
+				return V4L2_STD_PAL_Nc;
+			return V4L2_STD_PAL_N;
 		default:
 			tuner_warn("pal= argument not recognised\n");
 			break;
 		}
 	}
-	if ((t->std & V4L2_STD_SECAM) == V4L2_STD_SECAM) {
+	if (secam[0] != '-' && (std & V4L2_STD_SECAM) == V4L2_STD_SECAM) {
 		switch (secam[0]) {
 		case 'b':
 		case 'B':
@@ -909,63 +892,42 @@ static int tuner_fixup_std(struct tuner *t)
 		case 'G':
 		case 'h':
 		case 'H':
-			tuner_dbg("insmod fixup: SECAM => SECAM-BGH\n");
-			t->std = V4L2_STD_SECAM_B |
-				 V4L2_STD_SECAM_G |
-				 V4L2_STD_SECAM_H;
-			break;
+			return V4L2_STD_SECAM_B |
+			       V4L2_STD_SECAM_G |
+			       V4L2_STD_SECAM_H;
 		case 'd':
 		case 'D':
 		case 'k':
 		case 'K':
-			tuner_dbg("insmod fixup: SECAM => SECAM-DK\n");
-			t->std = V4L2_STD_SECAM_DK;
-			break;
+			return V4L2_STD_SECAM_DK;
 		case 'l':
 		case 'L':
-			if ((secam[1] == 'C') || (secam[1] == 'c')) {
-				tuner_dbg("insmod fixup: SECAM => SECAM-L'\n");
-				t->std = V4L2_STD_SECAM_LC;
-			} else {
-				tuner_dbg("insmod fixup: SECAM => SECAM-L\n");
-				t->std = V4L2_STD_SECAM_L;
-			}
-			break;
-		case '-':
-			/* default parameter, do nothing */
-			break;
+			if ((secam[1] == 'C') || (secam[1] == 'c'))
+				return V4L2_STD_SECAM_LC;
+			return V4L2_STD_SECAM_L;
 		default:
 			tuner_warn("secam= argument not recognised\n");
 			break;
 		}
 	}
 
-	if ((t->std & V4L2_STD_NTSC) == V4L2_STD_NTSC) {
+	if (ntsc[0] != '-' && (std & V4L2_STD_NTSC) == V4L2_STD_NTSC) {
 		switch (ntsc[0]) {
 		case 'm':
 		case 'M':
-			tuner_dbg("insmod fixup: NTSC => NTSC-M\n");
-			t->std = V4L2_STD_NTSC_M;
-			break;
+			return V4L2_STD_NTSC_M;
 		case 'j':
 		case 'J':
-			tuner_dbg("insmod fixup: NTSC => NTSC_M_JP\n");
-			t->std = V4L2_STD_NTSC_M_JP;
-			break;
+			return V4L2_STD_NTSC_M_JP;
 		case 'k':
 		case 'K':
-			tuner_dbg("insmod fixup: NTSC => NTSC_M_KR\n");
-			t->std = V4L2_STD_NTSC_M_KR;
-			break;
-		case '-':
-			/* default parameter, do nothing */
-			break;
+			return V4L2_STD_NTSC_M_KR;
 		default:
 			tuner_info("ntsc= argument not recognised\n");
 			break;
 		}
 	}
-	return 0;
+	return std;
 }
 
 /*
@@ -1120,8 +1082,9 @@ static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	if (set_mode(t, V4L2_TUNER_ANALOG_TV))
 		return 0;
 
-	t->std = std;
-	tuner_fixup_std(t);
+	t->std = tuner_fixup_std(t, std);
+	if (t->std != std)
+		tuner_dbg("Fixup standard %llx to %llx\n", std, t->std);
 	set_freq(t, 0);
 	return 0;
 }
-- 
1.7.1

