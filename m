Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36197 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdEaTzV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 15:55:21 -0400
Date: Wed, 31 May 2017 21:55:17 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] ARM: dts: exynos: Add HDMI CEC device to Exynos5 SoC
 family
Message-ID: <20170531195517.2vjbc3voefdgq6sg@kozik-lap>
References: <CGME20170531110029eucas1p14bb9468f72155d88364c0aa5093ac05d@eucas1p1.samsung.com>
 <1496228417-31126-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1496228417-31126-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 31, 2017 at 01:00:17PM +0200, Marek Szyprowski wrote:
> Exynos5250 and Exynos542x SoCs have the same CEC hardware module as
> Exynos4 SoC series, so enable support for it using the same compatible
> string.
> 
> Tested on Odroid XU3 (Exynos5422) and Google Snow (Exynos5250) boards.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |  7 +++++++
>  arch/arm/boot/dts/exynos5250-snow-common.dtsi      |  4 ++++
>  arch/arm/boot/dts/exynos5250.dtsi                  | 13 +++++++++++++
>  arch/arm/boot/dts/exynos5420-pinctrl.dtsi          |  7 +++++++
>  arch/arm/boot/dts/exynos5420.dtsi                  | 13 +++++++++++++
>  arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |  4 ++++
>  6 files changed, 48 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> index 2f6ab32b5954..1fd122db18e6 100644
> --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> @@ -589,6 +589,13 @@
>  		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
>  		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
>  	};
> +
> +	hdmi_cec: hdmi-cec {
> +		samsung,pins = "gpx3-6";
> +		samsung,pin-function = <EXYNOS_PIN_FUNC_3>;
> +		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
> +		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
> +	};
>  };
>  
>  &pinctrl_1 {
> diff --git a/arch/arm/boot/dts/exynos5250-snow-common.dtsi b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
> index 8f3a80430748..e1d293dbbe5d 100644
> --- a/arch/arm/boot/dts/exynos5250-snow-common.dtsi
> +++ b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
> @@ -272,6 +272,10 @@
>  	vdd_pll-supply = <&ldo8_reg>;
>  };
>  
> +&hdmicec {
> +	status = "okay";
> +};
> +
>  &i2c_0 {
>  	status = "okay";
>  	samsung,i2c-sda-delay = <100>;
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 79c9c885613a..fbdc1d53a2ce 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -689,6 +689,19 @@
>  			samsung,syscon-phandle = <&pmu_system_controller>;
>  		};
>  
> +		hdmicec: cec@101B0000 {
> +			compatible = "samsung,s5p-cec";
> +			reg = <0x101B0000 0x200>;
> +			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clock CLK_HDMI_CEC>;
> +			clock-names = "hdmicec";
> +			samsung,syscon-phandle = <&pmu_system_controller>;
> +			hdmi-phandle = <&hdmi>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&hdmi_cec>;
> +			status = "disabled";
> +		};

What about Exynos5410? Is it applicable there as well? If yes, then this
could be added to exynos5.dtsi... although then clocks and pinctrl
should remain in SoC-specific DTSI. We're following such pattern in many
places but I am not sure if this more readable.

Beside that, looks fine to me.

Best regards,
Krzysztof
