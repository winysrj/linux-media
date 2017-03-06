Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:31965 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754732AbdCFOgD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:36:03 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 15/29] drivers, media: convert vb2_dma_sg_buf.refcount from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:02 +0200
Message-Id: <1488810076-3754-16-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index ecff8f4..29fde1a 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -46,7 +47,7 @@ struct vb2_dma_sg_buf {
 	struct sg_table			*dma_sgt;
 	size_t				size;
 	unsigned int			num_pages;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct vb2_vmarea_handler	handler;
 
 	struct dma_buf_attachment	*db_attach;
@@ -150,7 +151,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 	buf->handler.put = vb2_dma_sg_put;
 	buf->handler.arg = buf;
 
-	atomic_inc(&buf->refcount);
+	refcount_set(&buf->refcount, 1);
 
 	dprintk(1, "%s: Allocated buffer of %d pages\n",
 		__func__, buf->num_pages);
@@ -176,7 +177,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 	struct sg_table *sgt = &buf->sg_table;
 	int i = buf->num_pages;
 
-	if (atomic_dec_and_test(&buf->refcount)) {
+	if (refcount_dec_and_test(&buf->refcount)) {
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
 		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
@@ -320,7 +321,7 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
 
-	return atomic_read(&buf->refcount);
+	return refcount_read(&buf->refcount);
 }
 
 static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
@@ -530,7 +531,7 @@ static struct dma_buf *vb2_dma_sg_get_dmabuf(void *buf_priv, unsigned long flags
 		return NULL;
 
 	/* dmabuf keeps reference to vb2 buffer */
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return dbuf;
 }
-- 
2.7.4
