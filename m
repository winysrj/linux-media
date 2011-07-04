Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:54312 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab1GDPPP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 11:15:15 -0400
Date: Mon, 4 Jul 2011 17:15:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Bastian Hecht <hechtb@googlemail.com>
Subject: [PATCH] V4L: sh_mobile_ceu_camera: fix Oops when USERPTR mapping
 fails
Message-ID: <Pine.LNX.4.64.1107041713500.28687@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If vb2_dma_contig_get_userptr() fails on a videobuffer, driver's
.buf_init() method will not be called and the list will not be
initialised. Trying to remove an uninitialised element from a list leads
to a NULL-dereference.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3ae5c9c..a851a3e 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -421,8 +421,12 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 		pcdev->active = NULL;
 	}
 
-	/* Doesn't hurt also if the list is empty */
-	list_del_init(&buf->queue);
+	/*
+	 * Doesn't hurt also if the list is empty, but it hurts, if queuing the
+	 * buffer failed, and .buf_init() hasn't been called
+	 */
+	if (buf->queue.next)
+		list_del_init(&buf->queue);
 
 	spin_unlock_irq(&pcdev->lock);
 }
-- 
1.7.2.5
