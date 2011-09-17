Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58268 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab1IQPeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 11:34:05 -0400
Received: from localhost.localdomain (unknown [91.178.181.94])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D41C535AA1
	for <linux-media@vger.kernel.org>; Sat, 17 Sep 2011 15:34:02 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] uvcvideo: Add a mapping for H.264 payloads
Date: Sat, 17 Sep 2011 17:34:01 +0200
Message-Id: <1316273642-3624-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1316273642-3624-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1316273642-3624-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_driver.c |    5 +++++
 drivers/media/video/uvc/uvcvideo.h   |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index a3c24dd..656d4c9 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -114,6 +114,11 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.guid		= UVC_GUID_FORMAT_RGBP,
 		.fcc		= V4L2_PIX_FMT_RGB565,
 	},
+	{
+		.name		= "H.264",
+		.guid		= UVC_GUID_FORMAT_H264,
+		.fcc		= V4L2_PIX_FMT_H264,
+	},
 };
 
 /* ------------------------------------------------------------------------
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index e3aec87..4c1392e 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -89,6 +89,10 @@
 	{ 'M',  '4',  '2',  '0', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 
+#define UVC_GUID_FORMAT_H264 \
+	{ 'H',  '2',  '6',  '4', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+
 /* ------------------------------------------------------------------------
  * Driver specific constants.
  */
-- 
1.7.3.4

