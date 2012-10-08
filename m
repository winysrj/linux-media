Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54249 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2JHMeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 08:34:09 -0400
Received: by mail-qc0-f174.google.com with SMTP id d3so2796440qch.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 05:34:09 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 20:34:09 +0800
Message-ID: <CAPgLHd9N8YuzKY86UYmXJysv+B1E_ms4i=SAujXDZaiBHdZx=A@mail.gmail.com>
Subject: [PATCH] [media] v4l2: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@infradead.org, grant.likely@secretlab.ca,
	rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/fsl-viu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 897250b..c5091fe 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -352,8 +352,7 @@ static int restart_video_queue(struct viu_dmaqueue *vidq)
 			return 0;
 		buf = list_entry(vidq->queued.next, struct viu_buf, vb.queue);
 		if (prev == NULL) {
-			list_del(&buf->vb.queue);
-			list_add_tail(&buf->vb.queue, &vidq->active);
+			list_move_tail(&buf->vb.queue, &vidq->active);
 
 			dprintk(1, "Restarting video dma\n");
 			viu_stop_dma(vidq->dev);
@@ -367,8 +366,7 @@ static int restart_video_queue(struct viu_dmaqueue *vidq)
 		} else if (prev->vb.width  == buf->vb.width  &&
 			   prev->vb.height == buf->vb.height &&
 			   prev->fmt       == buf->fmt) {
-			list_del(&buf->vb.queue);
-			list_add_tail(&buf->vb.queue, &vidq->active);
+			list_move_tail(&buf->vb.queue, &vidq->active);
 			buf->vb.state = VIDEOBUF_ACTIVE;
 			dprintk(2, "[%p/%d] restart_queue - move to active\n",
 				buf, buf->vb.i);

