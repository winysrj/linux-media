Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41440 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2LaQ2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:28:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/2] omap3isp: Remove unneeded memset after kzalloc
Date: Mon, 31 Dec 2012 17:29:54 +0100
Message-Id: <1356971395-3135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kzalloc initializes the memory it allocates to 0, there's no need for an
explicit memset.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isph3a_aewb.c |    1 -
 drivers/media/platform/omap3isp/isph3a_af.c   |    1 -
 drivers/media/platform/omap3isp/isphist.c     |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index 036e996..1b908fd 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -306,7 +306,6 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	if (!aewb_cfg)
 		return -ENOMEM;
 
-	memset(aewb, 0, sizeof(*aewb));
 	aewb->ops = &h3a_aewb_ops;
 	aewb->priv = aewb_cfg;
 	aewb->dma_ch = -1;
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index 42ccce3..d645b41 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -369,7 +369,6 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	if (af_cfg == NULL)
 		return -ENOMEM;
 
-	memset(af, 0, sizeof(*af));
 	af->ops = &h3a_af_ops;
 	af->priv = af_cfg;
 	af->dma_ch = -1;
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index 2d759c5..da2fa98 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -481,7 +481,6 @@ int omap3isp_hist_init(struct isp_device *isp)
 	if (hist_cfg == NULL)
 		return -ENOMEM;
 
-	memset(hist, 0, sizeof(*hist));
 	hist->isp = isp;
 
 	if (HIST_CONFIG_DMA)
-- 
1.7.8.6

