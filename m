Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59426 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728278AbeI1BtE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 21:49:04 -0400
Date: Thu, 27 Sep 2018 22:29:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v4 4/7] [media] ad5820: Add support for of-autoload
Message-ID: <20180927192912.hecig4ybp2jnh4ou@valkosipuli.retiisi.org.uk>
References: <20180920204751.29117-1-ricardo.ribalda@gmail.com>
 <20180920204751.29117-4-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920204751.29117-4-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Thu, Sep 20, 2018 at 10:47:48PM +0200, Ricardo Ribalda Delgado wrote:
> Since kernel 4.16, i2c devices with DT compatible tag are modprobed
> using their DT modalias.
> Without this patch, if this driver is build as module it would never
> be autoprobed.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/media/i2c/ad5820.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> index 625867472929..e461d36201a4 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -372,12 +372,21 @@ static const struct i2c_device_id ad5820_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id ad5820_of_table[] = {
> +	{ .compatible = "adi,ad5820" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ad5820_of_table);
> +#endif
> +
>  static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
>  
>  static struct i2c_driver ad5820_i2c_driver = {
>  	.driver		= {
>  		.name	= AD5820_NAME,
>  		.pm	= &ad5820_pm,
> +		.of_match_table = of_match_ptr(ad5820_of_table),

No need to use of_match_ptr() or #ifdef above --- not doing so makes this
work on ACPI, too.

>  	},
>  	.probe		= ad5820_probe,
>  	.remove		= ad5820_remove,

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
