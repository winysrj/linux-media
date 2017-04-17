Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36262 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754202AbdDQIxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 04:53:25 -0400
Received: by mail-pf0-f194.google.com with SMTP id i5so23482037pfc.3
        for <linux-media@vger.kernel.org>; Mon, 17 Apr 2017 01:53:24 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Daniel Axtens <dja@axtens.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 2/2] [media] uvcvideo: Kill video URBs on disconnect
Date: Mon, 17 Apr 2017 18:52:40 +1000
Message-Id: <20170417085240.12930-2-dja@axtens.net>
In-Reply-To: <20170417085240.12930-1-dja@axtens.net>
References: <20170417085240.12930-1-dja@axtens.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When an in-use webcam is disconnected, I noticed the following
messages:

  uvcvideo: Failed to resubmit video URB (-19).

-19 is -ENODEV, which does make sense given that the device has
disappeared.

We could put a case for -ENODEV like we have with -ENOENT, -ECONNRESET
and -ESHUTDOWN, but the usb_unlink_urb() API documentation says that
'The disconnect function should synchronize with a driver's I/O
routines to insure that all URB-related activity has completed before
it returns.' So we should make an effort to proactively kill URBs in
the disconnect path instead.

Call uvc_enable_video() (specifying 0 to disable) in the disconnect
path, which kills and frees URBs.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>

---

Before this patch, yavta -c hangs when a camera is disconnected, but
with this patch it exits immediately after the camera is
disconnected. I'm not sure if this is acceptable - Laurent?

---
 drivers/media/usb/uvc/uvc_driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 2390592f78e0..647e3d8a1256 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1877,6 +1877,8 @@ static void uvc_unregister_video(struct uvc_device *dev)
 		if (!video_is_registered(&stream->vdev))
 			continue;
 
+		uvc_video_enable(stream, 0);
+
 		video_unregister_device(&stream->vdev);
 
 		uvc_debugfs_cleanup_stream(stream);
-- 
2.9.3
