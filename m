Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:53959 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbCTG4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 02:56:50 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 3/3] v4l2-ctl-stds: Support cvt/gtf options in set-dv-bt-timings
Date: Fri, 20 Mar 2015 12:03:33 +0530
Message-Id: <1426833213-7777-4-git-send-email-prladdha@cisco.com>
In-Reply-To: <1426833213-7777-1-git-send-email-prladdha@cisco.com>
References: <1426833213-7777-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support to parse cvt/gtf suboptions- width, height, refresh
rate, reduced blanking, interlaced.

The cvt/gtf modeline calculations are implemented v4l2-ctl-modes.cpp.
Calling those APIs to update v4l2_bt_timings structure.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-stds.cpp | 82 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index 2141876..0e4f810 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -39,6 +39,9 @@ void stds_usage(void)
 	       "  --set-dv-bt-timings\n"
 	       "                     query: use the output of VIDIOC_QUERY_DV_TIMINGS\n"
 	       "                     index=<index>: use the index as provided by --list-dv-timings\n"
+	       "                     or specify timings using cvt/gtf options as follows:\n"
+	       "                     cvt/gtf,width=<width>,height=<height>,fps=<frames per sec>\n"
+	       "                     interlaced=<0/1>,reduced-blanking=<0/1>\n"
 	       "                     or give a fully specified timings:\n"
 	       "                     width=<width>,height=<height>,interlaced=<0/1>,\n"
 	       "                     polarities=<polarities mask>,pixelclock=<pixelclock Hz>,\n"
@@ -141,6 +144,10 @@ enum timing_opts {
 	IL_VERT_SYNC,
 	IL_VERT_BACK_PORCH,
 	INDEX,
+	CVT,
+	GTF,
+	FPS,
+	REDUCED_BLANK,
 };
 
 static int parse_timing_subopt(char **subopt_str, int *value)
@@ -164,6 +171,10 @@ static int parse_timing_subopt(char **subopt_str, int *value)
 	[IL_VERT_SYNC] = "il_vs",
 	[IL_VERT_BACK_PORCH] = "il_vbp",
 	[INDEX] = "index",
+	[CVT] = "cvt",
+	[GTF] = "gtf",
+	[FPS] = "fps",
+	[REDUCED_BLANK] = "reduced-blanking",
 	NULL
 	};
 
@@ -174,7 +185,7 @@ static int parse_timing_subopt(char **subopt_str, int *value)
 		stds_usage();
 		exit(1);
 	}
-	if (opt_str == NULL) {
+	if (opt_str == NULL && opt != CVT && opt != GTF) {
 		fprintf(stderr, "No value given to suboption <%s>\n",
 				subopt_list[opt]);
 		stds_usage();
@@ -186,11 +197,69 @@ static int parse_timing_subopt(char **subopt_str, int *value)
 	return opt;
 }
 
+static void get_cvt_gtf_timings(char *subopt, int standard,
+				struct v4l2_bt_timings *bt)
+{
+	int width = 0;
+	int height = 0;
+	int fps = 0;
+	int r_blank = 0;
+	int interlaced = 0;
+
+	bool timings_valid = false;
+
+	char *subopt_str = subopt;
+	while (*subopt_str != '\0') {
+		int opt;
+		int opt_val;
+
+		opt = parse_timing_subopt(&subopt_str, &opt_val);
+
+		switch (opt) {
+		case WIDTH:
+			width = opt_val;
+			break;
+		case HEIGHT:
+			height = opt_val;
+			break;
+		case FPS:
+			fps = opt_val;
+			break;
+		case REDUCED_BLANK:
+			r_blank = opt_val;
+			break;
+		case INTERLACED:
+			interlaced = opt_val;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (standard == V4L2_DV_BT_STD_CVT) {
+		timings_valid = calc_cvt_modeline(width, height, fps,
+			              r_blank == 1 ? true : false,
+			              interlaced == 1 ? true : false,
+			              bt);
+	} else {
+		timings_valid = calc_gtf_modeline(width, height, fps,
+			              r_blank == 1 ? true : false,
+			              interlaced == 1 ? true : false,
+			              bt);
+	}
+
+	if (!timings_valid) {
+		stds_usage();
+		exit(1);
+	}
+}
+
 static void parse_dv_bt_timings(char *optarg, struct v4l2_dv_timings *dv_timings,
 		bool &query, int &enumerate)
 {
 	char *subs = optarg;
 	struct v4l2_bt_timings *bt = &dv_timings->bt;
+	bool parse_cvt_gtf = false;
 
 	dv_timings->type = V4L2_DV_BT_656_1120;
 
@@ -199,11 +268,12 @@ static void parse_dv_bt_timings(char *optarg, struct v4l2_dv_timings *dv_timings
 		return;
 	}
 
-	while (*subs != '\0') {
+	while (*subs != '\0' && !parse_cvt_gtf) {
 		int opt;
 		int opt_val;
 
 		opt = parse_timing_subopt(&subs, &opt_val);
+
 		switch (opt) {
 		case WIDTH:
 			bt->width = opt_val;
@@ -250,6 +320,14 @@ static void parse_dv_bt_timings(char *optarg, struct v4l2_dv_timings *dv_timings
 		case INDEX:
 			enumerate = opt_val;
 			break;
+		case CVT:
+			parse_cvt_gtf = true;
+			get_cvt_gtf_timings(subs, V4L2_DV_BT_STD_CVT, bt);
+			break;
+		case GTF:
+			parse_cvt_gtf = true;
+			get_cvt_gtf_timings(subs, V4L2_DV_BT_STD_GTF, bt);
+			break;
 		default:
 			stds_usage();
 			exit(1);
-- 
1.9.1

