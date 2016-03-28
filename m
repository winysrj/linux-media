Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58537 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbcC1RIM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 13:08:12 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: au0828_v4l2_device_register()
Message-ID: <56F964F9.8080703@osg.samsung.com>
Date: Mon, 28 Mar 2016 11:08:09 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro/Javier,

I can't figure out when au0828_v4l2_device_register() was added. Must be in
Linux 4.5 as I can't find this change in Linux 4.4 This used to be a call to
v4l2_device_register() from au0828_usb_probe(). When the code was moved, locking
bugs are introduced.

Notice that au0828_v4l2_device_register() does the following in error legs:

                mutex_unlock(&dev->lock);
                kfree(dev);


And au0828_usb_probe() also does the same cleanup when au0828_v4l2_device_register()
returns error:

        retval = au0828_v4l2_device_register(interface, dev);
        if (retval) {
                au0828_usb_v4l2_media_release(dev);
                mutex_unlock(&dev->lock);
                kfree(dev);
                return retval;
        }

We could be seeing some problems if this fails.

Please let me know if you would like a patch to fix this.

The following is the right fix:

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 32d7db9..7d0ec4c 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -679,8 +679,6 @@ int au0828_v4l2_device_register(struct usb_interface *interface,
        if (retval) {
                pr_err("%s() v4l2_device_register failed\n",
                       __func__);
-               mutex_unlock(&dev->lock);
-               kfree(dev);
                return retval;
        }
 
@@ -691,8 +689,6 @@ int au0828_v4l2_device_register(struct usb_interface *interface,
        if (retval) {
                pr_err("%s() v4l2_ctrl_handler_init failed\n",
                       __func__);
-               mutex_unlock(&dev->lock);
-               kfree(dev);
                return retval;
        }
        dev->v4l2_dev.ctrl_handler = &dev->v4l2_ctrl_hdl;


thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com
