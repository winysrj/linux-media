Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17629 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759410Ab3HNIVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 04:21:50 -0400
From: Kukjin Kim <kgene@kernel.org>
To: 'Jingoo Han' <jg1.han@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: 'Kishon Vijay Abraham I' <kishon@ti.com>,
	linux-media@vger.kernel.org,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	'Tomi Valkeinen' <tomi.valkeinen@ti.com>,
	linux-fbdev@vger.kernel.org, 'Hui Wang' <jason77.wang@gmail.com>
References: <003e01ce7c7a$e519a300$af4ce900$@samsung.com>
In-reply-to: <003e01ce7c7a$e519a300$af4ce900$@samsung.com>
Subject: RE: [PATCH V6 1/4] ARM: dts: Add DP PHY node to exynos5250.dtsi
Date: Wed, 14 Aug 2013 17:21:48 +0900
Message-id: <10ab01ce98c7$522567a0$f67036e0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jingoo Han wrote:
> 
> Add PHY provider node for the DP PHY.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi
> index fc9fb3d..c326c06 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -616,6 +616,12 @@
>  		interrupts = <0 94 0>;
>  	};
> 
> +	dp_phy: video-phy@10040720 {
> +		compatible = "samsung,exynos5250-dp-video-phy";
> +		reg = <0x10040720 4>;
> +		#phy-cells = <0>;
> +	};
> +
>  	dp-controller {
>  		compatible = "samsung,exynos5-dp";
>  		reg = <0x145b0000 0x1000>;
> @@ -623,11 +629,8 @@
>  		interrupt-parent = <&combiner>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -
> -		dptx-phy {
> -			reg = <0x10040720>;
> -			samsung,enable-mask = <1>;
> -		};
> +		phys = <&dp_phy>;
> +		phy-names = "dp";
>  	};
> 
>  	fimd {
> --
> 1.7.10.4


