Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:51026 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbeEICN3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 22:13:29 -0400
From: <ming_qian@realsil.com.cn>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        ming_qian <ming_qian@realsil.com.cn>
Subject: [PATCH] media: uvcvideo: Support realtek's UVC 1.5 device
Date: Wed, 9 May 2018 10:13:08 +0800
Message-ID: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: ming_qian <ming_qian@realsil.com.cn>

The length of UVC 1.5 video control is 48, and it id 34 for UVC 1.1.
Change it to 48 for UVC 1.5 device,
and the UVC 1.5 device can be recognized.

More changes to the driver are needed for full UVC 1.5 compatibility.
However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have
been reported to work well.

Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
---
 drivers/media/usb/uvc/uvc_video.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index aa0082f..32dfb32 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -171,6 +171,8 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 	int ret;
 
 	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
+	if (stream->dev->uvc_version >= 0x0150)
+		size = 48;
 	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
 			query == UVC_GET_DEF)
 		return -EIO;
@@ -259,6 +261,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 	int ret;
 
 	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
+	if (stream->dev->uvc_version >= 0x0150)
+		size = 48;
 	data = kzalloc(size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
-- 
2.7.4
