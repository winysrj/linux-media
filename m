Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46919 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759454AbcIMXQh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:37 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 05/13] v4l: vsp1: Use DFE instead of FRE for frame end
Date: Wed, 14 Sep 2016 02:16:58 +0300
Message-Id: <1473808626-19488-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran+renesas@bingham.xyz>

The DFE and FRE interrupts are both fired at frame completion, as each
display list processes a single frame. This won't be true anymore when
using image partitioning, switch to DFE in preparation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 92418fc09511..57c713a4e1df 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -60,7 +60,7 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
 		status = vsp1_read(vsp1, VI6_WPF_IRQ_STA(i));
 		vsp1_write(vsp1, VI6_WPF_IRQ_STA(i), ~status & mask);
 
-		if (status & VI6_WFP_IRQ_STA_FRE) {
+		if (status & VI6_WFP_IRQ_STA_DFE) {
 			vsp1_pipeline_frame_end(wpf->pipe);
 			ret = IRQ_HANDLED;
 		}
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 31983169c24a..748f5af90b7e 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -318,7 +318,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 	/* Enable interrupts */
 	vsp1_dl_list_write(dl, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
 	vsp1_dl_list_write(dl, VI6_WPF_IRQ_ENB(wpf->entity.index),
-			   VI6_WFP_IRQ_ENB_FREE);
+			   VI6_WFP_IRQ_ENB_DFEE);
 }
 
 static const struct vsp1_entity_operations wpf_entity_ops = {
-- 
Regards,

Laurent Pinchart

