Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35255 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753172AbdJQRfV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 13:35:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] uvcvideo: Stream error events carry no data
Date: Tue, 17 Oct 2017 20:35:35 +0300
Message-Id: <20171017173535.8953-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the UVC specification, stream error events carry no data.
Fix a buffer overflow (that should be harmless given data alignment)
when reporting the stream error event by removing the data byte from the
message.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_status.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index f552ab997956..1ef20e74b7ac 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -93,8 +93,9 @@ static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
 			data[1], data[3] ? "pressed" : "released", len);
 		uvc_input_report_key(dev, KEY_CAMERA, data[3]);
 	} else {
-		uvc_trace(UVC_TRACE_STATUS, "Stream %u error event %02x %02x "
-			"len %d.\n", data[1], data[2], data[3], len);
+		uvc_trace(UVC_TRACE_STATUS,
+			  "Stream %u error event %02x len %d.\n",
+			  data[1], data[2], len);
 	}
 }
 
-- 
Regards,

Laurent Pinchart
