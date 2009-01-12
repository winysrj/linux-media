Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:56258 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZALPuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 10:50:00 -0500
Received: by ti-out-0910.google.com with SMTP id b6so12007547tic.23
        for <linux-media@vger.kernel.org>; Mon, 12 Jan 2009 07:49:57 -0800 (PST)
Subject: Re: [PATCH] pwc: add support for webcam snapshot button (2)
From: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <1231706104.10496.91.camel@AcerAspire4710>
References: <2ac79fa40901092218y6af40570m5cbe5aeb598038b2@mail.gmail.com>
	 <1231706104.10496.91.camel@AcerAspire4710>
Content-Type: multipart/mixed; boundary="=-SGeIQUDlTsSYSMDNDgc5"
Date: Mon, 12 Jan 2009 12:50:17 +0700
Message-Id: <1231739417.7309.11.camel@AcerAspire4710>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-SGeIQUDlTsSYSMDNDgc5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all
Maybe Linux Media team has not received my patch. I also CC'ed my former
email to linux-media mailing list, but it has been filtered out by Linux
Media mail server's policy for some reason, so I resend the patch.
*** PATCH BEGINS FROM HERE ***
This patch adds support for Philips webcam snapshot button as an
event input device, for consistency with other webcam drivers.
Signed-off-by: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>

diff -uNr a/linux/drivers/media/video/pwc/Kconfig
b/linux/drivers/media/video/pwc/Kconfig
--- a/linux/drivers/media/video/pwc/Kconfig	2009-01-03
20:03:43.000000000 +0700
+++ b/linux/drivers/media/video/pwc/Kconfig	2009-01-09
16:09:45.000000000 +0700
@@ -35,3 +35,13 @@
 	  Say Y here in order to have the pwc driver generate verbose
debugging
 	  messages.
 	  A special module options 'trace' is used to control the verbosity.
+
+config USB_PWC_INPUT_EVDEV
+	bool "USB Philips Cameras input events device support"
+	default y
+	depends on USB_PWC && INPUT
+	---help---
+	  This option makes USB Philips cameras register the snapshot button
as
+	  an input device to report button events.
+
+	  If you are in doubt, say Y.
diff -uNr a/linux/drivers/media/video/pwc/pwc.h
b/linux/drivers/media/video/pwc/pwc.h
--- a/linux/drivers/media/video/pwc/pwc.h	2009-01-03 20:03:43.000000000
+0700
+++ b/linux/drivers/media/video/pwc/pwc.h	2009-01-09 17:06:04.000000000
+0700
@@ -38,6 +38,9 @@
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+#include <linux/input.h>
+#endif
 
 #include "pwc-uncompress.h"
 #include <media/pwc-ioctl.h>
@@ -256,6 +259,9 @@
    int pan_angle;			/* in degrees * 100 */
    int tilt_angle;			/* absolute angle; 0,0 is home position */
    int snapshot_button_status;		/* set to 1 when the user push the
button, reset to 0 when this value is read */
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+   struct input_dev *button_dev;	/* webcam snapshot button input */
+#endif
 
    /*** Misc. data ***/
    wait_queue_head_t frameq;		/* When waiting for a frame to finish...
*/
diff -uNr a/linux/drivers/media/video/pwc/pwc-if.c
b/linux/drivers/media/video/pwc/pwc-if.c
--- a/linux/drivers/media/video/pwc/pwc-if.c	2009-01-03
20:03:43.000000000 +0700
+++ b/linux/drivers/media/video/pwc/pwc-if.c	2009-01-10
11:26:44.000000000 +0700
@@ -53,6 +53,7 @@
    - Xavier Roche: QuickCam Pro 4000 ID
    - Jens Knudsen: QuickCam Zoom ID
    - J. Debert: QuickCam for Notebooks ID
+   - Pham Thanh Nam: webcam snapshot button as an event input device
 */
 
 #include <linux/errno.h>
@@ -61,6 +62,13 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 18)
+#include <linux/usb_input.h>
+#else
+#include <linux/usb/input.h>
+#endif
+#endif
 #include <linux/vmalloc.h>
 #include <linux/version.h>
 #include <asm/io.h>
@@ -587,6 +595,23 @@
 				pdev->vframe_count);
 }
 
+static void pwc_snapshot_button(struct pwc_device *pdev, int down)
+{
+	if (down) {
+		PWC_TRACE("Snapshot button pressed.\n");
+		pdev->snapshot_button_status = 1;
+	} else {
+		PWC_TRACE("Snapshot button released.\n");
+	}
+
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	if (pdev->button_dev) {
+		input_report_key(pdev->button_dev, BTN_0, down);
+		input_sync(pdev->button_dev);
+	}
+#endif
+}
+
 static int pwc_rcv_short_packet(struct pwc_device *pdev, const struct
pwc_frame_buf *fbuf)
 {
 	int awake = 0;
@@ -604,13 +629,7 @@
 			pdev->vframes_error++;
 		}
 		if ((ptr[0] ^ pdev->vmirror) & 0x01) {
-			if (ptr[0] & 0x01) {
-				pdev->snapshot_button_status = 1;
-				PWC_TRACE("Snapshot button pressed.\n");
-			}
-			else {
-				PWC_TRACE("Snapshot button released.\n");
-			}
+			pwc_snapshot_button(pdev, ptr[0] & 0x01);
 		}
 		if ((ptr[0] ^ pdev->vmirror) & 0x02) {
 			if (ptr[0] & 0x02)
@@ -634,12 +653,7 @@
 	else if (pdev->type == 740 || pdev->type == 720) {
 		unsigned char *ptr = (unsigned char *)fbuf->data;
 		if ((ptr[0] ^ pdev->vmirror) & 0x01) {
-			if (ptr[0] & 0x01) {
-				pdev->snapshot_button_status = 1;
-				PWC_TRACE("Snapshot button pressed.\n");
-			}
-			else
-				PWC_TRACE("Snapshot button released.\n");
+			pwc_snapshot_button(pdev, ptr[0] & 0x01);
 		}
 		pdev->vmirror = ptr[0] & 0x03;
 	}
@@ -1221,6 +1235,15 @@
 {
 	pwc_remove_sysfs_files(pdev->vdev);
 	video_unregister_device(pdev->vdev);
+
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	if (pdev->button_dev) {
+		input_unregister_device(pdev->button_dev);
+		input_free_device(pdev->button_dev);
+		kfree(pdev->button_dev->phys);
+		pdev->button_dev = NULL;
+	}
+#endif
 }
 
 /* Note that all cleanup is done in the reverse order as in _open */
@@ -1488,6 +1511,9 @@
 	int features = 0;
 	int video_nr = -1; /* default: use next available device */
 	char serial_number[30], *name;
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	char *phys = NULL;
+#endif
 
 	vendor_id = le16_to_cpu(udev->descriptor.idVendor);
 	product_id = le16_to_cpu(udev->descriptor.idProduct);
@@ -1812,6 +1838,39 @@
 	pwc_set_leds(pdev, 0, 0);
 	pwc_camera_power(pdev, 0);
 
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	/* register webcam snapshot button input device */
+	pdev->button_dev = input_allocate_device();
+	if (!pdev->button_dev) {
+		PWC_ERROR("Err, insufficient memory for webcam snapshot button
device.");
+		return -ENOMEM;
+	}
+
+	pdev->button_dev->name = "PWC snapshot button";
+	phys = kasprintf(GFP_KERNEL,"usb-%s-%s", pdev->udev->bus->bus_name,
pdev->udev->devpath);
+	if (!phys) {
+		input_free_device(pdev->button_dev);
+		return -ENOMEM;
+	}
+	pdev->button_dev->phys = phys;
+	usb_to_input_id(pdev->udev, &pdev->button_dev->id);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	pdev->button_dev->dev.parent = &pdev->udev->dev;
+#else
+	pdev->button_dev->cdev.dev = &pdev->udev->dev;
+#endif
+	pdev->button_dev->evbit[0] = BIT_MASK(EV_KEY);
+	pdev->button_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+
+	rc = input_register_device(pdev->button_dev);
+	if (rc) {
+		input_free_device(pdev->button_dev);
+		kfree(pdev->button_dev->phys);
+		pdev->button_dev = NULL;
+		return rc;
+	}
+#endif
+
 	return 0;
 
 err_unreg:
*** PATCH ENDS HERE ***
Thanks
> Hi,
> Please review and consider to apply my patch, for following reasons:
> 1. Nobody complains anymore about it :)
> 2. Tested to guarantee working with 2 kinds of Logitech webcam.
> 3. It's quite clearly to see that event input support won't break
> anything existing (and you still have option to disable it in kernel
> configuration if you don't like).
> 4. Consistency of webcam snapshot button support as an event input
> device with other webcam drivers.
> 5. Nowadays, many manufacturers are making webcams with a button on it
> to use in their Windows software (e.g. the software Logitech's Quickcam
> for Logitech webcams). The webcam snapshot button is very convenient
> when you want to take an interesting moment on someone or something by
> one hand (like a digital camera). I've asked a question about this
> problem and it seems that solutions are still null for Linux.
> But now I'm happy because I've found the way to use webcam snapshot
> button with webcam applications (like Cheese) provided that my webcam
> button is supported as an input device.
> ----------
> Sharing my experience on Ubuntu 8.10
> 1. Install gizmod (http://gizmod.sourceforge.net)
> sudo apt-get install gizmod
> 2. Connect webcam and run gizmod at debug mode as superuser:
> sudo gizmod -g
> 3. Open webcam with Cheese and press the snapshot button (button of pwc
> webcam is only usable when webcam is being open)
> When button is pressed, gizmod shows:
> onEvent: Standard -- /dev/input/event12 | [EV_KEY] <BTN_0> c: 0x100 v:
> 0x1
> and when button is released, gizmod shows:
> onEvent: Standard -- /dev/input/event12 | [EV_KEY] <BTN_0> c: 0x100 v:
> 0x0
> Pay attention to "c: 0x100 v:0x0" in the above line, we'll use these
> numbers to configure gizmod.
> 4. Create /etc/gizmod/modules.d/010-Snapshot-Cheese.py with the
> following content (the numbers 0x100 and 0x0 are used):
>     #***
>   #*********************************************************************
> #*************************************************************************
> #*** 
> #*** GizmoDaemon Config Script
> #*** Snapshot Cheese config
> #***
> #*****************************************
>   #*****************************************
>     #***
> 
> """
> 
>   Written by Pham Thanh Nam (phamthanhnam.ptn@gmail.com)
>   
> """
> 
> ############################
> # Imports
> ##########################
> 
> from GizmoDaemon import *
> from GizmoScriptRunningApplication import *
> import subprocess
> 
> ENABLED = True
> VERSION_NEEDED = 3.2
> INTERESTED_CLASSES = [GizmoEventClass.Standard]
> INTERESTED_APPLICATION = "cheese"
> 
> ############################
> # SnapshotCheese Class definition
> ##########################
> 
> class SnapshotCheese(GizmoScriptRunningApplication):
> """
> Snapshot Cheese Event Mapping
> """
> 
> ############################
> # Public Functions
> ##########################
> 
> def onDeviceEvent(self, Event, Gizmo = None):
> """
> Called from Base Class' onEvent method.
> See GizmodDispatcher.onEvent documention for an explanation of this
> function
> """
> 
> # process the key
>    if (Event.Code == 0x100) and (Event.Value == 0x0):
>    Gizmod.Keyboards[0].createEvent(GizmoEventType.EV_KEY,
> GizmoKey.KEY_SPACE)
>    return True
>    else:
>    # unmatched event, keep processing
> return False 
> 
> ############################
> # Private Functions
> ##########################
> 
> def __init__(self):
> """ 
> Default Constructor
> """
> 
> GizmoScriptRunningApplication.__init__(self, ENABLED, VERSION_NEEDED,
> INTERESTED_CLASSES, INTERESTED_APPLICATION)
> 
> ############################
> # SnapshotCheese class end
> ##########################
> 
> # register the user script
> SnapshotCheese()
> 5. Kill gizmod by Ctrl-C and run it again at normal mode:
> sudo gizmod
> 6. Focus to active Cheese window, uncheck countdown option in Cheese and
> try the snapshot button. Happy shots!
> ----------

--=-SGeIQUDlTsSYSMDNDgc5
Content-Disposition: attachment; filename="pwc-snapshot-button.patch"
Content-Type: text/x-patch; name="pwc-snapshot-button.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

This patch adds support for Philips webcam snapshot button as an
event input device, for consistency with other webcam drivers.
Signed-off-by: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>

diff -uNr a/linux/drivers/media/video/pwc/Kconfig b/linux/drivers/media/video/pwc/Kconfig
--- a/linux/drivers/media/video/pwc/Kconfig	2009-01-03 20:03:43.000000000 +0700
+++ b/linux/drivers/media/video/pwc/Kconfig	2009-01-09 16:09:45.000000000 +0700
@@ -35,3 +35,13 @@
 	  Say Y here in order to have the pwc driver generate verbose debugging
 	  messages.
 	  A special module options 'trace' is used to control the verbosity.
+
+config USB_PWC_INPUT_EVDEV
+	bool "USB Philips Cameras input events device support"
+	default y
+	depends on USB_PWC && INPUT
+	---help---
+	  This option makes USB Philips cameras register the snapshot button as
+	  an input device to report button events.
+
+	  If you are in doubt, say Y.
diff -uNr a/linux/drivers/media/video/pwc/pwc.h b/linux/drivers/media/video/pwc/pwc.h
--- a/linux/drivers/media/video/pwc/pwc.h	2009-01-03 20:03:43.000000000 +0700
+++ b/linux/drivers/media/video/pwc/pwc.h	2009-01-09 17:06:04.000000000 +0700
@@ -38,6 +38,9 @@
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+#include <linux/input.h>
+#endif
 
 #include "pwc-uncompress.h"
 #include <media/pwc-ioctl.h>
@@ -256,6 +259,9 @@
    int pan_angle;			/* in degrees * 100 */
    int tilt_angle;			/* absolute angle; 0,0 is home position */
    int snapshot_button_status;		/* set to 1 when the user push the button, reset to 0 when this value is read */
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+   struct input_dev *button_dev;	/* webcam snapshot button input */
+#endif
 
    /*** Misc. data ***/
    wait_queue_head_t frameq;		/* When waiting for a frame to finish... */
diff -uNr a/linux/drivers/media/video/pwc/pwc-if.c b/linux/drivers/media/video/pwc/pwc-if.c
--- a/linux/drivers/media/video/pwc/pwc-if.c	2009-01-03 20:03:43.000000000 +0700
+++ b/linux/drivers/media/video/pwc/pwc-if.c	2009-01-10 11:26:44.000000000 +0700
@@ -53,6 +53,7 @@
    - Xavier Roche: QuickCam Pro 4000 ID
    - Jens Knudsen: QuickCam Zoom ID
    - J. Debert: QuickCam for Notebooks ID
+   - Pham Thanh Nam: webcam snapshot button as an event input device
 */
 
 #include <linux/errno.h>
@@ -61,6 +62,13 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 18)
+#include <linux/usb_input.h>
+#else
+#include <linux/usb/input.h>
+#endif
+#endif
 #include <linux/vmalloc.h>
 #include <linux/version.h>
 #include <asm/io.h>
@@ -587,6 +595,23 @@
 				pdev->vframe_count);
 }
 
+static void pwc_snapshot_button(struct pwc_device *pdev, int down)
+{
+	if (down) {
+		PWC_TRACE("Snapshot button pressed.\n");
+		pdev->snapshot_button_status = 1;
+	} else {
+		PWC_TRACE("Snapshot button released.\n");
+	}
+
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	if (pdev->button_dev) {
+		input_report_key(pdev->button_dev, BTN_0, down);
+		input_sync(pdev->button_dev);
+	}
+#endif
+}
+
 static int pwc_rcv_short_packet(struct pwc_device *pdev, const struct pwc_frame_buf *fbuf)
 {
 	int awake = 0;
@@ -604,13 +629,7 @@
 			pdev->vframes_error++;
 		}
 		if ((ptr[0] ^ pdev->vmirror) & 0x01) {
-			if (ptr[0] & 0x01) {
-				pdev->snapshot_button_status = 1;
-				PWC_TRACE("Snapshot button pressed.\n");
-			}
-			else {
-				PWC_TRACE("Snapshot button released.\n");
-			}
+			pwc_snapshot_button(pdev, ptr[0] & 0x01);
 		}
 		if ((ptr[0] ^ pdev->vmirror) & 0x02) {
 			if (ptr[0] & 0x02)
@@ -634,12 +653,7 @@
 	else if (pdev->type == 740 || pdev->type == 720) {
 		unsigned char *ptr = (unsigned char *)fbuf->data;
 		if ((ptr[0] ^ pdev->vmirror) & 0x01) {
-			if (ptr[0] & 0x01) {
-				pdev->snapshot_button_status = 1;
-				PWC_TRACE("Snapshot button pressed.\n");
-			}
-			else
-				PWC_TRACE("Snapshot button released.\n");
+			pwc_snapshot_button(pdev, ptr[0] & 0x01);
 		}
 		pdev->vmirror = ptr[0] & 0x03;
 	}
@@ -1221,6 +1235,15 @@
 {
 	pwc_remove_sysfs_files(pdev->vdev);
 	video_unregister_device(pdev->vdev);
+
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	if (pdev->button_dev) {
+		input_unregister_device(pdev->button_dev);
+		input_free_device(pdev->button_dev);
+		kfree(pdev->button_dev->phys);
+		pdev->button_dev = NULL;
+	}
+#endif
 }
 
 /* Note that all cleanup is done in the reverse order as in _open */
@@ -1488,6 +1511,9 @@
 	int features = 0;
 	int video_nr = -1; /* default: use next available device */
 	char serial_number[30], *name;
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	char *phys = NULL;
+#endif
 
 	vendor_id = le16_to_cpu(udev->descriptor.idVendor);
 	product_id = le16_to_cpu(udev->descriptor.idProduct);
@@ -1812,6 +1838,39 @@
 	pwc_set_leds(pdev, 0, 0);
 	pwc_camera_power(pdev, 0);
 
+#ifdef CONFIG_USB_PWC_INPUT_EVDEV
+	/* register webcam snapshot button input device */
+	pdev->button_dev = input_allocate_device();
+	if (!pdev->button_dev) {
+		PWC_ERROR("Err, insufficient memory for webcam snapshot button device.");
+		return -ENOMEM;
+	}
+
+	pdev->button_dev->name = "PWC snapshot button";
+	phys = kasprintf(GFP_KERNEL,"usb-%s-%s", pdev->udev->bus->bus_name, pdev->udev->devpath);
+	if (!phys) {
+		input_free_device(pdev->button_dev);
+		return -ENOMEM;
+	}
+	pdev->button_dev->phys = phys;
+	usb_to_input_id(pdev->udev, &pdev->button_dev->id);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	pdev->button_dev->dev.parent = &pdev->udev->dev;
+#else
+	pdev->button_dev->cdev.dev = &pdev->udev->dev;
+#endif
+	pdev->button_dev->evbit[0] = BIT_MASK(EV_KEY);
+	pdev->button_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+
+	rc = input_register_device(pdev->button_dev);
+	if (rc) {
+		input_free_device(pdev->button_dev);
+		kfree(pdev->button_dev->phys);
+		pdev->button_dev = NULL;
+		return rc;
+	}
+#endif
+
 	return 0;
 
 err_unreg:

--=-SGeIQUDlTsSYSMDNDgc5--

