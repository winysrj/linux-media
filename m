Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33460
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753037AbdCFSP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 13:15:28 -0500
Subject: Re: [PATCH] media: mfc: Fix race between interrupt routine and device
 functions
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <CGME20170223114347eucas1p21e5aed393511b41e51aac1df2762db83@eucas1p2.samsung.com>
 <1487850219-6482-1-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>, stable@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <6918cc54-bf43-afe3-def7-9d5888bb837e@osg.samsung.com>
Date: Mon, 6 Mar 2017 15:07:04 -0300
MIME-Version: 1.0
In-Reply-To: <1487850219-6482-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/23/2017 08:43 AM, Marek Szyprowski wrote:
> Interrupt routine must wake process waiting for given interrupt AFTER
> updating driver's internal structures and contexts. Doing it in-between
> is a serious bug. This patch moves all calls to the wake() function to
> the end of the interrupt processing block to avoid potential and real
> races, especially on multi-core platforms. This also fixes following issue
> reported from clock core (clocks were disabled in interrupt after being
> unprepared from the other place in the driver, the stack trace however
> points to the different place than s5p_mfc driver because of the race):
> 
> WARNING: CPU: 1 PID: 18 at drivers/clk/clk.c:544 clk_core_unprepare+0xc8/0x108
> Modules linked in:
> CPU: 1 PID: 18 Comm: kworker/1:0 Not tainted 4.10.0-next-20170223-00070-g04e18bc99ab9-dirty #2154
> Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> Workqueue: pm pm_runtime_work
> [<c010d8b0>] (unwind_backtrace) from [<c010a534>] (show_stack+0x10/0x14)
> [<c010a534>] (show_stack) from [<c033292c>] (dump_stack+0x74/0x94)
> [<c033292c>] (dump_stack) from [<c011cef4>] (__warn+0xd4/0x100)
> [<c011cef4>] (__warn) from [<c011cf40>] (warn_slowpath_null+0x20/0x28)
> [<c011cf40>] (warn_slowpath_null) from [<c0387a84>] (clk_core_unprepare+0xc8/0x108)
> [<c0387a84>] (clk_core_unprepare) from [<c0389d84>] (clk_unprepare+0x24/0x2c)
> [<c0389d84>] (clk_unprepare) from [<c03d4660>] (exynos_sysmmu_suspend+0x48/0x60)
> [<c03d4660>] (exynos_sysmmu_suspend) from [<c042b9b0>] (pm_generic_runtime_suspend+0x2c/0x38)
> [<c042b9b0>] (pm_generic_runtime_suspend) from [<c0437580>] (genpd_runtime_suspend+0x94/0x220)
> [<c0437580>] (genpd_runtime_suspend) from [<c042e240>] (__rpm_callback+0x134/0x208)
> [<c042e240>] (__rpm_callback) from [<c042e334>] (rpm_callback+0x20/0x80)
> [<c042e334>] (rpm_callback) from [<c042d3b8>] (rpm_suspend+0xdc/0x458)
> [<c042d3b8>] (rpm_suspend) from [<c042ea24>] (pm_runtime_work+0x80/0x90)
> [<c042ea24>] (pm_runtime_work) from [<c01322c4>] (process_one_work+0x120/0x318)
> [<c01322c4>] (process_one_work) from [<c0132520>] (worker_thread+0x2c/0x4ac)
> [<c0132520>] (worker_thread) from [<c0137ab0>] (kthread+0xfc/0x134)
> [<c0137ab0>] (kthread) from [<c0107978>] (ret_from_fork+0x14/0x3c)
> ---[ end trace 1ead49a7bb83f0d8 ]---
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Fixes: af93574678108 ("[media] MFC: Add MFC 5.1 V4L2 driver")
> CC: stable@vger.kernel.org # v4.5+
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
