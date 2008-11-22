Return-path: <video4linux-list-bounces@redhat.com>
From: Jean-Francois Moine <moinejf@free.fr>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
In-Reply-To: <200811192256.09361.m.kozlowski@tuxland.pl>
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
	<492439AE.1070903@redhat.com>
	<200811192256.09361.m.kozlowski@tuxland.pl>
Content-Type: multipart/mixed; boundary="=-xavXKfrKZN66NMzRY6v4"
Date: Sat, 22 Nov 2008 13:41:50 +0100
Message-Id: <1227357710.3266.9.camel@localhost>
Mime-Version: 1.0
Cc: Hans de Goede <hdegoede@redhat.com>, v4l-dvb-maintainer@linuxtv.org,
	David Ellingsworth <david@identd.dyndns.org>, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [BUG] zc3xx oopses on unplug: unable to
	handle kernel paging request
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


--=-xavXKfrKZN66NMzRY6v4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On Wed, 2008-11-19 at 22:56 +0100, Mariusz Kozlowski wrote:
> Hi,

Hi Mariusz,

> Not sure I understand what should be applied where. I applied your -
> Hans - patch to
> 2.6.28-rc5-00117-g7f0f598. As you see my HEAD in linux-2.6 is at
> 7f0f598a0069d1ab072375965a4b69137233169c and I can reproduce the oops
> easily.
> I turned on all possible debuging in gspca as well. If it should be
> applied to
> some other tree which contains some more fixes for this - my fault.
> Please let me know.

I think Hans's patch was good.

Well, Leandro Costantino found an other bug. Here is a new patch to be
applied to 2.26.8-rc5 (not compiled). May you check it?

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--=-xavXKfrKZN66NMzRY6v4
Content-Disposition: attachment; filename=gspca.patch
Content-Type: text/x-patch; name=gspca.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

--- ../linux-2.26.8-rc5/drivers/media/video/gspca/gspca.h.orig	2008-11-19 11:10:11.000000000 +0100
+++ ../linux-2.26.8-rc5/drivers/media/video/gspca/gspca.h	2008-11-22 13:31:41.000000000 +0100
@@ -121,9 +121,8 @@
 
 struct gspca_dev {
 	struct video_device vdev;	/* !! must be the first item */
-	struct file_operations fops;
+	struct module *module;		/* subdriver handling the device */
 	struct usb_device *dev;
-	struct kref kref;
 	struct file *capt_file;		/* file doing video capture */
 
 	struct cam cam;				/* device information */
--- ../linux-2.26.8-rc5/drivers/media/video/gspca/gspca.c.orig	2008-11-19 11:10:02.000000000 +0100
+++ ../linux-2.26.8-rc5/drivers/media/video/gspca/gspca.c	2008-11-22 13:36:44.000000000 +0100
@@ -30,7 +30,6 @@
 #include <linux/string.h>
 #include <linux/pagemap.h>
 #include <linux/io.h>
-#include <linux/kref.h>
 #include <asm/page.h>
 #include <linux/uaccess.h>
 #include <linux/jiffies.h>
@@ -847,11 +846,11 @@
 	return ret;
 }
 
-static void gspca_delete(struct kref *kref)
+static void gspca_release(struct video_device *vfd)
 {
-	struct gspca_dev *gspca_dev = container_of(kref, struct gspca_dev, kref);
+	struct gspca_dev *gspca_dev = container_of(vfd, struct gspca_dev, vdev);
 
-	PDEBUG(D_STREAM, "device deleted");
+	PDEBUG(D_STREAM, "device released");
 
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
@@ -875,10 +874,14 @@
 		ret = -EBUSY;
 		goto out;
 	}
-	gspca_dev->users++;
 
-	/* one more user */
-	kref_get(&gspca_dev->kref);
+	/* protect the subdriver against rmmod */
+	if (!try_module_get(gspca_dev->module)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	gspca_dev->users++;
 
 	file->private_data = gspca_dev;
 #ifdef GSPCA_DEBUG
@@ -921,12 +924,11 @@
 		gspca_dev->memory = GSPCA_MEMORY_NO;
 	}
 	file->private_data = NULL;
+	module_put(gspca_dev->module);
 	mutex_unlock(&gspca_dev->queue_lock);
 
 	PDEBUG(D_STREAM, "close done");
 
-	kref_put(&gspca_dev->kref, gspca_delete);
-
 	return 0;
 }
 
@@ -1748,11 +1750,6 @@
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
@@ -1800,7 +1797,7 @@
 	.name = "gspca main driver",
 	.fops = &dev_fops,
 	.ioctl_ops = &dev_ioctl_ops,
-	.release = dev_release,		/* mandatory */
+	.release = gspca_release,
 	.minor = -1,
 };
 
@@ -1838,7 +1835,6 @@
 		err("couldn't kzalloc gspca struct");
 		return -ENOMEM;
 	}
-	kref_init(&gspca_dev->kref);
 	gspca_dev->usb_buf = kmalloc(USB_BUF_SZ, GFP_KERNEL);
 	if (!gspca_dev->usb_buf) {
 		err("out of memory");
@@ -1871,9 +1867,7 @@
 	/* init video stuff */
 	memcpy(&gspca_dev->vdev, &gspca_template, sizeof gspca_template);
 	gspca_dev->vdev.parent = &dev->dev;
-	memcpy(&gspca_dev->fops, &dev_fops, sizeof gspca_dev->fops);
-	gspca_dev->vdev.fops = &gspca_dev->fops;
-	gspca_dev->fops.owner = module;		/* module protection */
+	gspca_dev->module = module;
 	gspca_dev->present = 1;
 	ret = video_register_device(&gspca_dev->vdev,
 				  VFL_TYPE_GRABBER,
@@ -1887,7 +1881,8 @@
 	PDEBUG(D_PROBE, "probe ok");
 	return 0;
 out:
-	kref_put(&gspca_dev->kref, gspca_delete);
+	kfree(gspca_dev->usb_buf);
+	kfree(gspca_dev);
 	return ret;
 }
 EXPORT_SYMBOL(gspca_dev_probe);
@@ -1902,15 +1897,14 @@
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
-/* We don't want people trying to open up the device */
-	video_unregister_device(&gspca_dev->vdev);
-
 	gspca_dev->present = 0;
 	gspca_dev->streaming = 0;
 
-	kref_put(&gspca_dev->kref, gspca_delete);
+	usb_set_intfdata(intf, NULL);
+
+	/* release the device */
+	/* (this will call gspca_release() immediatly or on last close) */
+	video_unregister_device(&gspca_dev->vdev);
 
 	PDEBUG(D_PROBE, "disconnect complete");
 }

--=-xavXKfrKZN66NMzRY6v4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-xavXKfrKZN66NMzRY6v4--
