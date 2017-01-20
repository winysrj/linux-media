Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50270
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751693AbdATKB5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 05:01:57 -0500
Subject: Re: [PATCH 2/2] [media] exynos-gsc: Fix imprecise external abort due
 disabled power domain
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
References: <1484699402-28738-1-git-send-email-javier@osg.samsung.com>
 <CGME20170118003022epcas3p34cf03bb6feb830c4fa231497f2536d0e@epcas3p3.samsung.com>
 <1484699402-28738-2-git-send-email-javier@osg.samsung.com>
 <cc9c6837-7141-b63c-ddf6-68252493df11@samsung.com>
 <842737f2-3faf-7b22-c480-93e183bbb670@osg.samsung.com>
 <20ecbcee-0dfd-04f6-a855-e117ba05732f@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <37760cac-7a46-9f40-8b4e-5414627c7fcf@osg.samsung.com>
Date: Fri, 20 Jan 2017 07:01:46 -0300
MIME-Version: 1.0
In-Reply-To: <20ecbcee-0dfd-04f6-a855-e117ba05732f@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 01/20/2017 05:08 AM, Marek Szyprowski wrote:
> Hi Javier,
> 

[snip]

>> Ok, I misunderstood the relationship between runtime PM and the power domains
>> then. I thought the power domains were only powered on when the runtime PM
>> framework resumed an associated device (i.e: pm_runtime_get_sync() is called).
> 
> Power domains are implemented transparently for the drivers. Even when driver
> doesn't support runtime pm, but its device is in the power domain, the core will
> ensure that the domain will be turned on all the time the driver is bound to the
> device.
>

I got it now, thank a lot for your explanation.
 
>> But even if this isn't the case, shouldn't the reset in probe only be needed
>> if CONFIG_PM isn't enabled? (IOW, $SUBJECT but with another commit message).
> 
> This looks like an over-engineering. I don't like polluting driver code with
> conditional statements like IS_ENABLED(CONFIG_*). It should not hurt to reset
> the device in driver probe, especially just in case the device was left in
> some partially configured/working state by bootloader or previous kernel run
> (if started from kexec). Adding this conditional code to avoid some issues
> with power domain or clocks configuration also suggests that one should
> instead solve the problem elsewhere. Driver should be able to access device
> registers in its probe() in any case without the additional hacks.
>

Fair enough, I already posted the patch but I'll ask it to be dropped.

[snip]

>>
>> This seems to be caused by some needed clocks to access the power domains
>> to be gated, since I don't get these erros when passing clk_ignore_unused
>> as parameter in the kernel command line.
> 
> I think that those issues were fixes by the following patch:
> https://patchwork.kernel.org/patch/9484607/
> It still didn't reach mainline, but I hope it will go as a fix to v4.10.
>

That won't be enough since the CLK_ACLK432_SCALER needs to be ungated for
Exynos5422/5800 as mentioned on another mail in this thread.

> Please test if this solves your issue. Please not that adding more clocks
> to the power domain drivers will solve only the problem with turning domain
> on/off, but the are more cases where those clocks should be turned on (like
> IOMMU integration), so marking them as critical solves that problem too.
>

Ok, I understand your point.
 
> Best regards

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
