Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:40267 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966064AbeBMXms (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 18:42:48 -0500
Date: Tue, 13 Feb 2018 17:42:46 -0600
From: Rob Herring <robh@kernel.org>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: media: Binding document for OV7251
 camera sensor
Message-ID: <20180213234246.vmiwrxlxuprlak4z@rob-hp-laptop>
References: <1518080018-10403-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1518080018-10403-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 08, 2018 at 10:53:37AM +0200, Todor Tomov wrote:
> Add the document for ov7251 device tree binding.
> 
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: devicetree@vger.kernel.org
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  .../devicetree/bindings/media/i2c/ov7251.txt       | 51 ++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7251.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7251.txt b/Documentation/devicetree/bindings/media/i2c/ov7251.txt
> new file mode 100644
> index 0000000..c807646
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov7251.txt
> @@ -0,0 +1,51 @@
> +* Omnivision 1/7.5-Inch B&W VGA CMOS Digital Image Sensor
> +
> +The Omnivision OV7251 is a 1/7.5-Inch CMOS active pixel digital image sensor with
> +an active array size of 640H x 480V. It is programmable through a serial I2C
> +interface.
> +
> +Required Properties:
> +- compatible: Value should be "ovti,ov7251".
> +- clocks: Reference to the xclk clock.
> +- clock-names: Should be "xclk".
> +- clock-frequency: Frequency of the xclk clock.
> +- enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH. This corresponds
> +  to the hardware pin XSHUTDOWN which is physically active low.
> +- vdddo-supply: Chip digital IO regulator.
> +- vdda-supply: Chip analog regulator.
> +- vddd-supply: Chip digital core regulator.
> +
> +The device node must contain one 'port' child node for its digital output
> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	&i2c1 {
> +		...
> +
> +		ov7251: ov7251@60 {

camera-sensor@60

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

> +			compatible = "ovti,ov7251";
> +			reg = <0x60>;
> +
> +			enable-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&camera_bw_default>;
> +
> +			clocks = <&clks 200>;
> +			clock-names = "xclk";
> +			clock-frequency = <24000000>;
> +
> +			vdddo-supply = <&camera_dovdd_1v8>;
> +			vdda-supply = <&camera_avdd_2v8>;
> +			vddd-supply = <&camera_dvdd_1v2>;
> +
> +			port {
> +				ov7251_ep: endpoint {
> +					clock-lanes = <1>;
> +					data-lanes = <0>;
> +					remote-endpoint = <&csi0_ep>;
> +				};
> +			};
> +		};
> +	};
> -- 
> 2.7.4
> 
