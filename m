Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44163 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbaIYOuU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 10:50:20 -0400
Message-ID: <54242BA6.2040309@iki.fi>
Date: Thu, 25 Sep 2014 17:50:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH 01/12] cx231xx: let i2c bus scanning use its own i2c_client
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <1411621684-8295-1-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 09/25/2014 08:07 AM, Matthias Schwarzott wrote:
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-i2c.c | 17 +++++++++++------
>   drivers/media/usb/cx231xx/cx231xx.h     |  2 +-
>   2 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index 7c0f797..67a1391 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -480,22 +480,27 @@ static char *i2c_devs[128] = {
>    * cx231xx_do_i2c_scan()
>    * check i2c address range for devices
>    */
> -void cx231xx_do_i2c_scan(struct cx231xx *dev, struct i2c_client *c)
> +void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
>   {
>   	unsigned char buf;
>   	int i, rc;
> +	struct i2c_client client;
>
> -	cx231xx_info(": Checking for I2C devices ..\n");
> +	memset(&client, 0, sizeof(client));
> +	client.adapter = &dev->i2c_bus[i2c_port].i2c_adap;
> +
> +	cx231xx_info(": Checking for I2C devices on port=%d ..\n", i2c_port);
>   	for (i = 0; i < 128; i++) {
> -		c->addr = i;
> -		rc = i2c_master_recv(c, &buf, 0);
> +		client.addr = i;
> +		rc = i2c_master_recv(&client, &buf, 0);
>   		if (rc < 0)
>   			continue;
>   		cx231xx_info("%s: i2c scan: found device @ 0x%x  [%s]\n",
>   			     dev->name, i << 1,
>   			     i2c_devs[i] ? i2c_devs[i] : "???");
>   	}
> -	cx231xx_info(": Completed Checking for I2C devices.\n");
> +	cx231xx_info(": Completed Checking for I2C devices on port=%d.\n",
> +		i2c_port);
>   }
>
>   /*
> @@ -522,7 +527,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
>
>   	if (0 == bus->i2c_rc) {
>   		if (i2c_scan)
> -			cx231xx_do_i2c_scan(dev, &bus->i2c_client);
> +			cx231xx_do_i2c_scan(dev, bus->nr);
>   	} else
>   		cx231xx_warn("%s: i2c bus %d register FAILED\n",
>   			     dev->name, bus->nr);
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index aeb1bf4..5efc93e 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -751,7 +751,7 @@ int cx231xx_set_analog_freq(struct cx231xx *dev, u32 freq);
>   int cx231xx_reset_analog_tuner(struct cx231xx *dev);
>
>   /* Provided by cx231xx-i2c.c */
> -void cx231xx_do_i2c_scan(struct cx231xx *dev, struct i2c_client *c);
> +void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port);
>   int cx231xx_i2c_register(struct cx231xx_i2c *bus);
>   int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
>
>

-- 
http://palosaari.fi/
