Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52343 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbbG0ORm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 10:17:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Peter Rabbitson <rabbit@rabbit.us>
Subject: [PATCH] uvcvideo: Disable hardware timestamps by default
Date: Mon, 27 Jul 2015 17:18:16 +0300
Message-Id: <1438006696-30678-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware timestamping implementation has been reported as not
working correctly on at least the Logitech C920. Until this can be
fixed, disable it by default.

Reported-by: Peter Rabbitson <rabbit@rabbit.us>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 3 +++
 drivers/media/usb/uvc/uvc_video.c  | 3 +++
 drivers/media/usb/uvc/uvcvideo.h   | 1 +
 3 files changed, 7 insertions(+)

Peter, could you please test this ?

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d9ddddb50e4d..ca8acc6fd9ed 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -32,6 +32,7 @@
 #define DRIVER_DESC		"USB Video Class driver"
 
 unsigned int uvc_clock_param = CLOCK_MONOTONIC;
+unsigned int uvc_hw_timestamps_param;
 unsigned int uvc_no_drop_param;
 static unsigned int uvc_quirks_param = -1;
 unsigned int uvc_trace_param;
@@ -2090,6 +2091,8 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 module_param_call(clock, uvc_clock_param_set, uvc_clock_param_get,
 		  &uvc_clock_param, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(clock, "Video buffers timestamp clock");
+module_param_named(hwtimestamps, uvc_hw_timestamps_param, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(hwtimestamps, "Use hardware timestamps");
 module_param_named(nodrop, uvc_no_drop_param, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(nodrop, "Don't drop incomplete frames");
 module_param_named(quirks, uvc_quirks_param, uint, S_IRUGO|S_IWUSR);
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 25ea8cf1b8b3..85d99882a5ca 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -667,6 +667,9 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 	u32 rem;
 	u64 y;
 
+	if (!uvc_hw_timestamps_param)
+		return;
+
 	spin_lock_irqsave(&clock->lock, flags);
 
 	if (clock->count < clock->size)
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 4bba30e5a1a5..18647f78f164 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -599,6 +599,7 @@ extern unsigned int uvc_clock_param;
 extern unsigned int uvc_no_drop_param;
 extern unsigned int uvc_trace_param;
 extern unsigned int uvc_timeout_param;
+extern unsigned int uvc_hw_timestamps_param;
 
 #define uvc_trace(flag, msg...) \
 	do { \
-- 
Regards,

Laurent Pinchart

