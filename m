Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2319 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab2FVMVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 24/34] vb2-core: add support for count == 0 in create_bufs.
Date: Fri, 22 Jun 2012 14:21:18 +0200
Message-Id: <951bfdce738f946daa53d7a966c8d9c8621bfe48.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This also fixes incorrect error handling in create_bufs: the return code
of __vb2_queue_alloc is the number of allocated buffers, and not a
traditional error code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf2-core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 8486e33..bfcacaa 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -667,9 +667,9 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	/* Finally, allocate buffers and video memory */
 	ret = __vb2_queue_alloc(q, create->memory, num_buffers,
 				num_planes);
-	if (ret < 0) {
-		dprintk(1, "Memory allocation failed with error: %d\n", ret);
-		return ret;
+	if (ret == 0) {
+		dprintk(1, "Memory allocation failed\n");
+		return -ENOMEM;
 	}
 
 	allocated_buffers = ret;
@@ -700,7 +700,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 
 	if (ret < 0) {
 		__vb2_queue_free(q, allocated_buffers);
-		return ret;
+		return -ENOMEM;
 	}
 
 	/*
@@ -724,6 +724,8 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	int ret = __verify_memory_type(q, create->memory, create->format.type);
 
 	create->index = q->num_buffers;
+	if (create->count == 0)
+		return ret != -EBUSY ? ret : 0;
 	return ret ? ret : __create_bufs(q, create);
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
-- 
1.7.10

