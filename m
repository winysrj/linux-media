Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43224 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2GQSza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 14:55:30 -0400
Message-ID: <5005B51E.20505@gmail.com>
Date: Tue, 17 Jul 2012 20:55:26 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 06/13] media: s5p-fimc: Add device tree support for
 FIMC-LITE
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com> <1337975573-27117-6-git-send-email-s.nawrocki@samsung.com> <Pine.LNX.4.64.1207161114130.12302@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207161114130.12302@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2012 11:15 AM, Guennadi Liakhovetski wrote:
>> --- a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
>> +++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
>> @@ -39,6 +39,21 @@ Required properties:
>>   	       depends on the SoC revision. For S5PV210 valid values are:
>>   	       0...2, for Exynos4x1x: 0...3.
>>
>> +
>> +'fimc-lite' device node
>> +-----------------------
>> +
>> +Required properties:
>> +
>> +- compatible : should be one of:
>> +		"samsung,exynos4212-fimc";
>> +		"samsung,exynos4412-fimc";
>> +- reg	     : physical base address and size of the device's memory mapped
>> +	       registers;
>> +- interrupts : should contain FIMC-LITE interrupt;
>> +- cell-index : FIMC-LITE IP instance index;
>
> Same as in an earlier patch - not sure this is needed.

It is needed for setting up a pipeline of multiple sub-device
within a SoC. As I commented on patch 2/13 I'd like to replace
this with proper entries in the "aliases" node. Some sub-devices
have registers that these indexes need to be directly written to.

--

Thanks,
Sylwester
