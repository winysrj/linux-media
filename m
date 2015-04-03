Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49404 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbbDCJ3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 05:29:40 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7ED6A2A009F
	for <linux-media@vger.kernel.org>; Fri,  3 Apr 2015 11:29:07 +0200 (CEST)
Message-ID: <551E5D63.7040407@xs4all.nl>
Date: Fri, 03 Apr 2015 11:29:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/5] v4l2-dv-timings: log new V4L2_DV_FL_IS_CE_VIDEO flag
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the new flag to v4l2_print_dv_timings().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Follow-up to:
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/89447
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index b1d8dbb..c0e9638 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -282,7 +282,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
 			bt->vsync, bt->vbackporch);
 	pr_info("%s: pixelclock: %llu\n", dev_prefix, bt->pixelclock);
-	pr_info("%s: flags (0x%x):%s%s%s%s\n", dev_prefix, bt->flags,
+	pr_info("%s: flags (0x%x):%s%s%s%s%s\n", dev_prefix, bt->flags,
 			(bt->flags & V4L2_DV_FL_REDUCED_BLANKING) ?
 			" REDUCED_BLANKING" : "",
 			(bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS) ?
@@ -290,7 +290,9 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 			(bt->flags & V4L2_DV_FL_REDUCED_FPS) ?
 			" REDUCED_FPS" : "",
 			(bt->flags & V4L2_DV_FL_HALF_LINE) ?
-			" HALF_LINE" : "");
+			" HALF_LINE" : "",
+			(bt->flags & V4L2_DV_FL_IS_CE_VIDEO) ?
+			" CE_VIDEO" : "");
 	pr_info("%s: standards (0x%x):%s%s%s%s\n", dev_prefix, bt->standards,
 			(bt->standards & V4L2_DV_BT_STD_CEA861) ?  " CEA" : "",
 			(bt->standards & V4L2_DV_BT_STD_DMT) ?  " DMT" : "",
-- 
2.1.4

