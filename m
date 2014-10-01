Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42961 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaJATrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 15:47:05 -0400
Message-ID: <542C5A35.1040005@iki.fi>
Date: Wed, 01 Oct 2014 22:47:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH V2 13/13] cx231xx: scan all four existing i2c busses instead
 of the 3 masters
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org> <1412140821-16285-14-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-14-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

btw. is there some reason you those on that order? I mean you scan I2C_2 
between MUX segments?

Antti

On 10/01/2014 08:20 AM, Matthias Schwarzott wrote:
> The scanning itself just fails (as before this series) but now the correct busses are scanned.
>
> V2: Changed to symbolic names where muxed adapters can be seen directly.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-core.c | 6 ++++++
>   drivers/media/usb/cx231xx/cx231xx-i2c.c  | 8 ++++----
>   2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
> index c49022f..60dbbbb 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-core.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-core.c
> @@ -1303,6 +1303,12 @@ int cx231xx_dev_init(struct cx231xx *dev)
>   	cx231xx_i2c_mux_register(dev, 0);
>   	cx231xx_i2c_mux_register(dev, 1);
>
> +	/* scan the real bus segments */
> +	cx231xx_do_i2c_scan(dev, I2C_0);
> +	cx231xx_do_i2c_scan(dev, I2C_1_MUX_1);
> +	cx231xx_do_i2c_scan(dev, I2C_2);
> +	cx231xx_do_i2c_scan(dev, I2C_1_MUX_3);
> +
>   	/* init hardware */
>   	/* Note : with out calling set power mode function,
>   	afe can not be set up correctly */
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index bb82e6d..0df50d3 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -492,6 +492,9 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
>   	int i, rc;
>   	struct i2c_client client;
>
> +	if (!i2c_scan)
> +		return;
> +
>   	memset(&client, 0, sizeof(client));
>   	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
>
> @@ -533,10 +536,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
>   	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
>   	i2c_add_adapter(&bus->i2c_adap);
>
> -	if (0 == bus->i2c_rc) {
> -		if (i2c_scan)
> -			cx231xx_do_i2c_scan(dev, bus->nr);
> -	} else
> +	if (0 != bus->i2c_rc)
>   		cx231xx_warn("%s: i2c bus %d register FAILED\n",
>   			     dev->name, bus->nr);
>
>

-- 
http://palosaari.fi/
