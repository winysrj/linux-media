Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:55062 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab1FGOru (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 10:47:50 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p57EloHI013478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:50 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep35.itg.ti.com (8.13.7/8.13.8) with ESMTP id p57Elni9013419
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:49 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: <hvaibhav@ti.com>, <sumit.semwal@ti.com>, Amber Jain <amber@ti.com>
Subject: [PATCH 2/6] V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in qbuf and dqbuf
Date: Tue, 7 Jun 2011 20:17:34 +0530
Message-ID: <1307458058-29030-3-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-1-git-send-email-amber@ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support to map the buffer using dma_map_single during qbuf which inturn
calls cache flush and unmap the same during dqbuf. This is done to prevent
the artifacts seen because of cache-coherency issues on OMAP4

Signed-off-by: Amber Jain <amber@ti.com>
---
 drivers/media/video/omap/omap_vout.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 6fe7efa..435fe65 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -37,6 +37,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/videodev2.h>
+#include <linux/dma-mapping.h>
 
 #include <media/videobuf-dma-contig.h>
 #include <media/v4l2-device.h>
@@ -768,6 +769,17 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 		vout->queued_buf_addr[vb->i] = (u8 *)
 			omap_vout_uservirt_to_phys(vb->baddr);
 	} else {
+		int addr, dma_addr;
+		unsigned long size;
+
+		addr = (unsigned long) vout->buf_virt_addr[vb->i];
+		size = (unsigned long) vb->size;
+
+		dma_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void *) addr,
+				(unsigned) size, DMA_TO_DEVICE);
+		if (dma_mapping_error(vout->vid_dev->v4l2_dev.dev, dma_addr))
+			printk(KERN_ERR "dma_map_single failed\n");
+
 		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb->i];
 	}
 
@@ -1549,15 +1561,28 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	struct omap_vout_device *vout = fh;
 	struct videobuf_queue *q = &vout->vbq;
 
+	unsigned long size;
+	u32 addr;
+	struct videobuf_buffer *vb;
+	int ret;
+
+	vb = q->bufs[b->index];
+
 	if (!vout->streaming)
 		return -EINVAL;
 
 	if (file->f_flags & O_NONBLOCK)
 		/* Call videobuf_dqbuf for non blocking mode */
-		return videobuf_dqbuf(q, (struct v4l2_buffer *)b, 1);
+		ret = videobuf_dqbuf(q, (struct v4l2_buffer *)b, 1);
 	else
 		/* Call videobuf_dqbuf for  blocking mode */
-		return videobuf_dqbuf(q, (struct v4l2_buffer *)b, 0);
+		ret = videobuf_dqbuf(q, (struct v4l2_buffer *)b, 0);
+
+	addr = (unsigned long) vout->buf_phy_addr[vb->i];
+	size = (unsigned long) vb->size;
+	dma_unmap_single(vout->vid_dev->v4l2_dev.dev,  addr,
+				(unsigned) size, DMA_TO_DEVICE);
+	return ret;
 }
 
 static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
-- 
1.7.1

