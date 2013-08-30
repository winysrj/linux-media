Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33592 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3H3CRb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:31 -0400
Received: by mail-pb0-f53.google.com with SMTP id up15so1236361pbc.12
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:31 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 02/19] uvcvideo: Return 0 when setting probe control succeeds.
Date: Fri, 30 Aug 2013 11:17:01 +0900
Message-Id: <1377829038-4726-3-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return 0 instead of returning size of the probe control on successful set.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 695f6d9..1198989 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -296,6 +296,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 			"%d (exp. %u).\n", probe ? "probe" : "commit",
 			ret, size);
 		ret = -EIO;
+	} else {
+		ret = 0;
 	}
 
 	kfree(data);
-- 
1.8.4

