Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55431 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaJBFZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 01:25:08 -0400
Message-ID: <542CE1B0.1000903@iki.fi>
Date: Thu, 02 Oct 2014 08:25:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH V3 04/13] cx231xx: give each master i2c bus a seperate
 name
References: <1412227265-17453-1-git-send-email-zzam@gentoo.org> <1412227265-17453-5-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412227265-17453-5-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/2014 08:20 AM, Matthias Schwarzott wrote:
> V2: Use snprintf to construct the complete name
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-i2c.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index a30d400..b10f482 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -506,13 +506,14 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
>   int cx231xx_i2c_register(struct cx231xx_i2c *bus)
>   {
>   	struct cx231xx *dev = bus->dev;
> +	char bus_name[3];

you don't need that variable anymore :]

>
>   	BUG_ON(!dev->cx231xx_send_usb_command);
>
>   	bus->i2c_adap = cx231xx_adap_template;
>   	bus->i2c_adap.dev.parent = &dev->udev->dev;
>
> -	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
> +	snprintf(bus->i2c_adap.name, sizeof(bus->i2c_adap.name), "%s-%d", bus->dev->name, bus->nr);
>
>   	bus->i2c_adap.algo_data = bus;
>   	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
>

With a correction for small mistake I mentioned:
Reviewed-by: Antti Palosaari <crope@iki.fi>

regards
Antti

-- 
http://palosaari.fi/
