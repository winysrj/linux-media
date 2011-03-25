Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43259 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1CYTIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 15:08:09 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"david.cohen@nokia.com" <david.cohen@nokia.com>,
	"hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>
Date: Sat, 26 Mar 2011 00:37:46 +0530
Subject: RE: [PATCH 1/4] omap iommu: Check existence of arch_iommu
Message-ID: <19F8576C6E063C45BE387C64729E739404E21D57E2@dbde02.ent.ti.com>
References: <4D8CB106.7030608@maxwell.research.nokia.com>
 <1301066005-7882-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1301066005-7882-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Friday, March 25, 2011 8:43 PM
> To: linux-media@vger.kernel.org
> Cc: laurent.pinchart@ideasonboard.com; david.cohen@nokia.com;
> hiroshi.doyu@nokia.com
> Subject: [PATCH 1/4] omap iommu: Check existence of arch_iommu
> 
> Check that the arch_iommu has been installed before trying to use it. This
> will lead to kernel oops if the arch_iommu isn't there.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  arch/arm/plat-omap/iommu.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
> index b1107c0..f0fea0b 100644
> --- a/arch/arm/plat-omap/iommu.c
> +++ b/arch/arm/plat-omap/iommu.c
> @@ -104,6 +104,9 @@ static int iommu_enable(struct iommu *obj)
>  	if (!obj)
>  		return -EINVAL;
> 
> +	if (!arch_iommu)
> +		return -ENOENT;
> +
[Hiremath, Vaibhav] Similar patch has already been submitted and accepted in community, not sure which baseline you are using. Please refer to below commit - 


commit ef4815ab1ff10d642c21ef92faa6544934bc78d1
Author: Martin Hostettler <martin@neutronstar.dyndns.org>
Date:   Thu Feb 24 12:51:31 2011 -0800

    omap: iommu: Gracefully fail iommu_enable if no arch_iommu is registered

    In a modular build of the iommu code it's possible that the arch iommu code
    isn't loaded when trying to enable the iommu. Instead of blindly following a
    null pointer return -NODEV in that case.

    Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index b1107c0..3d8f55e 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -104,6 +104,9 @@ static int iommu_enable(struct iommu *obj)
        if (!obj)
                return -EINVAL;

+       if (!arch_iommu)
+               return -ENODEV;
+
        clk_enable(obj->clk);

        err = arch_iommu->enable(obj);


Thanks,
Vaibhav

>  	clk_enable(obj->clk);
> 
>  	err = arch_iommu->enable(obj);
> --
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
