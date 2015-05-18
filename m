Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58505 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbbERHxj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 03:53:39 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 3BED720061
	for <linux-media@vger.kernel.org>; Mon, 18 May 2015 09:53:30 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: uvcvideo: Fix incorrect bandwidth with Chicony device 04f2:b50b
Date: Mon, 18 May 2015 10:53:48 +0300
Message-Id: <1431935628-10216-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "TOSHIBA Web Camera - 5M" Chicony device (04f2:b50b) seems to
compute the bandwidth on 16 bits and erroneously sign-extend it to
32 bits, resulting in a huge bandwidth value. Detect and fix that
condition by setting the 16 MSBs to 0 when they're all equal to 1.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index dd2373f..25ea8cf 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -119,6 +119,14 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 		ctrl->dwMaxVideoFrameSize =
 			frame->dwMaxVideoFrameBufferSize;
 
+	/* The "TOSHIBA Web Camera - 5M" Chicony device (04f2:b50b) seems to
+	 * compute the bandwidth on 16 bits and erroneously sign-extend it to
+	 * 32 bits, resulting in a huge bandwidth value. Detect and fix that
+	 * condition by setting the 16 MSBs to 0 when they're all equal to 1.
+	 */
+	if ((ctrl->dwMaxPayloadTransferSize & 0xffff0000) == 0xffff0000)
+		ctrl->dwMaxPayloadTransferSize &= ~0xffff0000;
+
 	if (!(format->flags & UVC_FMT_FLAG_COMPRESSED) &&
 	    stream->dev->quirks & UVC_QUIRK_FIX_BANDWIDTH &&
 	    stream->intf->num_altsetting > 1) {
-- 
Regards,

Laurent Pinchart

