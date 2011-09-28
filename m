Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57637 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1I1KdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 06:33:10 -0400
Date: Wed, 28 Sep 2011 12:33:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] V4L: videobuf2: update buffer state on VIDIOC_QBUF
Message-ID: <Pine.LNX.4.64.1109281228280.30317@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 specification states, that the videobuffer state flags have to be
updated on VIDIOC_QBUF ioctl(). Videobuf2 currently doesn't do that,
which is fixed by this patch.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/videobuf2-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 696c0f2..910440d 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -935,6 +935,9 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	if (q->streaming)
 		__enqueue_in_driver(vb);
 
+	/* Fill buffer information for the userspace */
+	__fill_v4l2_buffer(vb, b);
+
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
 	return 0;
 }
-- 
1.7.2.5

