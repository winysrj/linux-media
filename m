Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:39237 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2DPBzH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Apr 2012 21:55:07 -0400
Date: Mon, 16 Apr 2012 10:55:04 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: mach-shmobile: sh7372 CEU supports up to
 8188x8188 images
Message-ID: <20120416015504.GA15753@verge.net.au>
References: <Pine.LNX.4.64.1203141600210.25284@axis700.grange>
 <Pine.LNX.4.64.1203141601060.25284@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203141601060.25284@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 14, 2012 at 04:02:24PM +0100, Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Reviewed-by: Simon Horman <horms@verge.net.au>

> ---
> 
> This patch we can push some time after the first one in this series gets 
> in, no breakage is caused.
> 
>  arch/arm/mach-shmobile/board-ap4evb.c   |    2 ++
>  arch/arm/mach-shmobile/board-mackerel.c |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
> index aab0a34..f67aa03 100644
> --- a/arch/arm/mach-shmobile/board-ap4evb.c
> +++ b/arch/arm/mach-shmobile/board-ap4evb.c
> @@ -1009,6 +1009,8 @@ static struct sh_mobile_ceu_companion csi2 = {
>  
>  static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
>  	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
> +	.max_width = 8188,
> +	.max_height = 8188,
>  	.csi2 = &csi2,
>  };
>  
> diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
> index 9b42fbd..f790772 100644
> --- a/arch/arm/mach-shmobile/board-mackerel.c
> +++ b/arch/arm/mach-shmobile/board-mackerel.c
> @@ -1270,6 +1270,8 @@ static void mackerel_camera_del(struct soc_camera_device *icd)
>  
>  static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
>  	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
> +	.max_width = 8188,
> +	.max_height = 8188,
>  };
>  
>  static struct resource ceu_resources[] = {
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
