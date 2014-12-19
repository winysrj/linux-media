Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53632 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbaLSU70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 15:59:26 -0500
Date: Fri, 19 Dec 2014 21:59:24 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	devicetree@vger.kernel.org, robh+dt@kernel.org,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/7] ARM: at91: dts: sama5d3: split isi pinctrl
Message-ID: <20141219205924.GZ4885@piout.net>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
 <1418892667-27428-3-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418892667-27428-3-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2014 at 16:51:02 +0800, Josh Wu wrote :
> From: Bo Shen <voice.shen@atmel.com>
> 
> As the ISI has 12 data lines, however we only use 8 data lines with
> sensor module. So, split the data line into two groups which make
> it can be choosed depends on the hardware design.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  arch/arm/boot/dts/sama5d3.dtsi    | 11 ++++++++---
>  arch/arm/boot/dts/sama5d3xmb.dtsi |  2 +-
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 61746ef..595609f 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -547,7 +547,7 @@
>  				};
>  
>  				isi {
> -					pinctrl_isi: isi-0 {
> +					pinctrl_isi_data_0_7: isi-0-data-0-7 {
>  						atmel,pins =
>  							<AT91_PIOA 16 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA16 periph C ISI_D0, conflicts with LCDDAT16 */
>  							 AT91_PIOA 17 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA17 periph C ISI_D1, conflicts with LCDDAT17 */
> @@ -559,10 +559,15 @@
>  							 AT91_PIOA 23 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA23 periph C ISI_D7, conflicts with LCDDAT23, PWML1 */
>  							 AT91_PIOC 30 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC30 periph C ISI_PCK, conflicts with UTXD0 */
>  							 AT91_PIOA 31 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA31 periph C ISI_HSYNC, conflicts with TWCK0, UTXD1 */
> -							 AT91_PIOA 30 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA30 periph C ISI_VSYNC, conflicts with TWD0, URXD1 */
> -							 AT91_PIOC 29 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC29 periph C ISI_PD8, conflicts with URXD0, PWMFI2 */
> +							 AT91_PIOA 30 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PA30 periph C ISI_VSYNC, conflicts with TWD0, URXD1 */
> +					};
> +
> +					pinctrl_isi_data_8_9: isi-0-data-8-9 {
> +						atmel,pins =
> +							<AT91_PIOC 29 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC29 periph C ISI_PD8, conflicts with URXD0, PWMFI2 */
>  							 AT91_PIOC 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PC28 periph C ISI_PD9, conflicts with SPI1_NPCS3, PWMFI0 */
>  					};
> +
>  					pinctrl_isi_pck_as_mck: isi_pck_as_mck-0 {
>  						atmel,pins =
>  							<AT91_PIOD 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD31 periph B ISI_MCK */
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 49c10d3..2530541 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -61,7 +61,7 @@
>  
>  			isi: isi@f0034000 {
>  				pinctrl-names = "default";
> -				pinctrl-0 = <&pinctrl_isi &pinctrl_isi_pck_as_mck &pinctrl_isi_power &pinctrl_isi_reset>;
> +				pinctrl-0 = <&pinctrl_isi_data_0_7 &pinctrl_isi_pck_as_mck &pinctrl_isi_power &pinctrl_isi_reset>;
>  			};
>  
>  			mmc1: mmc@f8000000 {
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
