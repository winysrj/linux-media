Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33402 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdFPHje (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 03:39:34 -0400
Received: by mail-pg0-f65.google.com with SMTP id a70so4544944pge.0
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 00:39:34 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH 04/12] [media] uvc: enable subscriptions to other events
Date: Fri, 16 Jun 2017 16:39:07 +0900
Message-Id: <20170616073915.5027-5-gustavo@padovan.org>
In-Reply-To: <20170616073915.5027-1-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
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
2.9.4
