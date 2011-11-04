Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52215 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1KDMqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 08:46:20 -0400
Received: from localhost.localdomain (unknown [91.178.160.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C05E135997
	for <linux-media@vger.kernel.org>; Fri,  4 Nov 2011 12:46:18 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/6] uvcvideo: Don't skip erroneous payloads
Date: Fri,  4 Nov 2011 13:46:16 +0100
Message-Id: <1320410777-14108-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inside of skipping the payload completely, which would make the
resulting image corrupted anyway, store the payload normally and mark
the buffer as erroneous. If the no_drop module parameter is set to 1 the
buffer will then be passed to userspace, and tt will then be up to the
application to decide what to do with the buffer.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index b953dae..a57f813 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -409,13 +409,6 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	if (len < 2 || data[0] < 2 || data[0] > len)
 		return -EINVAL;
 
-	/* Skip payloads marked with the error bit ("error frames"). */
-	if (data[1] & UVC_STREAM_ERR) {
-		uvc_trace(UVC_TRACE_FRAME, "Dropping payload (error bit "
-			  "set).\n");
-		return -ENODATA;
-	}
-
 	fid = data[1] & UVC_STREAM_FID;
 
 	/* Increase the sequence number regardless of any buffer states, so
@@ -432,6 +425,13 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		return -ENODATA;
 	}
 
+	/* Mark the buffer as bad if the error bit is set. */
+	if (data[1] & UVC_STREAM_ERR) {
+		uvc_trace(UVC_TRACE_FRAME, "Marking buffer as bad (error bit "
+			  "set).\n");
+		buf->error = 1;
+	}
+
 	/* Synchronize to the input stream by waiting for the FID bit to be
 	 * toggled when the the buffer state is not UVC_BUF_STATE_ACTIVE.
 	 * stream->last_fid is initialized to -1, so the first isochronous
-- 
1.7.3.4

