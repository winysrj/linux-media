Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:55081 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZK1HOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 02:14:55 -0500
Message-ID: <4B10CDF1.9030204@freemail.hu>
Date: Sat, 28 Nov 2009 08:14:57 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca: add input support for interrupt endpoints
References: <4B095EDE.4090409@freemail.hu>
In-Reply-To: <4B095EDE.4090409@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

what do you think about the latest version of this patchset?

Regards,

	Márton Németh

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Add helper functions for interrupt endpoint based input handling.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/Makefile
> --- a/linux/drivers/media/video/gspca/Makefile	Sat Nov 21 12:01:36 2009 +0100
> +++ b/linux/drivers/media/video/gspca/Makefile	Sun Nov 22 16:40:34 2009 +0100
> @@ -30,6 +30,9 @@
>  obj-$(CONFIG_USB_GSPCA_ZC3XX)    += gspca_zc3xx.o
> 
>  gspca_main-objs     := gspca.o
> +ifeq ($(CONFIG_INPUT),y)
> +    gspca_main-objs += input.o
> +endif
>  gspca_conex-objs    := conex.o
>  gspca_etoms-objs    := etoms.o
>  gspca_finepix-objs  := finepix.o
> diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Sat Nov 21 12:01:36 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.c	Sun Nov 22 16:40:34 2009 +0100
> @@ -40,6 +40,9 @@
>  #include <media/v4l2-ioctl.h>
> 
>  #include "gspca.h"
> +
> +#include <linux/input.h>
> +#include "input.h"
> 
>  /* global values */
>  #define DEF_NURBS 3		/* default number of URBs */
> @@ -499,11 +502,13 @@
>  			i, ep->desc.bEndpointAddress);
>  	gspca_dev->alt = i;		/* memorize the current alt setting */
>  	if (gspca_dev->nbalt > 1) {
> +		gspca_input_destroy_urb(gspca_dev);
>  		ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, i);
>  		if (ret < 0) {
>  			err("set alt %d err %d", i, ret);
> -			return NULL;
> +			ep = NULL;
>  		}
> +		gspca_input_create_urb(gspca_dev);
>  	}
>  	return ep;
>  }
> @@ -707,7 +712,9 @@
>  		if (gspca_dev->sd_desc->stopN)
>  			gspca_dev->sd_desc->stopN(gspca_dev);
>  		destroy_urbs(gspca_dev);
> +		gspca_input_destroy_urb(gspca_dev);
>  		gspca_set_alt0(gspca_dev);
> +		gspca_input_create_urb(gspca_dev);
>  	}
> 
>  	/* always call stop0 to free the subdriver's resources */
> @@ -2088,6 +2095,11 @@
> 
>  	usb_set_intfdata(intf, gspca_dev);
>  	PDEBUG(D_PROBE, "/dev/video%d created", gspca_dev->vdev.num);
> +
> +	ret = gspca_input_connect(gspca_dev);
> +	if (0 <= ret)
> +		ret = gspca_input_create_urb(gspca_dev);
> +
>  	return 0;
>  out:
>  	kfree(gspca_dev->usb_buf);
> @@ -2105,6 +2117,7 @@
>  void gspca_disconnect(struct usb_interface *intf)
>  {
>  	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
> +	struct input_dev *input_dev;
> 
>  	PDEBUG(D_PROBE, "/dev/video%d disconnect", gspca_dev->vdev.num);
>  	mutex_lock(&gspca_dev->usb_lock);
> @@ -2113,6 +2126,13 @@
>  	if (gspca_dev->streaming) {
>  		destroy_urbs(gspca_dev);
>  		wake_up_interruptible(&gspca_dev->wq);
> +	}
> +
> +	gspca_input_destroy_urb(gspca_dev);
> +	input_dev = gspca_dev->input_dev;
> +	if (input_dev) {
> +		gspca_dev->input_dev = NULL;
> +		input_unregister_device(input_dev);
>  	}
> 
>  	/* the device is freed at exit of this function */
> @@ -2140,6 +2160,7 @@
>  	if (gspca_dev->sd_desc->stopN)
>  		gspca_dev->sd_desc->stopN(gspca_dev);
>  	destroy_urbs(gspca_dev);
> +	gspca_input_destroy_urb(gspca_dev);
>  	gspca_set_alt0(gspca_dev);
>  	if (gspca_dev->sd_desc->stop0)
>  		gspca_dev->sd_desc->stop0(gspca_dev);
> @@ -2153,6 +2174,7 @@
> 
>  	gspca_dev->frozen = 0;
>  	gspca_dev->sd_desc->init(gspca_dev);
> +	gspca_input_create_urb(gspca_dev);
>  	if (gspca_dev->streaming)
>  		return gspca_init_transfer(gspca_dev);
>  	return 0;
> diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/gspca.h
> --- a/linux/drivers/media/video/gspca/gspca.h	Sat Nov 21 12:01:36 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.h	Sun Nov 22 16:40:34 2009 +0100
> @@ -81,6 +81,9 @@
>  typedef void (*cam_pkt_op) (struct gspca_dev *gspca_dev,
>  				u8 *data,
>  				int len);
> +typedef int (*cam_int_pkt_op) (struct gspca_dev *gspca_dev,
> +				u8 *data,
> +				int len);
> 
>  struct ctrl {
>  	struct v4l2_queryctrl qctrl;
> @@ -116,6 +119,9 @@
>  	cam_reg_op get_register;
>  #endif
>  	cam_ident_op get_chip_ident;
> +#ifdef CONFIG_INPUT
> +	cam_int_pkt_op int_pkt_scan;
> +#endif
>  };
> 
>  /* packet types when moving from iso buf to frame buf */
> @@ -138,6 +144,10 @@
>  	struct module *module;		/* subdriver handling the device */
>  	struct usb_device *dev;
>  	struct file *capt_file;		/* file doing video capture */
> +#ifdef CONFIG_INPUT
> +	struct input_dev *input_dev;
> +	char phys[64];			/* physical device path */
> +#endif
> 
>  	struct cam cam;				/* device information */
>  	const struct sd_desc *sd_desc;		/* subdriver description */
> @@ -147,6 +157,9 @@
>  #define USB_BUF_SZ 64
>  	__u8 *usb_buf;				/* buffer for USB exchanges */
>  	struct urb *urb[MAX_NURBS];
> +#ifdef CONFIG_INPUT
> +	struct urb *int_urb;
> +#endif
> 
>  	__u8 *frbuf;				/* buffer for nframes */
>  	struct gspca_frame frame[GSPCA_MAX_FRAMES];
> diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/input.c
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/video/gspca/input.c	Sun Nov 22 16:40:34 2009 +0100
> @@ -0,0 +1,184 @@
> +/*
> + * Input handling for gspca USB camera drivers
> + *
> + * Copyright (C) 2009 Márton Németh <nm127@freemail.hu>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> + * for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundation,
> + * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/input.h>
> +#include <linux/usb/input.h>
> +
> +#include "gspca.h"
> +#include "input.h"
> +
> +#define MODULE_NAME "gspca_input"
> +
> +
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
> +static void int_irq(struct urb *urb, struct pt_regs *regs)
> +#else
> +static void int_irq(struct urb *urb)
> +#endif
> +{
> +	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
> +	int ret;
> +
> +	if (urb->status == 0) {
> +		if (gspca_dev->sd_desc->int_pkt_scan(gspca_dev,
> +		    urb->transfer_buffer, urb->actual_length) < 0) {
> +			PDEBUG(D_ERR, "Unknown packet received");
> +		}
> +
> +		ret = usb_submit_urb(urb, GFP_ATOMIC);
> +		if (ret < 0)
> +			PDEBUG(D_ERR, "Resubmit URB failed with error %i", ret);
> +	}
> +}
> +
> +int gspca_input_connect(struct gspca_dev *dev)
> +{
> +	struct input_dev *input_dev;
> +	int err = 0;
> +
> +	dev->input_dev = NULL;
> +	if (dev->sd_desc->int_pkt_scan)  {
> +		input_dev = input_allocate_device();
> +		if (!input_dev)
> +			return -ENOMEM;
> +
> +		usb_make_path(dev->dev, dev->phys, sizeof(dev->phys));
> +		strlcat(dev->phys, "/input0", sizeof(dev->phys));
> +
> +		input_dev->name = dev->sd_desc->name;
> +		input_dev->phys = dev->phys;
> +
> +		usb_to_input_id(dev->dev, &input_dev->id);
> +
> +		input_dev->evbit[0] = BIT_MASK(EV_KEY);
> +		input_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
> +		input_dev->dev.parent = &dev->dev->dev;
> +
> +		err = input_register_device(input_dev);
> +		if (err) {
> +			PDEBUG(D_ERR, "Input device registration failed "
> +				"with error %i", err);
> +			input_dev->dev.parent = NULL;
> +			input_free_device(input_dev);
> +		} else {
> +			dev->input_dev = input_dev;
> +		}
> +	} else
> +		err = -EINVAL;
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(gspca_input_connect);
> +
> +static int alloc_and_submit_int_urb(struct gspca_dev *gspca_dev,
> +			  struct usb_endpoint_descriptor *ep)
> +{
> +	unsigned int buffer_len;
> +	int interval;
> +	struct urb *urb;
> +	struct usb_device *dev;
> +	void *buffer = NULL;
> +	int ret = -EINVAL;
> +
> +	buffer_len = ep->wMaxPacketSize;
> +	interval = ep->bInterval;
> +	PDEBUG(D_PROBE, "found int in endpoint: 0x%x, "
> +		"buffer_len=%u, interval=%u",
> +		ep->bEndpointAddress, buffer_len, interval);
> +
> +	dev = gspca_dev->dev;
> +	gspca_dev->int_urb = NULL;
> +
> +	urb = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!urb) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
> +	buffer = usb_buffer_alloc(dev, ep->wMaxPacketSize,
> +				GFP_KERNEL, &urb->transfer_dma);
> +	if (!buffer) {
> +		ret = -ENOMEM;
> +		goto error_buffer;
> +	}
> +	usb_fill_int_urb(urb, dev,
> +		usb_rcvintpipe(dev, ep->bEndpointAddress),
> +		buffer, buffer_len,
> +		int_irq, (void *)gspca_dev, interval);
> +	gspca_dev->int_urb = urb;
> +	ret = usb_submit_urb(urb, GFP_KERNEL);
> +	if (ret < 0) {
> +		PDEBUG(D_ERR, "submit URB failed with error %i", ret);
> +		goto error_submit;
> +	}
> +	return ret;
> +
> +error_submit:
> +	usb_buffer_free(dev,
> +			urb->transfer_buffer_length,
> +			urb->transfer_buffer,
> +			urb->transfer_dma);
> +error_buffer:
> +	usb_free_urb(urb);
> +error:
> +	return ret;
> +}
> +
> +int gspca_input_create_urb(struct gspca_dev *gspca_dev)
> +{
> +	int ret = -EINVAL;
> +	struct usb_interface *intf;
> +	struct usb_host_interface *intf_desc;
> +	struct usb_endpoint_descriptor *ep;
> +	int i;
> +
> +	if (gspca_dev->sd_desc->int_pkt_scan)  {
> +		intf = usb_ifnum_to_if(gspca_dev->dev, gspca_dev->iface);
> +		intf_desc = intf->cur_altsetting;
> +		for (i = 0; i < intf_desc->desc.bNumEndpoints; i++) {
> +			ep = &intf_desc->endpoint[i].desc;
> +			if (usb_endpoint_dir_in(ep) &&
> +			    usb_endpoint_xfer_int(ep)) {
> +
> +				ret = alloc_and_submit_int_urb(gspca_dev, ep);
> +				break;
> +			}
> +		}
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(gspca_input_create_urb);
> +
> +void gspca_input_destroy_urb(struct gspca_dev *gspca_dev)
> +{
> +	struct urb *urb;
> +
> +	urb = gspca_dev->int_urb;
> +	if (urb) {
> +		gspca_dev->int_urb = NULL;
> +		usb_kill_urb(urb);
> +		usb_buffer_free(gspca_dev->dev,
> +				urb->transfer_buffer_length,
> +				urb->transfer_buffer,
> +				urb->transfer_dma);
> +		usb_free_urb(urb);
> +	}
> +}
> +EXPORT_SYMBOL(gspca_input_destroy_urb);
> diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/input.h
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/video/gspca/input.h	Sun Nov 22 16:40:34 2009 +0100
> @@ -0,0 +1,36 @@
> +/*
> + * Input handling for gspca USB camera drivers
> + *
> + * Copyright (C) 2009 Márton Németh <nm127@freemail.hu>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> + * for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundation,
> + * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef GSPCA_INPUT_H
> +#define GSPCA_INPUT_H
> +
> +#include "gspca.h"
> +
> +#ifdef CONFIG_INPUT
> +int gspca_input_connect(struct gspca_dev *gspca_dev);
> +int gspca_input_create_urb(struct gspca_dev *gspca_dev);
> +void gspca_input_destroy_urb(struct gspca_dev *gspca_dev);
> +#else
> +#define gspca_input_connect(gspca_dev)		0
> +#define gspca_input_create_urb(gspca_dev)	0
> +#define gspca_input_destroy_urb(gspca_dev)
> +#endif
> +
> +#endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

