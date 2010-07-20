Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:7828 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105Ab0GTHab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 03:30:31 -0400
Date: Tue, 20 Jul 2010 08:42:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Kenney Phillisjr <kphillisjr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 04/17] cx25840: Make cx25840 i2c register read
 transactions  atomic
Message-ID: <20100720084217.4ab937a7@hyperion.delvare>
In-Reply-To: <1279588306.28153.6.camel@localhost>
References: <cover.1279586511.git.awalls@md.metrocast.net>
	<1279588306.28153.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Mon, 19 Jul 2010 21:11:46 -0400, Andy Walls wrote:
> There was a small window between writing the cx25840 register
> address over the i2c bus and reading the register contents back from the
> cx25840 device that the i2c adapter lock was released.  This change ensures the
> adapter lock is not released until the register read is done.
> 
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>

Good catch.

Acked-by: Jean Delvare <khali@linux-fr.org>

Note that cx25840_and_or() still has a (smaller and less dangerous)
race window. If several calls to cx25840_and_or() happen in parallel on
the same register, some of the changes may be lost. I don't know if
this can be a problem in practice though. If it is, then additional
locking around cx25840_and_or() would be needed.

> ---
>  drivers/media/video/cx25840/cx25840-core.c |   58 +++++++++++++++++++---------
>  1 files changed, 39 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
> index bb4872b..4f908fa 100644
> --- a/drivers/media/video/cx25840/cx25840-core.c
> +++ b/drivers/media/video/cx25840/cx25840-core.c
> @@ -80,33 +80,53 @@ int cx25840_write4(struct i2c_client *client, u16 addr, u32 value)
>  
>  u8 cx25840_read(struct i2c_client * client, u16 addr)
>  {
> -	u8 buffer[2];
> -	buffer[0] = addr >> 8;
> -	buffer[1] = addr & 0xff;
> -
> -	if (i2c_master_send(client, buffer, 2) < 2)
> -		return 0;
> -
> -	if (i2c_master_recv(client, buffer, 1) < 1)
> +	struct i2c_msg msgs[2];
> +	u8 tx_buf[2], rx_buf[1];
> +
> +	/* Write register address */
> +	tx_buf[0] = addr >> 8;
> +	tx_buf[1] = addr & 0xff;
> +	msgs[0].addr = client->addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 2;
> +	msgs[0].buf = (char *) tx_buf;
> +
> +	/* Read data from register */
> +	msgs[1].addr = client->addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = 1;
> +	msgs[1].buf = (char *) rx_buf;
> +
> +	if (i2c_transfer(client->adapter, msgs, 2) < 2)
>  		return 0;
>  
> -	return buffer[0];
> +	return rx_buf[0];
>  }
>  
>  u32 cx25840_read4(struct i2c_client * client, u16 addr)
>  {
> -	u8 buffer[4];
> -	buffer[0] = addr >> 8;
> -	buffer[1] = addr & 0xff;
> -
> -	if (i2c_master_send(client, buffer, 2) < 2)
> -		return 0;
> -
> -	if (i2c_master_recv(client, buffer, 4) < 4)
> +	struct i2c_msg msgs[2];
> +	u8 tx_buf[2], rx_buf[4];
> +
> +	/* Write register address */
> +	tx_buf[0] = addr >> 8;
> +	tx_buf[1] = addr & 0xff;
> +	msgs[0].addr = client->addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 2;
> +	msgs[0].buf = (char *) tx_buf;
> +
> +	/* Read data from registers */
> +	msgs[1].addr = client->addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = 4;
> +	msgs[1].buf = (char *) rx_buf;
> +
> +	if (i2c_transfer(client->adapter, msgs, 2) < 2)
>  		return 0;
>  
> -	return (buffer[3] << 24) | (buffer[2] << 16) |
> -	    (buffer[1] << 8) | buffer[0];
> +	return (rx_buf[3] << 24) | (rx_buf[2] << 16) | (rx_buf[1] << 8) |
> +		rx_buf[0];
>  }
>  
>  int cx25840_and_or(struct i2c_client *client, u16 addr, unsigned and_mask,


-- 
Jean Delvare
