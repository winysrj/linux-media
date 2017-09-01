Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:37006 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdIABvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:51:00 -0400
Received: by mail-qt0-f196.google.com with SMTP id x29so1000138qtc.4
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:51:00 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 04/14] [media] uvc: enable subscriptions to other events
Date: Thu, 31 Aug 2017 22:50:31 -0300
Message-Id: <20170901015041.7757-5-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Call v4l2_ctrl_subscribe_event to subscribe to the BUF_QUEUED event as
well.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3e7e283a44a8..dfa0ccdcf849 100644
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
2.13.5
