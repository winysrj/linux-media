Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39456 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728426AbeJXFwO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 01:52:14 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>, stable@vger.kernel.org
From: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] [bug/urgent] dvb-usb-v2: Fix incorrect use of transfer_flags
 URB_FREE_BUFFER
Message-ID: <04c2de66-ec7f-48db-472b-bdc4cd266cc8@gmail.com>
Date: Tue, 23 Oct 2018 22:26:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In commit 1a0c10ed7b media: dvb-usb-v2: stop using coherent memory for URBs
incorrectly adds URB_FREE_BUFFER after every urb transfer resulting in
no buffers and eventually deadlock.

The stream buffer should remain in constant while in use by user and 
kfree() on their departure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
CC: stable@vger.kernel.org # v4.18+
---
  drivers/media/usb/dvb-usb-v2/usb_urb.c | 5 ++---
  1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c 
b/drivers/media/usb/dvb-usb-v2/usb_urb.c
index 024c751eb165..2ad2ddeaff51 100644
--- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
@@ -155,7 +155,6 @@ static int usb_urb_alloc_bulk_urbs(struct 
usb_data_stream *stream)
  				stream->props.u.bulk.buffersize,
  				usb_urb_complete, stream);

-		stream->urb_list[i]->transfer_flags = URB_FREE_BUFFER;
  		stream->urbs_initialized++;
  	}
  	return 0;
@@ -186,7 +185,7 @@ static int usb_urb_alloc_isoc_urbs(struct 
usb_data_stream *stream)
  		urb->complete = usb_urb_complete;
  		urb->pipe = usb_rcvisocpipe(stream->udev,
  				stream->props.endpoint);
-		urb->transfer_flags = URB_ISO_ASAP | URB_FREE_BUFFER;
+		urb->transfer_flags = URB_ISO_ASAP;
  		urb->interval = stream->props.u.isoc.interval;
  		urb->number_of_packets = stream->props.u.isoc.framesperurb;
  		urb->transfer_buffer_length = stream->props.u.isoc.framesize *
@@ -210,7 +209,7 @@ static int usb_free_stream_buffers(struct 
usb_data_stream *stream)
  	if (stream->state & USB_STATE_URB_BUF) {
  		while (stream->buf_num) {
  			stream->buf_num--;
-			stream->buf_list[stream->buf_num] = NULL;
+			kfree(stream->buf_list[stream->buf_num]);
  		}
  	}

-- 
2.19.1
