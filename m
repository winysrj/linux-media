Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34334 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751928AbdIVNs5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 09:48:57 -0400
Date: Fri, 22 Sep 2017 16:48:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [media] stk-webcam: Fix use after free on disconnect
Message-ID: <20170922134841.kxfwwn2yocjgnuad@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+yQshGzduWP-hpGbbnYh9uHbeODDsEX_K3KmgaNXHNFNQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We free the stk_camera device too early.  It's allocate first in probe
and it should be freed last in stk_camera_disconnect().

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Not tested but these bug reports seem surprisingly straight forward.
Thanks Andrey!

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index c0bba773db25..e748c976d967 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1241,7 +1241,6 @@ static void stk_v4l_dev_release(struct video_device *vd)
 	if (dev->sio_bufs != NULL || dev->isobufs != NULL)
 		pr_err("We are leaking memory\n");
 	usb_put_intf(dev->interface);
-	kfree(dev);
 }
 
 static const struct video_device stk_v4l_data = {
@@ -1391,6 +1390,7 @@ static void stk_camera_disconnect(struct usb_interface *interface)
 	video_unregister_device(&dev->vdev);
 	v4l2_ctrl_handler_free(&dev->hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	kfree(dev);
 }
 
 #ifdef CONFIG_PM
