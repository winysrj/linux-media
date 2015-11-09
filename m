Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45339 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbbKIWBt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 17:01:49 -0500
Received: from avalon.bb.dnainternet.fi (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id A977421C55
	for <linux-media@vger.kernel.org>; Mon,  9 Nov 2015 23:01:16 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: omap4iss: csi2: Fix IRQ handling when stopping module
Date: Tue, 10 Nov 2015 00:01:57 +0200
Message-Id: <1447106517-27086-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1447106517-27086-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1447106517-27086-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When stopping the CSI2 receiver the s_stream handler will wait for the
IRQ handler to notice the stop request. The receiver, automatically
disabled by the hardware after each frame, is then not reenabled by the
IRQ handler as it returns immediately.

As the IRQ handler check is performed before handling the context IRQ,
the context IRQ source isn't cleared, and the CSI2 IRQ is then fired
again immediately. The IRQ handler then fails to notice that the module
is being stopped, processes the IRQ normally and reenables the CSI2
hardware.

The problem goes unnoticed at stream stop time, but depending on the IRQ
and s_stream scheduling timings, the CSI2 receiver can end up being
hanged and will not produce any interrupt the next time it gets enabled,
despite being soft-reset then.

Fix this by checking for module stop after clearing the context IRQ
source.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_csi2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index bc83f8246101..b6b5c12b9c9d 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -674,6 +674,9 @@ static void csi2_isr_ctx(struct iss_csi2_device *csi2,
 	status = iss_reg_read(csi2->iss, csi2->regs1, CSI2_CTX_IRQSTATUS(n));
 	iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_IRQSTATUS(n), status);
 
+	if (omap4iss_module_sync_is_stopping(&csi2->wait, &csi2->stopping))
+		return;
+
 	/* Propagate frame number */
 	if (status & CSI2_CTX_IRQ_FS) {
 		struct iss_pipeline *pipe =
@@ -776,9 +779,6 @@ void omap4iss_csi2_isr(struct iss_csi2_device *csi2)
 		pipe->error = true;
 	}
 
-	if (omap4iss_module_sync_is_stopping(&csi2->wait, &csi2->stopping))
-		return;
-
 	/* Successful cases */
 	if (csi2_irqstatus & CSI2_IRQ_CONTEXT0)
 		csi2_isr_ctx(csi2, &csi2->contexts[0]);
-- 
Regards,

Laurent Pinchart

