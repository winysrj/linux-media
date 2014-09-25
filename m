Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44815 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaIYPA2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 11:00:28 -0400
Message-ID: <54242E08.7020307@iki.fi>
Date: Thu, 25 Sep 2014 18:00:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH 03/12] cx231xx: delete i2c_client per bus
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org> <1411621684-8295-3-git-send-email-zzam@gentoo.org>
In-Reply-To: <1411621684-8295-3-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Good catch, certainly pointless to add "dummy" I2C client per adapter. 
Just wastes memory.

Missing patch description.

regards
Antti

On 09/25/2014 08:07 AM, Matthias Schwarzott wrote:
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-i2c.c | 7 -------
>   drivers/media/usb/cx231xx/cx231xx.h     | 1 -
>   2 files changed, 8 deletions(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index 67a1391..a30d400 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -455,10 +455,6 @@ static struct i2c_adapter cx231xx_adap_template = {
>   	.algo = &cx231xx_algo,
>   };
>
> -static struct i2c_client cx231xx_client_template = {
> -	.name = "cx231xx internal",
> -};
> -
>   /* ----------------------------------------------------------- */
>
>   /*
> @@ -514,7 +510,6 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
>   	BUG_ON(!dev->cx231xx_send_usb_command);
>
>   	bus->i2c_adap = cx231xx_adap_template;
> -	bus->i2c_client = cx231xx_client_template;
>   	bus->i2c_adap.dev.parent = &dev->udev->dev;
>
>   	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
> @@ -523,8 +518,6 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
>   	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
>   	i2c_add_adapter(&bus->i2c_adap);
>
> -	bus->i2c_client.adapter = &bus->i2c_adap;
> -
>   	if (0 == bus->i2c_rc) {
>   		if (i2c_scan)
>   			cx231xx_do_i2c_scan(dev, bus->nr);
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index 5efc93e..c92382f 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -472,7 +472,6 @@ struct cx231xx_i2c {
>
>   	/* i2c i/o */
>   	struct i2c_adapter i2c_adap;
> -	struct i2c_client i2c_client;
>   	u32 i2c_rc;
>
>   	/* different settings for each bus */
>

-- 
http://palosaari.fi/
