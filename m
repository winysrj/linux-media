Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35131 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754984Ab2JBQcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 12:32:06 -0400
Date: Tue, 2 Oct 2012 09:31:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ido Yariv <ido@wizery.com>
Cc: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] [media] omap3isp: Fix compilation error in
 ispreg.h
Message-ID: <20121002163158.GR4840@atomide.com>
References: <20120927195526.GP4840@atomide.com>
 <1349131591-10804-1-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349131591-10804-1-git-send-email-ido@wizery.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Ido Yariv <ido@wizery.com> [121001 15:48]:
> Commit c49f34bc ("ARM: OMAP2+ Move SoC specific headers to be local to
> mach-omap2") moved omap34xx.h to mach-omap2. This broke omap3isp, as it
> includes omap34xx.h.
> 
> Instead of moving omap34xx to platform_data, simply add the two
> definitions the driver needs and remove the include altogether.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>

I'm assuming that Mauro picks this one up, sorry
for breaking it.

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/media/platform/omap3isp/ispreg.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
> index 084ea77..e2c57f3 100644
> --- a/drivers/media/platform/omap3isp/ispreg.h
> +++ b/drivers/media/platform/omap3isp/ispreg.h
> @@ -27,13 +27,13 @@
>  #ifndef OMAP3_ISP_REG_H
>  #define OMAP3_ISP_REG_H
>  
> -#include <plat/omap34xx.h>
> -
> -
>  #define CM_CAM_MCLK_HZ			172800000	/* Hz */
>  
>  /* ISP Submodules offset */
>  
> +#define L4_34XX_BASE			0x48000000
> +#define OMAP3430_ISP_BASE		(L4_34XX_BASE + 0xBC000)
> +
>  #define OMAP3ISP_REG_BASE		OMAP3430_ISP_BASE
>  #define OMAP3ISP_REG(offset)		(OMAP3ISP_REG_BASE + (offset))
>  
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
