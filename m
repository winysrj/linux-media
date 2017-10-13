Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.132]:36883 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753191AbdJMDNx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 23:13:53 -0400
From: Jeffy Chen <jeffy.chen@rock-chips.com>
To: linux-kernel@vger.kernel.org, mchehab@s-opensource.com,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com
Cc: Jeffy Chen <jeffy.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2] media: uvcvideo: Fix uvc dev reference management
Date: Fri, 13 Oct 2017 11:13:38 +0800
Message-Id: <20171013031338.8064-1-jeffy.chen@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the kref_get() in uvc_register_video(), which is not needed as
the kref_init() already initializes refcount to 1 for us.

Fixes: 9d15cd958c17 ("media: uvcvideo: Convert from using an atomic variable to a reference count")
Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
---

Changes in v2:
Rewrite commit message.

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
