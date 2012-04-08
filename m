Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2DHLYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2012 07:24:07 -0400
Date: Sun, 8 Apr 2012 13:23:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 2/2] ARM: mach-shmobile: sh7372 CEU supports up to
 8188x8188 images
In-Reply-To: <Pine.LNX.4.64.1203141601060.25284@axis700.grange>
Message-ID: <Pine.LNX.4.64.1204081319520.29005@axis700.grange>
References: <Pine.LNX.4.64.1203141600210.25284@axis700.grange>
 <Pine.LNX.4.64.1203141601060.25284@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 14 Mar 2012, Guennadi Liakhovetski wrote:

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> This patch we can push some time after the first one in this series gets 
> in, no breakage is caused.

Patch 1/2 from this series is now in the mainline, so, also this patch can 
be applied now. Not sure whether this qualifies as a fix (in the sense, 
that the default maximum sizes of 2560x1920, used without this patch are 
wrong for sh7372). Please, either push for 3.4 or queue for 3.5 
accordingly.

Thanks
Guennadi

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
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
