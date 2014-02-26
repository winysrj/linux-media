Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46471 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaBZW2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 17:28:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Edgar Thier <info@edgarthier.net>
Subject: [PATCH v2] uvcvideo: Add bayer 8-bit patterns to uvcvideo
Date: Wed, 26 Feb 2014 23:29:19 +0100
Message-Id: <1393453759-25047-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Edgar Thier <info@edgarthier.net>

Add bayer 8-bit GUIDs to uvcvideo and associated them with the
corresponding V4L2 pixel formats.

Signed-off-by: Edgar Thier <info@edgarthier.net>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 22 +++++++++++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h   | 12 ++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index b6cac17..ad47c5c 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -108,11 +108,31 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.fcc		= V4L2_PIX_FMT_Y16,
 	},
 	{
-		.name		= "RGB Bayer",
+		.name		= "BGGR Bayer (BY8 )",
 		.guid		= UVC_GUID_FORMAT_BY8,
 		.fcc		= V4L2_PIX_FMT_SBGGR8,
 	},
 	{
+		.name		= "BGGR Bayer (BA81)",
+		.guid		= UVC_GUID_FORMAT_BA81,
+		.fcc		= V4L2_PIX_FMT_SBGGR8,
+	},
+	{
+		.name		= "GBRG Bayer (GBRG)",
+		.guid		= UVC_GUID_FORMAT_GBRG,
+		.fcc		= V4L2_PIX_FMT_SGBRG8,
+	},
+	{
+		.name		= "GRBG Bayer (GRBG)",
+		.guid		= UVC_GUID_FORMAT_GRBG,
+		.fcc		= V4L2_PIX_FMT_SGRBG8,
+	},
+	{
+		.name		= "RGGB Bayer (RGGB)",
+		.guid		= UVC_GUID_FORMAT_RGGB,
+		.fcc		= V4L2_PIX_FMT_SRGGB8,
+	},
+	{
 		.name		= "RGB565",
 		.guid		= UVC_GUID_FORMAT_RGBP,
 		.fcc		= V4L2_PIX_FMT_RGB565,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 143d5e5..b1f69a6 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -94,6 +94,18 @@
 #define UVC_GUID_FORMAT_BY8 \
 	{ 'B',  'Y',  '8',  ' ', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BA81 \
+	{ 'B',  'A',  '8',  '1', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_GBRG \
+	{ 'G',  'B',  'R',  'G', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_GRBG \
+	{ 'G',  'R',  'B',  'G', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_RGGB \
+	{ 'R',  'G',  'G',  'B', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 #define UVC_GUID_FORMAT_RGBP \
 	{ 'R',  'G',  'B',  'P', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
-- 
1.8.3.2

