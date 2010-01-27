Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab0A0OeL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 09:34:11 -0500
Message-ID: <4B604EF1.6090500@redhat.com>
Date: Wed, 27 Jan 2010 15:34:25 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2, RFC] gspca: add input support for interrupt endpoints
References: <4B530BBA.7080400@freemail.hu> <4B53D671.80206@redhat.com> <4B54BDA3.2020403@freemail.hu> <4B54BE29.3080503@freemail.hu> <4B56453B.2050404@redhat.com> <4B5FDE66.60200@freemail.hu>
In-Reply-To: <4B5FDE66.60200@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/27/2010 07:34 AM, Németh Márton wrote:
> Hello Jean-Francois,
>
> do you have any comments or suggestions about this patch?
>

I've been playing around a bit with the latest incarnation
of this patch (with the resubmit issue fixed), and I can report
that it works very well. Once this is merged I've got patches
ready to add button support to pac207, pac7311 and zc3xx cameras
and more will follow as time permits.

Regards,

Hans

> Regards,
>
> 	Márton Németh
>
> Hans de Goede wrote:
>> Hi,
>>
>> Looks good to me now.
>>
>> Regards,
>>
>> Hans
>>
>> On 01/18/2010 09:01 PM, Németh Márton wrote:
>>> From: Márton Németh<nm127@freemail.hu>
>>>
>>> Add support functions for interrupt endpoint based input handling.
>>>
>>> Signed-off-by: Márton Németh<nm127@freemail.hu>
>>> ---
>>> diff -r 875c200a19dc linux/drivers/media/video/gspca/gspca.c
>>> --- a/linux/drivers/media/video/gspca/gspca.c	Sun Jan 17 07:58:51 2010 +0100
>>> +++ b/linux/drivers/media/video/gspca/gspca.c	Mon Jan 18 20:43:55 2010 +0100
>>> @@ -3,6 +3,9 @@
>>>     *
>>>     * Copyright (C) 2008-2009 Jean-Francois Moine (http://moinejf.free.fr)
>>>     *
>>> + * Camera button input handling by Márton Németh
>>> + * Copyright (C) 2009-2010 Márton Németh<nm127@freemail.hu>
>>> + *
>>>     * This program is free software; you can redistribute it and/or modify it
>>>     * under the terms of the GNU General Public License as published by the
>>>     * Free Software Foundation; either version 2 of the License, or (at your
>>> @@ -41,6 +44,9 @@
>>>
>>>    #include "gspca.h"
>>>
>>> +#include<linux/input.h>
>>> +#include<linux/usb/input.h>
>>> +
>>>    /* global values */
>>>    #define DEF_NURBS 3		/* default number of URBs */
>>>    #if DEF_NURBS>   MAX_NURBS
>>> @@ -112,6 +118,186 @@
>>>    	.close		= gspca_vm_close,
>>>    };
>>>
>>> +/*
>>> + * Input and interrupt endpoint handling functions
>>> + */
>>> +#ifdef CONFIG_INPUT
>>> +#if LINUX_VERSION_CODE<   KERNEL_VERSION(2, 6, 19)
>>> +static void int_irq(struct urb *urb, struct pt_regs *regs)
>>> +#else
>>> +static void int_irq(struct urb *urb)
>>> +#endif
>>> +{
>>> +	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
>>> +	int ret;
>>> +
>>> +	ret = urb->status;
>>> +	switch (ret) {
>>> +	case 0:
>>> +		if (gspca_dev->sd_desc->int_pkt_scan(gspca_dev,
>>> +		    urb->transfer_buffer, urb->actual_length)<   0) {
>>> +			PDEBUG(D_ERR, "Unknown packet received");
>>> +		}
>>> +		break;
>>> +
>>> +	case -ENOENT:
>>> +	case -ECONNRESET:
>>> +	case -ENODEV:
>>> +	case -ESHUTDOWN:
>>> +		/* Stop is requested either by software or hardware is gone,
>>> +		 * keep the ret value non-zero and don't resubmit later.
>>> +		 */
>>> +		break;
>>> +
>>> +	default:
>>> +		PDEBUG(D_ERR, "URB error %i, resubmitting", urb->status);
>>> +		urb->status = 0;
>>> +		ret = 0;
>>> +	}
>>> +
>>> +	if (ret == 0) {
>>> +		ret = usb_submit_urb(urb, GFP_ATOMIC);
>>> +		if (ret<   0)
>>> +			PDEBUG(D_ERR, "Resubmit URB failed with error %i", ret);
>>> +	}
>>> +}
>>> +
>>> +static int gspca_input_connect(struct gspca_dev *dev)
>>> +{
>>> +	struct input_dev *input_dev;
>>> +	int err = 0;
>>> +
>>> +	dev->input_dev = NULL;
>>> +	if (dev->sd_desc->int_pkt_scan)  {
>>> +		input_dev = input_allocate_device();
>>> +		if (!input_dev)
>>> +			return -ENOMEM;
>>> +
>>> +		usb_make_path(dev->dev, dev->phys, sizeof(dev->phys));
>>> +		strlcat(dev->phys, "/input0", sizeof(dev->phys));
>>> +
>>> +		input_dev->name = dev->sd_desc->name;
>>> +		input_dev->phys = dev->phys;
>>> +
>>> +		usb_to_input_id(dev->dev,&input_dev->id);
>>> +
>>> +		input_dev->evbit[0] = BIT_MASK(EV_KEY);
>>> +		input_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
>>> +		input_dev->dev.parent =&dev->dev->dev;
>>> +
>>> +		err = input_register_device(input_dev);
>>> +		if (err) {
>>> +			PDEBUG(D_ERR, "Input device registration failed "
>>> +				"with error %i", err);
>>> +			input_dev->dev.parent = NULL;
>>> +			input_free_device(input_dev);
>>> +		} else {
>>> +			dev->input_dev = input_dev;
>>> +		}
>>> +	} else
>>> +		err = -EINVAL;
>>> +
>>> +	return err;
>>> +}
>>> +
>>> +static int alloc_and_submit_int_urb(struct gspca_dev *gspca_dev,
>>> +			  struct usb_endpoint_descriptor *ep)
>>> +{
>>> +	unsigned int buffer_len;
>>> +	int interval;
>>> +	struct urb *urb;
>>> +	struct usb_device *dev;
>>> +	void *buffer = NULL;
>>> +	int ret = -EINVAL;
>>> +
>>> +	buffer_len = ep->wMaxPacketSize;
>>> +	interval = ep->bInterval;
>>> +	PDEBUG(D_PROBE, "found int in endpoint: 0x%x, "
>>> +		"buffer_len=%u, interval=%u",
>>> +		ep->bEndpointAddress, buffer_len, interval);
>>> +
>>> +	dev = gspca_dev->dev;
>>> +
>>> +	urb = usb_alloc_urb(0, GFP_KERNEL);
>>> +	if (!urb) {
>>> +		ret = -ENOMEM;
>>> +		goto error;
>>> +	}
>>> +
>>> +	buffer = usb_buffer_alloc(dev, ep->wMaxPacketSize,
>>> +				GFP_KERNEL,&urb->transfer_dma);
>>> +	if (!buffer) {
>>> +		ret = -ENOMEM;
>>> +		goto error_buffer;
>>> +	}
>>> +	usb_fill_int_urb(urb, dev,
>>> +		usb_rcvintpipe(dev, ep->bEndpointAddress),
>>> +		buffer, buffer_len,
>>> +		int_irq, (void *)gspca_dev, interval);
>>> +	gspca_dev->int_urb = urb;
>>> +	ret = usb_submit_urb(urb, GFP_KERNEL);
>>> +	if (ret<   0) {
>>> +		PDEBUG(D_ERR, "submit URB failed with error %i", ret);
>>> +		goto error_submit;
>>> +	}
>>> +	return ret;
>>> +
>>> +error_submit:
>>> +	usb_buffer_free(dev,
>>> +			urb->transfer_buffer_length,
>>> +			urb->transfer_buffer,
>>> +			urb->transfer_dma);
>>> +error_buffer:
>>> +	usb_free_urb(urb);
>>> +error:
>>> +	return ret;
>>> +}
>>> +
>>> +static int gspca_input_create_urb(struct gspca_dev *gspca_dev)
>>> +{
>>> +	int ret = -EINVAL;
>>> +	struct usb_interface *intf;
>>> +	struct usb_host_interface *intf_desc;
>>> +	struct usb_endpoint_descriptor *ep;
>>> +	int i;
>>> +
>>> +	if (gspca_dev->sd_desc->int_pkt_scan)  {
>>> +		intf = usb_ifnum_to_if(gspca_dev->dev, gspca_dev->iface);
>>> +		intf_desc = intf->cur_altsetting;
>>> +		for (i = 0; i<   intf_desc->desc.bNumEndpoints; i++) {
>>> +			ep =&intf_desc->endpoint[i].desc;
>>> +			if (usb_endpoint_dir_in(ep)&&
>>> +			    usb_endpoint_xfer_int(ep)) {
>>> +
>>> +				ret = alloc_and_submit_int_urb(gspca_dev, ep);
>>> +				break;
>>> +			}
>>> +		}
>>> +	}
>>> +	return ret;
>>> +}
>>> +
>>> +static void gspca_input_destroy_urb(struct gspca_dev *gspca_dev)
>>> +{
>>> +	struct urb *urb;
>>> +
>>> +	urb = gspca_dev->int_urb;
>>> +	if (urb) {
>>> +		gspca_dev->int_urb = NULL;
>>> +		usb_kill_urb(urb);
>>> +		usb_buffer_free(gspca_dev->dev,
>>> +				urb->transfer_buffer_length,
>>> +				urb->transfer_buffer,
>>> +				urb->transfer_dma);
>>> +		usb_free_urb(urb);
>>> +	}
>>> +}
>>> +#else
>>> +#define gspca_input_connect(gspca_dev)		0
>>> +#define gspca_input_create_urb(gspca_dev)	0
>>> +#define gspca_input_destroy_urb(gspca_dev)
>>> +#endif
>>> +
>>>    /* get the current input frame buffer */
>>>    struct gspca_frame *gspca_get_i_frame(struct gspca_dev *gspca_dev)
>>>    {
>>> @@ -499,11 +685,13 @@
>>>    			i, ep->desc.bEndpointAddress);
>>>    	gspca_dev->alt = i;		/* memorize the current alt setting */
>>>    	if (gspca_dev->nbalt>   1) {
>>> +		gspca_input_destroy_urb(gspca_dev);
>>>    		ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, i);
>>>    		if (ret<   0) {
>>>    			err("set alt %d err %d", i, ret);
>>> -			return NULL;
>>> +			ep = NULL;
>>>    		}
>>> +		gspca_input_create_urb(gspca_dev);
>>>    	}
>>>    	return ep;
>>>    }
>>> @@ -714,7 +902,9 @@
>>>    		if (gspca_dev->sd_desc->stopN)
>>>    			gspca_dev->sd_desc->stopN(gspca_dev);
>>>    		destroy_urbs(gspca_dev);
>>> +		gspca_input_destroy_urb(gspca_dev);
>>>    		gspca_set_alt0(gspca_dev);
>>> +		gspca_input_create_urb(gspca_dev);
>>>    	}
>>>
>>>    	/* always call stop0 to free the subdriver's resources */
>>> @@ -2137,6 +2327,11 @@
>>>
>>>    	usb_set_intfdata(intf, gspca_dev);
>>>    	PDEBUG(D_PROBE, "%s created", video_device_node_name(&gspca_dev->vdev));
>>> +
>>> +	ret = gspca_input_connect(gspca_dev);
>>> +	if (ret == 0)
>>> +		ret = gspca_input_create_urb(gspca_dev);
>>> +
>>>    	return 0;
>>>    out:
>>>    	kfree(gspca_dev->usb_buf);
>>> @@ -2154,6 +2349,7 @@
>>>    void gspca_disconnect(struct usb_interface *intf)
>>>    {
>>>    	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
>>> +	struct input_dev *input_dev;
>>>
>>>    	PDEBUG(D_PROBE, "%s disconnect",
>>>    		video_device_node_name(&gspca_dev->vdev));
>>> @@ -2165,6 +2361,13 @@
>>>    		wake_up_interruptible(&gspca_dev->wq);
>>>    	}
>>>
>>> +	gspca_input_destroy_urb(gspca_dev);
>>> +	input_dev = gspca_dev->input_dev;
>>> +	if (input_dev) {
>>> +		gspca_dev->input_dev = NULL;
>>> +		input_unregister_device(input_dev);
>>> +	}
>>> +
>>>    	/* the device is freed at exit of this function */
>>>    	gspca_dev->dev = NULL;
>>>    	mutex_unlock(&gspca_dev->usb_lock);
>>> @@ -2190,6 +2393,7 @@
>>>    	if (gspca_dev->sd_desc->stopN)
>>>    		gspca_dev->sd_desc->stopN(gspca_dev);
>>>    	destroy_urbs(gspca_dev);
>>> +	gspca_input_destroy_urb(gspca_dev);
>>>    	gspca_set_alt0(gspca_dev);
>>>    	if (gspca_dev->sd_desc->stop0)
>>>    		gspca_dev->sd_desc->stop0(gspca_dev);
>>> @@ -2203,6 +2407,7 @@
>>>
>>>    	gspca_dev->frozen = 0;
>>>    	gspca_dev->sd_desc->init(gspca_dev);
>>> +	gspca_input_create_urb(gspca_dev);
>>>    	if (gspca_dev->streaming)
>>>    		return gspca_init_transfer(gspca_dev);
>>>    	return 0;
>>> diff -r 875c200a19dc linux/drivers/media/video/gspca/gspca.h
>>> --- a/linux/drivers/media/video/gspca/gspca.h	Sun Jan 17 07:58:51 2010 +0100
>>> +++ b/linux/drivers/media/video/gspca/gspca.h	Mon Jan 18 20:43:55 2010 +0100
>>> @@ -92,6 +92,9 @@
>>>    typedef void (*cam_pkt_op) (struct gspca_dev *gspca_dev,
>>>    				u8 *data,
>>>    				int len);
>>> +typedef int (*cam_int_pkt_op) (struct gspca_dev *gspca_dev,
>>> +				u8 *data,
>>> +				int len);
>>>
>>>    struct ctrl {
>>>    	struct v4l2_queryctrl qctrl;
>>> @@ -127,6 +130,9 @@
>>>    	cam_reg_op get_register;
>>>    #endif
>>>    	cam_ident_op get_chip_ident;
>>> +#ifdef CONFIG_INPUT
>>> +	cam_int_pkt_op int_pkt_scan;
>>> +#endif
>>>    };
>>>
>>>    /* packet types when moving from iso buf to frame buf */
>>> @@ -149,6 +155,10 @@
>>>    	struct module *module;		/* subdriver handling the device */
>>>    	struct usb_device *dev;
>>>    	struct file *capt_file;		/* file doing video capture */
>>> +#ifdef CONFIG_INPUT
>>> +	struct input_dev *input_dev;
>>> +	char phys[64];			/* physical device path */
>>> +#endif
>>>
>>>    	struct cam cam;				/* device information */
>>>    	const struct sd_desc *sd_desc;		/* subdriver description */
>>> @@ -158,6 +168,9 @@
>>>    #define USB_BUF_SZ 64
>>>    	__u8 *usb_buf;				/* buffer for USB exchanges */
>>>    	struct urb *urb[MAX_NURBS];
>>> +#ifdef CONFIG_INPUT
>>> +	struct urb *int_urb;
>>> +#endif
>>>
>>>    	__u8 *frbuf;				/* buffer for nframes */
>>>    	struct gspca_frame frame[GSPCA_MAX_FRAMES];
>>>
