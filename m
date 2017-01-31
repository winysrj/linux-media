Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48480 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750740AbdAaG4s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 01:56:48 -0500
Date: Tue, 31 Jan 2017 08:56:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 05/16] ov7670: document device tree bindings
Message-ID: <20170131065608.GQ7139@valkosipuli.retiisi.org.uk>
References: <20170130140628.18088-1-hverkuil@xs4all.nl>
 <20170130140628.18088-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130140628.18088-6-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jan 30, 2017 at 03:06:17PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add binding documentation and add that file to the MAINTAINERS entry.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../devicetree/bindings/media/i2c/ov7670.txt       | 44 ++++++++++++++++++++++
>  MAINTAINERS                                        |  1 +
>  2 files changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> new file mode 100644
> index 0000000..a014694
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> @@ -0,0 +1,44 @@
> +* Omnivision OV7670 CMOS sensor
> +
> +The Omnivision OV7670 sensor supports multiple resolutions output, such as
> +CIF, SVGA, UXGA. It also can support the YUV422/420, RGB565/555 or raw RGB
> +output formats.
> +
> +Required Properties:
> +- compatible: should be "ovti,ov7670"
> +- clocks: reference to the xclk input clock.
> +- clock-names: should be "xclk".
> +
> +Optional Properties:
> +- resetb-gpios: reference to the GPIO connected to the resetb pin, if any.
> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.

Please add when the signal is active. From the datasheet it seems to be that
these are both "active high".

> +
> +The device node must contain one 'port' child node for its digital output
> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	i2c1: i2c@f0018000 {
> +		status = "okay";
> +
> +		ov7670: camera@0x21 {
> +			compatible = "ovti,ov7670";
> +			reg = <0x21>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
> +			resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
> +			pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
> +			clocks = <&pck0>;
> +			clock-names = "xclk";
> +			assigned-clocks = <&pck0>;
> +			assigned-clock-rates = <25000000>;
> +
> +			port {
> +				ov7670_0: endpoint {
> +					remote-endpoint = <&isi_0>;
> +					bus-width = <8>;
> +				};
> +			};
> +		};
> +	};

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
