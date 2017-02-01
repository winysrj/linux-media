Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33198 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753046AbdBAQ7D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 11:59:03 -0500
Date: Wed, 1 Feb 2017 10:58:56 -0600
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 13/16] ov2640: update bindings
Message-ID: <20170201165856.vadsezfz46qarc2m@rob-hp-laptop>
References: <20170130140628.18088-1-hverkuil@xs4all.nl>
 <20170130140628.18088-14-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130140628.18088-14-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 30, 2017 at 03:06:25PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Update the bindings for this device based on a working DT example.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../devicetree/bindings/media/i2c/ov2640.txt       | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
> index c429b5b..5e6c445 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov2640.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
> @@ -1,8 +1,8 @@
>  * Omnivision OV2640 CMOS sensor
>  
> -The Omnivision OV2640 sensor support multiple resolutions output, such as
> -CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
> -output format.
> +The Omnivision OV2640 sensor supports multiple resolutions output, such as
> +CIF, SVGA, UXGA. It also can support the YUV422/420, RGB565/555 or raw RGB
> +output formats.
>  
>  Required Properties:
>  - compatible: should be "ovti,ov2640"
> @@ -20,20 +20,18 @@ Documentation/devicetree/bindings/media/video-interfaces.txt.
>  Example:
>  
>  	i2c1: i2c@f0018000 {
> +		status = "okay";

There's no point in showing status in examples.

> +
>  		ov2640: camera@0x30 {

Drop the '0x' while here.

With that,

Acked-by: Rob Herring <robh@kernel.org>


>  			compatible = "ovti,ov2640";
>  			reg = <0x30>;
> -
>  			pinctrl-names = "default";
> -			pinctrl-0 = <&pinctrl_pck1 &pinctrl_ov2640_pwdn &pinctrl_ov2640_resetb>;
> -
> -			resetb-gpios = <&pioE 24 GPIO_ACTIVE_LOW>;
> -			pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
> -
> -			clocks = <&pck1>;
> +			pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
> +			resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
> +			pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
> +			clocks = <&pck0>;
>  			clock-names = "xvclk";
> -
> -			assigned-clocks = <&pck1>;
> +			assigned-clocks = <&pck0>;
>  			assigned-clock-rates = <25000000>;
>  
>  			port {
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
