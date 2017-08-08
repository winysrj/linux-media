Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47382 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbdHHM4S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 08:56:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/5] uvcvideo: Prevent heap overflow when accessing mapped controls
Date: Tue,  8 Aug 2017 15:56:21 +0300
Message-Id: <20170808125624.11328-3-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
References: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guenter Roeck <linux@roeck-us.net>

The size of uvc_control_mapping is user controlled leading to a
potential heap overflow in the uvc driver. This adds a check to verify
the user provided size fits within the bounds of the defined buffer
size.

Cc: stable@vger.kernel.org
Originally-from: Richard Simmons <rssimmo@amazon.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ee6e39fd0c..20397aba6849 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2002,6 +2002,13 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		goto done;
 	}
 
+	/* Validate the user-provided bit-size and offset */
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
Regards,

Laurent Pinchart
