Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:39318 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752549AbdIHLdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 07:33:35 -0400
Subject: Re: [PATCH v3 2/6] ARM: dts: exynos: Add clean name of compatible.
To: Hoegeun Kwon <hoegeun.kwon@samsung.com>, inki.dae@samsung.com,
        airlied@linux.ie, kgene@kernel.org, krzk@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com,
        will.deacon@arm.com, mchehab@kernel.org, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        a.hajda@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
References: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
 <CGME20170908060308epcas1p2b275c76f63f5742092a7bc4ef14c05a5@epcas1p2.samsung.com>
 <1504850560-27950-3-git-send-email-hoegeun.kwon@samsung.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <1a2dfeb9-b2e1-3bc6-772a-e3b55fc51b7f@arm.com>
Date: Fri, 8 Sep 2017 12:33:29 +0100
MIME-Version: 1.0
In-Reply-To: <1504850560-27950-3-git-send-email-hoegeun.kwon@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/17 07:02, Hoegeun Kwon wrote:
> Exynos 5250 and 5420 have different hardware rotation limits. However,
> currently it uses only one compatible - "exynos5-gsc". Since we have
> to distinguish between these two, we add different compatible.
> 
> Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi | 8 ++++----
>  arch/arm/boot/dts/exynos5420.dtsi | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 8dbeb87..bf08101 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -637,7 +637,7 @@
>  		};
>  
>  		gsc_0:  gsc@13e00000 {
> -			compatible = "samsung,exynos5-gsc";
> +			compatible = "samsung,exynos5-gsc", "samsung,exynos5250-gsc";

These should be the other way round - the most specific compatible
should come first, then the more general fallback afterwards.

(and similarly in all cases below)

Robin.

>  			reg = <0x13e00000 0x1000>;
>  			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
>  			power-domains = <&pd_gsc>;
> @@ -647,7 +647,7 @@
>  		};
>  
>  		gsc_1:  gsc@13e10000 {
> -			compatible = "samsung,exynos5-gsc";
> +			compatible = "samsung,exynos5-gsc", "samsung,exynos5250-gsc";
>  			reg = <0x13e10000 0x1000>;
>  			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
>  			power-domains = <&pd_gsc>;
> @@ -657,7 +657,7 @@
>  		};
>  
>  		gsc_2:  gsc@13e20000 {
> -			compatible = "samsung,exynos5-gsc";
> +			compatible = "samsung,exynos5-gsc", "samsung,exynos5250-gsc";
>  			reg = <0x13e20000 0x1000>;
>  			interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
>  			power-domains = <&pd_gsc>;
> @@ -667,7 +667,7 @@
>  		};
>  
>  		gsc_3:  gsc@13e30000 {
> -			compatible = "samsung,exynos5-gsc";
> +			compatible = "samsung,exynos5-gsc", "samsung,exynos5250-gsc";
>  			reg = <0x13e30000 0x1000>;
>  			interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>;
>  			power-domains = <&pd_gsc>;
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 02d2f89..86afe77 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -658,7 +658,7 @@
>  		};
>  
>  		gsc_0: video-scaler@13e00000 {
> -			compatible = "samsung,exynos5-gsc";
> +			compatible = "samsung,exynos5-gsc", "samsung,exynos5420-gsc";
>  			reg = <0x13e00000 0x1000>;
>  			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks = <&clock CLK_GSCL0>;
> @@ -668,7 +668,7 @@
>  		};
>  
>  		gsc_1: video-scaler@13e10000 {
> -			compatible = "samsung,exynos5-gsc";
> +			compatible = "samsung,exynos5-gsc", "samsung,exynos5420-gsc";
>  			reg = <0x13e10000 0x1000>;
>  			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks = <&clock CLK_GSCL1>;
> 
