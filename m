Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:49041 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3FPVMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jun 2013 17:12:36 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: kishon@ti.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] ARM: dts: Add MIPI PHY node to exynos4.dtsi
Date: Sun, 16 Jun 2013 23:12:35 +0200
Message-ID: <1479883.i06oAuDEkn@flatron>
In-Reply-To: <1371231951-1969-3-git-send-email-s.nawrocki@samsung.com>
References: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com> <1371231951-1969-3-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 14 of June 2013 19:45:48 Sylwester Nawrocki wrote:
> Add PHY provider node for the MIPI CSIS and MIPI DSIM PHYs.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4.dtsi |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4.dtsi
> b/arch/arm/boot/dts/exynos4.dtsi index d505ece..4b7ce52 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -120,12 +120,20 @@
>  		reg = <0x10010000 0x400>;
>  	};
> 
> +	mipi_phy: video-phy {

nit: video-phy@10020710

Best regards,
Tomasz

> +		compatible = "samsung,s5pv210-video-phy";
> +		reg = <0x10020710 8>;
> +		#phy-cells = <1>;
> +	};
> +
>  	dsi_0: dsi@11C80000 {
>  		compatible = "samsung,exynos4210-mipi-dsi";
>  		reg = <0x11C80000 0x10000>;
>  		interrupts = <0 79 0>;
>  		samsung,phy-type = <0>;
>  		samsung,power-domain = <&pd_lcd0>;
> +		phys = <&mipi_phy 1>;
> +		phy-names = "dsim";
>  		clocks = <&clock 286>, <&clock 143>;
>  		clock-names = "bus_clk", "pll_clk";
>  		status = "disabled";
> @@ -181,6 +189,8 @@
>  			interrupts = <0 78 0>;
>  			bus-width = <4>;
>  			samsung,power-domain = <&pd_cam>;
> +			phys = <&mipi_phy 0>;
> +			phy-names = "csis";
>  			status = "disabled";
>  		};
> 
> @@ -190,6 +200,8 @@
>  			interrupts = <0 80 0>;
>  			bus-width = <2>;
>  			samsung,power-domain = <&pd_cam>;
> +			phys = <&mipi_phy 2>;
> +			phy-names = "csis";
>  			status = "disabled";
>  		};
>  	};
