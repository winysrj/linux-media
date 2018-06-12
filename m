Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr00094.outbound.protection.outlook.com ([40.107.0.94]:60830
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933450AbeFLRb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 13:31:27 -0400
Subject: Re: [RFC PATCH v2] media: i2c: add SCCB helpers
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
From: Peter Rosin <peda@axentia.se>
Message-ID: <843b1253-67ec-883f-9683-134528320791@axentia.se>
Date: Tue, 12 Jun 2018 19:31:18 +0200
MIME-Version: 1.0
In-Reply-To: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-12 17:34, Akinobu Mita wrote:
> (This is 2nd version of SCCB helpers patch.  After 1st version was
> submitted, I sent alternative patch titled "i2c: add I2C_M_FORCE_STOP".
> But it wasn't accepted because it makes the I2C core code unreadable.
> I couldn't find out a way to untangle it, so I returned to the original
> approach.)
> 
> This adds Serial Camera Control Bus (SCCB) helper functions (sccb_read_byte
> and sccb_write_byte) that are intended to be used by some of Omnivision
> sensor drivers.
> 
> The ov772x driver is going to use these functions in order to make it work
> with most i2c controllers.
> 
> As the ov772x device doesn't support repeated starts, this driver currently
> requires I2C_FUNC_PROTOCOL_MANGLING that is not supported by many i2c
> controller drivers.
> 
> With the sccb_read_byte() that issues two separated requests in order to
> avoid repeated start, the driver doesn't require I2C_FUNC_PROTOCOL_MANGLING.
> 
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - Convert all helpers into static inline functions, and remove C source
>   and Kconfig option.
> - Acquire i2c adapter lock while issuing two requests for sccb_read_byte
> 
>  drivers/media/i2c/sccb.h | 74 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 drivers/media/i2c/sccb.h
> 
> diff --git a/drivers/media/i2c/sccb.h b/drivers/media/i2c/sccb.h
> new file mode 100644
> index 0000000..a531fdc
> --- /dev/null
> +++ b/drivers/media/i2c/sccb.h
> @@ -0,0 +1,74 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Serial Camera Control Bus (SCCB) helper functions
> + */
> +
> +#ifndef __SCCB_H__
> +#define __SCCB_H__
> +
> +#include <linux/i2c.h>
> +
> +/**
> + * sccb_read_byte - Read data from SCCB slave device
> + * @client: Handle to slave device
> + * @addr: Register to be read from
> + *
> + * This executes the 2-phase write transmission cycle that is followed by a
> + * 2-phase read transmission cycle, returning negative errno else a data byte
> + * received from the device.
> + */
> +static inline int sccb_read_byte(struct i2c_client *client, u8 addr)
> +{
> +	u8 val;
> +	struct i2c_msg msg[] = {
> +		{
> +			.addr = client->addr,
> +			.len = 1,
> +			.buf = &addr,
> +		},
> +		{
> +			.addr = client->addr,
> +			.flags = I2C_M_RD,
> +			.len = 1,
> +			.buf = &val,
> +		},
> +	};
> +	int ret;
> +	int i;
> +
> +	i2c_lock_adapter(client->adapter);

I'd say that

	i2c_lock_bus(client->adapter, I2C_LOCK_SEGMENT);

is more appropriate. Maybe we should have a i2c_lock_segment helper?

Cheers,
Peter

> +
> +	/* Issue two separated requests in order to avoid repeated start */
> +	for (i = 0; i < 2; i++) {
> +		ret = __i2c_transfer(client->adapter, &msg[i], 1);
> +		if (ret != 1)
> +			break;
> +	}
> +
> +	i2c_unlock_adapter(client->adapter);
> +
> +	return i == 2 ? val : ret;
> +}
> +
> +/**
> + * sccb_write_byte - Write data to SCCB slave device
> + * @client: Handle to slave device
> + * @addr: Register to write to
> + * @data: Value to be written
> + *
> + * This executes the SCCB 3-phase write transmission cycle, returning negative
> + * errno else zero on success.
> + */
> +static inline int sccb_write_byte(struct i2c_client *client, u8 addr, u8 data)
> +{
> +	int ret;
> +	unsigned char msgbuf[] = { addr, data };
> +
> +	ret = i2c_master_send(client, msgbuf, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +#endif /* __SCCB_H__ */
> 
