Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50887 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaLRMcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 07:32:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	alexandre.belloni@free-electrons.com, devicetree@vger.kernel.org,
	robh+dt@kernel.org, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH 6/7] ARM: at91: dts: sama5d3: add ov2640 camera sensor support
Date: Thu, 18 Dec 2014 14:32:49 +0200
Message-ID: <5518219.5PdO7T0ydL@avalon>
In-Reply-To: <1418892667-27428-7-git-send-email-josh.wu@atmel.com>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com> <1418892667-27428-7-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Thursday 18 December 2014 16:51:06 Josh Wu wrote:
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
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi
> b/arch/arm/boot/dts/sama5d3xmb.dtsi index 0aaebc6..958a528 100644
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
> +					pinctrl-0 = <&pinctrl_isi_pck_as_mck
> &pinctrl_sensor_power &pinctrl_sensor_reset>;
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

I would add the port node and those two properties to 
arch/arm/boot/dts/sama5d3.dtsi, as the isi has a single port. The endpoint, of 
course, should stay in this file.

> +					isi_0: endpoint {
> +						remote-endpoint = <&ov2640_0>;
> +						bus-width = <8>;
> +					};
> +				};
>  			};
> 
>  			mmc1: mmc@f8000000 {

-- 
Regards,

Laurent Pinchart

