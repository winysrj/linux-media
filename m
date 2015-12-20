Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37005 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbbLTL5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2015 06:57:25 -0500
Received: by mail-wm0-f41.google.com with SMTP id p187so37610104wmp.0
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2015 03:57:24 -0800 (PST)
Date: Sun, 20 Dec 2015 12:57:17 +0100
From: Nikola =?UTF-8?B?Rm9ycsOz?= <nikola.forro@gmail.com>
To: linux-media@vger.kernel.org
Cc: lkundrak@v3.sk
Subject: [PATCH] usbtv: discard redundant video fields
Message-ID: <20151220125717.376e7903@urna>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are many dropped fields with some sources, leading to many
redundant fields without counterparts. When this redundant field
is odd, a new frame is pushed containing this odd field interleaved
with whatever was left in the buffer, causing video artifacts.

Do not push a new frame after processing every odd field, but do it
only after those which come after an even field.

Signed-off-by: Nikola Forró <nikola.forro@gmail.com>
---
 drivers/media/usb/usbtv/usbtv-video.c | 33 +++++++++++++++++++--------------
 drivers/media/usb/usbtv/usbtv.h       |  1 +
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index e645c9d..a20fd60 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -312,20 +312,24 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
        usbtv_chunk_to_vbuf(frame, &chunk[1], chunk_no, odd);
        usbtv->chunks_done++;
 
-       /* Last chunk in a frame, signalling an end */
-       if (odd && chunk_no == usbtv->n_chunks-1) {
-               int size = vb2_plane_size(&buf->vb.vb2_buf, 0);
-               enum vb2_buffer_state state = usbtv->chunks_done ==
-                                               usbtv->n_chunks ?
-                                               VB2_BUF_STATE_DONE :
-                                               VB2_BUF_STATE_ERROR;
-
-               buf->vb.field = V4L2_FIELD_INTERLACED;
-               buf->vb.sequence = usbtv->sequence++;
-               v4l2_get_timestamp(&buf->vb.timestamp);
-               vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
-               vb2_buffer_done(&buf->vb.vb2_buf, state);
-               list_del(&buf->list);
+       /* Last chunk in a field */
+       if (chunk_no == usbtv->n_chunks-1) {
+               /* Last chunk in a frame, signalling an end */
+               if (odd && !usbtv->last_odd) {
+                       int size = vb2_plane_size(&buf->vb.vb2_buf, 0);
+                       enum vb2_buffer_state state = usbtv->chunks_done ==
+                                                       usbtv->n_chunks ?
+                                                       VB2_BUF_STATE_DONE :
+                                                       VB2_BUF_STATE_ERROR;
+
+                       buf->vb.field = V4L2_FIELD_INTERLACED;
+                       buf->vb.sequence = usbtv->sequence++;
+                       v4l2_get_timestamp(&buf->vb.timestamp);
+                       vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
+                       vb2_buffer_done(&buf->vb.vb2_buf, state);
+                       list_del(&buf->list);
+               }
+               usbtv->last_odd = odd;
        }
 
        spin_unlock_irqrestore(&usbtv->buflock, flags);
@@ -640,6 +644,7 @@ static int usbtv_start_streaming(struct vb2_queue *vq, unsigned int count)
        if (usbtv->udev == NULL)
                return -ENODEV;
 
+       usbtv->last_odd = 1;
        usbtv->sequence = 0;
        return usbtv_start(usbtv);
 }
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index 19cb8bf..161b38d 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -95,6 +95,7 @@ struct usbtv {
        int width, height;
        int n_chunks;
        int iso_size;
+       int last_odd;
        unsigned int sequence;
        struct urb *isoc_urbs[USBTV_ISOC_TRANSFERS];
 
-- 
2.6.4
