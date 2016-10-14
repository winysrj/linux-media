Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36133 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754366AbcJNMBO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 08:01:14 -0400
Received: by mail-lf0-f45.google.com with SMTP id b75so191904802lfg.3
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2016 05:01:13 -0700 (PDT)
Subject: Re: [PATCH v6 1/2] media: i2c/ov5645: add the device tree binding
 document
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <1473326035-25228-2-git-send-email-todor.tomov@linaro.org>
 <5464790.La2jRYUjpB@avalon>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5800C904.8080002@linaro.org>
Date: Fri, 14 Oct 2016 15:01:08 +0300
MIME-Version: 1.0
In-Reply-To: <5464790.La2jRYUjpB@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the review.

On 09/08/2016 03:22 PM, Laurent Pinchart wrote:
> Hi Todor,
> 
> Thank you for the patch.
> 
> On Thursday 08 Sep 2016 12:13:54 Todor Tomov wrote:
>> Add the document for ov5645 device tree binding.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/i2c/ov5645.txt       | 52 +++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>> b/Documentation/devicetree/bindings/media/i2c/ov5645.txt new file mode
>> 100644
>> index 0000000..bcf6dba
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>> @@ -0,0 +1,52 @@
>> +* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
>> +
>> +The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image sensor
>> with +an active array size of 2592H x 1944V. It is programmable through a
>> serial I2C +interface.
>> +
>> +Required Properties:
>> +- compatible: Value should be "ovti,ov5645".
>> +- clocks: Reference to the xclk clock.
>> +- clock-names: Should be "xclk".
>> +- clock-frequency: Frequency of the xclk clock.
>> +- enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH.
>> +- reset-gpios: Chip reset GPIO. Polarity is GPIO_ACTIVE_LOW.
> 
> Shouldn't the enable and reset GPIOs be optional ?
I don't think so. The operations on the GPIOs are part of the power up sequence
of the sensor so we must have control over them to execute the exact sequence.

> 
>> +- vdddo-supply: Chip digital IO regulator.
>> +- vdda-supply: Chip analog regulator.
>> +- vddd-supply: Chip digital core regulator.
>> +
>> +The device node must contain one 'port' child node for its digital output
>> +video port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +
>> +	&i2c1 {
>> +		...
>> +
>> +		ov5645: ov5645@78 {
>> +			compatible = "ovti,ov5645";
>> +			reg = <0x78>;
>> +
>> +			enable-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
>> +			reset-gpios = <&gpio5 20 GPIO_ACTIVE_LOW>;
>> +			pinctrl-names = "default";
>> +			pinctrl-0 = <&camera_rear_default>;
>> +
>> +			clocks = <&clks 200>;
>> +			clock-names = "xclk";
>> +			clock-frequency = <23880000>;
>> +
>> +			vdddo-supply = <&camera_dovdd_1v8>;
>> +			vdda-supply = <&camera_avdd_2v8>;
>> +			vddd-supply = <&camera_dvdd_1v2>;
>> +
>> +			port {
>> +				ov5645_ep: endpoint {
>> +					clock-lanes = <1>;
>> +					data-lanes = <0 2>;
>> +					remote-endpoint = <&csi0_ep>;
>> +				};
>> +			};
>> +		};
>> +	};
> 

-- 
Best regards,
Todor Tomov
