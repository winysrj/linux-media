Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:32955 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3BAC0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 21:26:09 -0500
Message-ID: <510B27BF.6030203@wwwdotorg.org>
Date: Thu, 31 Jan 2013 19:26:07 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Inki Dae <inki.dae@samsung.com>
CC: 'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	patches@linaro.org, 'Sachin Kamat' <sachin.kamat@linaro.org>,
	devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, s.nawrocki@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org> <1359107722-9974-2-git-send-email-sachin.kamat@linaro.org> <CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com> <510987B5.6090509@gmail.com> <050101cdff52$86df3a70$949daf50$%dae@samsung.com> <510B02AB.4080908@gmail.com> <0b7501ce0011$3df65180$b9e2f480$@samsung.com> <00fd01ce001b$5215a3f0$f640ebd0$%dae@samsung.com>
In-Reply-To: <00fd01ce001b$5215a3f0$f640ebd0$%dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/31/2013 06:27 PM, Inki Dae wrote:
> Hi Kukjin,
> 
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Kukjin Kim
>> Sent: Friday, February 01, 2013 9:15 AM
>> To: 'Sylwester Nawrocki'; 'Inki Dae'
>> Cc: 'Sachin Kamat'; linux-media@vger.kernel.org; dri-
>> devel@lists.freedesktop.org; devicetree-discuss@lists.ozlabs.org;
>> patches@linaro.org; s.nawrocki@samsung.com
>> Subject: RE: [PATCH 2/2] drm/exynos: Add device tree based discovery
>> support for G2D
>>
>> Sylwester Nawrocki wrote:
>>>
>>> Hi Inki,
>>>
>> Hi Sylwester and Inki,
>>
>>> On 01/31/2013 02:30 AM, Inki Dae wrote:
>>>>> -----Original Message-----
>>>>> From: Sylwester Nawrocki [mailto:sylvester.nawrocki@gmail.com]
>>>>> Sent: Thursday, January 31, 2013 5:51 AM
>>>>> To: Inki Dae
>>>>> Cc: Sachin Kamat; linux-media@vger.kernel.org; dri-
>>>>> devel@lists.freedesktop.org; devicetree-discuss@lists.ozlabs.org;
>>>>> patches@linaro.org; s.nawrocki@samsung.com
>>>>> Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery
>>>>> support for G2D
>>>>>
>>>>> On 01/30/2013 09:50 AM, Inki Dae wrote:
>>>>>>> +static const struct of_device_id exynos_g2d_match[] = {
>>>>>>> +       { .compatible = "samsung,g2d-v41" },
>>>>>>
>>>>>> not only Exynos5 and also Exyno4 has the g2d gpu and drm-based g2d
>>>>>> driver shoud support for all Exynos SoCs. How about using
>>>>>> "samsung,exynos5-g2d" instead and adding a new property 'version' to
>>>>>> identify ip version more surely? With this, we could know which SoC
>>>>>> and its g2d ip version. The version property could have '0x14' or
>>>>>> others. And please add descriptions to dt document.
>>>>>
>>>>> Err no. Are you suggesting using "samsung,exynos5-g2d" compatible
>>> string
>>>>> for Exynos4 specific IPs ? This would not be correct, and you still
>> can
>>>>
>>>> I assumed the version 'v41' is the ip for Exynos5 SoC. So if this
>> version
>>>> means Exynos4 SoC then it should be "samsung,exynos4-g2d".
>>>
>>> Yes, v3.0 is implemented in the S5PC110 (Exynos3110) SoCs and
> Exynos4210,
>>> V4.1 can be found in Exynos4212 and Exynos4412, if I'm not mistaken.
>>>
>>> So we could have:
>>>
>>> compatible = "samsung,exynos-g2d-3.0" /* for Exynos3110, Exynos4210 */
>>> compatible = "samsung,exynos-g2d-4.1" /* for Exynos4212, Exynos4412 */
>>>
>> In my opinion, this is better than later. Because as I said, when we can
>> use
>> IP version to identify, it is more clear and can be used
>>
>> One more, how about following?
>>
>> compatible = "samsung,g2d-3.0"
>> compatible = "samsung,g2d-4.1"
>>
> 
> I think compatible string should be considered case by case.
> 
> For example,
> If compatible = "samsung,g2d-3.0" is added to exynos4210.dtsi, it'd be
> reasonable. But what if that compatible string is added to exynos4.dtsi?.
> This case isn't considered for exynos4412 SoC with v4.1. 

You can always add the most common value for the compatible property
into exynos4.dtsi, and then override it in exyons4210.dtsi, or other files.

Still, the idea of including the SoC version in the compatible value is
a good idea.
