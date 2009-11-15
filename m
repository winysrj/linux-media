Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZKOKQ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 05:16:28 -0500
Message-ID: <4AFFD685.9060209@redhat.com>
Date: Sun, 15 Nov 2009 11:23:01 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: [RFC, PATCH] gspca pac7302: add support for camera button
References: <4AFFC00F.6060704@freemail.hu>
In-Reply-To: <4AFFC00F.6060704@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for working on this! I think it would be great if we could
get support for camera buttons in general into gspca.

I've not looked closely at your code yet, have you looked at
the camera button code in the gspca sn9c20x.c driver? Also I would really
like to see as much of the button handling code as possible go into
the gspca core. AFAIK many many camera's use an usb interrupt ep for this, so
I would like to see the setting up and cleanup of this interrupt ep be in
the core (as said before see the sn9c20x driver for another driver which
does such things).

Regards,

Hans


On 11/15/2009 09:47 AM, Németh Márton wrote:
> From: Márton Németh<nm127@freemail.hu>
>
> Add support for snapshot button found on Labtec Webcam 2200.
>
> Signed-off-by: Márton Németh<nm127@freemail.hu>
> ---
> Hi,
>
> this is the first trial to add support for the snapshot button. This
> code is working only before the streaming is started. When the streaming
> is started the alternate number of the interface 0 is changed and the
> interrupt URB is no longer usable. I guess the interrupt URB is to
> be reconstructed every time when the alternate number is changed.
>
> When I disconnect the device I get the following error:
>
> uhci_hcd 0000:00:1d.1: dma_pool_free buffer-32, f58ba168/358ba168 (bad dma)
>
> I guess something is wrong in this patch with the cleanup routine.
>
> Regards,
>
> 	Márton Németh
>
> ---
> diff -r 09c1284de47d linux/drivers/media/video/gspca/gspca.h
> --- a/linux/drivers/media/video/gspca/gspca.h	Sat Nov 14 08:58:12 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.h	Sun Nov 15 10:40:54 2009 +0100
> @@ -138,6 +138,7 @@
>   	struct module *module;		/* subdriver handling the device */
>   	struct usb_device *dev;
>   	struct file *capt_file;		/* file doing video capture */
> +	struct input_dev *input_dev;
>
>   	struct cam cam;				/* device information */
>   	const struct sd_desc *sd_desc;		/* subdriver description */
> @@ -147,6 +148,7 @@
>   #define USB_BUF_SZ 64
>   	__u8 *usb_buf;				/* buffer for USB exchanges */
>   	struct urb *urb[MAX_NURBS];
> +	struct urb *int_urb;
>
>   	__u8 *frbuf;				/* buffer for nframes */
>   	struct gspca_frame frame[GSPCA_MAX_FRAMES];
> diff -r 09c1284de47d linux/drivers/media/video/gspca/pac7302.c
> --- a/linux/drivers/media/video/gspca/pac7302.c	Sat Nov 14 08:58:12 2009 +0100
> +++ b/linux/drivers/media/video/gspca/pac7302.c	Sun Nov 15 10:40:54 2009 +0100
> @@ -68,6 +68,7 @@
>
>   #define MODULE_NAME "pac7302"
>
> +#include<linux/input.h>
>   #include<media/v4l2-chip-ident.h>
>   #include "gspca.h"
>
> @@ -1220,6 +1221,50 @@
>   }
>   #endif
>
> +#if LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 19)
> +static void int_irq(struct urb *urb, struct pt_regs *regs)
> +#else
> +static void int_irq(struct urb *urb)
> +#endif
> +{
> +	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
> +	int ret;
> +	int i;
> +	__u8 data0, data1;
> +
> +	printk(KERN_DEBUG "int_irq()\n");
> +	printk(KERN_DEBUG "urb->status: %i\n", urb->status);
> +	if (urb->status == 0) {
> +		printk(KERN_DEBUG "urb->actual_length: %u\n", urb->actual_length);
> +		for (i = 0; i<  urb->actual_length; i++) {
> +			printk(KERN_DEBUG "urb->transfer_buffer[%i]=0x%x\n",
> +				i, ((__u8*)urb->transfer_buffer)[i]);
> +		}
> +		if (urb->actual_length == 2) {
> +			data0 = ((__u8*)urb->transfer_buffer)[0];
> +			data1 = ((__u8*)urb->transfer_buffer)[1];
> +			if ((data0 == 0x00&&  data1 == 0x11) ||
> +			    (data0 == 0x22&&  data1 == 0x33) ||
> +			    (data0 == 0x44&&  data1 == 0x55) ||
> +			    (data0 == 0x66&&  data1 == 0x77) ||
> +			    (data0 == 0x88&&  data1 == 0x99) ||
> +			    (data0 == 0xaa&&  data1 == 0xbb) ||
> +			    (data0 == 0xcc&&  data1 == 0xdd) ||
> +			    (data0 == 0xee&&  data1 == 0xff)) {
> +				input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
> +				input_sync(gspca_dev->input_dev);
> +				input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
> +				input_sync(gspca_dev->input_dev);
> +			} else
> +				printk(KERN_DEBUG "Unknown packet received\n");
> +		}
> +		ret = usb_submit_urb(urb, GFP_ATOMIC);
> +		printk(KERN_DEBUG "resubmit urb: %i\n", ret);
> +	}
> +
> +}
> +
> +
>   /* sub-driver description for pac7302 */
>   static struct sd_desc sd_desc = {
>   	.name = MODULE_NAME,
> @@ -1254,19 +1299,132 @@
>   };
>   MODULE_DEVICE_TABLE(usb, device_table);
>
> +static int init_camera_input(struct gspca_dev *gspca_dev, const struct usb_device_id *id)
> +{
> +	struct input_dev *input_dev;
> +	int err;
> +
> +	printk(KERN_DEBUG "allocating input device\n");
> +	input_dev = input_allocate_device();
> +	if (!input_dev)
> +		return -ENOMEM;
> +
> +	//input_dev->name = "Camera capture button";
> +	//input_dev->phys = "camera";
> +	input_dev->id.bustype = BUS_USB;
> +	input_dev->id.vendor = id->idVendor;
> +	input_dev->id.product = id->idProduct;
> +	input_dev->id.version = id->bcdDevice_hi;
> +	//input_dev->id.version = id->bcdDevice_lo;
> +
> +	input_dev->evbit[0] = BIT_MASK(EV_KEY);
> +	input_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
> +	//input_dev->dev.parent = ;
> +
> +	printk(KERN_DEBUG "registering input device\n");
> +	err = input_register_device(input_dev);
> +	if (err) {
> +		input_dev->dev.parent = NULL;
> +		input_free_device(input_dev);
> +	} else {
> +		gspca_dev->input_dev = input_dev;
> +	}
> +
> +	return err;
> +}
> +
>   /* -- device connect -- */
>   static int sd_probe(struct usb_interface *intf,
>   			const struct usb_device_id *id)
>   {
> -	return gspca_dev_probe(intf, id,&sd_desc, sizeof(struct sd),
> +	int ret;
> +	struct usb_host_interface *intf_desc;
> +	struct usb_endpoint_descriptor *ep;
> +	int i;
> +
> +	struct urb *urb;
> +	void* buffer = NULL;
> +	unsigned int buffer_len;
> +	int interval;
> +	struct gspca_dev *gspca_dev;
> +	struct usb_device *dev;
> +
> +	ret = gspca_dev_probe(intf, id,&sd_desc, sizeof(struct sd),
>   				THIS_MODULE);
> +	if (0<= ret) {
> +		intf_desc = intf->cur_altsetting;
> +		for (i = 0; i<  intf_desc->desc.bNumEndpoints; i++) {
> +			ep =&intf_desc->endpoint[i].desc;
> +			if ((ep->bEndpointAddress&  USB_DIR_IN)&&
> +			    ((ep->bmAttributes&  USB_ENDPOINT_XFERTYPE_MASK)
> +				== USB_ENDPOINT_XFER_INT)) {
> +
> +				buffer_len = ep->wMaxPacketSize;
> +				interval = ep->bInterval;
> +				printk(KERN_DEBUG "found int in endpoint: 0x%x\n", ep->bEndpointAddress);
> +				printk(KERN_DEBUG " - buffer_len = %u\n", buffer_len);
> +				printk(KERN_DEBUG " - interval = %u\n", interval);
> +
> +				gspca_dev = usb_get_intfdata(intf);
> +				dev = gspca_dev->dev;
> +				gspca_dev->int_urb = NULL;
> +				gspca_dev->input_dev = NULL;
> +
> +				buffer = kmalloc(ep->wMaxPacketSize, GFP_KERNEL);
> +				if (buffer)
> +					urb = usb_alloc_urb(0, GFP_KERNEL);
> +				else {
> +					kfree(buffer);
> +					urb = NULL;
> +				}
> +				if (buffer&&  urb) {
> +					usb_fill_int_urb(urb, dev,
> +						usb_rcvintpipe(dev, ep->bEndpointAddress),
> +						buffer, buffer_len,
> +						int_irq, (void*)gspca_dev, interval);
> +					ret = init_camera_input(gspca_dev, id);
> +					if (0<= ret) {
> +						gspca_dev->int_urb = urb;
> +						ret = usb_submit_urb(urb, GFP_KERNEL);
> +						printk(KERN_DEBUG "usb_submit_urb() returns %i\n", ret);
> +					}
> +				}
> +			}
> +
> +		}
> +	}
> +	return ret;
> +}
> +
> +static void sd_disconnect(struct usb_interface *intf)
> +{
> +	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
> +	struct urb *urb;
> +	struct input_dev *input_dev;
> +
> +	urb = gspca_dev->int_urb;
> +	if (urb != NULL) {
> +		gspca_dev->int_urb = NULL;
> +		usb_kill_urb(urb);
> +		usb_buffer_free(gspca_dev->dev,
> +				urb->transfer_buffer_length,
> +				urb->transfer_buffer,
> +				urb->transfer_dma);
> +		usb_free_urb(urb);
> +	}
> +	input_dev = gspca_dev->input_dev;
> +	if (input_dev) {
> +		gspca_dev->input_dev = NULL;
> +		input_unregister_device(input_dev);
> +	}
> +	gspca_disconnect(intf);
>   }
>
>   static struct usb_driver sd_driver = {
>   	.name = MODULE_NAME,
>   	.id_table = device_table,
>   	.probe = sd_probe,
> -	.disconnect = gspca_disconnect,
> +	.disconnect = sd_disconnect,
>   #ifdef CONFIG_PM
>   	.suspend = gspca_suspend,
>   	.resume = gspca_resume,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
