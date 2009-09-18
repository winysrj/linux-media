Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:45552 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbZIRK1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 06:27:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH 1/3] USB gadget: audio class function driver
Date: Fri, 18 Sep 2009 12:26:49 +0200
Cc: linux-media@vger.kernel.org, Bryan Wu <cooloney@kernel.org>,
	Mike Frysinger <vapier@gentoo.org>
References: <200909181225.57212.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200909181225.57212.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909181226.50056.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This USB audio class function driver exposes an ALSA interface to userspace
to stream audio data from an application over USB.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/f_uac.c     |  654 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/uac.h       |   99 ++++++
 drivers/usb/gadget/uac_alsa.c  |  348 +++++++++++++++++++++
 drivers/usb/gadget/uac_audio.c |  238 +++++++++++++++
 4 files changed, 1339 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/gadget/f_uac.c
 create mode 100644 drivers/usb/gadget/uac.h
 create mode 100644 drivers/usb/gadget/uac_alsa.c
 create mode 100644 drivers/usb/gadget/uac_audio.c

diff --git a/drivers/usb/gadget/f_uac.c b/drivers/usb/gadget/f_uac.c
new file mode 100644
index 0000000..aaacff1
--- /dev/null
+++ b/drivers/usb/gadget/f_uac.c
@@ -0,0 +1,654 @@
+/*
+ *	f_uac.c -- USB Audio class function driver
+ *
+ *	Copyright (C) 2009
+ *         Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	Based on f_audio.c
+ *	Copyright (C) 2008 Bryan Wu <cooloney@kernel.org>
+ *	Copyright (C) 2008 Analog Devices, Inc
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <asm/atomic.h>
+
+#include "uac.h"
+
+/* I'd like 68 bytes packets, but for some reason the MUSB controller refuses
+ * to transfer 68 bytes isochronous packets. 64 bytes and 70 bytes work though.
+ * Go figure.
+ */
+#define IN_EP_MAX_PACKET_SIZE	70
+
+static int req_buf_size = IN_EP_MAX_PACKET_SIZE;
+module_param(req_buf_size, int, S_IRUGO);
+MODULE_PARM_DESC(req_buf_size, "ISO IN endpoint request buffer size");
+
+static int req_count = 256;
+module_param(req_count, int, S_IRUGO);
+MODULE_PARM_DESC(req_count, "ISO IN endpoint request count");
+
+static int audio_buf_size = 48000;
+module_param(audio_buf_size, int, S_IRUGO);
+MODULE_PARM_DESC(audio_buf_size, "Audio buffer size");
+
+static int generic_set_cmd(struct usb_audio_control *con, u8 cmd, int value);
+static int generic_get_cmd(struct usb_audio_control *con, u8 cmd);
+
+/* --------------------------------------------------------------------------
+ * Function descriptors
+ */
+
+#define INPUT_TERMINAL_ID	1
+#define FEATURE_UNIT_ID		2
+#define OUTPUT_TERMINAL_ID	3
+
+static struct usb_interface_assoc_descriptor uac_iad __initdata = {
+	.bLength		= USB_DT_INTERFACE_ASSOCIATION_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE_ASSOCIATION,
+	.bFirstInterface	= 0,
+	.bInterfaceCount	= 2,
+	.bFunctionClass		= USB_CLASS_AUDIO,
+	.bFunctionSubClass	= USB_SUBCLASS_AUDIOSTREAMING,	/* FIXME Where is this documented ? */
+	.bFunctionProtocol	= 0x00,
+	.iFunction		= 0,
+};
+
+/* B.3.1  Standard AC Interface Descriptor */
+static struct usb_interface_descriptor ac_interface_desc __initdata = {
+	.bLength		= USB_DT_INTERFACE_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE,
+	.bInterfaceNumber	= 0, /* dynamic */
+	.bAlternateSetting	= 0,
+	.bNumEndpoints		= 0,
+	.bInterfaceClass	= USB_CLASS_AUDIO,
+	.bInterfaceSubClass	= USB_SUBCLASS_AUDIOCONTROL,
+};
+
+DECLARE_UAC_AC_HEADER_DESCRIPTOR(2);
+
+/* B.3.2  Class-Specific AC Interface Descriptor */
+static struct uac_ac_header_descriptor_2 ac_header_desc = {
+	.bLength		= UAC_DT_AC_HEADER_SIZE(1),
+	.bDescriptorType	= USB_DT_CS_INTERFACE,
+	.bDescriptorSubtype	= UAC_HEADER,
+	.bcdADC			= cpu_to_le16(0x0100),
+	.wTotalLength		= cpu_to_le16(UAC_DT_AC_HEADER_SIZE(1) +
+					      UAC_DT_INPUT_TERMINAL_SIZE +
+					      UAC_DT_FEATURE_UNIT_SIZE(0)),
+	.bInCollection		= 1,
+	.baInterfaceNr[0]	= 0, /* dynamic */
+};
+
+static struct uac_input_terminal_descriptor input_terminal_desc = {
+	.bLength		= UAC_DT_INPUT_TERMINAL_SIZE,
+	.bDescriptorType	= USB_DT_CS_INTERFACE,
+	.bDescriptorSubtype	= UAC_INPUT_TERMINAL,
+	.bTerminalID		= INPUT_TERMINAL_ID,
+	.wTerminalType		= UAC_INPUT_TERMINAL_MICROPHONE,
+	.bAssocTerminal		= 0,
+	.bNrChannels		= 1, /* TODO make this dynamic */
+	.wChannelConfig		= 0, /* dynamic */
+	.iChannelNames		= 0,
+	.iTerminal		= 0,
+};
+
+DECLARE_UAC_FEATURE_UNIT_DESCRIPTOR(0);
+
+static struct uac_feature_unit_descriptor_0 feature_unit_desc = {
+	.bLength		= UAC_DT_FEATURE_UNIT_SIZE(0),
+	.bDescriptorType	= USB_DT_CS_INTERFACE,
+	.bDescriptorSubtype	= UAC_FEATURE_UNIT,
+	.bUnitID		= FEATURE_UNIT_ID,
+	.bSourceID		= INPUT_TERMINAL_ID,
+	.bControlSize		= 2,
+	.bmaControls[0]		= (UAC_FU_MUTE | UAC_FU_VOLUME),
+	.iFeature		= 0,
+};
+
+static struct uac_output_terminal_descriptor output_terminal_desc = {
+	.bLength		= UAC_DT_OUTPUT_TERMINAL_SIZE,
+	.bDescriptorType	= USB_DT_CS_INTERFACE,
+	.bDescriptorSubtype	= UAC_OUTPUT_TERMINAL,
+	.bTerminalID		= OUTPUT_TERMINAL_ID,
+	.wTerminalType		= UAC_TERMINAL_STREAMING,
+	.bAssocTerminal		= 0,
+	.bSourceID		= FEATURE_UNIT_ID,
+	.iTerminal		= 0,
+};
+
+/* B.4.1  Standard AS Interface Descriptor */
+static struct usb_interface_descriptor as_interface_alt_0_desc = {
+	.bLength		= USB_DT_INTERFACE_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE,
+	.bInterfaceNumber	= 0, /* dynamic */
+	.bAlternateSetting	= 0,
+	.bNumEndpoints		= 0,
+	.bInterfaceClass	= USB_CLASS_AUDIO,
+	.bInterfaceSubClass	= USB_SUBCLASS_AUDIOSTREAMING,
+};
+
+static struct usb_interface_descriptor as_interface_alt_1_desc = {
+	.bLength		= USB_DT_INTERFACE_SIZE,
+	.bDescriptorType	= USB_DT_INTERFACE,
+	.bInterfaceNumber	= 0, /* dynamic */
+	.bAlternateSetting	= 1,
+	.bNumEndpoints		= 1,
+	.bInterfaceClass	= USB_CLASS_AUDIO,
+	.bInterfaceSubClass	= USB_SUBCLASS_AUDIOSTREAMING,
+};
+
+/* B.4.2  Class-Specific AS Interface Descriptor */
+static struct uac_as_header_descriptor as_header_desc = {
+	.bLength		= UAC_DT_AS_HEADER_SIZE,
+	.bDescriptorType	= USB_DT_CS_INTERFACE,
+	.bDescriptorSubtype	= UAC_AS_GENERAL,
+	.bTerminalLink		= INPUT_TERMINAL_ID,
+	.bDelay			= 1,
+	.wFormatTag		= UAC_FORMAT_TYPE_I_PCM,
+};
+
+DECLARE_UAC_FORMAT_TYPE_I_DISCRETE_DESC(1);
+
+static struct uac_format_type_i_discrete_descriptor_1 as_type_i_desc = {
+	.bLength		= UAC_FORMAT_TYPE_I_DISCRETE_DESC_SIZE(1),
+	.bDescriptorType	= USB_DT_CS_INTERFACE,
+	.bDescriptorSubtype	= UAC_FORMAT_TYPE,
+	.bFormatType		= UAC_FORMAT_TYPE_I,
+	.bNrChannels		= 1, /* TODO make this dynamic */
+	.bSubframeSize		= 2,
+	.bBitResolution		= 16,
+	.bSamFreqType		= 1,
+	.tSamFreq[0]		= { 0x00, 0x00, 0x00 }, /* dynamic */
+};
+
+/* Standard ISO IN Endpoint Descriptor */
+static struct usb_endpoint_descriptor as_in_ep_desc = {
+	.bLength		= USB_DT_ENDPOINT_AUDIO_SIZE,
+	.bDescriptorType	= USB_DT_ENDPOINT,
+	.bEndpointAddress	= USB_DIR_IN,
+	.bmAttributes		= USB_ENDPOINT_SYNC_SYNC
+				| USB_ENDPOINT_XFER_ISOC,
+	.wMaxPacketSize		= cpu_to_le16(IN_EP_MAX_PACKET_SIZE),
+	.bInterval		= 4,
+};
+
+/* Class-specific AS ISO IN Endpoint Descriptor */
+static struct uac_iso_endpoint_descriptor as_iso_in_desc __initdata = {
+	.bLength		= UAC_ISO_ENDPOINT_DESC_SIZE,
+	.bDescriptorType	= USB_DT_CS_ENDPOINT,
+	.bDescriptorSubtype	= UAC_EP_GENERAL,
+	.bmAttributes		= 1,
+	.bLockDelayUnits	= 1,
+	.wLockDelay		= cpu_to_le16(1),
+};
+
+static struct usb_descriptor_header *f_audio_desc[] __initdata = {
+	(struct usb_descriptor_header *)&uac_iad,
+
+	(struct usb_descriptor_header *)&ac_interface_desc,
+	(struct usb_descriptor_header *)&ac_header_desc,
+
+	(struct usb_descriptor_header *)&input_terminal_desc,
+	(struct usb_descriptor_header *)&output_terminal_desc,
+	(struct usb_descriptor_header *)&feature_unit_desc,
+
+	(struct usb_descriptor_header *)&as_interface_alt_0_desc,
+	(struct usb_descriptor_header *)&as_interface_alt_1_desc,
+	(struct usb_descriptor_header *)&as_header_desc,
+
+	(struct usb_descriptor_header *)&as_type_i_desc,
+
+	(struct usb_descriptor_header *)&as_in_ep_desc,
+	(struct usb_descriptor_header *)&as_iso_in_desc,
+	NULL,
+};
+
+/* --------------------------------------------------------------------------
+ * Control requests
+ */
+
+static inline struct uac_device *func_to_audio(struct usb_function *f)
+{
+	return container_of(f, struct uac_device, func);
+}
+
+static struct usb_audio_control mute_control = {
+	.list = LIST_HEAD_INIT(mute_control.list),
+	.name = "Mute Control",
+	.type = UAC_MUTE_CONTROL,
+	/* Todo: add real Mute control code */
+	.set = generic_set_cmd,
+	.get = generic_get_cmd,
+};
+
+static struct usb_audio_control volume_control = {
+	.list = LIST_HEAD_INIT(volume_control.list),
+	.name = "Volume Control",
+	.type = UAC_VOLUME_CONTROL,
+	/* Todo: add real Volume control code */
+	.set = generic_set_cmd,
+	.get = generic_get_cmd,
+};
+
+static struct usb_audio_unit feature_unit = {
+	.list = LIST_HEAD_INIT(feature_unit.list),
+	.id = FEATURE_UNIT_ID,
+	.name = "Mute & Volume Control",
+	.type = UAC_FEATURE_UNIT,
+	.desc = (struct usb_descriptor_header *)&feature_unit_desc,
+};
+
+static void
+uac_function_ep0_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct uac_device *uac = req->context;
+	struct usb_composite_dev *cdev = uac->func.config->cdev;
+	int value = le16_to_cpup((__le16 *)req->buf);
+
+	if (req->status != 0 || uac->set_con == NULL)
+		return;
+
+	DBG(cdev, "setting control %s to %d\n", uac->set_con->name, value);
+
+	uac->set_con->set(uac->set_con, uac->set_cmd, value);
+	uac->set_con = NULL;
+}
+
+static int
+uac_function_set_endpoint_req(struct uac_device *uac,
+		const struct usb_ctrlrequest *ctrl)
+{
+	struct usb_composite_dev *cdev = uac->func.config->cdev;
+	u8 ep = le16_to_cpu(ctrl->wIndex) & 0xff;
+	u8 cs = le16_to_cpu(ctrl->wValue) >> 8;
+	int value = -EOPNOTSUPP;
+
+	if (cs != UAC_EP_CS_ATTR_SAMPLE_RATE ||
+	    ep != as_in_ep_desc.bEndpointAddress)
+		return -EOPNOTSUPP;
+
+	switch (ctrl->bRequest) {
+	case UAC_SET_CUR:
+		DBG(cdev, "setting sampling frequency\n");
+		value = 3;
+		break;
+
+	case UAC_SET_MIN:
+	case UAC_SET_MAX:
+	case UAC_SET_RES:
+	case UAC_SET_MEM:
+	default:
+		break;
+	}
+
+	return value;
+}
+
+static int
+uac_function_get_endpoint_req(struct uac_device *uac,
+		const struct usb_ctrlrequest *ctrl)
+{
+	struct usb_composite_dev *cdev = uac->func.config->cdev;
+	u8 ep = le16_to_cpu(ctrl->wIndex) & 0xff;
+	u8 cs = le16_to_cpu(ctrl->wValue) >> 8;
+	int value = -EOPNOTSUPP;
+
+	if (cs != UAC_EP_CS_ATTR_SAMPLE_RATE ||
+	    ep != as_in_ep_desc.bEndpointAddress)
+		return -EOPNOTSUPP;
+
+	switch (ctrl->bRequest) {
+	case UAC_GET_CUR:
+	case UAC_GET_MIN:
+	case UAC_GET_MAX:
+	case UAC_GET_RES:
+		DBG(cdev, "getting sampling frequency\n");
+		memcpy(uac->control_buf, as_type_i_desc.tSamFreq[0], 3);
+		value = 3;
+		break;
+
+	case UAC_GET_MEM:
+	default:
+		break;
+	}
+
+	return value;
+}
+
+static struct usb_audio_control *
+uac_function_find_control(struct uac_device *uac, int unit, int cs)
+{
+	struct usb_audio_unit *entity;
+	struct usb_audio_control *ctrl;
+
+	list_for_each_entry(entity, &uac->units, list) {
+		if (entity->id != unit)
+			continue;
+
+		list_for_each_entry(ctrl, &entity->control, list) {
+			if (ctrl->type == cs)
+				return ctrl;
+		}
+	}
+
+	return NULL;
+}
+
+static int
+uac_function_set_intf_req(struct uac_device *uac,
+		const struct usb_ctrlrequest *creq)
+{
+	struct usb_composite_dev *cdev = uac->func.config->cdev;
+	u16 len = le16_to_cpu(creq->wLength);
+	u8 unit = le16_to_cpu(creq->wIndex) >> 8;
+	u8 cs = le16_to_cpu(creq->wValue) >> 8;
+	struct usb_audio_control *ctrl;
+
+	ctrl = uac_function_find_control(uac, unit, cs);
+	if (ctrl == NULL)
+		return -EOPNOTSUPP;
+
+	uac->set_con = ctrl;
+	uac->set_cmd = creq->bRequest & 0x0f;
+
+	DBG(cdev, "setting control %s value\n", ctrl->name);
+	return le16_to_cpu(len);
+}
+
+static int
+uac_function_get_intf_req(struct uac_device *uac,
+		const struct usb_ctrlrequest *creq)
+{
+	struct usb_composite_dev *cdev = uac->func.config->cdev;
+	u16 len = le16_to_cpu(creq->wLength);
+	u8 unit = le16_to_cpu(creq->wIndex) >> 8;
+	u8 cs = le16_to_cpu(creq->wValue) >> 8;
+	struct usb_audio_control *ctrl;
+	int value;
+
+	ctrl = uac_function_find_control(uac, unit, cs);
+	if (ctrl == NULL)
+		return -EOPNOTSUPP;
+
+	value = ctrl->get(ctrl, creq->bRequest & 0x0f);
+	memcpy(uac->control_buf, &value, len);
+
+	DBG(cdev, "getting control %s value (%d)\n", ctrl->name, value);
+	return len;
+}
+
+static int
+uac_function_setup(struct usb_function *f, const struct usb_ctrlrequest *ctrl)
+{
+	struct uac_device *uac = func_to_audio(f);
+	struct usb_composite_dev *cdev = f->config->cdev;
+	struct usb_request *req = uac->control_req;
+	int value = -EOPNOTSUPP;
+	u16 wIndex = le16_to_cpu(ctrl->wIndex);
+	u16 wValue = le16_to_cpu(ctrl->wValue);
+	u16 wLength = le16_to_cpu(ctrl->wLength);
+
+	/* Composite driver infrastructure handles everything; interface
+	 * activation uses set_alt().
+	 */
+	switch (ctrl->bRequestType) {
+	case USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE:
+		value = uac_function_set_intf_req(uac, ctrl);
+		break;
+
+	case USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE:
+		value = uac_function_get_intf_req(uac, ctrl);
+		break;
+
+	case USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_ENDPOINT:
+		value = uac_function_set_endpoint_req(uac, ctrl);
+		break;
+
+	case USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_ENDPOINT:
+		value = uac_function_get_endpoint_req(uac, ctrl);
+		break;
+
+	default:
+		ERROR(cdev, "invalid setup request %02x %02x value %04x index "
+			"%04x %04x\n", ctrl->bRequestType, ctrl->bRequest,
+			wValue, wIndex, wLength);
+		break;
+	}
+
+	if (value >= 0) {
+		req->zero = 0;
+		req->length = value;
+		value = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
+	}
+
+	return value;
+}
+
+static int
+uac_function_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
+{
+	struct uac_device *uac = func_to_audio(f);
+
+	DBG(f->config->cdev, "intf %d, alt %d\n", intf, alt);
+
+	if (intf == uac->control_intf) {
+		if (alt)
+			return -EINVAL;
+
+		/* TODO Notify userspace that the device has been connected. */
+		return 0;
+	}
+
+	if (intf != uac->streaming_intf)
+		return -EINVAL;
+
+	switch (alt) {
+	case 0:
+		uac_audio_enable(uac, 0);
+		usb_ep_disable(uac->audio_ep);
+
+		/* TODO Notify userspace that the audio stream should be stopped. */
+		break;
+
+	case 1:
+		usb_ep_enable(uac->audio_ep, &as_in_ep_desc);
+		uac_audio_enable(uac, 1);
+
+		/* TODO Notify userspace that the audio stream should be started. */
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
+uac_function_disable(struct usb_function *f)
+{
+	// struct uac_device *uac = func_to_audio(f);
+
+	DBG(f->config->cdev, "uac_function_disable\n");
+
+	/* TODO Notify userspace that the device has been disconnected. */
+	return;
+}
+
+/* --------------------------------------------------------------------------
+ * USB probe and disconnect
+ */
+
+static int generic_set_cmd(struct usb_audio_control *con, u8 cmd, int value)
+{
+	con->data[cmd] = value;
+
+	return 0;
+}
+
+static int generic_get_cmd(struct usb_audio_control *con, u8 cmd)
+{
+	return con->data[cmd];
+}
+
+/* Todo: add more control selectors dynamically */
+static int __init
+control_selector_init(struct uac_device *uac)
+{
+	INIT_LIST_HEAD(&uac->units);
+	list_add(&feature_unit.list, &uac->units);
+
+	INIT_LIST_HEAD(&feature_unit.control);
+	list_add(&mute_control.list, &feature_unit.control);
+	list_add(&volume_control.list, &feature_unit.control);
+
+	volume_control.data[UAC_SET_CUR] = 0xffc0;
+	volume_control.data[UAC_SET_MIN] = 0xe3a0;
+	volume_control.data[UAC_SET_MAX] = 0xfff0;
+	volume_control.data[UAC_SET_RES] = 0x0030;
+
+	return 0;
+}
+
+static void
+uac_function_unbind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct usb_composite_dev *cdev = f->config->cdev;
+	struct uac_device *uac = func_to_audio(f);
+
+	uac_audio_cleanup(uac);
+
+	if (uac->audio_ep)
+		uac->audio_ep->driver_data = NULL;
+
+	if (uac->control_req) {
+		usb_ep_free_request(cdev->gadget->ep0, uac->control_req);
+		kfree(uac->control_buf);
+	}
+
+	usb_free_descriptors(f->descriptors);
+	usb_free_descriptors(f->hs_descriptors);
+
+	kfree(uac);
+}
+
+/* audio function driver setup/binding */
+static int __init
+uac_function_bind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct usb_composite_dev *cdev = c->cdev;
+	struct uac_device	*uac = func_to_audio(f);
+	int			ret;
+	struct usb_ep		*ep;
+
+	/* Allocate endpoints. */
+	ep = usb_ep_autoconfig(cdev->gadget, &as_in_ep_desc);
+	if (!ep) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	uac->audio_ep = ep;
+	ep->driver_data = uac;
+
+	/* Allocate interface IDs. */
+	if ((ret = usb_interface_id(c, f)) < 0)
+		goto error;
+	ac_interface_desc.bInterfaceNumber = ret;
+	uac->control_intf = ret;
+	uac_iad.bFirstInterface = ret;
+
+	if ((ret = usb_interface_id(c, f)) < 0)
+		goto error;
+	as_interface_alt_0_desc.bInterfaceNumber = ret;
+	as_interface_alt_1_desc.bInterfaceNumber = ret;
+	ac_header_desc.baInterfaceNr[0] = ret;
+	uac->streaming_intf = ret;
+
+	/* Copy descriptors. Support all relevant hardware speeds. We expect
+	 * that when hardware is dual speed, all isochronous-capable endpoints
+	 * work at both speeds.
+	 */
+	as_type_i_desc.tSamFreq[0][0] = (uac->rate >> 0) & 0xff;
+	as_type_i_desc.tSamFreq[0][1] = (uac->rate >> 8) & 0xff;
+	as_type_i_desc.tSamFreq[0][2] = (uac->rate >> 16) & 0xff;
+
+	f->descriptors = usb_copy_descriptors(f_audio_desc);
+	if (gadget_is_dualspeed(c->cdev->gadget))
+		f->hs_descriptors = usb_copy_descriptors(f_audio_desc);
+
+	/* Preallocate control endpoint request. */
+	uac->control_req = usb_ep_alloc_request(cdev->gadget->ep0, GFP_KERNEL);
+	uac->control_buf = kmalloc(UAC_MAX_REQUEST_SIZE, GFP_KERNEL);
+	if (uac->control_req == NULL || uac->control_buf == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	uac->control_req->buf = uac->control_buf;
+	uac->control_req->complete = uac_function_ep0_complete;
+	uac->control_req->context = uac;
+
+	/* Set up ALSA audio devices. */
+	ret = uac_audio_init(uac);
+	if (ret < 0)
+		return ret;
+
+	control_selector_init(uac);
+
+	return 0;
+
+error:
+	uac_function_unbind(c, f);
+	return ret;
+}
+
+/*-------------------------------------------------------------------------*/
+
+/**
+ * audio_bind_config - add USB audio fucntion to a configuration
+ * @c: the configuration to supcard the USB audio function
+ * Context: single threaded during gadget setup
+ *
+ * Returns zero on success, else negative errno.
+ */
+int __init
+audio_bind_config(struct usb_configuration *c, unsigned int rate)
+{
+	struct uac_device *uac;
+	int ret;
+
+	/* Allocate and initialize one new instance. */
+	uac = kzalloc(sizeof *uac, GFP_KERNEL);
+	if (uac == NULL)
+		return -ENOMEM;
+
+	uac->rate = rate;
+	uac->func.name = "g_audio";
+
+	/* Register the function. */
+	uac->func.strings = NULL;
+	uac->func.bind = uac_function_bind;
+	uac->func.unbind = uac_function_unbind;
+	uac->func.set_alt = uac_function_set_alt;
+	uac->func.setup = uac_function_setup;
+	uac->func.disable = uac_function_disable;
+
+	ret = usb_add_function(c, &uac->func);
+	if (ret) {
+		kfree(uac);
+		return ret;
+	}
+
+	INFO(c->cdev, "audio_buf_size %d, req_buf_size %d, req_count %d\n",
+		audio_buf_size, req_buf_size, req_count);
+
+	return 0;
+}
diff --git a/drivers/usb/gadget/uac.h b/drivers/usb/gadget/uac.h
new file mode 100644
index 0000000..fabb309
--- /dev/null
+++ b/drivers/usb/gadget/uac.h
@@ -0,0 +1,99 @@
+/*
+ *	uac.h -- USB audio class function driver
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+
+#ifndef __UAC_H
+#define __UAC_H
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/usb/audio.h>
+#include <linux/usb/composite.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+
+#include "gadget_chips.h"
+
+#define UAC_NUM_REQUESTS		16
+#define UAC_MAX_REQUEST_SIZE		64
+
+struct usb_audio_unit {
+	struct list_head list;
+	struct list_head control;
+	u8 id;
+	const char *name;
+	u8 type;
+	struct usb_descriptor_header *desc;
+};
+
+/*
+ * This represents the USB side of an audio card device, managed by a USB
+ * function which provides control and stream interfaces.
+ */
+
+struct uac_device;
+
+struct snd_uac_substream {
+	struct uac_device		*uac;
+	struct snd_pcm_substream	*substream;
+	spinlock_t			lock;
+	unsigned int			streaming;
+
+	unsigned int			frame_bytes;
+	unsigned int			buffer_bytes;
+	unsigned int			buffer_pos;
+	unsigned int			period_bytes;
+	unsigned int			period_pos;
+};
+
+struct snd_uac_device {
+	struct snd_card			*card;
+	struct snd_pcm			*pcm;
+	struct snd_uac_substream	substreams[2];
+};
+
+struct uac_device {
+	struct usb_function		func;
+
+	struct snd_uac_device		sound;
+	unsigned int			rate;
+
+	/* endpoints handle full and/or high speeds */
+	struct usb_ep			*audio_ep;
+
+	/* Control Set command */
+	struct list_head		units;
+	u8				set_cmd;
+	struct usb_audio_control	*set_con;
+
+	unsigned int			control_intf;
+	struct usb_request		*control_req;
+	void				*control_buf;
+
+	unsigned int			streaming_intf;
+
+	/* Audio streaming requests */
+	unsigned int			req_size;
+	struct usb_request		*req[UAC_NUM_REQUESTS];
+	__u8				*req_buffer[UAC_NUM_REQUESTS];
+	struct list_head		req_free;
+	spinlock_t			req_lock;
+};
+
+extern int audio_bind_config(struct usb_configuration *c, unsigned int rate);
+
+extern int uac_audio_enable(struct uac_device *audio, int enable);
+extern int uac_audio_init(struct uac_device *audio);
+extern void uac_audio_cleanup(struct uac_device *audio);
+
+#endif /* __UAC_H */
diff --git a/drivers/usb/gadget/uac_alsa.c b/drivers/usb/gadget/uac_alsa.c
new file mode 100644
index 0000000..8161deb
--- /dev/null
+++ b/drivers/usb/gadget/uac_alsa.c
@@ -0,0 +1,348 @@
+/*
+ *	uac_alsa.c -- USB audio class function driver, ALSA interface
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+
+#include <sound/core.h>
+#include <sound/initval.h>
+#include <sound/pcm.h>
+
+#include "uac.h"
+
+/*
+ * This component encapsulates the ALSA devices for USB audio gadget
+ */
+
+static int uac_capture = 1;
+static int uac_playback = 1;
+
+module_param(uac_capture, int, 0444);
+MODULE_PARM_DESC(uac_capture, "Support audio capture.");
+module_param(uac_playback, int, 0444);
+MODULE_PARM_DESC(uac_playback, "Support audio playback.");
+
+/* -------------------------------------------------------------------------
+ * Utility functions
+ */
+
+static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
+					     unsigned long offset)
+{
+	void *pageptr = subs->runtime->dma_area + offset;
+	return vmalloc_to_page(pageptr);
+}
+
+static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs, size_t size)
+{
+	struct snd_pcm_runtime *runtime = subs->runtime;
+	if (runtime->dma_area) {
+		if (runtime->dma_bytes >= size)
+			return 0; /* already large enough */
+		vfree(runtime->dma_area);
+	}
+	runtime->dma_area = vmalloc(size);
+	if (!runtime->dma_area)
+		return -ENOMEM;
+	runtime->dma_bytes = size;
+	return 0;
+}
+
+static int snd_pcm_free_vmalloc_buffer(struct snd_pcm_substream *subs)
+{
+	struct snd_pcm_runtime *runtime = subs->runtime;
+
+	vfree(runtime->dma_area);
+	runtime->dma_area = NULL;
+	return 0;
+}
+
+/*-------------------------------------------------------------------------*/
+
+static struct snd_pcm_hardware snd_uac_capture_hw = {
+	.info			= SNDRV_PCM_INFO_MMAP
+				| SNDRV_PCM_INFO_INTERLEAVED
+				| SNDRV_PCM_INFO_BLOCK_TRANSFER
+				| SNDRV_PCM_INFO_MMAP_VALID,
+	.formats		= SNDRV_PCM_FMTBIT_S16_LE,
+	.rates			= SNDRV_PCM_RATE_8000_48000,
+	.rate_min		= 8000,
+	.rate_max		= 48000,
+	.channels_min		= 1,
+	.channels_max		= 1,
+	.buffer_bytes_max	= 32 * 1024,
+	.period_bytes_min	= 4 * 1024,
+	.period_bytes_max	= 32 * 1024,
+	.periods_min		= 1,
+	.periods_max		= 1024,
+};
+
+static struct snd_pcm_hardware snd_uac_playback_hw = {
+	.info			= SNDRV_PCM_INFO_MMAP
+				| SNDRV_PCM_INFO_INTERLEAVED
+				| SNDRV_PCM_INFO_BLOCK_TRANSFER
+				| SNDRV_PCM_INFO_MMAP_VALID,
+	.formats		= SNDRV_PCM_FMTBIT_S16_LE,
+	.rates			= SNDRV_PCM_RATE_8000_48000,
+	.rate_min		= 8000,
+	.rate_max		= 48000,
+	.channels_min		= 1,
+	.channels_max		= 1,
+	.buffer_bytes_max	= 32 * 1024,
+	.period_bytes_min	= 4 * 1024,
+	.period_bytes_max	= 32 * 1024,
+	.periods_min		= 1,
+	.periods_max		= 1024,
+};
+
+static int
+snd_uac_pcm_open(struct snd_pcm_substream *substream, int stream)
+{
+	struct uac_device *uac = snd_pcm_substream_chip(substream);
+	struct snd_uac_substream *subs = &uac->sound.substreams[stream];
+
+	INFO(uac->func.config->cdev, "snd_uac_pcm_open\n");
+
+	substream->runtime->hw = stream == SNDRV_PCM_STREAM_PLAYBACK
+			       ? snd_uac_playback_hw
+			       : snd_uac_capture_hw;
+	substream->runtime->hw.rate_min = uac->rate;
+	substream->runtime->hw.rate_max = uac->rate;
+
+	substream->runtime->private_data = subs;
+	subs->substream = substream;
+
+	return 0;
+}
+
+static int
+snd_uac_capture_open(struct snd_pcm_substream *substream)
+{
+	return snd_uac_pcm_open(substream, SNDRV_PCM_STREAM_CAPTURE);
+}
+
+static int
+snd_uac_playback_open(struct snd_pcm_substream *substream)
+{
+	return snd_uac_pcm_open(substream, SNDRV_PCM_STREAM_PLAYBACK);
+}
+
+static int
+snd_uac_pcm_close(struct snd_pcm_substream *substream)
+{
+	struct uac_device *uac = snd_pcm_substream_chip(substream);
+	struct snd_uac_substream *subs = substream->runtime->private_data;
+
+	INFO(uac->func.config->cdev, "snd_uac_pcm_close\n");
+
+	subs->substream = NULL;
+	return 0;
+}
+
+static int
+snd_uac_pcm_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *hw_params)
+{
+	struct uac_device *uac = snd_pcm_substream_chip(substream);
+	size_t size;
+
+	INFO(uac->func.config->cdev, "snd_uac_pcm_hw_params\n");
+
+	size = params_buffer_bytes(hw_params);
+	return snd_pcm_alloc_vmalloc_buffer(substream, size);
+}
+
+static int
+snd_uac_pcm_hw_free(struct snd_pcm_substream *substream)
+{
+	struct uac_device *uac = snd_pcm_substream_chip(substream);
+
+	INFO(uac->func.config->cdev, "snd_uac_pcm_hw_free\n");
+
+	return snd_pcm_free_vmalloc_buffer(substream);
+}
+
+static int
+snd_uac_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct uac_device *uac = snd_pcm_substream_chip(substream);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_uac_substream *subs = runtime->private_data;
+
+	INFO(uac->func.config->cdev, "snd_uac_pcm_prepare\n");
+
+	subs->frame_bytes = frames_to_bytes(runtime, uac->rate) / 1000;
+	subs->buffer_bytes = frames_to_bytes(runtime, runtime->buffer_size);
+	subs->period_bytes = frames_to_bytes(runtime, runtime->period_size);
+	subs->buffer_pos = 0;
+	subs->period_pos = 0;
+
+	INFO(uac->func.config->cdev, "buffer: %u bytes, period: %u bytes, "
+		"usb frame: %u bytes\n", subs->buffer_bytes, subs->period_bytes,
+		subs->frame_bytes);
+	return 0;
+}
+
+static int
+snd_uac_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct uac_device *uac = snd_pcm_substream_chip(substream);
+	struct snd_uac_substream *subs = substream->runtime->private_data;
+	unsigned long flags;
+
+	INFO(uac->func.config->cdev, "snd_uac_pcm_trigger(%d)\n", cmd);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		spin_lock_irqsave(&subs->lock, flags);
+		subs->streaming = 1;
+		spin_unlock_irqrestore(&subs->lock, flags);
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+		spin_lock_irqsave(&subs->lock, flags);
+		subs->streaming = 0;
+		spin_unlock_irqrestore(&subs->lock, flags);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static snd_pcm_uframes_t
+snd_uac_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct uac_device *uac = snd_pcm_substream_chip(substream);
+	struct snd_uac_substream *subs = substream->runtime->private_data;
+	snd_pcm_uframes_t pointer;
+
+	pointer = bytes_to_frames(substream->runtime, subs->buffer_pos);
+//	INFO(uac->func.config->cdev, "snd_uac_pcm_pointer -> %lu\n", pointer);
+
+	return pointer;
+}
+
+static struct snd_pcm_ops snd_uac_capture_ops = {
+	.open			= snd_uac_capture_open,
+	.close			= snd_uac_pcm_close,
+	.ioctl			= snd_pcm_lib_ioctl,
+	.hw_params		= snd_uac_pcm_hw_params,
+	.hw_free		= snd_uac_pcm_hw_free,
+	.prepare		= snd_uac_pcm_prepare,
+	.trigger		= snd_uac_pcm_trigger,
+	.pointer		= snd_uac_pcm_pointer,
+	.page			= snd_pcm_get_vmalloc_page,
+};
+
+static struct snd_pcm_ops snd_uac_playback_ops = {
+	.open			= snd_uac_playback_open,
+	.close			= snd_uac_pcm_close,
+	.ioctl			= snd_pcm_lib_ioctl,
+	.hw_params		= snd_uac_pcm_hw_params,
+	.hw_free		= snd_uac_pcm_hw_free,
+	.prepare		= snd_uac_pcm_prepare,
+	.trigger		= snd_uac_pcm_trigger,
+	.pointer		= snd_uac_pcm_pointer,
+	.page			= snd_pcm_get_vmalloc_page,
+};
+
+static void
+uac_init_substream(struct uac_device *uac, int stream)
+{
+	struct snd_uac_substream *subs = &uac->sound.substreams[stream];
+
+	snd_pcm_set_ops(uac->sound.pcm, stream,
+			stream == SNDRV_PCM_STREAM_PLAYBACK ?
+			&snd_uac_playback_ops : &snd_uac_capture_ops);
+
+	subs->uac = uac;
+	subs->streaming = 0;
+	spin_lock_init(&subs->lock);
+}
+
+/**
+ * uac_audio_init - setup ALSA interface and preparing for USB transfer
+ *
+ * This sets up PCM, mixer or MIDI ALSA devices for USB gadget using.
+ *
+ * Returns negative errno, or zero on success
+ */
+int __init uac_audio_init(struct uac_device *uac)
+{
+	static int dev = 0;
+
+	struct snd_card *card;
+	struct snd_pcm *pcm;
+	int ret;
+
+	if (dev >= SNDRV_CARDS)
+		return -ENODEV;
+
+	INIT_LIST_HEAD(&uac->req_free);
+	spin_lock_init(&uac->req_lock);
+
+	/* Create a card instance. */
+	ret = snd_card_create(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
+			      THIS_MODULE, 0, &card);
+	if (ret < 0)
+		return ret;
+
+	strlcpy(card->driver, "UAC gadget", sizeof(card->driver));
+	strlcpy(card->shortname, "UAC gadget", sizeof(card->shortname));
+	strlcpy(card->longname, "UAC gadget", sizeof(card->longname));
+
+	snd_card_set_dev(card, &uac->func.config->cdev->gadget->dev);
+
+	/* Create a PCM device. */
+	ret = snd_pcm_new(card, "UAC gadget", 0, uac_capture ? 1 : 0,
+			  uac_playback ? 1 : 0, &pcm);
+	if (ret < 0)
+		goto error;
+
+	uac->sound.pcm = pcm;
+	pcm->private_data = uac;
+
+	if (uac_capture)
+		uac_init_substream(uac, SNDRV_PCM_STREAM_PLAYBACK);
+	if (uac_playback)
+		uac_init_substream(uac, SNDRV_PCM_STREAM_CAPTURE);
+
+	/* Register the sound card. */
+	if ((ret = snd_card_register(card)) < 0)
+		goto error;
+
+	uac->sound.card = card;
+	dev++;
+
+	return 0;
+
+error:
+	snd_card_free(card);
+	return ret;
+}
+
+/**
+ * uac_audio_cleanup - remove ALSA device interface
+ *
+ * This is called to free all resources allocated by @uac_audio_setup().
+ */
+void uac_audio_cleanup(struct uac_device *uac)
+{
+	snd_card_free(uac->sound.card);
+	uac->sound.card = NULL;
+}
+
diff --git a/drivers/usb/gadget/uac_audio.c b/drivers/usb/gadget/uac_audio.c
new file mode 100644
index 0000000..f85a798
--- /dev/null
+++ b/drivers/usb/gadget/uac_audio.c
@@ -0,0 +1,238 @@
+/*
+ *	uac_audio.c -- USB audio class function driver, audio data handling
+ *
+ *	Copyright (C) 2009
+ *	    Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/usb/gadget.h>
+
+#include "uac.h"
+
+/* --------------------------------------------------------------------------
+ * Video codecs
+ */
+
+static void
+uac_audio_encode(struct snd_uac_substream *subs, struct usb_request *req)
+{
+	unsigned char *dma_area;
+	unsigned long flags;
+	unsigned int size;
+
+	spin_lock_irqsave(&subs->lock, flags);
+	if (!subs->streaming) {
+		spin_unlock_irqrestore(&subs->lock, flags);
+		req->length = 0;
+		return;
+	}
+
+	/* TODO Handle buffer underruns. */
+	size = subs->frame_bytes;
+	dma_area = subs->substream->runtime->dma_area;
+
+	if (subs->buffer_pos + size > subs->buffer_bytes) {
+		unsigned int left = subs->buffer_bytes - subs->buffer_pos;
+		memcpy(req->buf, dma_area + subs->buffer_pos, left);
+		memcpy(req->buf + left, dma_area, size - left);
+	} else
+		memcpy(req->buf, dma_area + subs->buffer_pos, size);
+
+	spin_unlock_irqrestore(&subs->lock, flags);
+
+	req->length = size;
+
+	/* Update the buffer and period positions, and update the pcm status
+	 * for the next period if we reached the end of the current one.
+	 */
+	subs->buffer_pos += size;
+	if (subs->buffer_pos >= subs->buffer_bytes)
+		subs->buffer_pos -= subs->buffer_bytes;
+
+	subs->period_pos += size;
+	if (subs->period_pos >= subs->period_bytes) {
+		subs->period_pos %= subs->period_bytes;
+		snd_pcm_period_elapsed(subs->substream);
+	}
+}
+
+/* --------------------------------------------------------------------------
+ * Request handling
+ */
+
+static void
+uac_audio_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct snd_uac_substream *subs = req->context;
+	struct uac_device *uac = subs->uac;
+	unsigned long flags;
+	int ret;
+
+	switch (req->status) {
+	case 0:
+		break;
+
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		goto requeue;
+
+	default:
+		INFO(uac->func.config->cdev, "AS request completed with "
+			"status %d.\n", req->status);
+		goto requeue;
+	}
+
+	uac_audio_encode(subs, req);
+
+	if ((ret = usb_ep_queue(ep, req, GFP_ATOMIC)) < 0) {
+		INFO(uac->func.config->cdev, "Failed to queue request (%d).\n",
+			ret);
+		usb_ep_set_halt(ep);
+		goto requeue;
+	}
+	return;
+
+requeue:
+	spin_lock_irqsave(&uac->req_lock, flags);
+	list_add_tail(&req->list, &uac->req_free);
+	spin_unlock_irqrestore(&uac->req_lock, flags);
+}
+
+static int
+uac_audio_free_requests(struct uac_device *uac)
+{
+	unsigned int i;
+
+	for (i = 0; i < UAC_NUM_REQUESTS; ++i) {
+		if (uac->req[i]) {
+			usb_ep_free_request(uac->audio_ep, uac->req[i]);
+			uac->req[i] = NULL;
+		}
+
+		kfree(uac->req_buffer[i]);
+		uac->req_buffer[i] = NULL;
+	}
+
+	INIT_LIST_HEAD(&uac->req_free);
+	uac->req_size = 0;
+	return 0;
+}
+
+static int
+uac_audio_alloc_requests(struct uac_device *uac)
+{
+	struct snd_uac_substream *subs = &uac->sound.substreams[SNDRV_PCM_STREAM_PLAYBACK];
+	unsigned int i;
+
+	BUG_ON(uac->req_size);
+
+	for (i = 0; i < UAC_NUM_REQUESTS; ++i) {
+		uac->req_buffer[i] = kmalloc(uac->audio_ep->maxpacket,
+					     GFP_KERNEL);
+		if (uac->req_buffer[i] == NULL)
+			goto error;
+
+		uac->req[i] = usb_ep_alloc_request(uac->audio_ep, GFP_KERNEL);
+		if (uac->req[i] == NULL)
+			goto error;
+
+		uac->req[i]->buf = uac->req_buffer[i];
+		uac->req[i]->length = 0;
+		uac->req[i]->dma = DMA_ADDR_INVALID;
+		uac->req[i]->complete = uac_audio_complete;
+		uac->req[i]->context = subs;
+
+		list_add_tail(&uac->req[i]->list, &uac->req_free);
+	}
+
+	uac->req_size = uac->audio_ep->maxpacket;
+	return 0;
+
+error:
+	uac_audio_free_requests(uac);
+	return -ENOMEM;
+}
+
+/* --------------------------------------------------------------------------
+ * Audio streaming
+ */
+
+/*
+ * uac_audio_pump - Pump audio data into the USB requests
+ *
+ * This function fills the available USB requests (listed in req_free) with
+ * audio data from the ALSA buffer.
+ */
+int
+uac_audio_pump(struct uac_device *uac)
+{
+	struct snd_uac_substream *subs = &uac->sound.substreams[SNDRV_PCM_STREAM_PLAYBACK];
+	struct usb_request *req;
+	unsigned long flags;
+	int ret;
+
+	/* FIXME TODO Race between uac_audio_pump and requests completion
+	 * handler ???
+	 */
+
+	while (1) {
+		/* Retrieve the first available USB request, protected by the
+		 * request lock.
+		 */
+		spin_lock_irqsave(&uac->req_lock, flags);
+		if (list_empty(&uac->req_free)) {
+			spin_unlock_irqrestore(&uac->req_lock, flags);
+			return 0;
+		}
+		req = list_first_entry(&uac->req_free, struct usb_request,
+					list);
+		list_del(&req->list);
+		spin_unlock_irqrestore(&uac->req_lock, flags);
+
+		uac_audio_encode(subs, req);
+
+		if ((ret = usb_ep_queue(uac->audio_ep, req, GFP_KERNEL)) < 0) {
+			printk(KERN_INFO "Failed to queue request (%d)\n", ret);
+			usb_ep_set_halt(uac->audio_ep);
+			break;
+		}
+	}
+
+	spin_lock_irqsave(&uac->req_lock, flags);
+	list_add_tail(&req->list, &uac->req_free);
+	spin_unlock_irqrestore(&uac->req_lock, flags);
+	return 0;
+}
+
+/*
+ * Enable or disable the audio stream.
+ */
+
+int
+uac_audio_enable(struct uac_device *uac, int enable)
+{
+	unsigned int i;
+	int ret;
+
+	if (!enable) {
+		for (i = 0; i < UAC_NUM_REQUESTS; ++i)
+			usb_ep_dequeue(uac->audio_ep, uac->req[i]);
+
+		uac_audio_free_requests(uac);
+		return 0;
+	}
+
+	if ((ret = uac_audio_alloc_requests(uac)) < 0)
+		return ret;
+
+	return uac_audio_pump(uac);
+}
+
-- 
1.6.3.3

-- 
Laurent Pinchart
