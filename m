Return-path: <linux-media-owner@vger.kernel.org>
Received: from vena.lwn.net ([206.168.112.25]:50483 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbZKWR3b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 12:29:31 -0500
Date: Mon, 23 Nov 2009 10:29:35 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH, RFC] Fix videobuf_queue_vmalloc_init() prototype
Message-ID: <20091123102935.1e89561e@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For whatever reason, the device structure pointer to
videobuf_queue_vmalloc_init is typed "void *", even though it's passed
right through to videobuf_queue_core_init(), which expects a struct
device pointer.  The other videobuf implementations use struct device *;
I think vmalloc should too.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 99d646e..d6e6a28 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -392,7 +392,7 @@ static struct videobuf_qtype_ops qops = {
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
 			 const struct videobuf_queue_ops *ops,
-			 void *dev,
+			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
 			 enum v4l2_field field,
diff --git a/include/media/videobuf-vmalloc.h b/include/media/videobuf-vmalloc.h
index 1ffdb66..4b419a2 100644
--- a/include/media/videobuf-vmalloc.h
+++ b/include/media/videobuf-vmalloc.h
@@ -31,7 +31,7 @@ struct videobuf_vmalloc_memory
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
 			 const struct videobuf_queue_ops *ops,
-			 void *dev,
+			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
 			 enum v4l2_field field,
