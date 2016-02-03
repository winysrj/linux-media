Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61330 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779AbcBCRJA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2016 12:09:00 -0500
Date: Wed, 3 Feb 2016 18:08:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/2] UVC: Add support for R200 depth camera.
In-Reply-To: <Pine.LNX.4.64.1602031251210.16491@axis700.grange>
Message-ID: <Pine.LNX.4.64.1602031259160.16491@axis700.grange>
References: <Pine.LNX.4.64.1602031251210.16491@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Aviv Greenberg <avivgr@gmail.com>

Add support for Intel R200 depth camera in uvc driver.
This includes adding new uvc GUIDs for the new pixel formats,
adding new V4L pixel format definition to user api headers,
and updating the uvc driver GUID-to-4cc tables with the new formats.

Tested-by: Greenberg, Aviv D <aviv.d.greenberg@intel.com>
Signed-off-by: Aviv Greenberg <aviv.d.greenberg@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/usb/uvc/uvc_driver.c | 20 ++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   | 12 ++++++++++++
 include/uapi/linux/videodev2.h     |  3 +++
 3 files changed, 35 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 4b5b3e8..bcbb6cf 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -147,6 +147,26 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.guid		= UVC_GUID_FORMAT_H264,
 		.fcc		= V4L2_PIX_FMT_H264,
 	},
+	{
+		.name		= "Greyscale 8 L/R (Y8I)",
+		.guid		= UVC_GUID_FORMAT_Y8I,
+		.fcc		= V4L2_PIX_FMT_Y8I,
+	},
+	{
+		.name		= "Greyscale 12 L/R (Y12I)",
+		.guid		= UVC_GUID_FORMAT_Y12I,
+		.fcc		= V4L2_PIX_FMT_Y12I,
+	},
+	{
+		.name		= "Depth data 16-bit (Z16)",
+		.guid		= UVC_GUID_FORMAT_Z16,
+		.fcc		= V4L2_PIX_FMT_Z16,
+	},
+	{
+		.name		= "Bayer 10-bit (SRGGB10P)",
+		.guid		= UVC_GUID_FORMAT_RW10,
+		.fcc		= V4L2_PIX_FMT_SRGGB10P,
+	},
 };
 
 /* ------------------------------------------------------------------------
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 816dd1a..b38bb2e 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -119,6 +119,18 @@
 #define UVC_GUID_FORMAT_H264 \
 	{ 'H',  '2',  '6',  '4', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_Y8I \
+	{ 'Y',  '8',  'I',  ' ', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_Y12I \
+	{ 'Y',  '1',  '2',  'I', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_Z16 \
+	{ 'Z',  '1',  '6',  ' ', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_RW10 \
+	{ 'R',  'W',  '1',  '0', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 
 /* ------------------------------------------------------------------------
  * Driver specific constants.
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3228fbe..14274c1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -606,6 +606,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_JPGL	v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */
 #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
 #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
+#define V4L2_PIX_FMT_Y8I      v4l2_fourcc('Y', '8', 'I', ' ') /* Greyscale 8-bit L/R interleaved */
+#define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
+#define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
 
 /* SDR formats - used only for Software Defined Radio devices */
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
