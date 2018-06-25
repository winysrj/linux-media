Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59168 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbeFYIF3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 04:05:29 -0400
Date: Mon, 25 Jun 2018 11:05:25 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: alanx.chiang@intel.com
Cc: linux-media@vger.kernel.org, andy.yeh@intel.com,
        andriy.shevchenko@intel.com, rajmohan.mani@intel.com
Subject: Re: [RESEND PATCH v1 1/2] eeprom: at24: Add support for
 address-width property
Message-ID: <20180625080525.vx2c5uchhzilp6ak@paasikivi.fi.intel.com>
References: <1529911783-28576-1-git-send-email-alanx.chiang@intel.com>
 <1529911783-28576-2-git-send-email-alanx.chiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529911783-28576-2-git-send-email-alanx.chiang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 25, 2018 at 03:29:42PM +0800, alanx.chiang@intel.com wrote:
> From: "alanx.chiang" <alanx.chiang@intel.com>
> 
> Provide a flexible way to determine the addressing bits of eeprom.
> It doesn't need to add acpi or i2c ids for specific modules.
> 
> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> Reviewed-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  drivers/misc/eeprom/at24.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> index 0c125f2..a6fbdae 100644
> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c
> @@ -478,6 +478,22 @@ static void at24_properties_to_pdata(struct device *dev,
>  	if (device_property_present(dev, "no-read-rollover"))
>  		chip->flags |= AT24_FLAG_NO_RDROL;
>  
> +	err = device_property_read_u32(dev, "address-width", &val);
> +	if (!err) {
> +		switch (val) {
> +		case 8:
> +			chip->flags &= ~AT24_FLAG_ADDR16;

I think I'd print a warning here if the bit was set. Perhaps unlikely that
it'd happen but that'd suggest there's a problem nevertheless.

> +			break;
> +		case 16:
> +			chip->flags |= AT24_FLAG_ADDR16;
> +			break;
> +		default:
> +			dev_warn(dev,
> +				"Bad \"address-width\" property: %u\n",

Fits on previous line.

> +				val);
> +		}
> +	}
> +
>  	err = device_property_read_u32(dev, "size", &val);
>  	if (!err)
>  		chip->byte_len = val;

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
