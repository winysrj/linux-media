Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35684 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbdL1Q3o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 11:29:44 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 4/5] media: vb2: add pr_fmt() macro
Date: Thu, 28 Dec 2017 14:29:37 -0200
Message-Id: <d758ab588b68118ed8e29ff3aec4bcd3bf48ba0c.1514478428.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514478428.git.mchehab@s-opensource.com>
References: <cover.1514478428.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514478428.git.mchehab@s-opensource.com>
References: <cover.1514478428.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the pr_foo() macros by adding a pr_fmt() macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/videobuf/videobuf2-core.c | 30 ++++++++++++++------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/media/common/videobuf/videobuf2-core.c b/drivers/media/common/videobuf/videobuf2-core.c
index ba04103f2f32..195942bf8fde 100644
--- a/drivers/media/common/videobuf/videobuf2-core.c
+++ b/drivers/media/common/videobuf/videobuf2-core.c
@@ -14,6 +14,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -32,10 +34,10 @@
 static int debug;
 module_param(debug, int, 0644);
 
-#define dprintk(level, fmt, arg...)					      \
-	do {								      \
-		if (debug >= level)					      \
-			pr_info("vb2-core: %s: " fmt, __func__, ## arg); \
+#define dprintk(level, fmt, arg...)				\
+	do {							\
+		if (debug >= level)				\
+			pr_info("%s: " fmt, __func__, ## arg);	\
 	} while (0)
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -463,12 +465,12 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 				  q->cnt_wait_prepare != q->cnt_wait_finish;
 
 		if (unbalanced || debug) {
-			pr_info("vb2: counters for queue %p:%s\n", q,
+			pr_info("counters for queue %p:%s\n", q,
 				unbalanced ? " UNBALANCED!" : "");
-			pr_info("vb2:     setup: %u start_streaming: %u stop_streaming: %u\n",
+			pr_info("     setup: %u start_streaming: %u stop_streaming: %u\n",
 				q->cnt_queue_setup, q->cnt_start_streaming,
 				q->cnt_stop_streaming);
-			pr_info("vb2:     wait_prepare: %u wait_finish: %u\n",
+			pr_info("     wait_prepare: %u wait_finish: %u\n",
 				q->cnt_wait_prepare, q->cnt_wait_finish);
 		}
 		q->cnt_queue_setup = 0;
@@ -489,23 +491,23 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
 
 		if (unbalanced || debug) {
-			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
+			pr_info("   counters for queue %p, buffer %d:%s\n",
 				q, buffer, unbalanced ? " UNBALANCED!" : "");
-			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
+			pr_info("     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
 				vb->cnt_buf_init, vb->cnt_buf_cleanup,
 				vb->cnt_buf_prepare, vb->cnt_buf_finish);
-			pr_info("vb2:     buf_queue: %u buf_done: %u\n",
+			pr_info("     buf_queue: %u buf_done: %u\n",
 				vb->cnt_buf_queue, vb->cnt_buf_done);
-			pr_info("vb2:     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
+			pr_info("     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
 				vb->cnt_mem_alloc, vb->cnt_mem_put,
 				vb->cnt_mem_prepare, vb->cnt_mem_finish,
 				vb->cnt_mem_mmap);
-			pr_info("vb2:     get_userptr: %u put_userptr: %u\n",
+			pr_info("     get_userptr: %u put_userptr: %u\n",
 				vb->cnt_mem_get_userptr, vb->cnt_mem_put_userptr);
-			pr_info("vb2:     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
+			pr_info("     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
 				vb->cnt_mem_attach_dmabuf, vb->cnt_mem_detach_dmabuf,
 				vb->cnt_mem_map_dmabuf, vb->cnt_mem_unmap_dmabuf);
-			pr_info("vb2:     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
+			pr_info("     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
 				vb->cnt_mem_get_dmabuf,
 				vb->cnt_mem_num_users,
 				vb->cnt_mem_vaddr,
-- 
2.14.3
