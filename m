Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36184 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbeIUBzW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 21:55:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 4/4] [media] ad5820: Add support for of-autoload
Date: Thu, 20 Sep 2018 23:10:23 +0300
Message-ID: <2401971.XiI38RXFgU@avalon>
In-Reply-To: <20180920183151.2933-1-ricardo.ribalda@gmail.com>
References: <20180920161912.17063-4-ricardo.ribalda@gmail.com> <20180920183151.2933-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Thursday, 20 September 2018 21:31:51 EEST Ricardo Ribalda Delgado wrote:
> Since kernel 4.16, i2c devices with DT compatible tag are modprobed
> using their DT modalias.
> Without this patch, if this driver is build as module it would never
> be autoprobed.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/i2c/ad5820.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> index 20931217e3b1..75b9b8aa5533 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -375,12 +375,19 @@ static const struct i2c_device_id ad5820_id_table[] =
> { };
>  MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
> 
> +static const struct of_device_id ad5820_of_table[] = {
> +	{ .compatible = "adi,"AD5820_NAME },

I'd spell this out explicitly, to make it easier to grep for the compatible 
string.

> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ad5820_of_table);
> +
>  static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
> 
>  static struct i2c_driver ad5820_i2c_driver = {
>  	.driver		= {
>  		.name	= AD5820_NAME,
>  		.pm	= &ad5820_pm,
> +		.of_match_table = ad5820_of_table,

As the driver doesn't depend on CONFIG_OF, would it make sense to use 
of_config_ptr() (and to compile the of table conditionally on CONFIG_OF) ?

>  	},
>  	.probe		= ad5820_probe,
>  	.remove		= ad5820_remove,

-- 
Regards,

Laurent Pinchart
