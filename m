Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.meprolight.com ([194.90.149.17]:50623 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754374Ab2G3TQe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 15:16:34 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: <g.liakhovetski@gmx.de>, <laurent.pinchart@ideasonboard.com>,
	<m.szyprowski@samsung.com>, <linux-media@vger.kernel.org>,
	Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH] media: mx3_camera: buf_init() add buffer state check
Date: Mon, 30 Jul 2012 22:07:07 +0300
Message-ID: <1343675227-9061-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch check the state of the buffer when calling buf_init() method.
The thread http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/48587
also includes report witch can show the problem. This patch solved the problem.
Both MMAP and USERPTR methods was successfully tested.

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 drivers/media/video/mx3_camera.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index f13643d..950a8fe 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -405,13 +405,15 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 
-	/* This is for locking debugging only */
-	INIT_LIST_HEAD(&buf->queue);
-	sg_init_table(&buf->sg, 1);
+	if (buf->state != CSI_BUF_PREPARED) {
+		/* This is for locking debugging only */
+		INIT_LIST_HEAD(&buf->queue);
+		sg_init_table(&buf->sg, 1);
 
-	buf->state = CSI_BUF_NEEDS_INIT;
+		buf->state = CSI_BUF_NEEDS_INIT;
 
-	mx3_cam->buf_total += vb2_plane_size(vb, 0);
+		mx3_cam->buf_total += vb2_plane_size(vb, 0);
+	}
 
 	return 0;
 }
-- 
1.7.0.4

