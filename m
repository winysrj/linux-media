Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:10115 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3CGIEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 03:04:41 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MJA00JEJ6FFT3H0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 17:04:39 +0900 (KST)
From: Inki Dae <inki.dae@samsung.com>
To: 'Vikas Sajjan' <vikas.sajjan@linaro.org>,
	dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	l.krishna@samsung.com, joshi@samsung.com,
	linaro-kernel@lists.linaro.org
References: <1362641984-2706-1-git-send-email-vikas.sajjan@linaro.org>
 <1362641984-2706-3-git-send-email-vikas.sajjan@linaro.org>
In-reply-to: <1362641984-2706-3-git-send-email-vikas.sajjan@linaro.org>
Subject: RE: [PATCH v12 2/2] drm/exynos: enable OF_VIDEOMODE and
 FB_MODE_HELPERS for exynos drm fimd
Date: Thu, 07 Mar 2013 17:04:38 +0900
Message-id: <015c01ce1b0a$6a7887f0$3f6997d0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Vikas Sajjan
> Sent: Thursday, March 07, 2013 4:40 PM
> To: dri-devel@lists.freedesktop.org
> Cc: linux-media@vger.kernel.org; kgene.kim@samsung.com;
> inki.dae@samsung.com; l.krishna@samsung.com; joshi@samsung.com; linaro-
> kernel@lists.linaro.org
> Subject: [PATCH v12 2/2] drm/exynos: enable OF_VIDEOMODE and
> FB_MODE_HELPERS for exynos drm fimd
> 
> patch adds "select OF_VIDEOMODE" and "select FB_MODE_HELPERS" when
> EXYNOS_DRM_FIMD config is selected.
> 
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/exynos/Kconfig
> b/drivers/gpu/drm/exynos/Kconfig
> index 046bcda..bb25130 100644
> --- a/drivers/gpu/drm/exynos/Kconfig
> +++ b/drivers/gpu/drm/exynos/Kconfig
> @@ -25,6 +25,8 @@ config DRM_EXYNOS_DMABUF
>  config DRM_EXYNOS_FIMD
>  	bool "Exynos DRM FIMD"
>  	depends on DRM_EXYNOS && !FB_S3C && !ARCH_MULTIPLATFORM

Again, you missed 'OF' dependency. At least, let's have build testing surely
before posting :)

Thanks,
Inki Dae

> +	select OF_VIDEOMODE
> +	select FB_MODE_HELPERS
>  	help
>  	  Choose this option if you want to use Exynos FIMD for DRM.
> 
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

