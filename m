Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58563 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaLCJud (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 04:50:33 -0500
Message-ID: <547EDCAE.50001@atmel.com>
Date: Wed, 3 Dec 2014 17:49:34 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>, <g.liakhovetski@gmx.de>,
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/4] media: ov2640: dt: add the device tree binding document
References: <1417170507-11172-1-git-send-email-josh.wu@atmel.com> <1417170507-11172-5-git-send-email-josh.wu@atmel.com> <3353234.ED9pHT6goB@avalon>
In-Reply-To: <3353234.ED9pHT6goB@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 12/2/2014 6:14 AM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Friday 28 November 2014 18:28:27 Josh Wu wrote:
>> Add the document for ov2640 dt.
>>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>   .../devicetree/bindings/media/i2c/ov2640.txt       | 43 +++++++++++++++++++
>>   1 file changed, 43 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt
>> b/Documentation/devicetree/bindings/media/i2c/ov2640.txt new file mode
>> 100644
>> index 0000000..adec147
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
>> @@ -0,0 +1,43 @@
>> +* Omnivision ov2640 CMOS sensor
>> +
>> +The Omnivision OV2640 sensor support multiple resolutions output, such as
>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
>> +output format.
>> +
>> +Required Properties :
>> +- compatible      : Must be "omnivision,ov2640"
> The usual practice is to use the company's stock ticker as a prefix. In this
> case the compatible string would be "ovti,ov2640". You need to add the prefix
> to Documentation/devicetree/bindings/vendor-prefixes.txt.
>
>> +- reset-gpio      : reset pin
>> +- power-down-gpio : power down pin
> That should be reset-gpios and power-down-gpios, even if there's a single
> GPIO. Furthermore, given that the power down pin is named PWDN you might want
> to name the property pwdn-gpios.
>
> The reset and pwdn signals won't be connected on all boards, so the two
> properties should be optional.
>
>> +Optional Properties:
>> +- clocks          : reference master clock, if using external fixed clock,
>> you
>> +                    no need to have such property.
> The clock is required by the chip, so even when using an external fixed clock
> the property should be present, and reference a fixed clock node. The clocks
> and clock-names properties should thus be mandatory.
>
>> +- clock-names     : Must be "mck", it means the master clock for ov2640.
> The clock input is named xvclk in the datasheet, you should use the same name
> here.
>
>> +
>> +For further reading of port node refer
>> Documentation/devicetree/bindings/media/
>> +video-interfaces.txt.
> Even if you reference that document you should still mention what port node(s)
> these bindings require. Something like the following text should be enough.
>
> "The device node must contain one 'port' child node for its digital output
> video port, in accordance with the video interface bindings defined in
> Documentation/devicetree/bindings/media/video-interfaces.txt."
>
>> +
>> +Example:
>> +
>> +	i2c1: i2c@f0018000 {
>> +		ov2640: camera@0x30 {
>> +			compatible = "omnivision,ov2640";
>> +			reg = <0x30>;
>> +
>> +			... ...
> No need for an ellipsis, what are you trying to hide ? :-)

I just emit the pinctrl property here. Will add it back.
>
>> +
>> +			reset-gpio = <&pioE 24 GPIO_ACTIVE_HIGH>;
>> +			power-down-gpio = <&pioE 29 GPIO_ACTIVE_HIGH>;
>> +
>> +			/* use pck1 for the master clock of ov2640 */
> I think you can drop the comment.

I will send a new version which will fix all above.
Thanks for your time to review the patch. That help me a lot.

Best Regards,
Josh Wu

>
>> +			clocks = <&pck1>;
>> +			clock-names = "mck";
>> +
>> +			port {
>> +				ov2640_0: endpoint {
>> +					remote-endpoint = <&isi_0>;
>> +					bus-width = <8>;
>> +				};
>> +			};
>> +		};
>> +	};

