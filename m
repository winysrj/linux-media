Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35560 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab2J3O3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 10:29:18 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so153345wey.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 07:29:16 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, fabio.estevam@freescale.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 4/4] media: mx2_camera: Remove buffer states.
Date: Tue, 30 Oct 2012 15:29:02 +0100
Message-Id: <1351607342-18030-5-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1351607342-18030-1-git-send-email-javier.martin@vista-silicon.com>
References: <1351607342-18030-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After removing i.mx25 support and buf_cleanup() callback,
buffer states are not used in the code any longer.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 8202cb9..a672475 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -233,12 +233,6 @@ struct mx2_fmt_cfg {
 	struct mx2_prp_cfg		cfg;
 };
 
-enum mx2_buffer_state {
-	MX2_STATE_QUEUED,
-	MX2_STATE_ACTIVE,
-	MX2_STATE_DONE,
-};
-
 struct mx2_buf_internal {
 	struct list_head	queue;
 	int			bufnum;
@@ -249,7 +243,6 @@ struct mx2_buf_internal {
 struct mx2_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct vb2_buffer		vb;
-	enum mx2_buffer_state		state;
 	struct mx2_buf_internal		internal;
 };
 
@@ -545,7 +538,6 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
-	buf->state = MX2_STATE_QUEUED;
 	list_add_tail(&buf->internal.queue, &pcdev->capture);
 
 	spin_unlock_irqrestore(&pcdev->lock, flags);
@@ -669,7 +661,6 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 			       internal.queue);
 	buf->internal.bufnum = 0;
 	vb = &buf->vb;
-	buf->state = MX2_STATE_ACTIVE;
 
 	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 	mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
@@ -679,7 +670,6 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 			       internal.queue);
 	buf->internal.bufnum = 1;
 	vb = &buf->vb;
-	buf->state = MX2_STATE_ACTIVE;
 
 	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 	mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
@@ -1368,7 +1358,6 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
 	vb = &buf->vb;
-	buf->state = MX2_STATE_ACTIVE;
 
 	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 	mx27_update_emma_buf(pcdev, phys, bufnum);
-- 
1.7.9.5

