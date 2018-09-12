Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36929 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILLjB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 07:39:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id 2-v6so513238pgo.4
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2018 23:35:58 -0700 (PDT)
From: dorodnic@gmail.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Subject: [PATCH v2 2/2] [media] CNF4 pixel format for media subsystem
Date: Wed, 12 Sep 2018 02:42:07 -0400
Message-Id: <1536734527-3770-3-git-send-email-sergey.dorodnicov@intel.com>
In-Reply-To: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
References: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>

Registering new GUID used by Intel RealSense cameras with fourcc CNF4,
encoding depth sensor confidence information for every pixel.

Signed-off-by: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 5 +++++
 drivers/media/usb/uvc/uvcvideo.h   | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d46dc43..19f129f 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -214,6 +214,11 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.guid		= UVC_GUID_FORMAT_INZI,
 		.fcc		= V4L2_PIX_FMT_INZI,
 	},
+	{
+		.name		= "4-bit Depth Confidence (Packed)",
+		.guid		= UVC_GUID_FORMAT_CNF4,
+		.fcc		= V4L2_PIX_FMT_CNF4,
+	},
 };
 
 /* ------------------------------------------------------------------------
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index e5f5d84..779bab2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -154,6 +154,9 @@
 #define UVC_GUID_FORMAT_INVI \
 	{ 'I',  'N',  'V',  'I', 0xdb, 0x57, 0x49, 0x5e, \
 	 0x8e, 0x3f, 0xf4, 0x79, 0x53, 0x2b, 0x94, 0x6f}
+#define UVC_GUID_FORMAT_CNF4 \
+	{ 'C',  ' ',  ' ',  ' ', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 
 #define UVC_GUID_FORMAT_D3DFMT_L8 \
 	{0x32, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, \
-- 
2.7.4
