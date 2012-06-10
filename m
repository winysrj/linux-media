Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:52080 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754812Ab2FJBo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:58 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 9/9] tvaudio: don't report mono when stereo is received
Date: Sun, 10 Jun 2012 03:43:58 +0200
Message-Id: <1339292638-12205-10-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 spec says reporting mono and stereo at the same time means
the hardware can not distinguish between the two. So when we can,
we should report only one of them.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index f3ce93a..1e61cbf 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -383,7 +383,7 @@ static int tda9840_getmode(struct CHIPSTATE *chip)
 	if (val & TDA9840_DS_DUAL)
 		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	if (val & TDA9840_ST_STEREO)
-		mode |= V4L2_TUNER_SUB_STEREO;
+		mode = V4L2_TUNER_SUB_STEREO;
 
 	v4l2_dbg(1, debug, sd, "tda9840_getmode(): raw chip read: %d, return: %d\n",
 		val, mode);
@@ -541,7 +541,7 @@ static int  tda985x_getmode(struct CHIPSTATE *chip)
 	mode = V4L2_TUNER_SUB_MONO;
 	val = chip_read(chip);
 	if (val & TDA985x_STP)
-		mode |= V4L2_TUNER_SUB_STEREO;
+		mode = V4L2_TUNER_SUB_STEREO;
 	if (val & TDA985x_SAPP)
 		mode |= V4L2_TUNER_SUB_SAP;
 	return mode;
@@ -700,7 +700,7 @@ static int tda9873_getmode(struct CHIPSTATE *chip)
 	val = chip_read(chip);
 	mode = V4L2_TUNER_SUB_MONO;
 	if (val & TDA9873_STEREO)
-		mode |= V4L2_TUNER_SUB_STEREO;
+		mode = V4L2_TUNER_SUB_STEREO;
 	if (val & TDA9873_DUAL)
 		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	v4l2_dbg(1, debug, sd, "tda9873_getmode(): raw chip read: %d, return: %d\n",
@@ -918,12 +918,12 @@ static int tda9874a_getmode(struct CHIPSTATE *chip)
 		 * external 4052 multiplexer in audio_hook().
 		 */
 		if(nsr & 0x02) /* NSR.S/MB=1 */
-			mode |= V4L2_TUNER_SUB_STEREO;
+			mode = V4L2_TUNER_SUB_STEREO;
 		if(nsr & 0x01) /* NSR.D/SB=1 */
 			mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	} else {
 		if(dsr & 0x02) /* DSR.IDSTE=1 */
-			mode |= V4L2_TUNER_SUB_STEREO;
+			mode = V4L2_TUNER_SUB_STEREO;
 		if(dsr & 0x04) /* DSR.IDDUA=1 */
 			mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	}
@@ -1350,7 +1350,7 @@ static int ta8874z_getmode(struct CHIPSTATE *chip)
 	if (val & TA8874Z_B1){
 		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	}else if (!(val & TA8874Z_B0)){
-		mode |= V4L2_TUNER_SUB_STEREO;
+		mode = V4L2_TUNER_SUB_STEREO;
 	}
 	/* v4l_dbg(1, debug, chip->c, "ta8874z_getmode(): raw chip read: 0x%02x, return: 0x%02x\n", val, mode); */
 	return mode;
-- 
1.7.0.5

