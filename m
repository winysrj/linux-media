Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50195 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750776AbcKNN07 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 08:26:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 86742207B3
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2016 08:26:58 -0500 (EST)
Received: from workstation01.smtp.fastmail.com (unknown [31.209.95.242])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AE9C7E046
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2016 08:26:58 -0500 (EST)
From: Edgar Thier <info@edgarthier.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] uvcvideo: Add bayer 16-bit format patterns
Date: Mon, 14 Nov 2016 14:26:56 +0100
Message-ID: <87h97achun.fsf@edgarthier.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From aec97c931cb4b91f91dd0ed38f74d866d4f13347 Mon Sep 17 00:00:00 2001
From: Edgar Thier <info@edgarthier.net>
Date: Mon, 14 Nov 2016 14:17:57 +0100
Subject: [PATCH] uvcvideo: Add bayer 16-bit format patterns

Add bayer 16-bit GUIDs to uvcvideo and associated them with the
corresponding V4L2 pixel formats.

Signed-off-by: Edgar Thier <info@edgarthier.net>
---
drivers/media/usb/uvc/uvc_driver.c   | 20 ++++++++++++++++++++
drivers/media/usb/uvc/uvcvideo.h     | 12 ++++++++++++
drivers/media/v4l2-core/v4l2-ioctl.c |  4 ++++
include/uapi/linux/videodev2.h       |  3 +++
4 files changed, 39 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 87b2fc3b..9d1fc33 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -168,6 +168,26 @@ static struct uvc_format_desc uvc_fmts[] = {
.guid		= UVC_GUID_FORMAT_RW10,
.fcc		= V4L2_PIX_FMT_SRGGB10P,
},
+	{
+			.name		= "Bayer 16-bit (SBGGR16)",
+			.guid		= UVC_GUID_FORMAT_BG16,
+			.fcc		= V4L2_PIX_FMT_SBGGR16,
+	},
+	{
+			.name		= "Bayer 16-bit (SGBRG16)",
+			.guid		= UVC_GUID_FORMAT_GB16,
+			.fcc		= V4L2_PIX_FMT_SGBRG16,
+	},
+	{
+			.name		= "Bayer 16-bit (SRGGB16)",
+			.guid		= UVC_GUID_FORMAT_RG16,
+			.fcc		= V4L2_PIX_FMT_SRGGB16,
+	},
+	{
+			.name		= "Bayer 16-bit (SGRBG16)",
+			.guid		= UVC_GUID_FORMAT_GR16,
+			.fcc		= V4L2_PIX_FMT_SGRBG16,
+	},
};

/* ------------------------------------------------------------------------
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 7e4d3ee..3d6cc62 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -106,6 +106,18 @@
#define UVC_GUID_FORMAT_RGGB \
{ 'R',  'G',  'G',  'B', 0x00, 0x00, 0x10, 0x00, \
0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BG16 \
+	{ 'B',  'G',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_GB16 \
+	{ 'G',  'B',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_RG16 \
+	{ 'R',  'G',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_GR16 \
+	{ 'G',  'R',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
#define UVC_GUID_FORMAT_RGBP \
{ 'R',  'G',  'B',  'P', 0x00, 0x00, 0x10, 0x00, \
0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 181381d..abbb6d5 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1179,6 +1179,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
case V4L2_PIX_FMT_SGBRG12:	descr = "12-bit Bayer GBGB/RGRG"; break;
case V4L2_PIX_FMT_SGRBG12:	descr = "12-bit Bayer GRGR/BGBG"; break;
case V4L2_PIX_FMT_SRGGB12:	descr = "12-bit Bayer RGRG/GBGB"; break;
+	case V4L2_PIX_FMT_SGBRG16:	descr = "16-bit Bayer GBGB/RGRG"; break;
+	case V4L2_PIX_FMT_SGRBG16:	descr = "16-bit Bayer GRGR/BGBG"; break;
+	case V4L2_PIX_FMT_SRGGB16:	descr = "16-bit Bayer RGRG/GBGB"; break;
+	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR"; break;
case V4L2_PIX_FMT_SBGGR10P:	descr = "10-bit Bayer BGBG/GRGR Packed"; break;
case V4L2_PIX_FMT_SGBRG10P:	descr = "10-bit Bayer GBGB/RGRG Packed"; break;
case V4L2_PIX_FMT_SGRBG10P:	descr = "10-bit Bayer GRGR/BGBG Packed"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4364ce6..6bdf592 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -605,6 +605,9 @@ struct v4l2_pix_format {
#define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
#define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
#define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGBRG16 v4l2_fourcc('G', 'B', '1', '6') /* 16  GBGB.. RGRG.. */
+#define V4L2_PIX_FMT_SRGGB16 v4l2_fourcc('R', 'G', '1', '6') /* 16  RGRG.. GBGB.. */
+#define V4L2_PIX_FMT_SGRBG16 v4l2_fourcc('G', 'R', '1', '6') /* 16  GRGR.. BGBG.. */

/* HSV formats */
#define V4L2_PIX_FMT_HSV24 v4l2_fourcc('H', 'S', 'V', '3')
--
2.10.2
