Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52214 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1KDMqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 08:46:19 -0400
Received: from localhost.localdomain (unknown [91.178.160.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 016E735B6D
	for <linux-media@vger.kernel.org>; Fri,  4 Nov 2011 12:46:17 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/6] uvcvideo: Remove duplicate definitions of UVC_STREAM_* macros
Date: Fri,  4 Nov 2011 13:46:13 +0100
Message-Id: <1320410777-14108-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The macros are defined in both drivers/media/video/uvc/uvc_video.c and
include/linux/usb/video.h. Remove definitions from the former.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 2e5e728..d8666ec 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -361,16 +361,6 @@ int uvc_commit_video(struct uvc_streaming *stream,
  * Video codecs
  */
 
-/* Values for bmHeaderInfo (Video and Still Image Payload Headers, 2.4.3.3) */
-#define UVC_STREAM_EOH	(1 << 7)
-#define UVC_STREAM_ERR	(1 << 6)
-#define UVC_STREAM_STI	(1 << 5)
-#define UVC_STREAM_RES	(1 << 4)
-#define UVC_STREAM_SCR	(1 << 3)
-#define UVC_STREAM_PTS	(1 << 2)
-#define UVC_STREAM_EOF	(1 << 1)
-#define UVC_STREAM_FID	(1 << 0)
-
 /* Video payload decoding is handled by uvc_video_decode_start(),
  * uvc_video_decode_data() and uvc_video_decode_end().
  *
-- 
1.7.3.4

