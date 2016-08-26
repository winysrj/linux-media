Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:36125 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750999AbcHZHpj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 03:45:39 -0400
Subject: Re: [RFC PATCH 5/7] ov7670: add devicetree support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
 <1471415383-38531-6-git-send-email-hverkuil@xs4all.nl>
 <3513546.0HAk52lbkG@avalon>
Cc: linux-media@vger.kernel.org, Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <86f01ea7-984c-0b9e-477a-c04f61d44db1@xs4all.nl>
Date: Fri, 26 Aug 2016 09:45:25 +0200
MIME-Version: 1.0
In-Reply-To: <3513546.0HAk52lbkG@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/17/2016 02:44 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Wednesday 17 Aug 2016 08:29:41 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add DT support. Use it to get the reset and pwdn pins (if there are any).
>> Tested with one sensor requiring reset/pwdn and one sensor that doesn't
>> have reset/pwdn pins.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  .../devicetree/bindings/media/i2c/ov7670.txt       | 44 +++++++++++++++++
>>  MAINTAINERS                                        |  1 +
>>  drivers/media/i2c/ov7670.c                         | 51 +++++++++++++++++++
>>  3 files changed, 96 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt
>> b/Documentation/devicetree/bindings/media/i2c/ov7670.txt new file mode
>> 100644
>> index 0000000..3231c47
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
>> @@ -0,0 +1,44 @@
>> +* Omnivision OV7670 CMOS sensor
>> +
>> +The Omnivision OV7670 sensor support multiple resolutions output, such as
> 
> s/support/supports/
> 
>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
>> +output format.
> 
> s/format/formats/ (and possibly s/can support/can support the/)
> 
>> +
>> +Required Properties:
>> +- compatible: should be "ovti,ov7670"
>> +- clocks: reference to the xvclk input clock.
>> +- clock-names: should be "xvclk".
>> +
>> +Optional Properties:
>> +- resetb-gpios: reference to the GPIO connected to the resetb pin, if any.
>> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.
>> +
>> +The device node must contain one 'port' child node for its digital output
>> +video port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +
>> +	i2c1: i2c@f0018000 {
>> +		status = "okay";
>> +
>> +		ov7670: camera@0x21 {
>> +			compatible = "ovti,ov7670";
>> +			reg = <0x21>;
>> +			pinctrl-names = "default";
>> +			pinctrl-0 = <&pinctrl_pck0_as_isi_mck
>> &pinctrl_sensor_power
>> &pinctrl_sensor_reset>;
> 
> The pinctrl properties should be part of the clock provider DT node.

Do you have examples of that?

I just copied this from existing atmel dts code (arch/arm/boot/dts/sama5d3xmb.dtsi).

> 
>> +			resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
>> +			pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
>> +			clocks = <&pck0>;
>> +			clock-names = "xvclk";
>> +			assigned-clocks = <&pck0>;
>> +			assigned-clock-rates = <24000000>;
> 
> You should compute and set the clock rate dynamically in the driver, not 
> hardcode it in DT.

Do you have an example of that? Again, I just copied this from the same sama5d3xmb.dtsi.

Regards,

	Hans
