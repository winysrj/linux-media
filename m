Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61HDW1S003555
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 13:13:32 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61HDKiY021784
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 13:13:20 -0400
Received: by ug-out-1314.google.com with SMTP id s2so439011uge.6
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 10:13:20 -0700 (PDT)
Date: Tue, 1 Jul 2008 18:13:21 +0100
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Message-ID: <20080701171321.GA6159@singular.sob>
References: <30353c3d0806281840y76796eebh3beae577a24f6049@mail.gmail.com>
	<30353c3d0806291534y3b79d27aob9c4955b6d4ecb9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30353c3d0806291534y3b79d27aob9c4955b6d4ecb9c@mail.gmail.com>
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

Hi David,

it seems to work ok now with your other patch, but if the video_device
struct is going to be ref. counted, wouldn't it make sense to drop the
kref in the driver and free all resources in the release callback? With
these changes there are two krefs which are created, get and put at the
same time and for the same purpose.

I also like better the video_device struct embedded in the main
stk_camera struct (as it is now), but if people prefer having it
referenced with a pointer, so be it.

Regards,

Jaime

El dom. 29 de jun. de 2008, a las 18:34:27 -0400, David Ellingsworth escribió:
> [RFC v2.1] This patch should cleanly apply to the v4l-dvb devel branch
> Patch attached.
> 
> Regards,
> 
> David Ellingsworth

> From 210a4ca1f3d59ec3d152bf9177fda750f090fcf8 Mon Sep 17 00:00:00 2001
> From: David Ellingsworth <david@identd.dyndns.org>
> Date: Sun, 29 Jun 2008 14:37:55 -0400
> Subject: [PATCH] stk-camera: fix video_device handling
> 
> 
> Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
> ---
>  drivers/media/video/stk-webcam.c |  106 +++++++++++++++-----------------------
>  drivers/media/video/stk-webcam.h |    3 +-
>  2 files changed, 43 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
> index f308c38..378059f 100644
> --- a/drivers/media/video/stk-webcam.c
> +++ b/drivers/media/video/stk-webcam.c
> @@ -68,11 +68,6 @@ static void stk_camera_cleanup(struct kref *kref)
>  {
>  	struct stk_camera *dev = to_stk_camera(kref);
>  
> -	STK_INFO("Syntek USB2.0 Camera release resources"
> -		" video device /dev/video%d\n", dev->vdev.minor);
> -	video_unregister_device(&dev->vdev);
> -	dev->vdev.priv = NULL;
> -
>  	if (dev->sio_bufs != NULL || dev->isobufs != NULL)
>  		STK_ERROR("We are leaking memory\n");
>  	usb_put_intf(dev->interface);
> @@ -255,7 +250,7 @@ static ssize_t show_brightness(struct device *class,
>  			struct device_attribute *attr, char *buf)
>  {
>  	struct video_device *vdev = to_video_device(class);
> -	struct stk_camera *dev = vdev_to_camera(vdev);
> +	struct stk_camera *dev = dev_get_drvdata(vdev->dev);
>  
>  	return sprintf(buf, "%X\n", dev->vsettings.brightness);
>  }
> @@ -268,7 +263,7 @@ static ssize_t store_brightness(struct device *class,
>  	int ret;
>  
>  	struct video_device *vdev = to_video_device(class);
> -	struct stk_camera *dev = vdev_to_camera(vdev);
> +	struct stk_camera *dev = dev_get_drvdata(vdev->dev);
>  
>  	value = simple_strtoul(buf, &endp, 16);
>  
> @@ -285,7 +280,7 @@ static ssize_t show_hflip(struct device *class,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct video_device *vdev = to_video_device(class);
> -	struct stk_camera *dev = vdev_to_camera(vdev);
> +	struct stk_camera *dev = dev_get_drvdata(vdev->dev);
>  
>  	return sprintf(buf, "%d\n", dev->vsettings.hflip);
>  }
> @@ -294,7 +289,7 @@ static ssize_t store_hflip(struct device *class,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	struct video_device *vdev = to_video_device(class);
> -	struct stk_camera *dev = vdev_to_camera(vdev);
> +	struct stk_camera *dev = dev_get_drvdata(vdev->dev);
>  
>  	if (strncmp(buf, "1", 1) == 0)
>  		dev->vsettings.hflip = 1;
> @@ -310,7 +305,7 @@ static ssize_t show_vflip(struct device *class,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct video_device *vdev = to_video_device(class);
> -	struct stk_camera *dev = vdev_to_camera(vdev);
> +	struct stk_camera *dev = dev_get_drvdata(vdev->dev);
>  
>  	return sprintf(buf, "%d\n", dev->vsettings.vflip);
>  }
> @@ -319,7 +314,7 @@ static ssize_t store_vflip(struct device *class,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	struct video_device *vdev = to_video_device(class);
> -	struct stk_camera *dev = vdev_to_camera(vdev);
> +	struct stk_camera *dev = dev_get_drvdata(vdev->dev);
>  
>  	if (strncmp(buf, "1", 1) == 0)
>  		dev->vsettings.vflip = 1;
> @@ -683,11 +678,11 @@ static int v4l_stk_open(struct inode *inode, struct file *fp)
>  	struct video_device *vdev;
>  
>  	vdev = video_devdata(fp);
> -	dev = vdev_to_camera(vdev);
> +	dev = dev_get_drvdata(vdev->dev);
>  
>  	if (dev == NULL || !is_present(dev))
>  		return -ENXIO;
> -	fp->private_data = vdev;
> +	fp->private_data = dev;
>  	kref_get(&dev->kref);
>  	usb_autopm_get_interface(dev->interface);
>  
> @@ -696,19 +691,7 @@ static int v4l_stk_open(struct inode *inode, struct file *fp)
>  
>  static int v4l_stk_release(struct inode *inode, struct file *fp)
>  {
> -	struct stk_camera *dev;
> -	struct video_device *vdev;
> -
> -	vdev = video_devdata(fp);
> -	if (vdev == NULL) {
> -		STK_ERROR("v4l_release called w/o video devdata\n");
> -		return -EFAULT;
> -	}
> -	dev = vdev_to_camera(vdev);
> -	if (dev == NULL) {
> -		STK_ERROR("v4l_release called on removed device\n");
> -		return -ENODEV;
> -	}
> +	struct stk_camera *dev = fp->private_data;
>  
>  	if (dev->owner != fp) {
>  		usb_autopm_put_interface(dev->interface);
> @@ -734,14 +717,8 @@ static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
>  	int i;
>  	int ret;
>  	unsigned long flags;
> -	struct stk_camera *dev;
> -	struct video_device *vdev;
>  	struct stk_sio_buffer *sbuf;
> -
> -	vdev = video_devdata(fp);
> -	if (vdev == NULL)
> -		return -EFAULT;
> -	dev = vdev_to_camera(vdev);
> +	struct stk_camera *dev = fp->private_data;
>  
>  	if (dev == NULL)
>  		return -EIO;
> @@ -800,15 +777,8 @@ static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
>  
>  static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
>  {
> -	struct stk_camera *dev;
> -	struct video_device *vdev;
> -
> -	vdev = video_devdata(fp);
> -
> -	if (vdev == NULL)
> -		return -EFAULT;
> +	struct stk_camera *dev = fp->private_data;
>  
> -	dev = vdev_to_camera(vdev);
>  	if (dev == NULL)
>  		return -ENODEV;
>  
> @@ -846,16 +816,12 @@ static int v4l_stk_mmap(struct file *fp, struct vm_area_struct *vma)
>  	unsigned int i;
>  	int ret;
>  	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
> -	struct stk_camera *dev;
> -	struct video_device *vdev;
> +	struct stk_camera *dev = fp->private_data;
>  	struct stk_sio_buffer *sbuf = NULL;
>  
>  	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
>  		return -EINVAL;
>  
> -	vdev = video_devdata(fp);
> -	dev = vdev_to_camera(vdev);
> -
>  	for (i = 0; i < dev->n_sbufs; i++) {
>  		if (dev->sio_bufs[i].v4lbuf.m.offset == offset) {
>  			sbuf = dev->sio_bufs + i;
> @@ -1327,10 +1293,6 @@ static struct file_operations v4l_stk_fops = {
>  	.llseek = no_llseek
>  };
>  
> -static void stk_v4l_dev_release(struct video_device *vd)
> -{
> -}
> -
>  static struct video_device stk_v4l_data = {
>  	.name = "stkwebcam",
>  	.type = VFL_TYPE_GRABBER,
> @@ -1339,7 +1301,7 @@ static struct video_device stk_v4l_data = {
>  	.tvnorms = V4L2_STD_UNKNOWN,
>  	.current_norm = V4L2_STD_UNKNOWN,
>  	.fops = &v4l_stk_fops,
> -	.release = stk_v4l_dev_release,
> +	.release = video_device_release,
>  
>  	.vidioc_querycap = stk_vidioc_querycap,
>  	.vidioc_enum_fmt_vid_cap = stk_vidioc_enum_fmt_vid_cap,
> @@ -1367,16 +1329,16 @@ static int stk_register_video_device(struct stk_camera *dev)
>  {
>  	int err;
>  
> -	dev->vdev = stk_v4l_data;
> -	dev->vdev.debug = debug;
> -	dev->vdev.dev = &dev->interface->dev;
> -	dev->vdev.priv = dev;
> -	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> +	*dev->vdev = stk_v4l_data;
> +	dev->vdev->debug = debug;
> +	dev->vdev->dev = &dev->interface->dev;
> +	dev_set_drvdata(dev->vdev->dev, dev);
> +	err = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
>  	if (err)
>  		STK_ERROR("v4l registration failed\n");
>  	else
>  		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> -			" /dev/video%d\n", dev->vdev.minor);
> +			" /dev/video%d\n", dev->vdev->minor);
>  	return err;
>  }
>  
> @@ -1387,7 +1349,7 @@ static int stk_camera_probe(struct usb_interface *interface,
>  		const struct usb_device_id *id)
>  {
>  	int i;
> -	int err;
> +	int err = 0;
>  
>  	struct stk_camera *dev = NULL;
>  	struct usb_device *udev = interface_to_usbdev(interface);
> @@ -1433,8 +1395,8 @@ static int stk_camera_probe(struct usb_interface *interface,
>  	}
>  	if (!dev->isoc_ep) {
>  		STK_ERROR("Could not find isoc-in endpoint");
> -		kref_put(&dev->kref, stk_camera_cleanup);
> -		return -ENODEV;
> +		err = -ENODEV;
> +		goto error;
>  	}
>  	dev->vsettings.brightness = 0x7fff;
>  	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
> @@ -1446,16 +1408,27 @@ static int stk_camera_probe(struct usb_interface *interface,
>  
>  	usb_set_intfdata(interface, dev);
>  
> +	dev->vdev = video_device_alloc();
> +	if (dev->vdev == NULL) {
> +		err = -ENOMEM;
> +		goto error;
> +	}
> +
>  	err = stk_register_video_device(dev);
>  	if (err) {
> -		kref_put(&dev->kref, stk_camera_cleanup);
> -		return err;
> +		goto error_vdev;
>  	}
>  
> -	stk_create_sysfs_files(&dev->vdev);
> +	stk_create_sysfs_files(dev->vdev);
>  	usb_autopm_enable(dev->interface);
>  
>  	return 0;
> +
> +error_vdev:
> +	video_device_release(dev->vdev);
> +error:
> +	kref_put(&dev->kref, stk_camera_cleanup);
> +	return err;
>  }
>  
>  static void stk_camera_disconnect(struct usb_interface *interface)
> @@ -1466,7 +1439,12 @@ static void stk_camera_disconnect(struct usb_interface *interface)
>  	unset_present(dev);
>  
>  	wake_up_interruptible(&dev->wait_frame);
> -	stk_remove_sysfs_files(&dev->vdev);
> +	stk_remove_sysfs_files(dev->vdev);
> +
> +	STK_INFO("Syntek USB2.0 Camera release resources"
> +		" video device /dev/video%d\n", dev->vdev->minor);
> +
> +	video_unregister_device(dev->vdev);
>  
>  	kref_put(&dev->kref, stk_camera_cleanup);
>  }
> diff --git a/drivers/media/video/stk-webcam.h b/drivers/media/video/stk-webcam.h
> index df4dfef..84257fe 100644
> --- a/drivers/media/video/stk-webcam.h
> +++ b/drivers/media/video/stk-webcam.h
> @@ -91,7 +91,7 @@ struct regval {
>  };
>  
>  struct stk_camera {
> -	struct video_device vdev;
> +	struct video_device *vdev;
>  	struct usb_device *udev;
>  	struct usb_interface *interface;
>  	int webcam_model;
> @@ -122,7 +122,6 @@ struct stk_camera {
>  };
>  
>  #define to_stk_camera(d) container_of(d, struct stk_camera, kref)
> -#define vdev_to_camera(d) container_of(d, struct stk_camera, vdev)
>  
>  void stk_camera_delete(struct kref *);
>  int stk_camera_write_reg(struct stk_camera *, u16, u8);
> -- 
> 1.5.5.1
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
