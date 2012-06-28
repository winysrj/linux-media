Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3685 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2F1Gsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 23/33] vb2-core: add support for count == 0 in create_bufs.
Date: Thu, 28 Jun 2012 08:48:17 +0200
Message-Id: <062a4c549e24e84129c03163995dd3d912706abb.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
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
index 7d7f86f..4461106 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -669,9 +669,9 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
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
@@ -702,7 +702,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 
 	if (ret < 0) {
 		__vb2_queue_free(q, allocated_buffers);
-		return ret;
+		return -ENOMEM;
 	}
 
 	/*
@@ -726,6 +726,8 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	int ret = __verify_memory_type(q, create->memory, create->format.type);
 
 	create->index = q->num_buffers;
+	if (create->count == 0)
+		return ret != -EBUSY ? ret : 0;
 	return ret ? ret : __create_bufs(q, create);
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
-- 
1.7.10

