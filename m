Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19820 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933817AbaCSMCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 08:02:49 -0400
Message-id: <53298762.9090604@samsung.com>
Date: Wed, 19 Mar 2014 13:02:42 +0100
From: Tomasz Figa <t.figa@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	s.nawrocki@samsung.com, m.chehab@samsung.com,
	b.zolnierkie@samsung.com, k.debski@samsung.com, arun.kk@samsung.com
Subject: Re: [PATCH v6 1/4] [media] exynos-scaler: Add DT bindings for SCALER
 driver
References: <1395213196-25972-1-git-send-email-shaik.ameer@samsung.com>
 <1395213196-25972-2-git-send-email-shaik.ameer@samsung.com>
 <4637278.9G3gGkQ5GA@avalon>
In-reply-to: <4637278.9G3gGkQ5GA@avalon>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 19.03.2014 12:31, Laurent Pinchart wrote:
> Hi Shaik,
>
> Thank you for the patch.
>
> On Wednesday 19 March 2014 12:43:13 Shaik Ameer Basha wrote:
>> This patch adds the DT binding documentation for the Exynos5420/5410
>> based SCALER device driver.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>   .../devicetree/bindings/media/exynos5-scaler.txt   |   24 +++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/media/exynos5-scaler.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-scaler.txt
>> b/Documentation/devicetree/bindings/media/exynos5-scaler.txt new file mode
>> 100644
>> index 0000000..e1dd465
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
>> @@ -0,0 +1,24 @@
>> +* Samsung Exynos5 SCALER device
>> +
>> +SCALER is used for scaling, blending, color fill and color space
>> +conversion on EXYNOS[5420/5410] SoCs.
>> +
>> +Required properties:
>> +- compatible: should be "samsung,exynos5420-scaler" or
>> +			"samsung,exynos5410-scaler"
>> +- reg: should contain SCALER physical address location and length
>> +- interrupts: should contain SCALER interrupt specifier
>> +- clocks: should contain the SCALER clock phandle and specifier pair for
>> +		each clock listed in clock-names property, according to
>> +		the common clock bindings
>> +- clock-names: should contain exactly one entry
>> +		- "scaler" - IP bus clock
>
> I'm not too familiar with the Exynos platform, but wouldn't it make sense to
> use a common name across IP cores for interface and function clocks ?

Yes, it would definitely make sense, provided we are starting from 
scratch, but due to the lack of listed IP clock inputs in documentation, 
we ended with a custom of naming the inputs after SoC clocks of first 
SoC used with such driver. This showed up long before adoption of DT and 
common clocks on Samsung platform and I'd say it would be hard to get 
rid of it now.

Anyway, as long as clock names are well specified in binding 
documentation, it should be fine. So, from me it's a

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
