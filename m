Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:60017 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932254AbcLYStK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:49:10 -0500
Subject: [PATCH 16/19] [media] uvc_video: Adjust 18 checks for null pointers
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <bdeb697f-4e6a-bf64-112b-907e3c298a29@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:49:01 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 18:26:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_video.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 0ed3453b1c75..617f2090aa55 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -100,7 +100,7 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 		}
 	}
 
-	if (format == NULL)
+	if (!format)
 		return;
 
 	for (i = 0; i < format->nframes; ++i) {
@@ -110,7 +110,7 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 		}
 	}
 
-	if (frame == NULL)
+	if (!frame)
 		return;
 
 	if (!(format->flags & UVC_FMT_FLAG_COMPRESSED) ||
@@ -176,7 +176,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		return -EIO;
 
 	data = kmalloc(size, GFP_KERNEL);
-	if (data == NULL)
+	if (!data)
 		return -ENOMEM;
 
 	ret = __uvc_query_ctrl(stream->dev, query, 0, stream->intfnum,
@@ -260,7 +260,7 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 
 	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
 	data = kzalloc(size, GFP_KERNEL);
-	if (data == NULL)
+	if (!data)
 		return -ENOMEM;
 
 	*(__le16 *)&data[0] = cpu_to_le16(ctrl->bmHint);
@@ -420,7 +420,7 @@ uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 	 *   kernel timestamps and store them with the SCR STC and SOF fields
 	 *   in the ring buffer
 	 */
-	if (has_pts && buf != NULL)
+	if (has_pts && buf)
 		buf->pts = get_unaligned_le32(&data[2]);
 
 	if (!has_scr)
@@ -503,7 +503,7 @@ static int uvc_video_clock_init(struct uvc_streaming *stream)
 	clock->samples = kmalloc_array(clock->size,
 				       sizeof(*clock->samples),
 				       GFP_KERNEL);
-	if (clock->samples == NULL)
+	if (!clock->samples)
 		return -ENOMEM;
 
 	uvc_video_clock_reset(stream);
@@ -994,7 +994,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	/* Store the payload FID bit and return immediately when the buffer is
 	 * NULL.
 	 */
-	if (buf == NULL) {
+	if (!buf) {
 		stream->last_fid = fid;
 		return -ENODATA;
 	}
@@ -1169,7 +1169,7 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 				  "USB isochronous frame lost (%d).\n",
 				  urb->iso_frame_desc[i].status);
 			/* Mark the buffer as faulty. */
-			if (buf != NULL)
+			if (buf)
 				buf->error = 1;
 			continue;
 		}
@@ -1233,7 +1233,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 		} while (ret == -EAGAIN);
 
 		/* If an error occurred skip the rest of the payload. */
-		if (ret < 0 || buf == NULL) {
+		if (ret < 0 || !buf) {
 			stream->bulk.skip_payload = 1;
 		} else {
 			memcpy(stream->bulk.header, mem, ret);
@@ -1250,7 +1250,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	 */
 
 	/* Process video data. */
-	if (!stream->bulk.skip_payload && buf != NULL)
+	if (!stream->bulk.skip_payload && buf)
 		uvc_video_decode_data(stream, buf, mem, len);
 
 	/* Detect the payload end by a URB smaller than the maximum size (or
@@ -1258,7 +1258,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	 */
 	if (urb->actual_length < urb->transfer_buffer_length ||
 	    stream->bulk.payload_size >= stream->bulk.max_payload_size) {
-		if (!stream->bulk.skip_payload && buf != NULL) {
+		if (!stream->bulk.skip_payload && buf) {
 			uvc_video_decode_end(stream, buf, stream->bulk.header,
 				stream->bulk.payload_size);
 			if (buf->state == UVC_BUF_STATE_READY)
@@ -1278,7 +1278,7 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	u8 *mem = urb->transfer_buffer;
 	int len = stream->urb_size, ret;
 
-	if (buf == NULL) {
+	if (!buf) {
 		urb->transfer_buffer_length = 0;
 		return;
 	}
@@ -1450,7 +1450,7 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
 
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = stream->urb[i];
-		if (urb == NULL)
+		if (!urb)
 			continue;
 
 		usb_kill_urb(urb);
@@ -1511,7 +1511,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = usb_alloc_urb(npackets, gfp_flags);
-		if (urb == NULL) {
+		if (!urb) {
 			uvc_uninit_video(stream, 1);
 			return -ENOMEM;
 		}
@@ -1577,7 +1577,7 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = usb_alloc_urb(0, gfp_flags);
-		if (urb == NULL) {
+		if (!urb) {
 			uvc_uninit_video(stream, 1);
 			return -ENOMEM;
 		}
@@ -1641,7 +1641,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 			alts = &intf->altsetting[i];
 			ep = uvc_find_endpoint(alts,
 				stream->header.bEndpointAddress);
-			if (ep == NULL)
+			if (!ep)
 				continue;
 
 			/* Check if the bandwidth is high enough. */
@@ -1653,7 +1653,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 			}
 		}
 
-		if (best_ep == NULL) {
+		if (!best_ep) {
 			uvc_trace(UVC_TRACE_VIDEO,
 				  "No fast enough alt setting for requested bandwidth.\n");
 			return -EIO;
@@ -1671,7 +1671,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		/* Bulk endpoint, proceed to URB initialization. */
 		ep = uvc_find_endpoint(&intf->altsetting[0],
 				stream->header.bEndpointAddress);
-		if (ep == NULL)
+		if (!ep)
 			return -EIO;
 
 		ret = uvc_init_video_bulk(stream, ep, gfp_flags);
-- 
2.11.0

