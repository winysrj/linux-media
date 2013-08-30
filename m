Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34555 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3H3CRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:41 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc17so1233589pbc.32
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:41 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 08/19] uvcvideo: Add UVC1.5 VP8 format support.
Date: Fri, 30 Aug 2013 11:17:07 +0900
Message-Id: <1377829038-4726-9-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add detection and parsing of VP8 format and frame descriptors and
reorganize format parsing code.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 120 ++++++++++++++++++++++++++++---------
 drivers/media/usb/uvc/uvcvideo.h   |   4 +-
 include/uapi/linux/usb/video.h     |   8 +++
 3 files changed, 104 insertions(+), 28 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 936ddc7..27a7a11 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -312,7 +312,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 	struct uvc_frame *frame;
 	const unsigned char *start = buffer;
 	unsigned int interval;
-	unsigned int i, n;
+	unsigned int i, n, intervals_off;
 	__u8 ftype;
 
 	format->type = buffer[2];
@@ -401,6 +401,18 @@ static int uvc_parse_format(struct uvc_device *dev,
 		format->nframes = 1;
 		break;
 
+	case UVC_VS_FORMAT_VP8:
+		if (buflen < 13)
+			goto format_error;
+
+		format->bpp = 0;
+		format->flags = UVC_FMT_FLAG_COMPRESSED;
+		ftype = UVC_VS_FRAME_VP8;
+		strlcpy(format->name, "VP8", sizeof(format->name));
+		format->fcc = V4L2_PIX_FMT_VP8;
+
+		break;
+
 	case UVC_VS_FORMAT_MPEG2TS:
 	case UVC_VS_FORMAT_STREAM_BASED:
 		/* Not supported yet. */
@@ -417,44 +429,83 @@ static int uvc_parse_format(struct uvc_device *dev,
 	buflen -= buffer[0];
 	buffer += buffer[0];
 
-	/* Parse the frame descriptors. Only uncompressed, MJPEG and frame
-	 * based formats have frame descriptors.
+	/* Parse the frame descriptors. Only uncompressed, MJPEG, temporally
+	 * encoded and frame based formats have frame descriptors.
 	 */
 	while (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
 	       buffer[2] == ftype) {
 		frame = &format->frame[format->nframes];
-		if (ftype != UVC_VS_FRAME_FRAME_BASED)
-			n = buflen > 25 ? buffer[25] : 0;
-		else
-			n = buflen > 21 ? buffer[21] : 0;
-
-		n = n ? n : 3;
 
-		if (buflen < 26 + 4*n) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d FRAME error\n", dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
-			return -EINVAL;
-		}
-
-		frame->bFrameIndex = buffer[3];
-		frame->bmCapabilities = buffer[4];
-		frame->wWidth = get_unaligned_le16(&buffer[5]);
-		frame->wHeight = get_unaligned_le16(&buffer[7]);
-		frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
-		frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
-		if (ftype != UVC_VS_FRAME_FRAME_BASED) {
+		switch (ftype) {
+		case UVC_VS_FRAME_UNCOMPRESSED:
+		case UVC_VS_FRAME_MJPEG:
+			intervals_off = 26;
+			if (buflen < intervals_off)
+				goto frame_error;
+
+			frame->bFrameIndex = buffer[3];
+			frame->bmCapabilities = buffer[4];
+			frame->wWidth = get_unaligned_le16(&buffer[5]);
+			frame->wHeight = get_unaligned_le16(&buffer[7]);
+			frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
+			frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
 			frame->dwMaxVideoFrameBufferSize =
 				get_unaligned_le32(&buffer[17]);
 			frame->dwDefaultFrameInterval =
 				get_unaligned_le32(&buffer[21]);
-			frame->bFrameIntervalType = buffer[25];
-		} else {
+			frame->bFrameIntervalType = n = buffer[25];
+			break;
+
+		case UVC_VS_FRAME_FRAME_BASED:
+			intervals_off = 26;
+			if (buflen < intervals_off)
+				goto frame_error;
+
+			frame->bFrameIndex = buffer[3];
+			frame->bmCapabilities = buffer[4];
+			frame->wWidth = get_unaligned_le16(&buffer[5]);
+			frame->wHeight = get_unaligned_le16(&buffer[7]);
+			frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
+			frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
 			frame->dwMaxVideoFrameBufferSize = 0;
 			frame->dwDefaultFrameInterval =
 				get_unaligned_le32(&buffer[17]);
-			frame->bFrameIntervalType = buffer[21];
+			frame->bFrameIntervalType = n = buffer[21];
+			break;
+
+		case UVC_VS_FRAME_VP8:
+			intervals_off = 31;
+			if (buflen < intervals_off)
+				goto frame_error;
+
+			frame->bFrameIndex = buffer[3];
+			frame->bmSupportedUsages =
+				get_unaligned_le32(&buffer[8]);
+			frame->bmCapabilities =
+				get_unaligned_le16(&buffer[12]);
+			frame->bmScalabilityCapabilities =
+				get_unaligned_le32(&buffer[14]);
+			frame->wWidth = get_unaligned_le16(&buffer[4]);
+			frame->wHeight = get_unaligned_le16(&buffer[6]);
+			frame->dwMinBitRate = get_unaligned_le32(&buffer[18]);
+			frame->dwMaxBitRate = get_unaligned_le32(&buffer[22]);
+			frame->dwMaxVideoFrameBufferSize = 0;
+			frame->dwDefaultFrameInterval =
+				get_unaligned_le32(&buffer[26]);
+			frame->bFrameIntervalType = n = buffer[30];
+			break;
+
+		default:
+			uvc_trace(UVC_TRACE_CONTROL,
+				"Unsupported frame descriptor %d\n", ftype);
+			return -EINVAL;
 		}
+
+		/* For n=0 - continuous intervals given, always 3 values. */
+		n = n ? n : 3;
+		if (buflen < intervals_off + 4 * n)
+			goto frame_error;
+
 		frame->dwFrameInterval = *intervals;
 
 		/* Several UVC chipsets screw up dwMaxVideoFrameBufferSize
@@ -475,12 +526,14 @@ static int uvc_parse_format(struct uvc_device *dev,
 		 * some other divisions by zero that could happen.
 		 */
 		for (i = 0; i < n; ++i) {
-			interval = get_unaligned_le32(&buffer[26+4*i]);
+			interval = get_unaligned_le32(
+					&buffer[intervals_off + 4 * i]);
 			*(*intervals)++ = interval ? interval : 1;
 		}
 
 		/* Make sure that the default frame interval stays between
 		 * the boundaries.
+		 * For type = 0, the last value is interval step, so skip it.
 		 */
 		n -= frame->bFrameIntervalType ? 1 : 2;
 		frame->dwDefaultFrameInterval =
@@ -535,6 +588,11 @@ format_error:
 			alts->desc.bInterfaceNumber);
 	return -EINVAL;
 
+frame_error:
+	uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
+			"interface %d FRAME error\n", dev->udev->devnum,
+			alts->desc.bInterfaceNumber);
+	return -EINVAL;
 }
 
 static int uvc_parse_streaming(struct uvc_device *dev,
@@ -672,6 +730,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		case UVC_VS_FORMAT_UNCOMPRESSED:
 		case UVC_VS_FORMAT_MJPEG:
 		case UVC_VS_FORMAT_FRAME_BASED:
+		case UVC_VS_FORMAT_VP8:
 			nformats++;
 			break;
 
@@ -704,6 +763,12 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 			if (_buflen > 21)
 				nintervals += _buffer[21] ? _buffer[21] : 3;
 			break;
+
+		case UVC_VS_FRAME_VP8:
+			nframes++;
+			if (_buflen > 30)
+				nintervals += _buffer[30] ? _buffer[30] : 0;
+			break;
 		}
 
 		_buflen -= _buffer[0];
@@ -738,6 +803,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		case UVC_VS_FORMAT_MJPEG:
 		case UVC_VS_FORMAT_DV:
 		case UVC_VS_FORMAT_FRAME_BASED:
+		case UVC_VS_FORMAT_VP8:
 			format->frame = frame;
 			ret = uvc_parse_format(dev, streaming, format,
 				&interval, buffer, buflen);
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 109c0a2..88f5e38 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -309,7 +309,7 @@ struct uvc_chain_entry {
 
 struct uvc_frame {
 	__u8  bFrameIndex;
-	__u8  bmCapabilities;
+	__u16 bmCapabilities;
 	__u16 wWidth;
 	__u16 wHeight;
 	__u32 dwMinBitRate;
@@ -318,6 +318,8 @@ struct uvc_frame {
 	__u8  bFrameIntervalType;
 	__u32 dwDefaultFrameInterval;
 	__u32 *dwFrameInterval;
+	__u32 bmSupportedUsages;
+	__u32 bmScalabilityCapabilities;
 };
 
 struct uvc_format {
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index eb48ba8..e09c50b 100644
--- a/include/uapi/linux/usb/video.h
+++ b/include/uapi/linux/usb/video.h
@@ -54,6 +54,8 @@
 #define UVC_VS_FORMAT_FRAME_BASED			0x10
 #define UVC_VS_FRAME_FRAME_BASED			0x11
 #define UVC_VS_FORMAT_STREAM_BASED			0x12
+#define UVC_VS_FORMAT_VP8				0x16
+#define UVC_VS_FRAME_VP8				0x17
 
 /* A.7. Video Class-Specific Endpoint Descriptor Subtypes */
 #define UVC_EP_UNDEFINED				0x00
@@ -163,6 +165,8 @@
 
 /* 2.4.3.3. Payload Header Information */
 #define UVC_STREAM_EOH					(1 << 7)
+/* SLI bit replaces EOH for VP8 formats */
+#define UVC_STREAM_SLI					(1 << 7)
 #define UVC_STREAM_ERR					(1 << 6)
 #define UVC_STREAM_STI					(1 << 5)
 #define UVC_STREAM_RES					(1 << 4)
@@ -171,6 +175,10 @@
 #define UVC_STREAM_EOF					(1 << 1)
 #define UVC_STREAM_FID					(1 << 0)
 
+#define UVC_STREAM_VP8_GRF				(1 << 2)
+#define UVC_STREAM_VP8_ARF				(1 << 1)
+#define UVC_STREAM_VP8_PRF				(1 << 0)
+
 /* 4.1.2. Control Capabilities */
 #define UVC_CONTROL_CAP_GET				(1 << 0)
 #define UVC_CONTROL_CAP_SET				(1 << 1)
-- 
1.8.4

