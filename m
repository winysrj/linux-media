Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36013 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032568AbeCAPsC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 10:48:02 -0500
Received: by mail-wm0-f68.google.com with SMTP id 188so12944999wme.1
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2018 07:48:01 -0800 (PST)
Date: Thu, 1 Mar 2018 16:47:59 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] media: i2c: adv748x: Simplify regmap configuration
Message-ID: <20180301154759.GD19122@bigcity.dyn.berto.se>
References: <1519743950-28346-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1519743950-28346-2-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1519743950-28346-2-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your patch,

On 2018-02-27 15:05:48 +0000, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> The ADV748x has identical map configurations for each register map. The
> duplication of each map can be simplified using a helper macro such that
> each map is represented on a single line.
> 
> Define ADV748X_REGMAP_CONF for this purpose use it to create the tables.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> 
> ---
> v2:
>  - Remove unnecessary #undef
> 
>  drivers/media/i2c/adv748x/adv748x-core.c | 109 ++++++-------------------------
>  1 file changed, 20 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index fd92c9e4b519..faf73949962b 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -35,96 +35,27 @@
>   * Register manipulation
>   */
>  
> -static const struct regmap_config adv748x_regmap_cnf[] = {
> -	{
> -		.name			= "io",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "dpll",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "cp",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "hdmi",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "edid",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "repeater",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "infoframe",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "cec",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "sdp",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -
> -	{
> -		.name			= "txb",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> -
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> -	{
> -		.name			= "txa",
> -		.reg_bits		= 8,
> -		.val_bits		= 8,
> +#define ADV748X_REGMAP_CONF(n) \
> +{ \
> +	.name = n, \
> +	.reg_bits = 8, \
> +	.val_bits = 8, \
> +	.max_register = 0xff, \
> +	.cache_type = REGCACHE_NONE, \
> +}
>  
> -		.max_register		= 0xff,
> -		.cache_type		= REGCACHE_NONE,
> -	},
> +static const struct regmap_config adv748x_regmap_cnf[] = {
> +	ADV748X_REGMAP_CONF("io"),
> +	ADV748X_REGMAP_CONF("dpll"),
> +	ADV748X_REGMAP_CONF("cp"),
> +	ADV748X_REGMAP_CONF("hdmi"),
> +	ADV748X_REGMAP_CONF("edid"),
> +	ADV748X_REGMAP_CONF("repeater"),
> +	ADV748X_REGMAP_CONF("infoframe"),
> +	ADV748X_REGMAP_CONF("cec"),
> +	ADV748X_REGMAP_CONF("sdp"),
> +	ADV748X_REGMAP_CONF("txa"),
> +	ADV748X_REGMAP_CONF("txb"),
>  };
>  
>  static int adv748x_configure_regmap(struct adv748x_state *state, int region)
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
