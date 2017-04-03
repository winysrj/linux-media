Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751435AbdDCLZm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 07:25:42 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH] uvcvideo: Fix empty packet statistic
Date: Mon,  3 Apr 2017 12:25:32 +0100
Message-Id: <1491218732-12068-2-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

The frame counters are inadvertently counting packets with content as
empty.

Fix it by correcting the logic expression

Fixes: 7bc5edb00bbd [media] uvcvideo: Extract video stream statistics
Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 075a0fe77485..7777ed24908b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -818,7 +818,7 @@ static void uvc_video_stats_decode(struct uvc_streaming *stream,
 
 	/* Update the packets counters. */
 	stream->stats.frame.nb_packets++;
-	if (len > header_size)
+	if (len <= header_size)
 		stream->stats.frame.nb_empty++;
 
 	if (data[1] & UVC_STREAM_ERR)
-- 
2.7.4
