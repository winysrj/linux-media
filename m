Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43771 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbbFEIaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 04:30:14 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EC4A72A0085
	for <linux-media@vger.kernel.org>; Fri,  5 Jun 2015 10:30:02 +0200 (CEST)
Message-ID: <55715E0A.20700@xs4all.nl>
Date: Fri, 05 Jun 2015 10:30:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-dv-timings: support interlaced in v4l2_print_dv_timings
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_print_dv_timings() didn't log the interlaced format correctly. The timings
for the bottom field weren't logged and the fields per second value was half of what
it should have been.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5792192..d303fdc 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -262,6 +262,8 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 
 	htot = V4L2_DV_BT_FRAME_WIDTH(bt);
 	vtot = V4L2_DV_BT_FRAME_HEIGHT(bt);
+	if (bt->interlaced)
+		vtot /= 2;
 
 	if (prefix == NULL)
 		prefix = "";
@@ -282,6 +284,11 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 			dev_prefix, bt->vfrontporch,
 			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
 			bt->vsync, bt->vbackporch);
+	if (bt->interlaced)
+		pr_info("%s: vertical bottom field: fp = %u, %ssync = %u, bp = %u\n",
+			dev_prefix, bt->il_vfrontporch,
+			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
+			bt->il_vsync, bt->il_vbackporch);
 	pr_info("%s: pixelclock: %llu\n", dev_prefix, bt->pixelclock);
 	pr_info("%s: flags (0x%x):%s%s%s%s%s\n", dev_prefix, bt->flags,
 			(bt->flags & V4L2_DV_FL_REDUCED_BLANKING) ?

