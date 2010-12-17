Return-path: <mchehab@gaivota>
Received: from mail-out.m-online.net ([212.18.0.9]:42490 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0LQJkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 04:40:40 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Detlev Zundel <dzu@denx.de>
Subject: [PATCH] media: fsl-viu: fix support for streaming with mmap method
Date: Fri, 17 Dec 2010 10:40:50 +0100
Message-Id: <1292578850-7392-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Streaming using mmap didn't work in the VIU driver. We need to
start/stop DMA in streamon/streamoff and free the buffers on
release. Add appropriate driver extension now.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/fsl-viu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index c9eb161..483a5ed 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -917,6 +917,8 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	if (fh->type != i)
 		return -EINVAL;
 
+	viu_start_dma(fh->dev);
+
 	return videobuf_streamon(&fh->vb_vidq);
 }
 
@@ -929,6 +931,8 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	if (fh->type != i)
 		return -EINVAL;
 
+	viu_stop_dma(fh->dev);
+
 	return videobuf_streamoff(&fh->vb_vidq);
 }
 
@@ -1350,6 +1354,7 @@ static int viu_release(struct file *file)
 
 	viu_stop_dma(dev);
 	videobuf_stop(&fh->vb_vidq);
+	videobuf_mmap_free(&fh->vb_vidq);
 
 	kfree(fh);
 
-- 
1.7.1

