Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47009 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753503AbdCFO3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:29:48 -0500
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
Subject: [PATCH 14/29] drivers, media: convert vb2_dc_buf.refcount from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:01 +0200
Message-Id: <1488810076-3754-15-git-send-email-elena.reshetova@intel.com>
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
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index fb6a177..d29a07f 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -12,6 +12,7 @@
 
 #include <linux/dma-buf.h>
 #include <linux/module.h>
+#include <linux/refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -34,7 +35,7 @@ struct vb2_dc_buf {
 
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct sg_table			*sgt_base;
 
 	/* DMABUF related */
@@ -86,7 +87,7 @@ static unsigned int vb2_dc_num_users(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
-	return atomic_read(&buf->refcount);
+	return refcount_read(&buf->refcount);
 }
 
 static void vb2_dc_prepare(void *buf_priv)
@@ -122,7 +123,7 @@ static void vb2_dc_put(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
-	if (!atomic_dec_and_test(&buf->refcount))
+	if (!refcount_dec_and_test(&buf->refcount))
 		return;
 
 	if (buf->sgt_base) {
@@ -170,7 +171,7 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
 
-	atomic_inc(&buf->refcount);
+	refcount_set(&buf->refcount, 1);
 
 	return buf;
 }
@@ -407,7 +408,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 		return NULL;
 
 	/* dmabuf keeps reference to vb2 buffer */
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return dbuf;
 }
-- 
2.7.4
