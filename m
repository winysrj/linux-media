Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56949 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2JVF13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 01:27:29 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so1242284qcr.19
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 22:27:28 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 13:27:28 +0800
Message-ID: <CAPgLHd_VM=sgAfmckcY=7jhr31Fr8DPyWOcbW4vQsfzSia-5NA@mail.gmail.com>
Subject: [PATCH] [media] mx2_camera: fix missing unlock on error in mx2_start_streaming()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: g.liakhovetski@gmx.de, mchehab@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handle path in function
mx2_start_streaming().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/soc_camera/mx2_camera.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 9fd9d1c..ccb9722 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -864,8 +864,10 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 
 		bytesperline = soc_mbus_bytes_per_line(icd->user_width,
 				icd->current_fmt->host_fmt);
-		if (bytesperline < 0)
+		if (bytesperline < 0) {
+			spin_unlock_irqrestore(&pcdev->lock, flags);
 			return bytesperline;
+		}
 
 		/*
 		 * I didn't manage to properly enable/disable the prp
@@ -878,8 +880,10 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		pcdev->discard_buffer = dma_alloc_coherent(ici->v4l2_dev.dev,
 				pcdev->discard_size, &pcdev->discard_buffer_dma,
 				GFP_KERNEL);
-		if (!pcdev->discard_buffer)
+		if (!pcdev->discard_buffer) {
+			spin_unlock_irqrestore(&pcdev->lock, flags);
 			return -ENOMEM;
+		}
 
 		pcdev->buf_discard[0].discard = true;
 		list_add_tail(&pcdev->buf_discard[0].queue,


