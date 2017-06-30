Return-path: <linux-media-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:41333 "EHLO
        bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdF3QWF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 12:22:05 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Richard Simmons <rssimmo@amazon.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robb Glasser <rglasser@google.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2] [media] uvcvideo: Prevent heap overflow in uvc driver
Date: Fri, 30 Jun 2017 09:21:56 -0700
Message-Id: <1498839716-31918-1-git-send-email-linux@roeck-us.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The size of uvc_control_mapping is user controlled leading to a
potential heap overflow in the uvc driver. This adds a check to verify
the user provided size fits within the bounds of the defined buffer
size.

Originally-from: Richard Simmons <rssimmo@amazon.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Fixes CVE-2017-0627.

v2: Combination of v1 with the fix suggested by Richard Simmons
    Perform validation after uvc_ctrl_fill_xu_info()
    Take into account that ctrl->info.size is in bytes
    Also validate mapping->size

 drivers/media/usb/uvc/uvc_ctrl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ee6e39fd0c..d3e3164f43fd 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2002,6 +2002,13 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		goto done;
 	}
 
+	/* validate that the user provided bit-size and offset is valid */
+	if (mapping->size > 32 ||
+	    mapping->offset + mapping->size > ctrl->info.size * 8) {
+		ret = -EINVAL;
+		goto done;
+	}
+
 	list_for_each_entry(map, &ctrl->info.mappings, list) {
 		if (mapping->id == map->id) {
 			uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', "
-- 
2.7.4
