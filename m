Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbbKSOvs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 09:51:48 -0500
Date: Thu, 19 Nov 2015 08:51:43 -0600
From: Rob Herring <robh@kernel.org>
To: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 2/2] media: v4l: ti-vpe: Document DRA72 CAL h/w module
Message-ID: <20151119145143.GA21319@rob-hp-laptop>
References: <1447879632-22635-1-git-send-email-bparrot@ti.com>
 <1447879632-22635-3-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1447879632-22635-3-git-send-email-bparrot@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 18, 2015 at 02:47:12PM -0600, Benoit Parrot wrote:
> Device Tree bindings for the DRA72 Camera Adaptation Layer (CAL)
> H/W module.
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  Documentation/devicetree/bindings/media/ti-cal.txt | 72 ++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/ti-cal.txt b/Documentation/devicetree/bindings/media/ti-cal.txt
> new file mode 100644
> index 000000000000..ae9b52f37576
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/ti-cal.txt
> @@ -0,0 +1,72 @@
> +Texas Instruments DRA72x CAMERA ADAPTATION LAYER (CAL)
> +------------------------------------------------------
> +
> +The Camera Adaptation Layer (CAL) is a key component for image capture
> +applications. The capture module provides the system interface and the
> +processing capability to connect CSI2 image-sensor modules to the
> +DRA72x device.
> +
> +Required properties:
> +- compatible: must be "ti,dra72-cal"
> +- reg:	CAL Top level, Receiver Core #0, Receiver Core #1 and Camera RX
> +	control address space
> +- reg-names: cal_top, cal_rx_core0, cal_rx_core1, and camerrx_control
> +	     registers
> +- interrupts: should contain IRQ line for the CAL;
> +
> +CAL supports 2 camera port nodes on MIPI bus. Each CSI2 camera port nodes
> +should contain a 'port' child node with child 'endpoint' node. Please
> +refer to the bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +	cal: cal@4845b000 {
> +		compatible = "ti,dra72-cal";
> +		ti,hwmods = "cal";
> +		reg = <0x4845B000 0x400>,
> +		      <0x4845B800 0x40>,
> +		      <0x4845B900 0x40>,
> +		      <0x4A002e94 0x4>;
> +		reg-names = "cal_top",
> +			    "cal_rx_core0",
> +			    "cal_rx_core1",
> +			    "camerrx_control";
> +		interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			csi2_0: port@0 {
> +				reg = <0>;
> +				endpoint {
> +					slave-mode;
> +					remote-endpoint = <&ar0330_1>;
> +				};
> +			};
> +			csi2_1: port@1 {
> +				reg = <1>;
> +			};
> +		};
> +	};
> +
> +	i2c5: i2c@4807c000 {
> +		ar0330@10 {
> +			compatible = "ti,ar0330";
> +			reg = <0x10>;
> +
> +			port {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				ar0330_1: endpoint {
> +					reg = <0>;
> +					clock-lanes = <1>;
> +					data-lanes = <0 2 3 4>;
> +					remote-endpoint = <&csi2_0>;
> +				};
> +			};
> +		};
> +	};
> -- 
> 1.8.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
