Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2GPJPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 05:15:18 -0400
Date: Mon, 16 Jul 2012 11:15:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 06/13] media: s5p-fimc: Add device tree support for
 FIMC-LITE
In-Reply-To: <1337975573-27117-6-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1207161114130.12302@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
 <1337975573-27117-6-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 May 2012, Sylwester Nawrocki wrote:

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../bindings/camera/soc/samsung-fimc.txt           |   15 ++++
>  drivers/media/video/s5p-fimc/fimc-lite.c           |   73 ++++++++++++++------
>  2 files changed, 67 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> index 1ec48e9..b459da2 100644
> --- a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> @@ -39,6 +39,21 @@ Required properties:
>  	       depends on the SoC revision. For S5PV210 valid values are:
>  	       0...2, for Exynos4x1x: 0...3.
>  
> +
> +'fimc-lite' device node
> +-----------------------
> +
> +Required properties:
> +
> +- compatible : should be one of:
> +		"samsung,exynos4212-fimc";
> +		"samsung,exynos4412-fimc";
> +- reg	     : physical base address and size of the device's memory mapped
> +	       registers;
> +- interrupts : should contain FIMC-LITE interrupt;
> +- cell-index : FIMC-LITE IP instance index;

Same as in an earlier patch - not sure this is needed.

Thanks
Guennadi

> +
> +
>  Example:
>  
>  	fimc0: fimc@11800000 {
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
