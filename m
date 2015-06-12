Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56260 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbbFLGxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 02:53:07 -0400
Message-ID: <557A81C6.60604@xs4all.nl>
Date: Fri, 12 Jun 2015 08:52:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
Subject: [PATCH] v4l2-dv-timings: log if the timing is reduced blanking V2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The last CVT standard introduced reduced blanking version 2 which is signaled by
a vsync of 8. Log this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index eefad4f..5d9e896 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -290,9 +290,11 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
 			bt->il_vsync, bt->il_vbackporch);
 	pr_info("%s: pixelclock: %llu\n", dev_prefix, bt->pixelclock);
-	pr_info("%s: flags (0x%x):%s%s%s%s%s\n", dev_prefix, bt->flags,
+	pr_info("%s: flags (0x%x):%s%s%s%s%s%s\n", dev_prefix, bt->flags,
 			(bt->flags & V4L2_DV_FL_REDUCED_BLANKING) ?
 			" REDUCED_BLANKING" : "",
+			((bt->flags & V4L2_DV_FL_REDUCED_BLANKING) &&
+			 bt->vsync == 8) ? " (V2)" : "",
 			(bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS) ?
 			" CAN_REDUCE_FPS" : "",
 			(bt->flags & V4L2_DV_FL_REDUCED_FPS) ?
