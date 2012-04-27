Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2D0IQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 04:16:48 -0400
Date: Fri, 27 Apr 2012 10:16:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH] V4L: mem2mem: fix alignment in mem2mem-testdev
Message-ID: <Pine.LNX.4.64.1204271013550.31986@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a trivial alignment calculation issue.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 12897e8..82f86ca 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -40,7 +40,7 @@ MODULE_VERSION("0.1.1");
 #define MIN_H 32
 #define MAX_W 640
 #define MAX_H 480
-#define DIM_ALIGN_MASK 0x08 /* 8-alignment for dimensions */
+#define DIM_ALIGN_MASK 7 /* 8-byte alignment for line length */
 
 /* Flags that indicate a format can be used for capture/output */
 #define MEM2MEM_CAPTURE	(1 << 0)
