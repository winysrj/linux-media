Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50470 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754462AbeDWJQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 05:16:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 01/11] media: dt-bindings: ov772x: add device tree binding
Date: Mon, 23 Apr 2018 12:17:09 +0300
Message-ID: <6602935.FYsd3sRonc@avalon>
In-Reply-To: <1524412577-14419-2-git-send-email-akinobu.mita@gmail.com>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com> <1524412577-14419-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mita-san,

On Sunday, 22 April 2018 18:56:07 EEST Akinobu Mita wrote:
> This adds a device tree binding documentation for OV7720/OV7725 sensor.
> 
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v3
> - Add Reviewed-by: lines
> 
>  .../devicetree/bindings/media/i2c/ov772x.txt       | 42 +++++++++++++++++++
>  MAINTAINERS                                        |  1 +
>  2 files changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt
> b/Documentation/devicetree/bindings/media/i2c/ov772x.txt new file mode
> 100644
> index 0000000..b045503
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
> @@ -0,0 +1,42 @@
> +* Omnivision OV7720/OV7725 CMOS sensor
> +
> +The Omnivision OV7720/OV7725 sensor supports multiple resolutions output,
> +such as VGA, QVGA, and any size scaling down from CIF to 40x30. It also can
> +support the YUV422, RGB565/555/444, GRB422 or raw RGB output formats.
> +
> +Required Properties:
> +- compatible: shall be one of
> +	"ovti,ov7720"
> +	"ovti,ov7725"
> +- clocks: reference to the xclk input clock.
> +- clock-names: shall be "xclk".

As there's a single clock we could omit clock-names, couldn't we ?

The rest of the patch looks good to me.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +Optional Properties:
> +- reset-gpios: reference to the GPIO connected to the RSTB pin which is
> +  active low, if any.
> +- powerdown-gpios: reference to the GPIO connected to the PWDN pin which is
> +  active high, if any.
> +
> +The device node shall contain one 'port' child node with one child
> 'endpoint'
> +subnode for its digital output video port, in accordance with the video
> +interface bindings defined in Documentation/devicetree/bindings/media/
> +video-interfaces.txt.
> +
> +Example:
> +
> +&i2c0 {
> +	ov772x: camera@21 {
> +		compatible = "ovti,ov7725";
> +		reg = <0x21>;
> +		reset-gpios = <&axi_gpio_0 0 GPIO_ACTIVE_LOW>;
> +		powerdown-gpios = <&axi_gpio_0 1 GPIO_ACTIVE_LOW>;
> +		clocks = <&xclk>;
> +		clock-names = "xclk";
> +
> +		port {
> +			ov772x_0: endpoint {
> +				remote-endpoint = <&vcap1_in0>;
> +			};
> +		};
> +	};
> +};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5ae51d0..1cc5fb1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10353,6 +10353,7 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Odd fixes
>  F:	drivers/media/i2c/ov772x.c
>  F:	include/media/i2c/ov772x.h
> +F:	Documentation/devicetree/bindings/media/i2c/ov772x.txt
> 
>  OMNIVISION OV7740 SENSOR DRIVER
>  M:	Wenyou Yang <wenyou.yang@microchip.com>

-- 
Regards,

Laurent Pinchart
