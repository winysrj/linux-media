Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38888 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbeKJCrN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 21:47:13 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Tomasz Figa <tfiga@google.com>,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: [PATCH v6 09/10] media: uvcvideo: Rename uvc_{un,}init_video()
Date: Fri,  9 Nov 2018 17:05:32 +0000
Message-Id: <c5f36d543bb234e1ade29537585202f008791d7e.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have both uvc_init_video() and uvc_video_init() calls which can be
quite confusing to determine the process for each. Now that video
uvc_video_enable() has been renamed to uvc_video_start_streaming(),
adapt these calls to suit the new flow.

Rename uvc_init_video() to uvc_video_start() and uvc_uninit_video() to
uvc_video_stop().

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

---

v6:
 - Append _transfer to {_stop,_start}

 drivers/media/usb/uvc/uvc_video.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index cd67506dc696..a81012c65280 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1641,7 +1641,8 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 /*
  * Uninitialize isochronous/bulk URBs and free transfer buffers.
  */
-static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
+static void uvc_video_stop_transfer(struct uvc_streaming *stream,
+				    int free_buffers)
 {
 	struct uvc_urb *uvc_urb;
 
@@ -1718,7 +1719,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
-			uvc_uninit_video(stream, 1);
+			uvc_video_stop_transfer(stream, 1);
 			return -ENOMEM;
 		}
 
@@ -1786,7 +1787,7 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 
 		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
-			uvc_uninit_video(stream, 1);
+			uvc_video_stop_transfer(stream, 1);
 			return -ENOMEM;
 		}
 
@@ -1806,7 +1807,8 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 /*
  * Initialize isochronous/bulk URBs and allocate transfer buffers.
  */
-static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
+static int uvc_video_start_transfer(struct uvc_streaming *stream,
+				    gfp_t gfp_flags)
 {
 	struct usb_interface *intf = stream->intf;
 	struct usb_host_endpoint *ep;
@@ -1894,7 +1896,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		if (ret < 0) {
 			uvc_printk(KERN_ERR, "Failed to submit URB %u "
 					"(%d).\n", i, ret);
-			uvc_uninit_video(stream, 1);
+			uvc_video_stop_transfer(stream, 1);
 			return ret;
 		}
 	}
@@ -1925,7 +1927,7 @@ int uvc_video_suspend(struct uvc_streaming *stream)
 		return 0;
 
 	stream->frozen = 1;
-	uvc_uninit_video(stream, 0);
+	uvc_video_stop_transfer(stream, 0);
 	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
 	return 0;
 }
@@ -1961,7 +1963,7 @@ int uvc_video_resume(struct uvc_streaming *stream, int reset)
 	if (ret < 0)
 		return ret;
 
-	return uvc_init_video(stream, GFP_NOIO);
+	return uvc_video_start_transfer(stream, GFP_NOIO);
 }
 
 /* ------------------------------------------------------------------------
@@ -2089,7 +2091,7 @@ int uvc_video_start_streaming(struct uvc_streaming *stream)
 	if (ret < 0)
 		goto error_commit;
 
-	ret = uvc_init_video(stream, GFP_KERNEL);
+	ret = uvc_video_start_transfer(stream, GFP_KERNEL);
 	if (ret < 0)
 		goto error_video;
 
@@ -2105,7 +2107,7 @@ int uvc_video_start_streaming(struct uvc_streaming *stream)
 
 int uvc_video_stop_streaming(struct uvc_streaming *stream)
 {
-	uvc_uninit_video(stream, 1);
+	uvc_video_stop_transfer(stream, 1);
 	if (stream->intf->num_altsetting > 1) {
 		usb_set_interface(stream->dev->udev,
 				  stream->intfnum, 0);
-- 
git-series 0.9.1
