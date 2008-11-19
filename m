Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJAfL5h029891
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 05:41:21 -0500
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJAf9pN013937
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 05:41:09 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
In-Reply-To: <200811182219.38925.m.kozlowski@tuxland.pl>
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<200811162224.47885.m.kozlowski@tuxland.pl>
	<1227034668.1703.4.camel@localhost>
	<200811182219.38925.m.kozlowski@tuxland.pl>
Content-Type: multipart/mixed; boundary="=-dwKED0+LbCr2uY+zDoiy"
Date: Wed, 19 Nov 2008 11:32:12 +0100
Message-Id: <1227090732.2998.8.camel@localhost>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [BUG] zc3xx oopses on unplug: unable to handle kernel paging
	request
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--=-dwKED0+LbCr2uY+zDoiy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On Tue, 2008-11-18 at 22:19 +0100, Mariusz Kozlowski wrote:
> and it didn't fix it. It didn't apply cleanly - there
> was some offset during patching if that matters.
	[snip]
> If you could provide patches against some mainline kernel versions
> like 2.6.28-rc5 that would be great - and please specify which bits
> exactly should I patch to avoid confusion.
> 
> BTW. Can you reproduce the oops I'm seeing?

Hi Mariusz,

You have the oops thanks to poison and it is not enabled in my kernel.

I found the real bug: the device structure was part of the gspca device
and it was freed on close after webcam unplug while streaming.

I join a patch I merged from the linux-2.6.28-rc5 source (not compiled -
the original patch is the last one in my mercurial repository).

Thanks again.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--=-dwKED0+LbCr2uY+zDoiy
Content-Disposition: attachment; filename=gspca.patch
Content-Type: text/x-patch; name=gspca.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

--- linux-2.26.8-rc5/drivers/media/video/gspca/gspca.h.orig	2008-11-19 11:10:11.000000000 +0100
+++ linux-2.26.8-rc5/drivers/media/video/gspca/gspca.h	2008-11-19 11:16:58.000000000 +0100
@@ -120,8 +120,8 @@
 };
 
 struct gspca_dev {
-	struct video_device vdev;	/* !! must be the first item */
-	struct file_operations fops;
+	struct video_device *vdev;
+	struct module *module;		/* subdriver handling the device */
 	struct usb_device *dev;
 	struct kref kref;
 	struct file *capt_file;		/* file doing video capture */
--- linux-2.26.8-rc5/drivers/media/video/gspca/gspca.c.orig	2008-11-19 11:10:02.000000000 +0100
+++ linux-2.26.8-rc5/drivers/media/video/gspca/gspca.c	2008-11-19 11:19:57.000000000 +0100
@@ -863,7 +863,7 @@
 	int ret;
 
 	PDEBUG(D_STREAM, "%s open", current->comm);
-	gspca_dev = (struct gspca_dev *) video_devdata(file);
+	gspca_dev = video_drvdata(file);
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
 		return -ERESTARTSYS;
 	if (!gspca_dev->present) {
@@ -875,6 +875,13 @@
 		ret = -EBUSY;
 		goto out;
 	}
+
+	/* protect the subdriver against rmmod */
+	if (!try_module_get(gspca_dev->module)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	gspca_dev->users++;
 
 	/* one more user */
@@ -884,10 +891,10 @@
 #ifdef GSPCA_DEBUG
 	/* activate the v4l2 debug */
 	if (gspca_debug & D_V4L2)
-		gspca_dev->vdev.debug |= V4L2_DEBUG_IOCTL
+		gspca_dev->vdev->debug |= V4L2_DEBUG_IOCTL
 					| V4L2_DEBUG_IOCTL_ARG;
 	else
-		gspca_dev->vdev.debug &= ~(V4L2_DEBUG_IOCTL
+		gspca_dev->vdev->debug &= ~(V4L2_DEBUG_IOCTL
 					| V4L2_DEBUG_IOCTL_ARG);
 #endif
 	ret = 0;
@@ -921,6 +928,7 @@
 		gspca_dev->memory = GSPCA_MEMORY_NO;
 	}
 	file->private_data = NULL;
+	module_put(gspca_dev->module);
 	mutex_unlock(&gspca_dev->queue_lock);
 
 	PDEBUG(D_STREAM, "close done");
@@ -1748,11 +1756,6 @@
 	return ret;
 }
 
-static void dev_release(struct video_device *vfd)
-{
-	/* nothing */
-}
-
 static struct file_operations dev_fops = {
 	.owner = THIS_MODULE,
 	.open = dev_open,
@@ -1800,7 +1803,7 @@
 	.name = "gspca main driver",
 	.fops = &dev_fops,
 	.ioctl_ops = &dev_ioctl_ops,
-	.release = dev_release,		/* mandatory */
+	.release = video_device_release,
 	.minor = -1,
 };
 
@@ -1869,17 +1872,18 @@
 	init_waitqueue_head(&gspca_dev->wq);
 
 	/* init video stuff */
-	memcpy(&gspca_dev->vdev, &gspca_template, sizeof gspca_template);
-	gspca_dev->vdev.parent = &dev->dev;
-	memcpy(&gspca_dev->fops, &dev_fops, sizeof gspca_dev->fops);
-	gspca_dev->vdev.fops = &gspca_dev->fops;
-	gspca_dev->fops.owner = module;		/* module protection */
+	gspca_dev->vdev = video_device_alloc();
+	memcpy(gspca_dev->vdev, &gspca_template, sizeof gspca_template);
+	gspca_dev->vdev->parent = &dev->dev;
+	gspca_dev->module = module;
 	gspca_dev->present = 1;
-	ret = video_register_device(&gspca_dev->vdev,
+	video_set_drvdata(gspca_dev->vdev, gspca_dev);
+	ret = video_register_device(gspca_dev->vdev,
 				  VFL_TYPE_GRABBER,
 				  video_nr);
 	if (ret < 0) {
 		err("video_register_device err %d", ret);
+		video_device_release(gspca_dev->vdev);
 		goto out;
 	}
 
@@ -1887,7 +1891,8 @@
 	PDEBUG(D_PROBE, "probe ok");
 	return 0;
 out:
-	kref_put(&gspca_dev->kref, gspca_delete);
+	kfree(gspca_dev->usb_buf);
+	kfree(gspca_dev);
 	return ret;
 }
 EXPORT_SYMBOL(gspca_dev_probe);
@@ -1905,7 +1910,7 @@
 	usb_set_intfdata(intf, NULL);
 
 /* We don't want people trying to open up the device */
-	video_unregister_device(&gspca_dev->vdev);
+	video_unregister_device(gspca_dev->vdev);
 
 	gspca_dev->present = 0;
 	gspca_dev->streaming = 0;

--=-dwKED0+LbCr2uY+zDoiy
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-dwKED0+LbCr2uY+zDoiy--
