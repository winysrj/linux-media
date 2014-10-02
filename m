Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54597 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaJBFeh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 01:34:37 -0400
Message-ID: <542CE3E8.2050705@iki.fi>
Date: Thu, 02 Oct 2014 08:34:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH V3 08/13] cx231xx: remember status of i2c port_3 switch
References: <1412227265-17453-1-git-send-email-zzam@gentoo.org> <1412227265-17453-9-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412227265-17453-9-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/02/2014 08:21 AM, Matthias Schwarzott wrote:
> This is used later for is_tuner function that switches i2c behaviour for
> some tuners.
>
> V2: Add comments about possible improvements for port_3 switch function.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-avcore.c | 10 ++++++++++
>   drivers/media/usb/cx231xx/cx231xx.h        |  1 +
>   2 files changed, 11 insertions(+)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
> index 40a6987..148b5fa 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
> @@ -1272,6 +1272,12 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
>
>   	if (dev->board.dont_use_port_3)
>   		is_port_3 = false;
> +
> +	/* Should this code check dev->port_3_switch_enabled first */
> +	/* to skip unnecessary reading of the register? */
> +	/* If yes, the flag dev->port_3_switch_enabled must be initialized */
> +	/* correctly. */

That multiline comment is violates Linux CodingStyle. See 
Documentation/CodingStyle

> +
>   	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
>   				       PWR_CTL_EN, value, 4);
>   	if (status < 0)
> @@ -1294,6 +1300,10 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
>   	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
>   					PWR_CTL_EN, value, 4);
>
> +	/* remember status of the switch for usage in is_tuner */
> +	if (status >= 0)
> +		dev->port_3_switch_enabled = is_port_3;
> +
>   	return status;
>
>   }
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index f03338b..8a3c97b 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -629,6 +629,7 @@ struct cx231xx {
>   	/* I2C adapters: Master 1 & 2 (External) & Master 3 (Internal only) */
>   	struct cx231xx_i2c i2c_bus[3];
>   	unsigned int xc_fw_load_done:1;
> +	unsigned int port_3_switch_enabled:1;
>   	/* locks */
>   	struct mutex gpio_i2c_lock;
>   	struct mutex i2c_lock;
>

I trust functionality is correct. However, I expected to see mux 
switching logic inside mux select() / deselect(), maybe with caching mux 
switch position in order to avoid I/O needed for checking mux switch 
position.

But as I don't know that driver internals very well, I am not adding 
reviewed by tag, which does not mean that is wrong. It is simply because 
I don't know.

regards
Antti

-- 
http://palosaari.fi/
