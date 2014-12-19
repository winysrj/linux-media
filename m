Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53609 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbaLSU6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 15:58:46 -0500
Date: Fri, 19 Dec 2014 21:58:43 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	devicetree@vger.kernel.org, robh+dt@kernel.org,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 5/7] ARM: at91: dts: sama5d3: change name of
 pinctrl_isi_{power,reset}
Message-ID: <20141219205843.GX4885@piout.net>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
 <1418892667-27428-6-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418892667-27428-6-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On 18/12/2014 at 16:51:05 +0800, Josh Wu wrote :
> For sama5d3xmb board, the pins: pinctrl_isi_{power,reset} is used to
> power-down or reset camera sensor.
> 
> So we should let camera sensor instead of ISI to configure the pins.
> This patch will change pinctrl name from pinctrl_isi_{power,reset} to
> pinctrl_sensor_{power,reset}.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  arch/arm/boot/dts/sama5d3.dtsi    | 2 ++
>  arch/arm/boot/dts/sama5d3xmb.dtsi | 6 ++----
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index ed734e9..ff0fa3a 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -214,6 +214,8 @@
>  				compatible = "atmel,at91sam9g45-isi";
>  				reg = <0xf0034000 0x4000>;
>  				interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_isi_data_0_7>;

This should probably not be is that patch.

>  				clocks = <&isi_clk>;
>  				clock-names = "isi_clk";
>  				status = "disabled";
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 6af1cba..0aaebc6 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -60,8 +60,6 @@
>  			};
>  
>  			isi: isi@f0034000 {
> -				pinctrl-names = "default";
> -				pinctrl-0 = <&pinctrl_isi_data_0_7 &pinctrl_isi_pck_as_mck &pinctrl_isi_power &pinctrl_isi_reset>;
>  			};
>  
>  			mmc1: mmc@f8000000 {
> @@ -122,12 +120,12 @@
>  							<AT91_PIOD 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD31 periph B ISI_MCK */
>  					};
>  
> -					pinctrl_isi_reset: isi_reset-0 {
> +					pinctrl_sensor_reset: sensor_reset-0 {
>  						atmel,pins =
>  							<AT91_PIOE 24 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;   /* PE24 gpio */
>  					};
>  
> -					pinctrl_isi_power: isi_power-0 {
> +					pinctrl_sensor_power: sensor_power-0 {
>  						atmel,pins =
>  							<AT91_PIOE 29 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>; /* PE29 gpio */
>  					};
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
