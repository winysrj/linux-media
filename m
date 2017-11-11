Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10516 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754967AbdKKANs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 19:13:48 -0500
Date: Sat, 11 Nov 2017 00:13:26 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v6 6/9] i2c: smbus: use DMA safe buffers for emulated
 SMBus transactions
Message-ID: <20171111001326.0000349b@huawei.com>
In-Reply-To: <20171104202009.3818-7-wsa+renesas@sang-engineering.com>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
        <20171104202009.3818-7-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 4 Nov 2017 21:20:06 +0100
Wolfram Sang <wsa+renesas@sang-engineering.com> wrote:

> For all block commands, try to allocate a DMA safe buffer and mark it
> accordingly. Only use the stack, if the buffers cannot be allocated.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Hmm. Interesting balance here as this adds allocations to paths where the i2c
master can't take advantage.  Not ideal, but perhaps not worth the hassle
of working around it?

It's only for the block calls I guess so not that major an issue.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  drivers/i2c/i2c-core-smbus.c | 45 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core-smbus.c b/drivers/i2c/i2c-core-smbus.c
> index 4bb9927afd0106..931c274fe26809 100644
> --- a/drivers/i2c/i2c-core-smbus.c
> +++ b/drivers/i2c/i2c-core-smbus.c
> @@ -18,6 +18,7 @@
>  #include <linux/err.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-smbus.h>
> +#include <linux/slab.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/smbus.h>
> @@ -291,6 +292,22 @@ s32 i2c_smbus_write_i2c_block_data(const struct i2c_client *client, u8 command,
>  }
>  EXPORT_SYMBOL(i2c_smbus_write_i2c_block_data);
>  
> +static void i2c_smbus_try_get_dmabuf(struct i2c_msg *msg, u8 init_val)
> +{
> +	bool is_read = msg->flags & I2C_M_RD;
> +	unsigned char *dma_buf;
> +
> +	dma_buf = kzalloc(I2C_SMBUS_BLOCK_MAX + (is_read ? 2 : 3), GFP_KERNEL);
> +	if (!dma_buf)
> +		return;
> +
> +	msg->buf = dma_buf;
> +	msg->flags |= I2C_M_DMA_SAFE;
> +
> +	if (init_val)
> +		msg->buf[0] = init_val;
> +
> +}
>  /* Simulate a SMBus command using the i2c protocol
>     No checking of parameters is done!  */
>  static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
> @@ -368,6 +385,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
>  			msg[1].flags |= I2C_M_RECV_LEN;
>  			msg[1].len = 1; /* block length will be added by
>  					   the underlying bus driver */
> +			i2c_smbus_try_get_dmabuf(&msg[1], 0);
>  		} else {
>  			msg[0].len = data->block[0] + 2;
>  			if (msg[0].len > I2C_SMBUS_BLOCK_MAX + 2) {
> @@ -376,8 +394,10 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
>  					data->block[0]);
>  				return -EINVAL;
>  			}
> +
> +			i2c_smbus_try_get_dmabuf(&msg[0], command);
>  			for (i = 1; i < msg[0].len; i++)
> -				msgbuf0[i] = data->block[i-1];
> +				msg[0].buf[i] = data->block[i-1];
>  		}
>  		break;
>  	case I2C_SMBUS_BLOCK_PROC_CALL:
> @@ -389,16 +409,21 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
>  				data->block[0]);
>  			return -EINVAL;
>  		}
> +
>  		msg[0].len = data->block[0] + 2;
> +		i2c_smbus_try_get_dmabuf(&msg[0], command);
>  		for (i = 1; i < msg[0].len; i++)
> -			msgbuf0[i] = data->block[i-1];
> +			msg[0].buf[i] = data->block[i-1];
> +
>  		msg[1].flags |= I2C_M_RECV_LEN;
>  		msg[1].len = 1; /* block length will be added by
>  				   the underlying bus driver */
> +		i2c_smbus_try_get_dmabuf(&msg[1], 0);
>  		break;
>  	case I2C_SMBUS_I2C_BLOCK_DATA:
>  		if (read_write == I2C_SMBUS_READ) {
>  			msg[1].len = data->block[0];
> +			i2c_smbus_try_get_dmabuf(&msg[1], 0);
>  		} else {
>  			msg[0].len = data->block[0] + 1;
>  			if (msg[0].len > I2C_SMBUS_BLOCK_MAX + 1) {
> @@ -407,8 +432,10 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
>  					data->block[0]);
>  				return -EINVAL;
>  			}
> +
> +			i2c_smbus_try_get_dmabuf(&msg[0], command);
>  			for (i = 1; i <= data->block[0]; i++)
> -				msgbuf0[i] = data->block[i];
> +				msg[0].buf[i] = data->block[i];
>  		}
>  		break;
>  	default:
> @@ -456,14 +483,20 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
>  			break;
>  		case I2C_SMBUS_I2C_BLOCK_DATA:
>  			for (i = 0; i < data->block[0]; i++)
> -				data->block[i+1] = msgbuf1[i];
> +				data->block[i+1] = msg[1].buf[i];
>  			break;
>  		case I2C_SMBUS_BLOCK_DATA:
>  		case I2C_SMBUS_BLOCK_PROC_CALL:
> -			for (i = 0; i < msgbuf1[0] + 1; i++)
> -				data->block[i] = msgbuf1[i];
> +			for (i = 0; i < msg[1].buf[0] + 1; i++)
> +				data->block[i] = msg[1].buf[i];
>  			break;
>  		}
> +
> +	if (msg[0].flags & I2C_M_DMA_SAFE)
> +		kfree(msg[0].buf);
> +	if (msg[1].flags & I2C_M_DMA_SAFE)
> +		kfree(msg[1].buf);
> +
>  	return 0;
>  }
>  
