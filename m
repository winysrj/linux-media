Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4062 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZCWUXM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 16:23:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] v4l2-subdev: THS7303 video amplifier driver
Date: Mon, 23 Mar 2009 21:23:32 +0100
Cc: Chaithrika U S <chaithrika@ti.com>, linux-media@vger.kernel.org
References: <1237811895-26949-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1237811895-26949-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903232123.32469.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 23 March 2009 13:38:15 Chaithrika U S wrote:
> TI THS7303 video amplifier driver code
>
> This patch adds driver for TI THS7303 video amplifier. This driver is
> implemented as a v4l2 sub device. Tested on TI DM646x EVM.
>
> This patch applies on top of the ADV7343 driver patch submitted prior to
> this. The dependency is due to the modification of the
> 'Kconfig', 'Makefile', 'v4l2-chip-ident.h' files by both the patches.
>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>

Just a few small points left:

> ---
>  drivers/media/video/Kconfig     |    9 ++
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/ths7303.c   |  158
> +++++++++++++++++++++++++++++++++++++++ include/media/v4l2-chip-ident.h |
>    3 +
>  4 files changed, 171 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ths7303.c
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 49ff639..9747e4d 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -435,6 +435,15 @@ config VIDEO_ADV7343
>            To compile this driver as a module, choose M here: the
>            module will be called adv7343.
>
> +config VIDEO_THS7303
> +	tristate "THS7303 Video Amplifier"
> +	depends on I2C
> +	help
> +	  Support for TI THS7303 video amplifier
> +
> +	  To compile this driver as a module, choose M here: the
> +          module will be called ths7303.
> +
>  comment "Video improvement chips"
>
>  config VIDEO_UPD64031A
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index eaa5a49..4dc10de 100644
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
> diff --git a/drivers/media/video/ths7303.c
> b/drivers/media/video/ths7303.c new file mode 100644
> index 0000000..ae94910
> --- /dev/null
> +++ b/drivers/media/video/ths7303.c
> @@ -0,0 +1,158 @@
> +/*
> + * ths7303- THS7303 Video Amplifier driver
> + *
> + * Copyright (C) 2009 Texas Instruments Incorporated -
> http://www.ti.com/ + *
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
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-chip-ident.h>
> +
> +MODULE_DESCRIPTION("TI THS7303 video amplifier driver");
> +MODULE_AUTHOR("Chaithrika U S");
> +MODULE_LICENSE("GPL");
> +
> +#define THS7303_NAME	"ths7303"
> +
> +static int debug = 1;

By default the debug level should be 0.

> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Debug level 0-1");
> +
> +struct ths7303_state {
> +	struct v4l2_subdev sd;
> +};

No need for this struct. Just allocate a v4l2_subdev struct directly.

> +
> +/* following function is used to set ths7303 */
> +static int ths7303_setvalue(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	int err = 0;
> +	u8 val;
> +	struct i2c_client *client;
> +
> +	client = v4l2_get_subdevdata(sd);
> +
> +	if (std & V4L2_STD_ALL) {
> +		val = 0x02;
> +		v4l2_dbg(1, debug, sd, "setting value for SDTV format\n");
> +	} else {
> +		val = 0x00;
> +		v4l2_dbg(1, debug, sd, "disabling all channels\n");
> +	}
> +
> +	err |= i2c_smbus_write_byte_data(client, 0x01, val);
> +	err |= i2c_smbus_write_byte_data(client, 0x02, val);
> +	err |= i2c_smbus_write_byte_data(client, 0x03, val);
> +
> +	if (err)
> +		v4l2_err(sd, "write failed\n");
> +
> +	return err;
> +}
> +
> +static int ths7303_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
> +{
> +	return ths7303_setvalue(sd, norm);
> +}

It is my understanding that the ths7303 is only used in combination with 
video encoders (i.e. video output). In that case this should be 
ths7303_s_std_output.

> +
> +static int ths7303_g_chip_ident(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_THS7303, 0);
> +}
> +
> +static const struct v4l2_subdev_tuner_ops ths7303_tuner_ops = {
> +	.s_std	= ths7303_s_std,
> +};
> +
> +static const struct v4l2_subdev_core_ops ths7303_core_ops = {
> +	.g_chip_ident = ths7303_g_chip_ident,
> +};
> +
> +static const struct v4l2_subdev_ops ths7303_ops = {
> +	.core	= &ths7303_core_ops,
> +	.tuner 	= &ths7303_tuner_ops,
> +};
> +
> +static int ths7303_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct ths7303_state *state;
> +	v4l2_std_id std_id = V4L2_STD_NTSC;
> +
> +	if (!i2c_check_functionality(client->adapter,
> I2C_FUNC_SMBUS_BYTE_DATA)) +		return -ENODEV;
> +
> +	v4l_info(client, "chip found @ 0x%x (%s)\n",
> +			client->addr << 1, client->adapter->name);
> +
> +	state = kzalloc(sizeof(struct ths7303_state), GFP_KERNEL);
> +	if (state == NULL)
> +		return -ENOMEM;
> +
> +	v4l2_i2c_subdev_init(&state->sd, client, &ths7303_ops);
> +
> +	return ths7303_setvalue(&state->sd, std_id);
> +
> +}
> +
> +static int ths7303_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(container_of(sd, struct ths7303_state, sd));
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
> +static struct i2c_driver ths7303_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= THS7303_NAME,

I'm not sure whether it is such a good idea to have a THS7303_NAME define. 
It's used in two places: in this .driver.name field and in the 
i2c_device_id struct above. However, they are really two different 
things: .driver.name is the name of this driver, and in the i2c_device_id 
struct it is the name of the device. And there may be other devices that 
can be handled by the same driver (perhaps the ths7353? I think that's very 
similar).

Looking at e.g. hwmon drivers this seems to be the right style: just write 
it out in full rather than using macros.

> +	},
> +	.probe		= ths7303_probe,
> +	.remove		= ths7303_remove,
> +	.id_table	= ths7303_id,
> +};
> +
> +static int __init ths7303_init(void)
> +{
> +	return i2c_add_driver(&ths7303_driver);
> +}
> +
> +static void __exit ths7303_exit(void)
> +{
> +	i2c_del_driver(&ths7303_driver);
> +}
> +
> +module_init(ths7303_init);
> +module_exit(ths7303_exit);
> +
> diff --git a/include/media/v4l2-chip-ident.h
> b/include/media/v4l2-chip-ident.h index 66cd877..4d7e227 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -137,6 +137,9 @@ enum {
>  	/* module saa7191: just ident 7191 */
>  	V4L2_IDENT_SAA7191 = 7191,
>
> +	/* module ths7303: just ident 7303 */
> +	V4L2_IDENT_THS7303 = 7303,
> +
>  	/* module adv7343: just ident 7343 */
>  	V4L2_IDENT_ADV7343 = 7343,

That's it! Just fix these last small things and I'm happy with it!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
