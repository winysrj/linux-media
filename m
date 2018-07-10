Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48750 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbeGJKuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 06:50:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v3 1/2] i2c: add SCCB helpers
Date: Tue, 10 Jul 2018 13:50:51 +0300
Message-ID: <5320256.KVvq6sUnyz@avalon>
In-Reply-To: <1531150874-4595-2-git-send-email-akinobu.mita@gmail.com>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com> <1531150874-4595-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

Thank you for the patch.

On Monday, 9 July 2018 18:41:13 EEST Akinobu Mita wrote:
> This adds Serial Camera Control Bus (SCCB) helpers (sccb_is_available,
> sccb_read_byte, and sccb_write_byte) that are intended to be used by some
> of Omnivision sensor drivers.
> 
> The ov772x driver is going to use these helpers.
> 
> It was previously only worked with the i2c controller drivers that support
> I2C_FUNC_PROTOCOL_MANGLING, because the ov772x device doesn't support
> repeated starts.  After commit 0b964d183cbf ("media: ov772x: allow i2c
> controllers without I2C_FUNC_PROTOCOL_MANGLING"), reading ov772x register
> is replaced with issuing two separated i2c messages in order to avoid
> repeated start.  Using SCCB helpers hides the implementation detail.
> 
> Cc: Peter Rosin <peda@axentia.se>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  include/linux/i2c-sccb.h | 77 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
>  create mode 100644 include/linux/i2c-sccb.h
> 
> diff --git a/include/linux/i2c-sccb.h b/include/linux/i2c-sccb.h
> new file mode 100644
> index 0000000..61dece9
> --- /dev/null
> +++ b/include/linux/i2c-sccb.h
> @@ -0,0 +1,77 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Serial Camera Control Bus (SCCB) helper functions
> + */
> +
> +#ifndef _LINUX_I2C_SCCB_H
> +#define _LINUX_I2C_SCCB_H
> +
> +#include <linux/i2c.h>
> +
> +/**
> + * sccb_is_available - Check if the adapter supports SCCB protocol
> + * @adap: I2C adapter
> + *
> + * Return true if the I2C adapter is capable of using SCCB helper
> functions, + * false otherwise.
> + */
> +static inline bool sccb_is_available(struct i2c_adapter *adap)
> +{
> +	u32 needed_funcs = I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA;
> +
> +#if 0
> +	/*
> +	 * sccb_xfer not needed yet, since there is no driver support currently.
> +	 * Just showing how it should be done if we ever need it.
> +	 */
> +	if (adap->algo->sccb_xfer)
> +		return true;
> +#endif
> +
> +	return (i2c_get_functionality(adap) & needed_funcs) == needed_funcs;
> +}
> +
> +/**
> + * sccb_read_byte - Read data from SCCB slave device
> + * @client: Handle to slave device
> + * @addr: Register to be read from
> + *
> + * This executes the 2-phase write transmission cycle that is followed by a
> + * 2-phase read transmission cycle, returning negative errno else a data
> byte
> + * received from the device.
> + */
> +static inline int sccb_read_byte(struct i2c_client *client, u8 addr)
> +{
> +	int ret;
> +	union i2c_smbus_data data;
> +
> +	i2c_lock_bus(client->adapter, I2C_LOCK_SEGMENT);
> +
> +	ret = __i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> +				I2C_SMBUS_WRITE, addr, I2C_SMBUS_BYTE, NULL);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = __i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> +				I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &data);
> +out:
> +	i2c_unlock_bus(client->adapter, I2C_LOCK_SEGMENT);
> +
> +	return ret < 0 ? ret : data.byte;
> +}

I think I mentioned in a previous review of this patch that the function is 
too big to be a static inline. It should instead be moved to a .c file.

> +/**
> + * sccb_write_byte - Write data to SCCB slave device
> + * @client: Handle to slave device
> + * @addr: Register to write to
> + * @data: Value to be written
> + *
> + * This executes the SCCB 3-phase write transmission cycle, returning
> negative
> + * errno else zero on success.
> + */
> +static inline int sccb_write_byte(struct i2c_client *client, u8 addr, u8
> data)
> +{
> +	return i2c_smbus_write_byte_data(client, addr, data);
> +}
> +
> +#endif /* _LINUX_I2C_SCCB_H */

-- 
Regards,

Laurent Pinchart
