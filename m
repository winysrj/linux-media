Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab2EEPkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 11:40:22 -0400
Message-ID: <4FA549E2.7080509@redhat.com>
Date: Sat, 05 May 2012 17:40:18 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control
 framework.
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com> <4FA4DA05.5030001@redhat.com> <201205051114.31531.hverkuil@xs4all.nl> <4FA53CD2.1010706@redhat.com> <4FA541B8.4080507@redhat.com>
In-Reply-To: <4FA541B8.4080507@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020007030207050206070701"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020007030207050206070701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Oops, forgot the attachment it is here now...

Regards,

Hans


On 05/05/2012 05:05 PM, Hans de Goede wrote:
> Hi,
>
> On 05/05/2012 04:44 PM, Hans de Goede wrote:
>> Hi,
>>
>> On 05/05/2012 11:14 AM, Hans Verkuil wrote:
>>> So you get:
>>>
>>> vidioc_foo()
>>> lock(mylock)
>>> v4l2_ctrl_s_ctrl(ctrl, val)
>>> s_ctrl(ctrl, val)
>>> lock(mylock)
>>
>> Easy solution here, remove the first lock(mylock), since we are not using v4l2-dev's
>> locking, we are the one doing the first lock, and if we are going to call v4l2_ctrl_s_ctrl
>> we should simply not do that!
>>
>> Now I see that we are doing exactly that in for example vidioc_g_jpegcomp in gspca.c, so
>> we should stop doing that. We can make vidioc_g/s_jpegcomp only do the usb locking if
>> gspca_dev->vdev.ctrl_handler == NULL, and once all sub drivers are converted simply remove
>> it. Actually I'm thinking about making the jpegqual control part of the gspca_dev struct
>> itself and move all handling of vidioc_g/s_jpegcomp out of the sub drivers and into
>> the core.
>
> Here is an updated version of this patch implementing this approach for
> vidioc_g/s_jpegcomp. We may need to do something similar in other places, although I cannot
> think of any such places atm,
>
> Regards,
>
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

--------------020007030207050206070701
Content-Type: text/x-patch;
 name="0001-gspca-allow-subdrivers-to-use-the-control-framework.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-gspca-allow-subdrivers-to-use-the-control-framework.pat";
 filename*1="ch"

>From eb7eb7c63156c1c040a7fddaeddcf1b1891f0fb7 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hans.verkuil@cisco.com>
Date: Sat, 28 Apr 2012 17:09:50 +0200
Subject: [PATCH 1/8] gspca: allow subdrivers to use the control framework.

Make the necessary changes to allow subdrivers to use the control framework.
This does not add control event support, that needs more work.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |   47 ++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index ca5a2b1..dfe2e8a 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -38,6 +38,7 @@
 #include <linux/uaccess.h>
 #include <linux/ktime.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 
 #include "gspca.h"
 
@@ -1006,6 +1007,8 @@ static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
 
 	/* set the current control values to their default values
 	 * which may have changed in sd_init() */
+	/* does nothing if ctrl_handler == NULL */
+	v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
 	ctrl = gspca_dev->cam.ctrls;
 	if (ctrl != NULL) {
 		for (i = 0;
@@ -1323,6 +1326,7 @@ static void gspca_release(struct video_device *vfd)
 	PDEBUG(D_PROBE, "%s released",
 		video_device_node_name(&gspca_dev->vdev));
 
+	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 }
@@ -1771,14 +1775,21 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 
 	if (!gspca_dev->sd_desc->get_jcomp)
 		return -EINVAL;
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
+
+	/* Don't take the usb_lock when using the v4l2-ctrls framework */
+	if (gspca_dev->vdev.ctrl_handler == NULL)
+		if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+			return -ERESTARTSYS;
+
 	gspca_dev->usb_err = 0;
 	if (gspca_dev->present)
 		ret = gspca_dev->sd_desc->get_jcomp(gspca_dev, jpegcomp);
 	else
 		ret = -ENODEV;
-	mutex_unlock(&gspca_dev->usb_lock);
+
+	if (gspca_dev->vdev.ctrl_handler == NULL)
+		mutex_unlock(&gspca_dev->usb_lock);
+
 	return ret;
 }
 
@@ -1790,14 +1801,21 @@ static int vidioc_s_jpegcomp(struct file *file, void *priv,
 
 	if (!gspca_dev->sd_desc->set_jcomp)
 		return -EINVAL;
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
+
+	/* Don't take the usb_lock when using the v4l2-ctrls framework */
+	if (gspca_dev->vdev.ctrl_handler == NULL)
+		if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+			return -ERESTARTSYS;
+
 	gspca_dev->usb_err = 0;
 	if (gspca_dev->present)
 		ret = gspca_dev->sd_desc->set_jcomp(gspca_dev, jpegcomp);
 	else
 		ret = -ENODEV;
-	mutex_unlock(&gspca_dev->usb_lock);
+
+	if (gspca_dev->vdev.ctrl_handler == NULL)
+		mutex_unlock(&gspca_dev->usb_lock);
+
 	return ret;
 }
 
@@ -2347,6 +2365,14 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	gspca_dev->sd_desc = sd_desc;
 	gspca_dev->nbufread = 2;
 	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
+	gspca_dev->vdev = gspca_template;
+	gspca_dev->vdev.parent = &intf->dev;
+	gspca_dev->module = module;
+	gspca_dev->present = 1;
+
+	mutex_init(&gspca_dev->usb_lock);
+	mutex_init(&gspca_dev->queue_lock);
+	init_waitqueue_head(&gspca_dev->wq);
 
 	/* configure the subdriver and initialize the USB device */
 	ret = sd_desc->config(gspca_dev, id);
@@ -2363,15 +2389,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	if (ret)
 		goto out;
 
-	mutex_init(&gspca_dev->usb_lock);
-	mutex_init(&gspca_dev->queue_lock);
-	init_waitqueue_head(&gspca_dev->wq);
-
 	/* init video stuff */
-	memcpy(&gspca_dev->vdev, &gspca_template, sizeof gspca_template);
-	gspca_dev->vdev.parent = &intf->dev;
-	gspca_dev->module = module;
-	gspca_dev->present = 1;
 	ret = video_register_device(&gspca_dev->vdev,
 				  VFL_TYPE_GRABBER,
 				  -1);
@@ -2391,6 +2409,7 @@ out:
 	if (gspca_dev->input_dev)
 		input_unregister_device(gspca_dev->input_dev);
 #endif
+	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;
-- 
1.7.10


--------------020007030207050206070701--
