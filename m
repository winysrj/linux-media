Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60014 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431AbaLHS6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 13:58:39 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 3412720BBD
	for <linux-media@vger.kernel.org>; Mon,  8 Dec 2014 13:58:39 -0500 (EST)
From: William Manley <will@williammanley.net>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	m.chehab@samsung.com
Cc: William Manley <will@williammanley.net>
Subject: [PATCH] [media] uvcvideo: Add GUID for BGR 8:8:8
Date: Mon,  8 Dec 2014 18:57:58 +0000
Message-Id: <1418065078-27791-1-git-send-email-will@williammanley.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Magewell XI100DUSB-HDMI[1] video capture device reports the pixel
format "e436eb7d-524f-11ce-9f53-0020af0ba770".  This is its GUID for
BGR 8:8:8.

The UVC 1.5 spec[2] only defines GUIDs for YUY2, NV12, M420 and I420.
This seems to be an extension documented in the Microsoft Windows Media
Format SDK[3] - or at least the Media Format SDK was the only hit that
Google gave when searching for the GUID.  This Media Format SDK defines
this GUID as corresponding to `MEDIASUBTYPE_RGB24`.  Note though, the
XI100DUSB outputs BGR e.g. byte-reversed.  I don't know if its the
capture device in error or Microsoft mean BGR when they say RGB.

[1]: http://www.magewell.com/hardware/dongles/xi100dusb-hdmi/xi100dusb-hdmi_features.html?lang=en
[2]: http://www.usb.org/developers/docs/devclass_docs/USB_Video_Class_1_5.zip
[3]: http://msdn.microsoft.com/en-gb/library/windows/desktop/dd757532(v=vs.85).aspx

Signed-off-by: William Manley <will@williammanley.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 5 +++++
 drivers/media/usb/uvc/uvcvideo.h   | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 7c8322d..dc7cff1 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -138,6 +138,11 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.fcc		= V4L2_PIX_FMT_RGB565,
 	},
 	{
+		.name		= "BGR 8:8:8 (BGR3)",
+		.guid		= UVC_GUID_FORMAT_BGR3,
+		.fcc		= V4L2_PIX_FMT_BGR24,
+	},
+	{
 		.name		= "H.264",
 		.guid		= UVC_GUID_FORMAT_H264,
 		.fcc		= V4L2_PIX_FMT_H264,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 864ada7..ed0210d 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -109,6 +109,9 @@
 #define UVC_GUID_FORMAT_RGBP \
 	{ 'R',  'G',  'B',  'P', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BGR3 \
+	{ 0x7d, 0xeb, 0x36, 0xe4, 0x4f, 0x52, 0xce, 0x11, \
+	 0x9f, 0x53, 0x00, 0x20, 0xaf, 0x0b, 0xa7, 0x70}
 #define UVC_GUID_FORMAT_M420 \
 	{ 'M',  '4',  '2',  '0', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
-- 
2.1.3

