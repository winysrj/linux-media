Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35615 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdBBMNa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 07:13:30 -0500
Received: by mail-wm0-f43.google.com with SMTP id b65so87550845wmf.0
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2017 04:13:30 -0800 (PST)
Subject: Re: [PATCH v7 1/2] media: i2c/ov5645: add the device tree binding
 document
To: Todor Tomov <todor.tomov@linaro.org>, robh+dt@kernel.org
References: <1479119076-26363-1-git-send-email-todor.tomov@linaro.org>
 <1479119076-26363-2-git-send-email-todor.tomov@linaro.org>
Cc: pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <58932265.6050000@linaro.org>
Date: Thu, 2 Feb 2017 14:13:25 +0200
MIME-Version: 1.0
In-Reply-To: <1479119076-26363-2-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Could you please take a look again at this patch?

It had received an Ack from you for patch v3. Up to v7 the changes are:
- frequency of the sensor external clock added to DT;
- names of the hardware pins of the gpios are added in the description
  (the -gpios properties are still the same).

Best regards,
Todor


On 11/14/2016 12:24 PM, Todor Tomov wrote:
> Add the document for ov5645 device tree binding.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
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
> +					remote-endpoint = <&csi0_ep>;
> +				};
> +			};
> +		};
> +	};
> 

