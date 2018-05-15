Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46945 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752149AbeEONHt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 09:07:49 -0400
From: Oliver Neukum <oneukum@suse.com>
To: mchehab@s-opensource.com, ben.hutchings@codethink.co.uk,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: [PATCH] [Patch v2] usbtv: Fix refcounting mixup
Date: Tue, 15 May 2018 15:07:44 +0200
Message-Id: <20180515130744.19342-1-oneukum@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The premature free in the error path is blocked by V4L
refcounting, not USB refcounting. Thanks to
Ben Hutchings for review.

[v2] corrected attributions

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 50e704453553 ("media: usbtv: prevent double free in error case")
CC: stable@vger.kernel.org
Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 drivers/media/usb/usbtv/usbtv-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 5095c380b2c1..4a03c4d66314 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -113,7 +113,8 @@ static int usbtv_probe(struct usb_interface *intf,
 
 usbtv_audio_fail:
 	/* we must not free at this point */
-	usb_get_dev(usbtv->udev);
+	v4l2_device_get(&usbtv->v4l2_dev);
+	/* this will undo the v4l2_device_get() */
 	usbtv_video_free(usbtv);
 
 usbtv_video_fail:
-- 
2.13.6
