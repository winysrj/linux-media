Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750945AbdDCLZk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 07:25:40 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH] uvcvideo: don't recode timespec_sub
Date: Mon,  3 Apr 2017 12:25:31 +0100
Message-Id: <1491218732-12068-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

The statistics function subtracts two timespecs manually. A helper is
provided by the kernel to do this.

Replace the implementation, using the helper.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_video.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 7777ed24908b..cff02c6df1b8 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -868,14 +868,8 @@ size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 	struct timespec ts;
 	size_t count = 0;
 
-	ts.tv_sec = stream->stats.stream.stop_ts.tv_sec
-		  - stream->stats.stream.start_ts.tv_sec;
-	ts.tv_nsec = stream->stats.stream.stop_ts.tv_nsec
-		   - stream->stats.stream.start_ts.tv_nsec;
-	if (ts.tv_nsec < 0) {
-		ts.tv_sec--;
-		ts.tv_nsec += 1000000000;
-	}
+	ts = timespec_sub(stream->stats.stream.stop_ts,
+			  stream->stats.stream.start_ts);
 
 	/* Compute the SCR.SOF frequency estimate. At the nominal 1kHz SOF
 	 * frequency this will not overflow before more than 1h.
-- 
2.7.4
