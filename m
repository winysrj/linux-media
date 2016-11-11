Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35537 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754300AbcKKJuX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 04:50:23 -0500
Received: by mail-wm0-f44.google.com with SMTP id a197so415849453wmd.0
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 01:50:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqN=haG0HvpXgQr3nqfNUhhxRku8zbW1QJngPUyLDjokw@mail.gmail.com>
References: <1478701441-29107-5-git-send-email-m.szyprowski@samsung.com>
 <201611101146.cbVxBQXg%fengguang.wu@intel.com> <CAPDyKFqN=haG0HvpXgQr3nqfNUhhxRku8zbW1QJngPUyLDjokw@mail.gmail.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 11 Nov 2016 10:50:20 +0100
Message-ID: <CAPDyKFoKUhdDuWQdDUwOFxGtt0iv8y_-1vRzS0-jGkyEbxrdHQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] exynos-gsc: Make runtime PM callbacks available for CONFIG_PM
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11 November 2016 at 10:47, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 10 November 2016 at 04:44, kbuild test robot <lkp@intel.com> wrote:
>> Hi Ulf,
>>
>> [auto build test ERROR on linuxtv-media/master]
>> [also build test ERROR on v4.9-rc4 next-20161109]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>
>> url:    https://github.com/0day-ci/linux/commits/Marek-Szyprowski/media-Exynos-GScaller-driver-fixes/20161110-000048
>> base:   git://linuxtv.org/media_tree.git master
>> config: openrisc-allyesconfig (attached as .config)
>> compiler: or32-linux-gcc (GCC) 4.5.1-or32-1.0rc1
>> reproduce:
>>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # save the attached .config to linux build tree
>>         make.cross ARCH=openrisc
>>
>> Note: the linux-review/Marek-Szyprowski/media-Exynos-GScaller-driver-fixes/20161110-000048 HEAD 92b20676ac75659d1ea1d83b00e8028f45ea84e9 builds fine.
>>       It only hurts bisectibility.
>>
>> All errors (new ones prefixed by >>):
>>
>>    drivers/media/platform/exynos-gsc/gsc-core.c: In function 'gsc_resume':
>>>> drivers/media/platform/exynos-gsc/gsc-core.c:1183:3: error: implicit declaration of function 'gsc_runtime_resume'
>>    drivers/media/platform/exynos-gsc/gsc-core.c: In function 'gsc_suspend':
>>>> drivers/media/platform/exynos-gsc/gsc-core.c:1198:3: error: implicit declaration of function 'gsc_runtime_suspend'
>>
>
> Marek, to avoid the bisectibility issue, we could squash patch 4/12 with 6/12.

Urgh, ignore this.

What I meant was instead to squash these patches:
[PATCH 04/12] exynos-gsc: Make runtime PM callbacks available for CONFIG_PM
[PATCH 07/12] exynos-gsc: Make system PM callbacks available for CONFIG_PM_SLEEP

So, do you want to deal with it or you prefer me?

Kind regards
Uffe
