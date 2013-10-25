Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52986 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab3JYKgL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Oct 2013 06:36:11 -0400
Message-ID: <526A4959.1040405@ti.com>
Date: Fri, 25 Oct 2013 16:05:05 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>, <tomi.valkeinen@ti.com>,
	Rajendra Nayak <rnayak@ti.com>,
	Sricharan R <r.sricharan@ti.com>
Subject: Re: [PATCH 6/6] experimental: arm: dts: dra7xx: Add a DT node for
 VPE
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-7-git-send-email-archit@ti.com> <16994189.3ZRYT6i8Y5@avalon>
In-Reply-To: <16994189.3ZRYT6i8Y5@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Sorry about the late response, I had scrapped the DT patch out of the 
VPE series since there were dependencies on crossbar drivers and some 
other baseport stuff. Comments below.

On Friday 09 August 2013 03:41 AM, Laurent Pinchart wrote:
> Hi Archit,
>
> Thank you for the patch.
>
> On Friday 02 August 2013 19:33:43 Archit Taneja wrote:
>> Add a DT node for VPE in dra7.dtsi. This is experimental because we might
>> need to split the VPE address space a bit more, and also because the IRQ
>> line described is accessible the IRQ crossbar driver is added for DRA7XX.
>>
>> Cc: Rajendra Nayak <rnayak@ti.com>
>> Cc: Sricharan R <r.sricharan@ti.com>
>> Signed-off-by: Archit Taneja <archit@ti.com>
>> ---
>>   arch/arm/boot/dts/dra7.dtsi | 11 +++++++++++
>
> Documentation is missing :-) As this is an experimental patch you can probably
> document the bindings later.

Yes, I will work on that.

>
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
>> index ce9a0f0..3237972 100644
>> --- a/arch/arm/boot/dts/dra7.dtsi
>> +++ b/arch/arm/boot/dts/dra7.dtsi
>> @@ -484,6 +484,17 @@
>>   			dmas = <&sdma 70>, <&sdma 71>;
>>   			dma-names = "tx0", "rx0";
>>   		};
>> +
>> +		vpe {
>> +			compatible = "ti,vpe";
>> +			ti,hwmods = "vpe";
>> +			reg = <0x489d0000 0xd000>, <0x489dd000 0x400>;
>> +			reg-names = "vpe", "vpdma";
>> +			interrupts = <0 159 0x4>;
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>
> Are #address-cells and #size-cells really needed ?

These aren't needed, vpe derives the address info from it's parent(ocp). 
I didn't know that the child nodes inherit these params from the parent.

Archit

