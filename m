Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m844e2mt016084
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 00:40:03 -0400
Received: from mx3.decknet.fr (mx3.decknet.fr [195.80.159.101])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m844dmS5013394
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 00:39:49 -0400
Received: from cpe-24-28-75-20.austin.res.rr.com ([24.28.75.20]
	helo=[192.168.2.2]) by mx3.decknet.fr with esmtpa (Exim 4.50)
	id 1Kb6dG-0006GT-MS
	for video4linux-list@redhat.com; Thu, 04 Sep 2008 06:39:47 +0200
Message-ID: <48BF668F.3080409@zago.net>
Date: Wed, 03 Sep 2008 23:39:43 -0500
From: Frank Zago <frank@zago.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [PATCH] V4L2 driver for some Fujifilm cameras
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

Hello,

This driver supports several Fujifilm finepix camera in webcam mode 
(manufactured from 2000 to 2004). It's a rewrite on the existing finepix 
driver at http://sourceforge.net/projects/fpix/. The jpeg decrompressor and 
V4L1 support are gone. It is necessary to use libv4l2 to get pictures from 
those webcams. Tested with xawtv, vlc and ekiga.

I'd like to have some comments on it before I submit it for inclusion.

Patch applies against current Linus git tree.

Signed-off-by: Frank Zago <frank at zago dot net>

Regards,
   Frank.


diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ecbfa1b..c98f524 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -903,6 +903,22 @@ config USB_STKWEBCAM
  	  To compile this driver as a module, choose M here: the
  	  module will be called stkwebcam.

+config USB_FINEPIX
+	tristate "USB Fujifilm Finepix Webcam support"
+	depends on VIDEO_V4L2
+	---help---
+	  Say Y here if you want to use this type of camera.  The
+	  camera must be configured in webcam mode (as opposed to
+	  storage mode). The following models are known to work: 2600,
+	  4800Zoom, 6800Zoom, A101, F601Zoom, S602Zoom, F402, M603,
+	  A202, F700, F410, A310, A205, S7000, S5000, S3000,
+	  F420. Some other older models may also work. Recent models
+	  should be supported by the UVC driver. See
+	  http://www.zago.net/v4l2/finepix/index.html.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called finepix.
+
  config USB_S2255
  	tristate "USB Sensoray 2255 video capture device"
  	depends on VIDEO_V4L2
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index bbc6f8b..6a1e70d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_USB_STV680)        += stv680.o
  obj-$(CONFIG_USB_W9968CF)       += w9968cf.o
  obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
  obj-$(CONFIG_USB_STKWEBCAM)     += stkwebcam.o
+obj-$(CONFIG_USB_FINEPIX)       += finepix.o

  obj-$(CONFIG_USB_SN9C102)       += sn9c102/
  obj-$(CONFIG_USB_ET61X251)      += et61x251/
diff --git a/drivers/media/video/finepix.c b/drivers/media/video/finepix.c
new file mode 100644
index 0000000..55426b8
--- /dev/null
+++ b/drivers/media/video/finepix.c
@@ -0,0 +1,1290 @@
+/*
+ * V4L2 USB driver for Fujifilm FinePix cameras
+ *
+ * Copyright (C) 2004-2008 Frank Zago
+ * Copyright (C) 2004 Luc Willems
+ *
+ * This driver is based on the USB skeleton driver
+ * Copyright (C) 2001-2004 Greg Kroah-Hartman (greg@kroah.com)
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License as
+ *  published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/usb.h>
+#include <linux/device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <linux/kref.h>
+
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+#endif
+
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include "finepix.h"
+
+/* Table of supported devices */
+static struct usb_device_id fpix_table[] = {
+	{FPIX_DEV(USB_FINEPIX_4800_PID, "Fujifilm FinePix 4800")},
+	{FPIX_DEV(USB_FINEPIX_A202_PID, "Fujifilm FinePix A202")},
+	{FPIX_DEV(USB_FINEPIX_A203_PID, "Fujifilm FinePix A203")},
+	{FPIX_DEV(USB_FINEPIX_A204_PID, "Fujifilm FinePix A204")},
+	{FPIX_DEV(USB_FINEPIX_A205_PID, "Fujifilm FinePix A205")},
+	{FPIX_DEV(USB_FINEPIX_A210_PID, "Fujifilm FinePix A210")},
+	{FPIX_DEV(USB_FINEPIX_A303_PID, "Fujifilm FinePix A303")},
+	{FPIX_DEV(USB_FINEPIX_A310_PID, "Fujifilm FinePix A310")},
+	{FPIX_DEV(USB_FINEPIX_F401_PID, "Fujifilm FinePix F401")},
+	{FPIX_DEV(USB_FINEPIX_F402_PID, "Fujifilm FinePix F402")},
+	{FPIX_DEV(USB_FINEPIX_F410_PID, "Fujifilm FinePix F410")},
+	{FPIX_DEV(USB_FINEPIX_F601_PID, "Fujifilm FinePix F601")},
+	{FPIX_DEV(USB_FINEPIX_F700_PID, "Fujifilm FinePix F700")},
+	{FPIX_DEV(USB_FINEPIX_M603_PID, "Fujifilm FinePix M603")},
+	{FPIX_DEV(USB_FINEPIX_S3000_PID, "Fujifilm FinePix S3000")},
+	{FPIX_DEV(USB_FINEPIX_S304_PID, "Fujifilm FinePix S304")},
+	{FPIX_DEV(USB_FINEPIX_S5000_PID, "Fujifilm FinePix S5000")},
+	{FPIX_DEV(USB_FINEPIX_S602_PID, "Fujifilm FinePix S602")},
+	{FPIX_DEV(USB_FINEPIX_S7000_PID, "Fujifilm FinePix S7000")},
+	{FPIX_DEV(USB_FINEPIX_X1_PID, "Fujifilm FinePix unknown model")},
+	{FPIX_DEV(USB_FINEPIX_X2_PID, "Fujifilm FinePix unknown model")},
+	{FPIX_DEV(USB_FINEPIX_X3_PID, "Fujifilm FinePix unknown model")},
+	{FPIX_DEV(USB_FINEPIX_F420_PID, "Fujifilm FinePix F420")},
+
+	/* Terminating entry */
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, fpix_table);
+
+/* Module parameter */
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Enable debug");
+
+/*--------------------------------------------------------------------------*/
+
+/* Initialize the device */
+static int fpix_initialize_device(struct usb_fpix *dev)
+{
+	int ret;
+	int size_ret;
+
+	/* Reset bulk in endpoint */
+	usb_clear_halt(dev->udev, dev->bulk_in_endpointAddr);
+
+	/* Init the device */
+	memset(dev->control_buffer, 0, 12);
+	dev->control_buffer[0] = 0xc6;
+	dev->control_buffer[8] = 0x20;
+
+	ret = usb_control_msg(dev->udev,
+			      usb_sndctrlpipe(dev->udev, 0),
+			      USB_REQ_GET_STATUS,
+			      USB_DIR_OUT | USB_TYPE_CLASS |
+			      USB_RECIP_INTERFACE, 0, 0, dev->control_buffer,
+			      12, FPIX_TIMEOUT);
+	if (ret != 12) {
+		dev_err(&dev->udev->dev, "usb_control_msg failed (%d)\n", ret);
+		return -EIO;
+	}
+
+	/* Read the result of the command. Ignore the result, for it
+	 * varies with the device. */
+	ret = usb_bulk_msg(dev->udev,
+			   usb_rcvbulkpipe(dev->udev,
+					   dev->bulk_in_endpointAddr),
+			   dev->control_buffer, FPIX_MAX_TRANSFER, &size_ret,
+			   FPIX_TIMEOUT);
+	if (ret != 0) {
+		dev_err(&dev->udev->dev, "usb_bulk_msg failed (%d)\n", ret);
+		return -EIO;
+	}
+
+	/* Request a frame, but don't read it */
+	memset(dev->control_buffer, 0, 12);
+	dev->control_buffer[0] = 0xd3;
+	dev->control_buffer[7] = 0x01;
+
+	ret = usb_control_msg(dev->udev,
+			      usb_sndctrlpipe(dev->udev, 0),
+			      USB_REQ_GET_STATUS,
+			      USB_DIR_OUT | USB_TYPE_CLASS |
+			      USB_RECIP_INTERFACE, 0, 0, dev->control_buffer,
+			      12, FPIX_TIMEOUT);
+	if (ret != 12) {
+		dev_err(&dev->udev->dev, "usb_control_msg failed (%d)\n", ret);
+		return -EIO;
+	}
+
+	/* Again, reset bulk in endpoints */
+	usb_clear_halt(dev->udev, dev->bulk_in_endpointAddr);
+
+	return 0;
+}
+
+/*--------------------------------------------------------------------------*/
+
+/**
+ *  fpix_delete
+ */
+static void fpix_delete(struct kref *kref)
+{
+	struct usb_fpix *dev = container_of(kref, struct usb_fpix, kref);
+
+	usb_put_dev(dev->udev);
+
+	usb_free_urb(dev->control_urb);
+	usb_free_urb(dev->bulk_in_urb);
+	kfree(dev->control_buffer);
+
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove(dev->debug_state);
+	debugfs_remove(dev->debug_dir);
+#endif
+
+	kfree(dev);
+}
+
+/*--------------------------------------------------------------------------*/
+
+static void timeout_kill(unsigned long data)
+{
+	struct urb *urb = (struct urb *)data;
+
+	usb_unlink_urb(urb);
+}
+
+static void read_frame_part_callback(struct urb *urb);
+
+/* Reads part of a frame */
+static void read_frame_part(struct usb_fpix *dev)
+{
+	int ret;
+	struct fpix_frame *frame = dev->current_frame;
+	unsigned long flags;
+
+	/* Reads part of a frame */
+	usb_fill_bulk_urb(dev->bulk_in_urb,
+			  dev->udev,
+			  usb_rcvbulkpipe(dev->udev, dev->bulk_in_endpointAddr),
+			  frame->buffer + frame->offset,
+			  FPIX_MAX_TRANSFER, read_frame_part_callback, dev);
+
+	dev->bulk_in_urb->transfer_flags = 0;
+
+	spin_lock_irqsave(&dev->state_lock, flags);
+
+	ret = usb_submit_urb(dev->bulk_in_urb, GFP_ATOMIC);
+
+	if (ret) {
+		dev_new_state(FPIX_RESET);
+		schedule_delayed_work(&dev->wqe, 1);
+		dev_err(&dev->udev->dev, "usb_submit_urb failed with %d\n",
+			ret);
+	} else {
+		dev_new_state(FPIX_READ_FRAME_2);
+
+		/* Sometimes we never get a callback, so use a timer.
+		 * Is this masking a bug somewhere else? */
+		dev->bulk_timer.expires = jiffies + msecs_to_jiffies(150);
+		add_timer(&dev->bulk_timer);
+	}
+
+	spin_unlock_irqrestore(&dev->state_lock, flags);
+}
+
+static void read_frame_part_callback(struct urb *urb)
+{
+	struct usb_fpix *dev = urb->context;
+	unsigned long flags_state;
+
+	dev_dbg(&dev->udev->dev, "enter read_frame_part_callback\n");
+
+	del_timer_sync(&dev->bulk_timer);
+
+	spin_lock_irqsave(&dev->state_lock, flags_state);
+
+	if (urb->status != 0) {
+
+		/* We kill a stuck urb every 50 frames on average, so don't
+		 * display a log message for that. */
+		if (urb->status != -ECONNRESET)
+			dev_err(&dev->udev->dev, "bad URB status %d\n",
+				urb->status);
+		dev_new_state(FPIX_RESET);
+		schedule_delayed_work(&dev->wqe, 1);
+		spin_unlock_irqrestore(&dev->state_lock, flags_state);
+
+	} else {
+
+		struct fpix_frame *frame = dev->current_frame;
+
+		/* Adjust frame pointers */
+		frame->offset += urb->actual_length;
+		frame->size_left -= urb->actual_length;
+
+		if (frame->size_left == 0) {
+			/* Apparently the frame is too big for our
+			 * buffers. Never seen that case. */
+			dev_err(&dev->udev->dev,
+				"Destination buffer too small for frame."
+				"Please, report to driver maintainer.\n");
+			dev_new_state(FPIX_READ_FRAME_4);
+			schedule_delayed_work(&dev->wqe, 1);
+			spin_unlock_irqrestore(&dev->state_lock, flags_state);
+		} else if (urb->actual_length < FPIX_MAX_TRANSFER) {
+			/* If the result is less than what was asked
+			 * for, then it's the end of the frame. */
+			unsigned long flags_lists;
+
+			spin_lock_irqsave(&dev->lists_lock, flags_lists);
+
+			list_del(&frame->item);
+			list_add_tail(&frame->item, &dev->done_buffers);
+
+			frame->flags =
+			    V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE;
+
+			spin_unlock_irqrestore(&dev->lists_lock, flags_lists);
+
+			complete(&dev->frame_done);
+
+			dev_new_state(FPIX_READ_FRAME_4);
+			schedule_delayed_work(&dev->wqe, 1);
+			spin_unlock_irqrestore(&dev->state_lock, flags_state);
+		} else {
+			/* got a partial image */
+			spin_unlock_irqrestore(&dev->state_lock, flags_state);
+
+			read_frame_part(dev);
+		}
+	}
+}
+
+/* Request frame callback */
+static void request_frame_callback(struct urb *urb)
+{
+	struct usb_fpix *dev = urb->context;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->state_lock, flags);
+
+	if (urb->status != 0) {
+
+		if (urb->status != -ETIMEDOUT)
+			dev_err(&dev->udev->dev, "bad URB status %d\n",
+				urb->status);
+
+		dev_new_state(FPIX_RESET);
+		schedule_delayed_work(&dev->wqe, 1);
+		spin_unlock_irqrestore(&dev->state_lock, flags);
+
+	} else {
+		dev_new_state(FPIX_READ_FRAME_1);
+		spin_unlock_irqrestore(&dev->state_lock, flags);
+
+		read_frame_part(dev);
+	}
+}
+
+/* Request a new frame */
+static void request_frame(struct usb_fpix *dev)
+{
+	int ret;
+	struct fpix_frame *frame;
+	unsigned long flags;
+
+	/* Ensure there is a frame queued. */
+	spin_lock_irqsave(&dev->lists_lock, flags);
+
+	if (list_empty(&dev->queued_buffers)) {
+		/* Skip that frame */
+		spin_unlock_irqrestore(&dev->lists_lock, flags);
+		schedule_delayed_work(&dev->wqe, NEXT_FRAME_DELAY);
+		return;
+	} else {
+		frame = dev->current_frame =
+		    list_entry(dev->queued_buffers.next, struct fpix_frame,
+			       item);
+	}
+
+	spin_unlock_irqrestore(&dev->lists_lock, flags);
+
+	/* Setup command packet */
+	memset(dev->control_buffer, 0, 12);
+	dev->control_buffer[0] = 0xd3;
+	dev->control_buffer[7] = 0x01;
+
+	/* Request a frame */
+	frame->size_left = FPIX_FRAME_SIZE;
+	frame->offset = 0;
+
+	dev->ctrlreq.bRequestType =
+	    USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE;
+	dev->ctrlreq.bRequest = USB_REQ_GET_STATUS;
+	dev->ctrlreq.wValue = 0;
+	dev->ctrlreq.wIndex = 0;
+	dev->ctrlreq.wLength = cpu_to_le16(12);
+
+	usb_fill_control_urb(dev->control_urb,
+			     dev->udev,
+			     usb_sndctrlpipe(dev->udev, 0),
+			     (unsigned char *)&dev->ctrlreq,
+			     dev->control_buffer,
+			     12, request_frame_callback, dev);
+
+	spin_lock_irqsave(&dev->state_lock, flags);
+
+	ret = usb_submit_urb(dev->control_urb, GFP_ATOMIC);
+	if (ret) {
+		dev_new_state(FPIX_RESET);
+		dev_err(&dev->udev->dev, "usb_submit_urb failed with %d\n",
+			ret);
+		schedule_delayed_work(&dev->wqe, 1);
+	} else {
+		dev_new_state(FPIX_REQ_FRAME_2);
+	}
+
+	spin_unlock_irqrestore(&dev->state_lock, flags);
+}
+
+/*--------------------------------------------------------------------------*/
+
+/* Fallback state machine. */
+static void fpix_sm(struct work_struct *work)
+{
+	struct usb_fpix *dev = container_of(work, struct usb_fpix, wqe.work);
+	int ret;
+
+	mutex_lock(&dev->io_mutex);
+
+	/* verify that the device wasn't unplugged */
+	if (!dev->present) {
+		dev_dbg(&dev->udev->dev, "device is gone\n");
+		complete_all(&dev->frame_done);
+		complete(&dev->can_close);
+		mutex_unlock(&dev->io_mutex);
+		return;
+	}
+
+	switch (dev->state) {
+	case FPIX_RESET:
+		dev_dbg(&dev->udev->dev, "reseting device\n");
+
+		/* Init the device */
+		memset(dev->control_buffer, 0, 12);
+		dev->control_buffer[0] = 0xc6;
+		dev->control_buffer[8] = 0x20;
+
+		ret = usb_control_msg(dev->udev,
+				      usb_sndctrlpipe(dev->udev, 0),
+				      USB_REQ_GET_STATUS,
+				      USB_DIR_OUT | USB_TYPE_CLASS |
+				      USB_RECIP_INTERFACE, 0, 0,
+				      dev->control_buffer, 12, FPIX_TIMEOUT);
+		if (ret != 12) {
+			dev_err(&dev->udev->dev,
+				"usb_control_msg failed (%d)\n", ret);
+		}
+
+		usb_clear_halt(dev->udev, dev->bulk_in_endpointAddr);
+
+		dev_new_state(FPIX_REQ_FRAME_1);
+		schedule_delayed_work(&dev->wqe, HZ / 10);
+		break;
+
+	case FPIX_READ_FRAME_4:
+		if (list_empty(&dev->queued_buffers)) {
+			dev_new_state(FPIX_NOP);
+
+			if (dev->must_stop)
+				complete(&dev->can_close);
+
+		} else {
+			dev_new_state(FPIX_REQ_FRAME_1);
+			schedule_delayed_work(&dev->wqe, NEXT_FRAME_DELAY);
+		}
+		break;
+
+	case FPIX_REQ_FRAME_1:
+		if (dev->must_stop) {
+			complete_all(&dev->frame_done);
+			dev_new_state(FPIX_NOP);
+			complete(&dev->can_close);
+			mutex_unlock(&dev->io_mutex);
+			return;
+		}
+
+		request_frame(dev);
+		break;
+
+	case FPIX_NOP:
+	case FPIX_REQ_FRAME_2:
+	case FPIX_READ_FRAME_1:
+	case FPIX_READ_FRAME_2:
+		dev_err(&dev->udev->dev, "invalid state %d\n", dev->state);
+		break;
+	}
+
+	mutex_unlock(&dev->io_mutex);
+}
+
+/* Start streaming */
+static void start_streaming(struct usb_fpix *dev)
+{
+	mutex_lock(&dev->io_mutex);
+
+	if (!dev->present) {
+		complete_all(&dev->frame_done);
+		complete(&dev->can_close);
+		mutex_unlock(&dev->io_mutex);
+		return;
+	}
+
+	if (dev->state == FPIX_NOP) {
+
+		init_completion(&dev->can_close);
+
+		dev_new_state(FPIX_REQ_FRAME_1);
+
+		schedule_delayed_work(&dev->wqe, 1);
+	}
+
+	mutex_unlock(&dev->io_mutex);
+}
+
+/* Queue a new frame. frame_num is valid.
+ * Returns <0 on error. */
+static int queue_frame(struct usb_fpix *dev, int frame_num)
+{
+	struct fpix_frame *frame = &dev->frame[frame_num];
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&dev->lists_lock, flags);
+
+	if (frame->flags & V4L2_BUF_FLAG_QUEUED) {
+		/* Already queued */
+		dev_err(&dev->udev->dev,
+			"App is trying to queue an already"
+			"queued buffer (index=%d)\n", frame_num);
+		ret = -EINVAL;
+	} else {
+		/* Remove from either the done or free list */
+		list_del(&frame->item);
+		list_add_tail(&frame->item, &dev->queued_buffers);
+
+		frame->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED;
+		ret = 0;
+	}
+
+	spin_unlock_irqrestore(&dev->lists_lock, flags);
+
+	if (ret == 0)
+		start_streaming(dev);
+
+	return ret;
+}
+
+/* Stop streaming */
+static void stop_streaming(struct usb_fpix *dev)
+{
+	/* Stop the state machine */
+	mutex_lock(&dev->io_mutex);
+
+	if (dev->state != FPIX_NOP) {
+		dev->must_stop = 1;
+		mutex_unlock(&dev->io_mutex);
+
+		wait_for_completion(&dev->can_close);
+
+		dev->must_stop = 0;
+	} else {
+		mutex_unlock(&dev->io_mutex);
+	}
+}
+
+/* Free the resources allocated for the frames. */
+static void deallocate_frames(struct usb_fpix *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->nb_frames; i++) {
+		struct fpix_frame *frame = &dev->frame[i];
+
+		if (frame->buffer) {
+			memset(frame->buffer, 0, FPIX_FRAME_SIZE);
+			kfree(frame->buffer);
+			frame->buffer = NULL;
+		}
+	}
+
+	dev->nb_frames = 0;
+}
+
+/* Allocate the ressources for the frames. */
+static int allocate_frames(struct usb_fpix *dev, unsigned int nb_frames)
+{
+	int i;
+	int ret;
+
+	if (nb_frames > FPIX_MAX_FRAMES || dev->nb_frames != 0)
+		return -EINVAL;
+
+	memset(dev->frame, 0, sizeof(dev->frame));
+
+	/* Allocate the buffers to hold the frames. */
+	for (i = 0; i < nb_frames; i++) {
+
+		struct fpix_frame *frame = &dev->frame[i];
+
+		frame->index = i;
+
+		frame->buffer = kmalloc(FPIX_FRAME_SIZE, GFP_KERNEL);
+
+		if (frame->buffer == NULL) {
+			dev_err(&dev->udev->dev,
+				"Couldn't allocate a buffer for a frame\n");
+			ret = -ENOMEM;
+			goto done;
+		}
+
+		/* Since this memory is going to be user mmaped, erase its
+		 * current content. */
+		memset(frame->buffer, 0, FPIX_FRAME_SIZE);
+
+		/* Link the frame to the free list */
+		list_add_tail(&frame->item, &dev->free_buffers);
+
+		dev->nb_frames++;
+	}
+
+	ret = 0;
+
+ done:
+	if (ret)
+		deallocate_frames(dev);
+
+	return ret;
+}
+
+/*--------------------------------------------------------------------------*/
+/* IOCTLs */
+
+static int fpix_vidioc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
+	cap->version = KERNEL_VERSION(0, 92, 0);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int fpix_vidioc_enum_input(struct file *file, void *priv,
+				  struct v4l2_input *input)
+{
+	int ret;
+
+	if (input->index != 0) {
+		ret = -EINVAL;
+	} else {
+		strlcpy(input->name, "USB", sizeof(input->name));
+		input->type = V4L2_INPUT_TYPE_CAMERA;
+		input->std = V4L2_STD_UNKNOWN;
+
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_g_input(struct file *file, void *priv,
+			       unsigned int *input)
+{
+	*input = 0;
+	return 0;
+}
+
+static int fpix_vidioc_s_input(struct file *file, void *priv,
+			       unsigned int input)
+{
+	if (input != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int fpix_vidioc_queryctrl(struct file *file, void *priv,
+				 struct v4l2_queryctrl *control)
+{
+	/* This device doesn't support anything */
+	return -EINVAL;
+}
+
+static int fpix_vidioc_s_ctrl(struct file *file, void *priv,
+			      struct v4l2_control *control)
+{
+	/* This device doesn't support anything */
+	return -EINVAL;
+}
+
+static int fpix_vidioc_g_ctrl(struct file *file, void *priv,
+			      struct v4l2_control *control)
+{
+	/* This device doesn't support anything */
+	return -EINVAL;
+}
+
+static int fpix_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_fmtdesc *format)
+{
+	int ret;
+
+	if (format->index > 0) {
+		ret = -EINVAL;
+	} else if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		ret = -EINVAL;
+	} else {
+		format->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		format->flags = V4L2_FMT_FLAG_COMPRESSED;
+		strlcpy(format->description, "JPEG",
+			sizeof(format->description));
+		format->pixelformat = V4L2_PIX_FMT_JPEG;
+		memset(format->reserved, 0, sizeof(format->reserved));
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				       struct v4l2_format *format)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	int ret;
+
+	if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    format->fmt.pix.pixelformat != V4L2_PIX_FMT_JPEG) {
+		ret = -EINVAL;
+	} else {
+		format->fmt.pix = dev->pix;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				     struct v4l2_format *format)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	int ret;
+
+	if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		ret = -EINVAL;
+	} else {
+		format->fmt.pix = dev->pix;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				     struct v4l2_format *format)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	int ret;
+
+	if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    format->fmt.pix.pixelformat != V4L2_PIX_FMT_JPEG) {
+		ret = -EINVAL;
+	} else {
+		format->fmt.pix = dev->pix;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_streamon(struct file *file, void *priv,
+				enum v4l2_buf_type type)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+
+	start_streaming(dev);
+
+	return 0;
+}
+
+static int fpix_vidioc_streamoff(struct file *file, void *priv,
+				 enum v4l2_buf_type type)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	int i;
+
+	stop_streaming(dev);
+
+	/* Put all the buffers back on the free list */
+	INIT_LIST_HEAD(&dev->free_buffers);
+	INIT_LIST_HEAD(&dev->queued_buffers);
+	INIT_LIST_HEAD(&dev->done_buffers);
+
+	for (i = 0; i < dev->nb_frames; i++) {
+		struct fpix_frame *frame = &dev->frame[i];
+
+		frame->flags = V4L2_BUF_FLAG_MAPPED;
+
+		list_add_tail(&frame->item, &dev->free_buffers);
+	}
+
+	return 0;
+}
+
+static int fpix_vidioc_g_parm(struct file *file, void *fh,
+			      struct v4l2_streamparm *streamparm)
+{
+	struct v4l2_captureparm *captureparm = &streamparm->parm.capture;
+
+	captureparm->capability = 0;
+	captureparm->capturemode = V4L2_MODE_HIGHQUALITY;
+	captureparm->extendedmode = 0;
+	captureparm->readbuffers = 1;
+	memset(captureparm->reserved, 0, sizeof(captureparm->reserved));
+
+	return 0;
+}
+
+static int fpix_vidioc_reqbufs(struct file *file, void *fh,
+			       struct v4l2_requestbuffers *requestbuffers)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	int ret;
+
+	if (requestbuffers->memory == V4L2_MEMORY_MMAP &&
+	    requestbuffers->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+
+		ret = allocate_frames(dev, requestbuffers->count);
+
+	} else {
+		/* Method not supported */
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_querybuf(struct file *file, void *fh,
+				struct v4l2_buffer *buffer)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	int ret;
+
+	if (buffer->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    buffer->index < dev->nb_frames) {
+
+		buffer->memory = V4L2_MEMORY_MMAP;
+		buffer->m.offset = buffer->index * FPIX_FRAME_SIZE;
+		buffer->length = FPIX_FRAME_SIZE;
+		buffer->flags = dev->frame[buffer->index].flags;
+		buffer->field = V4L2_FIELD_NONE;
+		buffer->sequence = 0;
+
+		ret = 0;
+	} else {
+		dev_err(&dev->udev->dev,
+			"unsupported VIDIOC_QUERYBUF (%d, %d)\n",
+			buffer->type, buffer->index);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_qbuf(struct file *file, void *fh,
+			    struct v4l2_buffer *buffer)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	int ret;
+
+	if (buffer->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    buffer->index < dev->nb_frames) {
+		ret = queue_frame(dev, buffer->index);
+	} else {
+		dev_err(&dev->udev->dev,
+			"unsupported VIDIOC_QBUF (%d, %d)\n",
+			buffer->type, buffer->index);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_dqbuf(struct file *file, void *fh,
+			     struct v4l2_buffer *buffer)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	struct fpix_frame *frame = NULL;
+	int ret;
+
+	if (buffer->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    buffer->memory != V4L2_MEMORY_MMAP) {
+		ret = -EINVAL;
+	} else {
+
+		unsigned long flags;
+
+ dqbuf_again:
+
+		if (dev->present == 0) {
+			/* Device is gone */
+			return -ENODEV;
+		}
+
+		spin_lock_irqsave(&dev->lists_lock, flags);
+
+		if (list_empty(&dev->done_buffers)) {
+			if (dev->nonblocking || dev->state == FPIX_NOP) {
+				ret = -EAGAIN;
+			} else {
+				spin_unlock_irqrestore(&dev->lists_lock, flags);
+				wait_for_completion(&dev->frame_done);
+				goto dqbuf_again;
+			}
+		} else {
+			/* Remove the oldest frame */
+			frame =
+			    list_entry(dev->done_buffers.next,
+				       struct fpix_frame, item);
+
+			list_del(dev->done_buffers.next);
+			list_add_tail(&frame->item, &dev->free_buffers);
+
+			/* TODO: memset necessary ? */
+			memset(buffer, 0, sizeof(*buffer));
+
+			frame->flags = buffer->flags = V4L2_BUF_FLAG_MAPPED;
+
+			buffer->index = frame->index;
+			buffer->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+			buffer->bytesused = frame->offset;
+			buffer->field = V4L2_FIELD_NONE;
+			buffer->memory = V4L2_MEMORY_MMAP;
+
+			ret = 0;
+		}
+
+		spin_unlock_irqrestore(&dev->lists_lock, flags);
+	}
+
+	return ret;
+}
+
+static int fpix_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *parm)
+{
+	return 0;
+}
+
+/**
+ *  fpix_open
+ */
+static int fpix_open(struct inode *inode, struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = container_of(vdev, struct usb_fpix, vdev);
+	int subminor;
+	int retval;
+
+	subminor = iminor(inode);
+
+	/* increment our usage count for the device */
+	kref_get(&dev->kref);
+
+	/* lock the device to allow correctly handling errors
+	 * in resumption */
+	mutex_lock(&dev->io_mutex);
+
+	if (dev->open) {
+		/* Only one process can open it at any given time. */
+		mutex_unlock(&dev->io_mutex);
+		kref_put(&dev->kref, fpix_delete);
+		retval = -EBUSY;
+		goto exit;
+	}
+
+	dev->open++;
+
+	dev->nonblocking = (file->f_flags & O_NONBLOCK);
+
+	/* save our object in the file's private structure */
+	video_set_drvdata(&dev->vdev, dev);
+
+	if (debug)
+		dev->vdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
+
+	/* Initialize the device structure */
+	INIT_DELAYED_WORK(&dev->wqe, fpix_sm);
+	init_completion(&dev->frame_done);
+	dev->must_stop = 0;
+
+	INIT_LIST_HEAD(&dev->free_buffers);
+	INIT_LIST_HEAD(&dev->queued_buffers);
+	INIT_LIST_HEAD(&dev->done_buffers);
+
+	spin_lock_init(&dev->lists_lock);
+	spin_lock_init(&dev->state_lock);
+
+	retval = fpix_initialize_device(dev);
+	if (retval) {
+		dev->open--;
+		dev_err(&dev->udev->dev,
+			"fpix_initialize_device failed with %d.\n", retval);
+		mutex_unlock(&dev->io_mutex);
+		kref_put(&dev->kref, fpix_delete);
+		goto exit;
+	}
+
+	dev->pix.width = FPIX_IMAGE_WIDTH;
+	dev->pix.height = FPIX_IMAGE_HEIGHT;
+	dev->pix.pixelformat = V4L2_PIX_FMT_JPEG;
+	dev->pix.field = V4L2_FIELD_NONE;
+	dev->pix.bytesperline = FPIX_IMAGE_WIDTH * 3;
+	dev->pix.sizeimage = FPIX_IMAGE_WIDTH * FPIX_IMAGE_HEIGHT * 3;
+	dev->pix.colorspace = V4L2_COLORSPACE_SRGB;
+	dev->pix.priv = 0;
+
+	mutex_unlock(&dev->io_mutex);
+
+	retval = 0;
+
+ exit:
+	return retval;
+}
+
+/**
+ *  fpix_release
+ */
+static int fpix_release(struct inode *inode, struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev;
+
+	if (vdev == NULL)
+		return -ENODEV;
+
+	dev = video_get_drvdata(vdev);
+
+	/* Stop the camera if the application didn't do it */
+	stop_streaming(dev);
+
+	/* lock our device */
+	mutex_lock(&dev->io_mutex);
+
+	deallocate_frames(dev);
+
+	dev->open--;
+
+	mutex_unlock(&dev->io_mutex);
+
+	kref_put(&dev->kref, fpix_delete);
+
+	return 0;
+}
+
+static int fpix_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct usb_fpix *dev = video_get_drvdata(vdev);
+	unsigned long start = vma->vm_start;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	unsigned char *pos;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+
+	dev_dbg(&dev->udev->dev, "%s\n", __func__);
+
+	if (size != FPIX_FRAME_SIZE) {
+		dev_dbg(&dev->udev->dev, "mmap: invalid size (%ld)\n", size);
+		return -EINVAL;
+	}
+
+	if (offset % FPIX_FRAME_SIZE != 0) {
+		dev_dbg(&dev->udev->dev,
+			"mmap: invalid start addr (%ld)\n", offset);
+		return -EINVAL;
+	}
+
+	if ((offset / FPIX_FRAME_SIZE) > dev->nb_frames) {
+		dev_dbg(&dev->udev->dev, "mmap: invalid addr (%ld)\n", offset);
+		return -EINVAL;
+	}
+
+	pos = dev->frame[offset / FPIX_FRAME_SIZE].buffer;
+
+	mutex_lock(&dev->io_mutex);
+	vma->vm_flags |= VM_LOCKED;
+
+	if (remap_pfn_range(vma, start, virt_to_phys(pos) >> PAGE_SHIFT,
+			    FPIX_FRAME_SIZE, PAGE_SHARED)) {
+		mutex_unlock(&dev->io_mutex);
+		return -EAGAIN;
+	}
+
+	mutex_unlock(&dev->io_mutex);
+
+	return 0;
+}
+
+static void fpix_vdev_release(struct video_device *vdev)
+{
+	struct usb_fpix *dev = container_of(vdev, struct usb_fpix, vdev);
+
+	dev_dbg(&dev->udev->dev, "fpix_vdev_release - TODO\n");
+}
+
+/*--------------------------------------------------------------------------*/
+
+static struct file_operations fpix_fops = {
+	.owner = THIS_MODULE,
+
+	.ioctl = video_ioctl2,
+	.llseek = no_llseek,
+	.mmap = fpix_mmap,
+	.open = fpix_open,
+	.release = fpix_release,
+};
+
+static const struct v4l2_ioctl_ops fpix_ioctl_ops = {
+	.vidioc_querycap = fpix_vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = fpix_vidioc_enum_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = fpix_vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = fpix_vidioc_s_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = fpix_vidioc_g_fmt_vid_cap,
+	.vidioc_enum_input = fpix_vidioc_enum_input,
+	.vidioc_g_input = fpix_vidioc_g_input,
+	.vidioc_s_input = fpix_vidioc_s_input,
+	.vidioc_streamon = fpix_vidioc_streamon,
+	.vidioc_streamoff = fpix_vidioc_streamoff,
+	.vidioc_queryctrl = fpix_vidioc_queryctrl,
+	.vidioc_g_ctrl = fpix_vidioc_g_ctrl,
+	.vidioc_s_ctrl = fpix_vidioc_s_ctrl,
+	.vidioc_g_parm = fpix_vidioc_g_parm,
+	.vidioc_reqbufs = fpix_vidioc_reqbufs,
+	.vidioc_querybuf = fpix_vidioc_querybuf,
+	.vidioc_qbuf = fpix_vidioc_qbuf,
+	.vidioc_dqbuf = fpix_vidioc_dqbuf,
+	.vidioc_s_std = fpix_vidioc_s_std,
+};
+
+static struct video_device fpix_template = {
+	.name = DRIVER_DESC,
+	.fops = &fpix_fops,
+	.ioctl_ops = &fpix_ioctl_ops,
+	.release = fpix_vdev_release,
+	.minor = -1,
+
+	.tvnorms = V4L2_STD_UNKNOWN,
+	.current_norm = V4L2_STD_UNKNOWN,
+};
+
+/**
+ *  fpix_probe
+ *
+ *  Called by the usb core when a new device is connected that it thinks
+ *  this driver might be interested in.
+ */
+static int fpix_probe(struct usb_interface *interface,
+		      const struct usb_device_id *id)
+{
+	struct usb_fpix *dev;
+	struct usb_device *udev = interface_to_usbdev(interface);
+	int retval = -ENOMEM;
+	struct usb_host_interface *iface_desc;
+	int i;
+#ifdef CONFIG_DEBUG_FS
+	char buf[64];
+#endif
+
+	dev_dbg(&udev->dev, "fpix_probe for device %04x:%04x\n",
+		udev->descriptor.idVendor, udev->descriptor.idProduct);
+
+	/* allocate memory for our device state and initialize it */
+	dev = kzalloc(sizeof(struct usb_fpix), GFP_KERNEL);
+	if (dev == NULL) {
+		dev_err(&dev->udev->dev, "Out of memory\n");
+		return -ENOMEM;
+	}
+
+	kref_init(&dev->kref);
+	mutex_init(&dev->io_mutex);
+	dev->udev = udev;
+	dev->name = (char *)id->driver_info;
+
+	dev->control_buffer = kmalloc(FPIX_MAX_TRANSFER, GFP_KERNEL);
+	if (dev->control_buffer == NULL) {
+		dev_err(&dev->udev->dev, "Out of memory\n");
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	/* set up the endpoint information */
+	/* check out the endpoints */
+	/* use only the first bulk-in, bulk-out and bulk-int endpoints */
+	iface_desc = &interface->altsetting[0];
+
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
+		struct usb_endpoint_descriptor *endpoint =
+		    &iface_desc->endpoint[i].desc;
+		if (!dev->bulk_in_endpointAddr
+		    && (endpoint->bEndpointAddress & USB_DIR_IN)
+		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
+			USB_ENDPOINT_XFER_BULK)) {
+
+			dev->bulk_in_endpointAddr = endpoint->bEndpointAddress;
+
+			dev->bulk_in_urb = usb_alloc_urb(0, GFP_KERNEL);
+			if (!dev->bulk_in_urb) {
+				dev_err(&dev->udev->dev,
+					"No free urbs available\n");
+				goto error;
+			}
+		}
+	}
+
+	if (dev->bulk_in_endpointAddr == 0) {
+		dev_err(&dev->udev->dev, "Couldn't find bulk-in endpoint\n");
+		goto error;
+	}
+
+	init_timer(&dev->bulk_timer);
+	dev->bulk_timer.data = (unsigned long)dev->bulk_in_urb;
+	dev->bulk_timer.function = timeout_kill;
+
+	dev->control_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!dev->control_urb) {
+		dev_err(&dev->udev->dev, "No free urbs available\n");
+		goto error;
+	}
+
+	dev->present = 1;
+
+	/* we can register the device now, as it is ready */
+	usb_set_intfdata(interface, dev);
+
+	dev->vdev = fpix_template;
+
+	if (video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1) == -1) {
+		dev_err(&dev->udev->dev, "video_register_device failed\n");
+		goto error;
+	}
+
+	/* let the user know what node this device is now attached to */
+	dev_info(&dev->udev->dev, "registered new video device: video%d (%s)\n",
+		 dev->vdev.minor, dev->vdev.name);
+
+#ifdef CONFIG_DEBUG_FS
+	/* Create a sub-directory per device. The key is unique at any
+	 * given time but may be reused. */
+	sprintf(buf, "finepix-%p", dev);
+	dev->debug_dir = debugfs_create_dir(buf, NULL);
+	dev->debug_state =
+	    debugfs_create_u32("state", 0444, dev->debug_dir, &dev->state);
+#endif
+
+	return 0;
+
+ error:
+	fpix_delete(&dev->kref);
+	return retval;
+}
+
+/**
+ *  fpix_disconnect
+ *
+ *  Called by the usb core when the device is removed from the system.
+ *
+ *  This routine guarantees that the driver will not submit any more urbs
+ *  by clearing dev->udev.  It is also supposed to terminate any currently
+ *  active urbs.  Unfortunately, usb_bulk_msg(), used in fpix_read(), does
+ *  not provide any way to do this.  But at least we can cancel an active
+ *  write.
+ */
+static void fpix_disconnect(struct usb_interface *interface)
+{
+	struct usb_fpix *dev;
+	int minor;
+
+	dev = usb_get_intfdata(interface);
+	usb_set_intfdata(interface, NULL);
+
+	mutex_lock(&dev->io_mutex);
+
+	dev->present = 0;
+	minor = dev->vdev.minor;
+	video_unregister_device(&dev->vdev);
+
+	mutex_unlock(&dev->io_mutex);
+
+	dev_info(&dev->udev->dev, "USB FinePix #%d now disconnected\n", minor);
+
+	kref_put(&dev->kref, fpix_delete);
+}
+
+static struct usb_driver fpix_driver = {
+	.name = "finepix",
+	.probe = fpix_probe,
+	.disconnect = fpix_disconnect,
+	.id_table = fpix_table
+};
+
+static int __init fpix_init(void)
+{
+	int result;
+
+	/* register this driver with the USB subsystem */
+	result = usb_register(&fpix_driver);
+	if (result) {
+		printk(KERN_ERR "usb_register failed. Error number %d\n",
+		       result);
+		return result;
+	}
+
+	printk(KERN_INFO DRIVER_DESC " " DRIVER_VERSION "\n");
+	return 0;
+}
+
+static void __exit fpix_exit(void)
+{
+	/* deregister this driver with the USB subsystem */
+	usb_deregister(&fpix_driver);
+}
+
+module_init(fpix_init);
+module_exit(fpix_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL v2");
+
+/*
+ * Local variables:
+ * c-basic-offset: 8
+ * End:
+ */
diff --git a/drivers/media/video/finepix.h b/drivers/media/video/finepix.h
new file mode 100644
index 0000000..d491b7e
--- /dev/null
+++ b/drivers/media/video/finepix.h
@@ -0,0 +1,180 @@
+/*
+ * V4L2 USB driver for Fujifilm cameras
+ * This driver potentially support most of the FinePix USB cameras family
+ *
+ * Copyright (C) 2004-2008 Frank Zago
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License as
+ *  published by the Free Software Foundation, version 2.
+ *
+ */
+
+/*--------------------------------------------------------------------------*/
+
+#define DRIVER_NAME "finepix"
+#define DRIVER_DESC "Fujifilm FinePix USB V4L2 driver"
+#define DRIVER_VERSION "0.92.0"	/* also edit KERNEL_VERSION(...) in finepix.c */
+#define DRIVER_AUTHOR "Frank Zago"
+
+/* IDs of cameras the driver supports. Some different cameras have the
+ * same USB ids, so we just keep one here.  */
+#define USB_FUJIFILM_VENDOR_ID  0x04cb
+
+#define USB_FINEPIX_4800_PID	0x0104
+#define USB_FINEPIX_F601_PID	0x0109
+#define USB_FINEPIX_S602_PID	0x010b
+#define USB_FINEPIX_F402_PID	0x010f
+#define USB_FINEPIX_M603_PID	0x0111
+#define USB_FINEPIX_A202_PID	0x0113
+#define USB_FINEPIX_F401_PID	0x0115
+#define USB_FINEPIX_A203_PID	0x0117
+#define USB_FINEPIX_A303_PID	0x0119
+#define USB_FINEPIX_S304_PID	0x011b
+#define USB_FINEPIX_A204_PID	0x011d
+#define USB_FINEPIX_F700_PID	0x0121
+#define USB_FINEPIX_F410_PID	0x0123
+#define USB_FINEPIX_A310_PID	0x0125
+#define USB_FINEPIX_A210_PID	0x0127
+#define USB_FINEPIX_A205_PID	0x0129
+#define USB_FINEPIX_X1_PID		0x012B
+#define USB_FINEPIX_S7000_PID	0x012d
+#define USB_FINEPIX_X2_PID		0x012F
+#define USB_FINEPIX_S5000_PID	0x0131
+#define USB_FINEPIX_X3_PID		0x013b
+#define USB_FINEPIX_S3000_PID	0x013d
+#define USB_FINEPIX_F420_PID	0x013f
+
+/* Default timeout, in ms */
+#define FPIX_TIMEOUT (HZ / 10)
+
+/* Maximum number of frames to keep in memory. Each frame reserves
+ * FPIX_FRAME_SIZE of kmalloc'ed memory, so keep as low as
+ * possible. */
+#define FPIX_MAX_FRAMES 16
+
+/* Maximum transfer size to use. The windows driver reads by chunks of
+ * 0x2000 bytes, so do the same. Note: reading more seems to work
+ * too. */
+#define FPIX_MAX_TRANSFER 0x2000
+
+/* Maximum size of a buffer that holds a frame. 16KB is sometimes not
+ * enough. */
+#define FPIX_FRAME_SIZE (3*FPIX_MAX_TRANSFER)
+
+/* Image size returned by the camera. */
+#define FPIX_IMAGE_WIDTH 320
+#define FPIX_IMAGE_HEIGHT 240
+
+/* Holds a frame informations */
+struct fpix_frame {
+	unsigned char *buffer;	/* The buffer to receive data. This buffer
+				 * must be DMA capable (ie not
+				 * vmalloc'ed). */
+	size_t size;		/* total the size of the receive buffer */
+
+	size_t size_left;
+	size_t offset;
+
+	/* Store the frame in its respective queue (free, queued, done) */
+	struct list_head item;
+
+	/* V4L2 buffer flags (V4L2_BUF_FLAG_xxx) */
+	u32 index;
+	u32 flags;
+};
+
+/* Structure to hold all of our device specific stuff */
+struct usb_fpix {
+
+	/* Pointer to the name stored in fpix_table */
+	char *name;
+
+	/*
+	 * USB stuff
+	 */
+
+	struct usb_ctrlrequest ctrlreq;
+	struct urb *control_urb;
+	unsigned char *control_buffer;
+
+	u8 bulk_in_endpointAddr;	/* address of the bulk in endpoint */
+	struct urb *bulk_in_urb;
+	struct timer_list bulk_timer;
+
+	enum {
+		FPIX_NOP,	/* inactive, else streaming */
+		FPIX_RESET,	/* must reset */
+		FPIX_REQ_FRAME_1,	/* init frame request */
+		FPIX_REQ_FRAME_2,	/* wait for frame request completion */
+		FPIX_READ_FRAME_1,	/* int posted, must read frame */
+		FPIX_READ_FRAME_2,	/* reading frame */
+		FPIX_READ_FRAME_4	/* read complete */
+	} state;
+	spinlock_t state_lock;	/* protects the state */
+
+	int must_stop;		/* must stop streaming */
+
+	/*
+	 * Video stuff
+	 */
+	struct video_device vdev;	/* V4L2 device handler */
+
+	/* List of buffers. Queue at tail, remove at head. */
+	struct list_head free_buffers;
+	struct list_head queued_buffers;
+	struct list_head done_buffers;
+
+	spinlock_t lists_lock;
+
+	unsigned int nb_frames;	/* number of valid frames in frame[] */
+	struct fpix_frame frame[FPIX_MAX_FRAMES];
+	struct fpix_frame *current_frame;
+
+	/*
+	 * Driver stuff
+	 */
+	struct usb_device *udev;	/* save off the usb device pointer */
+	int open;		/* whether the port is open */
+	int present;		/* if the device has been disconnected */
+	struct mutex io_mutex;	/* synchronize I/O with disconnect */
+	struct kref kref;
+	struct delayed_work wqe;
+	struct completion can_close;
+	struct completion frame_done;
+
+	int nonblocking;	/* open can be blocking or non blocking */
+
+	unsigned int mmapped:1;	/* buffers are mapped. */
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debug_dir;
+	struct dentry *debug_state;
+#endif
+
+	struct v4l2_pix_format pix;	/* V4L2_PIX_FMT_JPEG only */
+};
+
+/* Delay after which claim the next frame. If the delay is too small,
+ * the camera will return old frames. On the 4800Z, 20ms is bad, 25ms
+ * will fail every 4 or 5 frames, but 30ms is perfect. */
+#define NEXT_FRAME_DELAY  (((HZ * 30) + 999) / 1000)
+
+/*
+ * FPIX_DEV
+ * Defines our specific usb device
+ *
+ * This macro is used to create a struct usb_device_id that matches a
+ * FujiFilm FinePix digital camera in PC-CAM mode (i.e. webcam).
+ */
+#define FPIX_DEV(prod,name) 						\
+  .match_flags = (USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_CLASS), \
+    .idVendor = (USB_FUJIFILM_VENDOR_ID),				\
+    .idProduct = (prod), .bInterfaceClass = 255,			\
+      .driver_info = (unsigned long)(name)
+
+#define dev_new_state(new_state) { \
+	dev_dbg(&dev->udev->dev, "new state from %d to %d at %s:%d\n", \
+	dev->state, new_state, __func__, __LINE__); \
+	dev->state = new_state; \
+}



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
