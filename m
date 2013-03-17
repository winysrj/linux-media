Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:38796 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756500Ab3CQULA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 16:11:00 -0400
Date: Sun, 17 Mar 2013 21:14:13 +0100
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	hverkuil@xs4all.nl, elezegarcia@gmail.com
Subject: Re: [RFC V1 2/8] smi2021: Add smi2021_main.c
Message-ID: <20130317201413.GC17291@dell.arpanet.local>
Reply-To: 20130315122057.GC2989@localhost.arpanet.local
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
 <1363270024-12127-3-git-send-email-jonarne@jonarne.no>
 <20130315122057.GC2989@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130315122057.GC2989@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 15, 2013 at 09:20:58AM -0300, Ezequiel Garcia wrote:
> On Thu, Mar 14, 2013 at 03:06:58PM +0100, Jon Arne Jørgensen wrote:
> > This is the core of the smi2021 module.
> > It will register the module with the kernel, and register the
> > usb probe function.
> > 
> > Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> > ---
> >  drivers/media/usb/smi2021/smi2021_main.c | 339 +++++++++++++++++++++++++++++++
> >  1 file changed, 339 insertions(+)
> >  create mode 100644 drivers/media/usb/smi2021/smi2021_main.c
> > 
> > diff --git a/drivers/media/usb/smi2021/smi2021_main.c b/drivers/media/usb/smi2021/smi2021_main.c
> > new file mode 100644
> > index 0000000..cc600e7
> > --- /dev/null
> > +++ b/drivers/media/usb/smi2021/smi2021_main.c
> > @@ -0,0 +1,339 @@
> > +/*******************************************************************************
> > + * smi2021_main.c                                                              *
> > + *                                                                             *
> > + * USB Driver for SMI2021 - EasyCAP                                            *
> > + * USB ID 1c88:003c                                                            *
> > + *                                                                             *
> > + * *****************************************************************************
> > + *
> > + * Copyright 2011-2013 Jon Arne Jørgensen
> > + * <jonjon.arnearne--a.t--gmail.com>
> > + *
> > + * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
> > + *
> > + * This file is part of SMI2021
> > + * http://code.google.com/p/easycap-somagic-linux/
> > + *
> > + * This program is free software: you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation, either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> > + *
> > + * This driver is heavily influensed by the STK1160 driver.
> > + * Copyright (C) 2012 Ezequiel Garcia
> > + * <elezegarcia--a.t--gmail.com>
> > + *
> > + */
> > +
> > +#include "smi2021.h"
> > +
> > +#define VENDOR_ID 0x1c88
> > +
> > +static unsigned int imput;
> > +module_param(imput, int, 0644);
> 
> s/imput/input
>

Fixed!
 
> > +MODULE_PARM_DESC(input, "Set default input");
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Jon Arne Jørgensen <jonjon.arnearne--a.t--gmail.com>");
> > +MODULE_DESCRIPTION("SMI2021 - EasyCap");
> > +MODULE_VERSION(SMI2021_DRIVER_VERSION);
> > +
> > +
> > +struct usb_device_id smi2021_usb_device_id_table[] = {
> > +	{ USB_DEVICE(VENDOR_ID, 0x003c) },
> > +	{ USB_DEVICE(VENDOR_ID, 0x003d) },
> > +	{ USB_DEVICE(VENDOR_ID, 0x003e) },
> > +	{ USB_DEVICE(VENDOR_ID, 0x003f) },
> > +	{ }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(usb, smi2021_usb_device_id_table);
> > +
> > +static unsigned short saa7113_addrs[] = {
> > +	0x4a,
> > +	I2C_CLIENT_END
> > +};
> > +
> > +/******************************************************************************/
> > +/*                                                                            */
> > +/*          Write to saa7113                                                  */
> > +/*                                                                            */
> > +/******************************************************************************/
> > +
> > +inline int transfer_usb_ctrl(struct smi2021_dev *dev, u8 *data, int len)
> > +{
> > +	return usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0x00),
> > +			0x01, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > +			0x0b, 0x00,
> > +			data, len, 1000);
> > +}
> > +
> > +int smi2021_write_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 val)
> > +{
> > +	int rc;
> > +	u8 snd_data[8];
> > +
> > +	memset(snd_data, 0x00, 8);
> > +
> 
> I think you want ARRAY_SIZE macro here.
> 

Fixed

> > +	snd_data[SMI2021_CTRL_HEAD] = 0x0b;
> > +	snd_data[SMI2021_CTRL_ADDR] = addr;
> > +	snd_data[SMI2021_CTRL_DATA_SIZE] = 0x01;
> > +
> > +	if (addr) {
> > +		/* This is I2C data for the saa7113 chip */
> > +		snd_data[SMI2021_CTRL_BM_DATA_TYPE] = 0xc0;
> > +		snd_data[SMI2021_CTRL_BM_DATA_OFFSET] = 0x01;
> > +
> > +		snd_data[SMI2021_CTRL_I2C_REG] = reg;
> > +		snd_data[SMI2021_CTRL_I2C_VAL] = val;
> > +	} else {
> > +		/* This is register settings for the smi2021 chip */
> > +		snd_data[SMI2021_CTRL_BM_DATA_OFFSET] = 0x82;
> > +
> 
> Mmmm... you should really avoid magic numbers: 0x82, 0xc0, 0x01...
> can't you use some more meaningful macros?
>

The big problem here, is that I don't know what to call these numbers.

I know some of them are bit fields, and I have some knowledege of what
they do. But as I'm not sure about all of these bits, I figured it was
best to leave them as magic numbers.

I can try to make up some names for the different bits, and create some macros
for the next patch :)

> > +		snd_data[SMI2021_CTRL_REG_HI] = __cpu_to_be16(reg) >> 8;
> > +		snd_data[SMI2021_CTRL_REG_LO] = __cpu_to_be16(reg);
> > +
> > +	}
> > +
> > +	rc = transfer_usb_ctrl(dev, snd_data, 8);
> 
> ARRAY_SIZE macro again...
>

Fixed

> > +	if (rc < 0) {
> > +		smi2021_warn("write failed on register 0x%x, errno: %d\n",
> > +			reg, rc);
> > +		return rc;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int smi2021_read_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 *val)
> > +{
> > +	int rc;
> > +	u8 rcv_data[13];
> > +	u8 snd_data[8];
> > +	memset(rcv_data, 0x00, 13);
> > +	memset(snd_data, 0x00, 8);
> > +
> 
> Ditto.
>

Yes
> > +	snd_data[SMI2021_CTRL_HEAD] = 0x0b;
> > +	snd_data[SMI2021_CTRL_ADDR] = addr;
> > +	snd_data[SMI2021_CTRL_BM_DATA_TYPE] = 0x84;
> > +	snd_data[SMI2021_CTRL_DATA_SIZE] = 0x01;
> > +	snd_data[SMI2021_CTRL_I2C_REG] = reg;
> > +
> > +	*val = 0;
> > +
> > +	rc = transfer_usb_ctrl(dev, snd_data, 8);
> > +	if (rc < 0) {
> > +		smi2021_warn(
> > +			"1st pass failing to read reg 0x%x, usb-errno: %d\n",
> > +			reg, rc);
> > +		return rc;
> > +	}
> > +
> > +	snd_data[SMI2021_CTRL_BM_DATA_TYPE] = 0xa0;
> > +	rc = transfer_usb_ctrl(dev, snd_data, 8);
> > +	if (rc < 0) {
> > +		smi2021_warn(
> > +			"2nd pass failing to read reg 0x%x, usb-errno: %d\n",
> > +			reg, rc);
> > +		return rc;
> > +	}
> > +
> > +	rc = usb_control_msg(dev->udev,
> > +		usb_rcvctrlpipe(dev->udev, 0x80), 0x01,
> > +		USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > +		0x0b, 0x00, rcv_data, 13, 1000);
> > +	if (rc < 0) {
> > +		smi2021_warn("Failed to read reg 0x%x, usb-errno: %d\n",
> > +			reg, rc);
> > +		return rc;
> > +	}
> > +
> > +	*val = rcv_data[SMI2021_CTRL_I2C_RCV_VAL];
> > +	return 0;
> > +}
> > +
> > +static void smi2021_reset_device(struct smi2021_dev *dev)
> > +{
> > +	smi2021_write_reg(dev, 0, 0x3a, 0x80);
> > +	smi2021_write_reg(dev, 0, 0x3b, 0x80);
> > +	smi2021_write_reg(dev, 0, 0x3b, 0x00);
> 
> More magic numbers :S
>

More stuff I don't know what is.
But as I said, I can try to make some nice macros for them :)

> > +}
> > +
> > +static void release_v4l2_dev(struct v4l2_device *v4l2_dev)
> > +{
> > +	struct smi2021_dev *dev = container_of(v4l2_dev, struct smi2021_dev,
> > +								v4l2_dev);
> > +	smi2021_dbg("Releasing all resources\n");
> > +
> > +	smi2021_i2c_unregister(dev);
> > +
> > +	v4l2_ctrl_handler_free(&dev->ctrl_handler);
> > +	v4l2_device_unregister(&dev->v4l2_dev);
> > +	kfree(dev);
> > +}
> > +
> > +#define hb_mult(w_max_packet_size) (1 + (((w_max_packet_size) >> 11) & 0x03))
> > +
> > +static int smi2021_scan_usb(struct usb_interface *intf, struct usb_device *udev)
> > +{
> > +	int i, e, ifnum, sizedescr, size;
> > +	const struct usb_endpoint_descriptor *desc;
> > +	ifnum = intf->altsetting[0].desc.bInterfaceNumber;
> > +
> > +	for (i = 0; i < intf->num_altsetting; i++) {
> > +		for (e = 0; e < intf->altsetting[i].desc.bNumEndpoints; e++) {
> > +			desc = &intf->altsetting[i].endpoint[e].desc;
> > +			sizedescr = le16_to_cpu(desc->wMaxPacketSize);
> > +			size = sizedescr & 0x7ff;
> > +
> > +			if (udev->speed == USB_SPEED_HIGH)
> > +				size = size * hb_mult(sizedescr);
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +/******************************************************************************/
> > +/*                                                                            */
> > +/*          DEVICE  -  PROBE   &   DISCONNECT                                 */
> > +/*                                                                            */
> > +/******************************************************************************/
> > +static int smi2021_usb_probe(struct usb_interface *intf,
> > +					const struct usb_device_id *devid)
> > +{
> > +	int rc = 0;
> 
> Is this rc initialization needed?
>
Nope, removed!

> > +	struct usb_device *udev = interface_to_usbdev(intf);
> > +	struct smi2021_dev *dev;
> > +
> > +	if (udev == (struct usb_device *)NULL) {
> > +		smi2021_err("device is NULL\n");
> > +		return -EFAULT;
> > +	}
> > +
> > +	smi2021_scan_usb(intf, udev);
> > +
> > +	dev = kzalloc(sizeof(struct smi2021_dev), GFP_KERNEL);
> > +	if (dev == NULL)
> > +		return -ENOMEM;
> > +
> > +	dev->udev = udev;
> > +	dev->dev = &intf->dev;
> > +	usb_set_intfdata(intf, dev);
> > +
> > +	/* Initialize videobuf2 stuff */
> > +	rc = smi2021_vb2_setup(dev);
> > +	if (rc < 0)
> > +		goto free_err;
> > +
> > +	spin_lock_init(&dev->buf_lock);
> > +	mutex_init(&dev->v4l2_lock);
> > +	mutex_init(&dev->vb_queue_lock);
> > +
> > +	rc = v4l2_ctrl_handler_init(&dev->ctrl_handler, 0);
> > +	if (rc) {
> > +		smi2021_err("v4l2_ctrl_handler_init failed with: %d\n", rc);
> > +		goto free_err;
> > +	}
> > +
> > +	dev->v4l2_dev.release = release_v4l2_dev;
> > +	dev->v4l2_dev.ctrl_handler = &dev->ctrl_handler;
> > +	rc = v4l2_device_register(dev->dev, &dev->v4l2_dev);
> > +	if (rc) {
> > +		smi2021_err("v4l2_device_register failed with %d\n", rc);
> > +		goto free_ctrl;
> > +	}
> > +
> > +	smi2021_reset_device(dev);
> > +
> > +	rc = smi2021_i2c_register(dev);
> > +	if (rc < 0)
> > +		goto unreg_v4l2;
> > +
> > +	dev->sd_saa7113 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
> > +		"saa7113", 0, saa7113_addrs);
> > +
> > +	smi2021_dbg("Driver version %s successfully loaded\n",
> > +			SMI2021_DRIVER_VERSION);
> > +
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, reset, 0);
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
> > +
> > +	rc = smi2021_snd_register(dev);
> > +	if (rc < 0)
> > +		goto unreg_i2c;
> > +
> > +	rc = smi2021_video_register(dev);
> > +	if (rc < 0)
> > +		goto unreg_snd;
> > +
> > +	return 0;
> > +
> > +unreg_snd:
> > +	smi2021_snd_unregister(dev);
> > +unreg_i2c:
> > +	smi2021_i2c_unregister(dev);
> > +unreg_v4l2:
> > +	v4l2_device_unregister(&dev->v4l2_dev);
> > +free_ctrl:
> > +	v4l2_ctrl_handler_free(&dev->ctrl_handler);
> > +free_err:
> > +	kfree(dev);
> > +
> > +	return rc;
> > +}
> > +
> > +static void smi2021_usb_disconnect(struct usb_interface *intf)
> > +{
> > +	struct smi2021_dev *dev = usb_get_intfdata(intf);
> > +
> > +	smi2021_dbg("Going for release!\n");
> > +
> > +	usb_set_intfdata(intf, NULL);
> > +
> > +	mutex_lock(&dev->vb_queue_lock);
> > +	mutex_lock(&dev->v4l2_lock);
> > +
> > +	smi2021_uninit_isoc(dev);
> > +	smi2021_clear_queue(dev);
> > +
> > +	video_unregister_device(&dev->vdev);
> > +	v4l2_device_disconnect(&dev->v4l2_dev);
> > +
> > +	/* This way current users can detect device is gone */
> > +	dev->udev = NULL;
> > +
> > +	mutex_unlock(&dev->v4l2_lock);
> > +	mutex_unlock(&dev->vb_queue_lock);
> > +
> > +	smi2021_snd_unregister(dev);
> > +
> > +	/*
> > +	 * This calls release_v4l2_dev if it's the last reference.
> > +	 * Otherwise, the release is postponed until there are no users left.
> > +	 */
> > +	v4l2_device_put(&dev->v4l2_dev);
> > +}
> > +
> > +/******************************************************************************/
> > +/*                                                                            */
> > +/*            MODULE  -  INIT  &  EXIT                                        */
> > +/*                                                                            */
> > +/******************************************************************************/
> > +
> > +struct usb_driver smi2021_usb_driver = {
> > +	.name = "smi2021",
> > +	.id_table = smi2021_usb_device_id_table,
> > +	.probe = smi2021_usb_probe,
> > +	.disconnect = smi2021_usb_disconnect
> > +};
> > +
> > +module_usb_driver(smi2021_usb_driver);
> > +
> > -- 
> > 1.8.1.1
> > 
> 
> -- 
> Ezequiel García, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com
