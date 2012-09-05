Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50445 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab2IEV4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 17:56:54 -0400
Received: by weyx8 with SMTP id x8so722299wey.19
        for <linux-media@vger.kernel.org>; Wed, 05 Sep 2012 14:56:53 -0700 (PDT)
Message-ID: <5047CAA2.4050702@gmail.com>
Date: Wed, 05 Sep 2012 23:56:50 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	hans.verkuil@cisco.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Scott Bambrough <scott.bambrough@linaro.org>
Subject: Re: [RFC PATCH v5] media: add v4l2 subdev driver for S5K4ECGX sensor
References: <1346848110-17882-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1346848110-17882-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 09/05/2012 02:28 PM, Sangwook Lee wrote:
> This patch adds driver for S5K4ECGX sensor with embedded ISP SoC,
> S5K4ECGX, which is a 5M CMOS Image sensor from Samsung
> The driver implements preview mode of the S5K4ECGX sensor.
> capture (snapshot) operation, face detection are missing now.
> Following controls are supported:
> contrast/saturation/brightness/sharpness
> 
> Signed-off-by: Sangwook Lee<sangwook.lee@linaro.org>
> Cc: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Cc: Scott Bambrough<scott.bambrough@linaro.org>

Overall it looks good, thank you for patiently addressing all my 
comments ;) There might be some rough edges here and there, but it's 
all easy to fix. Please see below.


Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
> Changes since v4:
> - replaced register tables with the function from Sylwester
> - updated firmware parsing function with CRC32 check
>    firmware generator from user space:
>    git://git.linaro.org/people/sangwook/fimc-v4l2-app.git
> 
> Changes since v3:
> - used request_firmware to configure initial settings
> - added parsing functions to read initial settings
> - updated regulator API
> - reduced preview setting tables by experiment
> 
> Changes since v2:
> - added GPIO (reset/stby) and regulators
> - updated I2C read/write, based on s5k6aa datasheet
> - fixed set_fmt errors
> - reduced register tables a bit
> - removed vmalloc
> 
> Changes since v1:
> - fixed s_stream(0) when it called twice
> - changed mutex_X position to be used when strictly necessary
> - add additional s_power(0) in case that error happens
> - update more accurate debugging statements
> - remove dummy else
> 
>   drivers/media/i2c/Kconfig    |    7 +
>   drivers/media/i2c/Makefile   |    1 +
>   drivers/media/i2c/s5k4ecgx.c | 1019 ++++++++++++++++++++++++++++++++++++++++++
>   include/media/s5k4ecgx.h     |   37 ++
>   4 files changed, 1064 insertions(+)
>   create mode 100644 drivers/media/i2c/s5k4ecgx.c
>   create mode 100644 include/media/s5k4ecgx.h
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 9a5a059..55b3bbb 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -484,6 +484,13 @@ config VIDEO_S5K6AA
>   	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
>   	  camera sensor with an embedded SoC image signal processor.
> 
> +config VIDEO_S5K4ECGX
> +        tristate "Samsung S5K4ECGX sensor support"
> +        depends on I2C&&  VIDEO_V4L2&&  VIDEO_V4L2_SUBDEV_API
> +        ---help---
> +          This is a V4L2 sensor-level driver for Samsung S5K4ECGX 5M
> +          camera sensor with an embedded SoC image signal processor.
> +
>   source "drivers/media/i2c/smiapp/Kconfig"
> 
>   comment "Flash devices"
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 088a460..a720812 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
>   obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
>   obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
>   obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
> +obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
>   obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
>   obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
>   obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
> diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
> new file mode 100644
> index 0000000..0f12d46
> --- /dev/null
> +++ b/drivers/media/i2c/s5k4ecgx.c
> @@ -0,0 +1,1019 @@
> +/*
> + * Driver for s5k4ecgx (5MP Camera) from Samsung
> + * a quarter-inch optical format 1.4 micron 5 megapixel (Mp)
> + * CMOS image sensor.
> + *
> + * Copyright (C) 2012, Linaro, Sangwook Lee<sangwook.lee@linaro.org>
> + * Copyright (C) 2012, Insignal Co,. Ltd,  Homin Lee<suapapa@insignal.co.kr>
> + *
> + * Based on s5k6aa, noon010pc30 driver
> + * Copyright (C) 2011, Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include<linux/clk.h>
> +#include<linux/crc32.h>
> +#include<linux/ctype.h>
> +#include<linux/delay.h>
> +#include<linux/firmware.h>
> +#include<linux/gpio.h>
> +#include<linux/i2c.h>
> +#include<linux/module.h>
> +#include<linux/regulator/consumer.h>
> +#include<linux/slab.h>
> +#include<linux/vmalloc.h>

What do we need this header for ?

> +
> +#include<media/media-entity.h>
> +#include<media/s5k4ecgx.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-mediabus.h>
> +#include<media/v4l2-subdev.h>
...
> +
> +static int s5k4ecgx_set_ahb_address(struct v4l2_subdev *sd)
> +{
> +	int ret;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	/* Set APB peripherals start address */
> +	ret = s5k4ecgx_i2c_write(client, AHB_MSB_ADDR_PTR, GEN_REG_OFFSH);
> +	if (ret)
> +		return ret;
> +	/*
> +	 * FIXME: This is copied from s5k6aa, because of no information
> +	 * in s5k4ecgx's datasheet.
> +	 * sw_reset is activated to put device into idle status
> +	 */
> +	ret = s5k4ecgx_i2c_write(client, 0x0010, 0x0001);
> +	if (ret)
> +		return ret;
> +
> +	/* FIXME: no information available about this register */

Let's drop that comment, we will fix all magic numbers once proper
documentation is available.

> +	ret = s5k4ecgx_i2c_write(client, 0x1030, 0x0000);
> +	if (ret)
> +		return ret;
> +	/* Halt ARM CPU */
> +	ret = s5k4ecgx_i2c_write(client, 0x0014, 0x0001);
> +
> +	return ret;

Just do

	return s5k4ecgx_i2c_write(client, 0x0014, 0x0001);
> +}
> +
> +#define FW_HEAD 6
> +/* Register address, value are 4, 2 bytes */
> +#define FW_REG_SIZE 6

FW_REG_SIZE is a bit confusing, maybe we could name this FW_RECORD_SIZE
or something similar ?

> +/*
> + * Firmware has the following format:
> + *<total number of records (4-bytes + 2-bytes padding) N>,<  record 0>,
> + *<  record N - 1>,<  CRC32-CCITT (4-bytes)>
> + * where "record" is a 4-byte register address followed by 2-byte
> + * register value (little endian)
> + */
> +static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
> +{
> +	const struct firmware *fw;
> +	int err, i, regs_num;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u16 val;
> +	u32 addr, crc, crc_file, addr_inc = 0;
> +	u8 *fwbuf;
> +
> +	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
> +	if (err) {
> +		v4l2_err(sd, "Failed to read firmware %s\n", S5K4ECGX_FIRMWARE);
> +		goto fw_out1;

return err; 

?
> +	}
> +	fwbuf = kmemdup(fw->data, fw->size, GFP_KERNEL);

Why do we need this kmemdup ? Couldn't we just use fw->data ?

> +	if (!fwbuf) {
> +		err = -ENOMEM;
> +		goto fw_out2;
> +	}
> +	crc_file = *(u32 *)(fwbuf + regs_num * FW_REG_SIZE);

regs_num is uninitialized ?

> +	crc = crc32_le(~0, fwbuf, regs_num * FW_REG_SIZE);
> +	if (crc != crc_file) {
> +		v4l2_err(sd, "FW: invalid crc (%#x:%#x)\n", crc, crc_file);
> +		err = -EINVAL;
> +		goto fw_out3;
> +	}
> +	regs_num = *(u32 *)(fwbuf);

I guess this needs to be moved up. I would make it 

	regs_num = le32_to_cpu(*(u32 *)fw->data);

And perhaps we need a check like:

	if (fw->size < regs_num * FW_REG_SIZE)
		return -EINVAL;
?
> +	v4l2_dbg(3, debug, sd, "FW: %s size %d register sets %d\n",
> +		 S5K4ECGX_FIRMWARE, fw->size, regs_num);
> +	regs_num++; /* Add header */
> +	for (i = 1; i<  regs_num; i++) {
> +		addr = *(u32 *)(fwbuf + i * FW_REG_SIZE);
> +		val = *(u16 *)(fwbuf + i * FW_REG_SIZE + 4);

I think you need to access addr and val through le32_to_cpu() as well, 
even though your ARM system might be little-endian by default, this 
driver could possibly be used on machines with different endianness.

Something like this could be more optimal:

	const u8 *ptr = fw->data + FW_REG_SIZE;

	for (i = 1; i < regs_num; i++) {
		addr = le32_to_cpu(*(u32 *)ptr);
		ptr += 4;
		val = le16_to_cpu(*(u16 *)ptr);
		ptr += FW_REG_SIZE;
	
> +		if (addr - addr_inc != 2)
> +			err = s5k4ecgx_write(client, addr, val);
> +		else
> +			err = s5k4ecgx_i2c_write(client, REG_CMDBUF0_ADDR, val);
> +		if (err)
> +			goto fw_out3;

nit: break instead of goto ?

> +		addr_inc = addr;
> +	}
> +fw_out3:
> +	kfree(fwbuf);
> +fw_out2:
> +	release_firmware(fw);
> +fw_out1:
> +
> +	return err;
> +}
...
> +static int s5k4ecgx_init_sensor(struct v4l2_subdev *sd)
> +{
> +	int ret;
> +
> +	ret = s5k4ecgx_set_ahb_address(sd);
> +	/* The delay is from manufacturer's settings */
> +	msleep(100);
> +
> +	ret |= s5k4ecgx_load_firmware(sd);

	if (!ret)
		ret = s5k4ecgx_load_firmware(sd);
	else
?
> +
> +	if (ret)
> +		v4l2_err(sd, "Failed to write initial settings\n");
> +
> +	return 0;

	return ret; ?
...
> +module_i2c_driver(v4l2_i2c_driver);
> +
> +MODULE_DESCRIPTION("Samsung S5K4ECGX 5MP SOC camera");
> +MODULE_AUTHOR("Sangwook Lee<sangwook.lee@linaro.org>");
> +MODULE_AUTHOR("Seok-Young Jang<quartz.jang@samsung.com>");

Was there anything really contributed by this person ? 

> +MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE(S5K4ECGX_FIRMWARE);
> diff --git a/include/media/s5k4ecgx.h b/include/media/s5k4ecgx.h
> new file mode 100644
> index 0000000..fbed5cb
> --- /dev/null
> +++ b/include/media/s5k4ecgx.h
> @@ -0,0 +1,37 @@
> +/*
> + * S5K4ECGX image sensor header file
> + *
> + * Copyright (C) 2012, Linaro
> + * Copyright (C) 2011, Samsung Electronics Co., Ltd.

2011 -> 2012 ?

Otherwise looks good. Would be interesting to add capture support
to this driver later. I've seen it supports JPEG compressed stream,
also with interleaved preview raw data inside it.

We have similar problem with S5C73M3 sensor, you have to configure 
two resolutions for JPEG and YUV for a single stream. Here you 
additionally could choose from various preview "sub-stream" pixel 
formats (YCBCR, RGB, etc.).

--

Regards,
Sylwester
