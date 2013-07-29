Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2486 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3G2Mle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [RFC PATCH 8/8] ths8200/ad9389b: use new dv_timings helpers.
Date: Mon, 29 Jul 2013 14:41:01 +0200
Message-Id: <1375101661-6493-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/ad9389b.c | 108 +++++++-------------------------------------
 drivers/media/i2c/ths8200.c |  55 ++++++----------------
 2 files changed, 31 insertions(+), 132 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 5295234..7e68d8f 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -635,95 +635,34 @@ static int ad9389b_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static const struct v4l2_dv_timings ad9389b_timings[] = {
-	V4L2_DV_BT_CEA_720X480P59_94,
-	V4L2_DV_BT_CEA_720X576P50,
-	V4L2_DV_BT_CEA_1280X720P24,
-	V4L2_DV_BT_CEA_1280X720P25,
-	V4L2_DV_BT_CEA_1280X720P30,
-	V4L2_DV_BT_CEA_1280X720P50,
-	V4L2_DV_BT_CEA_1280X720P60,
-	V4L2_DV_BT_CEA_1920X1080P24,
-	V4L2_DV_BT_CEA_1920X1080P25,
-	V4L2_DV_BT_CEA_1920X1080P30,
-	V4L2_DV_BT_CEA_1920X1080P50,
-	V4L2_DV_BT_CEA_1920X1080P60,
-
-	V4L2_DV_BT_DMT_640X350P85,
-	V4L2_DV_BT_DMT_640X400P85,
-	V4L2_DV_BT_DMT_720X400P85,
-	V4L2_DV_BT_DMT_640X480P60,
-	V4L2_DV_BT_DMT_640X480P72,
-	V4L2_DV_BT_DMT_640X480P75,
-	V4L2_DV_BT_DMT_640X480P85,
-	V4L2_DV_BT_DMT_800X600P56,
-	V4L2_DV_BT_DMT_800X600P60,
-	V4L2_DV_BT_DMT_800X600P72,
-	V4L2_DV_BT_DMT_800X600P75,
-	V4L2_DV_BT_DMT_800X600P85,
-	V4L2_DV_BT_DMT_848X480P60,
-	V4L2_DV_BT_DMT_1024X768P60,
-	V4L2_DV_BT_DMT_1024X768P70,
-	V4L2_DV_BT_DMT_1024X768P75,
-	V4L2_DV_BT_DMT_1024X768P85,
-	V4L2_DV_BT_DMT_1152X864P75,
-	V4L2_DV_BT_DMT_1280X768P60_RB,
-	V4L2_DV_BT_DMT_1280X768P60,
-	V4L2_DV_BT_DMT_1280X768P75,
-	V4L2_DV_BT_DMT_1280X768P85,
-	V4L2_DV_BT_DMT_1280X800P60_RB,
-	V4L2_DV_BT_DMT_1280X800P60,
-	V4L2_DV_BT_DMT_1280X800P75,
-	V4L2_DV_BT_DMT_1280X800P85,
-	V4L2_DV_BT_DMT_1280X960P60,
-	V4L2_DV_BT_DMT_1280X960P85,
-	V4L2_DV_BT_DMT_1280X1024P60,
-	V4L2_DV_BT_DMT_1280X1024P75,
-	V4L2_DV_BT_DMT_1280X1024P85,
-	V4L2_DV_BT_DMT_1360X768P60,
-	V4L2_DV_BT_DMT_1400X1050P60_RB,
-	V4L2_DV_BT_DMT_1400X1050P60,
-	V4L2_DV_BT_DMT_1400X1050P75,
-	V4L2_DV_BT_DMT_1400X1050P85,
-	V4L2_DV_BT_DMT_1440X900P60_RB,
-	V4L2_DV_BT_DMT_1440X900P60,
-	V4L2_DV_BT_DMT_1600X1200P60,
-	V4L2_DV_BT_DMT_1680X1050P60_RB,
-	V4L2_DV_BT_DMT_1680X1050P60,
-	V4L2_DV_BT_DMT_1792X1344P60,
-	V4L2_DV_BT_DMT_1856X1392P60,
-	V4L2_DV_BT_DMT_1920X1200P60_RB,
-	V4L2_DV_BT_DMT_1366X768P60,
-	V4L2_DV_BT_DMT_1920X1080P60,
-	{},
+static const struct v4l2_dv_timings_cap ad9389b_timings_cap = {
+	.type = V4L2_DV_BT_656_1120,
+	.bt = {
+		.max_width = 1920,
+		.max_height = 1200,
+		.min_pixelclock = 27000000,
+		.max_pixelclock = 170000000,
+		.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
+		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
+			V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM,
+	},
 };
 
 static int ad9389b_s_dv_timings(struct v4l2_subdev *sd,
 				struct v4l2_dv_timings *timings)
 {
 	struct ad9389b_state *state = get_ad9389b_state(sd);
-	int i;
 
 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
 
 	/* quick sanity check */
-	if (timings->type != V4L2_DV_BT_656_1120)
-		return -EINVAL;
-
-	if (timings->bt.interlaced)
-		return -EINVAL;
-	if (timings->bt.pixelclock < 27000000 ||
-	    timings->bt.pixelclock > 170000000)
+	if (!v4l2_dv_valid_timings(timings, &ad9389b_timings_cap))
 		return -EINVAL;
 
 	/* Fill the optional fields .standards and .flags in struct v4l2_dv_timings
-	   if the format is listed in ad9389b_timings[] */
-	for (i = 0; ad9389b_timings[i].bt.width; i++) {
-		if (v4l_match_dv_timings(timings, &ad9389b_timings[i], 0)) {
-			*timings = ad9389b_timings[i];
-			break;
-		}
-	}
+	   if the format is one of the CEA or DMT timings. */
+	v4l2_find_dv_timings_cap(timings, &ad9389b_timings_cap, 0);
 
 	timings->bt.flags &= ~V4L2_DV_FL_REDUCED_FPS;
 
@@ -761,26 +700,13 @@ static int ad9389b_g_dv_timings(struct v4l2_subdev *sd,
 static int ad9389b_enum_dv_timings(struct v4l2_subdev *sd,
 			struct v4l2_enum_dv_timings *timings)
 {
-	if (timings->index >= ARRAY_SIZE(ad9389b_timings))
-		return -EINVAL;
-
-	memset(timings->reserved, 0, sizeof(timings->reserved));
-	timings->timings = ad9389b_timings[timings->index];
-	return 0;
+	return v4l2_enum_dv_timings_cap(timings, &ad9389b_timings_cap);
 }
 
 static int ad9389b_dv_timings_cap(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings_cap *cap)
 {
-	cap->type = V4L2_DV_BT_656_1120;
-	cap->bt.max_width = 1920;
-	cap->bt.max_height = 1200;
-	cap->bt.min_pixelclock = 27000000;
-	cap->bt.max_pixelclock = 170000000;
-	cap->bt.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
-			 V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT;
-	cap->bt.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
-		V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM;
+	*cap = ad9389b_timings_cap;
 	return 0;
 }
 
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 28932e9..7a60a8f 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -44,18 +44,16 @@ struct ths8200_state {
 	struct v4l2_dv_timings dv_timings;
 };
 
-static const struct v4l2_dv_timings ths8200_timings[] = {
-	V4L2_DV_BT_CEA_720X480P59_94,
-	V4L2_DV_BT_CEA_1280X720P24,
-	V4L2_DV_BT_CEA_1280X720P25,
-	V4L2_DV_BT_CEA_1280X720P30,
-	V4L2_DV_BT_CEA_1280X720P50,
-	V4L2_DV_BT_CEA_1280X720P60,
-	V4L2_DV_BT_CEA_1920X1080P24,
-	V4L2_DV_BT_CEA_1920X1080P25,
-	V4L2_DV_BT_CEA_1920X1080P30,
-	V4L2_DV_BT_CEA_1920X1080P50,
-	V4L2_DV_BT_CEA_1920X1080P60,
+static const struct v4l2_dv_timings_cap ths8200_timings_cap = {
+	.type = V4L2_DV_BT_656_1120,
+	.bt = {
+		.max_width = 1920,
+		.max_height = 1080,
+		.min_pixelclock = 27000000,
+		.max_pixelclock = 148500000,
+		.standards = V4L2_DV_BT_STD_CEA861,
+		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE,
+	},
 };
 
 static inline struct ths8200_state *to_state(struct v4l2_subdev *sd)
@@ -411,25 +409,13 @@ static int ths8200_s_dv_timings(struct v4l2_subdev *sd,
 				struct v4l2_dv_timings *timings)
 {
 	struct ths8200_state *state = to_state(sd);
-	int i;
 
 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
 
-	if (timings->type != V4L2_DV_BT_656_1120)
+	if (!v4l2_dv_valid_timings(timings, &ths8200_timings_cap))
 		return -EINVAL;
 
-	/* TODO Support interlaced formats */
-	if (timings->bt.interlaced) {
-		v4l2_dbg(1, debug, sd, "TODO Support interlaced formats\n");
-		return -EINVAL;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(ths8200_timings); i++) {
-		if (v4l_match_dv_timings(&ths8200_timings[i], timings, 10))
-			break;
-	}
-
-	if (i == ARRAY_SIZE(ths8200_timings)) {
+	if (!v4l2_find_dv_timings_cap(timings, &ths8200_timings_cap, 10)) {
 		v4l2_dbg(1, debug, sd, "Unsupported format\n");
 		return -EINVAL;
 	}
@@ -459,26 +445,13 @@ static int ths8200_g_dv_timings(struct v4l2_subdev *sd,
 static int ths8200_enum_dv_timings(struct v4l2_subdev *sd,
 				   struct v4l2_enum_dv_timings *timings)
 {
-	/* Check requested format index is within range */
-	if (timings->index >= ARRAY_SIZE(ths8200_timings))
-		return -EINVAL;
-
-	timings->timings = ths8200_timings[timings->index];
-
-	return 0;
+	return v4l2_enum_dv_timings_cap(timings, &ths8200_timings_cap);
 }
 
 static int ths8200_dv_timings_cap(struct v4l2_subdev *sd,
 				  struct v4l2_dv_timings_cap *cap)
 {
-	cap->type = V4L2_DV_BT_656_1120;
-	cap->bt.max_width = 1920;
-	cap->bt.max_height = 1080;
-	cap->bt.min_pixelclock = 27000000;
-	cap->bt.max_pixelclock = 148500000;
-	cap->bt.standards = V4L2_DV_BT_STD_CEA861;
-	cap->bt.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE;
-
+	*cap = ths8200_timings_cap;
 	return 0;
 }
 
-- 
1.8.3.2

