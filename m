Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58978 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752049AbdHHLYJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 07:24:09 -0400
Date: Tue, 8 Aug 2017 14:24:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Fabio Estevam <festevam@gmail.com>
Cc: mchehab@s-opensource.com, hans.verkuil@cisco.com, corbet@lwn.net,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: Re: [PATCH 1/2] [media] ov7670: Return the real error code
Message-ID: <20170808112406.gkr2jhedzjkdr2ww@valkosipuli.retiisi.org.uk>
References: <1500435259-5838-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500435259-5838-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 19, 2017 at 12:34:18AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> When devm_clk_get() fails the real error code should be propagated,
> instead of always returning -EPROBE_DEFER.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

Hi Fabio,

I don't think -EPROBE_DEFER is returned by clk_get() if the clock can't be
found. The clock providers often are e.g. ISP drivers that may well be
loaded after the sensor driver. In that case this change would prevent
successful initialisation of the drivers.

> ---
>  drivers/media/i2c/ov7670.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 7270c68..552a881 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -1614,7 +1614,7 @@ static int ov7670_probe(struct i2c_client *client,
>  
>  	info->clk = devm_clk_get(&client->dev, "xclk");
>  	if (IS_ERR(info->clk))
> -		return -EPROBE_DEFER;
> +		return PTR_ERR(info->clk);
>  	clk_prepare_enable(info->clk);
>  
>  	ret = ov7670_init_gpio(client, info);
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
