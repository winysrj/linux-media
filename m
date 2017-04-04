Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37198 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752011AbdDDJcZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 05:32:25 -0400
Date: Tue, 4 Apr 2017 12:31:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 1/2] media: i2c/ov5645: add the device tree binding
 document
Message-ID: <20170404093150.GB3288@valkosipuli.retiisi.org.uk>
References: <1491228148-28505-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491228148-28505-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Apr 03, 2017 at 05:02:28PM +0300, Todor Tomov wrote:
> Add the document for ov5645 device tree binding.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5645.txt       | 54 ++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> new file mode 100644
> index 0000000..fd7aec9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> @@ -0,0 +1,54 @@
> +* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
> +
> +The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image sensor with
> +an active array size of 2592H x 1944V. It is programmable through a serial I2C
> +interface.
> +
> +Required Properties:
> +- compatible: Value should be "ovti,ov5645".
> +- clocks: Reference to the xclk clock.
> +- clock-names: Should be "xclk".
> +- clock-frequency: Frequency of the xclk clock.
> +- enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH. This corresponds
> +  to the hardware pin PWDNB which is physically active low.
> +- reset-gpios: Chip reset GPIO. Polarity is GPIO_ACTIVE_LOW. This corresponds to
> +  the hardware pin RESETB.
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
> +		ov5645: ov5645@78 {
> +			compatible = "ovti,ov5645";
> +			reg = <0x78>;
> +
> +			enable-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
> +			reset-gpios = <&gpio5 20 GPIO_ACTIVE_LOW>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&camera_rear_default>;
> +
> +			clocks = <&clks 200>;
> +			clock-names = "xclk";
> +			clock-frequency = <23880000>;
> +
> +			vdddo-supply = <&camera_dovdd_1v8>;
> +			vdda-supply = <&camera_avdd_2v8>;
> +			vddd-supply = <&camera_dvdd_1v2>;
> +
> +			port {
> +				ov5645_ep: endpoint {
> +					clock-lanes = <1>;
> +					data-lanes = <0 2>;

If the sensor does not support lane reordering, I'd use 0 for the clock lane
and lanes starting from 1 for data-lanes.

I guess it'd be good to document this but that's definitely out of scope of
the patchset.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +					remote-endpoint = <&csi0_ep>;
> +				};
> +			};
> +		};
> +	};

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
