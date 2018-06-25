Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:36502 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752930AbeFYNPc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 09:15:32 -0400
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Vinod Koul <vkoul@kernel.org>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Applied "dmaengine: pxa: document pxad_param" to the asoc tree
In-Reply-To: <20180524070703.11901-11-robert.jarzmik@free.fr>
Message-Id: <E1fXRKy-0008Lb-A6@debutante>
Date: Mon, 25 Jun 2018 14:15:20 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch

   dmaengine: pxa: document pxad_param

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

>From b6d1a17f4729e4fda5740a855da91d202db2c118 Mon Sep 17 00:00:00 2001
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 17 Jun 2018 19:02:14 +0200
Subject: [PATCH] dmaengine: pxa: document pxad_param

Add some documentation for the pxad_param structure, and describe the
contract behind the minimal required priority of a DMA channel.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Acked-by: Vinod Koul <vkoul@kernel.org>
---
 include/linux/dma/pxa-dma.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/dma/pxa-dma.h b/include/linux/dma/pxa-dma.h
index e56ec7af4fd7..9fc594f69eff 100644
--- a/include/linux/dma/pxa-dma.h
+++ b/include/linux/dma/pxa-dma.h
@@ -9,6 +9,15 @@ enum pxad_chan_prio {
 	PXAD_PRIO_LOWEST,
 };
 
+/**
+ * struct pxad_param - dma channel request parameters
+ * @drcmr: requestor line number
+ * @prio: minimal mandatory priority of the channel
+ *
+ * If a requested channel is granted, its priority will be at least @prio,
+ * ie. if PXAD_PRIO_LOW is required, the requested channel will be either
+ * PXAD_PRIO_LOW, PXAD_PRIO_NORMAL or PXAD_PRIO_HIGHEST.
+ */
 struct pxad_param {
 	unsigned int drcmr;
 	enum pxad_chan_prio prio;
-- 
2.18.0.rc2
