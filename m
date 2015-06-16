Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:61074 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbbFPJho (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 05:37:44 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH 2/2] v4l2-utils: extend set-dv-timing options for RB version
Date: Tue, 16 Jun 2015 15:00:31 +0530
Message-Id: <1434447031-21434-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1434447031-21434-1-git-send-email-prladdha@cisco.com>
References: <1434447031-21434-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To support the timings calculations for reduced blanking version 2
(RB v2), extended the command line options to include flag indicating
whether to use RB V2 or not. Updated the command usage for the same.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-stds.cpp | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index c0e919b..9734c80 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -41,7 +41,10 @@ void stds_usage(void)
 	       "                     index=<index>: use the index as provided by --list-dv-timings\n"
 	       "                     or specify timings using cvt/gtf options as follows:\n"
 	       "                     cvt/gtf,width=<width>,height=<height>,fps=<frames per sec>\n"
-	       "                     interlaced=<0/1>,reduced-blanking=<0/1>\n"
+	       "                     interlaced=<0/1>,reduced-blanking=<0/1>,use-rb-v2=<0/1>\n"
+	       "                     use-rb-v2 indicates whether to use reduced blanking version 2\n"
+	       "                     or not. This flag is relevant only for cvt timings and has\n"
+	       "                     effect only if reduced-blanking=1\n"
 	       "                     or give a fully specified timings:\n"
 	       "                     width=<width>,height=<height>,interlaced=<0/1>,\n"
 	       "                     polarities=<polarities mask>,pixelclock=<pixelclock Hz>,\n"
@@ -148,6 +151,7 @@ enum timing_opts {
 	GTF,
 	FPS,
 	REDUCED_BLANK,
+	USE_RB_V2,
 };
 
 static int parse_timing_subopt(char **subopt_str, int *value)
@@ -175,6 +179,7 @@ static int parse_timing_subopt(char **subopt_str, int *value)
 		"gtf",
 		"fps",
 		"reduced-blanking",
+		"use-rb-v2",
 		NULL
 	};
 
@@ -205,6 +210,7 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 	int fps = 0;
 	int r_blank = 0;
 	int interlaced = 0;
+	int use_rb_v2 = 0;
 
 	bool timings_valid = false;
 
@@ -231,6 +237,8 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 		case INTERLACED:
 			interlaced = opt_val;
 			break;
+		case USE_RB_V2:
+			use_rb_v2 = opt_val;
 		default:
 			break;
 		}
@@ -240,7 +248,8 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 		timings_valid = calc_cvt_modeline(width, height, fps,
 			              r_blank == 1 ? true : false,
 			              interlaced == 1 ? true : false,
-			              false, bt);
+			              use_rb_v2 == 1 ? true : false,
+			              bt);
 	} else {
 		timings_valid = calc_gtf_modeline(width, height, fps,
 			              r_blank == 1 ? true : false,
-- 
1.9.1

