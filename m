Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2HAIFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 04:05:24 -0400
Date: Wed, 1 Aug 2012 10:05:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Gershgorin <alexg@meprolight.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	linux-media@vger.kernel.org
Subject: [PATCH v2] media: mx3_camera: buf_init() add buffer state check
In-Reply-To: <1343675227-9061-1-git-send-email-alexg@meprolight.com>
Message-ID: <Pine.LNX.4.64.1208011002020.5406@axis700.grange>
References: <1343675227-9061-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alex Gershgorin <alexg@meprolight.com>

This patch check the state of the buffer when calling buf_init() method.
The thread http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/48587
also includes report witch can show the problem. This patch solved the problem.
Both MMAP and USERPTR methods was successfully tested.

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
[g.liakhovetski@gmx.de: remove mx3_camera_buffer::state completely]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Hi Alex

Thanks for your explanation. Please, check whether this version of your 
patch also fixes the problem and works in both MMAP and USERPTR modes.

Thanks
Guennadi

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 02d54a0..0af24d0 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -61,15 +61,9 @@
 
 #define MAX_VIDEO_MEM 16
 
-enum csi_buffer_state {
-	CSI_BUF_NEEDS_INIT,
-	CSI_BUF_PREPARED,
-};
-
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct vb2_buffer			vb;
-	enum csi_buffer_state			state;
 	struct list_head			queue;
 
 	/* One descriptot per scatterlist (per frame) */
@@ -285,7 +279,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 		goto error;
 	}
 
-	if (buf->state == CSI_BUF_NEEDS_INIT) {
+	if (!buf->txd) {
 		sg_dma_address(sg)	= vb2_dma_contig_plane_dma_addr(vb, 0);
 		sg_dma_len(sg)		= new_size;
 
@@ -298,7 +292,6 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 		txd->callback_param	= txd;
 		txd->callback		= mx3_cam_dma_done;
 
-		buf->state		= CSI_BUF_PREPARED;
 		buf->txd		= txd;
 	} else {
 		txd = buf->txd;
@@ -385,7 +378,6 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 
 	/* Doesn't hurt also if the list is empty */
 	list_del_init(&buf->queue);
-	buf->state = CSI_BUF_NEEDS_INIT;
 
 	if (txd) {
 		buf->txd = NULL;
@@ -405,13 +397,13 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 
-	/* This is for locking debugging only */
-	INIT_LIST_HEAD(&buf->queue);
-	sg_init_table(&buf->sg, 1);
+	if (!buf->txd) {
+		/* This is for locking debugging only */
+		INIT_LIST_HEAD(&buf->queue);
+		sg_init_table(&buf->sg, 1);
 
-	buf->state = CSI_BUF_NEEDS_INIT;
-
-	mx3_cam->buf_total += vb2_plane_size(vb, 0);
+		mx3_cam->buf_total += vb2_plane_size(vb, 0);
+	}
 
 	return 0;
 }
