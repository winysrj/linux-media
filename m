Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43625 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaBZNg5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 08:36:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>, stable@vger.kernel.org
Subject: [PATCH v2] uvcvideo: Do not use usb_set_interface on bulk EP
Date: Wed, 26 Feb 2014 14:38:10 +0100
Message-Id: <1393421890-4816-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksij Rempel <linux@rempel-privat.de>

The UVC specification uses alternate setting selection to notify devices
of stream start/stop. This breaks when using bulk-based devices, as the
video streaming interface has a single alternate setting in that case,
making video stream start and video stream stop events to appear
identical to the device. Bulk-based devices are thus not well supported
by UVC.

The webcam built in the Asus Zenbook UX302LA ignores the set interface
request and will keep the video stream enabled when the driver tries to
stop it. If USB autosuspend is enabled the device will then be suspended
and will crash, requiring a cold reboot.

USB trace capture showed that Windows sends a CLEAR_FEATURE(HALT)
request to the bulk endpoint when stopping the stream instead of
selecting alternate setting 0. The camera then behaves correctly, and
thus seems to require that behaviour.

Replace selection of alternate setting 0 with clearing of the endpoint
halt feature at video stream stop for bulk-based devices. Let's refrain
from blaming Microsoft this time, as it's not clear whether this
Windows-specific but USB-compliant behaviour was specifically developed
to handle bulkd-based UVC devices, or if the camera just took advantage
of it.

CC: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_video.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 103cd4e..8d52baf 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1850,7 +1850,25 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 
 	if (!enable) {
 		uvc_uninit_video(stream, 1);
-		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+		if (stream->intf->num_altsetting > 1) {
+			usb_set_interface(stream->dev->udev,
+					  stream->intfnum, 0);
+		} else {
+			/* UVC doesn't specify how to inform a bulk-based device
+			 * when the video stream is stopped. Windows sends a
+			 * CLEAR_FEATURE(HALT) request to the video streaming
+			 * bulk endpoint, mimic the same behaviour.
+			 */
+			unsigned int epnum = stream->header.bEndpointAddress
+					   & USB_ENDPOINT_NUMBER_MASK;
+			unsigned int dir = stream->header.bEndpointAddress
+					 & USB_ENDPOINT_DIR_MASK;
+			unsigned int pipe;
+
+			pipe = usb_sndbulkpipe(stream->dev->udev, epnum) | dir;
+			usb_clear_halt(stream->dev->udev, pipe);
+		}
+
 		uvc_queue_enable(&stream->queue, 0);
 		uvc_video_clock_cleanup(stream);
 		return 0;
-- 
Regards,

Laurent Pinchart

