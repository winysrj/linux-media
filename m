Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45460 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbeFEAYX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 20:24:23 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] uvcvideo: Also validate buffers in BULK mode
Date: Mon,  4 Jun 2018 20:24:15 -0400
Message-Id: <20180605002415.11421-1-nicolas.dufresne@collabora.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like for ISOC, validate the decoded BULK buffer size when possible.
This avoids sending corrupted or partial buffers to userspace, which may
lead to application crash or run-time failure.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/usb/uvc/uvc_video.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index aa0082fe5833..46df4d01e31b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1307,8 +1307,10 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
 		do {
 			ret = uvc_video_decode_start(stream, buf, mem, len);
-			if (ret == -EAGAIN)
+			if (ret == -EAGAIN) {
+				uvc_video_validate_buffer(stream, buf);
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
+			}
 		} while (ret == -EAGAIN);
 
 		/* If an error occurred skip the rest of the payload. */
@@ -1342,8 +1344,10 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 		if (!stream->bulk.skip_payload && buf != NULL) {
 			uvc_video_decode_end(stream, buf, stream->bulk.header,
 				stream->bulk.payload_size);
-			if (buf->state == UVC_BUF_STATE_READY)
+			if (buf->state == UVC_BUF_STATE_READY) {
+				uvc_video_validate_buffer(stream, buf);
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
+			}
 		}
 
 		stream->bulk.header_size = 0;
-- 
2.17.1
