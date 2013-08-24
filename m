Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:52609 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab3HXW0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 18:26:12 -0400
Message-ID: <521932FA.20801@gmail.com>
Date: Sun, 25 Aug 2013 00:26:02 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Inki Dae <inki.dae@samsung.com>
CC: 'Shaik Ameer Basha' <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	cpgs@samsung.com, s.nawrocki@samsung.com, posciak@google.com,
	arun.kk@samsung.com
Subject: Re: [PATCH v2 4/5] [media] exynos-mscl: Add DT bindings for M-Scaler
 driver
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com> <1376909932-23644-5-git-send-email-shaik.ameer@samsung.com> <033401ce9cdb$af145800$0d3d0800$%dae@samsung.com>
In-Reply-To: <033401ce9cdb$af145800$0d3d0800$%dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2013 02:57 PM, Inki Dae wrote:
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Shaik Ameer Basha
>> Sent: Monday, August 19, 2013 7:59 PM
>> To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
>> Cc: s.nawrocki@samsung.com; posciak@google.com; arun.kk@samsung.com;
>> shaik.ameer@samsung.com
>> Subject: [PATCH v2 4/5] [media] exynos-mscl: Add DT bindings for M-Scaler
>> driver
>>
>> This patch adds the DT binding documentation for the exynos5

You may want to say to which specific SoC it applies.

>> based M-Scaler device driver.
>>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> ---
>>   .../devicetree/bindings/media/exynos5-mscl.txt     |   34
>> ++++++++++++++++++++
>>   1 file changed, 34 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/exynos5-
>> mscl.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-mscl.txt
>> b/Documentation/devicetree/bindings/media/exynos5-mscl.txt
>> new file mode 100644
>> index 0000000..5c9d1b1
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-mscl.txt
>> @@ -0,0 +1,34 @@
>> +* Samsung Exynos5 M-Scaler device
>> +
>> +M-Scaler is used for scaling, blending, color fill and color space
>> +conversion on EXYNOS5 SoCs.
>> +
>> +Required properties:
>> +- compatible: should be "samsung,exynos5-mscl"

What is an exact name of this IP in the datasheet ?

> If Exynos5410/5420 have same IP,
> "samsung,exynos5410-mscl" for M Scaler IP in Exynos5410/5420"
>
> Else,
> Compatible: should be one of the following:
> (a) "samsung,exynos5410-mscl" for M Scaler IP in Exynos5410"
> (b) "samsung,exynos5420-mscl" for M Scaler IP in Exynos5420"

Yes, except I suspect "mscl" is incorrect. It sounds like an unclear
abbreviation of real name of the IP. It likely should be "mscaler".

>> +- reg: should contain M-Scaler physical address location and length.
>> +- interrupts: should contain M-Scaler interrupt number
>> +- clocks: should contain the clock number according to CCF

Hmm, this sounds like a Linux specific term in the binding. Perhaps:

  - clocks: should contain the M-Scaler clock specifier, from the common
	   clock bindings

?
>> +- clock-names: should be "mscl"
>> +
>> +Example:
>> +
>> +	mscl_0: mscl@0x12800000 {

s/0x//

>> +		compatible = "samsung,exynos5-mscl";
>
> "samsung,exynos5410-mscl";
>
>> +		reg =<0x12800000 0x1000>;
>> +		interrupts =<0 220 0>;
>> +		clocks =<&clock 381>;
>> +		clock-names = "mscl";
>> +	};
>> +
>> +Aliases:
>> +Each M-Scaler node should have a numbered alias in the aliases node,
>> +in the form of msclN, N = 0...2. M-Scaler driver uses these aliases
>> +to retrieve the device IDs using "of_alias_get_id()" call.

So except in debug logs and for selecting variant data (which is same for
all IP instances) are the aliases used for anything else ?
I suspect you could do without these aliases. Device name includes start
address of the IP register region, so that could be used to identify the
M-Scaler instance in the logs.

--
Regards,
Sylwester
