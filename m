Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58433 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbdATIIR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 03:08:17 -0500
Subject: Re: [PATCH 2/2] [media] exynos-gsc: Fix imprecise external abort due
 disabled power domain
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
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
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <20ecbcee-0dfd-04f6-a855-e117ba05732f@samsung.com>
Date: Fri, 20 Jan 2017 09:08:11 +0100
MIME-version: 1.0
In-reply-to: <842737f2-3faf-7b22-c480-93e183bbb670@osg.samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <1484699402-28738-1-git-send-email-javier@osg.samsung.com>
 <CGME20170118003022epcas3p34cf03bb6feb830c4fa231497f2536d0e@epcas3p3.samsung.com>
 <1484699402-28738-2-git-send-email-javier@osg.samsung.com>
 <cc9c6837-7141-b63c-ddf6-68252493df11@samsung.com>
 <842737f2-3faf-7b22-c480-93e183bbb670@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 2017-01-19 15:56, Javier Martinez Canillas wrote:
> Thanks a lot for your feedback.
>
> On 01/19/2017 11:17 AM, Marek Szyprowski wrote:
>> On 2017-01-18 01:30, Javier Martinez Canillas wrote:
>>> Commit 15f90ab57acc ("[media] exynos-gsc: Make driver functional when
>>> CONFIG_PM is unset") removed the implicit dependency that the driver
>>> had with CONFIG_PM, since it relied on the config option to be enabled.
>>>
>>> In order to work with !CONFIG_PM, the GSC reset logic that happens in
>>> the runtime resume callback had to be executed on the probe function.
>>>
>>> The problem is that if CONFIG_PM is enabled, the power domain for the
>>> GSC could be disabled and so an attempt to write to the GSC_SW_RESET
>>> register leads to an unhandled fault / imprecise external abort error:
>> Driver core ensures that driver's probe() is called with respective power
>> domain turned on, so this is not the right reason for the proposed change.
> Ok, I misunderstood the relationship between runtime PM and the power domains
> then. I thought the power domains were only powered on when the runtime PM
> framework resumed an associated device (i.e: pm_runtime_get_sync() is called).

Power domains are implemented transparently for the drivers. Even when 
driver
doesn't support runtime pm, but its device is in the power domain, the 
core will
ensure that the domain will be turned on all the time the driver is 
bound to the
device.

> But even if this isn't the case, shouldn't the reset in probe only be needed
> if CONFIG_PM isn't enabled? (IOW, $SUBJECT but with another commit message).

This looks like an over-engineering. I don't like polluting driver code with
conditional statements like IS_ENABLED(CONFIG_*). It should not hurt to 
reset
the device in driver probe, especially just in case the device was left in
some partially configured/working state by bootloader or previous kernel run
(if started from kexec). Adding this conditional code to avoid some issues
with power domain or clocks configuration also suggests that one should
instead solve the problem elsewhere. Driver should be able to access device
registers in its probe() in any case without the additional hacks.

>>> [   10.178825] Unhandled fault: imprecise external abort (0x1406) at 0x00000000
>>> [   10.186982] pgd = ed728000
>>> [   10.190847] [00000000] *pgd=00000000
>>> [   10.195553] Internal error: : 1406 [#1] PREEMPT SMP ARM
>>> [   10.229761] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
>>> [   10.237134] task: ed49e400 task.stack: ed724000
>>> [   10.242934] PC is at gsc_wait_reset+0x5c/0x6c [exynos_gsc]
>>> [   10.249710] LR is at gsc_probe+0x300/0x33c [exynos_gsc]
>>> [   10.256139] pc : [<bf2429e0>]    lr : [<bf240734>]    psr: 60070013
>>> [   10.256139] sp : ed725d30  ip : 00000000  fp : 00000001
>>> [   10.271492] r10: eea74800  r9 : ecd6a2c0  r8 : ed7d8854
>>> [   10.277912] r7 : ed7d8c08  r6 : ed7d8810  r5 : ffff8ecd  r4 : c0c03900
>>> [   10.285664] r3 : 00000000  r2 : 00000001  r1 : ed7d8b98  r0 : ed7d8810
>>>
>>> So only do a GSC reset if CONFIG_PM is disabled, since if is enabled the
>>> runtime PM resume callback will be called by the VIDIOC_STREAMON ioctl,
>>> making the reset in probe unneeded.
>>>
>>> Fixes: 15f90ab57acc ("[media] exynos-gsc: Make driver functional when CONFIG_PM is unset")
>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> Frankly, I don't get why this change is needed.
>>
> Yes, it seems $SUBJECT is just papering over the real issue. There's
> something really wrong with the Exynos power domains, I see that PDs
> can't be disabled by the genpd framework, exynos_pd_power_off() fail:
>
> # dmesg | grep power-domain
> [    4.893318] Power domain power-domain@10044020 disable failed
> [    4.893342] Power domain power-domain@10044120 disable failed
> [    4.893711] Power domain power-domain@10044000 disable failed
> [   12.690052] Power domain power-domain@10044000 disable failed
> [   12.703963] Power domain power-domain@10044000 disable failed
>
> So PD are kept on even when unused / attached devices are suspended.
> Only the mfc_pd (power-domain@10044060) is correctly turned off.
>
> # cat /sys/kernel/debug/pm_genpd/pm_genpd_summary
> domain                          status          slaves
>      /device                                             runtime status
> ----------------------------------------------------------------------
> power-domain@100440C0           on
>      /devices/platform/soc/14450000.mixer                active
>      /devices/platform/soc/14530000.hdmi                 active
> power-domain@10044120           on
> power-domain@10044060           off-0
>      /devices/platform/soc/11000000.codec                suspended
> power-domain@10044020           on
> power-domain@10044000           on
>      /devices/platform/soc/13e00000.video-scaler         suspended
>      /devices/platform/soc/13e10000.video-scaler         suspended
>
> Also when removing the exynos_gsc driver, I get the same error:
>
> # rmmod s5p_mfc
> [  106.405972] s5p-mfc 11000000.codec: Removing 11000000.codec
> # rmmod exynos_gsc
> [  227.008559] Unhandled fault: imprecise external abort (0x1c06) at 0x00048e14
> [  227.015116] pgd = ed5dc000
> [  227.017213] [00048e14] *pgd=b17c6835
> [  227.020889] Internal error: : 1c06 [#1] PREEMPT SMP ARM
> ...
> [  227.241585] [<bf2429bc>] (gsc_wait_reset [exynos_gsc]) from [<bf24009c>] (gsc_runtime_resume+0x9c/0xec [exynos_gsc])
> [  227.252331] [<bf24009c>] (gsc_runtime_resume [exynos_gsc]) from [<c042e488>] (genpd_runtime_resume+0x120/0x1d4)
> [  227.262294] [<c042e488>] (genpd_runtime_resume) from [<c04241c0>] (__rpm_callback+0xc8/0x218)
>
> # cat /sys/kernel/debug/pm_genpd/pm_genpd_summary
> domain                          status          slaves
>      /device                                             runtime status
> ----------------------------------------------------------------------
> power-domain@100440C0           on
>      /devices/platform/soc/14450000.mixer                active
>      /devices/platform/soc/14530000.hdmi                 active
> power-domain@10044120           on
> power-domain@10044060           off-0
> power-domain@10044020           on
> power-domain@10044000           on
>      /devices/platform/soc/13e00000.video-scaler         suspended
>      /devices/platform/soc/13e10000.video-scaler         resuming
>
> This seems to be caused by some needed clocks to access the power domains
> to be gated, since I don't get these erros when passing clk_ignore_unused
> as parameter in the kernel command line.

I think that those issues were fixes by the following patch:
https://patchwork.kernel.org/patch/9484607/
It still didn't reach mainline, but I hope it will go as a fix to v4.10.

Please test if this solves your issue. Please not that adding more clocks
to the power domain drivers will solve only the problem with turning domain
on/off, but the are more cases where those clocks should be turned on (like
IOMMU integration), so marking them as critical solves that problem too.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

