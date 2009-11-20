Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40483 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZKTKFA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 05:05:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@infradead.org
Subject: [PATCH] v4l: vm_area_struct::vm_ops isn't const on pre-2.6.32
Date: Fri, 20 Nov 2009 11:05:30 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911201105.30314.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vm_area_struct::vm_ops field became const on 2.6.32. All v4l drivers
have been changed to declare their vm_operations_struct as const, which
introduced warnings when compiling on pre-2.6.32 kernels.

Fix the warnings by not declaring the vm_operations_struct as const on
pre-2.6.32 kernels.

kernel-sync

Priority: normal

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/cafe_ccic.c
--- a/linux/drivers/media/video/cafe_ccic.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/cafe_ccic.c	Fri Nov 20 10:54:25 2009 +0100
@@ -1326,7 +1326,11 @@
 	mutex_unlock(&sbuf->cam->s_mutex);
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct cafe_v4l_vm_ops = {
+#else
 static const struct vm_operations_struct cafe_v4l_vm_ops = {
+#endif
 	.open = cafe_v4l_vm_open,
 	.close = cafe_v4l_vm_close
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/et61x251/et61x251_core.c
--- a/linux/drivers/media/video/et61x251/et61x251_core.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/et61x251/et61x251_core.c	Fri Nov 20 10:54:25 2009 +0100
@@ -1500,7 +1500,11 @@
 }
 
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct et61x251_vm_ops = {
+#else
 static const struct vm_operations_struct et61x251_vm_ops = {
+#endif
 	.open = et61x251_vm_open,
 	.close = et61x251_vm_close,
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Fri Nov 20 10:54:25 2009 +0100
@@ -103,7 +103,11 @@
 		frame->v4l2_buf.flags &= ~V4L2_BUF_FLAG_MAPPED;
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct gspca_vm_ops = {
+#else
 static const struct vm_operations_struct gspca_vm_ops = {
+#endif
 	.open		= gspca_vm_open,
 	.close		= gspca_vm_close,
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/sn9c102/sn9c102_core.c
--- a/linux/drivers/media/video/sn9c102/sn9c102_core.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/sn9c102/sn9c102_core.c	Fri Nov 20 10:54:25 2009 +0100
@@ -2081,7 +2081,11 @@
 }
 
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct sn9c102_vm_ops = {
+#else
 static const struct vm_operations_struct sn9c102_vm_ops = {
+#endif
 	.open = sn9c102_vm_open,
 	.close = sn9c102_vm_close,
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/stk-webcam.c
--- a/linux/drivers/media/video/stk-webcam.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/stk-webcam.c	Fri Nov 20 10:54:25 2009 +0100
@@ -791,7 +791,11 @@
 	if (sbuf->mapcount == 0)
 		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_MAPPED;
 }
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct stk_v4l_vm_ops = {
+#else
 static const struct vm_operations_struct stk_v4l_vm_ops = {
+#endif
 	.open = stk_v4l_vm_open,
 	.close = stk_v4l_vm_close
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Fri Nov 20 10:54:25 2009 +0100
@@ -1061,7 +1061,11 @@
 	buffer->vma_use_count--;
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct uvc_vm_ops = {
+#else
 static const struct vm_operations_struct uvc_vm_ops = {
+#endif
 	.open		= uvc_vm_open,
 	.close		= uvc_vm_close,
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/videobuf-dma-contig.c
--- a/linux/drivers/media/video/videobuf-dma-contig.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/videobuf-dma-contig.c	Fri Nov 20 10:54:25 2009 +0100
@@ -107,7 +107,11 @@
 	}
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct videobuf_vm_ops = {
+#else
 static const struct vm_operations_struct videobuf_vm_ops = {
+#endif
 	.open     = videobuf_vm_open,
 	.close    = videobuf_vm_close,
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/videobuf-dma-sg.c
--- a/linux/drivers/media/video/videobuf-dma-sg.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/videobuf-dma-sg.c	Fri Nov 20 10:54:25 2009 +0100
@@ -422,8 +422,11 @@
 }
 #endif
 
-static const struct vm_operations_struct videobuf_vm_ops =
-{
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct videobuf_vm_ops = {
+#else
+static const struct vm_operations_struct videobuf_vm_ops = {
+#endif
 	.open     = videobuf_vm_open,
 	.close    = videobuf_vm_close,
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 24)
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/videobuf-vmalloc.c
--- a/linux/drivers/media/video/videobuf-vmalloc.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/videobuf-vmalloc.c	Fri Nov 20 10:54:25 2009 +0100
@@ -117,8 +117,11 @@
 	return;
 }
 
-static const struct vm_operations_struct videobuf_vm_ops =
-{
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct videobuf_vm_ops = {
+#else
+static const struct vm_operations_struct videobuf_vm_ops = {
+#endif
 	.open     = videobuf_vm_open,
 	.close    = videobuf_vm_close,
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/zc0301/zc0301_core.c
--- a/linux/drivers/media/video/zc0301/zc0301_core.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/zc0301/zc0301_core.c	Fri Nov 20 10:54:25 2009 +0100
@@ -939,7 +939,11 @@
 }
 
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct zc0301_vm_ops = {
+#else
 static const struct vm_operations_struct zc0301_vm_ops = {
+#endif
 	.open = zc0301_vm_open,
 	.close = zc0301_vm_close,
 };
diff -r 7477df192a59 -r 36e9f5dfbfa5 linux/drivers/media/video/zoran/zoran_driver.c
--- a/linux/drivers/media/video/zoran/zoran_driver.c	Wed Nov 18 05:12:04 2009 -0200
+++ b/linux/drivers/media/video/zoran/zoran_driver.c	Fri Nov 20 10:54:25 2009 +0100
@@ -3180,7 +3180,11 @@
 	mutex_unlock(&zr->resource_lock);
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 32)
+static struct vm_operations_struct zoran_vm_ops = {
+#else
 static const struct vm_operations_struct zoran_vm_ops = {
+#endif
 	.open = zoran_vm_open,
 	.close = zoran_vm_close,
 };

-- 
Laurent Pinchart
