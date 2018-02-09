Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34615 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbeBIPjT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 10:39:19 -0500
Received: by mail-lf0-f66.google.com with SMTP id k19so11795646lfj.1
        for <linux-media@vger.kernel.org>; Fri, 09 Feb 2018 07:39:18 -0800 (PST)
Date: Fri, 9 Feb 2018 16:39:15 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kbingham@kernel.org>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] media: i2c: adv748x: Simplify regmap configuration
Message-ID: <20180209153915.GE7666@bigcity.dyn.berto.se>
References: <1518024886-842-1-git-send-email-kbingham@kernel.org>
 <1518024886-842-2-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1518024886-842-2-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your patch.

On 2018-02-07 17:34:45 +0000, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The ADV748x has identical map configurations for each register map. The
> duplication of each map can be simplified using a helper macro such that
> each map is represented on a single line.
> 
> Define ADV748X_REGMAP_CONF for this purpose and un-define after it's
> use.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 111 ++++++-------------------------
>  1 file changed, 22 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index fd92c9e4b519..71c69b816db2 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -35,98 +35,31 @@
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
> +#undef ADV748X_REGMAP_CONF
> +

Why is this macro undefined here? It have a rather limited scope as it's 
only local to this C file and it have a good prefix of ADV748X_ so 
conflicts are highly unlikely. Is there something I'm missing?

Is it really customary to undefine helper macros like this once they are 
used to populate the structure?

>  static int adv748x_configure_regmap(struct adv748x_state *state, int region)
>  {
>  	int err;
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
