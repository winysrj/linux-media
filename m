Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbbJEMRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 08:17:15 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] [media] DocBook: Fix remaining issues with VB2 core documentation
Date: Mon,  5 Oct 2015 09:17:03 -0300
Message-Id: <efe98010b80ec4516b2779e1b4e4a8ce16bf89fe.1444047333.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also, no fields after "private:" should be documented. As we don't
want to strip the documentation, let's untag. This way, it will
be seen only at the file, and not at the DocBooks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 128b15ad5497..af9a5d177fca 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -202,11 +202,6 @@ struct vb2_queue;
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue
  * @planes:		private per-plane information; do not change
- * @state:		current buffer state; do not change
- * @queued_entry:	entry on the queued buffers list, which holds all
- *			buffers queued from userspace
- * @done_entry:		entry on the list that stores all buffers ready to
- *			be dequeued to userspace
  */
 struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
@@ -216,7 +211,14 @@ struct vb2_buffer {
 	unsigned int		num_planes;
 	struct vb2_plane	planes[VIDEO_MAX_PLANES];
 
-	/* Private: internal use only */
+	/* private: internal use only
+	 *
+	 * state:		current buffer state; do not change
+	 * queued_entry:	entry on the queued buffers list, which holds
+	 *			all buffers queued from userspace
+	 * done_entry:		entry on the list that stores all buffers ready
+	 *			to be dequeued to userspace
+	 */
 	enum vb2_buffer_state	state;
 
 	struct list_head	queued_entry;
-- 
2.4.3

