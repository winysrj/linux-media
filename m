Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f176.google.com ([209.85.161.176]:32850 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab3ANSuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 13:50:14 -0500
Received: by mail-gg0-f176.google.com with SMTP id h3so707831gge.35
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 10:50:13 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH v2] uvc: Replace memcpy with struct assignment
Date: Mon, 14 Jan 2013 15:22:55 -0300
Message-Id: <1358187775-17592-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Changes from v1: 
 * Replaced a memcpy() in ucv_ctrl_add_info(),
   originally missed by the coccinelle script.

 drivers/media/usb/uvc/uvc_ctrl.c |    2 +-
 drivers/media/usb/uvc/uvc_v4l2.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 516a5b1..f2f6443 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1839,7 +1839,7 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
 {
 	int ret = 0;
 
-	memcpy(&ctrl->info, info, sizeof(*info));
+	ctrl->info = *info;
 	INIT_LIST_HEAD(&ctrl->info.mappings);
 
 	/* Allocate an array to save control values (cur, def, max, etc.) */
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 8e05604..36e79ed 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -315,7 +315,7 @@ static int uvc_v4l2_set_format(struct uvc_streaming *stream,
 		goto done;
 	}
 
-	memcpy(&stream->ctrl, &probe, sizeof probe);
+	stream->ctrl = probe;
 	stream->cur_format = format;
 	stream->cur_frame = frame;
 
@@ -387,7 +387,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 		return -EBUSY;
 	}
 
-	memcpy(&probe, &stream->ctrl, sizeof probe);
+	probe = stream->ctrl;
 	probe.dwFrameInterval =
 		uvc_try_frame_interval(stream->cur_frame, interval);
 
@@ -398,7 +398,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 		return ret;
 	}
 
-	memcpy(&stream->ctrl, &probe, sizeof probe);
+	stream->ctrl = probe;
 	mutex_unlock(&stream->mutex);
 
 	/* Return the actual frame period. */
-- 
1.7.4.4

