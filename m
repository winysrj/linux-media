Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52474 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932097AbeFEXqR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 19:46:17 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] uvcvideo: Also validate buffers in BULK mode
Date: Tue,  5 Jun 2018 19:46:07 -0400
Message-Id: <20180605234607.5334-1-nicolas.dufresne@collabora.com>
In-Reply-To: <2206409.jVpTcjFX6j@avalon>
References: <2206409.jVpTcjFX6j@avalon>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like for ISOC, validate the decoded BULK buffer size when possible.
This avoids sending corrupted or partial buffers to userspace, which may
lead to application crash or run-time failure.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/usb/uvc/uvc_video.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index aa0082fe5833..025ffac196f3 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1234,6 +1234,7 @@ static void uvc_video_next_buffers(struct uvc_streaming *stream,
 		*meta_buf = uvc_queue_next_buffer(&stream->meta.queue,
 						  *meta_buf);
 	}
+	uvc_video_validate_buffer(stream, *video_buf);
 	*video_buf = uvc_queue_next_buffer(&stream->queue, *video_buf);
 }
 
@@ -1258,10 +1259,8 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 		do {
 			ret = uvc_video_decode_start(stream, buf, mem,
 				urb->iso_frame_desc[i].actual_length);
-			if (ret == -EAGAIN) {
-				uvc_video_validate_buffer(stream, buf);
+			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
-			}
 		} while (ret == -EAGAIN);
 
 		if (ret < 0)
@@ -1277,10 +1276,8 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 		uvc_video_decode_end(stream, buf, mem,
 			urb->iso_frame_desc[i].actual_length);
 
-		if (buf->state == UVC_BUF_STATE_READY) {
-			uvc_video_validate_buffer(stream, buf);
+		if (buf->state == UVC_BUF_STATE_READY)
 			uvc_video_next_buffers(stream, &buf, &meta_buf);
-		}
 	}
 }
 
-- 
2.17.1
