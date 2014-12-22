Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:61912 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957AbaLVKcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 05:32:13 -0500
Message-ID: <5497F327.4040903@atmel.com>
Date: Mon, 22 Dec 2014 18:32:07 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>,
	<m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, <festevam@gmail.com>,
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] media: ov2640: dt: add the device tree binding
 document
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <1418869646-17071-6-git-send-email-josh.wu@atmel.com> <5492C4E3.4050401@samsung.com>
In-Reply-To: <5492C4E3.4050401@samsung.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sylwester

On 12/18/2014 8:13 PM, Sylwester Nawrocki wrote:
> Hi Josh,
>
> On 18/12/14 03:27, Josh Wu wrote:
>> Add the document for ov2640 dt.
>>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Thanks.

>
> It seems "ovti" is not in the list of vendor prefixes. You may want
> to send a patch adding it to Documentation/devicetree/bindings/
> vendor-prefixes.txt.
>
> Just few minor comments below..
>
>>   .../devicetree/bindings/media/i2c/ov2640.txt       | 46 ++++++++++++++++++++++
>>   1 file changed, 46 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
>> new file mode 100644
>> index 0000000..de11ebb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
>> @@ -0,0 +1,46 @@
>> +* Omnivision ov2640 CMOS sensor
> s/ov2640/OV2640 ?

OK.
>
>> +
>> +The Omnivision OV2640 sensor support multiple resolutions output, such as
>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
>> +output format.
>> +
>> +Required Properties:
>> +- compatible: Must be "ovti,ov2640"
> I believe it is preferred to put it as "Should contain", rather than
> "Must be".
I don't have a strong opinion here. After check many documents, it seems 
many people use "Should be".
Is it okay?

Best Regards,
Josh Wu

>
>> +- clocks: reference to the xvclk input clock.
>> +- clock-names: Must be "xvclk".
> --
> Regards,
> Sylwester

