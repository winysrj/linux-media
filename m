Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1999 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3CRIas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 04:30:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jon Arne =?utf-8?q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Subject: Re: [RFC V1 2/8] smi2021: Add smi2021_main.c
Date: Mon, 18 Mar 2013 09:30:38 +0100
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	elezegarcia@gmail.com
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no> <1363270024-12127-3-git-send-email-jonarne@jonarne.no>
In-Reply-To: <1363270024-12127-3-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303180930.38323.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu March 14 2013 15:06:58 Jon Arne Jørgensen wrote:
> This is the core of the smi2021 module.
> It will register the module with the kernel, and register the
> usb probe function.
> 
> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> ---
>  drivers/media/usb/smi2021/smi2021_main.c | 339 +++++++++++++++++++++++++++++++
>  1 file changed, 339 insertions(+)
>  create mode 100644 drivers/media/usb/smi2021/smi2021_main.c
> 
> diff --git a/drivers/media/usb/smi2021/smi2021_main.c b/drivers/media/usb/smi2021/smi2021_main.c
> new file mode 100644
> index 0000000..cc600e7
> --- /dev/null
> +++ b/drivers/media/usb/smi2021/smi2021_main.c
> @@ -0,0 +1,339 @@
> +/*******************************************************************************
> + * smi2021_main.c                                                              *
> + *                                                                             *
> + * USB Driver for SMI2021 - EasyCAP                                            *
> + * USB ID 1c88:003c                                                            *
> + *                                                                             *
> + * *****************************************************************************
> + *
> + * Copyright 2011-2013 Jon Arne Jørgensen
> + * <jonjon.arnearne--a.t--gmail.com>
> + *
> + * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
> + *
> + * This file is part of SMI2021
> + * http://code.google.com/p/easycap-somagic-linux/
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + * This driver is heavily influensed by the STK1160 driver.
> + * Copyright (C) 2012 Ezequiel Garcia
> + * <elezegarcia--a.t--gmail.com>
> + *
> + */
> +
> +#include "smi2021.h"
> +
> +#define VENDOR_ID 0x1c88
> +
> +static unsigned int imput;
> +module_param(imput, int, 0644);
> +MODULE_PARM_DESC(input, "Set default input");
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jon Arne Jørgensen <jonjon.arnearne--a.t--gmail.com>");
> +MODULE_DESCRIPTION("SMI2021 - EasyCap");
> +MODULE_VERSION(SMI2021_DRIVER_VERSION);
> +
> +
> +struct usb_device_id smi2021_usb_device_id_table[] = {
> +	{ USB_DEVICE(VENDOR_ID, 0x003c) },
> +	{ USB_DEVICE(VENDOR_ID, 0x003d) },
> +	{ USB_DEVICE(VENDOR_ID, 0x003e) },
> +	{ USB_DEVICE(VENDOR_ID, 0x003f) },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(usb, smi2021_usb_device_id_table);
> +
> +static unsigned short saa7113_addrs[] = {
> +	0x4a,
> +	I2C_CLIENT_END
> +};
> +
> +/******************************************************************************/
> +/*                                                                            */
> +/*          Write to saa7113                                                  */
> +/*                                                                            */
> +/******************************************************************************/
> +
> +inline int transfer_usb_ctrl(struct smi2021_dev *dev, u8 *data, int len)
> +{
> +	return usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0x00),
> +			0x01, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			0x0b, 0x00,
> +			data, len, 1000);
> +}
> +
> +int smi2021_write_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 val)
> +{
> +	int rc;
> +	u8 snd_data[8];
> +
> +	memset(snd_data, 0x00, 8);
> +
> +	snd_data[SMI2021_CTRL_HEAD] = 0x0b;
> +	snd_data[SMI2021_CTRL_ADDR] = addr;
> +	snd_data[SMI2021_CTRL_DATA_SIZE] = 0x01;
> +
> +	if (addr) {
> +		/* This is I2C data for the saa7113 chip */
> +		snd_data[SMI2021_CTRL_BM_DATA_TYPE] = 0xc0;
> +		snd_data[SMI2021_CTRL_BM_DATA_OFFSET] = 0x01;
> +
> +		snd_data[SMI2021_CTRL_I2C_REG] = reg;
> +		snd_data[SMI2021_CTRL_I2C_VAL] = val;
> +	} else {
> +		/* This is register settings for the smi2021 chip */
> +		snd_data[SMI2021_CTRL_BM_DATA_OFFSET] = 0x82;
> +
> +		snd_data[SMI2021_CTRL_REG_HI] = __cpu_to_be16(reg) >> 8;
> +		snd_data[SMI2021_CTRL_REG_LO] = __cpu_to_be16(reg);
> +
> +	}
> +

Don't transfer memory from the stack. It always has to be k[mz]alloced memory.

> +	rc = transfer_usb_ctrl(dev, snd_data, 8);
> +	if (rc < 0) {
> +		smi2021_warn("write failed on register 0x%x, errno: %d\n",
> +			reg, rc);
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +int smi2021_read_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 *val)
> +{
> +	int rc;
> +	u8 rcv_data[13];
> +	u8 snd_data[8];
> +	memset(rcv_data, 0x00, 13);
> +	memset(snd_data, 0x00, 8);
> +
> +	snd_data[SMI2021_CTRL_HEAD] = 0x0b;
> +	snd_data[SMI2021_CTRL_ADDR] = addr;
> +	snd_data[SMI2021_CTRL_BM_DATA_TYPE] = 0x84;
> +	snd_data[SMI2021_CTRL_DATA_SIZE] = 0x01;
> +	snd_data[SMI2021_CTRL_I2C_REG] = reg;
> +
> +	*val = 0;
> +

Ditto.

> +	rc = transfer_usb_ctrl(dev, snd_data, 8);
> +	if (rc < 0) {
> +		smi2021_warn(
> +			"1st pass failing to read reg 0x%x, usb-errno: %d\n",
> +			reg, rc);
> +		return rc;
> +	}
> +
> +	snd_data[SMI2021_CTRL_BM_DATA_TYPE] = 0xa0;
> +	rc = transfer_usb_ctrl(dev, snd_data, 8);
> +	if (rc < 0) {
> +		smi2021_warn(
> +			"2nd pass failing to read reg 0x%x, usb-errno: %d\n",
> +			reg, rc);
> +		return rc;
> +	}
> +
> +	rc = usb_control_msg(dev->udev,
> +		usb_rcvctrlpipe(dev->udev, 0x80), 0x01,
> +		USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +		0x0b, 0x00, rcv_data, 13, 1000);
> +	if (rc < 0) {
> +		smi2021_warn("Failed to read reg 0x%x, usb-errno: %d\n",
> +			reg, rc);
> +		return rc;
> +	}
> +
> +	*val = rcv_data[SMI2021_CTRL_I2C_RCV_VAL];
> +	return 0;
> +}

Regards,

	Hans
