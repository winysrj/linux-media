Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52066 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750966AbdBKWHz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Feb 2017 17:07:55 -0500
Date: Sun, 12 Feb 2017 00:07:52 +0200
From: Sakari <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smiapp: add CCP2 support
Message-ID: <20170211220752.zr3j7irpxl42ewo3@ihha.localdomain>
References: <20170208131127.GA29237@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170208131127.GA29237@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, Pavel! :-)

Besides this patch, what else is needed? The CSI-2 / CCP2 support is
missing in V4L2 OF at least. It'd be better to have this all in the same
set.

I pushed the two DT patches here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=ccp2>

On Wed, Feb 08, 2017 at 02:11:27PM +0100, Pavel Machek wrote:
> 
> Add support for CCP2 connected SMIA sensors as found
> on the Nokia N900.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 44f8c7e..c217bc6 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2997,13 +2997,19 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
>  	switch (bus_cfg->bus_type) {
>  	case V4L2_MBUS_CSI2:
>  		hwcfg->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
> +		hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
> +		break;
> +	case V4L2_MBUS_CCP2:
> +		hwcfg->csi_signalling_mode = (bus_cfg->bus.mipi_csi1.strobe) ?
> +		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE :
> +		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK;
> +		hwcfg->lanes = 1;
>  		break;
> -		/* FIXME: add CCP2 support. */
>  	default:
> +		dev_err(dev, "unknown bus protocol\n");

It's rather unsupported --- V4L2 OF framework picks one from enum
v4l2_mbus_type. You might want to print the value, too. Up to you.

>  		goto out_err;
>  	}
>  
> -	hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
>  	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
>  
>  	/* NVM size is not mandatory */
> @@ -3017,8 +3023,8 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
>  		goto out_err;
>  	}
>  
> -	dev_dbg(dev, "nvm %d, clk %d, csi %d\n", hwcfg->nvm_size,
> -		hwcfg->ext_clk, hwcfg->csi_signalling_mode);
> +	dev_dbg(dev, "nvm %d, clk %d, mode %d\n",
> +		hwcfg->nvm_size, hwcfg->ext_clk, hwcfg->csi_signalling_mode);
>  
>  	if (!bus_cfg->nr_of_link_frequencies) {
>  		dev_warn(dev, "no link frequencies defined\n");
> 


-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi		XMPP: sailus@retiisi.org.uk
