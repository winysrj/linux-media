Return-path: <mchehab@pedra>
Received: from antispam01.maxim-ic.com ([205.153.101.182]:37041 "EHLO
	antispam01.dummydomain.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753721Ab1A1TfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 14:35:08 -0500
Subject: [PATCH RFC] uvcvideo: Add support for MPEG-2 TS payload
From: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 11:35:05 -0800
Message-ID: <1296243305.17673.20.camel@svmlwks101>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Parse the UVC 1.0 and UVC 1.1 VS_FORMAT_MPEG2TS descriptors.
This a stream based format, so we generate a dummy frame descriptor
with a dummy frame interval range.
---
 drivers/media/video/uvc/uvc_driver.c |   41 ++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h   |    3 ++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index a1e9dfb..6bcb9e1 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -103,6 +103,11 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.guid		= UVC_GUID_FORMAT_BY8,
 		.fcc		= V4L2_PIX_FMT_SBGGR8,
 	},
+	{
+		.name		= "MPEG2 TS",
+		.guid		= UVC_GUID_FORMAT_MPEG,
+		.fcc		= V4L2_PIX_FMT_MPEG,
+	},
 };
 
 /* ------------------------------------------------------------------------
@@ -398,6 +403,33 @@ static int uvc_parse_format(struct uvc_device *dev,
 		break;
 
 	case UVC_VS_FORMAT_MPEG2TS:
+		n = dev->uvc_version >= 0x0110 ? 23 : 7;
+		if (buflen < n) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
+			       "interface %d FORMAT error\n",
+			       dev->udev->devnum,
+			       alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		strlcpy(format->name, "MPEG2 TS", sizeof format->name);
+		format->fcc = V4L2_PIX_FMT_MPEG;
+		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
+		format->bpp = 0;
+		ftype = 0;
+
+		/* Create a dummy frame descriptor. */
+		frame = &format->frame[0];
+		memset(&format->frame[0], 0, sizeof format->frame[0]);
+		frame->bFrameIntervalType = 0;
+		frame->dwDefaultFrameInterval = 1;
+		frame->dwFrameInterval = *intervals;
+		*(*intervals)++ = 1;
+		*(*intervals)++ = 10000000;
+		*(*intervals)++ = 1;
+		format->nframes = 1;
+		break;
+
 	case UVC_VS_FORMAT_STREAM_BASED:
 		/* Not supported yet. */
 	default:
@@ -673,6 +705,14 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 			break;
 
 		case UVC_VS_FORMAT_MPEG2TS:
+			/* MPEG2TS format has no frame descriptor. We will create a
+			 * dummy frame descriptor with a dummy frame interval range.
+			 */
+			nformats++;
+			nframes++;
+			nintervals += 3;
+			break;
+
 		case UVC_VS_FORMAT_STREAM_BASED:
 			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
 				"interface %d FORMAT %u is not supported.\n",
@@ -724,6 +764,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		switch (buffer[2]) {
 		case UVC_VS_FORMAT_UNCOMPRESSED:
 		case UVC_VS_FORMAT_MJPEG:
+		case UVC_VS_FORMAT_MPEG2TS:
 		case UVC_VS_FORMAT_DV:
 		case UVC_VS_FORMAT_FRAME_BASED:
 			format->frame = frame;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 45f01e7..e522f99 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -152,6 +152,9 @@ struct uvc_xu_control {
 #define UVC_GUID_FORMAT_BY8 \
 	{ 'B',  'Y',  '8',  ' ', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_MPEG \
+	{ 'M',  'P',  'E',  'G', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 
 /* ------------------------------------------------------------------------
  * Driver specific constants.
-- 
1.7.3.5


