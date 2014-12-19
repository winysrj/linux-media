Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53685 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156AbaLSVFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:05:12 -0500
Date: Fri, 19 Dec 2014 22:05:09 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	devicetree@vger.kernel.org, robh+dt@kernel.org,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 6/7] ARM: at91: dts: sama5d3: add ov2640 camera sensor
 support
Message-ID: <20141219210509.GC4885@piout.net>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
 <1418892667-27428-7-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418892667-27428-7-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2014 at 16:51:06 +0800, Josh Wu wrote :
> According to v4l2 dt document, we add:
>   a camera host: ISI port.
>   a i2c camera sensor: ov2640 port.
> to sama5d3xmb.dtsi.
> 
> In the ov2640 node, it defines the pinctrls, clocks and isi port.
> In the ISI node, it also reference to a ov2640 port.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  arch/arm/boot/dts/sama5d3xmb.dtsi | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 0aaebc6..958a528 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -52,6 +52,29 @@
>  				};
>  			};
>  
> +			i2c1: i2c@f0018000 {
> +				ov2640: camera@0x30 {
> +					compatible = "ovti,ov2640";
> +					reg = <0x30>;
> +					pinctrl-names = "default";
> +					pinctrl-0 = <&pinctrl_isi_pck_as_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;

I've acked your previous patch but maybe it should be named
pinctrl_isi_pck1_as_mck to be clearer (you used the handle to pck1
below).

> +					resetb-gpios = <&pioE 24 GPIO_ACTIVE_LOW>;
> +					pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
> +					/* use pck1 for the master clock of ov2640 */
> +					clocks = <&pck1>;
> +					clock-names = "xvclk";
> +					assigned-clocks = <&pck1>;
> +					assigned-clock-rates = <25000000>;
> +
> +					port {
> +						ov2640_0: endpoint {
> +							remote-endpoint = <&isi_0>;
> +							bus-width = <8>;
> +						};
> +					};
> +				};
> +			};
> +
>  			usart1: serial@f0020000 {
>  				dmas = <0>, <0>;	/*  Do not use DMA for usart1 */
>  				pinctrl-names = "default";
> @@ -60,6 +83,15 @@
>  			};
>  
>  			isi: isi@f0034000 {
> +				port {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					isi_0: endpoint {
> +						remote-endpoint = <&ov2640_0>;
> +						bus-width = <8>;
> +					};
> +				};
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
