Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f184.google.com ([209.85.216.184]:37799 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZGWWuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 18:50:16 -0400
Received: by pxi14 with SMTP id 14so50867pxi.33
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 15:50:16 -0700 (PDT)
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Subject: [PATCH] V4L/DVB: dm646x: fix DMA_nnBIT_MASK
Date: Thu, 23 Jul 2009 15:50:13 -0700
Message-Id: <1248389413-19366-1-git-send-email-khilman@deeprootsystems.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix deprecated use of DMA_nnBIT_MASK which now gives a compiler
warning.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
This compiler warning patch is on top of the master branch of Mauro's 
linux-next tree.

 arch/arm/mach-davinci/dm646x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 73a7e8b..8f38371 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -720,7 +720,7 @@ static struct platform_device vpif_display_dev = {
 	.id		= -1,
 	.dev		= {
 			.dma_mask 		= &vpif_dma_mask,
-			.coherent_dma_mask	= DMA_32BIT_MASK,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.resource	= vpif_resource,
 	.num_resources	= ARRAY_SIZE(vpif_resource),
-- 
1.6.3.3

