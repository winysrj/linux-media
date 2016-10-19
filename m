Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:32821 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942902AbcJSOm1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:42:27 -0400
Received: by mail-vk0-f53.google.com with SMTP id 83so29257504vkd.0
        for <linux-media@vger.kernel.org>; Wed, 19 Oct 2016 07:42:26 -0700 (PDT)
Subject: Re: [PATCH v6 1/2] media: i2c/ov5645: add the device tree binding
 document
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <5464790.La2jRYUjpB@avalon> <5800C904.8080002@linaro.org>
 <5771512.gQUqkxEut4@avalon>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5807398F.9060802@linaro.org>
Date: Wed, 19 Oct 2016 12:14:55 +0300
MIME-Version: 1.0
In-Reply-To: <5771512.gQUqkxEut4@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the review.

On 10/19/2016 11:49 AM, Laurent Pinchart wrote:
> Hi Todor,
> 
> On Friday 14 Oct 2016 15:01:08 Todor Tomov wrote:
>> On 09/08/2016 03:22 PM, Laurent Pinchart wrote:
>>> On Thursday 08 Sep 2016 12:13:54 Todor Tomov wrote:
>>>> Add the document for ov5645 device tree binding.
>>>>
>>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>>> ---
>>>>
>>>>  .../devicetree/bindings/media/i2c/ov5645.txt       | 52 ++++++++++++++++
>>>>  1 file changed, 52 insertions(+)
>>>>  create mode 100644
>>>>  Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>>> b/Documentation/devicetree/bindings/media/i2c/ov5645.txt new file mode
>>>> 100644
>>>> index 0000000..bcf6dba
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>>> @@ -0,0 +1,52 @@
>>>> +* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
>>>> +
>>>> +The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image
>>>> sensor with
>>>> +an active array size of 2592H x 1944V. It is programmable through a
>>>> serial I2C
>>>> +interface.
>>>> +
>>>> +Required Properties:
>>>> +- compatible: Value should be "ovti,ov5645".
>>>> +- clocks: Reference to the xclk clock.
>>>> +- clock-names: Should be "xclk".
>>>> +- clock-frequency: Frequency of the xclk clock.
>>>> +- enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH.
> 
> By the way, isn't the pin called pwdnb and isn't it active low ?

Yes, the pin is called "pwdnb" and is active low (must be up for power to be up).
I have changed the name to "enable" as it is more generally used - this change
was suggested by Rob Herring. As the logic switches with this change of the name
I have stated it is active high which ends up in the same condition (enable
must be up for the power to be up). I think this is correct, isn't it?

> 
>>>> +- reset-gpios: Chip reset GPIO. Polarity is GPIO_ACTIVE_LOW.
>>>
>>> Shouldn't the enable and reset GPIOs be optional ?
>>
>> I don't think so. The operations on the GPIOs are part of the power up
>> sequence of the sensor so we must have control over them to execute the
>> exact sequence.
> 
> Right, let's keep them mandatory. If we later have to make them optional for a 
> board that pulls one of those signals up (assuming this can work at all) we'll 
> revisit the bindings.

Ok.

> 
>>>> +- vdddo-supply: Chip digital IO regulator.
>>>> +- vdda-supply: Chip analog regulator.
>>>> +- vddd-supply: Chip digital core regulator.
>>>> +
>>>> +The device node must contain one 'port' child node for its digital
>>>> output
>>>> +video port, in accordance with the video interface bindings defined in
>>>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>>>> +
>>>> +Example:
>>>> +
>>>> +	&i2c1 {
>>>> +		...
>>>> +
>>>> +		ov5645: ov5645@78 {
>>>> +			compatible = "ovti,ov5645";
>>>> +			reg = <0x78>;
>>>> +
>>>> +			enable-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
>>>> +			reset-gpios = <&gpio5 20 GPIO_ACTIVE_LOW>;
>>>> +			pinctrl-names = "default";
>>>> +			pinctrl-0 = <&camera_rear_default>;
>>>> +
>>>> +			clocks = <&clks 200>;
>>>> +			clock-names = "xclk";
>>>> +			clock-frequency = <23880000>;
>>>> +
>>>> +			vdddo-supply = <&camera_dovdd_1v8>;
>>>> +			vdda-supply = <&camera_avdd_2v8>;
>>>> +			vddd-supply = <&camera_dvdd_1v2>;
>>>> +
>>>> +			port {
>>>> +				ov5645_ep: endpoint {
>>>> +					clock-lanes = <1>;
>>>> +					data-lanes = <0 2>;
>>>> +					remote-endpoint = <&csi0_ep>;
>>>> +				};
>>>> +			};
>>>> +		};
>>>> +	};
> 

-- 
Best regards,
Todor Tomov
