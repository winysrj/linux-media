Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36934 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdHRHTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 03:19:00 -0400
Received: by mail-pg0-f50.google.com with SMTP id y129so58821257pgy.4
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 00:19:00 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, baoyou.xie@gmail.com, baoyou.xie@zte.com.cn,
        jun.nie@linaro.org, broonie@kernel.org, arnd@arndb.de,
        Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH v1] [media] uvcvideo: mark buffer error where overflow
Date: Fri, 18 Aug 2017 15:17:56 +0800
Message-Id: <1503040676-28802-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some cameras post inaccurate frame where next frame data overlap
it. this results in screen flicker, and it need to be prevented.

So this patch marks the buffer error to discard the frame where
buffer overflow.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/media/usb/uvc/uvc_video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index fb86d6a..81a3530 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1077,6 +1077,7 @@ static void uvc_video_decode_data(struct uvc_streaming *stream,
 	/* Complete the current frame if the buffer size was exceeded. */
 	if (len > maxlen) {
 		uvc_trace(UVC_TRACE_FRAME, "Frame complete (overflow).\n");
+		buf->error = 1;
 		buf->state = UVC_BUF_STATE_READY;
 	}
 }
-- 
2.7.4
