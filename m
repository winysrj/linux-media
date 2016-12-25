Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:55972 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753678AbcLYSka (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:40:30 -0500
Subject: [PATCH 09/19] [media] uvc_driver: Less function calls in
 uvc_parse_streaming() after error detection
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <b417f723-d79b-dc46-0a2e-275c9f700a84@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:40:21 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 15:45:31 +0100

The kfree() function was called in a few cases by the uvc_parse_streaming()
function during error handling even if the passed data structure member
contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Fixes: c0efd232929c2cd87238de2cccdaf4e845be5b0c ("V4L/DVB (8145a): USB Video Class driver")

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index c4e954aecdd5..b0833902fde2 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -702,7 +702,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	if (buflen <= 2) {
 		uvc_trace(UVC_TRACE_DESCR,
 			  "no class-specific streaming interface descriptors found.\n");
-		goto error;
+		goto release_interface;
 	}
 
 	/* Parse the header descriptor. */
@@ -721,7 +721,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		uvc_trace(UVC_TRACE_DESCR,
 			  "device %d videostreaming interface %d HEADER descriptor not found.\n",
 			  dev->udev->devnum, alts->desc.bInterfaceNumber);
-		goto error;
+		goto release_interface;
 	}
 
 	p = buflen >= 4 ? buffer[3] : 0;
@@ -731,7 +731,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		uvc_trace(UVC_TRACE_DESCR,
 			  "device %d videostreaming interface %d HEADER descriptor is invalid.\n",
 			  dev->udev->devnum, alts->desc.bInterfaceNumber);
-		goto error;
+		goto release_interface;
 	}
 
 	streaming->header.bNumFormats = p;
@@ -751,7 +751,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 						GFP_KERNEL);
 	if (!streaming->header.bmaControls) {
 		ret = -ENOMEM;
-		goto error;
+		goto release_interface;
 	}
 
 	buflen -= buffer[0];
@@ -809,7 +809,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		uvc_trace(UVC_TRACE_DESCR,
 			  "device %d videostreaming interface %d has no supported formats defined.\n",
 			  dev->udev->devnum, alts->desc.bInterfaceNumber);
-		goto error;
+		goto release_interface;
 	}
 
 	size = nformats * sizeof(*format) + nframes * sizeof(*frame)
@@ -817,7 +817,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	format = kzalloc(size, GFP_KERNEL);
 	if (!format) {
 		ret = -ENOMEM;
-		goto error;
+		goto free_controls;
 	}
 
 	frame = (struct uvc_frame *)&format[nformats];
@@ -837,7 +837,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 			ret = uvc_parse_format(dev, streaming, format,
 				&interval, buffer, buflen);
 			if (ret < 0)
-				goto error;
+				goto free_format;
 
 			frame += format->nframes;
 			format++;
@@ -878,12 +878,13 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
 	list_add_tail(&streaming->list, &dev->streams);
 	return 0;
-
-error:
-	usb_driver_release_interface(&uvc_driver.driver, intf);
-	usb_put_intf(intf);
+free_format:
 	kfree(streaming->format);
+free_controls:
 	kfree(streaming->header.bmaControls);
+release_interface:
+	usb_driver_release_interface(&uvc_driver.driver, intf);
+	usb_put_intf(intf);
 	kfree(streaming);
 	return ret;
 }
-- 
2.11.0

