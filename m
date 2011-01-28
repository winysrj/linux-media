Return-path: <mchehab@pedra>
Received: from antispam01.maxim-ic.com ([205.153.101.182]:37311 "EHLO
	antispam01.dummydomain.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751556Ab1A1TjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 14:39:00 -0500
Subject: [PATCH RFC] uvcvideo: Add a mapping for H.264 payloads
From: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 11:38:58 -0800
Message-ID: <1296243538.17673.23.camel@svmlwks101>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Associate the H.264 GUID with an H.264 pixel format so that frame
and stream based format descriptors with this GUID are recognized
by the UVC video driver.
---
 drivers/media/video/uvc/uvc_driver.c |    5 +++++
 drivers/media/video/uvc/uvcvideo.h   |    3 +++
 include/linux/videodev2.h            |    1 +
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 6bcb9e1..a5a86ce 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -108,6 +108,11 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.guid		= UVC_GUID_FORMAT_MPEG,
 		.fcc		= V4L2_PIX_FMT_MPEG,
 	},
+	{
+		.name		= "H.264",
+		.guid		= UVC_GUID_FORMAT_H264,
+		.fcc		= V4L2_PIX_FMT_H264,
+	},
 };
 
 /* ------------------------------------------------------------------------
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index e522f99..4f65ac6 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -155,6 +155,9 @@ struct uvc_xu_control {
 #define UVC_GUID_FORMAT_MPEG \
 	{ 'M',  'P',  'E',  'G', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_H264 \
+	{ 'H',  '2',  '6',  '4', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 
 /* ------------------------------------------------------------------------
  * Driver specific constants.
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5f6f470..d3b5877 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -341,6 +341,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
 #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4    */
+#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H.264 Annex-B NAL Units */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
1.7.3.5


