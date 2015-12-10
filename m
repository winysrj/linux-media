Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33341 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbLJHp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 02:45:29 -0500
Subject: Re: [PATCH v2 2/7] ARM: dts: exynos4412-odroid*: enable MFC device
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1449669502-24601-1-git-send-email-m.szyprowski@samsung.com>
 <1449669502-24601-3-git-send-email-m.szyprowski@samsung.com>
 <56692D42.2090809@samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <56692D91.70506@samsung.com>
Date: Thu, 10 Dec 2015 16:45:21 +0900
MIME-version: 1.0
In-reply-to: <56692D42.2090809@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.12.2015 16:44, Krzysztof Kozlowski wrote:
> On 09.12.2015 22:58, Marek Szyprowski wrote:
>> Enable support for Multimedia Codec (MFC) device for all Exynos4412-based

... and one more finding: I think the abbreviation is Multi Format Codec.

BR,
Krzysztof

>> Odroid boards.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos4412-odroid-common.dtsi | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
>> index edf0fc8..5825abf 100644
>> --- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
>> +++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
>> @@ -18,6 +18,24 @@
>>  		stdout-path = &serial_1;
>>  	};
>>  
>> +	reserved-memory {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		ranges;
>> +
>> +		mfc_left: region@77000000 {
>> +			compatible = "shared-dma-pool";
>> +			reusable;
>> +			reg = <0x77000000 0x1000000>;
> 
> Doesn't this exceed the memory of Odroid X?
> 
> For other Exynos4412 boards the length is 0x800000. I am curious: any
> particular reason for the difference?
> 
> Best regards,
> Krzysztof
> 
> 

