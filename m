Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43155 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2BMNwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 08:52:07 -0500
Received: by werb13 with SMTP id b13so3480160wer.19
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 05:52:06 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/6] media: i.MX27 camera: Remove goto from mx2_videobuf_queue().
Date: Mon, 13 Feb 2012 14:51:50 +0100
Message-Id: <1329141115-23133-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
References: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index e70d26f..1f046a3 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -580,9 +580,7 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 	buf->state = MX2_STATE_QUEUED;
 	list_add_tail(&buf->queue, &pcdev->capture);
 
-	if (mx27_camera_emma(pcdev)) {
-		goto out;
-	} else { /* cpu_is_mx25() */
+	if (cpu_is_mx25()) {
 		u32 csicr3, dma_inten = 0;
 
 		if (pcdev->fb1_active == NULL) {
@@ -618,7 +616,6 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 		}
 	}
 
-out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-- 
1.7.0.4

