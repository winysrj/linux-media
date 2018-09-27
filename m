Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59492 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728582AbeI1Bwr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 21:52:47 -0400
Date: Thu, 27 Sep 2018 22:32:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v4 5/7] [media] ad5820: Add support for acpi autoload
Message-ID: <20180927193256.z3n5eaqroomrv62i@valkosipuli.retiisi.org.uk>
References: <20180920204751.29117-1-ricardo.ribalda@gmail.com>
 <20180920204751.29117-5-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920204751.29117-5-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Thu, Sep 20, 2018 at 10:47:49PM +0200, Ricardo Ribalda Delgado wrote:
> Allow module autoloading of ad5820 ACPI devices.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/i2c/ad5820.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> index e461d36201a4..5d1185e7f78d 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -22,6 +22,7 @@
>   * General Public License for more details.
>   */
>  
> +#include <linux/acpi.h>
>  #include <linux/errno.h>
>  #include <linux/i2c.h>
>  #include <linux/kernel.h>
> @@ -380,6 +381,15 @@ static const struct of_device_id ad5820_of_table[] = {
>  MODULE_DEVICE_TABLE(of, ad5820_of_table);
>  #endif
>  
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id ad5820_acpi_ids[] = {
> +	{ "AD5820" },

This is not a valid ACPI _HID. Is there a need to add ACPI support for the
chip this way?

> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(acpi, ad5820_acpi_ids);
> +#endif
> +
>  static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
>  
>  static struct i2c_driver ad5820_i2c_driver = {
> @@ -387,6 +397,7 @@ static struct i2c_driver ad5820_i2c_driver = {
>  		.name	= AD5820_NAME,
>  		.pm	= &ad5820_pm,
>  		.of_match_table = of_match_ptr(ad5820_of_table),
> +		.acpi_match_table = ACPI_PTR(ad5820_acpi_ids),
>  	},
>  	.probe		= ad5820_probe,
>  	.remove		= ad5820_remove,

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
