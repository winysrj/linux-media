Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:43811 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbFXGiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 02:38:55 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH 2/2] v4l2-utils: extend set-dv-timings to support reduced fps
Date: Wed, 24 Jun 2015 12:08:52 +0530
Message-Id: <1435127932-10193-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1435127932-10193-1-git-send-email-prladdha@cisco.com>
References: <1435127932-10193-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extended command line option for set-dv-timings to support timings
calculations for reduced fps. This will allow supporting NTSC frame
rates like 29.97 or 59.94.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-stds.cpp | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index e969d08..3987ba1 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -41,11 +41,15 @@ void stds_usage(void)
 	       "                     index=<index>: use the index as provided by --list-dv-timings\n"
 	       "                     or specify timings using cvt/gtf options as follows:\n"
 	       "                     cvt/gtf,width=<width>,height=<height>,fps=<frames per sec>\n"
-	       "                     interlaced=<0/1>,reduced-blanking=<0/1/2>\n"
+	       "                     interlaced=<0/1>,reduced-blanking=<0/1/2>,reduced-fps=<0/1>\n"
 	       "                     The value of reduced-blanking, if greater than 0, indicates\n"
 	       "                     that reduced blanking is to be used and the value indicate the\n"
 	       "                     version. For gtf, there is no version 2 for reduced blanking, and\n"
 	       "		     the value 1 or 2 will give same results.\n"
+	       "		     reduced-fps = 1, slows down pixel clock by factor of 1000 / 1001, allowing\n"
+	       "		     to support NTSC frame rates like 29.97 or 59.94.\n"
+	       "		     Reduced fps flag takes effect only with reduced blanking version 2 and,\n"
+	       "		     when refresh rate is an integer multiple of 6, say, fps = 24,30,60 etc.\n"
 	       "                     or give a fully specified timings:\n"
 	       "                     width=<width>,height=<height>,interlaced=<0/1>,\n"
 	       "                     polarities=<polarities mask>,pixelclock=<pixelclock Hz>,\n"
@@ -152,6 +156,7 @@ enum timing_opts {
 	GTF,
 	FPS,
 	REDUCED_BLANK,
+	REDUCED_FPS,
 };
 
 static int parse_timing_subopt(char **subopt_str, int *value)
@@ -179,6 +184,7 @@ static int parse_timing_subopt(char **subopt_str, int *value)
 		"gtf",
 		"fps",
 		"reduced-blanking",
+		"reduced-fps",
 		NULL
 	};
 
@@ -209,6 +215,7 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 	int fps = 0;
 	int r_blank = 0;
 	int interlaced = 0;
+	bool reduced_fps = false;
 	bool timings_valid = false;
 
 	char *subopt_str = subopt;
@@ -234,6 +241,9 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 		case INTERLACED:
 			interlaced = opt_val;
 			break;
+		case REDUCED_FPS:
+			reduced_fps = (opt_val == 1) ? true : false;
+			break;
 		default:
 			break;
 		}
@@ -241,7 +251,7 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 
 	if (standard == V4L2_DV_BT_STD_CVT) {
 		timings_valid = calc_cvt_modeline(width, height, fps, r_blank,
-						  interlaced == 1 ? true : false, false, bt);
+						  interlaced == 1 ? true : false, reduced_fps, bt);
 	} else {
 		timings_valid = calc_gtf_modeline(width, height, fps, r_blank,
 						  interlaced == 1 ? true : false, bt);
-- 
1.9.1

