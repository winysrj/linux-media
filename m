Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:62131 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3FRV5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 17:57:30 -0400
Received: by mail-bk0-f45.google.com with SMTP id je9so2036997bkc.32
        for <linux-media@vger.kernel.org>; Tue, 18 Jun 2013 14:57:28 -0700 (PDT)
Message-ID: <51C0D7C5.6030707@gmail.com>
Date: Tue, 18 Jun 2013 23:57:25 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Documentation: Update driver's directory in video4linux/fimc.txt
References: <1371486876-30421-1-git-send-email-s.nawrocki@samsung.com> <CAK9yfHxpUPaKzrjCAX44rAB6pqOW2A2KD23A5SbwAWK+vJCbww@mail.gmail.com>
In-Reply-To: <CAK9yfHxpUPaKzrjCAX44rAB6pqOW2A2KD23A5SbwAWK+vJCbww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 06/18/2013 05:45 AM, Sachin Kamat wrote:
> Hi Sylwester,
>
>> -The machine code (plat-s5p and arch/arm/mach-*) must select following options
>> +The machine code (arch/arm/plat-samsung and arch/arm/mach-*) must select
>> +following options:
>
> After the recent platform code cleanup the below entries are not found
> in arch/arm/mach-* (checked in linux-next).
>
>>   CONFIG_S5P_DEV_FIMC0       mandatory
>>   CONFIG_S5P_DEV_FIMC1  \

AFAICS some are still there:

$ git grep S5P_DEV_FIMC0
Documentation/video4linux/fimc.txt:CONFIG_S5P_DEV_FIMC0       mandatory
arch/arm/mach-s5pc100/Kconfig:  select S5P_DEV_FIMC0
arch/arm/mach-s5pv210/Kconfig:  select S5P_DEV_FIMC0
arch/arm/mach-s5pv210/Kconfig:  select S5P_DEV_FIMC0
arch/arm/mach-s5pv210/Kconfig:  select S5P_DEV_FIMC0
arch/arm/mach-s5pv210/Kconfig:  select S5P_DEV_FIMC0
arch/arm/plat-samsung/Kconfig:config S5P_DEV_FIMC0
arch/arm/plat-samsung/devs.c:#ifdef CONFIG_S5P_DEV_FIMC0
arch/arm/plat-samsung/devs.c:#endif /* CONFIG_S5P_DEV_FIMC0 */
arch/arm/plat-samsung/include/plat/fimc-core.h:#ifdef CONFIG_S5P_DEV_FIMC0

Those symbols have been removed only for Exynos. The above can be dropped
once we convert S5PV210 and S5PC100 (or drop support for this platform)
to Device Tree.

Anyway, I'm planning to update this FIMC documentation in a separate patch
to account for all the recent changes, especially addition of the FIMC-IS
support. But that will likely be only for 3.12.

Regards,
Sylwester
