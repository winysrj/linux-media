Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:34611 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbbFWF4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 01:56:18 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH v2 2/2] v4l2-utils: Modify usage for set-dv-timing to support RB V2
Date: Tue, 23 Jun 2015 11:26:13 +0530
Message-Id: <1435038973-2076-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1435038973-2076-1-git-send-email-prladdha@cisco.com>
References: <1435038973-2076-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To support the timings calculations for reduced blanking version 2
(RB v2), command line options now capture version info. Updated the
command usage for the same.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-stds.cpp | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index 3e54ff6..aea46c9 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -41,7 +41,11 @@ void stds_usage(void)
 	       "                     index=<index>: use the index as provided by --list-dv-timings\n"
 	       "                     or specify timings using cvt/gtf options as follows:\n"
 	       "                     cvt/gtf,width=<width>,height=<height>,fps=<frames per sec>\n"
-	       "                     interlaced=<0/1>,reduced-blanking=<0/1>\n"
+	       "                     interlaced=<0/1>,reduced-blanking=<0/1/2>\n"
+	       "                     The value of reduced-blanking, if greater than 0, indicates\n"
+	       "                     that reduced blanking is to be used and the value indicate the\n"
+	       "                     version. For gtf, there is no version 2 for reduced blanking, and\n"
+	       "		     the value 1 or 2 will give same results.\n"
 	       "                     or give a fully specified timings:\n"
 	       "                     width=<width>,height=<height>,interlaced=<0/1>,\n"
 	       "                     polarities=<polarities mask>,pixelclock=<pixelclock Hz>,\n"
@@ -205,7 +209,6 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 	int fps = 0;
 	int r_blank = 0;
 	int interlaced = 0;
-
 	bool timings_valid = false;
 
 	char *subopt_str = subopt;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
