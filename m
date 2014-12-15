Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:33043 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaLOKfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 05:35:24 -0500
Message-ID: <548EB91E.2090900@atmel.com>
Date: Mon, 15 Dec 2014 18:34:06 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>,
	<m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<s.nawrocki@samsung.com>, <festevam@gmail.com>,
	<devicetree@vger.kernel.org>
Subject: Re: [v3][PATCH 5/5] media: ov2640: dt: add the device tree binding
 document
References: <1418283339-16281-1-git-send-email-josh.wu@atmel.com> <1418283339-16281-6-git-send-email-josh.wu@atmel.com> <1644165.4XbSUOMUsK@avalon>
In-Reply-To: <1644165.4XbSUOMUsK@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 12/12/2014 10:17 AM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Thursday 11 December 2014 15:35:39 Josh Wu wrote:
>> Add the document for ov2640 dt.
>>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>> v2 -> v3:
>>    1. fix incorrect description.
>>    2. Add assigned-clocks & assigned-clock-rates.
>>    3. resetb pin should be ACTIVE_LOW.
>>
>> v1 -> v2:
>>    1. change the compatible string to be consistent with verdor file.
>>    2. change the clock and pins' name.
>>    3. add missed pinctrl in example.
>>
>>   .../devicetree/bindings/media/i2c/ov2640.txt       | 53 +++++++++++++++++++
>>   1 file changed, 53 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt
>> b/Documentation/devicetree/bindings/media/i2c/ov2640.txt new file mode
>> 100644
>> index 0000000..958e120
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
>> @@ -0,0 +1,53 @@
>> +* Omnivision ov2640 CMOS sensor
>> +
>> +The Omnivision OV2640 sensor support multiple resolutions output, such as
>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
>> +output format.
>> +
>> +Required Properties:
>> +- compatible: Must be "ovti,ov2640"
>> +- clocks: reference to the xvclk input clock. It can be an external fixed
>> +          clock or a programmable clock from SoC.
> It could also be a variable clock provided by something else. I would just
> drop the second sentence.

I mention this since these are the cases in at91 platform.
Sure. I'll drop it.
>
>> +- clock-names: Must be "xvclk".
>> +- assigned-clocks: reference to the above 'clocks' property.
>> +- assigned-clock-rates: reference to the clock frequency of xvclk. Typical
>> +                        value is 25Mhz (25000000).
>> +                        This clock should only have single user. Specifying
>> +                        Conflicting rate configuration in multiple
>> consumer
>> +                        nodes for a shared clock is forbidden.
> Those two properties are optional. I'm not sure they should even be mentioned
> in the ov2640 bindings. For one thing they're not needed if the clock doesn't
> need to be forced to a specific frequency, and the clock rate could also be
> configured through other means depending on the platform.

hmm, if the clock is fixed then this 'assigned-clock-rates' is not needed.
And I only find one binding document mentioned the assigned-clocks. It 
looks like a general property for all clocks. We don't need mention it 
repeatedly.
So I'd like to drop this two properties in next version.

Thanks and Best Regards,
Josh Wu
>
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
>> +		ov2640: camera@0x30 {
>> +			compatible = "ovti,ov2640";
>> +			reg = <0x30>;
>> +
>> +			pinctrl-names = "default";
>> +			pinctrl-0 = <&pinctrl_pck1 &pinctrl_ov2640_pwdn
> &pinctrl_ov2640_resetb>;
>> +
>> +			resetb-gpios = <&pioE 24 GPIO_ACTIVE_LOW>;
>> +			pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
>> +
>> +			clocks = <&pck1>;
>> +			clock-names = "xvclk";
>> +
>> +			assigned-clocks = <&pck1>;
>> +			assigned-clock-rates = <25000000>;
>> +
>> +			port {
>> +				ov2640_0: endpoint {
>> +					remote-endpoint = <&isi_0>;
>> +					bus-width = <8>;
>> +				};
>> +			};
>> +		};
>> +	};

