Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38582
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751078AbdARAa5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jan 2017 19:30:57 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 2/2] [media] exynos-gsc: Fix imprecise external abort due disabled power domain
Date: Tue, 17 Jan 2017 21:30:01 -0300
Message-Id: <1484699402-28738-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1484699402-28738-1-git-send-email-javier@osg.samsung.com>
References: <1484699402-28738-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 15f90ab57acc ("[media] exynos-gsc: Make driver functional when
CONFIG_PM is unset") removed the implicit dependency that the driver
had with CONFIG_PM, since it relied on the config option to be enabled.

In order to work with !CONFIG_PM, the GSC reset logic that happens in
the runtime resume callback had to be executed on the probe function.

The problem is that if CONFIG_PM is enabled, the power domain for the
GSC could be disabled and so an attempt to write to the GSC_SW_RESET
register leads to an unhandled fault / imprecise external abort error:

[   10.178825] Unhandled fault: imprecise external abort (0x1406) at 0x00000000
[   10.186982] pgd = ed728000
[   10.190847] [00000000] *pgd=00000000
[   10.195553] Internal error: : 1406 [#1] PREEMPT SMP ARM
[   10.229761] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   10.237134] task: ed49e400 task.stack: ed724000
[   10.242934] PC is at gsc_wait_reset+0x5c/0x6c [exynos_gsc]
[   10.249710] LR is at gsc_probe+0x300/0x33c [exynos_gsc]
[   10.256139] pc : [<bf2429e0>]    lr : [<bf240734>]    psr: 60070013
[   10.256139] sp : ed725d30  ip : 00000000  fp : 00000001
[   10.271492] r10: eea74800  r9 : ecd6a2c0  r8 : ed7d8854
[   10.277912] r7 : ed7d8c08  r6 : ed7d8810  r5 : ffff8ecd  r4 : c0c03900
[   10.285664] r3 : 00000000  r2 : 00000001  r1 : ed7d8b98  r0 : ed7d8810

So only do a GSC reset if CONFIG_PM is disabled, since if is enabled the
runtime PM resume callback will be called by the VIDIOC_STREAMON ioctl,
making the reset in probe unneeded.

Fixes: 15f90ab57acc ("[media] exynos-gsc: Make driver functional when CONFIG_PM is unset")
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

I-ve only tested with CONFIG_PM enabled since my Exynos5422 Odroid
XU4 board fails to boot when the config option is disabled.

Best regards,
Javier

 drivers/media/platform/exynos-gsc/gsc-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 83272f10722d..42e1e09ea915 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1083,8 +1083,10 @@ static int gsc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, gsc);
 
-	gsc_hw_set_sw_reset(gsc);
-	gsc_wait_reset(gsc);
+	if (!IS_ENABLED(CONFIG_PM)) {
+		gsc_hw_set_sw_reset(gsc);
+		gsc_wait_reset(gsc);
+	}
 
 	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 
-- 
2.7.4

