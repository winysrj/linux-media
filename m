Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48934 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab1EKQJ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 12:09:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com
Subject: [PATCH 2/2] uvcvideo: Add M420 format support
Date: Wed, 11 May 2011 15:37:23 +0200
Message-Id: <1305121043-8543-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1305121043-8543-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1305121043-8543-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Hans de Goede <hdegoede@redhat.com>

The M420 format is used by the Microsoft LifeCam Studio HD.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
[laurent.pinchart@ideasonboard.com: split into v4l/uvcvideo patches]
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_driver.c |    5 +++++
 drivers/media/video/uvc/uvcvideo.h   |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 496a9de..823f4b3 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -84,6 +84,11 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.fcc		= V4L2_PIX_FMT_YUV420,
 	},
 	{
+		.name		= "YUV 4:2:0 (M420)",
+		.guid		= UVC_GUID_FORMAT_M420,
+		.fcc		= V4L2_PIX_FMT_M420,
+	},
+	{
 		.name		= "YUV 4:2:2 (UYVY)",
 		.guid		= UVC_GUID_FORMAT_UYVY,
 		.fcc		= V4L2_PIX_FMT_UYVY,
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 0275613..7cf224b 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -172,6 +172,9 @@ struct uvc_xu_control {
 #define UVC_GUID_FORMAT_RGBP \
 	{ 'R',  'G',  'B',  'P', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_M420 \
+	{ 'M',  '4',  '2',  '0', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 
 /* ------------------------------------------------------------------------
  * Driver specific constants.
-- 
Regards,

Laurent Pinchart

