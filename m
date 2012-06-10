Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46644 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754542Ab2FJBoz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:55 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 2/9] tvaudio: fix tda8425_setmode
Date: Sun, 10 Jun 2012 03:43:51 +0200
Message-Id: <1339292638-12205-3-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The passed audio mode is not a bitfield.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 9b85e2a..76a8cbe 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1230,21 +1230,25 @@ static void tda8425_setmode(struct CHIPSTATE *chip, int mode)
 {
 	int s1 = chip->shadow.bytes[TDA8425_S1+1] & 0xe1;
 
-	if (mode & V4L2_TUNER_MODE_LANG1) {
+	switch (mode) {
+	case V4L2_TUNER_MODE_LANG1:
 		s1 |= TDA8425_S1_ML_SOUND_A;
 		s1 |= TDA8425_S1_STEREO_PSEUDO;
-
-	} else if (mode & V4L2_TUNER_MODE_LANG2) {
+		break;
+	case V4L2_TUNER_MODE_LANG2:
 		s1 |= TDA8425_S1_ML_SOUND_B;
 		s1 |= TDA8425_S1_STEREO_PSEUDO;
-
-	} else {
+		break;
+	case V4L2_TUNER_MODE_MONO:
 		s1 |= TDA8425_S1_ML_STEREO;
-
-		if (mode & V4L2_TUNER_MODE_MONO)
-			s1 |= TDA8425_S1_STEREO_MONO;
-		if (mode & V4L2_TUNER_MODE_STEREO)
-			s1 |= TDA8425_S1_STEREO_SPATIAL;
+		s1 |= TDA8425_S1_STEREO_MONO;
+		break;
+	case V4L2_TUNER_MODE_STEREO:
+		s1 |= TDA8425_S1_ML_STEREO;
+		s1 |= TDA8425_S1_STEREO_SPATIAL;
+		break;
+	default:
+		return;
 	}
 	chip_write(chip,TDA8425_S1,s1);
 }
-- 
1.7.0.5

