Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:51888 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755606Ab2FGJnT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jun 2012 05:43:19 -0400
From: Albert Wang <twang13@marvell.com>
To: pawel@osciak.com, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>
Subject: [PATCH] [media] videobuf2: correct the #ifndef text mistake in videobuf2-dma-contig.h
Date: Thu,  7 Jun 2012 17:42:24 +0800
Message-Id: <1339062144-4059-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  It should be a mistake due to copy & paste in header file
  Correct it in videobuf2-dma-config.h for avoiding duplicate include it

Change-Id: I1f71fcec2889c033c7db380c58d9a1369c5afb35
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 include/media/videobuf2-dma-contig.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 19ae1e3..8197f87 100755
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -1,5 +1,5 @@
 /*
- * videobuf2-dma-coherent.h - DMA coherent memory allocator for videobuf2
+ * videobuf2-dma-contig.h - DMA contig memory allocator for videobuf2
  *
  * Copyright (C) 2010 Samsung Electronics
  *
@@ -10,8 +10,8 @@
  * the Free Software Foundation.
  */
 
-#ifndef _MEDIA_VIDEOBUF2_DMA_COHERENT_H
-#define _MEDIA_VIDEOBUF2_DMA_COHERENT_H
+#ifndef _MEDIA_VIDEOBUF2_DMA_CONTIG_H
+#define _MEDIA_VIDEOBUF2_DMA_CONTIG_H
 
 #include <media/videobuf2-core.h>
 #include <linux/dma-mapping.h>
-- 
1.7.0.4

