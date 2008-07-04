Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m640ZVF2010669
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 20:35:31 -0400
Received: from mailrelay012.isp.belgacom.be (mailrelay012.isp.belgacom.be
	[195.238.6.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m640ZQdb020339
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 20:35:27 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 4 Jul 2008 02:35:26 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807040235.26808.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Use GFP_NOIO when allocating memory during resume
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

The swap device might still be asleep, so memory allocated in the resume
handler must use GFP_NOIO. Thanks to Oliver Neukum for catching and reporting
this bug.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_status.c |    2 +-
 drivers/media/video/uvc/uvc_video.c  |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_status.c b/drivers/media/video/uvc/uvc_status.c
index be9084e..06b4798 100644
--- a/drivers/media/video/uvc/uvc_status.c
+++ b/drivers/media/video/uvc/uvc_status.c
@@ -203,5 +203,5 @@ int uvc_status_resume(struct uvc_device *dev)
 	if (dev->int_urb == NULL)
 		return 0;
 
-	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
+	return usb_submit_urb(dev->int_urb, GFP_NOIO);
 }
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 6faf1fb..8eb5748 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -586,7 +586,7 @@ static void uvc_uninit_video(struct uvc_video_device *video)
  * is given by the endpoint.
  */
 static int uvc_init_video_isoc(struct uvc_video_device *video,
-	struct usb_host_endpoint *ep)
+	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
 	unsigned int npackets, i, j;
@@ -611,14 +611,14 @@ static int uvc_init_video_isoc(struct uvc_video_device *video,
 	size = npackets * psize;
 
 	for (i = 0; i < UVC_URBS; ++i) {
-		urb = usb_alloc_urb(npackets, GFP_KERNEL);
+		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
 			uvc_uninit_video(video);
 			return -ENOMEM;
 		}
 
 		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
-			size, GFP_KERNEL, &urb->transfer_dma);
+			size, gfp_flags, &urb->transfer_dma);
 		if (video->urb_buffer[i] == NULL) {
 			usb_free_urb(urb);
 			uvc_uninit_video(video);
@@ -652,7 +652,7 @@ static int uvc_init_video_isoc(struct uvc_video_device *video,
  * given by the endpoint.
  */
 static int uvc_init_video_bulk(struct uvc_video_device *video,
-	struct usb_host_endpoint *ep)
+	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
 	unsigned int pipe, i;
@@ -674,14 +674,14 @@ static int uvc_init_video_bulk(struct uvc_video_device *video,
 	pipe = usb_rcvbulkpipe(video->dev->udev, ep->desc.bEndpointAddress);
 
 	for (i = 0; i < UVC_URBS; ++i) {
-		urb = usb_alloc_urb(0, GFP_KERNEL);
+		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
 			uvc_uninit_video(video);
 			return -ENOMEM;
 		}
 
 		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
-			size, GFP_KERNEL, &urb->transfer_dma);
+			size, gfp_flags, &urb->transfer_dma);
 		if (video->urb_buffer[i] == NULL) {
 			usb_free_urb(urb);
 			uvc_uninit_video(video);
@@ -702,7 +702,7 @@ static int uvc_init_video_bulk(struct uvc_video_device *video,
 /*
  * Initialize isochronous/bulk URBs and allocate transfer buffers.
  */
-static int uvc_init_video(struct uvc_video_device *video)
+static int uvc_init_video(struct uvc_video_device *video, gfp_t gfp_flags)
 {
 	struct usb_interface *intf = video->streaming->intf;
 	struct usb_host_interface *alts;
@@ -747,7 +747,7 @@ static int uvc_init_video(struct uvc_video_device *video)
 		if ((ret = usb_set_interface(video->dev->udev, intfnum, i)) < 0)
 			return ret;
 
-		ret = uvc_init_video_isoc(video, ep);
+		ret = uvc_init_video_isoc(video, ep, gfp_flags);
 	} else {
 		/* Bulk endpoint, proceed to URB initialization. */
 		ep = uvc_find_endpoint(&intf->altsetting[0],
@@ -755,7 +755,7 @@ static int uvc_init_video(struct uvc_video_device *video)
 		if (ep == NULL)
 			return -EIO;
 
-		ret = uvc_init_video_bulk(video, ep);
+		ret = uvc_init_video_bulk(video, ep, gfp_flags);
 	}
 
 	if (ret < 0)
@@ -763,7 +763,7 @@ static int uvc_init_video(struct uvc_video_device *video)
 
 	/* Submit the URBs. */
 	for (i = 0; i < UVC_URBS; ++i) {
-		if ((ret = usb_submit_urb(video->urb[i], GFP_KERNEL)) < 0) {
+		if ((ret = usb_submit_urb(video->urb[i], gfp_flags)) < 0) {
 			uvc_printk(KERN_ERR, "Failed to submit URB %u "
 					"(%d).\n", i, ret);
 			uvc_uninit_video(video);
@@ -818,7 +818,7 @@ int uvc_video_resume(struct uvc_video_device *video)
 	if (!uvc_queue_streaming(&video->queue))
 		return 0;
 
-	if ((ret = uvc_init_video(video)) < 0)
+	if ((ret = uvc_init_video(video, GFP_NOIO)) < 0)
 		uvc_queue_enable(&video->queue, 0);
 
 	return ret;
@@ -930,5 +930,5 @@ int uvc_video_enable(struct uvc_video_device *video, int enable)
 	if ((ret = uvc_queue_enable(&video->queue, 1)) < 0)
 		return ret;
 
-	return uvc_init_video(video);
+	return uvc_init_video(video, GFP_KERNEL);
 }
-- 
1.5.4.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
