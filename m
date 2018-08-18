Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34729 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbeHRPwt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 11:52:49 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 11/14] ARM: tegra: Enable VDE on Tegra124
Date: Sat, 18 Aug 2018 15:45:09 +0300
Message-ID: <1684522.qRMD88czIW@dimapc>
In-Reply-To: <20180813145027.16346-12-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com> <20180813145027.16346-12-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, 13 August 2018 17:50:24 MSK Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra124.dtsi | 40 +++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/tegra124.dtsi
> b/arch/arm/boot/dts/tegra124.dtsi index b113e47b2b2a..8fdca4723205 100644
> --- a/arch/arm/boot/dts/tegra124.dtsi
> +++ b/arch/arm/boot/dts/tegra124.dtsi
> @@ -83,6 +83,19 @@
>  		};
>  	};
> 
> +	iram@40000000 {
> +		compatible = "mmio-sram";
> +		reg = <0x0 0x40000000 0x0 0x40000>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0x0 0x40000000 0x40000>;
> +
> +		vde_pool: pool@400 {
> +			reg = <0x400 0x3fc00>;
> +			pool;
> +		};
> +	};
> +
>  	host1x@50000000 {
>  		compatible = "nvidia,tegra124-host1x", "simple-bus";
>  		reg = <0x0 0x50000000 0x0 0x00034000>;
> @@ -283,6 +296,33 @@
>  		*/
>  	};
> 
> +	vde@60030000 {
> +		compatible = "nvidia,tegra124-vde", "nvidia,tegra30-vde",
> +			     "nvidia,tegra20-vde";
> +		reg = <0x0 0x60030000 0x0 0x1000   /* Syntax Engine */
> +		       0x0 0x60031000 0x0 0x1000   /* Video Bitstream Engine */
> +		       0x0 0x60032000 0x0 0x0100   /* Macroblock Engine */
> +		       0x0 0x60032200 0x0 0x0100   /* Post-processing Engine */
> +		       0x0 0x60032400 0x0 0x0100   /* Motion Compensation Engine */
> +		       0x0 0x60032600 0x0 0x0100   /* Transform Engine */
> +		       0x0 0x60032800 0x0 0x0100   /* Pixel prediction block */
> +		       0x0 0x60032a00 0x0 0x0100   /* Video DMA */
> +		       0x0 0x60033800 0x0 0x0400>; /* Video frame controls */
> +		reg-names = "sxe", "bsev", "mbe", "ppe", "mce",
> +			    "tfe", "ppb", "vdma", "frameid";
> +		iram = <&vde_pool>; /* IRAM region */
> +		interrupts = <GIC_SPI  9 IRQ_TYPE_LEVEL_HIGH>, /* Sync token 
> +			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>, /* BSE-V interrupt */
> +			     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
> +		interrupt-names = "sync-token", "bsev", "sxe";
> +		clocks = <&tegra_car TEGRA124_CLK_VDE>,
> +			 <&tegra_car TEGRA124_CLK_BSEV>;
> +		clock-names = "vde", "bsev";
> +		resets = <&tegra_car 61>,
> +			 <&tegra_car 63>;
> +		reset-names = "vde", "bsev";

Memory client reset missed?

> +	};
> +
>  	apbdma: dma@60020000 {
>  		compatible = "nvidia,tegra124-apbdma", "nvidia,tegra148-apbdma";
>  		reg = <0x0 0x60020000 0x0 0x1400>;
