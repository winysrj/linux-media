Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56367 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaFSHj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 03:39:26 -0400
Date: Thu, 19 Jun 2014 09:39:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: soc_camera: pxa_camera documentation device-tree
 support
In-Reply-To: <1402863436-30311-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1406190938280.22703@axis700.grange>
References: <1402863436-30311-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Jun 2014, Robert Jarzmik wrote:

> Add documentation for pxa_camera host interface.

As mentioned in another comment: this is driver DT bindings description, 
not interface documentation.

Thanks
Guennadi

> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  .../devicetree/bindings/media/pxa-camera.txt       | 40 ++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/pxa-camera.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/pxa-camera.txt b/Documentation/devicetree/bindings/media/pxa-camera.txt
> new file mode 100644
> index 0000000..568b63b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/pxa-camera.txt
> @@ -0,0 +1,40 @@
> +Marvell PXA camera host interface
> +
> +Required properties:
> + - compatible: Should be "mrvl,pxa_camera"
> + - reg: register base and size
> + - interrupts: the interrupt number
> + - any required generic properties defined in video-interfaces.txt
> +
> +Optional properties:
> + - mclk_10khz: host interface is driving MCLK, and MCLK rate is mclk_10khz *
> +   10000 Hz.
> +
> +Example:
> +
> +	pxa_camera: pxa_camera@50000000 {
> +		compatible = "mrvl,pxa_camera";
> +		reg = <0x50000000 0x1000>;
> +		interrupts = <33>;
> +
> +		clocks = <&pxa2xx_clks 24>;
> +		clock-names = "camera";
> +		status = "okay";
> +
> +		mclk_10khz = <5000>;
> +
> +		port {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			/* Parallel bus endpoint */
> +			qci: endpoint@0 {
> +				reg = <0>;		/* Local endpoint # */
> +				remote-endpoint = <&mt9m111_1>;
> +				bus-width = <8>;	/* Used data lines */
> +				hsync-active = <0>;	/* Active low */
> +				vsync-active = <0>;	/* Active low */
> +				pclk-sample = <1>;	/* Rising */
> +			};
> +		};
> +	};
> -- 
> 2.0.0.rc2
> 
