Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:41773 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbbDCXxc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 19:53:32 -0400
Date: Fri, 3 Apr 2015 16:49:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 11/14] ARM: omap2: use clkdev_create()
Message-ID: <20150403234937.GE18048@atomide.com>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
 <E1Ye59j-0001Bd-0T@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ye59j-0001Bd-0T@rmk-PC.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Russell King <rmk+kernel@arm.linux.org.uk> [150403 10:14]:
> Rather than open coding the clkdev allocation, initialisation and
> addition, use the clkdev_create() helper.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
> index 85e0b0c06718..b64d717bfab6 100644
> --- a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
> +++ b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
> @@ -232,14 +232,12 @@ void omap2xxx_clkt_vps_init(void)
>  	struct clk_hw_omap *hw = NULL;
>  	struct clk *clk;
>  	const char *parent_name = "mpu_ck";
> -	struct clk_lookup *lookup = NULL;
>  
>  	omap2xxx_clkt_vps_late_init();
>  	omap2xxx_clkt_vps_check_bootloader_rates();
>  
>  	hw = kzalloc(sizeof(*hw), GFP_KERNEL);
> -	lookup = kzalloc(sizeof(*lookup), GFP_KERNEL);
> -	if (!hw || !lookup)
> +	if (!hw)
>  		goto cleanup;
>  	init.name = "virt_prcm_set";
>  	init.ops = &virt_prcm_set_ops;
> @@ -249,15 +247,9 @@ void omap2xxx_clkt_vps_init(void)
>  	hw->hw.init = &init;
>  
>  	clk = clk_register(NULL, &hw->hw);
> -
> -	lookup->dev_id = NULL;
> -	lookup->con_id = "cpufreq_ck";
> -	lookup->clk = clk;
> -
> -	clkdev_add(lookup);
> +	clkdev_create(clk, "cpufreq_ck", NULL);
>  	return;
>  cleanup:
>  	kfree(hw);
> -	kfree(lookup);
>  }
>  #endif
> -- 
> 1.8.3.1
> 
