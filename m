Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43155 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2BMNwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 08:52:13 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so3480160wer.19
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 05:52:12 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 4/6] media: i.MX27 camera: return IRQ_NONE if no IRQ status bit is set.
Date: Mon, 13 Feb 2012 14:51:53 +0100
Message-Id: <1329141115-23133-5-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
References: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If active_bufs() list is empty and no IRQ status bit is set
we are probably dealing with a share IRQ. Return IRQ_NONE in
this case.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 34b43a4..d9028f1 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1302,7 +1302,11 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 	if (list_empty(&pcdev->active_bufs)) {
 		dev_warn(pcdev->dev, "%s: called while active list is empty\n",
 			__func__);
-		goto irq_ok;
+
+		if (!status) {
+			spin_unlock(&pcdev->lock);
+			return IRQ_NONE;
+		}
 	}
 
 	if (status & (1 << 7)) { /* overflow */
@@ -1327,7 +1331,6 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 		mx27_camera_frame_done_emma(pcdev, 1, false);
 	}
 
-irq_ok:
 	spin_unlock(&pcdev->lock);
 	writel(status, pcdev->base_emma + PRP_INTRSTATUS);
 
-- 
1.7.0.4

