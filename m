Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3599 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965691Ab3E2LBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv1 12/38] tveeprom: remove v4l2-chip-ident.h include.
Date: Wed, 29 May 2013 12:59:45 +0200
Message-Id: <1369825211-29770-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace the V4L2_IDENT_* usage with tveeprom-specific defines. This header
is deprecated, so those defines shouldn't be used anymore.

The em28xx driver is the only one that uses the tveeprom audio_processor
field, so that has been updated to use the new tveeprom AUDPROC define.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tveeprom.c         |  142 ++++++++++++++-----------------
 drivers/media/usb/em28xx/em28xx-cards.c |    3 +-
 include/media/tveeprom.h                |   11 +++
 3 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/drivers/media/common/tveeprom.c b/drivers/media/common/tveeprom.c
index cc1e172..c7dace6 100644
--- a/drivers/media/common/tveeprom.c
+++ b/drivers/media/common/tveeprom.c
@@ -40,7 +40,6 @@
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_DESCRIPTION("i2c Hauppauge eeprom decoder driver");
 MODULE_AUTHOR("John Klar");
@@ -67,13 +66,10 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
  * The Hauppauge eeprom uses an 8bit field to determine which
  * tuner formats the tuner supports.
  */
-static struct HAUPPAUGE_TUNER_FMT
-{
+static const struct {
 	int	id;
-	char *name;
-}
-hauppauge_tuner_fmt[] =
-{
+	const char * const name;
+} hauppauge_tuner_fmt[] = {
 	{ V4L2_STD_UNKNOWN,                   " UNKNOWN" },
 	{ V4L2_STD_UNKNOWN,                   " FM" },
 	{ V4L2_STD_B|V4L2_STD_GH,             " PAL(B/G)" },
@@ -88,13 +84,10 @@ hauppauge_tuner_fmt[] =
    supplying this information. Note that many tuners where only used for
    testing and never made it to the outside world. So you will only see
    a subset in actual produced cards. */
-static struct HAUPPAUGE_TUNER
-{
+static const struct {
 	int  id;
-	char *name;
-}
-hauppauge_tuner[] =
-{
+	const char * const name;
+} hauppauge_tuner[] = {
 	/* 0-9 */
 	{ TUNER_ABSENT,			"None" },
 	{ TUNER_ABSENT,			"External" },
@@ -298,69 +291,66 @@ hauppauge_tuner[] =
 	{ TUNER_ABSENT,                 "NXP 18272S"},
 };
 
-/* Use V4L2_IDENT_AMBIGUOUS for those audio 'chips' that are
+/* Use TVEEPROM_AUDPROC_INTERNAL for those audio 'chips' that are
  * internal to a video chip, i.e. not a separate audio chip. */
-static struct HAUPPAUGE_AUDIOIC
-{
+static const struct {
 	u32   id;
-	char *name;
-}
-audioIC[] =
-{
+	const char * const name;
+} audio_ic[] = {
 	/* 0-4 */
-	{ V4L2_IDENT_NONE,      "None"      },
-	{ V4L2_IDENT_UNKNOWN,   "TEA6300"   },
-	{ V4L2_IDENT_UNKNOWN,   "TEA6320"   },
-	{ V4L2_IDENT_UNKNOWN,   "TDA9850"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3400C"  },
+	{ TVEEPROM_AUDPROC_NONE,  "None"      },
+	{ TVEEPROM_AUDPROC_OTHER, "TEA6300"   },
+	{ TVEEPROM_AUDPROC_OTHER, "TEA6320"   },
+	{ TVEEPROM_AUDPROC_OTHER, "TDA9850"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3400C"  },
 	/* 5-9 */
-	{ V4L2_IDENT_MSPX4XX,   "MSP3410D"  },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3415"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3430"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3438"   },
-	{ V4L2_IDENT_UNKNOWN,   "CS5331"    },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3410D"  },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3415"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3430"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3438"   },
+	{ TVEEPROM_AUDPROC_OTHER, "CS5331"    },
 	/* 10-14 */
-	{ V4L2_IDENT_MSPX4XX,   "MSP3435"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3440"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3445"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3411"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3416"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3435"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3440"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3445"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3411"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3416"   },
 	/* 15-19 */
-	{ V4L2_IDENT_MSPX4XX,   "MSP3425"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3451"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP3418"   },
-	{ V4L2_IDENT_UNKNOWN,   "Type 0x12" },
-	{ V4L2_IDENT_UNKNOWN,   "OKI7716"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3425"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3451"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP3418"   },
+	{ TVEEPROM_AUDPROC_OTHER, "Type 0x12" },
+	{ TVEEPROM_AUDPROC_OTHER, "OKI7716"   },
 	/* 20-24 */
-	{ V4L2_IDENT_MSPX4XX,   "MSP4410"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP4420"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP4440"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP4450"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP4408"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4410"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4420"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4440"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4450"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4408"   },
 	/* 25-29 */
-	{ V4L2_IDENT_MSPX4XX,   "MSP4418"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP4428"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP4448"   },
-	{ V4L2_IDENT_MSPX4XX,   "MSP4458"   },
-	{ V4L2_IDENT_MSPX4XX,   "Type 0x1d" },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4418"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4428"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4448"   },
+	{ TVEEPROM_AUDPROC_MSP,   "MSP4458"   },
+	{ TVEEPROM_AUDPROC_MSP,   "Type 0x1d" },
 	/* 30-34 */
-	{ V4L2_IDENT_AMBIGUOUS, "CX880"     },
-	{ V4L2_IDENT_AMBIGUOUS, "CX881"     },
-	{ V4L2_IDENT_AMBIGUOUS, "CX883"     },
-	{ V4L2_IDENT_AMBIGUOUS, "CX882"     },
-	{ V4L2_IDENT_AMBIGUOUS, "CX25840"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX880"     },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX881"     },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX883"     },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX882"     },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX25840"   },
 	/* 35-39 */
-	{ V4L2_IDENT_AMBIGUOUS, "CX25841"   },
-	{ V4L2_IDENT_AMBIGUOUS, "CX25842"   },
-	{ V4L2_IDENT_AMBIGUOUS, "CX25843"   },
-	{ V4L2_IDENT_AMBIGUOUS, "CX23418"   },
-	{ V4L2_IDENT_AMBIGUOUS, "CX23885"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX25841"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX25842"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX25843"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX23418"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX23885"   },
 	/* 40-44 */
-	{ V4L2_IDENT_AMBIGUOUS, "CX23888"   },
-	{ V4L2_IDENT_AMBIGUOUS, "SAA7131"   },
-	{ V4L2_IDENT_AMBIGUOUS, "CX23887"   },
-	{ V4L2_IDENT_AMBIGUOUS, "SAA7164"   },
-	{ V4L2_IDENT_AMBIGUOUS, "AU8522"    },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX23888"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "SAA7131"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX23887"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "SAA7164"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "AU8522"    },
 };
 
 /* This list is supplied by Hauppauge. Thanks! */
@@ -453,11 +443,11 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 	int i, j, len, done, beenhere, tag, start;
 
 	int tuner1 = 0, t_format1 = 0, audioic = -1;
-	char *t_name1 = NULL;
+	const char *t_name1 = NULL;
 	const char *t_fmt_name1[8] = { " none", "", "", "", "", "", "", "" };
 
 	int tuner2 = 0, t_format2 = 0;
-	char *t_name2 = NULL;
+	const char *t_name2 = NULL;
 	const char *t_fmt_name2[8] = { " none", "", "", "", "", "", "", "" };
 
 	memset(tvee, 0, sizeof(*tvee));
@@ -545,10 +535,10 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			to indicate 4052 mux was removed in favor of using MSP
 			inputs directly. */
 			audioic = eeprom_data[i+2] & 0x7f;
-			if (audioic < ARRAY_SIZE(audioIC))
-				tvee->audio_processor = audioIC[audioic].id;
+			if (audioic < ARRAY_SIZE(audio_ic))
+				tvee->audio_processor = audio_ic[audioic].id;
 			else
-				tvee->audio_processor = V4L2_IDENT_UNKNOWN;
+				tvee->audio_processor = TVEEPROM_AUDPROC_OTHER;
 			break;
 
 		/* case 0x03: tag 'EEInfo' */
@@ -578,10 +568,10 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			to indicate 4052 mux was removed in favor of using MSP
 			inputs directly. */
 			audioic = eeprom_data[i+1] & 0x7f;
-			if (audioic < ARRAY_SIZE(audioIC))
-				tvee->audio_processor = audioIC[audioic].id;
+			if (audioic < ARRAY_SIZE(audio_ic))
+				tvee->audio_processor = audio_ic[audioic].id;
 			else
-				tvee->audio_processor = V4L2_IDENT_UNKNOWN;
+				tvee->audio_processor = TVEEPROM_AUDPROC_OTHER;
 
 			break;
 
@@ -726,11 +716,11 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			t_fmt_name2[6], t_fmt_name2[7], t_format2);
 	if (audioic < 0) {
 		tveeprom_info("audio processor is unknown (no idx)\n");
-		tvee->audio_processor = V4L2_IDENT_UNKNOWN;
+		tvee->audio_processor = TVEEPROM_AUDPROC_OTHER;
 	} else {
-		if (audioic < ARRAY_SIZE(audioIC))
+		if (audioic < ARRAY_SIZE(audio_ic))
 			tveeprom_info("audio processor is %s (idx %d)\n",
-					audioIC[audioic].name, audioic);
+					audio_ic[audioic].name, audioic);
 		else
 			tveeprom_info("audio processor is unknown (idx %d)\n",
 								audioic);
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 927956b..e4b0669 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -37,7 +37,6 @@
 #include <media/i2c-addr.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-chip-ident.h>
 
 #include "em28xx.h"
 
@@ -2669,7 +2668,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 
 		dev->tuner_type = tv.tuner_type;
 
-		if (tv.audio_processor == V4L2_IDENT_MSPX4XX) {
+		if (tv.audio_processor == TVEEPROM_AUDPROC_MSP) {
 			dev->i2s_speed = 2048000;
 			dev->board.has_msp34xx = 1;
 		}
diff --git a/include/media/tveeprom.h b/include/media/tveeprom.h
index a8ad75a..4a1191a 100644
--- a/include/media/tveeprom.h
+++ b/include/media/tveeprom.h
@@ -1,6 +1,17 @@
 /*
  */
 
+enum tveeprom_audio_processor {
+	/* No audio processor present */
+	TVEEPROM_AUDPROC_NONE,
+	/* The audio processor is internal to the video processor */
+	TVEEPROM_AUDPROC_INTERNAL,
+	/* The audio processor is a MSPXXXX device */
+	TVEEPROM_AUDPROC_MSP,
+	/* The audio processor is another device */
+	TVEEPROM_AUDPROC_OTHER,
+};
+
 struct tveeprom {
 	u32 has_radio;
 	/* If has_ir == 0, then it is unknown what the IR capabilities are,
-- 
1.7.10.4

