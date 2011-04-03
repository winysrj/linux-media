Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37753 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1DCXvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 19:51:25 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so5256601iwn.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:51:25 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, s.nawrocki@samsung.com,
	g.liakhovetski@gmx.de, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 2/5] [media] vivi: adapt to the new stop_streaming() callback behavior
Date: Sun,  3 Apr 2011 16:51:07 -0700
Message-Id: <1301874670-14833-3-git-send-email-pawel@osciak.com>
In-Reply-To: <1301874670-14833-1-git-send-email-pawel@osciak.com>
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Drivers are no longer required to call vb2_buffer_done() for all buffers
they have queued in stop_streaming().
The return value for stop_streaming() has also been removed.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/vivi.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2238a61..fcf11d7 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -627,8 +627,8 @@ static void vivi_stop_generating(struct vivi_dev *dev)
 	}
 
 	/*
-	 * Typical driver might need to wait here until dma engine stops.
-	 * In this case we can abort imiedetly, so it's just a noop.
+	 * A typical driver might need to stop the hardware here and wait
+	 * for any ongoing operations to finish.
 	 */
 
 	/* Release all active buffers */
@@ -636,7 +636,6 @@ static void vivi_stop_generating(struct vivi_dev *dev)
 		struct vivi_buffer *buf;
 		buf = list_entry(dma_q->active.next, struct vivi_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 		dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
 	}
 }
@@ -766,13 +765,11 @@ static int start_streaming(struct vb2_queue *vq)
 	return vivi_start_generating(dev);
 }
 
-/* abort streaming and wait for last buffer */
-static int stop_streaming(struct vb2_queue *vq)
+static void stop_streaming(struct vb2_queue *vq)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	dprintk(dev, 1, "%s\n", __func__);
 	vivi_stop_generating(dev);
-	return 0;
 }
 
 static void vivi_lock(struct vb2_queue *vq)
-- 
1.7.4.2

