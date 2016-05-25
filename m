Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25837 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbcEYLNv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 07:13:51 -0400
Subject: Re: [PATCH v4 6/7] ARM: dts: exynos: convert MFC device to generic
 reserved memory bindings
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-7-git-send-email-m.szyprowski@samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <574588E8.8050708@samsung.com>
Date: Wed, 25 May 2016 13:13:44 +0200
MIME-version: 1.0
In-reply-to: <1464096690-23605-7-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 03:31 PM, Marek Szyprowski wrote:
> This patch replaces custom properties for defining reserved memory
> regions with generic reserved memory bindings for MFC video codec
> device.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi  | 27 ++++++++++++++++++++++
>  arch/arm/boot/dts/exynos4210-origen.dts            |  4 ++--
>  arch/arm/boot/dts/exynos4210-smdkv310.dts          |  4 ++--
>  arch/arm/boot/dts/exynos4412-origen.dts            |  4 ++--
>  arch/arm/boot/dts/exynos4412-smdk4412.dts          |  4 ++--
>  arch/arm/boot/dts/exynos5250-arndale.dts           |  4 ++--
>  arch/arm/boot/dts/exynos5250-smdk5250.dts          |  4 ++--
>  arch/arm/boot/dts/exynos5250-spring.dts            |  4 ++--
>  arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  4 ++--
>  arch/arm/boot/dts/exynos5420-peach-pit.dts         |  4 ++--
>  arch/arm/boot/dts/exynos5420-smdk5420.dts          |  4 ++--
>  arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |  4 ++--
>  arch/arm/boot/dts/exynos5800-peach-pi.dts          |  4 ++--
>  13 files changed, 51 insertions(+), 24 deletions(-)
>  create mode 100644 arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
> 
> diff --git a/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi b/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
> new file mode 100644
> index 0000000..e7445c9
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
> @@ -0,0 +1,27 @@
> +/*
> + * Samsung's Exynos SoC MFC (Video Codec) reserved memory common definition.

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

One nit - our copyright would be welcomed:
	Copyright (c) 2016 Samsung Electronics Co., Ltd

However if there are no objections I will add it when applying.

Best regards,
Krzysztof

