Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53323 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3JAF2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 01:28:44 -0400
Message-ID: <524A5D68.8080904@ti.com>
Date: Tue, 1 Oct 2013 10:58:08 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: <gregkh@linuxfoundation.org>, <linux-media@vger.kernel.org>,
	<kyungmin.park@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>, <kgene.kim@samsung.com>,
	<dh09.lee@samsung.com>, <jg1.han@samsung.com>,
	<tomi.valkeinen@ti.com>, <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH V5 1/5] ARM: dts: Add MIPI PHY node to exynos4.dtsi
References: <1380396467-29278-1-git-send-email-s.nawrocki@samsung.com> <1380396467-29278-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1380396467-29278-2-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


On Sunday 29 September 2013 12:57 AM, Sylwester Nawrocki wrote:
> Add PHY provider node for the MIPI CSIS and MIPI DSIM PHYs.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>

Can this patch be taken through exynos dt tree?

Thanks
Kishon
> ---
>  arch/arm/boot/dts/exynos4.dtsi |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> index caadc02..a73eeb5 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -49,6 +49,12 @@
>  		reg = <0x10000000 0x100>;
>  	};
>  
> +	mipi_phy: video-phy@10020710 {
> +		compatible = "samsung,s5pv210-mipi-video-phy";
> +		reg = <0x10020710 8>;
> +		#phy-cells = <1>;
> +	};
> +
>  	pd_mfc: mfc-power-domain@10023C40 {
>  		compatible = "samsung,exynos4210-pd";
>  		reg = <0x10023C40 0x20>;
> @@ -161,6 +167,8 @@
>  			clock-names = "csis", "sclk_csis";
>  			bus-width = <4>;
>  			samsung,power-domain = <&pd_cam>;
> +			phys = <&mipi_phy 0>;
> +			phy-names = "csis";
>  			status = "disabled";
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> @@ -174,6 +182,8 @@
>  			clock-names = "csis", "sclk_csis";
>  			bus-width = <2>;
>  			samsung,power-domain = <&pd_cam>;
> +			phys = <&mipi_phy 2>;
> +			phy-names = "csis";
>  			status = "disabled";
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> 

