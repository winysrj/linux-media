Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60914 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaJATWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 15:22:15 -0400
Message-ID: <542C5462.5090406@iki.fi>
Date: Wed, 01 Oct 2014 22:22:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH V2 04/13] cx231xx: give each master i2c bus a seperate
 name
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org> <1412140821-16285-5-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-5-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/01/2014 08:20 AM, Matthias Schwarzott wrote:
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-i2c.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index a30d400..178fa48 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -506,6 +506,7 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
>   int cx231xx_i2c_register(struct cx231xx_i2c *bus)
>   {
>   	struct cx231xx *dev = bus->dev;
> +	char bus_name[3];
>
>   	BUG_ON(!dev->cx231xx_send_usb_command);
>
> @@ -513,6 +514,10 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
>   	bus->i2c_adap.dev.parent = &dev->udev->dev;
>
>   	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
> +	bus_name[0] = '-';
> +	bus_name[1] = '0' + bus->nr;
> +	bus_name[2] = '\0';
> +	strlcat(bus->i2c_adap.name, bus_name, sizeof(bus->i2c_adap.name));

I am still thinking that. Isn't there any better alternative for this 
kind homemade number to string conversion? It is trivial, but for 
something on my head says we should avoid that kind of string 
manipulation...

printf? num_to_str?


dunno

Antti

>
>   	bus->i2c_adap.algo_data = bus;
>   	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
>

-- 
http://palosaari.fi/
