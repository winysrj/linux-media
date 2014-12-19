Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:14301 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaLSFhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 00:37:35 -0500
Message-ID: <5493B990.7020302@atmel.com>
Date: Fri, 19 Dec 2014 13:37:20 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
	<plagnioj@jcrosoft.com>, <boris.brezillon@free-electrons.com>,
	<alexandre.belloni@free-electrons.com>,
	<devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
	<linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 6/7] ARM: at91: dts: sama5d3: add ov2640 camera sensor
 support
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com> <1418892667-27428-7-git-send-email-josh.wu@atmel.com> <5518219.5PdO7T0ydL@avalon>
In-Reply-To: <5518219.5PdO7T0ydL@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi, Laurent

On 12/18/2014 8:32 PM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Thursday 18 December 2014 16:51:06 Josh Wu wrote:
>> According to v4l2 dt document, we add:
>>    a camera host: ISI port.
>>    a i2c camera sensor: ov2640 port.
>> to sama5d3xmb.dtsi.
>>
>> In the ov2640 node, it defines the pinctrls, clocks and isi port.
>> In the ISI node, it also reference to a ov2640 port.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>   arch/arm/boot/dts/sama5d3xmb.dtsi | 32 ++++++++++++++++++++++++++++++++
>>   1 file changed, 32 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi
>> b/arch/arm/boot/dts/sama5d3xmb.dtsi index 0aaebc6..958a528 100644
>> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
>> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
>> @@ -52,6 +52,29 @@
>>   				};
>>   			};
>>
>> +			i2c1: i2c@f0018000 {
>> +				ov2640: camera@0x30 {
>> +					compatible = "ovti,ov2640";
>> +					reg = <0x30>;
>> +					pinctrl-names = "default";
>> +					pinctrl-0 = <&pinctrl_isi_pck_as_mck
>> &pinctrl_sensor_power &pinctrl_sensor_reset>;
>> +					resetb-gpios = <&pioE 24 GPIO_ACTIVE_LOW>;
>> +					pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
>> +					/* use pck1 for the master clock of ov2640 */
>> +					clocks = <&pck1>;
>> +					clock-names = "xvclk";
>> +					assigned-clocks = <&pck1>;
>> +					assigned-clock-rates = <25000000>;
>> +
>> +					port {
>> +						ov2640_0: endpoint {
>> +							remote-endpoint = <&isi_0>;
>> +							bus-width = <8>;
>> +						};
>> +					};
>> +				};
>> +			};
>> +
>>   			usart1: serial@f0020000 {
>>   				dmas = <0>, <0>;	/*  Do not use DMA for usart1 */
>>   				pinctrl-names = "default";
>> @@ -60,6 +83,15 @@
>>   			};
>>
>>   			isi: isi@f0034000 {
>> +				port {
>> +					#address-cells = <1>;
>> +					#size-cells = <0>;
>> +
> I would add the port node and those two properties to
> arch/arm/boot/dts/sama5d3.dtsi, as the isi has a single port. The endpoint, of
> course, should stay in this file.

That makes sense. I'll fix that. Thanks for the review.

Best Regards,
Josh Wu
>
>> +					isi_0: endpoint {
>> +						remote-endpoint = <&ov2640_0>;
>> +						bus-width = <8>;
>> +					};
>> +				};
>>   			};
>>
>>   			mmc1: mmc@f8000000 {

