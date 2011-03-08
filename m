Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:58978 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab1CHOGQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 09:06:16 -0500
Message-ID: <4D7637D0.4010402@maxwell.research.nokia.com>
Date: Tue, 08 Mar 2011 16:06:08 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: David Cohen <dacohen@gmail.com>
CC: Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	fernando.lugo@ti.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/3] omap3: change ISP's IOMMU da_start address
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com> <1299588365-2749-3-git-send-email-dacohen@gmail.com>
In-Reply-To: <1299588365-2749-3-git-send-email-dacohen@gmail.com>
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

The NULL address is still valid for the MMU. Can the IOVMF_DA_ANON
mapping be specified by the API to be always non-NULL?

This way it would be possible to combine IOVMF_DA_FIXED and
IOVMF_DA_ANON mappings in the same IOMMU while still being able to rely
that IOVMF_DA_ANON mappings would always be non-NULL.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
