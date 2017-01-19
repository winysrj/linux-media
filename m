Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48061
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751137AbdASWgj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jan 2017 17:36:39 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v2 2/2] [media] exynos-gsc: Only reset the GSC HW on probe() if !CONFIG_PM
Date: Thu, 19 Jan 2017 19:36:20 -0300
Message-Id: <1484865380-12651-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1484865380-12651-1-git-send-email-javier@osg.samsung.com>
References: <1484865380-12651-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 15f90ab57acc ("[media] exynos-gsc: Make driver functional when
CONFIG_PM is unset") removed the implicit dependency that the driver
had with CONFIG_PM, since it relied on the config option to be enabled.

In order to work with !CONFIG_PM, the GSC reset logic that happens in
the runtime resume callback had to be executed on the probe function.

But there's no need to do this if CONFIG_PM is enabled, since in this
case the runtime PM resume callback will be called by VIDIOC_STREAMON
ioctl, so the resume handler will call the GSC HW reset function.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

I-ve only tested with CONFIG_PM enabled since my Exynos5422 Odroid
XU4 board fails to boot when the config option is disabled.

Best regards,
Javier

Changes in v2:
 - Remove the Fixes tag and reword the commit message after feedback
   from Marek Szyprowski.

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

