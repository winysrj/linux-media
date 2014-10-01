Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49025 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaJATg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 15:36:56 -0400
Message-ID: <542C57D4.4000004@iki.fi>
Date: Wed, 01 Oct 2014 22:36:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH V2 08/13] cx231xx: remember status of i2c port_3 switch
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org> <1412140821-16285-9-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-9-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't understand that patch. Commit message should explain it likely 
better details.

You added flag 'port_3_switch_enabled' to device state. That is for I2C 
mux, but what it means? Does it means mux is currently switched to to 
port 3? Later you will use that flag to avoid unnecessary mux switching?

regards
Antti



On 10/01/2014 08:20 AM, Matthias Schwarzott wrote:
> If remembering is not stable enough, this must be changed to query from the register when needed.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-avcore.c | 3 +++
>   drivers/media/usb/cx231xx/cx231xx.h        | 1 +
>   2 files changed, 4 insertions(+)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
> index 40a6987..4c85b6f 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
> @@ -1294,6 +1294,9 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
>   	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
>   					PWR_CTL_EN, value, 4);
>
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

-- 
http://palosaari.fi/
