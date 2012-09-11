Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2IKM7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 08:59:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 20DCE189AF7
	for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 14:59:33 +0200 (CEST)
Date: Tue, 11 Sep 2012 14:59:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] media: mem2mem: make reference to struct m2m_ops in the core
 const
Message-ID: <Pine.LNX.4.64.1209111458580.22084@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mem2mem core doesn't change struct m2m_ops, provided by the driver,
make references to it const.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |    4 ++--
 include/media/v4l2-mem2mem.h           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 3ac8358..e4ff65d 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -62,7 +62,7 @@ struct v4l2_m2m_dev {
 	struct list_head	job_queue;
 	spinlock_t		job_spinlock;
 
-	struct v4l2_m2m_ops	*m2m_ops;
+	const struct v4l2_m2m_ops *m2m_ops;
 };
 
 static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx *m2m_ctx,
@@ -506,7 +506,7 @@ EXPORT_SYMBOL(v4l2_m2m_mmap);
  *
  * Usually called from driver's probe() function.
  */
-struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops)
+struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 {
 	struct v4l2_m2m_dev *m2m_dev;
 
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 16ac473..d4bf29a26 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -122,7 +122,7 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct vm_area_struct *vma);
 
-struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops);
+struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
 
 struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
-- 
1.7.2.5

