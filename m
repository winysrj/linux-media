Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51616 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2GZOmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 10:42:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 01/13] ARM: Samsung: Extend MIPI PHY callback with an index argument
Date: Thu, 26 Jul 2012 16:42:49 +0200
Message-ID: <3148357.irbGOBJ73x@avalon>
In-Reply-To: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 25 May 2012 21:52:40 Sylwester Nawrocki wrote:
> For systems instantiated from device tree struct platform_device id
> field is always -1, add an 'id' argument to the s5p_csis_phy_enable()
> function so the MIPI-CSIS hardware instance index can be passed in
> by driver, for CONFIG_OF=y.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/plat-s5p/setup-mipiphy.c              |   20 ++++++++------------
>  arch/arm/plat-samsung/include/plat/mipi_csis.h |   10 ++++++----
>  2 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/plat-s5p/setup-mipiphy.c
> b/arch/arm/plat-s5p/setup-mipiphy.c index 683c466..146ecc3 100644
> --- a/arch/arm/plat-s5p/setup-mipiphy.c
> +++ b/arch/arm/plat-s5p/setup-mipiphy.c
> @@ -14,24 +14,19 @@
>  #include <linux/spinlock.h>
>  #include <mach/regs-clock.h>
> 
> -static int __s5p_mipi_phy_control(struct platform_device *pdev,
> +static int __s5p_mipi_phy_control(struct platform_device *pdev, int id,
>  				  bool on, u32 reset)

What about removing the pdev argument, as it's now not needed ?

-- 
Regards,

Laurent Pinchart

