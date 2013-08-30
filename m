Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59285 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3H3CRa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:30 -0400
Received: by mail-pa0-f44.google.com with SMTP id fz6so1699214pac.17
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:29 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 01/19] uvcvideo: Add UVC query tracing.
Date: Fri, 30 Aug 2013 11:17:00 +0900
Message-Id: <1377829038-4726-2-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new trace argument enabling UVC query details and contents logging.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_video.c | 45 +++++++++++++++++++++++++--------------
 drivers/media/usb/uvc/uvcvideo.h  |  9 ++++++++
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 3394c34..695f6d9 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -29,22 +29,6 @@
 /* ------------------------------------------------------------------------
  * UVC Controls
  */
-
-static int __uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
-			__u8 intfnum, __u8 cs, void *data, __u16 size,
-			int timeout)
-{
-	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
-	unsigned int pipe;
-
-	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
-			      : usb_sndctrlpipe(dev->udev, 0);
-	type |= (query & 0x80) ? USB_DIR_IN : USB_DIR_OUT;
-
-	return usb_control_msg(dev->udev, pipe, query, type, cs << 8,
-			unit << 8 | intfnum, data, size, timeout);
-}
-
 static const char *uvc_query_name(__u8 query)
 {
 	switch (query) {
@@ -69,6 +53,35 @@ static const char *uvc_query_name(__u8 query)
 	}
 }
 
+static int __uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
+			__u8 intfnum, __u8 cs, void *data, __u16 size,
+			int timeout)
+{
+	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
+	unsigned int pipe;
+	int ret;
+
+	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
+			      : usb_sndctrlpipe(dev->udev, 0);
+	type |= (query & 0x80) ? USB_DIR_IN : USB_DIR_OUT;
+
+	uvc_trace(UVC_TRACE_QUERY,
+			"%s (%d): size=%d, unit=%d, cs=%d, intf=%d\n",
+			uvc_query_name(query), query, size, unit, cs, intfnum);
+	uvc_trace(UVC_TRACE_QUERY, "Sent:\n");
+	uvc_print_hex_dump(UVC_TRACE_QUERY, data, size);
+
+	ret = usb_control_msg(dev->udev, pipe, query, type, cs << 8,
+			unit << 8 | intfnum, data, size, timeout);
+	if (ret == -EPIPE)
+		uvc_trace(UVC_TRACE_QUERY, "Got device STALL on query!\n");
+
+	uvc_trace(UVC_TRACE_QUERY, "Received:\n");
+	uvc_print_hex_dump(UVC_TRACE_QUERY, data, size);
+
+	return ret;
+}
+
 int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 			__u8 intfnum, __u8 cs, void *data, __u16 size)
 {
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 9e35982..75e0153 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -574,6 +574,7 @@ struct uvc_driver {
 #define UVC_TRACE_VIDEO		(1 << 10)
 #define UVC_TRACE_STATS		(1 << 11)
 #define UVC_TRACE_CLOCK		(1 << 12)
+#define UVC_TRACE_QUERY		(1 << 13)
 
 #define UVC_WARN_MINMAX		0
 #define UVC_WARN_PROBE_DEF	1
@@ -599,6 +600,14 @@ extern unsigned int uvc_timeout_param;
 #define uvc_printk(level, msg...) \
 	printk(level "uvcvideo: " msg)
 
+#define uvc_print_hex_dump(flag, buf, len) \
+	do { \
+		if (uvc_trace_param & flag) { \
+			print_hex_dump(KERN_DEBUG, "uvcvideo: ", \
+				DUMP_PREFIX_NONE, 16, 1, buf, len, false); \
+		} \
+	} while (0)
+
 /* --------------------------------------------------------------------------
  * Internal functions.
  */
-- 
1.8.4

