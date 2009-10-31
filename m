Return-path: <linux-media-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:42740 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbZJaKsh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 06:48:37 -0400
Date: Sat, 31 Oct 2009 10:28:50 +0000
From: Martin Michlmayr <tbm@cyrius.com>
To: Magnus Damm <damm@igel.co.jp>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] videobuf-dma-contig.c: add missing #include
Message-ID: <20091031102850.GA3850@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media/video/videobuf-dma-contig.c fails to compile on ARM Versatile
like this:
 | videobuf-dma-contig.c: In function ‘videobuf_dma_contig_user_get’:
 | videobuf-dma-contig.c:139: error: dereferencing pointer to incomplete type
 | videobuf-dma-contig.c:184: error: dereferencing pointer to incomplete type
 | make[8]: *** [drivers/media/video/videobuf-dma-contig.o] Error 1

Looking at the preprocessed source, I noticed that there was no definition
for struct task_struct.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

--- a/drivers/media/video/videobuf-dma-contig.c	2009-10-31 10:22:42.000000000 +0000
+++ b/drivers/media/video/videobuf-dma-contig.c	2009-10-31 10:24:40.000000000 +0000
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/dma-mapping.h>
+#include <linux/sched.h>
 #include <media/videobuf-dma-contig.h>
 
 struct videobuf_dma_contig_memory {

-- 
Martin Michlmayr
http://www.cyrius.com/
