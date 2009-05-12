Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:47527 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbZELNSM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 09:18:12 -0400
Received: by pzk13 with SMTP id 13so108991pzk.33
        for <linux-media@vger.kernel.org>; Tue, 12 May 2009 06:18:13 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-mm@kvack.org,
	lethal@linux-sh.org, hannes@cmpxchg.org,
	Magnus Damm <magnus.damm@gmail.com>, akpm@linux-foundation.org
Date: Tue, 12 May 2009 22:07:19 +0900
Message-Id: <20090512130719.7857.85985.sendpatchset@rx1.opensource.se>
Subject: [PATCH] videobuf-dma-contig: zero copy USERPTR V3 comments
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm@igel.co.jp>

This patch adds function descriptions to V3 of the V4L2
videobuf-dma-contig USERPTR zero copy patch.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/videobuf-dma-contig.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- 0005/drivers/media/video/videobuf-dma-contig.c
+++ work/drivers/media/video/videobuf-dma-contig.c	2009-05-12 21:14:40.000000000 +0900
@@ -110,6 +110,12 @@ static struct vm_operations_struct video
 	.close    = videobuf_vm_close,
 };
 
+/**
+ * videobuf_dma_contig_user_put() - reset pointer to user space buffer
+ * @mem: per-buffer private videobuf-dma-contig data
+ *
+ * This function resets the user space pointer 
+ */
 static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
 {
 	mem->is_userptr = 0;
@@ -117,6 +123,16 @@ static void videobuf_dma_contig_user_put
 	mem->size = 0;
 }
 
+/**
+ * videobuf_dma_contig_user_get() - setup user space memory pointer
+ * @mem: per-buffer private videobuf-dma-contig data
+ * @vb: video buffer to map
+ *
+ * This function validates and sets up a pointer to user space memory.
+ * Only physically contiguous pfn-mapped memory is accepted.
+ *
+ * Returns 0 if successful.
+ */
 static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 					struct videobuf_buffer *vb)
 {
