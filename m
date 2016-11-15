Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38936 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965824AbcKOFjo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 00:39:44 -0500
References: <87h97achun.fsf@edgarthier.net> <20161114141425.GT3217@valkosipuli.retiisi.org.uk>
From: Edgar Thier <info@edgarthier.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Edgar Thier <info@edgarthier.net>, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH] uvcvideo: Add bayer 16-bit format patterns
In-reply-to: <20161114141425.GT3217@valkosipuli.retiisi.org.uk>
Date: Tue, 15 Nov 2016 06:39:41 +0100
Message-ID: <8760np5mjm.fsf@edgarthier.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>From 10ce06db4ab3c037758b3cb5264007f59801f1a1 Mon Sep 17 00:00:00 2001
From: Edgar Thier <info@edgarthier.net>
Date: Tue, 15 Nov 2016 06:33:10 +0100
Subject: [PATCH] uvcvideo: Add bayer 16-bit format patterns

Signed-off-by: Edgar Thier <info@edgarthier.net>
---
drivers/media/usb/uvc/uvc_driver.c | 20 ++++++++++++++++++++
drivers/media/usb/uvc/uvcvideo.h   | 12 ++++++++++++
2 files changed, 32 insertions(+)

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
--
2.10.2
