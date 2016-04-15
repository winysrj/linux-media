Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:53114 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbcDONEJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 09:04:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Florian Echtler <floe@butterbrot.org>,
	Federico Vaga <federico.vaga@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Benoit Parrot <bparrot@ti.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv2 01/12] vb2: add a dev field to use for the default allocation context
Date: Fri, 15 Apr 2016 15:03:45 +0200
Message-Id: <1460725436-20045-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1460725436-20045-1-git-send-email-hverkuil@xs4all.nl>
References: <1460725436-20045-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The allocation context is nothing more than a per-plane device pointer
to use when allocating buffers. So just provide a dev pointer in vb2_queue
for that purpose and drivers can skip allocating/releasing/filling in
the allocation context unless they require different per-plane device
pointers as used by some Samsung SoCs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Florian Echtler <floe@butterbrot.org>
Cc: Federico Vaga <federico.vaga@gmail.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Fabien Dessenne <fabien.dessenne@st.com>
Cc: Benoit Parrot <bparrot@ti.com>
Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 16 +++++++++-------
 include/media/videobuf2-core.h           |  3 +++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5d016f4..88b5e48 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -206,8 +206,9 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
 
-		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, dma_dir, q->gfp_flags);
+		mem_priv = call_ptr_memop(vb, alloc,
+				q->alloc_ctx[plane] ? : &q->dev,
+				size, dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
@@ -1131,9 +1132,10 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 		vb->planes[plane].data_offset = 0;
 
 		/* Acquire each plane's memory */
-		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
-				      planes[plane].m.userptr,
-				      planes[plane].length, dma_dir);
+		mem_priv = call_ptr_memop(vb, get_userptr,
+				q->alloc_ctx[plane] ? : &q->dev,
+				planes[plane].m.userptr,
+				planes[plane].length, dma_dir);
 		if (IS_ERR_OR_NULL(mem_priv)) {
 			dprintk(1, "failed acquiring userspace "
 						"memory for plane %d\n", plane);
@@ -1256,8 +1258,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, attach_dmabuf,
-			q->alloc_ctx[plane], dbuf, planes[plane].length,
-			dma_dir);
+				q->alloc_ctx[plane] ? : &q->dev,
+				dbuf, planes[plane].length, dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed to attach dmabuf\n");
 			ret = PTR_ERR(mem_priv);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8a0f55b..0f8b97b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -397,6 +397,8 @@ struct vb2_buf_ops {
  *		caller. For example, for V4L2, it should match
  *		the V4L2_BUF_TYPE_* in include/uapi/linux/videodev2.h
  * @io_modes:	supported io methods (see vb2_io_modes enum)
+ * @dev:	device to use for the default allocation context if the driver
+ *		doesn't fill in the @alloc_ctx array.
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
@@ -460,6 +462,7 @@ struct vb2_buf_ops {
 struct vb2_queue {
 	unsigned int			type;
 	unsigned int			io_modes;
+	struct device			*dev;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
-- 
2.8.0.rc3

