Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:42757 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbeANJWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 04:22:02 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@s-opensource.com, arnd@arndb.de,
        jasmin@anw.at
Subject: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
Date: Sun, 14 Jan 2018 10:21:43 +0000
Message-Id: <1515925303-5160-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Commit 828ee8c71950 ("media: uvcvideo: Use ktime_t for timestamps")
changed to use ktime_t for timestamps. Older Kernels use a struct for
ktime_t, which requires the conversion function ktime_to_ns to be used on
some places. With this patch it will compile now also for older Kernel
versions.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/usb/uvc/uvc_video.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 5441553..1670aeb 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1009,7 +1009,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 
 		buf->buf.field = V4L2_FIELD_NONE;
 		buf->buf.sequence = stream->sequence;
-		buf->buf.vb2_buf.timestamp = uvc_video_get_time();
+		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
@@ -1191,7 +1191,8 @@ static void uvc_video_decode_meta(struct uvc_streaming *stream,
 
 	uvc_trace(UVC_TRACE_FRAME,
 		  "%s(): t-sys %lluns, SOF %u, len %u, flags 0x%x, PTS %u, STC %u frame SOF %u\n",
-		  __func__, time, meta->sof, meta->length, meta->flags,
+		  __func__, ktime_to_ns(time), meta->sof, meta->length,
+		  meta->flags,
 		  has_pts ? *(u32 *)meta->buf : 0,
 		  has_scr ? *(u32 *)scr : 0,
 		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
-- 
2.7.4
