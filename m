Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6241Vgb029616
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 00:01:31 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6241KZG028622
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 00:01:21 -0400
Received: by fg-out-1718.google.com with SMTP id e21so93767fga.7
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 21:01:20 -0700 (PDT)
Message-ID: <30353c3d0807012101m5158059ftdb679e9501ec0fde@mail.gmail.com>
Date: Wed, 2 Jul 2008 00:01:20 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Jaime Velasco Juan" <jsagarribay@gmail.com>
In-Reply-To: <30353c3d0807011242r559f87ak8c8049b7ca4d2677@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806281840y76796eebh3beae577a24f6049@mail.gmail.com>
	<30353c3d0806291534y3b79d27aob9c4955b6d4ecb9c@mail.gmail.com>
	<20080701171321.GA6159@singular.sob>
	<30353c3d0807011242r559f87ak8c8049b7ca4d2677@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: [RFT v2] stk-webcam: Fix video_device handling
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

On Tue, Jul 1, 2008 at 3:42 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> On Tue, Jul 1, 2008 at 1:13 PM, Jaime Velasco Juan
> <jsagarribay@gmail.com> wrote:
>> Hi David,
>>
>> it seems to work ok now with your other patch, but if the video_device
>> struct is going to be ref. counted, wouldn't it make sense to drop the
>> kref in the driver and free all resources in the release callback? With
>> these changes there are two krefs which are created, get and put at the
>> same time and for the same purpose.
>>
> I noticed this as well and was actually working on a patch which would
> have removed the kref from the stk_camera since it would no longer
> have been needed.
>
>> I also like better the video_device struct embedded in the main
>> stk_camera struct (as it is now), but if people prefer having it
>> referenced with a pointer, so be it.
>>
> Agreed. The next patch I submit will keep the video_device struct in
> the stk_camera struct as it really doesn't need to be allocated using
> video_device_alloc().
>
>> Regards,
>>
>> Jaime
>
> I'm currently working to correct the kobject reference count in
> videodev which was previously patched by using a kref. The resulting
> behavior should be the same, but the code will be much simpler to
> understand. Once I have this working I will submit a proper patch for
> stk-webcam as well.
>
> Regards,
>
> David Ellingsworth
>

As promised, here's the patch which frees the stk_camera object via
the kobject release callback. This patch should be applied along with
the latest videodev patch titled "videodev: fix kobj ref count". This
patch removes the unnecessary kref object from stk_camera and reduces
the size of the driver by 40 lines of code.

Regards,

David Ellingsworth

[PATCH] stk-webcam: release via kobj


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/stk-webcam.c |   84 ++++++++++---------------------------
 drivers/media/video/stk-webcam.h |    2 -
 2 files changed, 23 insertions(+), 63 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index f308c38..acf9a69 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -64,22 +64,6 @@ static struct usb_device_id stkwebcam_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, stkwebcam_table);

-static void stk_camera_cleanup(struct kref *kref)
-{
-	struct stk_camera *dev = to_stk_camera(kref);
-
-	STK_INFO("Syntek USB2.0 Camera release resources"
-		" video device /dev/video%d\n", dev->vdev.minor);
-	video_unregister_device(&dev->vdev);
-	dev->vdev.priv = NULL;
-
-	if (dev->sio_bufs != NULL || dev->isobufs != NULL)
-		STK_ERROR("We are leaking memory\n");
-	usb_put_intf(dev->interface);
-	kfree(dev);
-}
-
-
 /*
  * Basic stuff
  */
@@ -687,8 +671,7 @@ static int v4l_stk_open(struct inode *inode,
struct file *fp)

 	if (dev == NULL || !is_present(dev))
 		return -ENXIO;
-	fp->private_data = vdev;
-	kref_get(&dev->kref);
+	fp->private_data = dev;
 	usb_autopm_get_interface(dev->interface);

 	return 0;
@@ -696,23 +679,10 @@ static int v4l_stk_open(struct inode *inode,
struct file *fp)

 static int v4l_stk_release(struct inode *inode, struct file *fp)
 {
-	struct stk_camera *dev;
-	struct video_device *vdev;
-
-	vdev = video_devdata(fp);
-	if (vdev == NULL) {
-		STK_ERROR("v4l_release called w/o video devdata\n");
-		return -EFAULT;
-	}
-	dev = vdev_to_camera(vdev);
-	if (dev == NULL) {
-		STK_ERROR("v4l_release called on removed device\n");
-		return -ENODEV;
-	}
+	struct stk_camera *dev = fp->private_data;

 	if (dev->owner != fp) {
 		usb_autopm_put_interface(dev->interface);
-		kref_put(&dev->kref, stk_camera_cleanup);
 		return 0;
 	}

@@ -723,7 +693,6 @@ static int v4l_stk_release(struct inode *inode,
struct file *fp)
 	dev->owner = NULL;

 	usb_autopm_put_interface(dev->interface);
-	kref_put(&dev->kref, stk_camera_cleanup);

 	return 0;
 }
@@ -734,14 +703,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
__user *buf,
 	int i;
 	int ret;
 	unsigned long flags;
-	struct stk_camera *dev;
-	struct video_device *vdev;
 	struct stk_sio_buffer *sbuf;
-
-	vdev = video_devdata(fp);
-	if (vdev == NULL)
-		return -EFAULT;
-	dev = vdev_to_camera(vdev);
+	struct stk_camera *dev = fp->private_data;

 	if (dev == NULL)
 		return -EIO;
@@ -800,15 +763,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
__user *buf,

 static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
 {
-	struct stk_camera *dev;
-	struct video_device *vdev;
-
-	vdev = video_devdata(fp);
-
-	if (vdev == NULL)
-		return -EFAULT;
+	struct stk_camera *dev = fp->private_data;

-	dev = vdev_to_camera(vdev);
 	if (dev == NULL)
 		return -ENODEV;

@@ -846,16 +802,12 @@ static int v4l_stk_mmap(struct file *fp, struct
vm_area_struct *vma)
 	unsigned int i;
 	int ret;
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-	struct stk_camera *dev;
-	struct video_device *vdev;
+	struct stk_camera *dev = fp->private_data;
 	struct stk_sio_buffer *sbuf = NULL;

 	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
 		return -EINVAL;

-	vdev = video_devdata(fp);
-	dev = vdev_to_camera(vdev);
-
 	for (i = 0; i < dev->n_sbufs; i++) {
 		if (dev->sio_bufs[i].v4lbuf.m.offset == offset) {
 			sbuf = dev->sio_bufs + i;
@@ -1329,6 +1281,12 @@ static struct file_operations v4l_stk_fops = {

 static void stk_v4l_dev_release(struct video_device *vd)
 {
+	struct stk_camera *dev = vdev_to_camera(vd);
+
+	if (dev->sio_bufs != NULL || dev->isobufs != NULL)
+		STK_ERROR("We are leaking memory\n");
+	usb_put_intf(dev->interface);
+	kfree(dev);
 }

 static struct video_device stk_v4l_data = {
@@ -1370,7 +1328,6 @@ static int stk_register_video_device(struct
stk_camera *dev)
 	dev->vdev = stk_v4l_data;
 	dev->vdev.debug = debug;
 	dev->vdev.dev = &dev->interface->dev;
-	dev->vdev.priv = dev;
 	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
 		STK_ERROR("v4l registration failed\n");
@@ -1387,7 +1344,7 @@ static int stk_camera_probe(struct usb_interface
*interface,
 		const struct usb_device_id *id)
 {
 	int i;
-	int err;
+	int err = 0;

 	struct stk_camera *dev = NULL;
 	struct usb_device *udev = interface_to_usbdev(interface);
@@ -1400,7 +1357,6 @@ static int stk_camera_probe(struct usb_interface
*interface,
 		return -ENOMEM;
 	}

-	kref_init(&dev->kref);
 	spin_lock_init(&dev->spinlock);
 	init_waitqueue_head(&dev->wait_frame);

@@ -1433,8 +1389,8 @@ static int stk_camera_probe(struct usb_interface
*interface,
 	}
 	if (!dev->isoc_ep) {
 		STK_ERROR("Could not find isoc-in endpoint");
-		kref_put(&dev->kref, stk_camera_cleanup);
-		return -ENODEV;
+		err = -ENODEV;
+		goto error;
 	}
 	dev->vsettings.brightness = 0x7fff;
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
@@ -1448,14 +1404,17 @@ static int stk_camera_probe(struct
usb_interface *interface,

 	err = stk_register_video_device(dev);
 	if (err) {
-		kref_put(&dev->kref, stk_camera_cleanup);
-		return err;
+		goto error;
 	}

 	stk_create_sysfs_files(&dev->vdev);
 	usb_autopm_enable(dev->interface);

 	return 0;
+
+error:
+	kfree(dev);
+	return err;
 }

 static void stk_camera_disconnect(struct usb_interface *interface)
@@ -1468,7 +1427,10 @@ static void stk_camera_disconnect(struct
usb_interface *interface)
 	wake_up_interruptible(&dev->wait_frame);
 	stk_remove_sysfs_files(&dev->vdev);

-	kref_put(&dev->kref, stk_camera_cleanup);
+	STK_INFO("Syntek USB2.0 Camera release resources"
+		" video device /dev/video%d\n", dev->vdev.minor);
+
+	video_unregister_device(&dev->vdev);
 }

 #ifdef CONFIG_PM
diff --git a/drivers/media/video/stk-webcam.h b/drivers/media/video/stk-webcam.h
index df4dfef..084a85b 100644
--- a/drivers/media/video/stk-webcam.h
+++ b/drivers/media/video/stk-webcam.h
@@ -99,7 +99,6 @@ struct stk_camera {

 	u8 isoc_ep;

-	struct kref kref;
 	/* Not sure if this is right */
 	atomic_t urbs_used;

@@ -121,7 +120,6 @@ struct stk_camera {
 	unsigned sequence;
 };

-#define to_stk_camera(d) container_of(d, struct stk_camera, kref)
 #define vdev_to_camera(d) container_of(d, struct stk_camera, vdev)

 void stk_camera_delete(struct kref *);
-- 
1.5.5.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
