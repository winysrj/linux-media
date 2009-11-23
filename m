Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050AbZKWMqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 07:46:08 -0500
Message-ID: <4B0A840F.1040804@redhat.com>
Date: Mon, 23 Nov 2009 10:46:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 2/3 v2] lirc driver for Windows MCE IR transceivers
References: <200910200956.33391.jarod@redhat.com> <200910201000.00372.jarod@redhat.com>
In-Reply-To: <200910201000.00372.jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> lirc driver for Windows Media Center Ed. IR transceivers
> 
> Successfully tested with the mce v2 transceiver and remote that shipped with a
> Hauppauge HVR-1500 expresscard tuner and an mce v1 transceiver from an old HP
> Media Center system.
> 
> Changes from prior submission:
> - both v1 and v2 transceivers supported by one driver now
> - transmit works on the v1 devices
> - support for several new devices
> - now uses dev_dbg (and friends) instead of its own dprintk
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> Signed-off-by: Janne Grunau <j@jannau.net>
> CC: Christoph Bartelmus <lirc@bartelmus.de>
> Tested-by: Jarod Wilson <jarod@redhat.com>
> 
> ---
>  drivers/input/lirc/Kconfig       |    6 
>  drivers/input/lirc/Makefile      |    1 
>  drivers/input/lirc/lirc_mceusb.c | 1235 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1241 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/input/lirc/Kconfig
> ===================================================================
> --- a/drivers/input/lirc/Kconfig
> +++ b/drivers/input/lirc/Kconfig
> @@ -11,6 +11,10 @@ menuconfig INPUT_LIRC
>  
>  if INPUT_LIRC
>  
> -# Device-specific drivers go here
> +config LIRC_MCEUSB
> +	tristate "Windows Media Center Ed. USB IR Transceiver"
> +	depends on LIRC_DEV && USB
> +	help
> +	  Driver for Windows Media Center Ed. USB IR Transceivers
>  
>  endif
> Index: b/drivers/input/lirc/Makefile
> ===================================================================
> --- a/drivers/input/lirc/Makefile
> +++ b/drivers/input/lirc/Makefile
> @@ -4,3 +4,4 @@
>  # Each configuration option enables a list of files.
>  
>  obj-$(CONFIG_INPUT_LIRC)	+= lirc_dev.o
> +obj-$(CONFIG_LIRC_MCEUSB)	+= lirc_mceusb.o
> Index: b/drivers/input/lirc/lirc_mceusb.c
> ===================================================================
> --- /dev/null
> +++ b/drivers/input/lirc/lirc_mceusb.c
> @@ -0,0 +1,1235 @@
> +/*
> + * LIRC driver for Windows Media Center Edition USB Infrared Transceivers
> + *
> + * (C) by Martin A. Blatter <martin_a_blatter@yahoo.com>
> + *
> + * Transmitter support and reception code cleanup.
> + * (C) by Daniel Melander <lirc@rajidae.se>
> + *
> + * Original lirc_mceusb driver for 1st-gen device:
> + * Copyright (c) 2003-2004 Dan Conti <dconti@acm.wwu.edu>
> + *
> + * Original lirc_mceusb driver deprecated in favor of this driver, which
> + * supports the 1st-gen device now too. Transmitting on the 1st-gen device
> + * only functions on port #2 at the moment.
> + *
> + * Support for 1st-gen device added June 2009,
> + * by Jarod Wilson <jarod@wilsonet.com>
> + *
> + * Initial transmission support for 1st-gen device added August 2009,
> + * by Patrick Calhoun <phineas@ou.edu>
> + *
> + * Derived from ATI USB driver by Paul Miller and the original
> + * MCE USB driver by Dan Conti (and now including chunks of the latter
> + * relevant to the 1st-gen device initialization)
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/kmod.h>
> +#include <linux/smp_lock.h>
> +#include <linux/completion.h>
> +#include <linux/uaccess.h>
> +#include <linux/usb.h>
> +#include <linux/wait.h>
> +#include <linux/time.h>
> +
> +#include "lirc.h"
> +#include "lirc_dev.h"
> +
> +#define DRIVER_VERSION	"1.90"
> +#define DRIVER_AUTHOR	"Daniel Melander <lirc@rajidae.se>, " \
> +			"Martin Blatter <martin_a_blatter@yahoo.com>, " \
> +			"Dan Conti <dconti@acm.wwu.edu>"
> +#define DRIVER_DESC	"Windows Media Center Edition USB IR Transceiver " \
> +			"driver for LIRC"
> +#define DRIVER_NAME	"lirc_mceusb"
> +
> +#define USB_BUFLEN	32	/* USB reception buffer length */
> +#define LIRCBUF_SIZE	256	/* LIRC work buffer length */
> +
> +/* MCE constants */
> +#define MCE_CMDBUF_SIZE	384 /* MCE Command buffer length */
> +#define MCE_TIME_UNIT	50 /* Approx 50us resolution */
> +#define MCE_CODE_LENGTH	5 /* Normal length of packet (with header) */
> +#define MCE_PACKET_SIZE	4 /* Normal length of packet (without header) */
> +#define MCE_PACKET_HEADER 0x84 /* Actual header format is 0x80 + num_bytes */
> +#define MCE_CONTROL_HEADER 0x9F /* MCE status header */
> +#define MCE_TX_HEADER_LENGTH 3 /* # of bytes in the initializing tx header */
> +#define MCE_MAX_CHANNELS 2 /* Two transmitters, hardware dependent? */
> +#define MCE_DEFAULT_TX_MASK 0x03 /* Val opts: TX1=0x01, TX2=0x02, ALL=0x03 */
> +#define MCE_PULSE_BIT	0x80 /* Pulse bit, MSB set == PULSE else SPACE */
> +#define MCE_PULSE_MASK	0x7F /* Pulse mask */
> +#define MCE_MAX_PULSE_LENGTH 0x7F /* Longest transmittable pulse symbol */
> +#define MCE_PACKET_LENGTH_MASK  0x7F /* Pulse mask */
> +
> +
> +/* module parameters */
> +#ifdef CONFIG_USB_DEBUG
> +static int debug = 1;
> +#else
> +static int debug;
> +#endif
> +
> +/* general constants */
> +#define SEND_FLAG_IN_PROGRESS	1
> +#define SEND_FLAG_COMPLETE	2
> +#define RECV_FLAG_IN_PROGRESS	3
> +#define RECV_FLAG_COMPLETE	4
> +
> +#define MCEUSB_INBOUND		1
> +#define MCEUSB_OUTBOUND		2
> +
> +#define VENDOR_PHILIPS		0x0471
> +#define VENDOR_SMK		0x0609
> +#define VENDOR_TATUNG		0x1460
> +#define VENDOR_GATEWAY		0x107b
> +#define VENDOR_SHUTTLE		0x1308
> +#define VENDOR_SHUTTLE2		0x051c
> +#define VENDOR_MITSUMI		0x03ee
> +#define VENDOR_TOPSEED		0x1784
> +#define VENDOR_RICAVISION	0x179d
> +#define VENDOR_ITRON		0x195d
> +#define VENDOR_FIC		0x1509
> +#define VENDOR_LG		0x043e
> +#define VENDOR_MICROSOFT	0x045e
> +#define VENDOR_FORMOSA		0x147a
> +#define VENDOR_FINTEK		0x1934
> +#define VENDOR_PINNACLE		0x2304
> +#define VENDOR_ECS		0x1019
> +#define VENDOR_WISTRON		0x0fb8
> +#define VENDOR_COMPRO		0x185b
> +#define VENDOR_NORTHSTAR	0x04eb

Hmm... we should consider moving the USB ID's to a global kernel header, just like
what we have with PCI IDs...We have some of those ID's on some common headers:

drivers/hid/hid-ids.h
drivers/media/dvb/dvb-usb/dvb-usb-ids.h

Unfortunately, it seems that each subsystem have their own place to store it, and
several drivers have the ID's at their own code.

> +#if 0
> +	Uncomment this if the last 100ms "infinity"-space should be transmitted
> +	to lirc directly instead of at the beginning of the next transmission.
> +	Changes pulse/space order.
> +
> +			if (++i < buf_len && ir->buf_in[i] == 0x01)
> +				send_packet_to_lirc(ir);
> +
> +#endif

Hmm... Generating a different code if uncommenting it doesn't seem nice. It should
be checked what code will produce the right RC5 protocol and uncomment the #if or
remove it completely to avoid temptation of latter change the behavior by uncommenting
it.

> +
> +
> +static int mceusb_lirc_ioctl(struct inode *node, struct file *filep,
> +			     unsigned int cmd, unsigned long arg)
> +{
> +	int result;
> +	unsigned int ivalue;
> +	unsigned long lvalue;
> +	struct mceusb_dev *ir = NULL;
> +
> +	/* Retrieve lirc_driver data for the device */
> +	ir = lirc_get_pdata(filep);
> +	if (!ir || !ir->usb_ep_out)
> +		return -EFAULT;
> +
> +
> +	switch (cmd) {
> +	case LIRC_SET_TRANSMITTER_MASK:
> +
> +		result = get_user(ivalue, (unsigned int *) arg);
> +		if (result)
> +			return result;
> +		switch (ivalue) {
> +		case 0x01: /* Transmitter 1     => 0x04 */
> +		case 0x02: /* Transmitter 2     => 0x02 */
> +		case 0x03: /* Transmitter 1 & 2 => 0x06 */
> +			set_transmitter_mask(ir, ivalue);
> +			break;
> +
> +		default: /* Unsupported transmitter mask */
> +			return MCE_MAX_CHANNELS;
> +		}
> +
> +		dev_dbg(ir->d->dev, ": SET_TRANSMITTERS mask=%d\n", ivalue);
> +		break;
> +
> +	case LIRC_GET_SEND_MODE:
> +
> +		result = put_user(LIRC_SEND2MODE(LIRC_CAN_SEND_PULSE &
> +						 LIRC_CAN_SEND_MASK),
> +				  (unsigned long *) arg);
> +
> +		if (result)
> +			return result;
> +		break;
> +
> +	case LIRC_SET_SEND_MODE:
> +
> +		result = get_user(lvalue, (unsigned long *) arg);
> +
> +		if (result)
> +			return result;
> +		if (lvalue != (LIRC_MODE_PULSE&LIRC_CAN_SEND_MASK))
> +			return -EINVAL;
> +		break;
> +
> +	case LIRC_SET_SEND_CARRIER:
> +
> +		result = get_user(ivalue, (unsigned int *) arg);
> +		if (result)
> +			return result;
> +
> +		set_send_carrier(ir, ivalue);
> +		break;
> +
> +	default:
> +		return lirc_dev_fop_ioctl(node, filep, cmd, arg);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct file_operations lirc_fops = {
> +	.owner		= THIS_MODULE,
> +	.write		= mceusb_transmit_ir,
> +	.ioctl		= mceusb_lirc_ioctl,
> +	.read		= lirc_dev_fop_read,
> +	.poll		= lirc_dev_fop_poll,
> +	.open		= lirc_dev_fop_open,
> +	.release	= lirc_dev_fop_close,
> +};
> +
> +static int mceusb_gen1_init(struct mceusb_dev *ir)
> +{
> +	int i, ret;
> +	char junk[64], data[8];
> +	int partial = 0;
> +
> +	/*
> +	 * Clear off the first few messages. These look like calibration
> +	 * or test data, I can't really tell. This also flushes in case
> +	 * we have random ir data queued up.
> +	 */
> +	for (i = 0; i < 40; i++)
> +		usb_bulk_msg(ir->usbdev,
> +			usb_rcvbulkpipe(ir->usbdev,
> +				ir->usb_ep_in->bEndpointAddress),
> +			junk, 64, &partial, HZ * 10);
> +
> +	ir->is_pulse = 1;
> +
> +	memset(data, 0, 8);

Please use, instead:
	memset(data, 0, sizeof(data));

> +
> +	/* Get Status */
> +	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
> +			      USB_REQ_GET_STATUS, USB_DIR_IN,
> +			      0, 0, data, 2, HZ * 3);
> +
> +	/*    ret = usb_get_status( ir->usbdev, 0, 0, data ); */
> +	dev_dbg(ir->d->dev, "%s - ret = %d status = 0x%x 0x%x\n", __func__,
> +		ret, data[0], data[1]);
> +
> +	/*
> +	 * This is a strange one. They issue a set address to the device
> +	 * on the receive control pipe and expect a certain value pair back
> +	 */
> +	memset(data, 0, 8);

Please use, instead:
	memset(data, 0, sizeof(data));


> +
> +	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
> +			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
> +			      data, 2, HZ * 3);
> +	dev_dbg(ir->d->dev, "%s - ret = %d, devnum = %d\n",
> +		__func__, ret, ir->usbdev->devnum);
> +	dev_dbg(ir->d->dev, "%s - data[0] = %d, data[1] = %d\n",
> +		__func__, data[0], data[1]);
> +
> +	/* set feature: bit rate 38400 bps */
> +	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
> +			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
> +			      0xc04e, 0x0000, NULL, 0, HZ * 3);
> +
> +	dev_dbg(ir->d->dev, "%s - ret = %d\n", __func__, ret);
> +
> +	/* bRequest 4: set char length to 8 bits */
> +	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
> +			      4, USB_TYPE_VENDOR,
> +			      0x0808, 0x0000, NULL, 0, HZ * 3);
> +	dev_dbg(ir->d->dev, "%s - retB = %d\n", __func__, ret);
> +
> +	/* bRequest 2: set handshaking to use DTR/DSR */
> +	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
> +			      2, USB_TYPE_VENDOR,
> +			      0x0000, 0x0100, NULL, 0, HZ * 3);
> +	dev_dbg(ir->d->dev, "%s - retC = %d\n", __func__, ret);
> +
> +	return ret;
> +
> +};
> +
> +static int mceusb_dev_probe(struct usb_interface *intf,
> +				const struct usb_device_id *id)
> +{
> +	struct usb_device *dev = interface_to_usbdev(intf);
> +	struct usb_host_interface *idesc;
> +	struct usb_endpoint_descriptor *ep = NULL;
> +	struct usb_endpoint_descriptor *ep_in = NULL;
> +	struct usb_endpoint_descriptor *ep_out = NULL;
> +	struct usb_host_config *config;
> +	struct mceusb_dev *ir = NULL;
> +	struct lirc_driver *driver = NULL;
> +	struct lirc_buffer *rbuf = NULL;
> +	int devnum, pipe, maxp;
> +	int minor = 0;
> +	int i;
> +	char buf[63], name[128] = "";
> +	int mem_failure = 0;
> +	int is_pinnacle;
> +	int is_microsoft_gen1;
> +
> +	dev_dbg(&intf->dev, ": %s called\n", __func__);
> +
> +	usb_reset_device(dev);
> +
> +	config = dev->actconfig;
> +
> +	idesc = intf->cur_altsetting;
> +
> +	is_pinnacle = usb_match_id(intf, pinnacle_list) ? 1 : 0;
> +
> +	is_microsoft_gen1 = usb_match_id(intf, microsoft_gen1_list) ? 1 : 0;
> +
> +	/* step through the endpoints to find first bulk in and out endpoint */
> +	for (i = 0; i < idesc->desc.bNumEndpoints; ++i) {
> +		ep = &idesc->endpoint[i].desc;
> +
> +		if ((ep_in == NULL)
> +			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
> +			    == USB_DIR_IN)
> +			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			    == USB_ENDPOINT_XFER_BULK)
> +			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			    == USB_ENDPOINT_XFER_INT))) {
> +
> +			dev_dbg(&intf->dev, ": acceptable inbound endpoint "
> +				"found\n");
> +			ep_in = ep;
> +			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
> +			if (is_pinnacle)
> +				/*
> +				 * setting seems to 1 seem to cause issues with
> +				 * Pinnacle timing out on transfer.
> +				 */
> +				ep_in->bInterval = ep->bInterval;
> +			else
> +				ep_in->bInterval = 1;
> +		}
> +
> +		if ((ep_out == NULL)
> +			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
> +			    == USB_DIR_OUT)
> +			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			    == USB_ENDPOINT_XFER_BULK)
> +			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			    == USB_ENDPOINT_XFER_INT))) {
> +
> +			dev_dbg(&intf->dev, ": acceptable outbound endpoint "
> +				"found\n");
> +			ep_out = ep;
> +			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
> +			if (is_pinnacle)
> +				/*
> +				 * setting seems to 1 seem to cause issues with
> +				 * Pinnacle timing out on transfer.
> +				 */
> +				ep_out->bInterval = ep->bInterval;
> +			else
> +				ep_out->bInterval = 1;
> +		}
> +	}
> +	if (ep_in == NULL) {
> +		dev_dbg(&intf->dev, ": inbound and/or endpoint not found\n");
> +		return -ENODEV;
> +	}
> +
> +	devnum = dev->devnum;
> +	pipe = usb_rcvintpipe(dev, ep_in->bEndpointAddress);
> +	maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
> +
> +	mem_failure = 0;
> +	ir = kzalloc(sizeof(struct mceusb_dev), GFP_KERNEL);
> +	if (!ir) {
> +		mem_failure = 1;
> +		goto mem_failure_switch;
> +	}
> +
> +	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
> +	if (!driver) {
> +		mem_failure = 2;
> +		goto mem_failure_switch;
> +	}
> +
> +	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);

kzalloc?

> +	if (!rbuf) {
> +		mem_failure = 3;
> +		goto mem_failure_switch;
> +	}
> +
> +	if (lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE)) {
> +		mem_failure = 4;
> +		goto mem_failure_switch;
> +	}
> +
> +	ir->buf_in = usb_buffer_alloc(dev, maxp, GFP_ATOMIC, &ir->dma_in);
> +	if (!ir->buf_in) {
> +		mem_failure = 5;
> +		goto mem_failure_switch;
> +	}
> +
> +	ir->urb_in = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!ir->urb_in) {
> +		mem_failure = 7;
> +		goto mem_failure_switch;
> +	}
> +
> +	strcpy(driver->name, DRIVER_NAME);
> +	driver->minor = -1;
> +	driver->features = LIRC_CAN_SEND_PULSE |
> +		LIRC_CAN_SET_TRANSMITTER_MASK |
> +		LIRC_CAN_REC_MODE2 |
> +		LIRC_CAN_SET_SEND_CARRIER;
> +	driver->data = ir;
> +	driver->rbuf = rbuf;
> +	driver->set_use_inc = &mceusb_ir_open;
> +	driver->set_use_dec = &mceusb_ir_close;
> +	driver->code_length = sizeof(int) * 8;
> +	driver->fops  = &lirc_fops;
> +	driver->dev   = &intf->dev;
> +	driver->owner = THIS_MODULE;
> +
> +	mutex_init(&ir->lock);
> +	init_waitqueue_head(&ir->wait_out);
> +
> +	minor = lirc_register_driver(driver);
> +	if (minor < 0)
> +		mem_failure = 9;
> +
> +mem_failure_switch:
> +
> +	switch (mem_failure) {
> +	case 9:
> +		usb_free_urb(ir->urb_in);
> +	case 7:
> +		usb_buffer_free(dev, maxp, ir->buf_in, ir->dma_in);
> +	case 5:
> +		lirc_buffer_free(rbuf);
> +	case 4:
> +		kfree(rbuf);
> +	case 3:
> +		kfree(driver);
> +	case 2:
> +		kfree(ir);
> +	case 1:
> +		dev_info(&intf->dev, "out of memory (code=%d)\n", mem_failure);
> +		return -ENOMEM;
> +	}

That seems ugly, IMHO ;) Better to use the standard way for it. Also, as kfree(NULL) is
valid, you could simply remove cases 3, 2 and 1.

The better is to use the standard way for errors, like:

error_free_urb:
	usb_free_urb(ir->urb_in);
error_free_usb_buf:
	usb_buffer_free(dev, maxp, ir->buf_in, ir->dma_in);
error_free_lirc_buf:
	lirc_buffer_free(rbuf);
error:
	kfree(rbuf);
	kfree(driver);
	kfree(ir);
	dev_info(&intf->dev, "out of memory (code=%d)\n", mem_failure);

	return -ENOMEM;
	

> +
> +	driver->minor = minor;
> +	ir->d = driver;
> +	ir->devnum = devnum;
> +	ir->usbdev = dev;
> +	ir->len_in = maxp;

> +	ir->overflow_len = 0;
> +	ir->flags.connected = 0;

There's no need to initialize with 0, since kzalloc were used.

> +	ir->flags.pinnacle = is_pinnacle;
> +	ir->flags.microsoft_gen1 = is_microsoft_gen1;
> +	ir->flags.transmitter_mask_inverted =
> +		usb_match_id(intf, transmitter_mask_list) ? 0 : 1;
> +
> +	ir->lircdata = PULSE_MASK;

> +	ir->is_pulse = 0;

There's no need to initialize with 0, since kzalloc were used.

Cheers,
Mauro
