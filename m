Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43494 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2JEPqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 11:46:47 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so874053wib.1
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2012 08:46:45 -0700 (PDT)
From: Andrei Mandychev <andreymandychev@gmail.com>
To: hvaibhav@ti.com
Cc: archit@ti.com, tomi.valkeinen@ti.com, sumit.semwal@ti.com,
	linux-media@vger.kernel.org,
	Andrei Mandychev <andrei.mandychev@parrot.com>
Subject: [PATCH] Fixed list_del corruption in videobuf-core.c : videobuf_queue_cancel()
Date: Fri,  5 Oct 2012 17:44:25 +0200
Message-Id: <1349451865-26678-1-git-send-email-andrei.mandychev@parrot.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there is a buffer with VIDEOBUF_QUEUED state it won't be deleted properly
because the head of queue loses its elements by calling INIT_LIST_HEAD()
before videobuf_streamoff().
---
 drivers/media/video/omap/omap_vout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 409da0f..f02eb8e 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1738,8 +1738,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode in"
 				" streamoff\n");
 
-	INIT_LIST_HEAD(&vout->dma_queue);
 	ret = videobuf_streamoff(&vout->vbq);
+	INIT_LIST_HEAD(&vout->dma_queue);
 
 	return ret;
 }
-- 
1.7.9.5

