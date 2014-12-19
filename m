Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53642 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384AbaLSU7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 15:59:53 -0500
Date: Fri, 19 Dec 2014 21:59:51 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	devicetree@vger.kernel.org, robh+dt@kernel.org,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 3/7] ARM: at91: dts: sama5d3: add missing pins of isi
Message-ID: <20141219205951.GA4885@piout.net>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
 <1418892667-27428-4-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418892667-27428-4-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2014 at 16:51:03 +0800, Josh Wu wrote :
> From: Bo Shen <voice.shen@atmel.com>
> 
> The ISI has 12 data lines, add the missing two data lines.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  arch/arm/boot/dts/sama5d3.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 595609f..b3ac156 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -568,6 +568,12 @@
>  							 AT91_PIOC 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PC28 periph C ISI_PD9, conflicts with SPI1_NPCS3, PWMFI0 */
>  					};
>  
> +					pinctrl_isi_data_10_11: isi-0-data-10-11 {
> +						atmel,pins =
> +							<AT91_PIOC 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC27 periph C ISI_PD10, conflicts with SPI1_NPCS2, TWCK1 */
> +							 AT91_PIOC 26 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PC26 periph C ISI_PD11, conflicts with SPI1_NPCS1, TWD1 */
> +					};
> +
>  					pinctrl_isi_pck_as_mck: isi_pck_as_mck-0 {
>  						atmel,pins =
>  							<AT91_PIOD 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD31 periph B ISI_MCK */
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
