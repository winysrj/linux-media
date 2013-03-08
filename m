Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3845 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439Ab3CHJWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 04:22:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/2] vb2-dma-sg: add debug module option.
Date: Fri,  8 Mar 2013 10:21:57 +0100
Message-Id: <552bc620da0483a6bd5a41604759c7f86abfd058.1362734097.git.hans.verkuil@cisco.com>
In-Reply-To: <1362734517-9420-1-git-send-email-hverkuil@xs4all.nl>
References: <1362734517-9420-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6b64252b870ca5f3433b1d5ed2a2d1f977cd8f48.1362734097.git.hans.verkuil@cisco.com>
References: <6b64252b870ca5f3433b1d5ed2a2d1f977cd8f48.1362734097.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This prevents the kernel log from being spammed with these messages.
By turning on the debug option you will see them again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 952776f..59522b2 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -21,6 +21,15 @@
 #include <media/videobuf2-memops.h>
 #include <media/videobuf2-dma-sg.h>
 
+static int debug;
+module_param(debug, int, 0644);
+
+#define dprintk(level, fmt, arg...)					\
+	do {								\
+		if (debug >= level)					\
+			printk(KERN_DEBUG "vb2-dma-sg: " fmt, ## arg);	\
+	} while (0)
+
 struct vb2_dma_sg_buf {
 	void				*vaddr;
 	struct page			**pages;
@@ -74,7 +83,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 
 	atomic_inc(&buf->refcount);
 
-	printk(KERN_DEBUG "%s: Allocated buffer of %d pages\n",
+	dprintk(1, "%s: Allocated buffer of %d pages\n",
 		__func__, buf->sg_desc.num_pages);
 	return buf;
 
@@ -97,7 +106,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 	int i = buf->sg_desc.num_pages;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
-		printk(KERN_DEBUG "%s: Freeing buffer of %d pages\n", __func__,
+		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->sg_desc.num_pages);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
@@ -163,7 +172,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	return buf;
 
 userptr_fail_get_user_pages:
-	printk(KERN_DEBUG "get_user_pages requested/got: %d/%d]\n",
+	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
 	       num_pages_from_user, buf->sg_desc.num_pages);
 	while (--num_pages_from_user >= 0)
 		put_page(buf->pages[num_pages_from_user]);
@@ -186,7 +195,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 	struct vb2_dma_sg_buf *buf = buf_priv;
 	int i = buf->sg_desc.num_pages;
 
-	printk(KERN_DEBUG "%s: Releasing userspace buffer of %d pages\n",
+	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
 	       __func__, buf->sg_desc.num_pages);
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
-- 
1.7.10.4

