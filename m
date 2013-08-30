Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:37997 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3H3CRx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:53 -0400
Received: by mail-pb0-f51.google.com with SMTP id jt11so1226978pbb.24
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:52 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 15/19] uvcvideo: Add support for VP8 special frame flags.
Date: Fri, 30 Aug 2013 11:17:14 +0900
Message-Id: <1377829038-4726-16-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_video.c | 18 +++++++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h  | 10 ++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 59f57a2..0291817 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1136,6 +1136,8 @@ static int uvc_video_parse_header(struct uvc_streaming *stream,
 	if (header->has_scr)
 		header->length += 6;
 
+	header->buf_flags = 0;
+
 	if (stream->cur_format->fcc == V4L2_PIX_FMT_VP8) {
 		/* VP8 payload has 2 additional bytes of BFH. */
 		header->length += 2;
@@ -1147,6 +1149,16 @@ static int uvc_video_parse_header(struct uvc_streaming *stream,
 		header->has_sli = data[1] & UVC_STREAM_SLI;
 		if (header->has_sli)
 			header->length += 2;
+
+		/* Codec-specific flags for v4l2_buffer. */
+		header->buf_flags |= (data[1] & UVC_STREAM_STI) ?
+					V4L2_BUF_FLAG_KEYFRAME : 0;
+		header->buf_flags |= (data[2] & UVC_STREAM_VP8_PRF) ?
+					V4L2_BUF_FLAG_PREV_FRAME : 0;
+		header->buf_flags |= (data[2] & UVC_STREAM_VP8_ARF) ?
+					V4L2_BUF_FLAG_ALTREF_FRAME : 0;
+		header->buf_flags |= (data[2] & UVC_STREAM_VP8_GRF) ?
+					V4L2_BUF_FLAG_GOLDEN_FRAME : 0;
 	}
 
 	/* - bHeaderLength value can't be larger than the packet size. */
@@ -1222,6 +1234,8 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream)
 		if (ret < 0)
 			continue;
 
+		buf->buf.v4l2_buf.flags |= header.buf_flags;
+
 		/* Decode the payload data. */
 		uvc_video_decode_data(stream, buf, mem + header.length,
 			urb->iso_frame_desc[i].actual_length - header.length);
@@ -1293,8 +1307,10 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream)
 	 */
 
 	/* Process video data. */
-	if (!stream->bulk.skip_payload && buf != NULL)
+	if (!stream->bulk.skip_payload && buf != NULL) {
 		uvc_video_decode_data(stream, buf, mem, len);
+		buf->buf.v4l2_buf.flags |= header.buf_flags;
+	}
 
 	/* Detect the payload end by a URB smaller than the maximum size (or
 	 * a payload size equal to the maximum) and process the header again.
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index b355b2c..fb21459 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -145,6 +145,14 @@
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
 #define UVC_FMT_FLAG_STREAM		0x00000002
 
+/* v4l2_buffer codec flags */
+#define UVC_V4L2_BUFFER_CODEC_FLAGS	(V4L2_BUF_FLAG_KEYFRAME | \
+					 V4L2_BUF_FLAG_PFRAME | \
+					 V4L2_BUF_FLAG_BFRAME | \
+					 V4L2_BUF_FLAG_PREV_FRAME | \
+					 V4L2_BUF_FLAG_GOLDEN_FRAME | \
+					 V4L2_BUF_FLAG_ALTREF_FRAME)
+
 /* ------------------------------------------------------------------------
  * Structures.
  */
@@ -472,6 +480,8 @@ struct uvc_payload_header {
 
 	int length;
 	int payload_size;
+
+	__u32 buf_flags; /* v4l2_buffer flags */
 };
 
 struct uvc_streaming {
-- 
1.8.4

