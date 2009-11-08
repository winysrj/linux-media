Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39221 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751476AbZKHOIP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2009 09:08:15 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1N78Ra-00062y-LP
	for linux-media@vger.kernel.org; Sun, 08 Nov 2009 15:08:38 +0100
Date: Sun, 8 Nov 2009 15:08:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l: add more missing linux/sched.h includions
Message-ID: <Pine.LNX.4.64.0911081506340.19545@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Unless there are objections, I'll be asking Mauro to pull this and one 
more patch later today.

 drivers/media/video/mx1_camera.c           |    1 +
 drivers/media/video/mx3_camera.c           |    1 +
 drivers/media/video/sh_mobile_ceu_camera.c |    1 +
 drivers/media/video/videobuf-dma-contig.c  |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 5f37952..7280229 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -28,6 +28,7 @@
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
+#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/version.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index dff2e5e..7db82bd 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -17,6 +17,7 @@
 #include <linux/clk.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index a2b5d39..56fc7ec 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -31,6 +31,7 @@
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <linux/pm_runtime.h>
+#include <linux/sched.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 635ffc7..c3065c4 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/dma-mapping.h>
+#include <linux/sched.h>
 #include <media/videobuf-dma-contig.h>
 
 struct videobuf_dma_contig_memory {
-- 
1.6.2.4

