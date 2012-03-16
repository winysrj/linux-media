Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56073 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162041Ab2CPXgU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:20 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/7] marvell-cam: ensure that the camera stops when requested
Date: Fri, 16 Mar 2012 17:14:50 -0600
Message-Id: <1331939696-12482-2-git-send-email-corbet@lwn.net>
In-Reply-To: <1331939696-12482-1-git-send-email-corbet@lwn.net>
References: <1331939696-12482-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The controller stop/restart logic could possibly restart DMA after the
driver things things have stopped, with suitably ugly results.  Make sure
that we only restart the hardware if we're supposed to be streaming.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 37d20e7..35cd89d 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -556,6 +556,11 @@ static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
 	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
 
 	/*
+	 * If we're no longer supposed to be streaming, don't do anything.
+	 */
+	if (cam->state != S_STREAMING)
+		return;
+	/*
 	 * Very Bad Not Good Things happen if you don't clear
 	 * C1_DESC_ENA before making any descriptor changes.
 	 */
@@ -922,7 +927,7 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
 	list_add(&mvb->queue, &cam->buffers);
-	if (test_bit(CF_SG_RESTART, &cam->flags))
+	if (cam->state == S_STREAMING && test_bit(CF_SG_RESTART, &cam->flags))
 		mcam_sg_restart(cam);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 	if (start)
-- 
1.7.9.3

