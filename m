Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53674 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbaLSVCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:02:30 -0500
Date: Fri, 19 Dec 2014 22:02:28 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	devicetree@vger.kernel.org, robh+dt@kernel.org,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 4/7] ARM: at91: dts: sama5d3: move the isi mck pin to mb
Message-ID: <20141219210228.GB4885@piout.net>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
 <1418892667-27428-5-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418892667-27428-5-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2014 at 16:51:04 +0800, Josh Wu wrote :
> From: Bo Shen <voice.shen@atmel.com>
> 
> The mck is decided by the board design, move it to mb related
> dtsi file.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  arch/arm/boot/dts/sama5d3.dtsi    | 5 -----
>  arch/arm/boot/dts/sama5d3xmb.dtsi | 5 +++++
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index b3ac156..ed734e9 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -573,11 +573,6 @@
>  							<AT91_PIOC 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC27 periph C ISI_PD10, conflicts with SPI1_NPCS2, TWCK1 */
>  							 AT91_PIOC 26 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PC26 periph C ISI_PD11, conflicts with SPI1_NPCS1, TWD1 */
>  					};
> -
> -					pinctrl_isi_pck_as_mck: isi_pck_as_mck-0 {
> -						atmel,pins =
> -							<AT91_PIOD 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD31 periph B ISI_MCK */
> -					};
>  				};
>  
>  				mmc0 {
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 2530541..6af1cba 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -117,6 +117,11 @@
>  							<AT91_PIOD 30 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD30 periph B */
>  					};
>  
> +					pinctrl_isi_pck_as_mck: isi_pck_as_mck-0 {
> +						atmel,pins =
> +							<AT91_PIOD 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD31 periph B ISI_MCK */
> +					};
> +
>  					pinctrl_isi_reset: isi_reset-0 {
>  						atmel,pins =
>  							<AT91_PIOE 24 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;   /* PE24 gpio */
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
