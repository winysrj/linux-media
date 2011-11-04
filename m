Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52213 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1KDMqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 08:46:18 -0400
Received: from localhost.localdomain (unknown [91.178.160.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id B466D35A00
	for <linux-media@vger.kernel.org>; Fri,  4 Nov 2011 12:46:17 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/6] uvcvideo: Handle uvc_init_video() failure in uvc_video_enable()
Date: Fri,  4 Nov 2011 13:46:12 +0100
Message-Id: <1320410777-14108-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Turn streaming off (by selecting alternate setting 0) and disable the
video buffers queue in the uvc_video_enable() error path.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 2995f26..2e5e728 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -1283,6 +1283,11 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 		return ret;
 	}
 
-	return uvc_init_video(stream, GFP_KERNEL);
-}
+	ret = uvc_init_video(stream, GFP_KERNEL);
+	if (ret < 0) {
+		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+		uvc_queue_enable(&stream->queue, 0);
+	}
 
+	return ret;
+}
-- 
1.7.3.4

