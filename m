Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35193 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbcLFQIY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 11:08:24 -0500
Received: by mail-pf0-f195.google.com with SMTP id i88so9539643pfk.2
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2016 08:08:23 -0800 (PST)
From: evgeni.raikhel@gmail.com
To: linux-media@vger.kernel.org
Cc: sergey.dorodnicov@intel.com, eliezer.tamir@intel.com,
        evgeni.raikhel@intel.com, laurent.pinchart@ideasonboard.com,
        Aviv Greenberg <avivgr@gmail.com>
Subject: [PATCH 2/2 v2] uvcvideo : Add support for Intel SR300 depth camera
Date: Tue,  6 Dec 2016 18:04:35 +0200
Message-Id: <1481040275-18392-3-git-send-email-evgeni.raikhel@intel.com>
In-Reply-To: <1481040275-18392-1-git-send-email-evgeni.raikhel@intel.com>
References: <1481040275-18392-1-git-send-email-evgeni.raikhel@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Aviv Greenberg <avivgr@gmail.com>

Add support for Intel SR300 depth camera formats in uvc driver.
This includes adding three uvc GUIDs for pixel formats
advertised by device, and their mapping to the proper FourCC definitions.

Signed-off-by: Aviv Greenberg <avivgr@gmail.com>
Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 15 +++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  9 +++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf35063c4c..46d6be0bb316 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -188,6 +188,21 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.guid		= UVC_GUID_FORMAT_GR16,
 		.fcc		= V4L2_PIX_FMT_SGRBG16,
 	},
+	{
+		.name		= "Depth data 16-bit (Z16)",
+		.guid		= UVC_GUID_FORMAT_INVZ,
+		.fcc		= V4L2_PIX_FMT_Z16,
+	},
+	{
+		.name		= "Greyscale 10-bit (Y10 )",
+		.guid		= UVC_GUID_FORMAT_INVI,
+		.fcc		= V4L2_PIX_FMT_Y10,
+	},
+	{
+		.name		= "IR:Depth 26-bit (INZI)",
+		.guid		= UVC_GUID_FORMAT_INZI,
+		.fcc		= V4L2_PIX_FMT_INZI,
+	},
 };
 
 /* ------------------------------------------------------------------------
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 3d6cc62f3cd2..672c4c96b767 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -143,6 +143,15 @@
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
-- 
2.7.4

