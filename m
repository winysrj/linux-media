Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52239 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbcFHKtW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2016 06:49:22 -0400
Date: Wed, 8 Jun 2016 11:49:19 +0100
From: Liviu Dudau <liviu.dudau@arm.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	Kamil Debski <k.debski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] of: reserved_mem: restore old behavior when no region is
 defined
Message-ID: <20160608104919.GI1165@e106497-lin.cambridge.arm.com>
References: <20160607143425.GE1165@e106497-lin.cambridge.arm.com>
 <1465368713-17866-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1465368713-17866-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 08, 2016 at 08:51:53AM +0200, Marek Szyprowski wrote:
> Change return value back to -ENODEV when no region is defined for given
> device. This restores old behavior of this function, as some drivers rely
> on such error code.
> 
> Reported-by: Liviu Dudau <liviu.dudau@arm.com>
> Fixes: 59ce4039727ef40 ("of: reserved_mem: add support for using more than
>        one region for given device")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Reviewed-by: Liviu Dudau <Liviu.Dudau@arm.com>

> ---
>  drivers/of/of_reserved_mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 3cf129f..06af99f 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -334,7 +334,7 @@ int of_reserved_mem_device_init_by_idx(struct device *dev,
>  
>  	target = of_parse_phandle(np, "memory-region", idx);
>  	if (!target)
> -		return -EINVAL;
> +		return -ENODEV;
>  
>  	rmem = __find_rmem(target);
>  	of_node_put(target);
> -- 
> 1.9.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯
