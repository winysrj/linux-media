Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:33317 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbCTG4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 02:56:48 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 2/3] v4l2-ctl-stds: Restructured suboption parsing code
Date: Fri, 20 Mar 2015 12:03:32 +0530
Message-Id: <1426833213-7777-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1426833213-7777-1-git-send-email-prladdha@cisco.com>
References: <1426833213-7777-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change is in preparation towards extending suboptions to include
options to set cvt/gtf timings. One of the suboption for cvt/gtf is
without value. The existing function parse_subopt() does not support
parsing of suboption without value.

Replacing parse_subopt() with new function parse_timing_subopt(). In
fact, parse_subopt() is a wrapper around getsubopt() and parse_subopt()
can be modified to support suboptions without value. However, avoided
such a change because it would have led to changes in some more files.

Also, enumerated sub options. This would make it easier to add/remove
suboptions for cvt, gtf.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-stds.cpp | 149 +++++++++++++++++++++++++--------------
 1 file changed, 97 insertions(+), 52 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index 4c7e308..2141876 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -20,7 +20,7 @@ static v4l2_std_id standard;		/* get_std/set_std */
 static struct v4l2_dv_timings dv_timings; /* set_dv_bt_timings/get_dv_timings/query_dv_timings */
 static bool query_and_set_dv_timings = false;
 static int enum_and_set_dv_timings = -1;
-	
+
 void stds_usage(void)
 {
 	printf("\nStandards/Timings options:\n"
@@ -125,10 +125,70 @@ static v4l2_std_id parse_ntsc(const char *ntsc)
 	exit(1);
 }
 
+enum timing_opts {
+	WIDTH = 0,
+	HEIGHT,
+	INTERLACED,
+	POLARITIES,
+	PIXEL_CLOCK,
+	HORZ_FRONT_PORCH,
+	HORZ_SYNC,
+	HORZ_BACK_PORCH,
+	VERT_FRONT_PORCH,
+	VERT_SYNC,
+	VERT_BACK_PORCH,
+	IL_VERT_FRONT_PORCH,
+	IL_VERT_SYNC,
+	IL_VERT_BACK_PORCH,
+	INDEX,
+};
+
+static int parse_timing_subopt(char **subopt_str, int *value)
+{
+	int opt;
+	char *opt_str;
+
+	static const char * const subopt_list[] = {
+	[WIDTH] = "width",
+	[HEIGHT] = "height",
+	[INTERLACED] = "interlaced",
+	[POLARITIES] = "polarities",
+	[PIXEL_CLOCK] = "pixelclock",
+	[HORZ_FRONT_PORCH] = "hfp",
+	[HORZ_SYNC] = "hs",
+	[HORZ_BACK_PORCH] = "hbp",
+	[VERT_FRONT_PORCH] = "vfp",
+	[VERT_SYNC] = "vs",
+	[VERT_BACK_PORCH] = "vbp",
+	[IL_VERT_FRONT_PORCH] = "il_vfp",
+	[IL_VERT_SYNC] = "il_vs",
+	[IL_VERT_BACK_PORCH] = "il_vbp",
+	[INDEX] = "index",
+	NULL
+	};
+
+	opt = getsubopt(subopt_str, (char* const*) subopt_list, &opt_str);
+
+	if (opt == -1) {
+		fprintf(stderr, "Invalid suboptions specified\n");
+		stds_usage();
+		exit(1);
+	}
+	if (opt_str == NULL) {
+		fprintf(stderr, "No value given to suboption <%s>\n",
+				subopt_list[opt]);
+		stds_usage();
+		exit(1);
+	}
+
+	if (opt_str)
+		*value = strtol(opt_str, 0L, 0);
+	return opt;
+}
+
 static void parse_dv_bt_timings(char *optarg, struct v4l2_dv_timings *dv_timings,
 		bool &query, int &enumerate)
 {
-	char *value;
 	char *subs = optarg;
 	struct v4l2_bt_timings *bt = &dv_timings->bt;
 
@@ -140,70 +200,55 @@ static void parse_dv_bt_timings(char *optarg, struct v4l2_dv_timings *dv_timings
 	}
 
 	while (*subs != '\0') {
-		static const char *const subopts[] = {
-			"width",
-			"height",
-			"interlaced",
-			"polarities",
-			"pixelclock",
-			"hfp",
-			"hs",
-			"hbp",
-			"vfp",
-			"vs",
-			"vbp",
-			"il_vfp",
-			"il_vs",
-			"il_vbp",
-			"index",
-			NULL
-		};
-
-		switch (parse_subopt(&subs, subopts, &value)) {
-		case 0:
-			bt->width = atoi(value);
+		int opt;
+		int opt_val;
+
+		opt = parse_timing_subopt(&subs, &opt_val);
+		switch (opt) {
+		case WIDTH:
+			bt->width = opt_val;
 			break;
-		case 1:
-			bt->height = strtol(value, 0L, 0);
+		case HEIGHT:
+			bt->height = opt_val;
 			break;
-		case 2:
-			bt->interlaced = strtol(value, 0L, 0);
+		case INTERLACED:
+			bt->interlaced = opt_val;
 			break;
-		case 3:
-			bt->polarities = strtol(value, 0L, 0);
+		case POLARITIES:
+			bt->polarities = opt_val;
 			break;
-		case 4:
-			bt->pixelclock = strtol(value, 0L, 0);
+		case PIXEL_CLOCK:
+			bt->pixelclock = opt_val;
 			break;
-		case 5:
-			bt->hfrontporch = strtol(value, 0L, 0);
+		case HORZ_FRONT_PORCH:
+			bt->hfrontporch = opt_val;
 			break;
-		case 6:
-			bt->hsync = strtol(value, 0L, 0);
+		case HORZ_SYNC:
+			bt->hsync = opt_val;
 			break;
-		case 7:
-			bt->hbackporch = strtol(value, 0L, 0);
+		case HORZ_BACK_PORCH:
+			bt->hbackporch = opt_val;
 			break;
-		case 8:
-			bt->vfrontporch = strtol(value, 0L, 0);
+		case VERT_FRONT_PORCH:
+			bt->vfrontporch = opt_val;
 			break;
-		case 9:
-			bt->vsync = strtol(value, 0L, 0);
+		case VERT_SYNC:
+			bt->vsync = opt_val;
 			break;
-		case 10:
-			bt->vbackporch = strtol(value, 0L, 0);
+		case VERT_BACK_PORCH:
+			bt->vbackporch = opt_val;
 			break;
-		case 11:
-			bt->il_vfrontporch = strtol(value, 0L, 0);
+		case IL_VERT_FRONT_PORCH:
+			bt->il_vfrontporch = opt_val;
 			break;
-		case 12:
-			bt->il_vsync = strtol(value, 0L, 0);
+		case IL_VERT_SYNC:
+			bt->il_vsync = opt_val;
 			break;
-		case 13:
-			bt->il_vbackporch = strtol(value, 0L, 0);
+		case IL_VERT_BACK_PORCH:
+			bt->il_vbackporch = opt_val;
 			break;
-		case 14:
-			enumerate = strtol(value, 0L, 0);
+		case INDEX:
+			enumerate = opt_val;
 			break;
 		default:
 			stds_usage();
-- 
1.9.1

