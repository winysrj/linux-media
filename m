Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38423 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbeGDPwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 11:52:02 -0400
Received: by mail-wm0-f68.google.com with SMTP id 69-v6so6476538wmf.3
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 08:52:02 -0700 (PDT)
References: <20180703140803.19580-1-rui.silva@linaro.org> <20180703140803.19580-2-rui.silva@linaro.org> <20180704085801.GB4463@w540>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v7 1/2] media: ov2680: dt: Add bindings for OV2680
In-reply-to: <20180704085801.GB4463@w540>
Date: Wed, 04 Jul 2018 16:51:59 +0100
Message-ID: <m3a7r7robk.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,
Hope your fine.
Thanks for the review.

On Wed 04 Jul 2018 at 09:58, jacopo mondi wrote:
> Hi Rui,
>    sorry, I'm a bit late, you're already at v7 and I don't want 
>    to
> slow down inclusion with a few minor comments.
>
> Please bear with me and see below...
>
> On Tue, Jul 03, 2018 at 03:08:02PM +0100, Rui Miguel Silva 
> wrote:
>> Add device tree binding documentation for the OV2680 camera 
>> sensor.
>>
>> CC: devicetree@vger.kernel.org
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  .../devicetree/bindings/media/i2c/ov2680.txt  | 46 
>>  +++++++++++++++++++
>>  1 file changed, 46 insertions(+)
>>  create mode 100644 
>>  Documentation/devicetree/bindings/media/i2c/ov2680.txt
>>
>> diff --git 
>> a/Documentation/devicetree/bindings/media/i2c/ov2680.txt 
>> b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
>> new file mode 100644
>> index 000000000000..11e925ed9dad
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
>> @@ -0,0 +1,46 @@
>> +* Omnivision OV2680 MIPI CSI-2 sensor
>> +
>> +Required Properties:
>> +- compatible: should be "ovti,ov2680".
>> +- clocks: reference to the xvclk input clock.
>> +- clock-names: should be "xvclk".
>
> Having a single clock source I think you can omit 'clock-names' 
> (or at
> least not marking it as required)

yeah, I see you point, but really all other OV sensors share this 
and
the bellow clock/data-lanes properties as required, I will let Rob 
or
Sakari take a call in this one.

---
Cheers,
	Rui

>
>> +- DOVDD-supply: Digital I/O voltage supply.
>> +- DVDD-supply: Digital core voltage supply.
>> +- AVDD-supply: Analog voltage supply.
>> +
>> +Optional Properties:
>> +- reset-gpios: reference to the GPIO connected to the 
>> powerdown/reset pin,
>> +               if any. This is an active low signal to the 
>> OV2680.
>> +
>> +The device node must contain one 'port' child node for its 
>> digital output
>> +video port, and this port must have a single endpoint in 
>> accordance with
>> + the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Endpoint node required properties for CSI-2 connection are:
>> +- remote-endpoint: a phandle to the bus receiver's endpoint 
>> node.
>> +- clock-lanes: should be set to <0> (clock lane on hardware 
>> lane 0).
>> +- data-lanes: should be set to <1> (one CSI-2 lane supported).
>
> What is the value of marking as required two properties which 
> can only have
> default values (the sensor does not support clock on different 
> lanes,
> nor it supports more than 1 data lane) ?
>
> Thanks
>    j
>
>> +
>> +Example:
>> +
>> +&i2c2 {
>> +	ov2680: camera-sensor@36 {
>> +		compatible = "ovti,ov2680";
>> +		reg = <0x36>;
>> +		clocks = <&osc>;
>> +		clock-names = "xvclk";
>> +		reset-gpios = <&gpio1 3 GPIO_ACTIVE_LOW>;
>> +		DOVDD-supply = <&sw2_reg>;
>> +		DVDD-supply = <&sw2_reg>;
>> +		AVDD-supply = <&reg_peri_3p15v>;
>> +
>> +		port {
>> +			ov2680_to_mipi: endpoint {
>> +				remote-endpoint = 
>> <&mipi_from_sensor>;
>> +				clock-lanes = <0>;
>> +				data-lanes = <1>;
>> +			};
>> +		};
>> +	};
>> +};
>> --
>> 2.18.0
>>
