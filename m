Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58099 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3FSDLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 23:11:51 -0400
Received: by mail-oa0-f50.google.com with SMTP id k7so6034391oag.9
        for <linux-media@vger.kernel.org>; Tue, 18 Jun 2013 20:11:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51C0D7C5.6030707@gmail.com>
References: <1371486876-30421-1-git-send-email-s.nawrocki@samsung.com>
	<CAK9yfHxpUPaKzrjCAX44rAB6pqOW2A2KD23A5SbwAWK+vJCbww@mail.gmail.com>
	<51C0D7C5.6030707@gmail.com>
Date: Wed, 19 Jun 2013 08:41:50 +0530
Message-ID: <CAK9yfHzCZJnLHfBTwWN+kbRtrXNCsrhZGQB1=0LHSy_YtSNMWA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Update driver's directory in video4linux/fimc.txt
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 19 June 2013 03:27, Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:
> Hi Sachin,
>
>
> On 06/18/2013 05:45 AM, Sachin Kamat wrote:
>>
>> Hi Sylwester,
>>
>>> -The machine code (plat-s5p and arch/arm/mach-*) must select following
>>> options
>>> +The machine code (arch/arm/plat-samsung and arch/arm/mach-*) must select
>>> +following options:
>>
>>
>> After the recent platform code cleanup the below entries are not found
>> in arch/arm/mach-* (checked in linux-next).
>>
>>>   CONFIG_S5P_DEV_FIMC0       mandatory
>>>   CONFIG_S5P_DEV_FIMC1  \
>
>
> AFAICS some are still there:
>
> $ git grep S5P_DEV_FIMC0
> Documentation/video4linux/fimc.txt:CONFIG_S5P_DEV_FIMC0       mandatory
> arch/arm/mach-s5pc100/Kconfig:  select S5P_DEV_FIMC0
> arch/arm/mach-s5pv210/Kconfig:  select S5P_DEV_FIMC0
> arch/arm/mach-s5pv210/Kconfig:  select S5P_DEV_FIMC0
> arch/arm/mach-s5pv210/Kconfig:  select S5P_DEV_FIMC0
> arch/arm/mach-s5pv210/Kconfig:  select S5P_DEV_FIMC0
> arch/arm/plat-samsung/Kconfig:config S5P_DEV_FIMC0
> arch/arm/plat-samsung/devs.c:#ifdef CONFIG_S5P_DEV_FIMC0
> arch/arm/plat-samsung/devs.c:#endif /* CONFIG_S5P_DEV_FIMC0 */
> arch/arm/plat-samsung/include/plat/fimc-core.h:#ifdef CONFIG_S5P_DEV_FIMC0
>
> Those symbols have been removed only for Exynos. The above can be dropped
> once we convert S5PV210 and S5PC100 (or drop support for this platform)
> to Device Tree.

Yes you are right. Probably I mis-grepped it.

-- 
With warm regards,
Sachin
