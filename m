Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:60422 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZHNFW4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2009 01:22:56 -0400
Received: by rv-out-0506.google.com with SMTP id f6so383747rvb.1
        for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 22:22:57 -0700 (PDT)
Date: Thu, 13 Aug 2009 22:22:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] pwc - fix few use-after-free and memory leaks
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-Id: <20090814055340.A2F9C526EC9@mailhub.coreip.homeip.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I just happen to peek inside the PWC driver and did not like what I saw
there. Please consider applying the patch below.

Thanks!

-- 
Dmitry

V4L/DVB: pwc - fix few use-after-free and memory leaks

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

It is not allowed to call input_free_device() after input_unregister_device()
since input_dev structure is refcounted and will [most likely] be freed by
input_unregister_device(). Also don't try accessing structure members after
freeing the structure and correctly free resources in error unwinding path.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/media/video/pwc/pwc-if.c |   78 +++++++++++++++++---------------------
 drivers/media/video/pwc/pwc.h    |    1 
 2 files changed, 36 insertions(+), 43 deletions(-)


diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 8d17cf6..f976df4 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1057,7 +1057,8 @@ static int pwc_create_sysfs_files(struct video_device *vdev)
 		goto err;
 	if (pdev->features & FEATURE_MOTOR_PANTILT) {
 		rc = device_create_file(&vdev->dev, &dev_attr_pan_tilt);
-		if (rc) goto err_button;
+		if (rc)
+			goto err_button;
 	}
 
 	return 0;
@@ -1072,6 +1073,7 @@ err:
 static void pwc_remove_sysfs_files(struct video_device *vdev)
 {
 	struct pwc_device *pdev = video_get_drvdata(vdev);
+
 	if (pdev->features & FEATURE_MOTOR_PANTILT)
 		device_remove_file(&vdev->dev, &dev_attr_pan_tilt);
 	device_remove_file(&vdev->dev, &dev_attr_button);
@@ -1229,13 +1231,11 @@ static void pwc_cleanup(struct pwc_device *pdev)
 	video_unregister_device(pdev->vdev);
 
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
-	if (pdev->button_dev) {
+	if (pdev->button_dev)
 		input_unregister_device(pdev->button_dev);
-		input_free_device(pdev->button_dev);
-		kfree(pdev->button_dev->phys);
-		pdev->button_dev = NULL;
-	}
 #endif
+
+	kfree(pdev);
 }
 
 /* Note that all cleanup is done in the reverse order as in _open */
@@ -1281,8 +1281,6 @@ static int pwc_video_close(struct file *file)
 		PWC_DEBUG_OPEN("<< video_close() vopen=%d\n", pdev->vopen);
 	} else {
 		pwc_cleanup(pdev);
-		/* Free memory (don't set pdev to 0 just yet) */
-		kfree(pdev);
 		/* search device_hint[] table if we occupy a slot, by any chance */
 		for (hint = 0; hint < MAX_DEV_HINTS; hint++)
 			if (device_hint[hint].pdev == pdev)
@@ -1499,13 +1497,10 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct pwc_device *pdev = NULL;
 	int vendor_id, product_id, type_id;
-	int i, hint, rc;
+	int hint, rc;
 	int features = 0;
 	int video_nr = -1; /* default: use next available device */
 	char serial_number[30], *name;
-#ifdef CONFIG_USB_PWC_INPUT_EVDEV
-	char *phys = NULL;
-#endif
 
 	vendor_id = le16_to_cpu(udev->descriptor.idVendor);
 	product_id = le16_to_cpu(udev->descriptor.idProduct);
@@ -1757,8 +1752,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->vframes = default_fps;
 	strcpy(pdev->serial, serial_number);
 	pdev->features = features;
-	if (vendor_id == 0x046D && product_id == 0x08B5)
-	{
+	if (vendor_id == 0x046D && product_id == 0x08B5) {
 		/* Logitech QuickCam Orbit
 		   The ranges have been determined experimentally; they may differ from cam to cam.
 		   Also, the exact ranges left-right and up-down are different for my cam
@@ -1780,8 +1774,8 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->vdev = video_device_alloc();
 	if (!pdev->vdev) {
 		PWC_ERROR("Err, cannot allocate video_device struture. Failing probe.");
-		kfree(pdev);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto err_free_mem;
 	}
 	memcpy(pdev->vdev, &pwc_template, sizeof(pwc_template));
 	pdev->vdev->parent = &intf->dev;
@@ -1806,25 +1800,23 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	}
 
 	pdev->vdev->release = video_device_release;
-	i = video_register_device(pdev->vdev, VFL_TYPE_GRABBER, video_nr);
-	if (i < 0) {
-		PWC_ERROR("Failed to register as video device (%d).\n", i);
-		rc = i;
-		goto err;
-	}
-	else {
-		PWC_INFO("Registered as /dev/video%d.\n", pdev->vdev->num);
+	rc = video_register_device(pdev->vdev, VFL_TYPE_GRABBER, video_nr);
+	if (rc < 0) {
+		PWC_ERROR("Failed to register as video device (%d).\n", rc);
+		goto err_video_release;
 	}
 
+	PWC_INFO("Registered as /dev/video%d.\n", pdev->vdev->num);
+
 	/* occupy slot */
 	if (hint < MAX_DEV_HINTS)
 		device_hint[hint].pdev = pdev;
 
 	PWC_DEBUG_PROBE("probe() function returning struct at 0x%p.\n", pdev);
-	usb_set_intfdata (intf, pdev);
+	usb_set_intfdata(intf, pdev);
 	rc = pwc_create_sysfs_files(pdev->vdev);
 	if (rc)
-		goto err_unreg;
+		goto err_video_unreg;
 
 	/* Set the leds off */
 	pwc_set_leds(pdev, 0, 0);
@@ -1835,16 +1827,16 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->button_dev = input_allocate_device();
 	if (!pdev->button_dev) {
 		PWC_ERROR("Err, insufficient memory for webcam snapshot button device.");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		pwc_remove_sysfs_files(pdev->vdev);
+		goto err_video_unreg;
 	}
 
+	usb_make_path(udev, pdev->button_phys, sizeof(pdev->button_phys));
+	strlcat(pdev->button_phys, "/input0", sizeof(pdev->button_phys));
+
 	pdev->button_dev->name = "PWC snapshot button";
-	phys = kasprintf(GFP_KERNEL,"usb-%s-%s", pdev->udev->bus->bus_name, pdev->udev->devpath);
-	if (!phys) {
-		input_free_device(pdev->button_dev);
-		return -ENOMEM;
-	}
-	pdev->button_dev->phys = phys;
+	pdev->button_dev->phys = pdev->button_phys;
 	usb_to_input_id(pdev->udev, &pdev->button_dev->id);
 	pdev->button_dev->dev.parent = &pdev->udev->dev;
 	pdev->button_dev->evbit[0] = BIT_MASK(EV_KEY);
@@ -1853,25 +1845,27 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	rc = input_register_device(pdev->button_dev);
 	if (rc) {
 		input_free_device(pdev->button_dev);
-		kfree(pdev->button_dev->phys);
 		pdev->button_dev = NULL;
-		return rc;
+		pwc_remove_sysfs_files(pdev->vdev);
+		goto err_video_unreg;
 	}
 #endif
 
 	return 0;
 
-err_unreg:
+err_video_unreg:
 	if (hint < MAX_DEV_HINTS)
 		device_hint[hint].pdev = NULL;
 	video_unregister_device(pdev->vdev);
-err:
-	video_device_release(pdev->vdev); /* Drip... drip... drip... */
-	kfree(pdev); /* Oops, no memory leaks please */
+	pdev->vdev = NULL;	/* So we don't try to release it below */
+err_video_release:
+	video_device_release(pdev->vdev);
+err_free_mem:
+	kfree(pdev);
 	return rc;
 }
 
-/* The user janked out the cable... */
+/* The user yanked out the cable... */
 static void usb_pwc_disconnect(struct usb_interface *intf)
 {
 	struct pwc_device *pdev;
@@ -1902,7 +1896,7 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
 	/* Alert waiting processes */
 	wake_up_interruptible(&pdev->frameq);
 	/* Wait until device is closed */
-	if(pdev->vopen) {
+	if (pdev->vopen) {
 		mutex_lock(&pdev->modlock);
 		pdev->unplugged = 1;
 		mutex_unlock(&pdev->modlock);
@@ -1911,8 +1905,6 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
 		/* Device is closed, so we can safely unregister it */
 		PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
 		pwc_cleanup(pdev);
-		/* Free memory (don't set pdev to 0 just yet) */
-		kfree(pdev);
 
 disconnect_out:
 		/* search device_hint[] table if we occupy a slot, by any chance */
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index 0b658de..57b22b0 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -259,6 +259,7 @@ struct pwc_device
    int snapshot_button_status;		/* set to 1 when the user push the button, reset to 0 when this value is read */
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
    struct input_dev *button_dev;	/* webcam snapshot button input */
+   char button_phys[64];
 #endif
 
    /*** Misc. data ***/
