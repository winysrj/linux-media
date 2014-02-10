Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57237 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaBJJEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:04:43 -0500
Received: by mail-oa0-f51.google.com with SMTP id h16so7121578oag.24
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 01:04:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAQKjZM7UWPYwjNESSwP_02=JMDN22StGuG4S2ZX=ZkpVXhPhw@mail.gmail.com>
References: <52F7CE59.90009@math.uni-bielefeld.de>
	<CAK9yfHz7_9UWh=tTJeKyJh7V8yFtn8B4+ub=coV67ovRtebRfQ@mail.gmail.com>
	<52F88DA0.8000201@math.uni-bielefeld.de>
	<CAK9yfHx=KZjvJGbPs89Yfwyt6mgY_bC+=1YeBo+q0sMyaWN8GA@mail.gmail.com>
	<CAAQKjZM7UWPYwjNESSwP_02=JMDN22StGuG4S2ZX=ZkpVXhPhw@mail.gmail.com>
Date: Mon, 10 Feb 2014 14:34:43 +0530
Message-ID: <CAK9yfHzmKDoYXUhGszkrspY=PAzVQ7xuOSav70yKBXF4+WTSng@mail.gmail.com>
Subject: Re: exynos4 / g2d
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Inki Dae <inki.dae@samsung.com>
Cc: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	linux-media <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 February 2014 14:28, Inki Dae <inki.dae@samsung.com> wrote:
> 2014-02-10 17:44 GMT+09:00 Sachin Kamat <sachin.kamat@linaro.org>:
>> +cc Joonyoung Shim
>>
>> Hi,
>>
>> On 10 February 2014 13:58, Tobias Jakobi <tjakobi@math.uni-bielefeld.de> wrote:
>>> Hello!
>>>
>>>
>>> Sachin Kamat wrote:
>>>> +cc linux-media list and some related maintainers
>>>>
>>>> Hi,
>>>>
>>>> On 10 February 2014 00:22, Tobias Jakobi <tjakobi@math.uni-bielefeld.de> wrote:
>>>>> Hello!
>>>>>
>>>>> I noticed while here
>>>>> (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/arm/boot/dts/exynos4x12.dtsi?id=3a0d48f6f81459c874165ffb14b310c0b5bb0c58)
>>>>> the necessary entry for the dts was made, on the drm driver side
>>>>> (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/exynos/exynos_drm_g2d.c)
>>>>> this was never added.
>>>>>
>>>>> Shouldn't "samsung,exynos4212-g2d" go into exynos_g2d_match as well?
>>>> The DRM version of G2D driver does not support Exynos4 based G2D IP
>>>> yet. The support for this IP
>>>> is available only in the V4L2 version of the driver. Please see the file:
>>>> drivers/media/platform/s5p-g2d/g2d.c
>>>>
>>> That doesn't make sense to me. From the initial commit message of the
>>> DRM code:
>>> "The G2D is a 2D graphic accelerator that supports Bit Block Transfer.
>>> This G2D driver is exynos drm specific and supports only G2D(version
>>> 4.1) of later Exynos series from Exynos4X12 because supporting DMA."
>>> (https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/gpu/drm/exynos/exynos_drm_g2d.c?id=d7f1642c90ab5eb2d7c48af0581c993094f97e1a)
>>>
>>> In fact, this doesn't even mention the Exynos5?!
>>
>> It does say "later Exynos series from Exynos4X12" which technically
>> includes Exynos5 and
>
> Right, supported.
>
>> does not include previous Exynos series SoCs like 4210, etc.
>> Anyway, I haven't tested this driver on Exynos4 based platforms and
>> hence cannot confirm if it
>> supports 4x12 in the current form. I leave it to the original author
>> and Inki to comment about it.
>>
>
> Just add "samsung,exynos4212-g2d" to exynos_g2d_match if you want to
> use g2d driver on exynos4212 SoC. We already tested this driver on
> Exynos4x12 SoC also. We didn't just post dt support patch for
> exynos4x12 series.

If you prefer I could add that and send a patch. I wouldn't be able to
test it though.

-- 
With warm regards,
Sachin
