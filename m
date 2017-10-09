Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:46569 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753740AbdJIDmY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 23:42:24 -0400
From: Jeffy Chen <jeffy.chen@rock-chips.com>
To: linux-kernel@vger.kernel.org
Cc: Jeffy Chen <jeffy.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [RESEND PATCH] media: uvcvideo: Fix memory leak of uvc resources
Date: Mon,  9 Oct 2017 11:42:15 +0800
Message-Id: <20171009034215.7596-1-jeffy.chen@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The refcount would be inited to 1 in kref_init(), so we don't need to
increase it at the end of uvc_register_video().

Fixes: 9d15cd958c17 ("media: uvcvideo: Convert from using an atomic variable to a reference count")
Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
---

 drivers/media/usb/uvc/uvc_driver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 6d22b22cb35b..dd6106411eb0 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1939,7 +1939,6 @@ static int uvc_register_video(struct uvc_device *dev,
 	else
 		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
 
-	kref_get(&dev->ref);
 	return 0;
 }
 
-- 
2.11.0
