Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:46878
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbaJJS7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 14:59:53 -0400
From: John Crispin <blogic@openwrt.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] uvcvideo: add a new quirk UVC_QUIRK_SINGLE_ISO
Date: Fri, 10 Oct 2014 20:41:12 +0200
Message-Id: <1412966473-5407-1-git-send-email-blogic@openwrt.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch adds the usb ids for the iPassion chip. This chip is found
on D-Link DIR-930 IP cameras. For them to work this patch needs to be applied.
I am almost certain that this is the incorrect fix. Could someone shed a bit of
light on how i should really implement the fix ?

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/media/usb/uvc/uvc_video.c |    2 ++
 drivers/media/usb/uvc/uvcvideo.h  |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 9144a2f..61381fd 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1495,6 +1495,8 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	if (npackets == 0)
 		return -ENOMEM;
 
+	if (stream->dev->quirks & UVC_QUIRK_SINGLE_ISO)
+		npackets = 1;
 	size = npackets * psize;
 
 	for (i = 0; i < UVC_URBS; ++i) {
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index b1f69a6..b6df4f8 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -147,6 +147,7 @@
 #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
 #define UVC_QUIRK_PROBE_DEF		0x00000100
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
+#define UVC_QUIRK_SINGLE_ISO		0x00000400
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
1.7.10.4

