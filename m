Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47064 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1DCXv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 19:51:28 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so5394248iyb.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:51:28 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, s.nawrocki@samsung.com,
	g.liakhovetski@gmx.de, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 3/5] [media] s5p-fimc: remove stop_streaming() callback return
Date: Sun,  3 Apr 2011 16:51:08 -0700
Message-Id: <1301874670-14833-4-git-send-email-pawel@osciak.com>
In-Reply-To: <1301874670-14833-1-git-send-email-pawel@osciak.com>
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The stop_streaming() callback does not return a value anymore.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    4 ++--
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 95f8b4e1..34e55a4 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -247,7 +247,7 @@ static int start_streaming(struct vb2_queue *q)
 	return 0;
 }
 
-static int stop_streaming(struct vb2_queue *q)
+static void stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
@@ -255,7 +255,7 @@ static int stop_streaming(struct vb2_queue *q)
 	if (!fimc_capture_active(fimc))
 		return -EINVAL;
 
-	return fimc_stop_capture(fimc);
+	fimc_stop_capture(fimc);
 }
 
 static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6c919b3..66571d7 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -348,13 +348,11 @@ static void fimc_m2m_shutdown(struct fimc_ctx *ctx)
 		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 }
 
-static int stop_streaming(struct vb2_queue *q)
+static void stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 
 	fimc_m2m_shutdown(ctx);
-
-	return 0;
 }
 
 static void fimc_capture_irq_handler(struct fimc_dev *fimc)
-- 
1.7.4.2

