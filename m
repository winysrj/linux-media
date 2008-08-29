Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TKbtxc011155
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 16:37:56 -0400
Received: from mailrelay012.isp.belgacom.be (mailrelay012.isp.belgacom.be
	[195.238.6.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TKbi0N001716
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 16:37:45 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 29 Aug 2008 22:37:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808292237.44875.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Supress spurious "EOF in empty payload" trace
	message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Pass the payload size instead of the header size to uvc_video_decode_end() to
avoid generating an extra trace message for each frame.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_video.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 6854ac7..0b7fc5d 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -455,7 +455,8 @@ static void uvc_video_decode_isoc(struct urb *urb,
 			urb->iso_frame_desc[i].actual_length - ret);
 
 		/* Process the header again. */
-		uvc_video_decode_end(video, buf, mem, ret);
+		uvc_video_decode_end(video, buf, mem,
+			urb->iso_frame_desc[i].actual_length);
 
 		if (buf->state == UVC_BUF_STATE_DONE ||
 		    buf->state == UVC_BUF_STATE_ERROR)
@@ -512,7 +513,7 @@ static void uvc_video_decode_bulk(struct urb *urb,
 	    video->bulk.payload_size >= video->bulk.max_payload_size) {
 		if (!video->bulk.skip_payload && buf != NULL) {
 			uvc_video_decode_end(video, buf, video->bulk.header,
-				video->bulk.header_size);
+				video->bulk.payload_size);
 			if (buf->state == UVC_BUF_STATE_DONE ||
 			    buf->state == UVC_BUF_STATE_ERROR)
 				buf = uvc_queue_next_buffer(&video->queue, buf);
-- 
1.5.6.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
