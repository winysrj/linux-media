Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38886 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbeKJCrL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 21:47:11 -0500
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
Subject: [PATCH v6 06/10] media: uvcvideo: Abstract streaming object lifetime
Date: Fri,  9 Nov 2018 17:05:29 +0000
Message-Id: <207851fbe7c980dee983f5c3587f911457e37f34.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The streaming object is a key part of handling the UVC device. Although
not critical, we are currently missing a call to destroy the mutex on
clean up paths, and we are due to extend the objects complexity in the
near future.

Facilitate easy management of a stream object by creating a pair of
functions to handle creating and destroying the allocation. The new
uvc_stream_delete() function also performs the missing mutex_destroy()
operation.

Previously a failed streaming object allocation would cause
uvc_parse_streaming() to return -EINVAL, which is inappropriate. If the
constructor failes, we will instead return -ENOMEM.

While we're here, fix the trivial spelling error in the function banner
of uvc_delete().

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 54 +++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 67bd58c6f397..afb44d1c9d04 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -396,6 +396,39 @@ static struct uvc_streaming *uvc_stream_by_id(struct uvc_device *dev, int id)
 }
 
 /* ------------------------------------------------------------------------
+ * Streaming Object Management
+ */
+
+static void uvc_stream_delete(struct uvc_streaming *stream)
+{
+	mutex_destroy(&stream->mutex);
+
+	usb_put_intf(stream->intf);
+
+	kfree(stream->format);
+	kfree(stream->header.bmaControls);
+	kfree(stream);
+}
+
+static struct uvc_streaming *uvc_stream_new(struct uvc_device *dev,
+					    struct usb_interface *intf)
+{
+	struct uvc_streaming *stream;
+
+	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
+	if (stream == NULL)
+		return NULL;
+
+	mutex_init(&stream->mutex);
+
+	stream->dev = dev;
+	stream->intf = usb_get_intf(intf);
+	stream->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
+
+	return stream;
+}
+
+/* ------------------------------------------------------------------------
  * Descriptors parsing
  */
 
@@ -687,17 +720,12 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		return -EINVAL;
 	}
 
-	streaming = kzalloc(sizeof(*streaming), GFP_KERNEL);
+	streaming = uvc_stream_new(dev, intf);
 	if (streaming == NULL) {
 		usb_driver_release_interface(&uvc_driver.driver, intf);
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
-	mutex_init(&streaming->mutex);
-	streaming->dev = dev;
-	streaming->intf = usb_get_intf(intf);
-	streaming->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
-
 	/* The Pico iMage webcam has its class-specific interface descriptors
 	 * after the endpoint descriptors.
 	 */
@@ -904,10 +932,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
 error:
 	usb_driver_release_interface(&uvc_driver.driver, intf);
-	usb_put_intf(intf);
-	kfree(streaming->format);
-	kfree(streaming->header.bmaControls);
-	kfree(streaming);
+	uvc_stream_delete(streaming);
 	return ret;
 }
 
@@ -1815,7 +1840,7 @@ static int uvc_scan_device(struct uvc_device *dev)
  * is released.
  *
  * As this function is called after or during disconnect(), all URBs have
- * already been canceled by the USB core. There is no need to kill the
+ * already been cancelled by the USB core. There is no need to kill the
  * interrupt URB manually.
  */
 static void uvc_delete(struct kref *kref)
@@ -1853,10 +1878,7 @@ static void uvc_delete(struct kref *kref)
 		streaming = list_entry(p, struct uvc_streaming, list);
 		usb_driver_release_interface(&uvc_driver.driver,
 			streaming->intf);
-		usb_put_intf(streaming->intf);
-		kfree(streaming->format);
-		kfree(streaming->header.bmaControls);
-		kfree(streaming);
+		uvc_stream_delete(streaming);
 	}
 
 	kfree(dev);
-- 
git-series 0.9.1
