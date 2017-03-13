Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36439 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbdCMTUz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:20:55 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 04/10] [media] uvc: enable subscriptions to other events
Date: Mon, 13 Mar 2017 16:20:29 -0300
Message-Id: <20170313192035.29859-5-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Call v4l2_ctrl_subscribe_event to subscribe to more events supported by
v4l.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3e7e283..dfa0ccd 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1240,7 +1240,7 @@ static int uvc_ioctl_subscribe_event(struct v4l2_fh *fh,
 	case V4L2_EVENT_CTRL:
 		return v4l2_event_subscribe(fh, sub, 0, &uvc_ctrl_sub_ev_ops);
 	default:
-		return -EINVAL;
+		return v4l2_ctrl_subscribe_event(fh, sub);
 	}
 }
 
-- 
2.9.3
