Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46278 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3C1LKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 07:10:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] uvcvideo: Return -EINVAL when setting a menu control to an invalid value
Date: Thu, 28 Mar 2013 12:10:56 +0100
Message-Id: <1364469056-31298-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-ERANGE is the right error code when the value is outside of the menu
range, but -EINVAL must be reported for invalid values inside the range.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 61e28de..a2f4501 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1487,7 +1487,7 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 			step = mapping->get(mapping, UVC_GET_RES,
 					uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
 			if (!(step & value))
-				return -ERANGE;
+				return -EINVAL;
 		}
 
 		break;
-- 
Regards,

Laurent Pinchart

