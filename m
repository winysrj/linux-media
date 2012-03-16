Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56069 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162040Ab2CPXgU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:20 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/7] marvell-cam: Increase the DMA shutdown timeout
Date: Fri, 16 Mar 2012 17:14:52 -0600
Message-Id: <1331939696-12482-4-git-send-email-corbet@lwn.net>
In-Reply-To: <1331939696-12482-1-git-send-email-corbet@lwn.net>
References: <1331939696-12482-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Experience shows that, on the Armada platform, it can take as much as 120ms
for the DMA engine to actually shut down after it has been told to.  So a
40ms timeout is not adequate; use 150ms instead.  Also make sure we don't
leave the DMA_ACTIVE flag set once things are down.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index b261182..050724f 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -742,7 +742,14 @@ static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
 	mcam_ctlr_stop(cam);
 	cam->state = S_IDLE;
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	msleep(40);
+	/*
+	 * This is a brutally long sleep, but experience shows that
+	 * it can take the controller a while to get the message that
+	 * it needs to stop grabbing frames.  In particular, we can
+	 * sometimes (on mmp) get a frame at the end WITHOUT the
+	 * start-of-frame indication.
+	 */
+	msleep(150);
 	if (test_bit(CF_DMA_ACTIVE, &cam->flags))
 		cam_err(cam, "Timeout waiting for DMA to end\n");
 		/* This would be bad news - what now? */
@@ -885,6 +892,7 @@ static int mcam_read_setup(struct mcam_camera *cam)
 	 * Turn it loose.
 	 */
 	spin_lock_irqsave(&cam->dev_lock, flags);
+	clear_bit(CF_DMA_ACTIVE, &cam->flags);
 	mcam_reset_buffers(cam);
 	mcam_ctlr_irq_enable(cam);
 	cam->state = S_STREAMING;
-- 
1.7.9.3

