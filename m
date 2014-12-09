Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:58188 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756508AbaLIDTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 22:19:49 -0500
Message-ID: <54866A44.2020600@atmel.com>
Date: Tue, 9 Dec 2014 11:19:32 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>, <g.liakhovetski@gmx.de>,
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/5] media: ov2640: dt: add the device tree binding document
References: <1418038147-13221-1-git-send-email-josh.wu@atmel.com> <1418038147-13221-6-git-send-email-josh.wu@atmel.com> <7239028.nL31Mosllm@avalon>
In-Reply-To: <7239028.nL31Mosllm@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 12/9/2014 2:59 AM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Monday 08 December 2014 19:29:07 Josh Wu wrote:
>> Add the document for ov2640 dt.
>>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>> v1 -> v2:
>>    1. change the compatible string to be consistent with verdor file.
> That's nice, but you still need to send a patch to add the ovti vendor prefix
> to Documentation/devicetree/bindings/vendor-prefixes.txt. It's not there yet.
As Fabio already send a patch to fix the vendor file.
See URL: http://patchwork.ozlabs.org/patch/416685/
I think it will go to mainline soon.

>
>>    2. change the clock and pins' name.
>>    3. add missed pinctrl in example.
>>
>>   .../devicetree/bindings/media/i2c/ov2640.txt       | 44 +++++++++++++++++++
>>   1 file changed, 44 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt
>> b/Documentation/devicetree/bindings/media/i2c/ov2640.txt new file mode
>> 100644
>> index 0000000..15be3cb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
>> @@ -0,0 +1,44 @@
>> +* Omnivision ov2640 CMOS sensor
>> +
>> +The Omnivision OV2640 sensor support multiple resolutions output, such as
>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
>> +output format.
>> +
>> +Required Properties :
>> +- compatible: Must be "ovti,ov2640"
>> +- clocks: reference master clock, if using external fixed clock, you
>> +          no need to have such property.
> That's not true anymore, the clocks property is mandatory in all cases. Just
> describe it as
>
> - clocks: reference to the xvclk input clock.
>
>> +- clock-names: Must be "xvclk", it means the master clock for ov2640.
> I would drop "it means the master clock for ov2640".
>
>> +Optional Properties:
>> +- resetb-gpios: reset pin
> - resetb-gpios: reference to the GPIO connected to the resetb pin, if any.
>
>> +- pwdn-gpios: power down pin
> - pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.

I'll fix all above that you mentioned in next version.
Thank a lot for the review.

Best Regards,
Josh Wu
>
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
> &pinctrl_ov2640_reset>;
>> +
>> +			resetb-gpios = <&pioE 24 GPIO_ACTIVE_HIGH>;
>> +			pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
>> +
>> +			clocks = <&pck1>;
>> +			clock-names = "xvclk";
>> +
>> +			port {
>> +				ov2640_0: endpoint {
>> +					remote-endpoint = <&isi_0>;
>> +					bus-width = <8>;
>> +				};
>> +			};
>> +		};
>> +	};

