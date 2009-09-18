Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:45553 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbZIRK1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 06:27:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH 2/3] USB gadget: video class function driver
Date: Fri, 18 Sep 2009 12:27:45 +0200
Cc: linux-media@vger.kernel.org, Bryan Wu <cooloney@kernel.org>,
	Mike Frysinger <vapier@gentoo.org>
References: <200909181225.57212.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200909181225.57212.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909181227.45269.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This USB video class function driver implements a video capture device from
the host's point of view. It creates a V4L2 output device on the gadget's
side to transfer data from a userspace application over USB.

The UVC-specific descriptors are passed by the gadget driver to the UVC
function driver, making them completely configurable without any modification
to the function's driver code.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/f_uvc.c      |  673 +++++++++++++++++++++++++++++
 drivers/usb/gadget/f_uvc.h      |  376 +++++++++++++++++
 drivers/usb/gadget/uvc.h        |  299 +++++++++++++
 drivers/usb/gadget/uvc_gadget.c |  890 +++++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/uvc_queue.c  |  583 +++++++++++++++++++++++++
 drivers/usb/gadget/uvc_queue.h  |   90 ++++
 drivers/usb/gadget/uvc_v4l2.c   |  376 +++++++++++++++++
 drivers/usb/gadget/uvc_video.c  |  386 +++++++++++++++++
 8 files changed, 3673 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/gadget/f_uvc.c
 create mode 100644 drivers/usb/gadget/f_uvc.h
 create mode 100644 drivers/usb/gadget/uvc.h
 create mode 100644 drivers/usb/gadget/uvc_gadget.c
 create mode 100644 drivers/usb/gadget/uvc_queue.c
 create mode 100644 drivers/usb/gadget/uvc_queue.h
 create mode 100644 drivers/usb/gadget/uvc_v4l2.c
 create mode 100644 drivers/usb/gadget/uvc_video.c

diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
new file mode 100644
index 0000000..f323960
--- /dev/null
+++ b/drivers/usb/gadget/f_uvc.c
@@ -0,0 +1,674 @@
+/*
+ *	uvc_gadget.c  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/version.h>
+#include <linux/usb/ch9.h>
+#include <linux/usb/gadget.h>
+#include <linux/usb/video.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+
+#include <media/v4l2-dev.h>
+
+#include "uvc.h"
+
+unsigned int uvc_trace_param;
+
+/* --------------------------------------------------------------------------
+ * Function descriptors
+ */
+
+/* string IDs are assigned dynamically */
+
+#define UVC_STRING_ASSOCIATION_IDX		0
+#define UVC_STRING_CONTROL_IDX			1
+#define UVC_STRING_STREAMING_IDX		2
+
+static struct usb_string uvc_en_us_strings[] = {
+	[UVC_STRING_ASSOCIATION_IDX].s = "UVC Camera",
+	[UVC_STRING_CONTROL_IDX].s = "Video Control",
+	[UVC_STRING_STREAMING_IDX].s = "Video Streaming",
+	{  }
+};
+
+static struct usb_gadget_strings uvc_stringtab = {
+	.language = 0x0409,	/* en-us */
+	.strings = uvc_en_us_strings,
+};
+
+static struct usb_gadget_strings *uvc_function_strings[] = {
+	&uvc_stringtab,
+	NULL,
+};
+
+#define UVC_INTF_VIDEO_CONTROL			0
+#define UVC_INTF_VIDEO_STREAMING		1
+
+static struct usb_interface_assoc_descriptor uvc_iad __initdata = {
+	.bLength		= USB_DT_INTERFACE_ASSOCIATION_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE_ASSOCIATION,
+	.bFirstInterface	= 0,
+	.bInterfaceCount	= 2,
+	.bFunctionClass		= USB_CLASS_VIDEO,
+	.bFunctionSubClass	= 0x03,
+	.bFunctionProtocol	= 0x00,
+	.iFunction		= 0,
+};
+
+static struct usb_interface_descriptor uvc_control_intf __initdata = {
+	.bLength		= USB_DT_INTERFACE_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE,
+	.bInterfaceNumber	= UVC_INTF_VIDEO_CONTROL,
+	.bAlternateSetting	= 0,
+	.bNumEndpoints		= 1,
+	.bInterfaceClass	= USB_CLASS_VIDEO,
+	.bInterfaceSubClass	= 0x01,
+	.bInterfaceProtocol	= 0x00,
+	.iInterface		= 0,
+};
+
+static struct usb_endpoint_descriptor uvc_control_ep __initdata = {
+	.bLength		= USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType	= USB_DT_ENDPOINT,
+	.bEndpointAddress	= USB_DIR_IN,
+	.bmAttributes		= USB_ENDPOINT_XFER_INT,
+	.wMaxPacketSize		= cpu_to_le16(16),
+	.bInterval		= 8,
+};
+
+static struct uvc_control_endpoint_descriptor uvc_control_cs_ep __initdata = {
+	.bLength		= UVC_DT_CONTROL_ENDPOINT_SIZE,
+	.bDescriptorType	= USB_DT_CS_ENDPOINT,
+	.bDescriptorSubType	= UVC_EP_INTERRUPT,
+	.wMaxTransferSize	= cpu_to_le16(16),
+};
+
+static struct usb_interface_descriptor uvc_streaming_intf_alt0 __initdata = {
+	.bLength		= USB_DT_INTERFACE_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE,
+	.bInterfaceNumber	= UVC_INTF_VIDEO_STREAMING,
+	.bAlternateSetting	= 0,
+	.bNumEndpoints		= 0,
+	.bInterfaceClass	= USB_CLASS_VIDEO,
+	.bInterfaceSubClass	= 0x02,
+	.bInterfaceProtocol	= 0x00,
+	.iInterface		= 0,
+};
+
+static struct usb_interface_descriptor uvc_streaming_intf_alt1 __initdata = {
+	.bLength		= USB_DT_INTERFACE_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE,
+	.bInterfaceNumber	= UVC_INTF_VIDEO_STREAMING,
+	.bAlternateSetting	= 1,
+	.bNumEndpoints		= 1,
+	.bInterfaceClass	= USB_CLASS_VIDEO,
+	.bInterfaceSubClass	= 0x02,
+	.bInterfaceProtocol	= 0x00,
+	.iInterface		= 0,
+};
+
+static struct usb_endpoint_descriptor uvc_streaming_ep = {
+	.bLength		= USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType	= USB_DT_ENDPOINT,
+	.bEndpointAddress	= USB_DIR_IN,
+	.bmAttributes		= USB_ENDPOINT_XFER_ISOC,
+	.wMaxPacketSize		= cpu_to_le16(1024),
+	.bInterval		= 1,
+};
+
+static const struct usb_descriptor_header * const uvc_fs_streaming[] = {
+	(struct usb_descriptor_header *) &uvc_streaming_intf_alt1,
+	(struct usb_descriptor_header *) &uvc_streaming_ep,
+	NULL,
+};
+
+static const struct usb_descriptor_header * const uvc_hs_streaming[] = {
+	(struct usb_descriptor_header *) &uvc_streaming_intf_alt1,
+	(struct usb_descriptor_header *) &uvc_streaming_ep,
+	NULL,
+};
+
+/* --------------------------------------------------------------------------
+ * Control requests
+ */
+
+static void
+uvc_function_ep0_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct uvc_device *uvc = req->context;
+	struct uvc_event event;
+
+	if (uvc->event_setup_out) {
+		uvc->event_setup_out = 0;
+
+		memset(&event, 0, sizeof(event));
+		event.type = UVC_EVENT_DATA;
+		event.data.length = req->actual;
+		memcpy(&event.data.data, req->buf, req->actual);
+		kfifo_put(uvc->events, (unsigned char*)&event, sizeof(event));
+
+		wake_up(&uvc->event_wait);
+	}
+}
+
+static int
+uvc_function_setup(struct usb_function *f, const struct usb_ctrlrequest *ctrl)
+{
+	struct uvc_device *uvc = to_uvc(f);
+	struct uvc_event event;
+
+	/* printk(KERN_INFO "setup request %02x %02x value %04x index %04x %04x\n",
+	 *	ctrl->bRequestType, ctrl->bRequest, le16_to_cpu(ctrl->wValue),
+	 *	le16_to_cpu(ctrl->wIndex), le16_to_cpu(ctrl->wLength));
+	 */
+
+	if ((ctrl->bRequestType & USB_TYPE_MASK) != USB_TYPE_CLASS) {
+		INFO(f->config->cdev, "invalid request type\n");
+		return -EINVAL;
+	}
+
+	/* Stall too big requests. */
+	if (le16_to_cpu(ctrl->wLength) > UVC_MAX_REQUEST_SIZE)
+		return -EINVAL;
+
+	memset(&event, 0, sizeof(event));
+	event.type = UVC_EVENT_SETUP;
+	memcpy(&event.req, ctrl, sizeof(event.req));
+	kfifo_put(uvc->events, (unsigned char*)&event, sizeof(event));
+
+	wake_up(&uvc->event_wait);
+
+	return 0;
+}
+
+static int
+uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
+{
+	struct uvc_device *uvc = to_uvc(f);
+	struct uvc_event event;
+
+	INFO(f->config->cdev, "uvc_function_set_alt(%u, %u)\n", interface, alt);
+
+	if (interface == uvc->control_intf) {
+		if (alt)
+			return -EINVAL;
+
+		if (uvc->state == UVC_STATE_DISCONNECTED) {
+			memset(&event, 0, sizeof(event));
+			event.type = UVC_EVENT_CONNECT;
+			event.speed = f->config->cdev->gadget->speed;
+			kfifo_put(uvc->events, (unsigned char*)&event,
+				  sizeof(event));
+
+			wake_up(&uvc->event_wait);
+
+			uvc->state = UVC_STATE_CONNECTED;
+		}
+
+		return 0;
+	}
+
+	if (interface != uvc->streaming_intf)
+		return -EINVAL;
+
+	/* TODO
+	if (usb_endpoint_xfer_bulk(&uvc->desc.vs_ep))
+		return alt ? -EINVAL : 0;
+	*/
+
+	switch (alt) {
+	case 0:
+		if (uvc->state != UVC_STATE_STREAMING)
+			return 0;
+
+		if (uvc->video.ep)
+			usb_ep_disable(uvc->video.ep);
+
+		memset(&event, 0, sizeof(event));
+		event.type = UVC_EVENT_STREAMOFF;
+		kfifo_put(uvc->events, (unsigned char*)&event, sizeof(event));
+
+		wake_up(&uvc->event_wait);
+
+		uvc->state = UVC_STATE_CONNECTED;
+		break;
+
+	case 1:
+		if (uvc->state != UVC_STATE_CONNECTED)
+			return 0;
+
+		if (uvc->video.ep)
+			usb_ep_enable(uvc->video.ep, &uvc_streaming_ep);
+
+		memset(&event, 0, sizeof(event));
+		event.type = UVC_EVENT_STREAMON;
+		kfifo_put(uvc->events, (unsigned char*)&event, sizeof(event));
+
+		wake_up(&uvc->event_wait);
+
+		uvc->state = UVC_STATE_STREAMING;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void
+uvc_function_disable(struct usb_function *f)
+{
+	struct uvc_device *uvc = to_uvc(f);
+	struct uvc_event event;
+
+	INFO(f->config->cdev, "uvc_function_disable\n");
+
+	memset(&event, 0, sizeof(event));
+	event.type = UVC_EVENT_DISCONNECT;
+	kfifo_put(uvc->events, (unsigned char*)&event, sizeof(event));
+
+	wake_up(&uvc->event_wait);
+
+	uvc->state = UVC_STATE_DISCONNECTED;
+}
+
+/* --------------------------------------------------------------------------
+ * Connection / disconnection
+ */
+
+void
+uvc_function_connect(struct uvc_device *uvc)
+{
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+	int ret;
+
+	if ((ret = usb_function_activate(&uvc->func)) < 0)
+		INFO(cdev, "UVC connect failed with %d\n", ret);
+}
+
+void
+uvc_function_disconnect(struct uvc_device *uvc)
+{
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+	int ret;
+
+	if ((ret = usb_function_deactivate(&uvc->func)) < 0)
+		INFO(cdev, "UVC disconnect failed with %d\n", ret);
+}
+
+/* --------------------------------------------------------------------------
+ * USB probe and disconnect
+ */
+
+static int
+uvc_register_video(struct uvc_device *uvc)
+{
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+	struct video_device *video;
+
+	/* TODO reference counting. */
+	video = video_device_alloc();
+	if (video == NULL)
+		return -ENOMEM;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
+	video->dev = &cdev->gadget->dev;
+	video->type = 0;
+	video->type2 = 0;
+#else
+	video->parent = &cdev->gadget->dev;
+#endif
+	video->minor = -1;
+	video->fops = &uvc_v4l2_fops;
+	video->release = video_device_release;
+	strncpy(video->name, cdev->gadget->name, sizeof(video->name));
+
+	uvc->vdev = video;
+	video_set_drvdata(video, uvc);
+
+	return video_register_device(video, VFL_TYPE_GRABBER, -1);
+}
+
+#define UVC_COPY_DESCRIPTOR(mem, dst, desc) \
+	do { \
+		memcpy(mem, desc, (desc)->bLength); \
+		*(dst)++ = mem; \
+		mem += (desc)->bLength; \
+	} while (0);
+
+#define UVC_COPY_DESCRIPTORS(mem, dst, src) \
+	do { \
+		const struct usb_descriptor_header * const *__src; \
+		for (__src = src; *__src; ++__src) { \
+			memcpy(mem, *__src, (*__src)->bLength); \
+			*dst++ = mem; \
+			mem += (*__src)->bLength; \
+		} \
+	} while (0)
+
+static struct usb_descriptor_header ** __init
+uvc_copy_descriptors(struct uvc_device *uvc, enum usb_device_speed speed)
+{
+	struct uvc_input_header_descriptor *uvc_streaming_header;
+	struct uvc_header_descriptor *uvc_control_header;
+	const struct uvc_descriptor_header * const *uvc_streaming_cls;
+	const struct usb_descriptor_header * const *uvc_streaming_std;
+	const struct usb_descriptor_header * const *src;
+	struct usb_descriptor_header **dst;
+	struct usb_descriptor_header **hdr;
+	unsigned int control_size;
+	unsigned int streaming_size;
+	unsigned int n_desc;
+	unsigned int bytes;
+	void *mem;
+
+	uvc_streaming_cls = (speed == USB_SPEED_FULL)
+			  ? uvc->desc.fs_streaming : uvc->desc.hs_streaming;
+	uvc_streaming_std = (speed == USB_SPEED_FULL)
+			  ? uvc_fs_streaming : uvc_hs_streaming;
+
+	/* Descriptors layout
+	 *
+	 * uvc_iad
+	 * uvc_control_intf
+	 * Class-specific UVC control descriptors
+	 * uvc_control_ep
+	 * uvc_control_cs_ep
+	 * uvc_streaming_intf_alt0
+	 * Class-specific UVC streaming descriptors
+	 * uvc_{fs|hs}_streaming
+	 */
+
+	/* Count descriptors and compute their size. */
+	control_size = 0;
+	streaming_size = 0;
+	bytes = uvc_iad.bLength + uvc_control_intf.bLength
+	      + uvc_control_ep.bLength + uvc_control_cs_ep.bLength
+	      + uvc_streaming_intf_alt0.bLength;
+	n_desc = 5;
+
+	for (src = (const struct usb_descriptor_header**)uvc->desc.control; *src; ++src) {
+		control_size += (*src)->bLength;
+		bytes += (*src)->bLength;
+		n_desc++;
+	}
+	for (src = (const struct usb_descriptor_header**)uvc_streaming_cls; *src; ++src) {
+		streaming_size += (*src)->bLength;
+		bytes += (*src)->bLength;
+		n_desc++;
+	}
+	for (src = uvc_streaming_std; *src; ++src) {
+		bytes += (*src)->bLength;
+		n_desc++;
+	}
+
+	mem = kmalloc((n_desc + 1) * sizeof(*src) + bytes, GFP_KERNEL);
+	if (mem == NULL)
+		return NULL;
+
+	hdr = mem;
+	dst = mem;
+	mem += (n_desc + 1) * sizeof(*src);
+
+	/* Copy the descriptors. */
+	UVC_COPY_DESCRIPTOR(mem, dst, &uvc_iad);
+	UVC_COPY_DESCRIPTOR(mem, dst, &uvc_control_intf);
+
+	uvc_control_header = mem;
+	UVC_COPY_DESCRIPTORS(mem, dst,
+		(const struct usb_descriptor_header**)uvc->desc.control);
+	uvc_control_header->wTotalLength = cpu_to_le16(control_size);
+	uvc_control_header->bInCollection = 1;
+	uvc_control_header->baInterfaceNr[0] = uvc->streaming_intf;
+
+	UVC_COPY_DESCRIPTOR(mem, dst, &uvc_control_ep);
+	UVC_COPY_DESCRIPTOR(mem, dst, &uvc_control_cs_ep);
+	UVC_COPY_DESCRIPTOR(mem, dst, &uvc_streaming_intf_alt0);
+
+	uvc_streaming_header = mem;
+	UVC_COPY_DESCRIPTORS(mem, dst,
+		(const struct usb_descriptor_header**)uvc_streaming_cls);
+	uvc_streaming_header->wTotalLength = cpu_to_le16(streaming_size);
+	uvc_streaming_header->bEndpointAddress = uvc_streaming_ep.bEndpointAddress;
+
+	UVC_COPY_DESCRIPTORS(mem, dst, uvc_streaming_std);
+
+	*dst = NULL;
+	return hdr;
+}
+
+static void
+uvc_function_unbind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct usb_composite_dev *cdev = c->cdev;
+	struct uvc_device *uvc = to_uvc(f);
+
+	INFO(cdev, "uvc_function_unbind\n");
+
+	if (uvc->vdev) {
+		if (uvc->vdev->minor == -1)
+			video_device_release(uvc->vdev);
+		else
+			video_unregister_device(uvc->vdev);
+		uvc->vdev = NULL;
+	}
+
+	if (uvc->control_ep)
+		uvc->control_ep->driver_data = NULL;
+	if (uvc->video.ep)
+		uvc->video.ep->driver_data = NULL;
+
+	if (uvc->control_req) {
+		usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+		kfree(uvc->control_buf);
+	}
+
+	kfree(f->descriptors);
+	kfree(f->hs_descriptors);
+
+	if (uvc->events)
+		kfifo_free(uvc->events);
+
+	kfree(uvc);
+}
+
+static int __init
+uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct usb_composite_dev *cdev = c->cdev;
+	struct uvc_device *uvc = to_uvc(f);
+	struct usb_ep *ep;
+	int ret = -EINVAL;
+
+	INFO(cdev, "uvc_function_bind\n");
+
+	/* Allocate endpoints. */
+	ep = usb_ep_autoconfig(cdev->gadget, &uvc_control_ep);
+	if (!ep) {
+		INFO(cdev, "Unable to allocate control EP\n");
+		goto error;
+	}
+	uvc->control_ep = ep;
+	ep->driver_data = uvc;
+
+	ep = usb_ep_autoconfig(cdev->gadget, &uvc_streaming_ep);
+	if (!ep) {
+		INFO(cdev, "Unable to allocate streaming EP\n");
+		goto error;
+	}
+	uvc->video.ep = ep;
+	ep->driver_data = uvc;
+
+	/* Allocate interface IDs. */
+	if ((ret = usb_interface_id(c, f)) < 0)
+		goto error;
+	uvc_iad.bFirstInterface = ret;
+	uvc_control_intf.bInterfaceNumber = ret;
+	uvc->control_intf = ret;
+
+	if ((ret = usb_interface_id(c, f)) < 0)
+		goto error;
+	uvc_streaming_intf_alt0.bInterfaceNumber = ret;
+	uvc_streaming_intf_alt1.bInterfaceNumber = ret;
+	uvc->streaming_intf = ret;
+
+	/* Copy descriptors. */
+	f->descriptors = uvc_copy_descriptors(uvc, USB_SPEED_FULL);
+	f->hs_descriptors = uvc_copy_descriptors(uvc, USB_SPEED_HIGH);
+
+	/* Preallocate control endpoint request. */
+	uvc->control_req = usb_ep_alloc_request(cdev->gadget->ep0, GFP_KERNEL);
+	uvc->control_buf = kmalloc(UVC_MAX_REQUEST_SIZE, GFP_KERNEL);
+	if (uvc->control_req == NULL || uvc->control_buf == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	uvc->control_req->buf = uvc->control_buf;
+	uvc->control_req->complete = uvc_function_ep0_complete;
+	uvc->control_req->context = uvc;
+
+	/* Avoid letting this gadget enumerate until the userspace server is
+	 * active.
+	 */
+	if ((ret = usb_function_deactivate(f)) < 0)
+		goto error;
+
+	/* Initialise video. */
+	ret = uvc_video_init(&uvc->video);
+	if (ret < 0)
+		goto error;
+
+	/* Register a V4L2 device. */
+	ret = uvc_register_video(uvc);
+	if (ret < 0) {
+		printk(KERN_INFO "Unable to register video device\n");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	uvc_function_unbind(c, f);
+	return ret;
+}
+
+/* --------------------------------------------------------------------------
+ * USB gadget function
+ */
+
+/**
+ * uvc_bind_config - add a UVC function to a configuration
+ * @c: the configuration to support the UVC instance
+ * Context: single threaded during gadget setup
+ *
+ * Returns zero on success, else negative errno.
+ *
+ * Caller must have called @uvc_setup(). Caller is also responsible for
+ * calling @uvc_cleanup() before module unload.
+ */
+int __init
+uvc_bind_config(struct usb_configuration *c,
+		const struct uvc_descriptor_header * const *control,
+		const struct uvc_descriptor_header * const *fs_streaming,
+		const struct uvc_descriptor_header * const *hs_streaming)
+{
+	struct uvc_device *uvc;
+	int ret = 0;
+
+	/* TODO Check if the USB device controller supports the required
+	 * features.
+	 */
+	if (!gadget_is_dualspeed(c->cdev->gadget))
+		return -EINVAL;
+
+	uvc = kzalloc(sizeof(*uvc), GFP_KERNEL);
+	if (uvc == NULL)
+		return -ENOMEM;
+
+	uvc->state = UVC_STATE_DISCONNECTED;
+
+	/* TODO Optimized structure-based kfifo implementation to avoid
+	 * copies.
+	 */
+	init_waitqueue_head(&uvc->event_wait);
+	spin_lock_init(&uvc->event_lock);
+	uvc->events = kfifo_alloc(sizeof(struct uvc_event) * UVC_MAX_EVENTS,
+				  GFP_KERNEL, &uvc->event_lock);
+	if (uvc->events == NULL)
+		goto error;
+
+	/* Validate the descriptors. */
+	if (control == NULL || control[0] == NULL ||
+	    control[0]->bDescriptorSubType != UVC_DT_HEADER)
+		goto error;
+
+	if (fs_streaming == NULL || fs_streaming[0] == NULL ||
+	    fs_streaming[0]->bDescriptorSubType != UVC_DT_INPUT_HEADER)
+		goto error;
+
+	if (hs_streaming == NULL || hs_streaming[0] == NULL ||
+	    hs_streaming[0]->bDescriptorSubType != UVC_DT_INPUT_HEADER)
+		goto error;
+
+	uvc->desc.control = control;
+	uvc->desc.fs_streaming = fs_streaming;
+	uvc->desc.hs_streaming = hs_streaming;
+
+	/* Allocate string descriptor numbers. */
+	if ((ret = usb_string_id(c->cdev)) < 0)
+		goto error;
+	uvc_en_us_strings[UVC_STRING_ASSOCIATION_IDX].id = ret;
+	uvc_iad.iFunction = ret;
+
+	if ((ret = usb_string_id(c->cdev)) < 0)
+		goto error;
+	uvc_en_us_strings[UVC_STRING_CONTROL_IDX].id = ret;
+	uvc_control_intf.iInterface = ret;
+
+	if ((ret = usb_string_id(c->cdev)) < 0)
+		goto error;
+	uvc_en_us_strings[UVC_STRING_STREAMING_IDX].id = ret;
+	uvc_streaming_intf_alt0.iInterface = ret;
+	uvc_streaming_intf_alt1.iInterface = ret;
+
+	/* Register the function. */
+	uvc->func.name = "uvc";
+	uvc->func.strings = uvc_function_strings;
+	uvc->func.bind = uvc_function_bind;
+	uvc->func.unbind = uvc_function_unbind;
+	uvc->func.set_alt = uvc_function_set_alt;
+	uvc->func.disable = uvc_function_disable;
+	uvc->func.setup = uvc_function_setup;
+
+	ret = usb_add_function(c, &uvc->func);
+	if (ret)
+		kfree(uvc);
+
+	return 0;
+
+error:
+	kfree(uvc);
+	return ret;
+}
+
+module_param_named(trace, uvc_trace_param, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(trace, "Trace level bitmask");
+
diff --git a/drivers/usb/gadget/f_uvc.h b/drivers/usb/gadget/f_uvc.h
new file mode 100644
index 0000000..42ded4d
--- /dev/null
+++ b/drivers/usb/gadget/f_uvc.h
@@ -0,0 +1,376 @@
+/*
+ *	f_uvc.h  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ */
+
+#ifndef _F_UVC_H_
+#define _F_UVC_H_
+
+#include <linux/usb/composite.h>
+
+#define USB_CLASS_VIDEO_CONTROL		1
+#define USB_CLASS_VIDEO_STREAMING	2
+
+struct uvc_descriptor_header {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+} __attribute__ ((packed));
+
+struct uvc_header_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u16 bcdUVC;
+	__u16 wTotalLength;
+	__u32 dwClockFrequency;
+	__u8  bInCollection;
+	__u8  baInterfaceNr[];
+} __attribute__((__packed__));
+
+#define UVC_HEADER_DESCRIPTOR(n)	uvc_header_descriptor_##n
+
+#define DECLARE_UVC_HEADER_DESCRIPTOR(n) 			\
+struct UVC_HEADER_DESCRIPTOR(n) {				\
+	__u8  bLength;						\
+	__u8  bDescriptorType;					\
+	__u8  bDescriptorSubType;				\
+	__u16 bcdUVC;						\
+	__u16 wTotalLength;					\
+	__u32 dwClockFrequency;					\
+	__u8  bInCollection;					\
+	__u8  baInterfaceNr[n];					\
+} __attribute__ ((packed))
+
+struct uvc_input_terminal_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bTerminalID;
+	__u16 wTerminalType;
+	__u8  bAssocTerminal;
+	__u8  iTerminal;
+} __attribute__((__packed__));
+
+struct uvc_output_terminal_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bTerminalID;
+	__u16 wTerminalType;
+	__u8  bAssocTerminal;
+	__u8  bSourceID;
+	__u8  iTerminal;
+} __attribute__((__packed__));
+
+struct uvc_camera_terminal_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bTerminalID;
+	__u16 wTerminalType;
+	__u8  bAssocTerminal;
+	__u8  iTerminal;
+	__u16 wObjectiveFocalLengthMin;
+	__u16 wObjectiveFocalLengthMax;
+	__u16 wOcularFocalLength;
+	__u8  bControlSize;
+	__u8  bmControls[3];
+} __attribute__((__packed__));
+
+struct uvc_selector_unit_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bUnitID;
+	__u8  bNrInPins;
+	__u8  baSourceID[0];
+	__u8  iSelector;
+} __attribute__((__packed__));
+
+#define UVC_SELECTOR_UNIT_DESCRIPTOR(n)	\
+	uvc_selector_unit_descriptor_##n
+
+#define DECLARE_UVC_SELECTOR_UNIT_DESCRIPTOR(n) 		\
+struct UVC_SELECTOR_UNIT_DESCRIPTOR(n) {			\
+	__u8  bLength;						\
+	__u8  bDescriptorType;					\
+	__u8  bDescriptorSubType;				\
+	__u8  bUnitID;						\
+	__u8  bNrInPins;					\
+	__u8  baSourceID[n];					\
+	__u8  iSelector;					\
+} __attribute__ ((packed))
+
+struct uvc_processing_unit_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bUnitID;
+	__u8  bSourceID;
+	__u16 wMaxMultiplier;
+	__u8  bControlSize;
+	__u8  bmControls[2];
+	__u8  iProcessing;
+} __attribute__((__packed__));
+
+struct uvc_extension_unit_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bUnitID;
+	__u8  guidExtensionCode[16];
+	__u8  bNumControls;
+	__u8  bNrInPins;
+	__u8  baSourceID[0];
+	__u8  bControlSize;
+	__u8  bmControls[0];
+	__u8  iExtension;
+} __attribute__((__packed__));
+
+#define UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) \
+	uvc_extension_unit_descriptor_##p_##n
+
+#define DECLARE_UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) 		\
+struct UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) {			\
+	__u8  bLength;						\
+	__u8  bDescriptorType;					\
+	__u8  bDescriptorSubType;				\
+	__u8  bUnitID;						\
+	__u8  guidExtensionCode[16];				\
+	__u8  bNumControls;					\
+	__u8  bNrInPins;					\
+	__u8  baSourceID[p];					\
+	__u8  bControlSize;					\
+	__u8  bmControls[n];					\
+	__u8  iExtension;					\
+} __attribute__ ((packed))
+
+struct uvc_control_endpoint_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u16 wMaxTransferSize;
+} __attribute__((__packed__));
+
+#define UVC_DT_HEADER				1
+#define UVC_DT_INPUT_TERMINAL			2
+#define UVC_DT_OUTPUT_TERMINAL			3
+#define UVC_DT_SELECTOR_UNIT			4
+#define UVC_DT_PROCESSING_UNIT			5
+#define UVC_DT_EXTENSION_UNIT			6
+
+#define UVC_DT_HEADER_SIZE(n)			(12+(n))
+#define UVC_DT_INPUT_TERMINAL_SIZE		8
+#define UVC_DT_OUTPUT_TERMINAL_SIZE		9
+#define UVC_DT_CAMERA_TERMINAL_SIZE(n)		(15+(n))
+#define UVC_DT_SELECTOR_UNIT_SIZE(n)		(6+(n))
+#define UVC_DT_PROCESSING_UNIT_SIZE(n)		(9+(n))
+#define UVC_DT_EXTENSION_UNIT_SIZE(p,n)		(24+(p)+(n))
+#define UVC_DT_CONTROL_ENDPOINT_SIZE		5
+
+struct uvc_input_header_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bNumFormats;
+	__u16 wTotalLength;
+	__u8  bEndpointAddress;
+	__u8  bmInfo;
+	__u8  bTerminalLink;
+	__u8  bStillCaptureMethod;
+	__u8  bTriggerSupport;
+	__u8  bTriggerUsage;
+	__u8  bControlSize;
+	__u8  bmaControls[];
+} __attribute__((__packed__));
+
+#define UVC_INPUT_HEADER_DESCRIPTOR(n, p) \
+	uvc_input_header_descriptor_##n_##p
+
+#define DECLARE_UVC_INPUT_HEADER_DESCRIPTOR(n, p)		\
+struct UVC_INPUT_HEADER_DESCRIPTOR(n, p) {			\
+	__u8  bLength;						\
+	__u8  bDescriptorType;					\
+	__u8  bDescriptorSubType;				\
+	__u8  bNumFormats;					\
+	__u16 wTotalLength;					\
+	__u8  bEndpointAddress;					\
+	__u8  bmInfo;						\
+	__u8  bTerminalLink;					\
+	__u8  bStillCaptureMethod;				\
+	__u8  bTriggerSupport;					\
+	__u8  bTriggerUsage;					\
+	__u8  bControlSize;					\
+	__u8  bmaControls[p][n];				\
+} __attribute__ ((packed))
+
+struct uvc_output_header_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bNumFormats;
+	__u16 wTotalLength;
+	__u8  bEndpointAddress;
+	__u8  bTerminalLink;
+	__u8  bControlSize;
+	__u8  bmaControls[];
+} __attribute__((__packed__));
+
+#define UVC_OUTPUT_HEADER_DESCRIPTOR(n, p) \
+	uvc_output_header_descriptor_##n_##p
+
+#define DECLARE_UVC_OUTPUT_HEADER_DESCRIPTOR(n, p)		\
+struct UVC_OUTPUT_HEADER_DESCRIPTOR(n, p) {			\
+	__u8  bLength;						\
+	__u8  bDescriptorType;					\
+	__u8  bDescriptorSubType;				\
+	__u8  bNumFormats;					\
+	__u16 wTotalLength;					\
+	__u8  bEndpointAddress;					\
+	__u8  bTerminalLink;					\
+	__u8  bControlSize;					\
+	__u8  bmaControls[p][n];				\
+} __attribute__ ((packed))
+
+struct uvc_format_uncompressed {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bFormatIndex;
+	__u8  bNumFrameDescriptors;
+	__u8  guidFormat[16];
+	__u8  bBitsPerPixel;
+	__u8  bDefaultFrameIndex;
+	__u8  bAspectRatioX;
+	__u8  bAspectRatioY;
+	__u8  bmInterfaceFlags;
+	__u8  bCopyProtect;
+} __attribute__((__packed__));
+
+struct uvc_frame_uncompressed {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bFrameIndex;
+	__u8  bmCapabilities;
+	__u16 wWidth;
+	__u16 wHeight;
+	__u32 dwMinBitRate;
+	__u32 dwMaxBitRate;
+	__u32 dwMaxVideoFrameBufferSize;
+	__u32 dwDefaultFrameInterval;
+	__u8  bFrameIntervalType;
+	__u32 dwFrameInterval[];
+} __attribute__((__packed__));
+
+#define UVC_FRAME_UNCOMPRESSED(n) \
+	uvc_frame_uncompressed_##n
+
+#define DECLARE_UVC_FRAME_UNCOMPRESSED(n) 			\
+struct UVC_FRAME_UNCOMPRESSED(n) {				\
+	__u8  bLength;						\
+	__u8  bDescriptorType;					\
+	__u8  bDescriptorSubType;				\
+	__u8  bFrameIndex;					\
+	__u8  bmCapabilities;					\
+	__u16 wWidth;						\
+	__u16 wHeight;						\
+	__u32 dwMinBitRate;					\
+	__u32 dwMaxBitRate;					\
+	__u32 dwMaxVideoFrameBufferSize;			\
+	__u32 dwDefaultFrameInterval;				\
+	__u8  bFrameIntervalType;				\
+	__u32 dwFrameInterval[n];				\
+} __attribute__ ((packed))
+
+struct uvc_format_mjpeg {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bFormatIndex;
+	__u8  bNumFrameDescriptors;
+	__u8  bmFlags;
+	__u8  bDefaultFrameIndex;
+	__u8  bAspectRatioX;
+	__u8  bAspectRatioY;
+	__u8  bmInterfaceFlags;
+	__u8  bCopyProtect;
+} __attribute__((__packed__));
+
+struct uvc_frame_mjpeg {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bFrameIndex;
+	__u8  bmCapabilities;
+	__u16 wWidth;
+	__u16 wHeight;
+	__u32 dwMinBitRate;
+	__u32 dwMaxBitRate;
+	__u32 dwMaxVideoFrameBufferSize;
+	__u32 dwDefaultFrameInterval;
+	__u8  bFrameIntervalType;
+	__u32 dwFrameInterval[];
+} __attribute__((__packed__));
+
+#define UVC_FRAME_MJPEG(n) \
+	uvc_frame_mjpeg_##n
+
+#define DECLARE_UVC_FRAME_MJPEG(n) 				\
+struct UVC_FRAME_MJPEG(n) {					\
+	__u8  bLength;						\
+	__u8  bDescriptorType;					\
+	__u8  bDescriptorSubType;				\
+	__u8  bFrameIndex;					\
+	__u8  bmCapabilities;					\
+	__u16 wWidth;						\
+	__u16 wHeight;						\
+	__u32 dwMinBitRate;					\
+	__u32 dwMaxBitRate;					\
+	__u32 dwMaxVideoFrameBufferSize;			\
+	__u32 dwDefaultFrameInterval;				\
+	__u8  bFrameIntervalType;				\
+	__u32 dwFrameInterval[n];				\
+} __attribute__ ((packed))
+
+struct uvc_color_matching_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bColorPrimaries;
+	__u8  bTransferCharacteristics;
+	__u8  bMatrixCoefficients;
+} __attribute__((__packed__));
+
+#define UVC_DT_INPUT_HEADER			1
+#define UVC_DT_OUTPUT_HEADER			2
+#define UVC_DT_FORMAT_UNCOMPRESSED		4
+#define UVC_DT_FRAME_UNCOMPRESSED		5
+#define UVC_DT_FORMAT_MJPEG			6
+#define UVC_DT_FRAME_MJPEG			7
+#define UVC_DT_COLOR_MATCHING			13
+
+#define UVC_DT_INPUT_HEADER_SIZE(n, p)		(13+(n*p))
+#define UVC_DT_OUTPUT_HEADER_SIZE(n, p)		(9+(n*p))
+#define UVC_DT_FORMAT_UNCOMPRESSED_SIZE		27
+#define UVC_DT_FRAME_UNCOMPRESSED_SIZE(n)	(26+4*(n))
+#define UVC_DT_FORMAT_MJPEG_SIZE		11
+#define UVC_DT_FRAME_MJPEG_SIZE(n)		(26+4*(n))
+#define UVC_DT_COLOR_MATCHING_SIZE		6
+
+extern int uvc_bind_config(struct usb_configuration *c,
+			   const struct uvc_descriptor_header * const *control,
+			   const struct uvc_descriptor_header * const *fs_streaming,
+			   const struct uvc_descriptor_header * const *hs_streaming);
+
+#endif /* _F_UVC_H_ */
+
diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
new file mode 100644
index 0000000..4d98980
--- /dev/null
+++ b/drivers/usb/gadget/uvc.h
@@ -0,0 +1,246 @@
+/*
+ *	uvc_gadget.h  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ */
+
+#ifndef _UVC_GADGET_H_
+#define _UVC_GADGET_H_
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+#include <linux/usb/ch9.h>
+
+enum uvc_event_type
+{
+	UVC_EVENT_CONNECT,
+	UVC_EVENT_DISCONNECT,
+	UVC_EVENT_STREAMON,
+	UVC_EVENT_STREAMOFF,
+	UVC_EVENT_SETUP,
+	UVC_EVENT_DATA,
+};
+
+struct uvc_event_data
+{
+	int length;
+	__u8 data[64];
+};
+
+struct uvc_event
+{
+	enum uvc_event_type type;
+	union {
+		enum usb_device_speed speed;
+		struct usb_ctrlrequest req;
+		struct uvc_event_data data;
+	};
+};
+
+#define UVCIOC_EVENT_READ			_IOR('U', 1, struct uvc_event)
+#define UVCIOC_EVENT_WRITE			_IOW('U', 2, struct uvc_event_data)
+
+#define UVC_INTF_CONTROL			0
+#define UVC_INTF_STREAMING			1
+
+/* ------------------------------------------------------------------------
+ * UVC constants & structures
+ */
+
+/* Values for bmHeaderInfo (Video and Still Image Payload Headers, 2.4.3.3) */
+#define UVC_STREAM_EOH				(1 << 7)
+#define UVC_STREAM_ERR				(1 << 6)
+#define UVC_STREAM_STI				(1 << 5)
+#define UVC_STREAM_RES				(1 << 4)
+#define UVC_STREAM_SCR				(1 << 3)
+#define UVC_STREAM_PTS				(1 << 2)
+#define UVC_STREAM_EOF				(1 << 1)
+#define UVC_STREAM_FID				(1 << 0)
+
+struct uvc_streaming_control {
+	__u16 bmHint;
+	__u8  bFormatIndex;
+	__u8  bFrameIndex;
+	__u32 dwFrameInterval;
+	__u16 wKeyFrameRate;
+	__u16 wPFrameRate;
+	__u16 wCompQuality;
+	__u16 wCompWindowSize;
+	__u16 wDelay;
+	__u32 dwMaxVideoFrameSize;
+	__u32 dwMaxPayloadTransferSize;
+	__u32 dwClockFrequency;
+	__u8  bmFramingInfo;
+	__u8  bPreferedVersion;
+	__u8  bMinVersion;
+	__u8  bMaxVersion;
+} __attribute__((__packed__));
+
+/* ------------------------------------------------------------------------
+ * Debugging, printing and logging
+ */
+
+#ifdef __KERNEL__
+
+#include <linux/kfifo.h>
+#include <linux/usb.h>	/* For usb_endpoint_* */
+#include <linux/usb/gadget.h>
+
+#include "uvc_queue.h"
+
+#define UVC_TRACE_PROBE				(1 << 0)
+#define UVC_TRACE_DESCR				(1 << 1)
+#define UVC_TRACE_CONTROL			(1 << 2)
+#define UVC_TRACE_FORMAT			(1 << 3)
+#define UVC_TRACE_CAPTURE			(1 << 4)
+#define UVC_TRACE_CALLS				(1 << 5)
+#define UVC_TRACE_IOCTL				(1 << 6)
+#define UVC_TRACE_FRAME				(1 << 7)
+#define UVC_TRACE_SUSPEND			(1 << 8)
+#define UVC_TRACE_STATUS			(1 << 9)
+
+#define UVC_WARN_MINMAX				0
+#define UVC_WARN_PROBE_DEF			1
+
+extern unsigned int uvc_trace_param;
+
+#define uvc_trace(flag, msg...) \
+	do { \
+		if (uvc_trace_param & flag) \
+			printk(KERN_DEBUG "uvcvideo: " msg); \
+	} while (0)
+
+#define uvc_warn_once(dev, warn, msg...) \
+	do { \
+		if (!test_and_set_bit(warn, &dev->warnings)) \
+			printk(KERN_INFO "uvcvideo: " msg); \
+	} while (0)
+
+#define uvc_printk(level, msg...) \
+	printk(level "uvcvideo: " msg)
+
+/* ------------------------------------------------------------------------
+ * Driver specific constants
+ */
+
+#define DRIVER_VERSION				"0.1.0"
+#define DRIVER_VERSION_NUMBER			KERNEL_VERSION(0, 1, 0)
+
+#define DMA_ADDR_INVALID			(~(dma_addr_t)0)
+
+#define UVC_NUM_REQUESTS			4
+#define UVC_MAX_REQUEST_SIZE			64
+#define UVC_MAX_EVENTS				4
+
+#define USB_DT_INTERFACE_ASSOCIATION_SIZE	8
+#define USB_CLASS_MISC				0xef
+
+/* ------------------------------------------------------------------------
+ * Structures
+ */
+
+struct uvc_video
+{
+	struct usb_ep *ep;
+
+	/* Frame parameters */
+	u8 bpp;
+	u32 fcc;
+	unsigned int width;
+	unsigned int height;
+	unsigned int imagesize;
+
+	/* Requests */
+	unsigned int req_size;
+	struct usb_request *req[UVC_NUM_REQUESTS];
+	__u8 *req_buffer[UVC_NUM_REQUESTS];
+	struct list_head req_free;
+	spinlock_t req_lock;
+
+	void (*encode) (struct usb_request *req, struct uvc_video *video,
+			struct uvc_buffer *buf);
+
+	/* Context data used by the completion handler */
+	__u32 payload_size;
+	__u32 max_payload_size;
+
+	struct uvc_video_queue queue;
+	unsigned int fid;
+};
+
+enum uvc_state
+{
+	UVC_STATE_DISCONNECTED,
+	UVC_STATE_CONNECTED,
+	UVC_STATE_STREAMING,
+};
+
+struct uvc_device
+{
+	struct video_device *vdev;
+	enum uvc_state state;
+	struct usb_function func;
+	struct uvc_video video;
+
+	/* Descriptors */
+	struct {
+		const struct uvc_descriptor_header * const *control;
+		const struct uvc_descriptor_header * const *fs_streaming;
+		const struct uvc_descriptor_header * const *hs_streaming;
+	} desc;
+
+	unsigned int control_intf;
+	struct usb_ep *control_ep;
+	struct usb_request *control_req;
+	void *control_buf;
+
+	unsigned int streaming_intf;
+
+	/* Events queue */
+	wait_queue_head_t event_wait;
+	spinlock_t event_lock;
+	struct kfifo *events;
+	unsigned int event_length;
+	unsigned int event_setup_out : 1;
+};
+
+static inline struct uvc_device *to_uvc(struct usb_function *f)
+{
+	return container_of(f, struct uvc_device, func);
+}
+
+struct uvc_file_handle
+{
+	struct uvc_video *device;
+};
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+extern struct file_operations uvc_v4l2_fops;
+#else
+extern struct v4l2_file_operations uvc_v4l2_fops;
+#endif
+
+/* ------------------------------------------------------------------------
+ * Functions
+ */
+
+extern int uvc_video_enable(struct uvc_video *video, int enable);
+extern int uvc_video_init(struct uvc_video *video);
+extern int uvc_video_pump(struct uvc_video *video);
+
+extern void uvc_endpoint_stream(struct uvc_device *dev);
+
+extern void uvc_function_connect(struct uvc_device *uvc);
+extern void uvc_function_disconnect(struct uvc_device *uvc);
+
+#endif /* __KERNEL__ */
+
+#endif /* _UVC_GADGET_H_ */
+
diff --git a/drivers/usb/gadget/uvc_gadget.c b/drivers/usb/gadget/uvc_gadget.c
new file mode 100644
index 0000000..39b9390
--- /dev/null
+++ b/drivers/usb/gadget/uvc_gadget.c
@@ -0,0 +1,890 @@
+/*
+ *	uvc_gadget.c  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/usb_ch9.h>
+#include <linux/usb_gadget.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+
+#include <media/v4l2-dev.h>
+
+#include "uvc.h"
+
+#define DRIVER_AUTHOR				"Laurent Pinchart"
+#define DRIVER_DESCRIPTION			"USB Video Class Gadget"
+
+unsigned int uvc_trace_param;
+
+/* --------------------------------------------------------------------------
+ * Streaming endpoint operations
+ */
+
+static int
+uvc_endpoint_set_interface(struct uvc_device *dev, u16 altsetting)
+{
+	if (usb_endpoint_xfer_bulk(&dev->desc.vs_ep))
+		return altsetting ? -EINVAL : 0;
+
+	switch (altsetting) {
+	case 0:
+		if (dev->video.ep)
+			usb_ep_disable(dev->video.ep);
+
+		dev->event.type = UVC_EVENT_STREAMOFF;
+		dev->event_ready = 1;
+		wake_up(&dev->event_wait);
+		break;
+
+	case 1:
+		if (dev->video.ep)
+			usb_ep_enable(dev->video.ep, &dev->desc.vs_ep);
+
+		dev->event.type = UVC_EVENT_STREAMON;
+		dev->event_ready = 1;
+		wake_up(&dev->event_wait);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+uvc_endpoint_set_configuration(struct uvc_device *dev, u16 config)
+{
+	switch (config) {
+	case 0:
+		dev->power = 8;
+		break;
+
+	case 1:
+		dev->power = dev->desc.config.bMaxPower * 2;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+uvc_endpoint_init(struct uvc_device *dev)
+{
+	/* Find a matching endpoint. */
+	usb_ep_autoconfig_reset(dev->gadget);
+	dev->video.ep = usb_ep_autoconfig(dev->gadget, &dev->desc.vs_ep);
+	if (dev->video.ep == NULL)
+		return -EINVAL;
+
+	dev->desc.vs_ep.wMaxPacketSize = dev->video.ep->maxpacket;
+	dev->video.ep->driver_data = dev;
+
+	/* TODO Make max_payload_size configurable. */
+	if (usb_endpoint_xfer_isoc(&dev->desc.vs_ep)) {
+		printk(KERN_INFO "g_uvc: Isochronous mode selected\n");
+		dev->video.max_payload_size = 0;
+	} else {
+		printk(KERN_INFO "g_uvc: Bulk mode selected\n");
+		dev->video.max_payload_size = 16 * 1024;
+		usb_ep_enable(dev->video.ep, &dev->desc.vs_ep);
+	}
+
+	return 0;
+}
+
+/* --------------------------------------------------------------------------
+ * Descriptor operations
+ */
+
+#define UVC_INTF_VIDEO_CONTROL			0
+#define UVC_INTF_VIDEO_STREAMING		1
+
+static const struct usb_device_descriptor uvc_device_descriptor = {
+	.bLength		= USB_DT_DEVICE_SIZE,
+	.bDescriptorType	= USB_DT_DEVICE,
+	.bcdUSB			= cpu_to_le16(0x0200),
+	.bDeviceClass		= USB_CLASS_MISC,
+	.bDeviceSubClass	= 0x02,
+	.bDeviceProtocol	= 0x01,
+	.bMaxPacketSize0	= 0,
+	.idVendor		= 0,
+	.idProduct		= 0,
+	.bcdDevice		= 0,
+	.iManufacturer		= 0,
+	.iProduct		= 0,
+	.iSerialNumber		= 0,
+	.bNumConfigurations	= 1,
+};
+
+static const struct usb_config_descriptor uvc_config_descriptor = {
+	.bLength		= USB_DT_CONFIG_SIZE,
+	.bDescriptorType	= USB_DT_CONFIG,
+	.wTotalLength		= 0,
+	.bNumInterfaces		= 2,
+	.bConfigurationValue	= 1,
+	.iConfiguration		= 0,
+	.bmAttributes		= USB_CONFIG_ATT_ONE,
+	.bMaxPower		= 100,
+};
+
+static const struct usb_interface_assoc_descriptor uvc_iad = {
+	.bLength		= USB_DT_INTERFACE_ASSOCIATION_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE_ASSOCIATION,
+	.bFirstInterface	= 0,
+	.bInterfaceCount	= 2,
+	.bFunctionClass		= USB_CLASS_VIDEO,
+	.bFunctionSubClass	= 0x03,
+	.bFunctionProtocol	= 0x00,
+	.iFunction		= 0,
+};
+
+static const struct usb_interface_descriptor uvc_video_control_descriptor = {
+	.bLength		= USB_DT_INTERFACE_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE,
+	.bInterfaceNumber	= UVC_INTF_VIDEO_CONTROL,
+	.bAlternateSetting	= 0,
+	.bNumEndpoints		= 0,
+	.bInterfaceClass	= USB_CLASS_VIDEO,
+	.bInterfaceSubClass	= 0x01,
+	.bInterfaceProtocol	= 0x00,
+	.iInterface		= 0,
+};
+
+#define UVC_DT_CS_ENDPOINT_SIZE		5
+
+static const struct uvc_interrupt_endpoint_descriptor uvc_interrupt_descriptor = {
+	.bLength		= UVC_DT_CS_ENDPOINT_SIZE,
+	.bDescriptorType	= USB_DT_CS_ENDPOINT,
+	.bDescriptorSubType	= EP_INTERRUPT,
+	.wMaxTransferSize	= 0x0010,
+};
+
+static const struct usb_interface_descriptor uvc_video_streaming_descriptor = {
+	.bLength		= USB_DT_INTERFACE_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE,
+	.bInterfaceNumber	= UVC_INTF_VIDEO_STREAMING,
+	.bAlternateSetting	= 0,
+	.bNumEndpoints		= 0,
+	.bInterfaceClass	= USB_CLASS_VIDEO,
+	.bInterfaceSubClass	= 0x02,
+	.bInterfaceProtocol	= 0x00,
+	.iInterface		= 0,
+};
+
+static int
+uvc_make_qualifier(struct uvc_device *dev)
+{
+	struct usb_qualifier_descriptor qual;
+
+	qual.bLength = sizeof(qual);
+	qual.bDescriptorType = USB_DT_DEVICE_QUALIFIER;
+	qual.bcdUSB = cpu_to_le16(0x0200);
+	qual.bRESERVED = 0;
+
+	qual.bDeviceClass = dev->desc.device.bDeviceClass;
+	qual.bDeviceSubClass = dev->desc.device.bDeviceSubClass;
+	qual.bDeviceProtocol = dev->desc.device.bDeviceProtocol;
+	qual.bMaxPacketSize0 = dev->desc.device.bMaxPacketSize0;
+	qual.bNumConfigurations = dev->desc.device.bNumConfigurations;
+
+	memcpy(dev->ep0buf, &qual, sizeof(qual));
+	return sizeof(qual);
+}
+
+#define UVC_APPEND_DESCRIPTOR_RAW(buf, desc, size) \
+	do { \
+		memcpy(buf, desc, size); \
+		buf += size; \
+	} while (0)
+
+#define UVC_APPEND_DESCRIPTOR(buf, desc) \
+	UVC_APPEND_DESCRIPTOR_RAW(buf, desc, sizeof(typeof(*desc)))
+
+static int
+uvc_make_config(struct uvc_device *dev, u8 type)
+{
+	struct usb_config_descriptor *config;
+	struct usb_interface_descriptor *intf;
+	struct usb_endpoint_descriptor *endp;
+	void *buf = dev->ep0buf;
+	int len;
+
+	UVC_APPEND_DESCRIPTOR(buf, &dev->desc.config);
+	UVC_APPEND_DESCRIPTOR(buf, &uvc_iad);
+
+	/* Video control. */
+	intf = buf;
+	UVC_APPEND_DESCRIPTOR(buf, &uvc_video_control_descriptor);
+	UVC_APPEND_DESCRIPTOR_RAW(buf, dev->desc.vc_data, dev->desc.vc_size);
+
+	if (dev->desc.vc_ep.bInterval) {
+		endp = buf;
+		UVC_APPEND_DESCRIPTOR_RAW(buf, &dev->desc.vc_ep, USB_DT_ENDPOINT_SIZE);
+		endp->wMaxPacketSize = 16;
+		UVC_APPEND_DESCRIPTOR(buf, &uvc_interrupt_descriptor);
+
+		intf->bNumEndpoints = 1;
+	}
+
+	/* Video streaming. */
+	intf = buf;
+	UVC_APPEND_DESCRIPTOR(buf, &uvc_video_streaming_descriptor);
+	UVC_APPEND_DESCRIPTOR_RAW(buf, dev->desc.vs_data, dev->desc.vs_size);
+
+	if (usb_endpoint_xfer_isoc(&dev->desc.vs_ep)) {
+		intf = buf;
+		UVC_APPEND_DESCRIPTOR(buf, &uvc_video_streaming_descriptor);
+		intf->bAlternateSetting = 1;
+	}
+
+	intf->bNumEndpoints = 1;
+	UVC_APPEND_DESCRIPTOR_RAW(buf, &dev->desc.vs_ep, USB_DT_ENDPOINT_SIZE);
+
+	len = buf - (void *)dev->ep0buf;
+	config = (struct usb_config_descriptor *)dev->ep0buf;
+	config->wTotalLength = cpu_to_le16(len);
+
+	return len;
+}
+
+static ssize_t
+uvc_config_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct usb_gadget *gadget = container_of(dev, struct usb_gadget, dev);
+	struct uvc_device *udev = get_gadget_data(gadget);
+	struct usb_string *string;
+	char *p = buf;
+
+	for (string = udev->desc.strings.strings; string->id; ++string)
+		p += sprintf(p, "%u %s\n", string->id, string->s);
+
+	return p - buf;
+}
+
+static ssize_t
+uvc_config_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	struct usb_gadget *gadget = container_of(dev, struct usb_gadget, dev);
+	struct uvc_device *udev = get_gadget_data(gadget);
+	const struct usb_descriptor_header *usb_header;
+	const struct usb_device_descriptor *usb_dd;
+	const struct usb_config_descriptor *usb_cd;
+	const struct usb_endpoint_descriptor *usb_ep;
+	const char *end = buf + count;
+	const char *data, *p, *s;
+	unsigned int nstrings;
+	unsigned int len, i;
+	int ret = -EINVAL;
+
+	if (udev->state != UVC_STATE_DISABLED)
+		return -EEXIST;
+
+	udev->desc.vc_ep.bLength = USB_DT_ENDPOINT_SIZE;
+	udev->desc.vc_ep.bDescriptorType = USB_DT_ENDPOINT;
+	udev->desc.vc_ep.bEndpointAddress = USB_DIR_IN | 0x03;
+	udev->desc.vc_ep.bmAttributes = USB_ENDPOINT_XFER_INT;
+	udev->desc.vc_ep.wMaxPacketSize = 0;
+	udev->desc.vc_ep.bInterval = 0;
+
+	udev->desc.vs_ep.bLength = USB_DT_ENDPOINT_SIZE;
+	udev->desc.vs_ep.bDescriptorType = USB_DT_ENDPOINT;
+	udev->desc.vs_ep.bEndpointAddress = USB_DIR_IN;
+	udev->desc.vs_ep.bmAttributes = 0;
+	udev->desc.vs_ep.wMaxPacketSize = 0;
+	udev->desc.vs_ep.bInterval = 1;
+
+	/*
+	 * Offset    | Size | Description
+	 * ----------+------+------------------------------------------------
+	 *  0        | 4    | Number of string descriptors (n)
+	 *  4        | p(1) | Zero-terminated string 1
+	 *  4+p(1)   | p(2) | Zero-terminated string 2
+	 *  ...      |      |
+	 *  4+p(1)   | p(n) | Zero-terminated string n
+	 *   +...    |      |
+	 *   +p(n-1) |      |
+	 *  4+p      | 18   | Device descriptor
+	 *  22+p     | 9    | Configuration descriptor
+	 *  31+p     | 8    | Interface association descriptor
+	 *  39+p     | 9    | Video control interface descriptor
+	 *  48+p     | m    | Class-specific video control descriptors
+	 *  48+p+m   | 9    | Video streaming interface descriptor
+	 *  57+p+m   | q    | Class-specific video streaming descriptors
+	 *
+	 * - Device: idVendor, idProduct, bcdDevice, iManufacturer, iProduct,
+	 *   iSerial
+	 * - Configuration: iConfiguration, bmAttributes, bMaxPower
+	 * - Interface association: none
+	 * - Video control interface: none
+	 * - Video streaming interface: none
+	 */
+
+	/* Parse string data and create string descriptors. The first pass
+	 * computes the total string data length to allocate memory in one
+	 * chunk and the second pass creates and fills the string descriptors.
+	 */
+	nstrings = *(u32 *)buf;
+	buf += 4;
+
+	for (p = buf, i = nstrings; p < end && i > 0; ++p) {
+		if (*p == '\0')
+			i--;
+	}
+
+	if (i > 0)
+		return -EINVAL;
+
+	len = (nstrings + 1) * sizeof(*udev->desc.string_data);
+	len += p - buf + 1;
+
+	udev->desc.string_data = kzalloc(len, GFP_KERNEL);
+	if (udev->desc.string_data == NULL)
+		return -ENOMEM;
+
+	memcpy(&udev->desc.string_data[nstrings+1], buf, len);
+	s = (char *)&udev->desc.string_data[nstrings+1];
+
+	for (i = 0; i < nstrings; ++i) {
+		udev->desc.string_data[i].id = i + 1;
+		udev->desc.string_data[i].s = s;
+		s += strlen(s) + 1;
+	}
+
+	udev->desc.strings.language = 0x0409;
+	udev->desc.strings.strings = udev->desc.string_data;
+
+	/* Fill device and configuration descriptors. */
+	if (end - p < USB_DT_DEVICE_SIZE + USB_DT_CONFIG_SIZE)
+		goto error;
+
+	usb_dd = (const struct usb_device_descriptor *)p;
+	if (usb_dd->bDescriptorType != USB_DT_DEVICE)
+		goto error;
+
+	memcpy(&udev->desc.device, &uvc_device_descriptor,
+		sizeof(udev->desc.device));
+	udev->desc.device.bMaxPacketSize0 = gadget->ep0->maxpacket;
+	udev->desc.device.idVendor = usb_dd->idVendor;
+	udev->desc.device.idProduct = usb_dd->idProduct;
+	udev->desc.device.bcdDevice = usb_dd->bcdDevice;
+	udev->desc.device.iManufacturer = usb_dd->iManufacturer;
+	udev->desc.device.iProduct = usb_dd->iProduct;
+	udev->desc.device.iSerialNumber = usb_dd->iSerialNumber;
+	p += USB_DT_DEVICE_SIZE;
+
+	usb_cd = (const struct usb_config_descriptor *)p;
+	if (usb_cd->bDescriptorType != USB_DT_CONFIG)
+		goto error;
+
+	memcpy(&udev->desc.config, &uvc_config_descriptor,
+		sizeof(udev->desc.config));
+	udev->desc.config.iConfiguration = usb_cd->iConfiguration;
+	udev->desc.config.bmAttributes = usb_cd->bmAttributes | USB_CONFIG_ATT_ONE;
+	udev->desc.config.bMaxPower = usb_cd->bMaxPower;
+	p += USB_DT_CONFIG_SIZE;
+
+	/* Video interface association descriptor. */
+	if (end - p < USB_DT_INTERFACE_ASSOCIATION_SIZE)
+		goto error;
+
+	usb_header = (const struct usb_descriptor_header *)p;
+	if (usb_header->bDescriptorType != USB_DT_INTERFACE_ASSOCIATION)
+		goto error;
+	p += USB_DT_INTERFACE_ASSOCIATION_SIZE;
+
+	/* Video control interface descriptors. */
+	if (end - p < USB_DT_INTERFACE_SIZE)
+		goto error;
+
+	usb_header = (const struct usb_descriptor_header *)p;
+	if (usb_header->bDescriptorType != USB_DT_INTERFACE)
+		goto error;
+	p += USB_DT_INTERFACE_SIZE;
+
+	for (data = p; p + 3 <= end && p[1] == USB_DT_CS_INTERFACE; p += p[0]) {
+		switch (p[2]) {
+		case VC_HEADER:
+			break;
+		}
+	}
+
+	if (p > end)
+		goto error;
+
+	udev->desc.vc_size = p - data;
+	udev->desc.vc_data = kmalloc(udev->desc.vc_size, GFP_KERNEL);
+	if (udev->desc.vc_data == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	memcpy(udev->desc.vc_data, data, udev->desc.vc_size);
+
+	/* Optional interrupt endpoint descriptor. */
+	if (end - p < sizeof(usb_header))
+		goto error;
+
+	usb_header = (const struct usb_descriptor_header *)p;
+	if (usb_header->bDescriptorType == USB_DT_ENDPOINT) {
+		if (end - p < USB_DT_ENDPOINT_SIZE + UVC_DT_CS_ENDPOINT_SIZE)
+			goto error;
+
+		usb_ep = (const struct usb_endpoint_descriptor *)p;
+		udev->desc.vc_ep.bInterval = usb_ep->bInterval;
+
+		p += USB_DT_ENDPOINT_SIZE + UVC_DT_CS_ENDPOINT_SIZE;
+	}
+
+	/* Video streaming interface descriptors. */
+	if (end - p < USB_DT_INTERFACE_SIZE)
+		goto error;
+
+	usb_header = (const struct usb_descriptor_header *)p;
+	if (usb_header->bDescriptorType != USB_DT_INTERFACE)
+		goto error;
+	p += USB_DT_INTERFACE_SIZE;
+
+	for (data = p; p + 3 <= end && p[1] == USB_DT_CS_INTERFACE; p += p[0]) {
+		switch (p[2]) {
+		case VS_INPUT_HEADER:
+			break;
+		}
+	}
+
+	if (p > end)
+		goto error;
+
+	udev->desc.vs_size = p - data;
+	udev->desc.vs_data = kmalloc(udev->desc.vs_size, GFP_KERNEL);
+	if (udev->desc.vs_data == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	memcpy(udev->desc.vs_data, data, udev->desc.vs_size);
+
+	/* Video streaming bulk endpoint. */
+	usb_header = (const struct usb_descriptor_header *)p;
+	if (end - p >= USB_DT_ENDPOINT_SIZE &&
+	    usb_header->bDescriptorType == USB_DT_ENDPOINT) {
+		usb_ep = (const struct usb_endpoint_descriptor *)p;
+		if (usb_ep->bmAttributes != USB_ENDPOINT_XFER_BULK)
+			goto error;
+
+		udev->desc.vs_ep.bmAttributes = usb_ep->bmAttributes;
+		p += USB_DT_ENDPOINT_SIZE;
+
+		if (p != end)
+			goto error;
+	}
+
+	/* Video streaming alternate settings and isochronous endpoints. */
+	while (end - p >= USB_DT_INTERFACE_SIZE + USB_DT_ENDPOINT_SIZE) {
+		usb_header = (const struct usb_descriptor_header *)p;
+		if (usb_header->bDescriptorType != USB_DT_INTERFACE)
+			goto error;
+		p += USB_DT_INTERFACE_SIZE;
+
+		usb_header = (const struct usb_descriptor_header *)p;
+		if (usb_header->bDescriptorType != USB_DT_ENDPOINT)
+			goto error;
+
+		usb_ep = (const struct usb_endpoint_descriptor *)p;
+		if (usb_ep->bmAttributes != (0X04 | USB_ENDPOINT_XFER_ISOC))
+			goto error;
+
+		udev->desc.vs_ep.bmAttributes = usb_ep->bmAttributes;
+		p += USB_DT_ENDPOINT_SIZE;
+	}
+
+	if (p != end)
+		goto error;
+
+	/* Select endpoints. */
+	ret = uvc_endpoint_init(udev);
+	if (ret < 0)
+		goto error;
+
+	udev->state = UVC_STATE_UNCONNECTED;
+	usb_gadget_connect(gadget);
+	return count;
+
+error:
+	kfree(udev->desc.string_data);
+	udev->desc.string_data = NULL;
+	kfree(udev->desc.vc_data);
+	udev->desc.vc_data = NULL;
+	kfree(udev->desc.vs_data);
+	udev->desc.vs_data = NULL;
+
+	return ret;
+}
+
+static DEVICE_ATTR(config, 0644, uvc_config_show, uvc_config_store);
+
+/* --------------------------------------------------------------------------
+ * Endpoint 0
+ */
+
+static void
+uvc_ep0_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct uvc_device *dev = req->context;
+
+	if (dev->event_setup_out) {
+		dev->event_setup_out = 0;
+
+		dev->event.type = UVC_EVENT_DATA;
+		dev->event.data.length = req->actual;
+		memcpy(&dev->event.data.data, &req->buf, req->actual);
+
+		dev->event_ready = 1;
+		wake_up(&dev->event_wait);
+	}
+}
+
+#define DeviceInRequest \
+	((USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE) << 8)
+#define DeviceOutRequest \
+	((USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE) << 8)
+#define InterfaceInRequest \
+	((USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_INTERFACE) << 8)
+#define InterfaceOutRequest \
+	((USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_INTERFACE) << 8)
+
+static int
+uvc_setup_standard(struct usb_gadget *gadget,
+	const struct usb_ctrlrequest *ctrl)
+{
+	struct uvc_device *dev = get_gadget_data(gadget);
+	u16 wIndex = le16_to_cpu(ctrl->wIndex);
+	u16 wValue = le16_to_cpu(ctrl->wValue);
+	int value = -EOPNOTSUPP;
+
+	switch ((ctrl->bRequestType << 8) | ctrl->bRequest) {
+	case DeviceInRequest | USB_REQ_GET_DESCRIPTOR:
+		switch (wValue >> 8) {
+		case USB_DT_DEVICE:
+			value = sizeof(dev->desc.device);
+			dev->ep0req->buf = &dev->desc.device;
+			break;
+
+		case USB_DT_DEVICE_QUALIFIER:
+			value = uvc_make_qualifier(dev);
+			break;
+
+		case USB_DT_CONFIG:
+		case USB_DT_OTHER_SPEED_CONFIG:
+			value = uvc_make_config(dev, wValue >> 8);
+			break;
+
+		case USB_DT_STRING:
+			value = usb_gadget_get_string(&dev->desc.strings,
+					wValue & 0xff, dev->ep0buf);
+			break;
+
+		case USB_DT_DEBUG:
+		default:
+			printk(KERN_INFO "Unsupported descriptor type %u\n",
+				wIndex >> 8);
+			break;
+		}
+		break;
+
+	case DeviceInRequest | USB_REQ_GET_CONFIGURATION:
+		*(u8 *)dev->ep0buf = dev->config;
+		value = 1;
+		break;
+
+	case DeviceOutRequest | USB_REQ_SET_CONFIGURATION:
+		if (uvc_endpoint_set_configuration(dev, wValue) == 0) {
+			value = 0;
+			dev->config = wValue;
+			usb_gadget_vbus_draw(gadget, dev->power);
+		}
+		break;
+
+	case InterfaceInRequest | USB_REQ_GET_INTERFACE:
+		switch (wIndex) {
+		case UVC_INTF_VIDEO_CONTROL:
+			/* Video control interface has a single alternate
+			 * setting.
+			 */
+			*(u8 *)dev->ep0buf = 0;
+			value = 1;
+			break;
+
+		case UVC_INTF_VIDEO_STREAMING:
+			*(u8 *)dev->ep0buf = dev->altsetting;
+			value = 1;
+			break;
+		}
+		break;
+
+	case InterfaceOutRequest | USB_REQ_SET_INTERFACE:
+		if (wIndex != UVC_INTF_VIDEO_STREAMING)
+			break;
+
+		if (uvc_endpoint_set_interface(dev, wValue) == 0) {
+			value = 0;
+			dev->altsetting = wValue;
+		}
+		break;
+
+	default:
+		printk(KERN_INFO "Unsupported request bRequestType 0x%02x "
+			"bRequest 0x%02x wValue 0x%04x wIndex 0x%04x\n",
+			ctrl->bRequestType, ctrl->bRequest, wValue, wIndex);
+		break;
+	}
+
+	return value;
+}
+
+static int
+uvc_setup_class(struct usb_gadget *gadget,
+	const struct usb_ctrlrequest *ctrl)
+{
+	struct uvc_device *dev = get_gadget_data(gadget);
+
+	/* printk(KERN_INFO "setup request %02x %02x value %04x index %04x %04x\n",
+	 *	ctrl->bRequestType, ctrl->bRequest, le16_to_cpu(ctrl->wValue),
+	 *	le16_to_cpu(ctrl->wIndex), le16_to_cpu(ctrl->wLength));
+	 */
+
+	/* TODO stall too big requests */
+
+	memcpy(&dev->event.req, ctrl, sizeof(dev->event.req));
+	dev->event.type = UVC_EVENT_SETUP;
+	dev->event_ready = 1;
+	wake_up(&dev->event_wait);
+
+	return -EAGAIN;
+}
+
+static int
+uvc_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
+{
+	struct uvc_device *dev = get_gadget_data(gadget);
+	u16 wLength = le16_to_cpu(ctrl->wLength);
+	int value = -EOPNOTSUPP;
+
+	dev->state = UVC_STATE_CONNECTED;
+
+	dev->ep0req->buf = &dev->ep0buf;
+
+	switch (ctrl->bRequestType & USB_TYPE_MASK) {
+	case USB_TYPE_STANDARD:
+		value = uvc_setup_standard(gadget, ctrl);
+		break;
+
+	case USB_TYPE_CLASS:
+		value = uvc_setup_class(gadget, ctrl);
+		break;
+
+	default:
+		printk(KERN_INFO "Unsupported request type 0x%02x\n",
+			ctrl->bRequestType);
+		break;
+	}
+
+	if (value >= 0) {
+		dev->ep0req->length = min((int)wLength, value);
+		dev->ep0req->zero = value < wLength;
+		dev->ep0req->dma = DMA_ADDR_INVALID;
+
+		value = usb_ep_queue(gadget->ep0, dev->ep0req, GFP_ATOMIC);
+	}
+
+	return (value == -EAGAIN) ? 0 : value;
+}
+
+/* --------------------------------------------------------------------------
+ * USB probe and disconnect
+ */
+
+static int
+uvc_register_video(struct uvc_device *dev)
+{
+	struct video_device *video;
+
+	/* TODO reference counting. */
+	video = video_device_alloc();
+	if (video == NULL)
+		return -ENOMEM;
+
+	video->dev = &dev->gadget->dev;
+	video->minor = -1;
+	video->fops = &uvc_v4l2_fops;
+	video->release = video_device_release;
+	strncpy(video->name, dev->gadget->name, sizeof(video->name));
+
+	dev->vdev = video;
+	video_set_drvdata(video, dev);
+
+	return video_register_device(video, VFL_TYPE_GRABBER, -1);
+}
+
+static void
+uvc_disconnect(struct usb_gadget *gadget)
+{
+	struct uvc_device *dev = get_gadget_data(gadget);
+
+	printk(KERN_DEBUG "uvc_disconnect: gadget %s\n", gadget->name);
+	if (dev->state != UVC_STATE_DISABLED)
+		dev->state = UVC_STATE_UNCONNECTED;
+}
+
+static void
+uvc_unbind(struct usb_gadget *gadget)
+{
+	struct uvc_device *dev = get_gadget_data(gadget);
+
+	printk(KERN_DEBUG "uvc_unbind: gadget %s\n", gadget->name);
+
+	if (dev->vdev) {
+		if (dev->vdev->minor == -1)
+			video_device_release(dev->vdev);
+		else
+			video_unregister_device(dev->vdev);
+		dev->vdev = NULL;
+	}
+
+	device_remove_file(&gadget->dev, &dev_attr_config);
+
+	set_gadget_data(gadget, NULL);
+	kfree(dev->desc.string_data);
+	kfree(dev->desc.vc_data);
+	kfree(dev->desc.vs_data);
+	kfree(dev);
+}
+
+static int
+uvc_bind(struct usb_gadget *gadget)
+{
+	struct uvc_device *dev;
+	int ret;
+
+	printk(KERN_INFO "uvc_bind: gadget %s\n", gadget->name);
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL)
+		return -ENOMEM;
+
+	dev->state = UVC_STATE_DISABLED;
+	init_waitqueue_head(&dev->event_wait);
+	mutex_init(&dev->event_lock);
+
+	dev->gadget = gadget;
+	set_gadget_data(gadget, dev);
+
+	/* Create the sysfs configuration file. */
+	device_create_file(&gadget->dev, &dev_attr_config);
+
+	/* Preallocate control endpoint request. */
+	dev->ep0req = usb_ep_alloc_request(gadget->ep0, GFP_KERNEL);
+	if (dev->ep0req == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	dev->ep0req->complete = uvc_ep0_complete;
+	dev->ep0req->context = dev;
+
+	/* Initialise video. */
+	ret = uvc_video_init(&dev->video);
+	if (ret < 0)
+		goto error;
+
+	/* Register a V4L2 device. */
+	ret = uvc_register_video(dev);
+	if (ret < 0) {
+		printk(KERN_INFO "Unable to register video device\n");
+		goto error;
+	}
+
+	usb_gadget_disconnect(gadget);
+	return 0;
+
+error:
+	uvc_unbind(gadget);
+	return ret;
+}
+
+/* --------------------------------------------------------------------------
+ * Suspend/resume
+ */
+
+static void
+uvc_suspend(struct usb_gadget *gadget)
+{
+	printk(KERN_INFO "uvc_suspend: gadget %s\n", gadget->name);
+}
+
+static void
+uvc_resume(struct usb_gadget *gadget)
+{
+	printk(KERN_INFO "uvc_resume: gadget %s\n", gadget->name);
+}
+
+/* --------------------------------------------------------------------------
+ * Driver
+ */
+
+static struct usb_gadget_driver uvc_driver = {
+	.function	= "USB Video Class",
+	.speed		= USB_SPEED_HIGH,
+	.bind		= uvc_bind,
+	.unbind		= uvc_unbind,
+	.setup		= uvc_setup,
+	.disconnect	= uvc_disconnect,
+	.suspend	= uvc_suspend,
+	.resume		= uvc_resume,
+	.driver		= {
+		.name		= "g_uvc",
+		.owner		= THIS_MODULE,
+	},
+};
+
+static int __init uvc_init (void)
+{
+	printk(KERN_INFO "%s (%s)\n", DRIVER_DESCRIPTION, DRIVER_VERSION);
+	return usb_gadget_register_driver(&uvc_driver);
+}
+
+static void __exit uvc_cleanup (void)
+{
+	usb_gadget_unregister_driver(&uvc_driver);
+}
+
+module_init(uvc_init);
+module_exit(uvc_cleanup);
+
+module_param_named(trace, uvc_trace_param, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(trace, "Trace level bitmask");
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_AUTHOR(DRIVER_DESCRIPTION);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
+
diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
new file mode 100644
index 0000000..b080d5d
--- /dev/null
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -0,0 +1,583 @@
+/*
+ *	uvc_queue.c  --  USB Video Class driver - Buffers management
+ *
+ *	Copyright (C) 2005-2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/videodev2.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+
+#include "uvc.h"
+
+/* ------------------------------------------------------------------------
+ * Video buffers queue management.
+ *
+ * Video queues is initialized by uvc_queue_init(). The function performs
+ * basic initialization of the uvc_video_queue struct and never fails.
+ *
+ * Video buffer allocation and freeing are performed by uvc_alloc_buffers and
+ * uvc_free_buffers respectively. The former acquires the video queue lock,
+ * while the later must be called with the lock held (so that allocation can
+ * free previously allocated buffers). Trying to free buffers that are mapped
+ * to user space will return -EBUSY.
+ *
+ * Video buffers are managed using two queues. However, unlike most USB video
+ * drivers that use an in queue and an out queue, we use a main queue to hold
+ * all queued buffers (both 'empty' and 'done' buffers), and an irq queue to
+ * hold empty buffers. This design (copied from video-buf) minimizes locking
+ * in interrupt, as only one queue is shared between interrupt and user
+ * contexts.
+ *
+ * Use cases
+ * ---------
+ *
+ * Unless stated otherwise, all operations that modify the irq buffers queue
+ * are protected by the irq spinlock.
+ *
+ * 1. The user queues the buffers, starts streaming and dequeues a buffer.
+ *
+ *    The buffers are added to the main and irq queues. Both operations are
+ *    protected by the queue lock, and the later is protected by the irq
+ *    spinlock as well.
+ *
+ *    The completion handler fetches a buffer from the irq queue and fills it
+ *    with video data. If no buffer is available (irq queue empty), the handler
+ *    returns immediately.
+ *
+ *    When the buffer is full, the completion handler removes it from the irq
+ *    queue, marks it as ready (UVC_BUF_STATE_DONE) and wakes its wait queue.
+ *    At that point, any process waiting on the buffer will be woken up. If a
+ *    process tries to dequeue a buffer after it has been marked ready, the
+ *    dequeing will succeed immediately.
+ *
+ * 2. Buffers are queued, user is waiting on a buffer and the device gets
+ *    disconnected.
+ *
+ *    When the device is disconnected, the kernel calls the completion handler
+ *    with an appropriate status code. The handler marks all buffers in the
+ *    irq queue as being erroneous (UVC_BUF_STATE_ERROR) and wakes them up so
+ *    that any process waiting on a buffer gets woken up.
+ *
+ *    Waking up up the first buffer on the irq list is not enough, as the
+ *    process waiting on the buffer might restart the dequeue operation
+ *    immediately.
+ *
+ */
+
+void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type)
+{
+	mutex_init(&queue->mutex);
+	spin_lock_init(&queue->irqlock);
+	INIT_LIST_HEAD(&queue->mainqueue);
+	INIT_LIST_HEAD(&queue->irqqueue);
+	queue->type = type;
+}
+
+/*
+ * Allocate the video buffers.
+ *
+ * Pages are reserved to make sure they will not be swapped, as they will be
+ * filled in the URB completion handler.
+ *
+ * Buffers will be individually mapped, so they must all be page aligned.
+ */
+int uvc_alloc_buffers(struct uvc_video_queue *queue, unsigned int nbuffers,
+		unsigned int buflength)
+{
+	unsigned int bufsize = PAGE_ALIGN(buflength);
+	unsigned int i;
+	void *mem = NULL;
+	int ret;
+
+	if (nbuffers > UVC_MAX_VIDEO_BUFFERS)
+		nbuffers = UVC_MAX_VIDEO_BUFFERS;
+
+	mutex_lock(&queue->mutex);
+
+	if ((ret = uvc_free_buffers(queue)) < 0)
+		goto done;
+
+	/* Bail out if no buffers should be allocated. */
+	if (nbuffers == 0)
+		goto done;
+
+	/* Decrement the number of buffers until allocation succeeds. */
+	for (; nbuffers > 0; --nbuffers) {
+		mem = vmalloc_32(nbuffers * bufsize);
+		if (mem != NULL)
+			break;
+	}
+
+	if (mem == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	for (i = 0; i < nbuffers; ++i) {
+		memset(&queue->buffer[i], 0, sizeof queue->buffer[i]);
+		queue->buffer[i].buf.index = i;
+		queue->buffer[i].buf.m.offset = i * bufsize;
+		queue->buffer[i].buf.length = buflength;
+		queue->buffer[i].buf.type = queue->type;
+		queue->buffer[i].buf.sequence = 0;
+		queue->buffer[i].buf.field = V4L2_FIELD_NONE;
+		queue->buffer[i].buf.memory = V4L2_MEMORY_MMAP;
+		queue->buffer[i].buf.flags = 0;
+		init_waitqueue_head(&queue->buffer[i].wait);
+	}
+
+	queue->mem = mem;
+	queue->count = nbuffers;
+	queue->buf_size = bufsize;
+	ret = nbuffers;
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
+ * Free the video buffers.
+ *
+ * This function must be called with the queue lock held.
+ */
+int uvc_free_buffers(struct uvc_video_queue *queue)
+{
+	unsigned int i;
+
+	for (i = 0; i < queue->count; ++i) {
+		if (queue->buffer[i].vma_use_count != 0)
+			return -EBUSY;
+	}
+
+	if (queue->count) {
+		vfree(queue->mem);
+		queue->count = 0;
+	}
+
+	return 0;
+}
+
+static void __uvc_query_buffer(struct uvc_buffer *buf,
+		struct v4l2_buffer *v4l2_buf)
+{
+	memcpy(v4l2_buf, &buf->buf, sizeof *v4l2_buf);
+
+	if (buf->vma_use_count)
+		v4l2_buf->flags |= V4L2_BUF_FLAG_MAPPED;
+
+	switch (buf->state) {
+	case UVC_BUF_STATE_ERROR:
+	case UVC_BUF_STATE_DONE:
+		v4l2_buf->flags |= V4L2_BUF_FLAG_DONE;
+		break;
+	case UVC_BUF_STATE_QUEUED:
+	case UVC_BUF_STATE_ACTIVE:
+		v4l2_buf->flags |= V4L2_BUF_FLAG_QUEUED;
+		break;
+	case UVC_BUF_STATE_IDLE:
+	default:
+		break;
+	}
+}
+
+int uvc_query_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf)
+{
+	int ret = 0;
+
+	mutex_lock(&queue->mutex);
+	if (v4l2_buf->index >= queue->count) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	__uvc_query_buffer(&queue->buffer[v4l2_buf->index], v4l2_buf);
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
+ * Queue a video buffer. Attempting to queue a buffer that has already been
+ * queued will return -EINVAL.
+ */
+int uvc_queue_buffer(struct uvc_video_queue *queue,
+	struct v4l2_buffer *v4l2_buf)
+{
+	struct uvc_buffer *buf;
+	unsigned long flags;
+	int ret = 0;
+
+	uvc_trace(UVC_TRACE_CAPTURE, "Queuing buffer %u.\n", v4l2_buf->index);
+
+	if (v4l2_buf->type != queue->type ||
+	    v4l2_buf->memory != V4L2_MEMORY_MMAP) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer type (%u) "
+			"and/or memory (%u).\n", v4l2_buf->type,
+			v4l2_buf->memory);
+		return -EINVAL;
+	}
+
+	mutex_lock(&queue->mutex);
+	if (v4l2_buf->index >= queue->count) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Out of range index.\n");
+		ret = -EINVAL;
+		goto done;
+	}
+
+	buf = &queue->buffer[v4l2_buf->index];
+	if (buf->state != UVC_BUF_STATE_IDLE) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer state "
+			"(%u).\n", buf->state);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	if (v4l2_buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	    v4l2_buf->bytesused > buf->buf.length) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
+		ret = -EINVAL;
+		goto done;
+	}
+
+	if (v4l2_buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		buf->buf.bytesused = 0;
+	else
+		buf->buf.bytesused = v4l2_buf->bytesused;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	if (queue->flags & UVC_QUEUE_DISCONNECTED) {
+		spin_unlock_irqrestore(&queue->irqlock, flags);
+		ret = -ENODEV;
+		goto done;
+	}
+	buf->state = UVC_BUF_STATE_QUEUED;
+
+	ret = (queue->flags & UVC_QUEUE_PAUSED) != 0;
+	queue->flags &= ~UVC_QUEUE_PAUSED;
+
+	list_add_tail(&buf->stream, &queue->mainqueue);
+	list_add_tail(&buf->queue, &queue->irqqueue);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+static int uvc_queue_waiton(struct uvc_buffer *buf, int nonblocking)
+{
+	if (nonblocking) {
+		return (buf->state != UVC_BUF_STATE_QUEUED &&
+			buf->state != UVC_BUF_STATE_ACTIVE)
+			? 0 : -EAGAIN;
+	}
+
+	return wait_event_interruptible(buf->wait,
+		buf->state != UVC_BUF_STATE_QUEUED &&
+		buf->state != UVC_BUF_STATE_ACTIVE);
+}
+
+/*
+ * Dequeue a video buffer. If nonblocking is false, block until a buffer is
+ * available.
+ */
+int uvc_dequeue_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf, int nonblocking)
+{
+	struct uvc_buffer *buf;
+	int ret = 0;
+
+	if (v4l2_buf->type != queue->type ||
+	    v4l2_buf->memory != V4L2_MEMORY_MMAP) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer type (%u) "
+			"and/or memory (%u).\n", v4l2_buf->type,
+			v4l2_buf->memory);
+		return -EINVAL;
+	}
+
+	mutex_lock(&queue->mutex);
+	if (list_empty(&queue->mainqueue)) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Empty buffer queue.\n");
+		ret = -EINVAL;
+		goto done;
+	}
+
+	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
+	if ((ret = uvc_queue_waiton(buf, nonblocking)) < 0)
+		goto done;
+
+	uvc_trace(UVC_TRACE_CAPTURE, "Dequeuing buffer %u (%u, %u bytes).\n",
+		buf->buf.index, buf->state, buf->buf.bytesused);
+
+	switch (buf->state) {
+	case UVC_BUF_STATE_ERROR:
+		uvc_trace(UVC_TRACE_CAPTURE, "[W] Corrupted data "
+			"(transmission error).\n");
+		ret = -EIO;
+	case UVC_BUF_STATE_DONE:
+		buf->state = UVC_BUF_STATE_IDLE;
+		break;
+
+	case UVC_BUF_STATE_IDLE:
+	case UVC_BUF_STATE_QUEUED:
+	case UVC_BUF_STATE_ACTIVE:
+	default:
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer state %u "
+			"(driver bug?).\n", buf->state);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	list_del(&buf->stream);
+	__uvc_query_buffer(buf, v4l2_buf);
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
+ * Poll the video queue.
+ *
+ * This function implements video queue polling and is intended to be used by
+ * the device poll handler.
+ */
+unsigned int uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
+		poll_table *wait)
+{
+	struct uvc_buffer *buf;
+	unsigned int mask = 0;
+
+	mutex_lock(&queue->mutex);
+	if (list_empty(&queue->mainqueue))
+		goto done;
+
+	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
+
+	poll_wait(file, &buf->wait, wait);
+	if (buf->state == UVC_BUF_STATE_DONE ||
+	    buf->state == UVC_BUF_STATE_ERROR)
+		mask |= POLLOUT | POLLWRNORM;
+
+done:
+	mutex_unlock(&queue->mutex);
+	return mask;
+}
+
+/*
+ * VMA operations.
+ */
+static void uvc_vm_open(struct vm_area_struct *vma)
+{
+	struct uvc_buffer *buffer = vma->vm_private_data;
+	buffer->vma_use_count++;
+}
+
+static void uvc_vm_close(struct vm_area_struct *vma)
+{
+	struct uvc_buffer *buffer = vma->vm_private_data;
+	buffer->vma_use_count--;
+}
+
+static struct vm_operations_struct uvc_vm_ops = {
+	.open		= uvc_vm_open,
+	.close		= uvc_vm_close,
+};
+
+/*
+ * Memory-map a buffer.
+ *
+ * This function implements video buffer memory mapping and is intended to be
+ * used by the device mmap handler.
+ */
+int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
+{
+	struct uvc_buffer *uninitialized_var(buffer);
+	struct page *page;
+	unsigned long addr, start, size;
+	unsigned int i;
+	int ret = 0;
+
+	start = vma->vm_start;
+	size = vma->vm_end - vma->vm_start;
+
+	mutex_lock(&queue->mutex);
+
+	for (i = 0; i < queue->count; ++i) {
+		buffer = &queue->buffer[i];
+		if ((buffer->buf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
+			break;
+	}
+
+	if (i == queue->count || size != queue->buf_size) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/*
+	 * VM_IO marks the area as being an mmaped region for I/O to a
+	 * device. It also prevents the region from being core dumped.
+	 */
+	vma->vm_flags |= VM_IO;
+
+	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
+	while (size > 0) {
+		page = vmalloc_to_page((void *)addr);
+		if ((ret = vm_insert_page(vma, start, page)) < 0)
+			goto done;
+
+		start += PAGE_SIZE;
+		addr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	vma->vm_ops = &uvc_vm_ops;
+	vma->vm_private_data = buffer;
+	uvc_vm_open(vma);
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
+ * Enable or disable the video buffers queue.
+ *
+ * The queue must be enabled before starting video acquisition and must be
+ * disabled after stopping it. This ensures that the video buffers queue
+ * state can be properly initialized before buffers are accessed from the
+ * interrupt handler.
+ *
+ * Enabling the video queue initializes parameters (such as sequence number,
+ * sync pattern, ...). If the queue is already enabled, return -EBUSY.
+ *
+ * Disabling the video queue cancels the queue and removes all buffers from
+ * the main queue.
+ *
+ * This function can't be called from interrupt context. Use
+ * uvc_queue_cancel() instead.
+ */
+int uvc_queue_enable(struct uvc_video_queue *queue, int enable)
+{
+	unsigned int i;
+	int ret = 0;
+
+	mutex_lock(&queue->mutex);
+	if (enable) {
+		if (uvc_queue_streaming(queue)) {
+			ret = -EBUSY;
+			goto done;
+		}
+		queue->sequence = 0;
+		queue->flags |= UVC_QUEUE_STREAMING;
+		queue->buf_used = 0;
+	} else {
+		uvc_queue_cancel(queue, 0);
+		INIT_LIST_HEAD(&queue->mainqueue);
+
+		for (i = 0; i < queue->count; ++i)
+			queue->buffer[i].state = UVC_BUF_STATE_IDLE;
+
+		queue->flags &= ~UVC_QUEUE_STREAMING;
+	}
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
+ * Cancel the video buffers queue.
+ *
+ * Cancelling the queue marks all buffers on the irq queue as erroneous,
+ * wakes them up and removes them from the queue.
+ *
+ * If the disconnect parameter is set, further calls to uvc_queue_buffer will
+ * fail with -ENODEV.
+ *
+ * This function acquires the irq spinlock and can be called from interrupt
+ * context.
+ */
+void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
+{
+	struct uvc_buffer *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	while (!list_empty(&queue->irqqueue)) {
+		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
+				       queue);
+		list_del(&buf->queue);
+		buf->state = UVC_BUF_STATE_ERROR;
+		wake_up(&buf->wait);
+	}
+	/* This must be protected by the irqlock spinlock to avoid race
+	 * conditions between uvc_queue_buffer and the disconnection event that
+	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not
+	 * blindly replace this logic by checking for the UVC_DEV_DISCONNECTED
+	 * state outside the queue code.
+	 */
+	if (disconnect)
+		queue->flags |= UVC_QUEUE_DISCONNECTED;
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+}
+
+struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
+		struct uvc_buffer *buf)
+{
+	struct uvc_buffer *nextbuf;
+	unsigned long flags;
+
+	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
+	    buf->buf.length != buf->buf.bytesused) {
+		buf->state = UVC_BUF_STATE_QUEUED;
+		buf->buf.bytesused = 0;
+		return buf;
+	}
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	list_del(&buf->queue);
+	if (!list_empty(&queue->irqqueue))
+		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
+					   queue);
+	else
+		nextbuf = NULL;
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+	buf->buf.sequence = queue->sequence++;
+	do_gettimeofday(&buf->buf.timestamp);
+
+	wake_up(&buf->wait);
+	return nextbuf;
+}
+
+struct uvc_buffer *uvc_queue_head(struct uvc_video_queue *queue)
+{
+	struct uvc_buffer *buf = NULL;
+
+	if (!list_empty(&queue->irqqueue))
+		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
+				       queue);
+	else
+		queue->flags |= UVC_QUEUE_PAUSED;
+
+	return buf;
+}
+
diff --git a/drivers/usb/gadget/uvc_queue.h b/drivers/usb/gadget/uvc_queue.h
new file mode 100644
index 0000000..1b0a88c
--- /dev/null
+++ b/drivers/usb/gadget/uvc_queue.h
@@ -0,0 +1,90 @@
+#ifndef _UVC_QUEUE_H_
+#define _UVC_QUEUE_H_
+
+#include <linux/kernel.h>
+#include <linux/videodev2.h>
+
+#ifdef __KERNEL__
+
+#include <linux/poll.h>
+
+/* Maximum frame size in bytes, for sanity checking. */
+#define UVC_MAX_FRAME_SIZE	(16*1024*1024)
+/* Maximum number of video buffers. */
+#define UVC_MAX_VIDEO_BUFFERS	32
+
+/* ------------------------------------------------------------------------
+ * Structures.
+ */
+
+enum uvc_buffer_state {
+	UVC_BUF_STATE_IDLE	= 0,
+	UVC_BUF_STATE_QUEUED	= 1,
+	UVC_BUF_STATE_ACTIVE	= 2,
+	UVC_BUF_STATE_DONE	= 3,
+	UVC_BUF_STATE_ERROR	= 4,
+};
+
+struct uvc_buffer {
+	unsigned long vma_use_count;
+	struct list_head stream;
+
+	/* Touched by interrupt handler. */
+	struct v4l2_buffer buf;
+	struct list_head queue;
+	wait_queue_head_t wait;
+	enum uvc_buffer_state state;
+};
+
+#define UVC_QUEUE_STREAMING		(1 << 0)
+#define UVC_QUEUE_DISCONNECTED		(1 << 1)
+#define UVC_QUEUE_DROP_INCOMPLETE	(1 << 2)
+#define UVC_QUEUE_PAUSED		(1 << 3)
+
+struct uvc_video_queue {
+	enum v4l2_buf_type type;
+
+	void *mem;
+	unsigned int flags;
+	__u32 sequence;
+
+	unsigned int count;
+	unsigned int buf_size;
+	unsigned int buf_used;
+	struct uvc_buffer buffer[UVC_MAX_VIDEO_BUFFERS];
+	struct mutex mutex;	/* protects buffers and mainqueue */
+	spinlock_t irqlock;	/* protects irqqueue */
+
+	struct list_head mainqueue;
+	struct list_head irqqueue;
+};
+
+extern void uvc_queue_init(struct uvc_video_queue *queue,
+		enum v4l2_buf_type type);
+extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
+		unsigned int nbuffers, unsigned int buflength);
+extern int uvc_free_buffers(struct uvc_video_queue *queue);
+extern int uvc_query_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf);
+extern int uvc_queue_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf);
+extern int uvc_dequeue_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf, int nonblocking);
+extern int uvc_queue_enable(struct uvc_video_queue *queue, int enable);
+extern void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect);
+extern struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
+		struct uvc_buffer *buf);
+extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
+		struct file *file, poll_table *wait);
+extern int uvc_queue_mmap(struct uvc_video_queue *queue,
+		struct vm_area_struct *vma);
+static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
+{
+	return queue->flags & UVC_QUEUE_STREAMING;
+}
+extern struct uvc_buffer *uvc_queue_head(struct uvc_video_queue *queue);
+
+#endif /* __KERNEL__ */
+
+#endif /* _UVC_QUEUE_H_ */
+
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
new file mode 100644
index 0000000..384b777
--- /dev/null
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -0,0 +1,376 @@
+/*
+ *	uvc_v4l2.c  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+
+#include <media/v4l2-dev.h>
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
+#include <media/v4l2-ioctl.h>
+#endif
+
+#include "uvc.h"
+#include "uvc_queue.h"
+
+/* --------------------------------------------------------------------------
+ * Events handling
+ *
+ */
+
+static int
+uvc_event_read(struct uvc_device *uvc, struct uvc_event *event,
+		  int nonblocking)
+{
+	int ret;
+
+	if (nonblocking)
+		ret = kfifo_len(uvc->events) ? 0 : -EAGAIN;
+	else
+		ret = wait_event_interruptible(uvc->event_wait,
+				kfifo_len(uvc->events) != 0);
+
+	if (ret < 0)
+		return ret;
+
+	kfifo_get(uvc->events, (unsigned char *)event, sizeof(*event));
+
+	if (event->type == UVC_EVENT_SETUP) {
+		/* Tell the complete callback to generate an event for the
+		 * next request that will be enqueued by uvc_event_write.
+		 */
+		uvc->event_setup_out = !(event->req.bRequestType & USB_DIR_IN);
+		uvc->event_length = event->req.wLength;
+	}
+
+	return 0;
+}
+
+static int
+uvc_event_write(struct uvc_device *uvc, struct uvc_event_data *data)
+{
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+	struct usb_request *req = uvc->control_req;
+
+	if (data->length < 0)
+		return usb_ep_set_halt(cdev->gadget->ep0);
+
+	req->length = min((int)uvc->event_length, data->length);
+	req->zero = data->length < uvc->event_length;
+	req->dma = DMA_ADDR_INVALID;
+
+	memcpy(req->buf, data->data, data->length);
+
+	return usb_ep_queue(cdev->gadget->ep0, req, GFP_KERNEL);
+}
+
+/* --------------------------------------------------------------------------
+ * V4L2
+ */
+
+struct uvc_format
+{
+	u8 bpp;
+	u32 fcc;
+};
+
+static struct uvc_format uvc_formats[] = {
+	{ 16, V4L2_PIX_FMT_YUYV  },
+	{ 0,  V4L2_PIX_FMT_MJPEG },
+};
+
+static int
+uvc_v4l2_get_format(struct uvc_video *video, struct v4l2_format *fmt)
+{
+	fmt->fmt.pix.pixelformat = video->fcc;
+	fmt->fmt.pix.width = video->width;
+	fmt->fmt.pix.height = video->height;
+	fmt->fmt.pix.field = V4L2_FIELD_NONE;
+	fmt->fmt.pix.bytesperline = video->bpp * video->width / 8;
+	fmt->fmt.pix.sizeimage = video->imagesize;
+	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+	fmt->fmt.pix.priv = 0;
+
+	return 0;
+}
+
+static int
+uvc_v4l2_set_format(struct uvc_video *video, struct v4l2_format *fmt)
+{
+	struct uvc_format *format;
+	unsigned int imagesize;
+	unsigned int bpl;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(uvc_formats); ++i) {
+		format = &uvc_formats[i];
+		if (format->fcc == fmt->fmt.pix.pixelformat)
+			break;
+	}
+
+	if (format == NULL || format->fcc != fmt->fmt.pix.pixelformat) {
+		printk(KERN_INFO "Unsupported format 0x%08x.\n",
+			fmt->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	bpl = format->bpp * fmt->fmt.pix.width / 8;
+	imagesize = bpl ? bpl * video->height : fmt->fmt.pix.sizeimage;
+
+	video->fcc = format->fcc;
+	video->bpp = format->bpp;
+	video->width = fmt->fmt.pix.width;
+	video->height = fmt->fmt.pix.height;
+	video->imagesize = imagesize;
+
+	fmt->fmt.pix.field = V4L2_FIELD_NONE;
+	fmt->fmt.pix.bytesperline = bpl;
+	fmt->fmt.pix.sizeimage = imagesize;
+	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+	fmt->fmt.pix.priv = 0;
+
+	return 0;
+}
+
+static int
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+uvc_v4l2_open(struct inode *inode, struct file *file)
+#else
+uvc_v4l2_open(struct file *file)
+#endif
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_file_handle *handle;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (handle == NULL)
+		return -ENOMEM;
+
+	handle->device = &uvc->video;
+	file->private_data = handle;
+
+	uvc_function_connect(uvc);
+	return 0;
+}
+
+static int
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
+uvc_v4l2_release(struct inode *inode, struct file *file)
+#else
+uvc_v4l2_release(struct file *file)
+#endif
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_file_handle *handle = file->private_data;
+	struct uvc_video *video = handle->device;
+
+	uvc_function_disconnect(uvc);
+
+	uvc_video_enable(video, 0);
+	mutex_lock(&video->queue.mutex);
+	if (uvc_free_buffers(&video->queue) < 0)
+		printk(KERN_ERR "uvc_v4l2_release: Unable to free "
+				"buffers.\n");
+	mutex_unlock(&video->queue.mutex);
+
+	file->private_data = NULL;
+	kfree(handle);
+	return 0;
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+static int
+uvc_v4l2_do_ioctl(struct inode *inode, struct file *file, unsigned int cmd, void *arg)
+#else
+static long
+uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
+#endif
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+	struct uvc_video *video = &uvc->video;
+	int ret = 0;
+
+	switch (cmd) {
+	/* Query capabilities */
+	case VIDIOC_QUERYCAP:
+	{
+		struct v4l2_capability *cap = arg;
+
+		memset(cap, 0, sizeof *cap);
+		strncpy(cap->driver, "g_uvc", sizeof(cap->driver));
+		strncpy(cap->card, cdev->gadget->name, sizeof(cap->card));
+		strncpy(cap->bus_info, dev_name(&cdev->gadget->dev),
+			sizeof cap->bus_info);
+		cap->version = DRIVER_VERSION_NUMBER;
+		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+		break;
+	}
+
+	/* Get & Set format */
+	case VIDIOC_G_FMT:
+	{
+		struct v4l2_format *fmt = arg;
+
+		if (fmt->type != video->queue.type)
+			return -EINVAL;
+
+		return uvc_v4l2_get_format(video, fmt);
+	}
+
+	case VIDIOC_S_FMT:
+	{
+		struct v4l2_format *fmt = arg;
+
+		if (fmt->type != video->queue.type)
+			return -EINVAL;
+
+		return uvc_v4l2_set_format(video, fmt);
+	}
+
+	/* Buffers & streaming */
+	case VIDIOC_REQBUFS:
+	{
+		struct v4l2_requestbuffers *rb = arg;
+
+		if (rb->type != video->queue.type ||
+		    rb->memory != V4L2_MEMORY_MMAP)
+			return -EINVAL;
+
+		ret = uvc_alloc_buffers(&video->queue, rb->count,
+					video->imagesize);
+		if (ret < 0)
+			return ret;
+
+		rb->count = ret;
+		ret = 0;
+		break;
+	}
+
+	case VIDIOC_QUERYBUF:
+	{
+		struct v4l2_buffer *buf = arg;
+
+		if (buf->type != video->queue.type)
+			return -EINVAL;
+
+		return uvc_query_buffer(&video->queue, buf);
+	}
+
+	case VIDIOC_QBUF:
+		if ((ret = uvc_queue_buffer(&video->queue, arg)) < 0)
+			return ret;
+
+		return uvc_video_pump(video);
+
+	case VIDIOC_DQBUF:
+		return uvc_dequeue_buffer(&video->queue, arg,
+			file->f_flags & O_NONBLOCK);
+
+	case VIDIOC_STREAMON:
+	{
+		int *type = arg;
+
+		if (*type != video->queue.type)
+			return -EINVAL;
+
+		return uvc_video_enable(video, 1);
+	}
+
+	case VIDIOC_STREAMOFF:
+	{
+		int *type = arg;
+
+		if (*type != video->queue.type)
+			return -EINVAL;
+
+		return uvc_video_enable(video, 0);
+	}
+
+	/* Events */
+	case UVCIOC_EVENT_READ:
+		ret = uvc_event_read(uvc, arg, file->f_flags & O_NONBLOCK);
+		break;
+
+	case UVCIOC_EVENT_WRITE:
+		ret = uvc_event_write(uvc, arg);
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return ret;
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+static int
+uvc_v4l2_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return video_usercopy(inode, file, cmd, arg, uvc_v4l2_do_ioctl);
+}
+#else
+static long
+uvc_v4l2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return video_usercopy(file, cmd, arg, uvc_v4l2_do_ioctl);
+}
+#endif
+
+static int
+uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+
+	return uvc_queue_mmap(&uvc->video.queue, vma);
+}
+
+static unsigned int
+uvc_v4l2_poll(struct file *file, poll_table *wait)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	unsigned int mask = 0;
+
+	poll_wait(file, &uvc->event_wait, wait);
+	if (kfifo_len(uvc->events) != 0)
+		mask |= POLLPRI;
+
+	mask |= uvc_queue_poll(&uvc->video.queue, file, wait);
+
+	return mask;
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+struct file_operations uvc_v4l2_fops = {
+#else
+struct v4l2_file_operations uvc_v4l2_fops = {
+#endif
+	.owner		= THIS_MODULE,
+	.open		= uvc_v4l2_open,
+	.release	= uvc_v4l2_release,
+	.ioctl		= uvc_v4l2_ioctl,
+	.mmap		= uvc_v4l2_mmap,
+	.poll		= uvc_v4l2_poll,
+};
+
diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_video.c
new file mode 100644
index 0000000..2777214
--- /dev/null
+++ b/drivers/usb/gadget/uvc_video.c
@@ -0,0 +1,386 @@
+/*
+ *	uvc_video.c  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/usb/ch9.h>
+#include <linux/usb/gadget.h>
+
+#include <media/v4l2-dev.h>
+
+#include "uvc.h"
+#include "uvc_queue.h"
+
+/* --------------------------------------------------------------------------
+ * Video codecs
+ */
+
+static int
+uvc_video_encode_header(struct uvc_video *video, struct uvc_buffer *buf,
+		u8 *data, int len)
+{
+	data[0] = 2;
+	data[1] = UVC_STREAM_EOH | video->fid;
+
+	if (buf->buf.bytesused - video->queue.buf_used <= len - 2)
+		data[1] |= UVC_STREAM_EOF;
+
+	return 2;
+}
+
+static int
+uvc_video_encode_data(struct uvc_video *video, struct uvc_buffer *buf,
+		u8 *data, int len)
+{
+	struct uvc_video_queue *queue = &video->queue;
+	unsigned int nbytes;
+	void *mem;
+
+	/* Copy video data to the USB buffer. */
+	mem = queue->mem + buf->buf.m.offset + queue->buf_used;
+	nbytes = min((unsigned int)len, buf->buf.bytesused - queue->buf_used);
+
+	memcpy(data, mem, nbytes);
+	queue->buf_used += nbytes;
+
+	return nbytes;
+}
+
+static void
+uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
+		struct uvc_buffer *buf)
+{
+	void *mem = req->buf;
+	int len = video->req_size;
+	int ret;
+
+	/* Add a header at the beginning of the payload. */
+	if (video->payload_size == 0) {
+		ret = uvc_video_encode_header(video, buf, mem, len);
+		video->payload_size += ret;
+		mem += ret;
+		len -= ret;
+	}
+
+	/* Process video data. */
+	len = min((int)(video->max_payload_size - video->payload_size), len);
+	ret = uvc_video_encode_data(video, buf, mem, len);
+
+	video->payload_size += ret;
+	len -= ret;
+
+	req->length = video->req_size - len;
+	req->zero = video->payload_size == video->max_payload_size;
+
+	if (buf->buf.bytesused == video->queue.buf_used) {
+		video->queue.buf_used = 0;
+		buf->state = UVC_BUF_STATE_DONE;
+		uvc_queue_next_buffer(&video->queue, buf);
+		video->fid ^= UVC_STREAM_FID;
+
+		video->payload_size = 0;
+	}
+
+	if (video->payload_size == video->max_payload_size ||
+	    buf->buf.bytesused == video->queue.buf_used)
+		video->payload_size = 0;
+}
+
+static void
+uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
+		struct uvc_buffer *buf)
+{
+	void *mem = req->buf;
+	int len = video->req_size;
+	int ret;
+
+	/* Add the header. */
+	ret = uvc_video_encode_header(video, buf, mem, len);
+	mem += ret;
+	len -= ret;
+
+	/* Process video data. */
+	ret = uvc_video_encode_data(video, buf, mem, len);
+	len -= ret;
+
+	req->length = video->req_size - len;
+
+	if (buf->buf.bytesused == video->queue.buf_used) {
+		video->queue.buf_used = 0;
+		buf->state = UVC_BUF_STATE_DONE;
+		uvc_queue_next_buffer(&video->queue, buf);
+		video->fid ^= UVC_STREAM_FID;
+	}
+}
+
+/* --------------------------------------------------------------------------
+ * Request handling
+ */
+
+/*
+ * I somehow feel that synchronisation won't be easy to achieve here. We have
+ * three events that control USB requests submission:
+ *
+ * - USB request completion: the completion handler will resubmit the request
+ *   if a video buffer is available.
+ *
+ * - USB interface setting selection: in response to a SET_INTERFACE request,
+ *   the handler will start streaming if a video buffer is available and if
+ *   video is not currently streaming.
+ *
+ * - V4L2 buffer queueing: the driver will start streaming if video is not
+ *   currently streaming.
+ *
+ * Race conditions between those 3 events might lead to deadlocks or other
+ * nasty side effects.
+ *
+ * The "video currently streaming" condition can't be detected by the irqqueue
+ * being empty, as a request can still be in flight. A separate "queue paused"
+ * flag is thus needed.
+ *
+ * The paused flag will be set when we try to retrieve the irqqueue head if the
+ * queue is empty, and cleared when we queue a buffer.
+ *
+ * The USB request completion handler will get the buffer at the irqqueue head
+ * under protection of the queue spinlock. If the queue is empty, the streaming
+ * paused flag will be set. Right after releasing the spinlock a userspace
+ * application can queue a buffer. The flag will then cleared, and the ioctl
+ * handler will restart the video stream.
+ */
+static void
+uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct uvc_video *video = req->context;
+	struct uvc_buffer *buf;
+	unsigned long flags;
+	int ret;
+
+	switch (req->status) {
+	case 0:
+		break;
+
+	case -ESHUTDOWN:
+		printk(KERN_INFO "VS request cancelled.\n");
+		goto requeue;
+
+	default:
+		printk(KERN_INFO "VS request completed with status %d.\n",
+			req->status);
+		goto requeue;
+	}
+
+	spin_lock_irqsave(&video->queue.irqlock, flags);
+	buf = uvc_queue_head(&video->queue);
+	if (buf == NULL) {
+		spin_unlock_irqrestore(&video->queue.irqlock, flags);
+		goto requeue;
+	}
+
+	video->encode(req, video, buf);
+
+	if ((ret = usb_ep_queue(ep, req, GFP_ATOMIC)) < 0) {
+		printk(KERN_INFO "Failed to queue request (%d).\n", ret);
+		usb_ep_set_halt(ep);
+		spin_unlock_irqrestore(&video->queue.irqlock, flags);
+		goto requeue;
+	}
+	spin_unlock_irqrestore(&video->queue.irqlock, flags);
+
+	return;
+
+requeue:
+	spin_lock_irqsave(&video->req_lock, flags);
+	list_add_tail(&req->list, &video->req_free);
+	spin_unlock_irqrestore(&video->req_lock, flags);
+}
+
+static int
+uvc_video_free_requests(struct uvc_video *video)
+{
+	unsigned int i;
+
+	for (i = 0; i < UVC_NUM_REQUESTS; ++i) {
+		if (video->req[i]) {
+			usb_ep_free_request(video->ep, video->req[i]);
+			video->req[i] = NULL;
+		}
+
+		if (video->req_buffer[i]) {
+			kfree(video->req_buffer[i]);
+			video->req_buffer[i] = NULL;
+		}
+	}
+
+	INIT_LIST_HEAD(&video->req_free);
+	video->req_size = 0;
+	return 0;
+}
+
+static int
+uvc_video_alloc_requests(struct uvc_video *video)
+{
+	unsigned int i;
+	int ret = -ENOMEM;
+
+	BUG_ON(video->req_size);
+
+	for (i = 0; i < UVC_NUM_REQUESTS; ++i) {
+		video->req_buffer[i] = kmalloc(video->ep->maxpacket, GFP_KERNEL);
+		if (video->req_buffer[i] == NULL)
+			goto error;
+
+		video->req[i] = usb_ep_alloc_request(video->ep, GFP_KERNEL);
+		if (video->req[i] == NULL)
+			goto error;
+
+		video->req[i]->buf = video->req_buffer[i];
+		video->req[i]->length = 0;
+		video->req[i]->dma = DMA_ADDR_INVALID;
+		video->req[i]->complete = uvc_video_complete;
+		video->req[i]->context = video;
+
+		list_add_tail(&video->req[i]->list, &video->req_free);
+	}
+
+	video->req_size = video->ep->maxpacket;
+	return 0;
+
+error:
+	uvc_video_free_requests(video);
+	return ret;
+}
+
+/* --------------------------------------------------------------------------
+ * Video streaming
+ */
+
+/*
+ * uvc_video_pump - Pump video data into the USB requests
+ *
+ * This function fills the available USB requests (listed in req_free) with
+ * video data from the queued buffers.
+ */
+int
+uvc_video_pump(struct uvc_video *video)
+{
+	struct usb_request *req;
+	struct uvc_buffer *buf;
+	unsigned long flags;
+	int ret;
+
+	/* FIXME TODO Race between uvc_video_pump and requests completion
+	 * handler ???
+	 */
+
+	while (1) {
+		/* Retrieve the first available USB request, protected by the
+		 * request lock.
+		 */
+		spin_lock_irqsave(&video->req_lock, flags);
+		if (list_empty(&video->req_free)) {
+			spin_unlock_irqrestore(&video->req_lock, flags);
+			return 0;
+		}
+		req = list_first_entry(&video->req_free, struct usb_request,
+					list);
+		list_del(&req->list);
+		spin_unlock_irqrestore(&video->req_lock, flags);
+
+		/* Retrieve the first available video buffer and fill the
+		 * request, protected by the video queue irqlock.
+		 */
+		spin_lock_irqsave(&video->queue.irqlock, flags);
+		buf = uvc_queue_head(&video->queue);
+		if (buf == NULL) {
+			spin_unlock_irqrestore(&video->queue.irqlock, flags);
+			break;
+		}
+
+		video->encode(req, video, buf);
+
+		/* Queue the USB request */
+		if ((ret = usb_ep_queue(video->ep, req, GFP_KERNEL)) < 0) {
+			printk(KERN_INFO "Failed to queue request (%d)\n", ret);
+			usb_ep_set_halt(video->ep);
+			spin_unlock_irqrestore(&video->queue.irqlock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&video->queue.irqlock, flags);
+	}
+
+	spin_lock_irqsave(&video->req_lock, flags);
+	list_add_tail(&req->list, &video->req_free);
+	spin_unlock_irqrestore(&video->req_lock, flags);
+	return 0;
+}
+
+/*
+ * Enable or disable the video stream.
+ */
+int
+uvc_video_enable(struct uvc_video *video, int enable)
+{
+	unsigned int i;
+	int ret;
+
+	if (video->ep == NULL) {
+		printk(KERN_INFO "Video enable failed, device is "
+			"uninitialized.\n");
+		return -ENODEV;
+	}
+
+	if (!enable) {
+		for (i = 0; i < UVC_NUM_REQUESTS; ++i)
+			usb_ep_dequeue(video->ep, video->req[i]);
+
+		uvc_video_free_requests(video);
+		uvc_queue_enable(&video->queue, 0);
+		return 0;
+	}
+
+	if ((ret = uvc_queue_enable(&video->queue, 1)) < 0)
+		return ret;
+
+	if ((ret = uvc_video_alloc_requests(video)) < 0)
+		return ret;
+
+	if (video->max_payload_size) {
+		video->encode = uvc_video_encode_bulk;
+		video->payload_size = 0;
+	} else
+		video->encode = uvc_video_encode_isoc;
+
+	return uvc_video_pump(video);
+}
+
+/*
+ * Initialize the UVC video stream.
+ */
+int
+uvc_video_init(struct uvc_video *video)
+{
+	INIT_LIST_HEAD(&video->req_free);
+	spin_lock_init(&video->req_lock);
+
+	video->fcc = V4L2_PIX_FMT_YUYV;
+	video->bpp = 16;
+	video->width = 320;
+	video->height = 240;
+	video->imagesize = 320 * 240 * 2;
+
+	/* Initialize the video buffers queue. */
+	uvc_queue_init(&video->queue, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	return 0;
+}
+
-- 
1.6.3.3

-- 
Laurent Pinchart
