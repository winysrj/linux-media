Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35663 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbcLEN2S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 08:28:18 -0500
Received: by mail-pf0-f195.google.com with SMTP id i88so7719217pfk.2
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2016 05:28:17 -0800 (PST)
From: evgeni.raikhel@gmail.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        Aviv Greenberg <aviv.d.greenberg@intel.com>,
        Evgeni Raikhel <evgeni.raikhel@intel.com>
Subject: [PATCH 1/2] uvcvideo: Add support for Intel SR300 depth camera
Date: Mon,  5 Dec 2016 15:24:58 +0200
Message-Id: <1480944299-3349-2-git-send-email-evgeni.raikhel@intel.com>
In-Reply-To: <1480944299-3349-1-git-send-email-evgeni.raikhel@intel.com>
References: <1480944299-3349-1-git-send-email-evgeni.raikhel@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Aviv Greenberg <aviv.d.greenberg@intel.com>

Add support for Intel SR300 depth camera in uvc driver.
This includes adding three uvc GUIDs for the required pixel formats,
adding a new V4L pixel format definition to user api headers,
and updating the uvc driver GUID-to-4cc tables with the new formats.

Signed-off-by: Aviv Greenberg <aviv.d.greenberg@intel.com>
Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 15 +++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  9 +++++++++
 include/uapi/linux/videodev2.h     |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 11744f92097b..5b96a89f29ae 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -168,6 +168,21 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.guid		= UVC_GUID_FORMAT_RW10,
 		.fcc		= V4L2_PIX_FMT_SRGGB10P,
 	},
+	{
+		.name		= "Depth data 16-bit (Z16)",
+		.guid		= UVC_GUID_FORMAT_INVZ,
+		.fcc		= V4L2_PIX_FMT_Z16,
+	},
+	{
+		.name		= "IR:Depth 26-bit (INZI)",
+		.guid		= UVC_GUID_FORMAT_INZI,
+		.fcc		= V4L2_PIX_FMT_INZI,
+	},
+	{
+		.name		= "Greyscale 10-bit (Y10 )",
+		.guid		= UVC_GUID_FORMAT_INVI,
+		.fcc		= V4L2_PIX_FMT_Y10,
+	},
 };
 
 /* ------------------------------------------------------------------------
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 7e4d3eea371b..460b99ca99b7 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -131,6 +131,15 @@
 #define UVC_GUID_FORMAT_RW10 \
 	{ 'R',  'W',  '1',  '0', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_INVZ \
+	{ 'I',  'N',  'V',  'Z', 0x90, 0x2d, 0x58, 0x4a, \
+	 0x92, 0x0b, 0x77, 0x3f, 0x1f, 0x2c, 0x55, 0x6b}
+#define UVC_GUID_FORMAT_INZI \
+	{ 'I',  'N',  'Z',  'I', 0x66, 0x1a, 0x42, 0xa2, \
+	 0x90, 0x65, 0xd0, 0x18, 0x14, 0xa8, 0xef, 0x8a}
+#define UVC_GUID_FORMAT_INVI \
+	{ 'I',  'N',  'V',  'I', 0xdb, 0x57, 0x49, 0x5e, \
+	 0x8e, 0x3f, 0xf4, 0x79, 0x53, 0x2b, 0x94, 0x6f}
 
 /* ------------------------------------------------------------------------
  * Driver specific constants.
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index d3f613e2c54a..4ab995bbec5b 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -659,6 +659,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
 #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
 #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
+#define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Infrared 10-bit linked with Depth 16-bit */
 
 /* SDR formats - used only for Software Defined Radio devices */
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
-- 
2.7.4

