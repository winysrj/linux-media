Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m640aWUv010947
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 20:36:32 -0400
Received: from mailrelay012.isp.belgacom.be (mailrelay012.isp.belgacom.be
	[195.238.6.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m640aMqm020813
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 20:36:22 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 4 Jul 2008 02:36:21 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807040236.21866.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Don't free URB buffers on suspend.
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

All submitted URBs must be killed at suspend time, but URB buffers don't have
to be freed. Avoiding a free on suspend/reallocate on resume lowers the presure
on system memory.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_video.c |   96 +++++++++++++++++++++++------------
 drivers/media/video/uvc/uvcvideo.h  |    2 +
 2 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 8eb5748..817af2e 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -554,9 +554,56 @@ static void uvc_video_complete(struct urb *urb)
 }
 
 /*
+ * Free transfer buffers.
+ */
+static void uvc_free_urb_buffers(struct uvc_video_device *video)
+{
+	unsigned int i;
+
+	for (i = 0; i < UVC_URBS; ++i) {
+		if (video->urb_buffer[i]) {
+			usb_buffer_free(video->dev->udev, video->urb_size,
+				video->urb_buffer[i], video->urb_dma[i]);
+			video->urb_buffer[i] = NULL;
+		}
+	}
+
+	video->urb_size = 0;
+}
+
+/*
+ * Allocate transfer buffers. This function can be called with buffers
+ * already allocated when resuming from suspend, in which case it will
+ * return without touching the buffers.
+ *
+ * Return 0 on success or -ENOMEM when out of memory.
+ */
+static int uvc_alloc_urb_buffers(struct uvc_video_device *video,
+	unsigned int size)
+{
+	unsigned int i;
+
+	/* Buffers are already allocated, bail out. */
+	if (video->urb_size)
+		return 0;
+
+	for (i = 0; i < UVC_URBS; ++i) {
+		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
+			size, GFP_KERNEL, &video->urb_dma[i]);
+		if (video->urb_buffer[i] == NULL) {
+			uvc_free_urb_buffers(video);
+			return -ENOMEM;
+		}
+	}
+
+	video->urb_size = size;
+	return 0;
+}
+
+/*
  * Uninitialize isochronous/bulk URBs and free transfer buffers.
  */
-static void uvc_uninit_video(struct uvc_video_device *video)
+static void uvc_uninit_video(struct uvc_video_device *video, int free_buffers)
 {
 	struct urb *urb;
 	unsigned int i;
@@ -566,19 +613,12 @@ static void uvc_uninit_video(struct uvc_video_device *video)
 			continue;
 
 		usb_kill_urb(urb);
-		/* urb->transfer_buffer_length is not touched by USB core, so
-		 * we can use it here as the buffer length.
-		 */
-		if (video->urb_buffer[i]) {
-			usb_buffer_free(video->dev->udev,
-				urb->transfer_buffer_length,
-				video->urb_buffer[i], urb->transfer_dma);
-			video->urb_buffer[i] = NULL;
-		}
-
 		usb_free_urb(urb);
 		video->urb[i] = NULL;
 	}
+
+	if (free_buffers)
+		uvc_free_urb_buffers(video);
 }
 
 /*
@@ -610,18 +650,13 @@ static int uvc_init_video_isoc(struct uvc_video_device *video,
 
 	size = npackets * psize;
 
+	if (uvc_alloc_urb_buffers(video, size) < 0)
+		return -ENOMEM;
+
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
-			uvc_uninit_video(video);
-			return -ENOMEM;
-		}
-
-		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
-			size, gfp_flags, &urb->transfer_dma);
-		if (video->urb_buffer[i] == NULL) {
-			usb_free_urb(urb);
-			uvc_uninit_video(video);
+			uvc_uninit_video(video, 1);
 			return -ENOMEM;
 		}
 
@@ -632,6 +667,7 @@ static int uvc_init_video_isoc(struct uvc_video_device *video,
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->interval = ep->desc.bInterval;
 		urb->transfer_buffer = video->urb_buffer[i];
+		urb->transfer_dma = video->urb_dma[i];
 		urb->complete = uvc_video_complete;
 		urb->number_of_packets = npackets;
 		urb->transfer_buffer_length = size;
@@ -671,20 +707,15 @@ static int uvc_init_video_bulk(struct uvc_video_device *video,
 	if (size > psize * UVC_MAX_ISO_PACKETS)
 		size = psize * UVC_MAX_ISO_PACKETS;
 
+	if (uvc_alloc_urb_buffers(video, size) < 0)
+		return -ENOMEM;
+
 	pipe = usb_rcvbulkpipe(video->dev->udev, ep->desc.bEndpointAddress);
 
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
-			uvc_uninit_video(video);
-			return -ENOMEM;
-		}
-
-		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
-			size, gfp_flags, &urb->transfer_dma);
-		if (video->urb_buffer[i] == NULL) {
-			usb_free_urb(urb);
-			uvc_uninit_video(video);
+			uvc_uninit_video(video, 1);
 			return -ENOMEM;
 		}
 
@@ -692,6 +723,7 @@ static int uvc_init_video_bulk(struct uvc_video_device *video,
 			video->urb_buffer[i], size, uvc_video_complete,
 			video);
 		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_dma = video->urb_dma[i];
 
 		video->urb[i] = urb;
 	}
@@ -766,7 +798,7 @@ static int uvc_init_video(struct uvc_video_device *video, gfp_t gfp_flags)
 		if ((ret = usb_submit_urb(video->urb[i], gfp_flags)) < 0) {
 			uvc_printk(KERN_ERR, "Failed to submit URB %u "
 					"(%d).\n", i, ret);
-			uvc_uninit_video(video);
+			uvc_uninit_video(video, 1);
 			return ret;
 		}
 	}
@@ -791,7 +823,7 @@ int uvc_video_suspend(struct uvc_video_device *video)
 		return 0;
 
 	video->frozen = 1;
-	uvc_uninit_video(video);
+	uvc_uninit_video(video, 0);
 	usb_set_interface(video->dev->udev, video->streaming->intfnum, 0);
 	return 0;
 }
@@ -920,7 +952,7 @@ int uvc_video_enable(struct uvc_video_device *video, int enable)
 	int ret;
 
 	if (!enable) {
-		uvc_uninit_video(video);
+		uvc_uninit_video(video, 1);
 		usb_set_interface(video->dev->udev,
 			video->streaming->intfnum, 0);
 		uvc_queue_enable(&video->queue, 0);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index a995a78..2444b8a 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -602,6 +602,8 @@ struct uvc_video_device {
 
 	struct urb *urb[UVC_URBS];
 	char *urb_buffer[UVC_URBS];
+	dma_addr_t urb_dma[UVC_URBS];
+	unsigned int urb_size;
 
 	__u8 last_fid;
 };
-- 
1.5.4.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
