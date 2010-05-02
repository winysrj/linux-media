Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36094 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0EBS5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 14:57:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org
Cc: linux-media@vger.kernel.org, robert.lukassen@tomtom.com
Subject: [PATCH 1/2] USB gadget: video class function driver
Date: Sun,  2 May 2010 20:57:41 +0200
Message-Id: <1272826662-8279-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1272826662-8279-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1272826662-8279-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This USB video class function driver implements a video capture device from the
host's point of view. It creates a V4L2 output device on the gadget's side to
transfer data from a userspace application over USB.

The UVC-specific descriptors are passed by the gadget driver to the UVC
function driver, making them completely configurable without any modification
to the function's driver code.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/f_uvc.c     |  661 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/f_uvc.h     |  376 +++++++++++++++++++++++
 drivers/usb/gadget/uvc.h       |  241 +++++++++++++++
 drivers/usb/gadget/uvc_queue.c |  583 +++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/uvc_queue.h |   89 ++++++
 drivers/usb/gadget/uvc_v4l2.c  |  374 +++++++++++++++++++++++
 drivers/usb/gadget/uvc_video.c |  386 +++++++++++++++++++++++
 7 files changed, 2710 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/gadget/f_uvc.c
 create mode 100644 drivers/usb/gadget/f_uvc.h
 create mode 100644 drivers/usb/gadget/uvc.h
 create mode 100644 drivers/usb/gadget/uvc_queue.c
 create mode 100644 drivers/usb/gadget/uvc_queue.h
 create mode 100644 drivers/usb/gadget/uvc_v4l2.c
 create mode 100644 drivers/usb/gadget/uvc_video.c

diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
new file mode 100644
index 0000000..fc2611f
--- /dev/null
+++ b/drivers/usb/gadget/f_uvc.c
@@ -0,0 +1,661 @@
+/*
+ *	uvc_gadget.c  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009-2010
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
+#include <linux/usb/ch9.h>
+#include <linux/usb/gadget.h>
+#include <linux/usb/video.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+
+#include <media/v4l2-dev.h>
+#include <media/v4l2-event.h>
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
+	.wMaxPacketSize		= cpu_to_le16(512),
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
+	struct v4l2_event v4l2_event;
+	struct uvc_event *uvc_event = (void *)&v4l2_event.u.data;
+
+	if (uvc->event_setup_out) {
+		uvc->event_setup_out = 0;
+
+		memset(&v4l2_event, 0, sizeof(v4l2_event));
+		v4l2_event.type = UVC_EVENT_DATA;
+		uvc_event->data.length = req->actual;
+		memcpy(&uvc_event->data.data, req->buf, req->actual);
+		v4l2_event_queue(uvc->vdev, &v4l2_event);
+	}
+}
+
+static int
+uvc_function_setup(struct usb_function *f, const struct usb_ctrlrequest *ctrl)
+{
+	struct uvc_device *uvc = to_uvc(f);
+	struct v4l2_event v4l2_event;
+	struct uvc_event *uvc_event = (void *)&v4l2_event.u.data;
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
+	memset(&v4l2_event, 0, sizeof(v4l2_event));
+	v4l2_event.type = UVC_EVENT_SETUP;
+	memcpy(&uvc_event->req, ctrl, sizeof(uvc_event->req));
+	v4l2_event_queue(uvc->vdev, &v4l2_event);
+
+	return 0;
+}
+
+static int
+uvc_function_get_alt(struct usb_function *f, unsigned interface)
+{
+	struct uvc_device *uvc = to_uvc(f);
+
+	INFO(f->config->cdev, "uvc_function_get_alt(%u)\n", interface);
+
+	if (interface == uvc->control_intf)
+		return 0;
+	else if (interface != uvc->streaming_intf)
+		return -EINVAL;
+	else
+		return uvc->state == UVC_STATE_STREAMING ? 1 : 0;
+}
+
+static int
+uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
+{
+	struct uvc_device *uvc = to_uvc(f);
+	struct v4l2_event v4l2_event;
+	struct uvc_event *uvc_event = (void *)&v4l2_event.u.data;
+
+	INFO(f->config->cdev, "uvc_function_set_alt(%u, %u)\n", interface, alt);
+
+	if (interface == uvc->control_intf) {
+		if (alt)
+			return -EINVAL;
+
+		if (uvc->state == UVC_STATE_DISCONNECTED) {
+			memset(&v4l2_event, 0, sizeof(v4l2_event));
+			v4l2_event.type = UVC_EVENT_CONNECT;
+			uvc_event->speed = f->config->cdev->gadget->speed;
+			v4l2_event_queue(uvc->vdev, &v4l2_event);
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
+		memset(&v4l2_event, 0, sizeof(v4l2_event));
+		v4l2_event.type = UVC_EVENT_STREAMOFF;
+		v4l2_event_queue(uvc->vdev, &v4l2_event);
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
+		memset(&v4l2_event, 0, sizeof(v4l2_event));
+		v4l2_event.type = UVC_EVENT_STREAMON;
+		v4l2_event_queue(uvc->vdev, &v4l2_event);
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
+	struct v4l2_event v4l2_event;
+
+	INFO(f->config->cdev, "uvc_function_disable\n");
+
+	memset(&v4l2_event, 0, sizeof(v4l2_event));
+	v4l2_event.type = UVC_EVENT_DISCONNECT;
+	v4l2_event_queue(uvc->vdev, &v4l2_event);
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
+	video->parent = &cdev->gadget->dev;
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
+	uvc->func.get_alt = uvc_function_get_alt;
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
index 0000000..8a5db7c
--- /dev/null
+++ b/drivers/usb/gadget/f_uvc.h
@@ -0,0 +1,376 @@
+/*
+ *	f_uvc.h  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009-2010
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
index 0000000..0a705e6
--- /dev/null
+++ b/drivers/usb/gadget/uvc.h
@@ -0,0 +1,241 @@
+/*
+ *	uvc_gadget.h  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009-2010
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
+#define UVC_EVENT_FIRST			(V4L2_EVENT_PRIVATE_START + 0)
+#define UVC_EVENT_CONNECT		(V4L2_EVENT_PRIVATE_START + 0)
+#define UVC_EVENT_DISCONNECT		(V4L2_EVENT_PRIVATE_START + 1)
+#define UVC_EVENT_STREAMON		(V4L2_EVENT_PRIVATE_START + 2)
+#define UVC_EVENT_STREAMOFF		(V4L2_EVENT_PRIVATE_START + 3)
+#define UVC_EVENT_SETUP			(V4L2_EVENT_PRIVATE_START + 4)
+#define UVC_EVENT_DATA			(V4L2_EVENT_PRIVATE_START + 5)
+#define UVC_EVENT_LAST			(V4L2_EVENT_PRIVATE_START + 5)
+
+struct uvc_request_data
+{
+	unsigned int length;
+	__u8 data[60];
+};
+
+struct uvc_event
+{
+	union {
+		enum usb_device_speed speed;
+		struct usb_ctrlrequest req;
+		struct uvc_request_data data;
+	};
+};
+
+#define UVCIOC_SEND_RESPONSE		_IOW('U', 1, struct uvc_request_data)
+
+#define UVC_INTF_CONTROL		0
+#define UVC_INTF_STREAMING		1
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
+#include <linux/usb.h>	/* For usb_endpoint_* */
+#include <linux/usb/gadget.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-fh.h>
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
+	/* Events */
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
+	struct v4l2_fh vfh;
+	struct uvc_video *device;
+};
+
+#define to_uvc_file_handle(handle) \
+	container_of(handle, struct uvc_file_handle, vfh)
+
+extern struct v4l2_file_operations uvc_v4l2_fops;
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
diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
new file mode 100644
index 0000000..4389199
--- /dev/null
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -0,0 +1,583 @@
+/*
+ *	uvc_queue.c  --  USB Video Class driver - Buffers management
+ *
+ *	Copyright (C) 2005-2010
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
index 0000000..7f5a33f
--- /dev/null
+++ b/drivers/usb/gadget/uvc_queue.h
@@ -0,0 +1,89 @@
+#ifndef _UVC_QUEUE_H_
+#define _UVC_QUEUE_H_
+
+#ifdef __KERNEL__
+
+#include <linux/kernel.h>
+#include <linux/poll.h>
+#include <linux/videodev2.h>
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
index 0000000..a7989f2
--- /dev/null
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -0,0 +1,374 @@
+/*
+ *	uvc_v4l2.c  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009-2010
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
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+
+#include "uvc.h"
+#include "uvc_queue.h"
+
+/* --------------------------------------------------------------------------
+ * Requests handling
+ */
+
+static int
+uvc_send_response(struct uvc_device *uvc, struct uvc_request_data *data)
+{
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+	struct usb_request *req = uvc->control_req;
+
+	if (data->length < 0)
+		return usb_ep_set_halt(cdev->gadget->ep0);
+
+	req->length = min(uvc->event_length, data->length);
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
+	imagesize = bpl ? bpl * fmt->fmt.pix.height : fmt->fmt.pix.sizeimage;
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
+uvc_v4l2_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_file_handle *handle;
+	int ret;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (handle == NULL)
+		return -ENOMEM;
+
+	ret = v4l2_fh_init(&handle->vfh, vdev);
+	if (ret < 0)
+		goto error;
+
+	ret = v4l2_event_init(&handle->vfh);
+	if (ret < 0)
+		goto error;
+
+	ret = v4l2_event_alloc(&handle->vfh, 8);
+	if (ret < 0)
+		goto error;
+
+	v4l2_fh_add(&handle->vfh);
+
+	handle->device = &uvc->video;
+	file->private_data = &handle->vfh;
+
+	uvc_function_connect(uvc);
+	return 0;
+
+error:
+	v4l2_fh_exit(&handle->vfh);
+	return ret;
+}
+
+static int
+uvc_v4l2_release(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
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
+	v4l2_fh_del(&handle->vfh);
+	v4l2_fh_exit(&handle->vfh);
+	kfree(handle);
+	return 0;
+}
+
+static long
+uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
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
+        case VIDIOC_DQEVENT:
+	{
+		struct v4l2_event *event = arg;
+
+		ret = v4l2_event_dequeue(&handle->vfh, event,
+					 file->f_flags & O_NONBLOCK);
+		if (ret == 0 && event->type == UVC_EVENT_SETUP) {
+			struct uvc_event *uvc_event = (void *)&event->u.data;
+
+			/* Tell the complete callback to generate an event for
+			 * the next request that will be enqueued by
+			 * uvc_event_write.
+			 */
+			uvc->event_setup_out =
+				!(uvc_event->req.bRequestType & USB_DIR_IN);
+			uvc->event_length = uvc_event->req.wLength;
+		}
+
+		return ret;
+	}
+
+	case VIDIOC_SUBSCRIBE_EVENT:
+	{
+		struct v4l2_event_subscription *sub = arg;
+
+		if (sub->type < UVC_EVENT_FIRST || sub->type > UVC_EVENT_LAST)
+			return -EINVAL;
+
+		return v4l2_event_subscribe(&handle->vfh, arg);
+	}
+
+	case VIDIOC_UNSUBSCRIBE_EVENT:
+		return v4l2_event_unsubscribe(&handle->vfh, arg);
+
+	case UVCIOC_SEND_RESPONSE:
+		ret = uvc_send_response(uvc, arg);
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return ret;
+}
+
+static long
+uvc_v4l2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return video_usercopy(file, cmd, arg, uvc_v4l2_do_ioctl);
+}
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
+	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
+	unsigned int mask = 0;
+
+	poll_wait(file, &handle->vfh.events->wait, wait);
+	if (v4l2_event_pending(&handle->vfh))
+		mask |= POLLPRI;
+
+	mask |= uvc_queue_poll(&uvc->video.queue, file, wait);
+
+	return mask;
+}
+
+struct v4l2_file_operations uvc_v4l2_fops = {
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
index 0000000..de8cbc4
--- /dev/null
+++ b/drivers/usb/gadget/uvc_video.c
@@ -0,0 +1,386 @@
+/*
+ *	uvc_video.c  --  USB Video Class Gadget driver
+ *
+ *	Copyright (C) 2009-2010
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
1.6.4.4

