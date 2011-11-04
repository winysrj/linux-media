Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52214 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1KDMqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 08:46:20 -0400
Received: from localhost.localdomain (unknown [91.178.160.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8EA6A35B6F
	for <linux-media@vger.kernel.org>; Fri,  4 Nov 2011 12:46:18 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/6] uvcvideo: Make uvc_commit_video() static
Date: Fri,  4 Nov 2011 13:46:15 +0100
Message-Id: <1320410777-14108-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function is not used outside of its compilation unit. Make it
static.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |    4 ++--
 drivers/media/video/uvc/uvcvideo.h  |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index d8666ec..b953dae 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -351,8 +351,8 @@ done:
 	return ret;
 }
 
-int uvc_commit_video(struct uvc_streaming *stream,
-	struct uvc_streaming_control *probe)
+static int uvc_commit_video(struct uvc_streaming *stream,
+			    struct uvc_streaming_control *probe)
 {
 	return uvc_set_video_ctrl(stream, probe, 0);
 }
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 8448edc..882159a 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -551,8 +551,6 @@ extern int uvc_video_resume(struct uvc_streaming *stream, int reset);
 extern int uvc_video_enable(struct uvc_streaming *stream, int enable);
 extern int uvc_probe_video(struct uvc_streaming *stream,
 		struct uvc_streaming_control *probe);
-extern int uvc_commit_video(struct uvc_streaming *stream,
-		struct uvc_streaming_control *ctrl);
 extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 		__u8 intfnum, __u8 cs, void *data, __u16 size);
 
-- 
1.7.3.4

