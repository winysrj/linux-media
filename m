Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:49334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1HDHOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:25 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/21] [staging] tm6000: Flesh out the IRQ callback.
Date: Thu,  4 Aug 2011 09:14:06 +0200
Message-Id: <1312442059-23935-9-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This brings the IRQ callback implementation more in line with how other
drivers do it.
---
 drivers/staging/tm6000/tm6000-video.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index e0cd512..4b50f6c 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -517,9 +517,21 @@ static void tm6000_irq_callback(struct urb *urb)
 	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
 	int i;
 
-	if (!dev)
+	switch (urb->status) {
+	case 0:
+	case -ETIMEDOUT:
+		break;
+
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
 		return;
 
+	default:
+		tm6000_err("urb completion error %d.\n", urb->status);
+		break;
+	}
+
 	spin_lock(&dev->slock);
 	tm6000_isoc_copy(urb);
 	spin_unlock(&dev->slock);
-- 
1.7.6

