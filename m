Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab1FFRnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 13:43:46 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: stable@kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] pwc: better usb disconnect handling
Date: Mon,  6 Jun 2011 19:43:39 +0200
Message-Id: <1307382219-2763-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1307382219-2763-1-git-send-email-hdegoede@redhat.com>
References: <1307382219-2763-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Unplugging a pwc cam while an app has the /dev/video# node open leads
to an oops in pwc_video_close when the app closes the node, because
the disconnect handler has free-ed the pdev struct pwc_video_close
tries to use. Instead of adding some sort of bandaid for this.
fix it properly using the v4l2 core's new(ish) behavior of keeping the
v4l2_dev structure around until both unregister has been called, and
all file handles referring  to it have been closed:

Embed the v4l2_dev structure in the pdev structure and define a v4l2 dev
release callback releasing the pdev structure (and thus also the embedded
v4l2 dev structure.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/pwc/pwc-ctrl.c |    2 +-
 drivers/media/video/pwc/pwc-if.c   |  152 +++++++++++-------------------------
 drivers/media/video/pwc/pwc.h      |    4 +-
 3 files changed, 50 insertions(+), 108 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-ctrl.c b/drivers/media/video/pwc/pwc-ctrl.c
index 1593f8d..760b4de 100644
--- a/drivers/media/video/pwc/pwc-ctrl.c
+++ b/drivers/media/video/pwc/pwc-ctrl.c
@@ -1414,7 +1414,7 @@ long pwc_ioctl(struct pwc_device *pdev, unsigned int cmd, void *arg)
 	{
 		ARG_DEF(struct pwc_probe, probe)
 
-		strcpy(ARGR(probe).name, pdev->vdev->name);
+		strcpy(ARGR(probe).name, pdev->vdev.name);
 		ARGR(probe).type = pdev->type;
 		ARG_OUT(probe)
 		break;
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index b81024c..592f966 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -40,7 +40,7 @@
    Oh yes, convention: to disctinguish between all the various pointers to
    device-structures, I use these names for the pointer variables:
    udev: struct usb_device *
-   vdev: struct video_device *
+   vdev: struct video_device (member of pwc_dev)
    pdev: struct pwc_devive *
 */
 
@@ -152,6 +152,7 @@ static ssize_t pwc_video_read(struct file *file, char __user *buf,
 			  size_t count, loff_t *ppos);
 static unsigned int pwc_video_poll(struct file *file, poll_table *wait);
 static int  pwc_video_mmap(struct file *file, struct vm_area_struct *vma);
+static void pwc_video_release(struct video_device *vfd);
 
 static const struct v4l2_file_operations pwc_fops = {
 	.owner =	THIS_MODULE,
@@ -164,42 +165,12 @@ static const struct v4l2_file_operations pwc_fops = {
 };
 static struct video_device pwc_template = {
 	.name =		"Philips Webcam",	/* Filled in later */
-	.release =	video_device_release,
+	.release =	pwc_video_release,
 	.fops =         &pwc_fops,
+	.ioctl_ops =	&pwc_ioctl_ops,
 };
 
 /***************************************************************************/
-
-/* Okay, this is some magic that I worked out and the reasoning behind it...
-
-   The biggest problem with any USB device is of course: "what to do
-   when the user unplugs the device while it is in use by an application?"
-   We have several options:
-   1) Curse them with the 7 plagues when they do (requires divine intervention)
-   2) Tell them not to (won't work: they'll do it anyway)
-   3) Oops the kernel (this will have a negative effect on a user's uptime)
-   4) Do something sensible.
-
-   Of course, we go for option 4.
-
-   It happens that this device will be linked to two times, once from
-   usb_device and once from the video_device in their respective 'private'
-   pointers. This is done when the device is probed() and all initialization
-   succeeded. The pwc_device struct links back to both structures.
-
-   When a device is unplugged while in use it will be removed from the
-   list of known USB devices; I also de-register it as a V4L device, but
-   unfortunately I can't free the memory since the struct is still in use
-   by the file descriptor. This free-ing is then deferend until the first
-   opportunity. Crude, but it works.
-
-   A small 'advantage' is that if a user unplugs the cam and plugs it back
-   in, it should get assigned the same video device minor, but unfortunately
-   it's non-trivial to re-link the cam back to the video device... (that
-   would surely be magic! :))
-*/
-
-/***************************************************************************/
 /* Private functions */
 
 /* Here we want the physical address of the memory.
@@ -1017,16 +988,15 @@ static ssize_t show_snapshot_button_status(struct device *class_dev,
 static DEVICE_ATTR(button, S_IRUGO | S_IWUSR, show_snapshot_button_status,
 		   NULL);
 
-static int pwc_create_sysfs_files(struct video_device *vdev)
+static int pwc_create_sysfs_files(struct pwc_device *pdev)
 {
-	struct pwc_device *pdev = video_get_drvdata(vdev);
 	int rc;
 
-	rc = device_create_file(&vdev->dev, &dev_attr_button);
+	rc = device_create_file(&pdev->vdev.dev, &dev_attr_button);
 	if (rc)
 		goto err;
 	if (pdev->features & FEATURE_MOTOR_PANTILT) {
-		rc = device_create_file(&vdev->dev, &dev_attr_pan_tilt);
+		rc = device_create_file(&pdev->vdev.dev, &dev_attr_pan_tilt);
 		if (rc)
 			goto err_button;
 	}
@@ -1034,19 +1004,17 @@ static int pwc_create_sysfs_files(struct video_device *vdev)
 	return 0;
 
 err_button:
-	device_remove_file(&vdev->dev, &dev_attr_button);
+	device_remove_file(&pdev->vdev.dev, &dev_attr_button);
 err:
 	PWC_ERROR("Could not create sysfs files.\n");
 	return rc;
 }
 
-static void pwc_remove_sysfs_files(struct video_device *vdev)
+static void pwc_remove_sysfs_files(struct pwc_device *pdev)
 {
-	struct pwc_device *pdev = video_get_drvdata(vdev);
-
 	if (pdev->features & FEATURE_MOTOR_PANTILT)
-		device_remove_file(&vdev->dev, &dev_attr_pan_tilt);
-	device_remove_file(&vdev->dev, &dev_attr_button);
+		device_remove_file(&pdev->vdev.dev, &dev_attr_pan_tilt);
+	device_remove_file(&pdev->vdev.dev, &dev_attr_button);
 }
 
 #ifdef CONFIG_USB_PWC_DEBUG
@@ -1107,7 +1075,7 @@ static int pwc_video_open(struct file *file)
 		if (ret >= 0)
 		{
 			PWC_DEBUG_OPEN("This %s camera is equipped with a %s (%d).\n",
-					pdev->vdev->name,
+					pdev->vdev.name,
 					pwc_sensor_type_to_string(i), i);
 		}
 	}
@@ -1181,16 +1149,15 @@ static int pwc_video_open(struct file *file)
 	return 0;
 }
 
-
-static void pwc_cleanup(struct pwc_device *pdev)
+static void pwc_video_release(struct video_device *vfd)
 {
-	pwc_remove_sysfs_files(pdev->vdev);
-	video_unregister_device(pdev->vdev);
+	struct pwc_device *pdev = container_of(vfd, struct pwc_device, vdev);
+	int hint;
 
-#ifdef CONFIG_USB_PWC_INPUT_EVDEV
-	if (pdev->button_dev)
-		input_unregister_device(pdev->button_dev);
-#endif
+	/* search device_hint[] table if we occupy a slot, by any chance */
+	for (hint = 0; hint < MAX_DEV_HINTS; hint++)
+		if (device_hint[hint].pdev == pdev)
+			device_hint[hint].pdev = NULL;
 
 	kfree(pdev);
 }
@@ -1200,7 +1167,7 @@ static int pwc_video_close(struct file *file)
 {
 	struct video_device *vdev = file->private_data;
 	struct pwc_device *pdev;
-	int i, hint;
+	int i;
 
 	PWC_DEBUG_OPEN(">> video_close called(vdev = 0x%p).\n", vdev);
 
@@ -1235,12 +1202,6 @@ static int pwc_video_close(struct file *file)
 		}
 		pdev->vopen--;
 		PWC_DEBUG_OPEN("<< video_close() vopen=%d\n", pdev->vopen);
-	} else {
-		pwc_cleanup(pdev);
-		/* search device_hint[] table if we occupy a slot, by any chance */
-		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
-			if (device_hint[hint].pdev == pdev)
-				device_hint[hint].pdev = NULL;
 	}
 
 	return 0;
@@ -1716,19 +1677,12 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	init_waitqueue_head(&pdev->frameq);
 	pdev->vcompression = pwc_preferred_compression;
 
-	/* Allocate video_device structure */
-	pdev->vdev = video_device_alloc();
-	if (!pdev->vdev) {
-		PWC_ERROR("Err, cannot allocate video_device struture. Failing probe.");
-		rc = -ENOMEM;
-		goto err_free_mem;
-	}
-	memcpy(pdev->vdev, &pwc_template, sizeof(pwc_template));
-	pdev->vdev->parent = &intf->dev;
-	pdev->vdev->lock = &pdev->modlock;
-	pdev->vdev->ioctl_ops = &pwc_ioctl_ops;
-	strcpy(pdev->vdev->name, name);
-	video_set_drvdata(pdev->vdev, pdev);
+	/* Init video_device structure */
+	memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));
+	pdev->vdev.parent = &intf->dev;
+	pdev->vdev.lock = &pdev->modlock;
+	strcpy(pdev->vdev.name, name);
+	video_set_drvdata(&pdev->vdev, pdev);
 
 	pdev->release = le16_to_cpu(udev->descriptor.bcdDevice);
 	PWC_DEBUG_PROBE("Release: %04x\n", pdev->release);
@@ -1747,8 +1701,6 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 		}
 	}
 
-	pdev->vdev->release = video_device_release;
-
 	/* occupy slot */
 	if (hint < MAX_DEV_HINTS)
 		device_hint[hint].pdev = pdev;
@@ -1760,16 +1712,16 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pwc_set_leds(pdev, 0, 0);
 	pwc_camera_power(pdev, 0);
 
-	rc = video_register_device(pdev->vdev, VFL_TYPE_GRABBER, video_nr);
+	rc = video_register_device(&pdev->vdev, VFL_TYPE_GRABBER, video_nr);
 	if (rc < 0) {
 		PWC_ERROR("Failed to register as video device (%d).\n", rc);
-		goto err_video_release;
+		goto err_free_mem;
 	}
-	rc = pwc_create_sysfs_files(pdev->vdev);
+	rc = pwc_create_sysfs_files(pdev);
 	if (rc)
 		goto err_video_unreg;
 
-	PWC_INFO("Registered as %s.\n", video_device_node_name(pdev->vdev));
+	PWC_INFO("Registered as %s.\n", video_device_node_name(&pdev->vdev));
 
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 	/* register webcam snapshot button input device */
@@ -1777,7 +1729,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	if (!pdev->button_dev) {
 		PWC_ERROR("Err, insufficient memory for webcam snapshot button device.");
 		rc = -ENOMEM;
-		pwc_remove_sysfs_files(pdev->vdev);
+		pwc_remove_sysfs_files(pdev);
 		goto err_video_unreg;
 	}
 
@@ -1795,7 +1747,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	if (rc) {
 		input_free_device(pdev->button_dev);
 		pdev->button_dev = NULL;
-		pwc_remove_sysfs_files(pdev->vdev);
+		pwc_remove_sysfs_files(pdev);
 		goto err_video_unreg;
 	}
 #endif
@@ -1805,10 +1757,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 err_video_unreg:
 	if (hint < MAX_DEV_HINTS)
 		device_hint[hint].pdev = NULL;
-	video_unregister_device(pdev->vdev);
-	pdev->vdev = NULL;	/* So we don't try to release it below */
-err_video_release:
-	video_device_release(pdev->vdev);
+	video_unregister_device(&pdev->vdev);
 err_free_mem:
 	kfree(pdev);
 	return rc;
@@ -1817,10 +1766,8 @@ err_free_mem:
 /* The user yanked out the cable... */
 static void usb_pwc_disconnect(struct usb_interface *intf)
 {
-	struct pwc_device *pdev;
-	int hint;
+	struct pwc_device *pdev  = usb_get_intfdata(intf);
 
-	pdev = usb_get_intfdata (intf);
 	mutex_lock(&pdev->modlock);
 	usb_set_intfdata (intf, NULL);
 	if (pdev == NULL) {
@@ -1837,30 +1784,25 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
 	}
 
 	/* We got unplugged; this is signalled by an EPIPE error code */
-	if (pdev->vopen) {
-		PWC_INFO("Disconnected while webcam is in use!\n");
-		pdev->error_status = EPIPE;
-	}
+	pdev->error_status = EPIPE;
+	pdev->unplugged = 1;
 
 	/* Alert waiting processes */
 	wake_up_interruptible(&pdev->frameq);
-	/* Wait until device is closed */
-	if (pdev->vopen) {
-		pdev->unplugged = 1;
-		pwc_iso_stop(pdev);
-	} else {
-		/* Device is closed, so we can safely unregister it */
-		PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
 
-disconnect_out:
-		/* search device_hint[] table if we occupy a slot, by any chance */
-		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
-			if (device_hint[hint].pdev == pdev)
-				device_hint[hint].pdev = NULL;
-	}
+	/* No need to keep the urbs around after disconnection */
+	pwc_isoc_cleanup(pdev);
 
+disconnect_out:
 	mutex_unlock(&pdev->modlock);
-	pwc_cleanup(pdev);
+
+	pwc_remove_sysfs_files(pdev);
+	video_unregister_device(&pdev->vdev);
+
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	if (pdev->button_dev)
+		input_unregister_device(pdev->button_dev);
+#endif
 }
 
 
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index e947766..083f8b1 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -162,9 +162,9 @@ struct pwc_imgbuf
 
 struct pwc_device
 {
-   struct video_device *vdev;
+	struct video_device vdev;
 
-   /* Pointer to our usb_device */
+   /* Pointer to our usb_device, may be NULL after unplug */
    struct usb_device *udev;
 
    int type;                    /* type of cam (645, 646, 675, 680, 690, 720, 730, 740, 750) */
-- 
1.7.5.1

