Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40090 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727233AbeHaMNj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 08:13:39 -0400
Date: Fri, 31 Aug 2018 11:07:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 1/2] media: dt-bindings: bind nokia,n900-ir to generic
 pwm-ir-tx driver
Message-ID: <20180831080723.3e6uwa5lsjfklhof@valkosipuli.retiisi.org.uk>
References: <20180713122230.19278-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180713122230.19278-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Fri, Jul 13, 2018 at 01:22:29PM +0100, Sean Young wrote:
> The generic pwm-ir-tx driver should work for the Nokia n900.
> 
> Compile tested only.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Cc: Pali Rohár <pali.rohar@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  arch/arm/boot/dts/omap3-n900.dts | 2 +-
>  drivers/media/rc/pwm-ir-tx.c     | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> index 182a53991c90..fd12dea15799 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -154,7 +154,7 @@
>  	};
>  
>  	ir: n900-ir {
> -		compatible = "nokia,n900-ir";
> +		compatible = "nokia,n900-ir", "pwm-ir-tx";
>  		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
>  	};
>  
> diff --git a/drivers/media/rc/pwm-ir-tx.c b/drivers/media/rc/pwm-ir-tx.c
> index 27d0f5837a76..272947b430c8 100644
> --- a/drivers/media/rc/pwm-ir-tx.c
> +++ b/drivers/media/rc/pwm-ir-tx.c
> @@ -30,6 +30,7 @@ struct pwm_ir {
>  };
>  
>  static const struct of_device_id pwm_ir_of_match[] = {
> +	{ .compatible = "nokia,n900-ir" },

Is this change needed as well? I suppose you could add it later if there's
a need to e.g. do something differently for the N900 IR transmitter.

It'd be nice if someone tested it, too...

>  	{ .compatible = "pwm-ir-tx", },
>  	{ },
>  };

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
