Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18801 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdH1GNT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 02:13:19 -0400
From: Hans Yang <hansy@nvidia.com>
To: <laurent.pinchart@ideasonboard.com>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hans Yang <hansy@nvidia.com>
Subject: [PATCH] [media] uvcvideo: zero seq number when disabling stream
Date: Mon, 28 Aug 2017 14:11:59 +0800
Message-ID: <1503900719-13165-1-git-send-email-hansy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For bulk-based devices, when disabling the video stream,
in addition to issue CLEAR_FEATURE(HALT), it is better to set
alternate setting 0 as well or the sequnce number in host
side will probably not reset to zero.

Then in next time video stream start, the device will expect
host starts packet from 0 sequence number but host actually
continue the sequence number from last transaction and this
causes transaction errors.

This commit fixes this by adding set alternate setting 0 back
as what isoch-based devices do.

Below error message will also be eliminated for some devices:
uvcvideo: Non-zero status (-71) in video completion handler.

Signed-off-by: Hans Yang <hansy@nvidia.com>
---
 drivers/media/usb/uvc/uvc_video.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index fb86d6af398d..ad80c2a6da6a 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1862,10 +1862,9 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 
 	if (!enable) {
 		uvc_uninit_video(stream, 1);
-		if (stream->intf->num_altsetting > 1) {
-			usb_set_interface(stream->dev->udev,
+		usb_set_interface(stream->dev->udev,
 					  stream->intfnum, 0);
-		} else {
+		if (stream->intf->num_altsetting == 1) {
 			/* UVC doesn't specify how to inform a bulk-based device
 			 * when the video stream is stopped. Windows sends a
 			 * CLEAR_FEATURE(HALT) request to the video streaming
-- 
2.1.4
