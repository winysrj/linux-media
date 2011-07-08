Return-path: <mchehab@localhost>
Received: from tex.lwn.net ([70.33.254.29]:36261 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1GHUwJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 16:52:09 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/6] marvell-cam: clean up a couple of unused cam structure fields
Date: Fri,  8 Jul 2011 14:50:50 -0600
Message-Id: <1310158250-168899-7-git-send-email-corbet@lwn.net>
In-Reply-To: <1310158250-168899-1-git-send-email-corbet@lwn.net>
References: <1310158250-168899-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Delete a couple of leftover fields whose time has passed.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |    2 --
 drivers/media/video/marvell-ccic/mcam-core.h |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 073e72c..83c1451 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -1638,7 +1638,6 @@ static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 	clear_bit(CF_DMA_ACTIVE, &cam->flags);
 	cam->next_buf = frame;
 	cam->buf_seq[frame] = ++(cam->sequence);
-	cam->last_delivered = frame;
 	frames++;
 	/*
 	 * "This should never happen"
@@ -1741,7 +1740,6 @@ int mccic_register(struct mcam_camera *cam)
 	mcam_set_config_needed(cam, 1);
 	cam->pix_format = mcam_def_pix_format;
 	cam->mbus_code = mcam_def_mbus_code;
-	INIT_LIST_HEAD(&cam->dev_list);
 	INIT_LIST_HEAD(&cam->buffers);
 	mcam_ctlr_init(cam);
 
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index aa55255..917200e 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -116,8 +116,6 @@ struct mcam_camera {
 	struct v4l2_subdev *sensor;
 	unsigned short sensor_addr;
 
-	struct list_head dev_list;	/* link to other devices */
-
 	/* Videobuf2 stuff */
 	struct vb2_queue vb_queue;
 	struct list_head buffers;	/* Available frames */
@@ -138,7 +136,6 @@ struct mcam_camera {
 	/* DMA buffers - DMA modes */
 	struct mcam_vb_buffer *vb_bufs[MAX_DMA_BUFS];
 	struct vb2_alloc_ctx *vb_alloc_ctx;
-	unsigned short last_delivered;
 
 	/* Mode-specific ops, set at open time */
 	void (*dma_setup)(struct mcam_camera *cam);
-- 
1.7.6

