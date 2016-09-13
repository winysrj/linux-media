Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46951 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756027AbcIMX2f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:28:35 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 14/13] v4l: vsp1: Fix spinlock in mixed IRQ context function
Date: Wed, 14 Sep 2016 02:29:08 +0300
Message-Id: <1473809348-5222-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The wpf_configure() function can be called both from IRQ and non-IRQ
contexts, use spin_lock_irqsave().

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_wpf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index b4ecffbaa3e3..c483fead3e98 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -251,11 +251,12 @@ static void wpf_configure(struct vsp1_entity *entity,
 	if (params == VSP1_ENTITY_PARAMS_RUNTIME) {
 		const unsigned int mask = BIT(WPF_CTRL_VFLIP)
 					| BIT(WPF_CTRL_HFLIP);
+		unsigned long flags;
 
-		spin_lock(&wpf->flip.lock);
+		spin_lock_irqsave(&wpf->flip.lock, flags);
 		wpf->flip.active = (wpf->flip.active & ~mask)
 				 | (wpf->flip.pending & mask);
-		spin_unlock(&wpf->flip.lock);
+		spin_unlock_irqrestore(&wpf->flip.lock, flags);
 
 		outfmt = (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT) | wpf->outfmt;
 
-- 
Regards,

Laurent Pinchart

