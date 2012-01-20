Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36272 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2ATLgs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 06:36:48 -0500
Received: by wgbed3 with SMTP id ed3so238166wgb.1
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 03:36:46 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de, baruch@tkos.co.il,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 4/4] media i.MX27 camera: handle overflows properly.
Date: Fri, 20 Jan 2012 12:36:32 +0100
Message-Id: <1327059392-29240-5-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index e0c5dd4..cdc614f 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1274,7 +1274,10 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		buf->state = state;
 		do_gettimeofday(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = pcdev->frame_count;
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		if (state == MX2_STATE_ERROR)
+			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		else
+			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	}
 
 	pcdev->frame_count++;
@@ -1309,19 +1312,11 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 	struct mx2_buffer *buf;
 
 	if (status & (1 << 7)) { /* overflow */
-		u32 cntl;
-		/*
-		 * We only disable channel 1 here since this is the only
-		 * enabled channel
-		 *
-		 * FIXME: the correct DMA overflow handling should be resetting
-		 * the buffer, returning an error frame, and continuing with
-		 * the next one.
-		 */
-		cntl = readl(pcdev->base_emma + PRP_CNTL);
-		writel(cntl & ~(PRP_CNTL_CH1EN | PRP_CNTL_CH2EN),
-		       pcdev->base_emma + PRP_CNTL);
-		writel(cntl, pcdev->base_emma + PRP_CNTL);
+		buf = list_entry(pcdev->active_bufs.next,
+			struct mx2_buffer, queue);
+		mx27_camera_frame_done_emma(pcdev,
+					buf->bufnum, MX2_STATE_ERROR);
+		status &= ~(1 << 7);
 	}
 	if ((((status & (3 << 5)) == (3 << 5)) ||
 		((status & (3 << 3)) == (3 << 3)))
-- 
1.7.0.4

