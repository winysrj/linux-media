Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38679 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757769AbeAHO0A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 09:26:00 -0500
From: Oliver Neukum <oneukum@suse.com>
To: khoroshilov@ispras.ru, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: [PATCH] media: usbtv: prevent double free in error case
Date: Mon,  8 Jan 2018 15:21:07 +0100
Message-Id: <20180108142107.29045-1-oneukum@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting the original report:

It looks like there is a double-free vulnerability in Linux usbtv driver on an error path of usbtv_probe function. When audio registration fails, usbtv_video_free function ends up freeing usbtv data structure, which gets freed the second time under usbtv_video_fail label.

usbtv_audio_fail:

        usbtv_video_free(usbtv); =>

           v4l2_device_put(&usbtv->v4l2_dev);

              => v4l2_device_put

                  => kref_put

                      => v4l2_device_release

  => usbtv_release (CALLBACK)

                             => kfree(usbtv) (1st time)

usbtv_video_fail:

        usb_set_intfdata(intf, NULL);

        usb_put_dev(usbtv->udev);

        kfree(usbtv); (2nd time)

So, as we have refcounting, use it

Reported-by: Yavuz, Tuba <tuba@ece.ufl.edu>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
CC: stable@vger.kernel.org
---
 drivers/media/usb/usbtv/usbtv-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 127f8a0c098b..0c2e628e8723 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -112,6 +112,8 @@ static int usbtv_probe(struct usb_interface *intf,
 	return 0;
 
 usbtv_audio_fail:
+	/* we must not free at this point */
+	usb_get_dev(usbtv->udev);
 	usbtv_video_free(usbtv);
 
 usbtv_video_fail:
-- 
2.13.6
