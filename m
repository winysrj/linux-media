Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47002
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752816AbdASRvP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jan 2017 12:51:15 -0500
Subject: Re: [PATCH 2/2] [media] exynos-gsc: Fix imprecise external abort due
 disabled power domain
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
References: <1484699402-28738-1-git-send-email-javier@osg.samsung.com>
 <CGME20170118003022epcas3p34cf03bb6feb830c4fa231497f2536d0e@epcas3p3.samsung.com>
 <1484699402-28738-2-git-send-email-javier@osg.samsung.com>
 <cc9c6837-7141-b63c-ddf6-68252493df11@samsung.com>
 <842737f2-3faf-7b22-c480-93e183bbb670@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
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
Message-ID: <d727576a-fbce-eb54-3b74-270c689b7fa3@osg.samsung.com>
Date: Thu, 19 Jan 2017 14:51:02 -0300
MIME-Version: 1.0
In-Reply-To: <842737f2-3faf-7b22-c480-93e183bbb670@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 01/19/2017 11:56 AM, Javier Martinez Canillas wrote:
> On 01/19/2017 11:17 AM, Marek Szyprowski wrote:

[snip]

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
>     /device                                             runtime status
> ----------------------------------------------------------------------
> power-domain@100440C0           on              
>     /devices/platform/soc/14450000.mixer                active
>     /devices/platform/soc/14530000.hdmi                 active
> power-domain@10044120           on              
> power-domain@10044060           off-0           
> power-domain@10044020           on              
> power-domain@10044000           on              
>     /devices/platform/soc/13e00000.video-scaler         suspended
>     /devices/platform/soc/13e10000.video-scaler         resuming
> 
> This seems to be caused by some needed clocks to access the power domains
> to be gated, since I don't get these erros when passing clk_ignore_unused
> as parameter in the kernel command line.
>

I found the issue. The problem was that Exynos5422 needs not only the
CLK_ACLK_ 300_GSCL but also CLK_ACLK432_SCALER to be ungated in order
to access the GSCL IP block.

The Exynos5422 manual shows in Figure 7-14 that ACLK_432_SCLAER is needed
for the internal buses.

Exynos5420 only needs CLK_ACLK_ 300_GSCL to be ungated.

With following hack, the issue goes away for the gsc_pd in the Odroid XU4:

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 8c8b495cbf0d..9876ec28b94c 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -586,7 +586,7 @@ static const struct samsung_gate_clock exynos5800_gate_clks[] __initconst = {
 	GATE(CLK_ACLK550_CAM, "aclk550_cam", "mout_user_aclk550_cam",
 				GATE_BUS_TOP, 24, 0, 0),
 	GATE(CLK_ACLK432_SCALER, "aclk432_scaler", "mout_user_aclk432_scaler",
-				GATE_BUS_TOP, 27, 0, 0),
+				GATE_BUS_TOP, 27, CLK_IS_CRITICAL, 0),
 };

# cat /sys/kernel/debug/pm_genpd/pm_genpd_summary
domain                          status          slaves
    /device                                             runtime status
----------------------------------------------------------------------
power-domain@100440C0           on              
    /devices/platform/soc/14450000.mixer                active
    /devices/platform/soc/14530000.hdmi                 active
power-domain@10044120           on              
power-domain@10044060           off-0           
    /devices/platform/soc/11000000.codec                suspended
power-domain@10044020           on              
power-domain@10044000           off-0           
    /devices/platform/soc/13e00000.video-scaler         suspended
    /devices/platform/soc/13e10000.video-scaler         suspended

# rmmod s5p_mfc
[   82.885227] s5p-mfc 11000000.codec: Removing 11000000.codec
# rmmod exynos_gsc

# cat /sys/kernel/debug/pm_genpd/pm_genpd_summary
domain                          status          slaves
    /device                                             runtime status
----------------------------------------------------------------------
power-domain@100440C0           on              
    /devices/platform/soc/14450000.mixer                active
    /devices/platform/soc/14530000.hdmi                 active
power-domain@10044120           on              
power-domain@10044060           off-0           
power-domain@10044020           on              
power-domain@10044000           off-0
 
I'll post a proper patch for the exynos5800.dtsi, to override the
clocks in the gsc_pd device node.

I also see that the two power domains that fail to be disabled msc_pd
(power-domain@10044120) and isp_pd (power-domain@10044020) don't have
clocks defined in the exynos54xx.dtsi. I'll add clocks for those too.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
