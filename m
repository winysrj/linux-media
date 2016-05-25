Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44171 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbcEYRLw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 13:11:52 -0400
Subject: Re: [PATCH v4 6/7] ARM: dts: exynos: convert MFC device to generic
 reserved memory bindings
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-7-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <0158bb7a-02cf-bbb3-f903-d99c7351dfc4@osg.samsung.com>
Date: Wed, 25 May 2016 13:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <1464096690-23605-7-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 05/24/2016 09:31 AM, Marek Szyprowski wrote:
> This patch replaces custom properties for defining reserved memory
> regions with generic reserved memory bindings for MFC video codec
> device.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

[snip]

> +
> +/ {
> +	reserved-memory {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		mfc_left: region@51000000 {
> +			compatible = "shared-dma-pool";
> +			no-map;
> +			reg = <0x51000000 0x800000>;
> +		};
> +
> +		mfc_right: region@43000000 {
> +			compatible = "shared-dma-pool";
> +			no-map;
> +			reg = <0x43000000 0x800000>;
> +		};
> +	};

I've a question probably for a follow up patch, but do you know what's a
sane default size for these? I needed to bump the mfc_left size from 8 MiB
to 16 MiB in order to decode a 480p H264 video using GStramer. So clearly
the default sizes are not that useful.

> +};
> diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
> index ad7394c..f5e4eb2 100644
> --- a/arch/arm/boot/dts/exynos4210-origen.dts
> +++ b/arch/arm/boot/dts/exynos4210-origen.dts
> @@ -18,6 +18,7 @@
>  #include "exynos4210.dtsi"
>  #include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/input/input.h>
> +#include "exynos-mfc-reserved-memory.dtsi"
>  
>  / {
>  	model = "Insignal Origen evaluation board based on Exynos4210";
> @@ -288,8 +289,7 @@
>  };
>  
>  &mfc {
> -	samsung,mfc-r = <0x43000000 0x800000>;
> -	samsung,mfc-l = <0x51000000 0x800000>;
> +	memory-region = <&mfc_left>, <&mfc_right>;
>  	status = "okay";

I wonder if shouldn't be better to include the exynos-mfc-reserved-memory.dtsi
on each SoC dtsi and set the memory-regions in the MFC node instead of doing
it on each DTS, and let DTS to just replace with its own memory regions if the
default sizes are not suitable for them.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
