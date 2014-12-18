Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50820 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaLRLz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 06:55:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	s.nawrocki@samsung.com, festevam@gmail.com,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 5/5] media: ov2640: dt: add the device tree binding document
Date: Thu, 18 Dec 2014 13:56 +0200
Message-ID: <2071990.alIc7byK3Q@avalon>
In-Reply-To: <1418869646-17071-6-git-send-email-josh.wu@atmel.com>
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <1418869646-17071-6-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Thursday 18 December 2014 10:27:26 Josh Wu wrote:
> Add the document for ov2640 dt.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> v3 -> v4:
>   1. remove aggsigned-clocks as it's general.
>   2. refine the explation.
> 
> v2 -> v3:
>   1. fix incorrect description.
>   2. Add assigned-clocks & assigned-clock-rates.
>   3. resetb pin should be ACTIVE_LOW.
> 
> v1 -> v2:
>   1. change the compatible string to be consistent with verdor file.
>   2. change the clock and pins' name.
>   3. add missed pinctrl in example.
> 
>  .../devicetree/bindings/media/i2c/ov2640.txt       | 46 +++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt
> b/Documentation/devicetree/bindings/media/i2c/ov2640.txt new file mode
> 100644
> index 0000000..de11ebb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
> @@ -0,0 +1,46 @@
> +* Omnivision ov2640 CMOS sensor
> +
> +The Omnivision OV2640 sensor support multiple resolutions output, such as
> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
> +output format.
> +
> +Required Properties:
> +- compatible: Must be "ovti,ov2640"
> +- clocks: reference to the xvclk input clock.
> +- clock-names: Must be "xvclk".
> +
> +Optional Properties:
> +- resetb-gpios: reference to the GPIO connected to the resetb pin, if any.
> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.
> +
> +The device node must contain one 'port' child node for its digital output
> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	i2c1: i2c@f0018000 {
> +		ov2640: camera@0x30 {
> +			compatible = "ovti,ov2640";
> +			reg = <0x30>;
> +
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_pck1 &pinctrl_ov2640_pwdn 
&pinctrl_ov2640_resetb>;
> +
> +			resetb-gpios = <&pioE 24 GPIO_ACTIVE_LOW>;
> +			pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
> +
> +			clocks = <&pck1>;
> +			clock-names = "xvclk";
> +
> +			assigned-clocks = <&pck1>;
> +			assigned-clock-rates = <25000000>;
> +
> +			port {
> +				ov2640_0: endpoint {
> +					remote-endpoint = <&isi_0>;
> +					bus-width = <8>;
> +				};
> +			};
> +		};
> +	};

-- 
Regards,

Laurent Pinchart

