Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:61922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1CWJ3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 05:29:17 -0400
Date: Wed, 23 Mar 2011 10:29:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] ARM: mach-shmobile: add coherent DMA mask to CEU camera
 devices
Message-ID: <Pine.LNX.4.64.1103231025560.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Cameras are currently broken on ARM sh-mobile platforms. They need a
suitable coherent DMA mask.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-shmobile/board-ap4evb.c   |    3 ++-
 arch/arm/mach-shmobile/board-mackerel.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 81d6536..77bf226 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -923,7 +923,8 @@ static struct platform_device ceu_device = {
 	.num_resources	= ARRAY_SIZE(ceu_resources),
 	.resource	= ceu_resources,
 	.dev	= {
-		.platform_data	= &sh_mobile_ceu_info,
+		.platform_data		= &sh_mobile_ceu_info,
+		.coherent_dma_mask	= 0xffffffff,
 	},
 };
 
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 063a320..71de352 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -887,7 +887,8 @@ static struct platform_device ceu_device = {
 	.num_resources	= ARRAY_SIZE(ceu_resources),
 	.resource	= ceu_resources,
 	.dev		= {
-		.platform_data	= &sh_mobile_ceu_info,
+		.platform_data		= &sh_mobile_ceu_info,
+		.coherent_dma_mask	= 0xffffffff,
 	},
 };
 
-- 
1.7.2.5

