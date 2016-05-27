Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38720 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbcE0LdC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 07:33:02 -0400
Subject: Re: [PATCH v4 6/7] ARM: dts: exynos: convert MFC device to generic
 reserved memory bindings
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-7-git-send-email-m.szyprowski@samsung.com>
 <0158bb7a-02cf-bbb3-f903-d99c7351dfc4@osg.samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <f0148d4b-a69c-c84b-4a5e-4ff6bb9fde6f@samsung.com>
Date: Fri, 27 May 2016 13:32:57 +0200
MIME-version: 1.0
In-reply-to: <0158bb7a-02cf-bbb3-f903-d99c7351dfc4@osg.samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,


On 2016-05-25 19:11, Javier Martinez Canillas wrote:
> Hello Marek,
>
> On 05/24/2016 09:31 AM, Marek Szyprowski wrote:
>> This patch replaces custom properties for defining reserved memory
>> regions with generic reserved memory bindings for MFC video codec
>> device.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
> [snip]
>
>> +
>> +/ {
>> +	reserved-memory {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		ranges;
>> +
>> +		mfc_left: region@51000000 {
>> +			compatible = "shared-dma-pool";
>> +			no-map;
>> +			reg = <0x51000000 0x800000>;
>> +		};
>> +
>> +		mfc_right: region@43000000 {
>> +			compatible = "shared-dma-pool";
>> +			no-map;
>> +			reg = <0x43000000 0x800000>;
>> +		};
>> +	};
> I've a question probably for a follow up patch, but do you know what's a
> sane default size for these? I needed to bump the mfc_left size from 8 MiB
> to 16 MiB in order to decode a 480p H264 video using GStramer. So clearly
> the default sizes are not that useful.

Right, the default size for the 'left' region can be increased. Frankly, 
those
values (8MiB/0x43000000+ 8MiB/0x51000000) comes from my initial patches
prepared for some demo and don't have much with any real requirements. They
were copied (blindly...) by various developers without any deeper 
understanding.
Probably the most sane would be to use something like this:

mfc_left: region_mfc_left {
          compatible = "shared-dma-pool";
          no-map;
          size = <0x1000000>;
          alignment = <0x100000>;
};

mfc_right: region_mfc_right {
          compatible = "shared-dma-pool";
          no-map;
          size = <0x800000>;
          alignment = <0x100000>;
};

So the region will be allocated automatically from the available memory. 
This way
another nice feature of the generic reserved memory regions can be used.

The only platform which really requires MFC regions to be placed at 
certain memory
offsets is Samsung S5PV210/S5PC110 (sometimes called exynos3), where 
there is no
memory address interleaving and MFC device has limited memory interface, 
which cannot
do 2 transactions to the same physical memory bank. However 
S5PV210/S5PC110 machine
code lost support for MFC during conversion to device tree, so it is not 
a problem
here.

All newer platforms (Exynos4, Exynos3250, Exynos5+) use memory 
interleaving, so the
actual offset of memory bank has no influence on the physical memory bank.

>> +};
>> diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
>> index ad7394c..f5e4eb2 100644
>> --- a/arch/arm/boot/dts/exynos4210-origen.dts
>> +++ b/arch/arm/boot/dts/exynos4210-origen.dts
>> @@ -18,6 +18,7 @@
>>   #include "exynos4210.dtsi"
>>   #include <dt-bindings/gpio/gpio.h>
>>   #include <dt-bindings/input/input.h>
>> +#include "exynos-mfc-reserved-memory.dtsi"
>>   
>>   / {
>>   	model = "Insignal Origen evaluation board based on Exynos4210";
>> @@ -288,8 +289,7 @@
>>   };
>>   
>>   &mfc {
>> -	samsung,mfc-r = <0x43000000 0x800000>;
>> -	samsung,mfc-l = <0x51000000 0x800000>;
>> +	memory-region = <&mfc_left>, <&mfc_right>;
>>   	status = "okay";
> I wonder if shouldn't be better to include the exynos-mfc-reserved-memory.dtsi
> on each SoC dtsi and set the memory-regions in the MFC node instead of doing
> it on each DTS, and let DTS to just replace with its own memory regions if the
> default sizes are not suitable for them.

I don't have strong opinion on this. Maybe it would make more sense to 
move the
following entry:

&mfc {
         memory-region = <&mfc_left>, <&mfc_right>;
};

also to the exynos-mfc-reserved-memory.dtsi ? So board will just include 
it if
it want to use MFC device with reserved memory regions.

> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

