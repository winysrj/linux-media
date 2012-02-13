Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56514 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab2BMNwL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 08:52:11 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so3480142wer.19
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 05:52:10 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/6] media: i.MX27 camera: Use spin_lock() inside the IRQ handler.
Date: Mon, 13 Feb 2012 14:51:52 +0100
Message-Id: <1329141115-23133-4-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
References: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need to use spin_lock_irqsave() since there are not
any other IRQs that can race with this ISR.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 13be305..34b43a4 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1296,9 +1296,8 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 	struct mx2_camera_dev *pcdev = data;
 	unsigned int status = readl(pcdev->base_emma + PRP_INTRSTATUS);
 	struct mx2_buffer *buf;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock(&pcdev->lock);
 
 	if (list_empty(&pcdev->active_bufs)) {
 		dev_warn(pcdev->dev, "%s: called while active list is empty\n",
@@ -1329,7 +1328,7 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 	}
 
 irq_ok:
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock(&pcdev->lock);
 	writel(status, pcdev->base_emma + PRP_INTRSTATUS);
 
 	return IRQ_HANDLED;
-- 
1.7.0.4

