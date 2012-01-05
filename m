Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:46341 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab2AEJKY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 04:10:24 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] omap3isp: Check media bus code on links
Date: Thu,  5 Jan 2012 11:10:19 +0200
Message-Id: <1325754619-2520-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check media bus code on links. The user could configure different formats at
different ends of the link, say, 8 bits-per-pixel in the source and 10
bits-per-pixel in the sink. This leads to interesting and typically
undesired results image-wise.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 615dae5..dbdd5b4 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -352,7 +352,8 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 
 		/* Check if the two ends match */
 		if (fmt_source.format.width != fmt_sink.format.width ||
-		    fmt_source.format.height != fmt_sink.format.height)
+		    fmt_source.format.height != fmt_sink.format.height ||
+		    fmt_source.format.code != fmt_sink.format.code)
 			return -EPIPE;
 
 		if (shifter_link) {
-- 
1.7.2.5

