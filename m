Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3809 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZCNNOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 09:14:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [RFC 3/7] ARM: DaVinci: DM646x Video: THS7303 video amplifier driver
Date: Sat, 14 Mar 2009 14:15:00 +0100
Cc: chaithrika@ti.com, linux-media@vger.kernel.org
References: <1236934866-32135-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1236934866-32135-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141415.00693.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chaithrika,

This is the first pass of this i2c driver. Note that several of the comments
here also apply to adv7343.

On Friday 13 March 2009 10:01:06 chaithrika@ti.com wrote:
> From: Chaithrika U S <chaithrika@ti.com>
> 
> THS7303 video amplifier driver code
> 
> This patch implements driver for TI THS7303 video amplifier . This driver is
> implemented as a v4l2-subdev.
> ---
> Applies to v4l-dvb repository located at
> http://linuxtv.org/hg/v4l-dvb/rev/1fd54a62abde
> 
>  drivers/media/video/Kconfig   |    9 ++
>  drivers/media/video/Makefile  |    1 +
>  drivers/media/video/ths7303.c |  179 +++++++++++++++++++++++++++++++++++++++++
>  include/media/ths7303.h       |   26 ++++++
>  4 files changed, 215 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ths7303.c
>  create mode 100644 include/media/ths7303.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 16019e9..b3b591d 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -435,6 +435,15 @@ config VIDEO_ADV7343
>            To compile this driver as a module, choose M here: the
>            module will be called adv7473.
>  
> +config VIDEO_THS7303
> +	tristate "THS7303 Video Amplifier"
> +	depends on I2C
> +	help
> +	  Support for TI  THS7303 video amplifier
> +
> +	  To compile this driver as a module, choose M here: the
> +          module will be called ths7303.
> +
>  comment "Video improvement chips"
>  
>  config VIDEO_UPD64031A
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 7f9fc62..1ed9c2c 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_VIDEO_BT819) += bt819.o
>  obj-$(CONFIG_VIDEO_BT856) += bt856.o
>  obj-$(CONFIG_VIDEO_BT866) += bt866.o
>  obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
> +obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
>  
>  obj-$(CONFIG_VIDEO_ZORAN) += zoran/
>  
> diff --git a/drivers/media/video/ths7303.c b/drivers/media/video/ths7303.c
> new file mode 100644
> index 0000000..a78b450
> --- /dev/null
> +++ b/drivers/media/video/ths7303.c
> @@ -0,0 +1,179 @@
> +/*
> + * ths7303- THS7303 Video Amplifier driver
> + *
> + * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/ctype.h>
> +#include <linux/i2c.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-i2c-drv.h>

Don't use v4l2-i2c-drv.h: that's for legacy kernel support only (e.g. when
the i2c driver has to run on pre-2.6.22 kernels as well). You can just
write this as a normal i2c driver.

I hope that this header can be removed in the near future to prevent this
confusion.

> +#include <media/v4l2-subdev.h>
> +#include <media/ths7303.h>
> +
> +static int debug;

Hmm, debug is not setup as a module option, so this doesn't do a lot.
You need to add something like this:

module_param(debug, int, 0644);
MODULE_PARM_DESC(debug, "Debug level (0-1)");

> +
> +struct ths7303_state {
> +	struct i2c_client	*client;

Don't store the i2c_client pointer here. It can be obtained from v4l2_subdev.

In this case that reduces the state information to just struct v4l2_subdev...

> +	struct v4l2_subdev sd;
> +};
> +
> +static inline struct ths7303_state *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct ths7303_state, sd);
> +}

...and that means that this function is not needed for this driver.

> +
> +/* following function is used to set ths7303 */
> +static int ths7303_setvalue(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	int err = 0;
> +	u8 val;
> +	struct ths7303_state *state;
> +	struct i2c_client *client;
> +
> +	state = to_state(sd);
> +	client = state->client;
> +
> +	if (client == NULL) {
> +		printk(KERN_ERR "THS7303 Client not found\n");
> +		return -ENODEV;
> +	}

Just use:

	struct i2c_client *client = v4l2_get_subdevdata(sd);

There is no need to check for a valid client pointer. If you have a subdev,
then you have by definition an i2c_client pointer.

> +
> +	if ((std == V4L2_STD_NTSC) || (std == V4L2_STD_PAL))
> +		val = 0x02;

Use 'std & V4L2_STD_NTSC' since v4l2_std_id is a bitmask. I suspect that what
you really want is to AND with '(V4L2_STD_525_60 | V4L2_STD_625_50)'.

> +	else if ((std == V4L2_STD_480P_60) || (std == V4L2_STD_576P_50))
> +		val = 0x4A;
> +	else
> +		val = 0x92;
> +
> +	err |= i2c_smbus_write_byte_data(client, 0x01, val);
> +	err |= i2c_smbus_write_byte_data(client, 0x02, val);
> +	err |= i2c_smbus_write_byte_data(client, 0x03, val);
> +
> +	if (err)
> +		printk(KERN_ERR "ths7303 write\n");

Use: v4l2_err(sd, "write failed\n");

> +
> +	mdelay(100);

Is this just a random number, or does this correspond to what the datasheet
says? 100 ms is fairly long.

I think you should also use msleep() instead of mdelay: both mdelay and udelay
implement the delay using a busy-loop rather than using a timer.

A comment why this delay/sleep is needed is probably also a good idea.

> +
> +	return err;
> +}
> +
> +static long ths7303_ioctl(struct v4l2_subdev *sd, unsigned cmd, void *arg)
> +{
> +	int err = 0;
> +	v4l2_dbg(1, debug, sd, "ioctl\n");

This v4l2_dbg doesn't seem very useful. It might be more useful to stick it
in ths7303_setvalue() and show what register value is set there. Or remove
it altogether.

> +	switch (cmd) {
> +
> +	case THS7303_SETVALUE:
> +		err = ths7303_setvalue(sd, *(v4l2_std_id *) arg);
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int ths7303_initialize(struct v4l2_subdev *sd, u32 val)
> +{
> +	v4l2_std_id id = V4L2_STD_NTSC;
> +	return (int) ths7303_ioctl(sd, THS7303_SETVALUE, &id);
> +}

Avoid using the .init callback. It's better to just set this from
ths7303_probe() function. The .init callback is likely to be removed. It is
generally used incorrectly and once all legacy drivers are converted to
v4l2_subdev I'll go through all drivers and see which ones really need this,
and whether init is really a good name. For example, there is at least one
driver that uses init to load firmware. But having a proper .load_fw callback
for that is much more understandable.

> +
> +static const struct v4l2_subdev_core_ops ths7303_core_ops = {
> +	.ioctl	= ths7303_ioctl,
> +	.init	= ths7303_initialize,
> +};

A note on .ioctl: why not use the tuner.s_std callback instead? Whenever the
driver changes the standard you want this driver to be called as well.

No need to create a new command for that.

Minor note: the s_std callback really belongs to v4l2_subdev_video_ops, but
I'm postponing that move until all legacy drivers are converted.

> +
> +static const struct v4l2_subdev_ops ths7303_ops = {
> +	.core	= &ths7303_core_ops,
> +};
> +
> +static int ths7303_command(struct i2c_client *client, unsigned cmd, void *arg)
> +{
> +	return v4l2_subdev_command(i2c_get_clientdata(client), cmd, arg);
> +}

Don't use this function. It is only needed to provide support for legacy
drivers and so is not needed for new drivers.

> +
> +static int ths7303_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct ths7303_state *state;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -ENODEV;
> +
> +	v4l2_info(client, "chip found @ 0x%x (%s)\n",
> +			client->addr << 1, client->adapter->name);

Use v4l_info in combination with an i2c_client pointer, and v4l2_info in
combination with a v4l2_device or v4l2_subdev pointer.

Yes, I know it is confusing. It is on my (very long) TODO list to clean this
up. Note the v4l2_info will work, but the formatting of the i2c name will be
missing the i2c address that v4l_info adds.

> +
> +	state = kzalloc(sizeof(struct ths7303_state), GFP_KERNEL);
> +	if (state == NULL)
> +		return -ENOMEM;
> +
> +	state->client = client;
> +	v4l2_i2c_subdev_init(&state->sd, client, &ths7303_ops);
> +	v4l2_dbg(1, debug, client, "Registered video amplifier\n");

This v4l2_dbg call doesn't add anything that the v4l2_info above already did.
Just remove this.

> +
> +	return 0;
> +}
> +
> +static int ths7303_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_state(sd));
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ths7303_id[] = {
> +	{THS7303_NAME, 0},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, ths7303_id);
> +
> +static struct v4l2_i2c_driver_data v4l2_i2c_data = {
> +	.name		= THS7303_NAME,
> +	.command	= ths7303_command,
> +	.probe		= ths7303_probe,
> +	.remove		= ths7303_remove,
> +	.legacy_class	= I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL,
> +	.id_table	= ths7303_id,
> +};

Replace this v4l2_i2c_driver_data struct with a normal i2c_driver struct:

static struct i2c_driver ths7303_driver = {
        .name = THS7303_NAME,
        .probe = ths7303_probe,
        .remove = ths7303_remove,
        .id_table = ths7303_id,
};


> +
> +static int __init ths7303_init(void)
> +{
> +	return 0;
> +}
> +
> +static void __exit ths7303_exit(void)
> +{
> +
> +}

Change these to:

static int __init ths7303_init(void)
{
	return i2c_add_driver(&ths7303_driver);
}

static void __exit ths7303_exit(void)
{
	i2c_del_driver(&ths7303_driver);
}

> +
> +module_init(ths7303_init);
> +module_exit(ths7303_exit);
> +
> +MODULE_DESCRIPTION("THS7303 video amplifier driver");
> +MODULE_AUTHOR("Chaithrika U S");
> +MODULE_LICENSE("GPL");

It might be me, but I prefer to have these lines at the top of the driver,
right after the includes. That way I can quickly see what the driver
does and who the author is when I open the source.

Regards,

	Hans

> +
> diff --git a/include/media/ths7303.h b/include/media/ths7303.h
> new file mode 100644
> index 0000000..5426941
> --- /dev/null
> +++ b/include/media/ths7303.h
> @@ -0,0 +1,26 @@
> +/*
> + * THS7303 header file
> + *
> + * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef THS7303_H
> +#define THS7303_H
> +
> +#include <linux/videodev2.h>
> +
> +#define THS7303_NAME	"ths7303"
> +
> +#define THS7303_SETVALUE	_IOW('e', BASE_VIDIOC_PRIVATE + 1,\
> +							v4l2_std_id *)
> +
> +#endif



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
