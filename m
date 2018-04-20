Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:36068 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755062AbeDTN3A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:29:00 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/8] dmaengine: shdmac: Change platform check to CONFIG_ARCH_RENESAS
Date: Fri, 20 Apr 2018 15:28:28 +0200
Message-Id: <1524230914-10175-3-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS")
is CONFIG_ARCH_RENESAS a more appropriate platform check than the legacy
CONFIG_ARCH_SHMOBILE, hence use the former.

Renesas SuperH SH-Mobile SoCs are still covered by the CONFIG_CPU_SH4
check, just like before support for Renesas ARM SoCs was added.

Instead of blindly changing all the #ifdefs, switch the main code block
in sh_dmae_probe() to IS_ENABLED(), as this allows to remove all the
remaining #ifdefs.

This will allow to drop ARCH_SHMOBILE on ARM in the near future.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/dma/sh/shdmac.c | 50 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 516f5487cc44cf96..8fcaae482ce0949a 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -440,7 +440,6 @@ static bool sh_dmae_reset(struct sh_dmae_device *shdev)
 	return ret;
 }
 
-#if defined(CONFIG_CPU_SH4) || defined(CONFIG_ARCH_SHMOBILE)
 static irqreturn_t sh_dmae_err(int irq, void *data)
 {
 	struct sh_dmae_device *shdev = data;
@@ -451,7 +450,6 @@ static irqreturn_t sh_dmae_err(int irq, void *data)
 	sh_dmae_reset(shdev);
 	return IRQ_HANDLED;
 }
-#endif
 
 static bool sh_dmae_desc_completed(struct shdma_chan *schan,
 				   struct shdma_desc *sdesc)
@@ -683,11 +681,8 @@ static int sh_dmae_probe(struct platform_device *pdev)
 	const struct sh_dmae_pdata *pdata;
 	unsigned long chan_flag[SH_DMAE_MAX_CHANNELS] = {};
 	int chan_irq[SH_DMAE_MAX_CHANNELS];
-#if defined(CONFIG_CPU_SH4) || defined(CONFIG_ARCH_SHMOBILE)
 	unsigned long irqflags = 0;
-	int errirq;
-#endif
-	int err, i, irq_cnt = 0, irqres = 0, irq_cap = 0;
+	int err, errirq, i, irq_cnt = 0, irqres = 0, irq_cap = 0;
 	struct sh_dmae_device *shdev;
 	struct dma_device *dma_dev;
 	struct resource *chan, *dmars, *errirq_res, *chanirq_res;
@@ -789,33 +784,32 @@ static int sh_dmae_probe(struct platform_device *pdev)
 	if (err)
 		goto rst_err;
 
-#if defined(CONFIG_CPU_SH4) || defined(CONFIG_ARCH_SHMOBILE)
-	chanirq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+	if (IS_ENABLED(CONFIG_CPU_SH4) || IS_ENABLED(CONFIG_ARCH_RENESAS)) {
+		chanirq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
 
-	if (!chanirq_res)
-		chanirq_res = errirq_res;
-	else
-		irqres++;
+		if (!chanirq_res)
+			chanirq_res = errirq_res;
+		else
+			irqres++;
 
-	if (chanirq_res == errirq_res ||
-	    (errirq_res->flags & IORESOURCE_BITS) == IORESOURCE_IRQ_SHAREABLE)
-		irqflags = IRQF_SHARED;
+		if (chanirq_res == errirq_res ||
+		    (errirq_res->flags & IORESOURCE_BITS) == IORESOURCE_IRQ_SHAREABLE)
+			irqflags = IRQF_SHARED;
 
-	errirq = errirq_res->start;
+		errirq = errirq_res->start;
 
-	err = devm_request_irq(&pdev->dev, errirq, sh_dmae_err, irqflags,
-			       "DMAC Address Error", shdev);
-	if (err) {
-		dev_err(&pdev->dev,
-			"DMA failed requesting irq #%d, error %d\n",
-			errirq, err);
-		goto eirq_err;
+		err = devm_request_irq(&pdev->dev, errirq, sh_dmae_err,
+				       irqflags, "DMAC Address Error", shdev);
+		if (err) {
+			dev_err(&pdev->dev,
+				"DMA failed requesting irq #%d, error %d\n",
+				errirq, err);
+			goto eirq_err;
+		}
+	} else {
+		chanirq_res = errirq_res;
 	}
 
-#else
-	chanirq_res = errirq_res;
-#endif /* CONFIG_CPU_SH4 || CONFIG_ARCH_SHMOBILE */
-
 	if (chanirq_res->start == chanirq_res->end &&
 	    !platform_get_resource(pdev, IORESOURCE_IRQ, 1)) {
 		/* Special case - all multiplexed */
@@ -881,9 +875,7 @@ static int sh_dmae_probe(struct platform_device *pdev)
 chan_probe_err:
 	sh_dmae_chan_remove(shdev);
 
-#if defined(CONFIG_CPU_SH4) || defined(CONFIG_ARCH_SHMOBILE)
 eirq_err:
-#endif
 rst_err:
 	spin_lock_irq(&sh_dmae_lock);
 	list_del_rcu(&shdev->node);
-- 
2.7.4
