Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:57811 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759324Ab2FAJj3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jun 2012 05:39:29 -0400
From: Bhupesh Sharma <bhupesh.sharma@st.com>
To: <laurent.pinchart@ideasonboard.com>, <linux-usb@vger.kernel.org>
Cc: <balbi@ti.com>, <linux-media@vger.kernel.org>,
	<gregkh@linuxfoundation.org>,
	Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH 3/5] usb: gadget/uvc: Add super-speed support to UVC webcam gadget
Date: Fri, 1 Jun 2012 15:08:56 +0530
Message-ID: <7da845d1b4ea9f8d716b7b218f03f9611e7ce97d.1338543124.git.bhupesh.sharma@st.com>
In-Reply-To: <cover.1338543124.git.bhupesh.sharma@st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds super-speed support to UVC webcam gadget.

Also in this patch:
	- We add the configurability to pass bInterval, bMaxBurst, mult
	  factors for video streaming endpoint (ISOC IN) through module
	  parameters.

	- We use config_ep_by_speed helper routine to configure video
	  streaming endpoint.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
---
 drivers/usb/gadget/f_uvc.c  |  241 ++++++++++++++++++++++++++++++++++++++-----
 drivers/usb/gadget/f_uvc.h  |    8 +-
 drivers/usb/gadget/uvc.h    |    4 +-
 drivers/usb/gadget/webcam.c |   29 +++++-
 4 files changed, 247 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index dd7d7a9..2a8bf06 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -29,6 +29,25 @@
 
 unsigned int uvc_gadget_trace_param;
 
+/*-------------------------------------------------------------------------*/
+
+/* module parameters specific to the Video streaming endpoint */
+static unsigned streaming_interval = 1;
+module_param(streaming_interval, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(streaming_interval, "1 - 16");
+
+static unsigned streaming_maxpacket = 1024;
+module_param(streaming_maxpacket, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(streaming_maxpacket, "0 - 1023 (fs), 0 - 1024 (hs/ss)");
+
+static unsigned streaming_mult;
+module_param(streaming_mult, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(streaming_mult, "0 - 2 (hs/ss only)");
+
+static unsigned streaming_maxburst;
+module_param(streaming_maxburst, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(streaming_maxburst, "0 - 15 (ss only)");
+
 /* --------------------------------------------------------------------------
  * Function descriptors
  */
@@ -84,7 +103,7 @@ static struct usb_interface_descriptor uvc_control_intf __initdata = {
 	.iInterface		= 0,
 };
 
-static struct usb_endpoint_descriptor uvc_control_ep __initdata = {
+static struct usb_endpoint_descriptor uvc_fs_control_ep __initdata = {
 	.bLength		= USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType	= USB_DT_ENDPOINT,
 	.bEndpointAddress	= USB_DIR_IN,
@@ -124,7 +143,7 @@ static struct usb_interface_descriptor uvc_streaming_intf_alt1 __initdata = {
 	.iInterface		= 0,
 };
 
-static struct usb_endpoint_descriptor uvc_streaming_ep = {
+static struct usb_endpoint_descriptor uvc_fs_streaming_ep = {
 	.bLength		= USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType	= USB_DT_ENDPOINT,
 	.bEndpointAddress	= USB_DIR_IN,
@@ -133,15 +152,72 @@ static struct usb_endpoint_descriptor uvc_streaming_ep = {
 	.bInterval		= 1,
 };
 
+static struct usb_endpoint_descriptor uvc_hs_streaming_ep = {
+	.bLength		= USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType	= USB_DT_ENDPOINT,
+	.bEndpointAddress	= USB_DIR_IN,
+	.bmAttributes		= USB_ENDPOINT_XFER_ISOC,
+	.wMaxPacketSize		= cpu_to_le16(1024),
+	.bInterval		= 1,
+};
+
+/* super speed support */
+static struct usb_endpoint_descriptor uvc_ss_control_ep __initdata = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_INT,
+	.wMaxPacketSize =	cpu_to_le16(STATUS_BYTECOUNT),
+	.bInterval =		8,
+};
+
+static struct usb_ss_ep_comp_descriptor uvc_ss_control_comp __initdata = {
+	.bLength =		sizeof uvc_ss_control_comp,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+
+	/* the following 3 values can be tweaked if necessary */
+	/* .bMaxBurst =		0, */
+	/* .bmAttributes =	0, */
+	.wBytesPerInterval =	cpu_to_le16(STATUS_BYTECOUNT),
+};
+
+static struct usb_endpoint_descriptor uvc_ss_streaming_ep __initdata = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_ISOC,
+	.wMaxPacketSize =	cpu_to_le16(1024),
+	.bInterval =		4,
+};
+
+static struct usb_ss_ep_comp_descriptor uvc_ss_streaming_comp = {
+	.bLength =		sizeof uvc_ss_streaming_comp,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+
+	/* the following 3 values can be tweaked if necessary */
+	.bMaxBurst =		0,
+	.bmAttributes =	0,
+	.wBytesPerInterval =	cpu_to_le16(1024),
+};
+
 static const struct usb_descriptor_header * const uvc_fs_streaming[] = {
 	(struct usb_descriptor_header *) &uvc_streaming_intf_alt1,
-	(struct usb_descriptor_header *) &uvc_streaming_ep,
+	(struct usb_descriptor_header *) &uvc_fs_streaming_ep,
 	NULL,
 };
 
 static const struct usb_descriptor_header * const uvc_hs_streaming[] = {
 	(struct usb_descriptor_header *) &uvc_streaming_intf_alt1,
-	(struct usb_descriptor_header *) &uvc_streaming_ep,
+	(struct usb_descriptor_header *) &uvc_hs_streaming_ep,
+	NULL,
+};
+
+static const struct usb_descriptor_header * const uvc_ss_streaming[] = {
+	(struct usb_descriptor_header *) &uvc_streaming_intf_alt1,
+	(struct usb_descriptor_header *) &uvc_ss_streaming_ep,
+	(struct usb_descriptor_header *) &uvc_ss_streaming_comp,
 	NULL,
 };
 
@@ -217,6 +293,7 @@ uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
 	struct uvc_device *uvc = to_uvc(f);
 	struct v4l2_event v4l2_event;
 	struct uvc_event *uvc_event = (void *)&v4l2_event.u.data;
+	int ret;
 
 	INFO(f->config->cdev, "uvc_function_set_alt(%u, %u)\n", interface, alt);
 
@@ -264,7 +341,10 @@ uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
 			return 0;
 
 		if (uvc->video.ep) {
-			uvc->video.ep->desc = &uvc_streaming_ep;
+			ret = config_ep_by_speed(f->config->cdev->gadget,
+					&(uvc->func), uvc->video.ep);
+			if (ret)
+				return ret;
 			usb_ep_enable(uvc->video.ep);
 		}
 
@@ -370,9 +450,11 @@ uvc_copy_descriptors(struct uvc_device *uvc, enum usb_device_speed speed)
 {
 	struct uvc_input_header_descriptor *uvc_streaming_header;
 	struct uvc_header_descriptor *uvc_control_header;
+	const struct uvc_descriptor_header * const *uvc_control_desc;
 	const struct uvc_descriptor_header * const *uvc_streaming_cls;
 	const struct usb_descriptor_header * const *uvc_streaming_std;
 	const struct usb_descriptor_header * const *src;
+	static struct usb_endpoint_descriptor *uvc_control_ep;
 	struct usb_descriptor_header **dst;
 	struct usb_descriptor_header **hdr;
 	unsigned int control_size;
@@ -381,10 +463,29 @@ uvc_copy_descriptors(struct uvc_device *uvc, enum usb_device_speed speed)
 	unsigned int bytes;
 	void *mem;
 
-	uvc_streaming_cls = (speed == USB_SPEED_FULL)
-			  ? uvc->desc.fs_streaming : uvc->desc.hs_streaming;
-	uvc_streaming_std = (speed == USB_SPEED_FULL)
-			  ? uvc_fs_streaming : uvc_hs_streaming;
+	switch (speed) {
+	case USB_SPEED_SUPER:
+		uvc_control_desc = uvc->desc.ss_control;
+		uvc_streaming_cls = uvc->desc.ss_streaming;
+		uvc_streaming_std = uvc_ss_streaming;
+		uvc_control_ep = &uvc_ss_control_ep;
+		break;
+
+	case USB_SPEED_HIGH:
+		uvc_control_desc = uvc->desc.fs_control;
+		uvc_streaming_cls = uvc->desc.hs_streaming;
+		uvc_streaming_std = uvc_hs_streaming;
+		uvc_control_ep = &uvc_fs_control_ep;
+		break;
+
+	case USB_SPEED_FULL:
+	default:
+		uvc_control_desc = uvc->desc.fs_control;
+		uvc_streaming_cls = uvc->desc.fs_streaming;
+		uvc_streaming_std = uvc_fs_streaming;
+		uvc_control_ep = &uvc_fs_control_ep;
+		break;
+	}
 
 	/* Descriptors layout
 	 *
@@ -402,16 +503,24 @@ uvc_copy_descriptors(struct uvc_device *uvc, enum usb_device_speed speed)
 	control_size = 0;
 	streaming_size = 0;
 	bytes = uvc_iad.bLength + uvc_control_intf.bLength
-	      + uvc_control_ep.bLength + uvc_control_cs_ep.bLength
+	      + uvc_control_ep->bLength + uvc_control_cs_ep.bLength
 	      + uvc_streaming_intf_alt0.bLength;
-	n_desc = 5;
 
-	for (src = (const struct usb_descriptor_header**)uvc->desc.control; *src; ++src) {
+	if (speed == USB_SPEED_SUPER) {
+		bytes += uvc_ss_control_comp.bLength;
+		n_desc = 6;
+	} else {
+		n_desc = 5;
+	}
+
+	for (src = (const struct usb_descriptor_header **)uvc_control_desc;
+			*src; ++src) {
 		control_size += (*src)->bLength;
 		bytes += (*src)->bLength;
 		n_desc++;
 	}
-	for (src = (const struct usb_descriptor_header**)uvc_streaming_cls; *src; ++src) {
+	for (src = (const struct usb_descriptor_header **)uvc_streaming_cls;
+			*src; ++src) {
 		streaming_size += (*src)->bLength;
 		bytes += (*src)->bLength;
 		n_desc++;
@@ -435,12 +544,15 @@ uvc_copy_descriptors(struct uvc_device *uvc, enum usb_device_speed speed)
 
 	uvc_control_header = mem;
 	UVC_COPY_DESCRIPTORS(mem, dst,
-		(const struct usb_descriptor_header**)uvc->desc.control);
+		(const struct usb_descriptor_header **)uvc_control_desc);
 	uvc_control_header->wTotalLength = cpu_to_le16(control_size);
 	uvc_control_header->bInCollection = 1;
 	uvc_control_header->baInterfaceNr[0] = uvc->streaming_intf;
 
-	UVC_COPY_DESCRIPTOR(mem, dst, &uvc_control_ep);
+	UVC_COPY_DESCRIPTOR(mem, dst, uvc_control_ep);
+	if (speed == USB_SPEED_SUPER)
+		UVC_COPY_DESCRIPTOR(mem, dst, &uvc_ss_control_comp);
+
 	UVC_COPY_DESCRIPTOR(mem, dst, &uvc_control_cs_ep);
 	UVC_COPY_DESCRIPTOR(mem, dst, &uvc_streaming_intf_alt0);
 
@@ -448,7 +560,8 @@ uvc_copy_descriptors(struct uvc_device *uvc, enum usb_device_speed speed)
 	UVC_COPY_DESCRIPTORS(mem, dst,
 		(const struct usb_descriptor_header**)uvc_streaming_cls);
 	uvc_streaming_header->wTotalLength = cpu_to_le16(streaming_size);
-	uvc_streaming_header->bEndpointAddress = uvc_streaming_ep.bEndpointAddress;
+	uvc_streaming_header->bEndpointAddress =
+		uvc_fs_streaming_ep.bEndpointAddress;
 
 	UVC_COPY_DESCRIPTORS(mem, dst, uvc_streaming_std);
 
@@ -484,6 +597,7 @@ uvc_function_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	kfree(f->descriptors);
 	kfree(f->hs_descriptors);
+	kfree(f->ss_descriptors);
 
 	kfree(uvc);
 }
@@ -498,8 +612,26 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 
 	INFO(cdev, "uvc_function_bind\n");
 
+	/* sanity check the streaming endpoint module parameters */
+	if (streaming_interval < 1)
+		streaming_interval = 1;
+	if (streaming_interval > 16)
+		streaming_interval = 16;
+	if (streaming_mult > 2)
+		streaming_mult = 2;
+	if (streaming_maxburst > 15)
+		streaming_maxburst = 15;
+
+	/*
+	 * fill in the FS video streaming specific descriptors from the
+	 * module parameters
+	 */
+	uvc_fs_streaming_ep.wMaxPacketSize = streaming_maxpacket > 1023 ?
+						1023 : streaming_maxpacket;
+	uvc_fs_streaming_ep.bInterval = streaming_interval;
+
 	/* Allocate endpoints. */
-	ep = usb_ep_autoconfig(cdev->gadget, &uvc_control_ep);
+	ep = usb_ep_autoconfig(cdev->gadget, &uvc_fs_control_ep);
 	if (!ep) {
 		INFO(cdev, "Unable to allocate control EP\n");
 		goto error;
@@ -507,7 +639,7 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 	uvc->control_ep = ep;
 	ep->driver_data = uvc;
 
-	ep = usb_ep_autoconfig(cdev->gadget, &uvc_streaming_ep);
+	ep = usb_ep_autoconfig(cdev->gadget, &uvc_fs_streaming_ep);
 	if (!ep) {
 		INFO(cdev, "Unable to allocate streaming EP\n");
 		goto error;
@@ -528,9 +660,52 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 	uvc_streaming_intf_alt1.bInterfaceNumber = ret;
 	uvc->streaming_intf = ret;
 
-	/* Copy descriptors. */
+	/* sanity check the streaming endpoint module parameters */
+	if (streaming_maxpacket > 1024)
+		streaming_maxpacket = 1024;
+
+	/* Copy descriptors for FS. */
 	f->descriptors = uvc_copy_descriptors(uvc, USB_SPEED_FULL);
-	f->hs_descriptors = uvc_copy_descriptors(uvc, USB_SPEED_HIGH);
+
+	/* support high speed hardware */
+	if (gadget_is_dualspeed(cdev->gadget)) {
+		/*
+		 * Fill in the HS descriptors from the module parameters for the
+		 * Video Streaming endpoint.
+		 * NOTE: We assume that the user knows what they are doing and
+		 * won't give parameters that their UDC doesn't support.
+		 */
+		uvc_hs_streaming_ep.wMaxPacketSize = streaming_maxpacket;
+		uvc_hs_streaming_ep.wMaxPacketSize |= streaming_mult << 11;
+		uvc_hs_streaming_ep.bInterval = streaming_interval;
+		uvc_hs_streaming_ep.bEndpointAddress =
+				uvc_fs_streaming_ep.bEndpointAddress;
+
+		/* Copy descriptors. */
+		f->hs_descriptors = uvc_copy_descriptors(uvc, USB_SPEED_HIGH);
+	}
+
+	/* support super speed hardware */
+	if (gadget_is_superspeed(c->cdev->gadget)) {
+		/*
+		 * Fill in the SS descriptors from the module parameters for the
+		 * Video Streaming endpoint.
+		 * NOTE: We assume that the user knows what they are doing and
+		 * won't give parameters that their UDC doesn't support.
+		 */
+		uvc_ss_streaming_ep.wMaxPacketSize = streaming_maxpacket;
+		uvc_ss_streaming_ep.bInterval = streaming_interval;
+		uvc_ss_streaming_comp.bmAttributes = streaming_mult;
+		uvc_ss_streaming_comp.bMaxBurst = streaming_maxburst;
+		uvc_ss_streaming_comp.wBytesPerInterval =
+			streaming_maxpacket * (streaming_mult + 1) *
+			(streaming_maxburst + 1);
+		uvc_ss_streaming_ep.bEndpointAddress =
+				uvc_fs_streaming_ep.bEndpointAddress;
+
+		/* Copy descriptors. */
+		f->ss_descriptors = uvc_copy_descriptors(uvc, USB_SPEED_SUPER);
+	}
 
 	/* Preallocate control endpoint request. */
 	uvc->control_req = usb_ep_alloc_request(cdev->gadget->ep0, GFP_KERNEL);
@@ -585,9 +760,11 @@ error:
  */
 int __init
 uvc_bind_config(struct usb_configuration *c,
-		const struct uvc_descriptor_header * const *control,
+		const struct uvc_descriptor_header * const *fs_control,
+		const struct uvc_descriptor_header * const *ss_control,
 		const struct uvc_descriptor_header * const *fs_streaming,
-		const struct uvc_descriptor_header * const *hs_streaming)
+		const struct uvc_descriptor_header * const *hs_streaming,
+		const struct uvc_descriptor_header * const *ss_streaming)
 {
 	struct uvc_device *uvc;
 	int ret = 0;
@@ -605,21 +782,31 @@ uvc_bind_config(struct usb_configuration *c,
 	uvc->state = UVC_STATE_DISCONNECTED;
 
 	/* Validate the descriptors. */
-	if (control == NULL || control[0] == NULL ||
-	    control[0]->bDescriptorSubType != UVC_VC_HEADER)
+	if (fs_control == NULL || fs_control[0] == NULL ||
+		fs_control[0]->bDescriptorSubType != UVC_VC_HEADER)
+		goto error;
+
+	if (ss_control == NULL || ss_control[0] == NULL ||
+		ss_control[0]->bDescriptorSubType != UVC_VC_HEADER)
 		goto error;
 
 	if (fs_streaming == NULL || fs_streaming[0] == NULL ||
-	    fs_streaming[0]->bDescriptorSubType != UVC_VS_INPUT_HEADER)
+		fs_streaming[0]->bDescriptorSubType != UVC_VS_INPUT_HEADER)
 		goto error;
 
 	if (hs_streaming == NULL || hs_streaming[0] == NULL ||
-	    hs_streaming[0]->bDescriptorSubType != UVC_VS_INPUT_HEADER)
+		hs_streaming[0]->bDescriptorSubType != UVC_VS_INPUT_HEADER)
+		goto error;
+
+	if (ss_streaming == NULL || ss_streaming[0] == NULL ||
+		ss_streaming[0]->bDescriptorSubType != UVC_VS_INPUT_HEADER)
 		goto error;
 
-	uvc->desc.control = control;
+	uvc->desc.fs_control = fs_control;
+	uvc->desc.ss_control = ss_control;
 	uvc->desc.fs_streaming = fs_streaming;
 	uvc->desc.hs_streaming = hs_streaming;
+	uvc->desc.ss_streaming = ss_streaming;
 
 	/* maybe allocate device-global string IDs, and patch descriptors */
 	if (uvc_en_us_strings[UVC_STRING_ASSOCIATION_IDX].id == 0) {
diff --git a/drivers/usb/gadget/f_uvc.h b/drivers/usb/gadget/f_uvc.h
index abf8329..c3d258d 100644
--- a/drivers/usb/gadget/f_uvc.h
+++ b/drivers/usb/gadget/f_uvc.h
@@ -17,9 +17,11 @@
 #include <linux/usb/video.h>
 
 extern int uvc_bind_config(struct usb_configuration *c,
-			   const struct uvc_descriptor_header * const *control,
-			   const struct uvc_descriptor_header * const *fs_streaming,
-			   const struct uvc_descriptor_header * const *hs_streaming);
+		   const struct uvc_descriptor_header * const *fs_control,
+		   const struct uvc_descriptor_header * const *hs_control,
+		   const struct uvc_descriptor_header * const *fs_streaming,
+		   const struct uvc_descriptor_header * const *hs_streaming,
+		   const struct uvc_descriptor_header * const *ss_streaming);
 
 #endif /* _F_UVC_H_ */
 
diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
index bc78c60..d78ea25 100644
--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -153,9 +153,11 @@ struct uvc_device
 
 	/* Descriptors */
 	struct {
-		const struct uvc_descriptor_header * const *control;
+		const struct uvc_descriptor_header * const *fs_control;
+		const struct uvc_descriptor_header * const *ss_control;
 		const struct uvc_descriptor_header * const *fs_streaming;
 		const struct uvc_descriptor_header * const *hs_streaming;
+		const struct uvc_descriptor_header * const *ss_streaming;
 	} desc;
 
 	unsigned int control_intf;
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index 668fe12..120e134 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -272,7 +272,15 @@ static const struct uvc_color_matching_descriptor uvc_color_matching = {
 	.bMatrixCoefficients	= 4,
 };
 
-static const struct uvc_descriptor_header * const uvc_control_cls[] = {
+static const struct uvc_descriptor_header * const uvc_fs_control_cls[] = {
+	(const struct uvc_descriptor_header *) &uvc_control_header,
+	(const struct uvc_descriptor_header *) &uvc_camera_terminal,
+	(const struct uvc_descriptor_header *) &uvc_processing,
+	(const struct uvc_descriptor_header *) &uvc_output_terminal,
+	NULL,
+};
+
+static const struct uvc_descriptor_header * const uvc_ss_control_cls[] = {
 	(const struct uvc_descriptor_header *) &uvc_control_header,
 	(const struct uvc_descriptor_header *) &uvc_camera_terminal,
 	(const struct uvc_descriptor_header *) &uvc_processing,
@@ -304,6 +312,18 @@ static const struct uvc_descriptor_header * const uvc_hs_streaming_cls[] = {
 	NULL,
 };
 
+static const struct uvc_descriptor_header * const uvc_ss_streaming_cls[] = {
+	(const struct uvc_descriptor_header *) &uvc_input_header,
+	(const struct uvc_descriptor_header *) &uvc_format_yuv,
+	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
+	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
+	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
+	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
+	NULL,
+};
+
 /* --------------------------------------------------------------------------
  * USB configuration
  */
@@ -311,8 +331,9 @@ static const struct uvc_descriptor_header * const uvc_hs_streaming_cls[] = {
 static int __init
 webcam_config_bind(struct usb_configuration *c)
 {
-	return uvc_bind_config(c, uvc_control_cls, uvc_fs_streaming_cls,
-			       uvc_hs_streaming_cls);
+	return uvc_bind_config(c, uvc_fs_control_cls, uvc_ss_control_cls,
+		uvc_fs_streaming_cls, uvc_hs_streaming_cls,
+		uvc_ss_streaming_cls);
 }
 
 static struct usb_configuration webcam_config_driver = {
@@ -373,7 +394,7 @@ static struct usb_composite_driver webcam_driver = {
 	.name		= "g_webcam",
 	.dev		= &webcam_device_descriptor,
 	.strings	= webcam_device_strings,
-	.max_speed	= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_SUPER,
 	.unbind		= webcam_unbind,
 };
 
-- 
1.7.2.2

