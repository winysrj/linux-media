Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61103 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3BDME1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 07:04:27 -0500
Received: by mail-oa0-f52.google.com with SMTP id k14so6335250oag.39
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2013 04:04:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E382E0B5-2695-4293-B264-FB4C54FE4F9D@gmail.com>
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
	<1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
	<CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com>
	<510987B5.6090509@gmail.com>
	<050101cdff52$86df3a70$949daf50$%dae@samsung.com>
	<510B02AB.4080908@gmail.com>
	<0b7501ce0011$3df65180$b9e2f480$@samsung.com>
	<00fd01ce001b$5215a3f0$f640ebd0$%dae@samsung.com>
	<CAK9yfHxqqumg-oqH_Ku8Zkf8biWVknF91Su0VkWJJXjvWQ3Jhw@mail.gmail.com>
	<510B9EC8.6020102@samsung.com>
	<CAK9yfHw+aTgiLwGVJt=J9-ie4-2JAaF4Nh3n4tjcHp6w2JHamg@mail.gmail.com>
	<014401ce006f$c7dd1dd0$57975970$%dae@samsung.com>
	<CAK9yfHyEdd_nr5eqT9WZ4+J9LHczL4U5VAUEwzzjbH1H0xgjUQ@mail.gmail.com>
	<014501ce0072$9eca1a80$dc5e4f80$%dae@samsung.com>
	<E382E0B5-2695-4293-B264-FB4C54FE4F9D@gmail.com>
Date: Mon, 4 Feb 2013 17:34:26 +0530
Message-ID: <CAK9yfHx7FOE1xTqDH=1L5r+hZFY7U-W=Q49qErgjs-i1HU4j4w@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Inki Dae <daeinki@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	"patches@linaro.org" <patches@linaro.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 February 2013 18:28, Inki Dae <daeinki@gmail.com> wrote:
>
>
>
>
> 2013. 2. 1. 오후 8:52 Inki Dae <inki.dae@samsung.com> 작성:
>
>>
>>
>>> -----Original Message-----
>>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>>> owner@vger.kernel.org] On Behalf Of Sachin Kamat
>>> Sent: Friday, February 01, 2013 8:40 PM
>>> To: Inki Dae
>>> Cc: Sylwester Nawrocki; Kukjin Kim; Sylwester Nawrocki; linux-
>>> media@vger.kernel.org; dri-devel@lists.freedesktop.org; devicetree-
>>> discuss@lists.ozlabs.org; patches@linaro.org
>>> Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery
>>> support for G2D
>>>
>>> On 1 February 2013 17:02, Inki Dae <inki.dae@samsung.com> wrote:
>>>>
>>>> How about using like below?
>>>>        Compatible = ""samsung,exynos4x12-fimg-2d" /* for Exynos4212,
>>>> Exynos4412  */
>>>> It looks odd to use "samsung,exynos4212-fimg-2d" saying that this ip is
>>> for
>>>> exynos4212 and exynos4412.
>>>
>>> AFAIK, compatible strings are not supposed to have any wildcard
>> characters.
>>> Compatible string should suggest the first SoC that contained this IP.
>>> Hence IMO 4212 is OK.
>>>
>
> Oops, one more thing. AFAIK Exynos4210 also has fimg-2d ip. In this case, we should use "samsung,exynos4210-fimg-2d" as comparible string and add it to exynos4210.dtsi?

Exynos4210 has same g2d IP (v3.0) as C110 or V210; so the same
comptible string will be used for this one too.

> And please check if exynos4212 and 4412 SoCs have same fimg-2d ip. If it's different, we might need to add ip version property or compatible string to each dtsi file to identify the ip version.

AFAIK, they both have the same IP (v4.1).

>
> Sorry but give me your opinions.
>
> Thanks,
> Inki Dae
>
>
>>
>> Got it. Please post it again.
>>
>>>
>>> --
>>> With warm regards,
>>> Sachin
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
With warm regards,
Sachin
