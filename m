Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34092 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3B1CmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 21:42:01 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MIW00DTHSTVQJI0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Feb 2013 11:42:00 +0900 (KST)
Received: from [10.90.51.60] by mmp1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MIW00BNQSTZ6320@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Feb 2013 11:41:59 +0900 (KST)
Message-id: <512EC410.3050301@samsung.com>
Date: Thu, 28 Feb 2013 11:42:24 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, inki.dae@samsung.com, l.krishna@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	t.figa@samsung.com
Subject: Re: [PATCH] drm/exynos: modify the compatible string for exynos fimd
References: <1361961178-1912-1-git-send-email-vikas.sajjan@linaro.org>
In-reply-to: <1361961178-1912-1-git-send-email-vikas.sajjan@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/2013 07:32 PM, Vikas Sajjan wrote:
> modified compatible string for exynos4 fimd as "exynos4210-fimd" and
> exynos5 fimd as "exynos5250-fimd" to stick to the rule that compatible
> value should be named after first specific SoC model in which this
> particular IP version was included as discussed at
> https://patchwork.kernel.org/patch/2144861/
>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 9537761..433ed35 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -109,9 +109,9 @@ struct fimd_context {
>   
>   #ifdef CONFIG_OF
>   static const struct of_device_id fimd_driver_dt_match[] = {
> -	{ .compatible = "samsung,exynos4-fimd",
> +	{ .compatible = "samsung,exynos4210-fimd",
>   	  .data = &exynos4_fimd_driver_data },
> -	{ .compatible = "samsung,exynos5-fimd",
> +	{ .compatible = "samsung,exynos5250-fimd",
>   	  .data = &exynos5_fimd_driver_data },
>   	{},
>   };

Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>

Thanks.
