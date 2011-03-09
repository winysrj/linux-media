Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:18060 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1CIHoR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2011 02:44:17 -0500
Message-ID: <4D772FB0.4020804@maxwell.research.nokia.com>
Date: Wed, 09 Mar 2011 09:43:44 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: David Cohen <dacohen@gmail.com>
CC: Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	fernando.lugo@ti.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 2/3] omap3: change ISP's IOMMU da_start address
References: <1299615316-17512-1-git-send-email-dacohen@gmail.com> <1299615316-17512-3-git-send-email-dacohen@gmail.com>
In-Reply-To: <1299615316-17512-3-git-send-email-dacohen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

David Cohen wrote:
> ISP doesn't consider 0x0 as a valid address, so it should explicitly
> exclude first page from allowed 'da' range.
> 
> Signed-off-by: David Cohen <dacohen@gmail.com>
> ---
>  arch/arm/mach-omap2/omap-iommu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
> index 3fc5dc7..3bea489 100644
> --- a/arch/arm/mach-omap2/omap-iommu.c
> +++ b/arch/arm/mach-omap2/omap-iommu.c
> @@ -33,7 +33,7 @@ static struct iommu_device omap3_devices[] = {
>  			.name = "isp",
>  			.nr_tlb_entries = 8,
>  			.clk_name = "cam_ick",
> -			.da_start = 0x0,
> +			.da_start = 0x1000,
>  			.da_end = 0xFFFFF000,
>  		},
>  	},

Hi David!

Thanks for the patch.

My question is once again: is this necessary? My understanding is that
the IOMMU allows mapping the NULL address if the user wishes to map it
explicitly. da_end specifies the real hardware limit for the mapped top
address, da_start should do the same for bottom.

I think that the IOMMU users should be either able to rely that they get
no NULL allocated automatically for them. Do we want or not want it to
be part of the API? I don't think the ISP driver is a special case of
all the possible drivers using the IOMMU.

On the other hand, probably there will be an API change at some point
for the IOMMU since as far as I remember, there are somewhat
established APIs for IOMMUs in existence.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
