Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:46765 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752734AbeCTLRt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 07:17:49 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com, sean@mess.org,
        gregkh@linuxfoundation.org, andreyknvl@google.com,
        hans.verkuil@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFT] media: hdpvr: Fix Double kfree() error
Date: Tue, 20 Mar 2018 16:46:39 +0530
Message-Id: <ed0e67f9c56e42827f34d6e2991e6572070f8996.1521544143.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here, double-free is happening on error path of hdpvr_probe.

error_v4l2_unregister:
  v4l2_device_unregister(&dev->v4l2_dev);
   =>
    v4l2_device_disconnect
    =>
     put_device
     =>
      kobject_put
      =>
       kref_put
       =>
        v4l2_device_release
        =>
         hdpvr_device_release (CALLBACK)
         =>
         kfree(dev)

error_free_dev:
           kfree(dev)

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
reported by:
           Dan Carpenter<dan.carpenter@oracle.com>

 drivers/media/usb/hdpvr/hdpvr-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 29ac7fc..cab100a0 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -395,6 +395,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	kfree(dev->usbc_buf);
 error_v4l2_unregister:
 	v4l2_device_unregister(&dev->v4l2_dev);
+	dev = NULL;
 error_free_dev:
 	kfree(dev);
 error:
-- 
1.9.1
