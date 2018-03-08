Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41638 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752173AbeCHTJJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 14:09:09 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] media: dvb-usb-v2: stop using coherent memory for URBs
Date: Thu,  8 Mar 2018 16:09:03 -0300
Message-Id: <6a131c6ca8afe5d000b9cbfadff96ea72f200852.1520536139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to use coherent buffers there. So, let the
DVB core do the allocation. That should give some performance
gain outside x86.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb-v2/usb_urb.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c b/drivers/media/usb/dvb-usb-v2/usb_urb.c
index dce2b97efce4..b0499f95ec45 100644
--- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
@@ -155,8 +155,7 @@ static int usb_urb_alloc_bulk_urbs(struct usb_data_stream *stream)
 				stream->props.u.bulk.buffersize,
 				usb_urb_complete, stream);
 
-		stream->urb_list[i]->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
-		stream->urb_list[i]->transfer_dma = stream->dma_addr[i];
+		stream->urb_list[i]->transfer_flags = URB_FREE_BUFFER;
 		stream->urbs_initialized++;
 	}
 	return 0;
@@ -187,13 +186,12 @@ static int usb_urb_alloc_isoc_urbs(struct usb_data_stream *stream)
 		urb->complete = usb_urb_complete;
 		urb->pipe = usb_rcvisocpipe(stream->udev,
 				stream->props.endpoint);
-		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_flags = URB_ISO_ASAP | URB_FREE_BUFFER;
 		urb->interval = stream->props.u.isoc.interval;
 		urb->number_of_packets = stream->props.u.isoc.framesperurb;
 		urb->transfer_buffer_length = stream->props.u.isoc.framesize *
 				stream->props.u.isoc.framesperurb;
 		urb->transfer_buffer = stream->buf_list[i];
-		urb->transfer_dma = stream->dma_addr[i];
 
 		for (j = 0; j < stream->props.u.isoc.framesperurb; j++) {
 			urb->iso_frame_desc[j].offset = frame_offset;
@@ -212,11 +210,7 @@ static int usb_free_stream_buffers(struct usb_data_stream *stream)
 	if (stream->state & USB_STATE_URB_BUF) {
 		while (stream->buf_num) {
 			stream->buf_num--;
-			dev_dbg(&stream->udev->dev, "%s: free buf=%d\n",
-				__func__, stream->buf_num);
-			usb_free_coherent(stream->udev, stream->buf_size,
-					  stream->buf_list[stream->buf_num],
-					  stream->dma_addr[stream->buf_num]);
+			stream->buf_list[stream->buf_num] = NULL;
 		}
 	}
 
@@ -236,9 +230,7 @@ static int usb_alloc_stream_buffers(struct usb_data_stream *stream, int num,
 			__func__,  num * size);
 
 	for (stream->buf_num = 0; stream->buf_num < num; stream->buf_num++) {
-		stream->buf_list[stream->buf_num] = usb_alloc_coherent(
-				stream->udev, size, GFP_ATOMIC,
-				&stream->dma_addr[stream->buf_num]);
+		stream->buf_list[stream->buf_num] = kzalloc(size, GFP_ATOMIC);
 		if (!stream->buf_list[stream->buf_num]) {
 			dev_dbg(&stream->udev->dev, "%s: alloc buf=%d failed\n",
 					__func__, stream->buf_num);
@@ -250,7 +242,6 @@ static int usb_alloc_stream_buffers(struct usb_data_stream *stream, int num,
 				__func__, stream->buf_num,
 				stream->buf_list[stream->buf_num],
 				(long long)stream->dma_addr[stream->buf_num]);
-		memset(stream->buf_list[stream->buf_num], 0, size);
 		stream->state |= USB_STATE_URB_BUF;
 	}
 
-- 
2.14.3
