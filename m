Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8610 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0EWNVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 09:21:48 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Sun, 23 May 2010 21:21:27 +0800
Subject: RE: [PATCH v3 8/8] V4L2 subdev patchset for Intel Moorestown Camera
 Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E922CEF@shsmsx501.ccr.corp.intel.com>
References: <33AB447FBD802F4E932063B962385B351E895735@shsmsx501.ccr.corp.intel.com>
 <201005231443.21136.hverkuil@xs4all.nl>
In-Reply-To: <201005231443.21136.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Currently this driver is only to bring up the flash hardware and basically it work as flash mode by default which will be trigged by ISP pre-flash/flash signal automatically if turn on the flash feature in application. 

In future, it can be extended to support more capabilities such as different mode (torch, flash, indicator, etc) and flash/torch current/time control. 

BRs
Xiaolin

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Sunday, May 23, 2010 8:43 PM
To: Zhang, Xiaolin
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 8/8] V4L2 subdev patchset for Intel Moorestown Camera Imaging Subsystem

On Tuesday 18 May 2010 11:23:56 Zhang, Xiaolin wrote:
> From fb60254ff50703b8b8301d6708371be011f1050e Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Tue, 18 May 2010 15:27:48 +0800
> Subject: [PATCH 8/8] This patch is to add National Semiconductor LM3553 flash LED driver support
>  which is based on the video4linux2 sub-dev driver framework.
> 
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>

Hmm, this driver doesn't seem to do anything. How is the flash supposed to work?

Regards,

	Hans

> ---
>  drivers/media/video/mrstflash.c |  151 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 151 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mrstflash.c
> 
> diff --git a/drivers/media/video/mrstflash.c b/drivers/media/video/mrstflash.c
> new file mode 100644
> index 0000000..927939b
> --- /dev/null
> +++ b/drivers/media/video/mrstflash.c
> @@ -0,0 +1,151 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging camera flash.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-device.h>
> +
> +static int debug;
> +module_param(debug, bool, 0644);
> +MODULE_PARM_DESC(debug, "Debug level (0-1)");
> +
> +MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
> +MODULE_DESCRIPTION("A low-level driver for mrst flash");
> +MODULE_LICENSE("GPL");
> +
> +static int flash_g_chip_ident(struct v4l2_subdev *sd,
> +		struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	#define V4L2_IDENT_MRST_FLASH 8248
> +	return v4l2_chip_ident_i2c_client(client, chip,
> +					  V4L2_IDENT_MRST_FLASH, 0);
> +}
> +
> +static const struct v4l2_subdev_core_ops flash_core_ops = {
> +	.g_chip_ident = flash_g_chip_ident,
> +};
> +static const struct v4l2_subdev_ops flash_ops = {
> +	.core = &flash_core_ops,
> +};
> +
> +static int flash_detect(struct i2c_client *client)
> +{
> +	struct i2c_adapter *adapter = client->adapter;
> +	u8 pid;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -ENODEV;
> +
> +	if (adapter->nr != 0)
> +		return -ENODEV;
> +
> +	pid = i2c_smbus_read_byte_data(client, 0x10);
> +	if (pid == 0x18) {
> +		printk(KERN_ERR "camera flash device found\n");
> +		v4l_dbg(1, debug, client, "found camera flash device");
> +	} else {
> +		printk(KERN_ERR "no camera flash device found\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int flash_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	u8 pid, ver;
> +	int ret = -1;
> +	struct v4l2_subdev *sd;
> +
> +	v4l_info(client, "chip found @ 0x%x (%s)\n",
> +			client->addr << 1, client->adapter->name);
> +
> +	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
> +	ret = flash_detect(client);
> +	if (ret)
> +		return -ENODEV;
> +
> +	v4l2_i2c_subdev_init(sd, client, &flash_ops);
> +
> +	ver = i2c_smbus_read_byte_data(client, 0x50);
> +	v4l_dbg(1, debug, client, "detect:CST from device is 0x%x", ver);
> +	pid = i2c_smbus_read_byte_data(client, 0x20);
> +	v4l_dbg(1, debug, client, "detect:MFPC from device is 0x%x", pid);
> +	pid = i2c_smbus_read_byte_data(client, 0xA0);
> +	v4l_dbg(1, debug, client, "detect:TCC from device is 0x%x", pid);
> +	pid = i2c_smbus_read_byte_data(client, 0xB0);
> +	v4l_dbg(1, debug, client, "detect:FCC from device is 0x%x", pid);
> +	pid = i2c_smbus_read_byte_data(client, 0xC0);
> +	v4l_dbg(1, debug, client, "detect:FDC from device is 0x%x", pid);
> +	i2c_smbus_write_byte_data(client, 0xc0, 0xff); /*set FST to 1000us*/
> +	pid = i2c_smbus_read_byte_data(client, 0xc0);
> +	v4l_dbg(1, debug, client, "FDC from device is 0x%x", pid);
> +
> +	v4l_dbg(1, debug, client,
> +		"successfully load camera flash device driver");
> +	return 0;
> +}
> +
> +static int flash_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(sd);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id flash_id[] = {
> +	{"mrst_camera_flash", 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, flash_id);
> +
> +static struct i2c_driver flash_i2c_driver = {
> +	.driver = {
> +		.name = "mrst_camera_flash",
> +	},
> +	.probe = flash_probe,
> +	.remove = flash_remove,
> +	.id_table = flash_id,
> +};
> +
> +static int __init flash_drv_init(void)
> +{
> +	return i2c_add_driver(&flash_i2c_driver);
> +}
> +
> +static void __exit flash_drv_cleanup(void)
> +{
> +	i2c_del_driver(&flash_i2c_driver);
> +}
> +
> +module_init(flash_drv_init);
> +module_exit(flash_drv_cleanup);
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
