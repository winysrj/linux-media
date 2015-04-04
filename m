Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([178.209.37.122]:37088 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbbDDAVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 20:21:34 -0400
Date: Sat, 4 Apr 2015 02:17:29 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 10/14] ARM: orion: use clkdev_create()
Message-ID: <20150404001729.GA14824@lunn.ch>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
 <E1Ye59d-0001BZ-Sv@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ye59d-0001BZ-Sv@rmk-PC.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 03, 2015 at 06:13:13PM +0100, Russell King wrote:
> clkdev_create() is a shorter way to write clkdev_alloc() followed by
> clkdev_add().  Use this instead.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew

> ---
>  arch/arm/plat-orion/common.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
> index f5b00f41c4f6..2235081a04ee 100644
> --- a/arch/arm/plat-orion/common.c
> +++ b/arch/arm/plat-orion/common.c
> @@ -28,11 +28,7 @@
>  void __init orion_clkdev_add(const char *con_id, const char *dev_id,
>  			     struct clk *clk)
>  {
> -	struct clk_lookup *cl;
> -
> -	cl = clkdev_alloc(clk, con_id, dev_id);
> -	if (cl)
> -		clkdev_add(cl);
> +	clkdev_create(clk, con_id, "%s", dev_id);
>  }
>  
>  /* Create clkdev entries for all orion platforms except kirkwood.
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
