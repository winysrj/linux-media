Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55896 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2AORxm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 12:53:42 -0500
Received: from localhost.localdomain (unknown [91.178.228.121])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6FB8C35B8D
	for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 17:53:41 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH FOR v3.3] uvcvideo: Avoid division by 0 in timestamp calculation
Date: Sun, 15 Jan 2012 18:53:45 +0100
Message-Id: <1326650025-11834-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use system timestamps if the timestamp can't be computed from the data
sent by the device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

This patches fixes a kernel division by 0 introduced in v3.3. I'll send a pull
request for v3.3-rc in a couple of days if there's no comment.

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index c7e69b8..4a44f9a 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -611,9 +611,11 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 	delta_stc = buf->pts - (1UL << 31);
 	x1 = first->dev_stc - delta_stc;
 	x2 = last->dev_stc - delta_stc;
+	if (x1 == x2)
+		goto done;
+
 	y1 = (first->dev_sof + 2048) << 16;
 	y2 = (last->dev_sof + 2048) << 16;
-
 	if (y2 < y1)
 		y2 += 2048 << 16;
 
@@ -631,14 +633,16 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 		  x1, x2, y1, y2, clock->sof_offset);
 
 	/* Second step, SOF to host clock conversion. */
-	ts = timespec_sub(last->host_ts, first->host_ts);
 	x1 = (uvc_video_clock_host_sof(first) + 2048) << 16;
 	x2 = (uvc_video_clock_host_sof(last) + 2048) << 16;
-	y1 = NSEC_PER_SEC;
-	y2 = (ts.tv_sec + 1) * NSEC_PER_SEC + ts.tv_nsec;
-
 	if (x2 < x1)
 		x2 += 2048 << 16;
+	if (x1 == x2)
+		goto done;
+
+	ts = timespec_sub(last->host_ts, first->host_ts);
+	y1 = NSEC_PER_SEC;
+	y2 = (ts.tv_sec + 1) * NSEC_PER_SEC + ts.tv_nsec;
 
 	/* Interpolated and host SOF timestamps can wrap around at slightly
 	 * different times. Handle this by adding or removing 2048 to or from
-- 
Regards,

Laurent Pinchart

