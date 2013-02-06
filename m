Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:37037 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3BFEOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 23:14:54 -0500
Received: by mail-oa0-f41.google.com with SMTP id i10so1070782oag.28
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2013 20:14:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5110D1DA.6000100@samsung.com>
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
	<CAK9yfHx7FOE1xTqDH=1L5r+hZFY7U-W=Q49qErgjs-i1HU4j4w@mail.gmail.com>
	<CAAQKjZNLTZSJ8Y0tt2aZPKFESbLGxQ1Z92zkhV_u8nvSXekgtw@mail.gmail.com>
	<5110D1DA.6000100@samsung.com>
Date: Wed, 6 Feb 2013 09:44:53 +0530
Message-ID: <CAK9yfHxZZLkXOf78QUOAC1hiXpR9fDuvaXjebtkmkrZW8uD9Vw@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	"patches@linaro.org" <patches@linaro.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 February 2013 15:03, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> On 02/05/2013 04:03 AM, Inki Dae wrote:
> [...]
>>> Exynos4210 has same g2d IP (v3.0) as C110 or V210; so the same
>>> comptible string will be used for this one too.
>>>
>>>> And please check if exynos4212 and 4412 SoCs have same fimg-2d ip.
>>>> If it's different, we might need to add ip version property or compatible
>>>> string to each dtsi file to identify the ip version.
>>>
>>> AFAIK, they both have the same IP (v4.1).
>>>
>>
>> Ok, let's use the below,
>>
>> For exynos4210 SoC,
>> compatible = "samsung,exynos4210-g2d"
>
> Since S5PV210 (Exynos3110 ??) seems to have same G2D IP, I guess
> something like "samsung,s5pv210-g2d" could be used for both
> S5PV210 (S5PC110) and Exynos4210 (S5PC210, S5PV310) ?
> I'm fine with using "samsung,exynos4210-g2d" for Exynos4210 though.

Since S5PV210 is the first SoC with the g2d IP as used on exynos4210,
I am inclined to use
"samsung,s5pv210-g2d" for exynos4210. This was suggested by Kukjin Kim as well.

> For instance for tegra SoCs a conventions like "nvidia,tegra<chip>-<ip>",
> is used (e.g. "nvidia,tegra20-gr2d").
>
>> For exynos4x12 SoCs,
>> compatible = "samsung,exynos4212-g2d"
>
> I'm not sure how well exynos4212 is going to be supported in the kernel.
> As Mr Park pointed out, if it is going to be nearly not existent then we
> could perhaps go with "samsung,exynos4412-g2d" for Exynos4412 and
> "samsung,exynos4212-g2d" for Exynos4212 (as needed). Anyway, I fine
> with using "samsung,exynos4212-g2d" for both. I'd like to hear Mr Kim's
> opinion on this as well though.

I will use "samsung,exynos4212-g2d" for now as it has dtsi reference,
although there is no exclusive board support based on this SoC.

>
>> For exynos5250, 5410 (In case of Exynos5440, I'm not sure that the SoC
>> has same ip)
>> compatible = "samsung,exynos5250-g2d"
>>
>> To other guys,
>> The device tree is used by not only v4l2 side but also drm side so we
>> should reach an arrangement. So please give me ack if you agree to my
>> opinion. Otherwise please, give me your opinions.
>
> It looks good to me, please just see the two remarks above.
>
Ok, i will use the above string for 5250.

I will resend the patches with above changes and other comments addressed.

-- 
With warm regards,
Sachin
