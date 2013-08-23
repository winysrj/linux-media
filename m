Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48552 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3HWJpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:45:35 -0400
Date: Fri, 23 Aug 2013 12:45:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] mx3-camera: locking typo in mx3_videobuf_queue()
Message-ID: <20130823094530.GN31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a return in the middle where we haven't restored the IRQs to
their original state.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 1047e3e..4bae910 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -334,7 +334,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 	if (!mx3_cam->active)
 		mx3_cam->active = buf;
 
-	spin_unlock_irq(&mx3_cam->lock);
+	spin_unlock_irqrestore(&mx3_cam->lock, flags);
 
 	cookie = txd->tx_submit(txd);
 	dev_dbg(icd->parent, "Submitted cookie %d DMA 0x%08x\n",
@@ -343,7 +343,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 	if (cookie >= 0)
 		return;
 
-	spin_lock_irq(&mx3_cam->lock);
+	spin_lock_irqsave(&mx3_cam->lock, flags);
 
 	/* Submit error */
 	list_del_init(&buf->queue);
