Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26141 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab1FBKN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:13:26 -0400
Date: Thu, 02 Jun 2011 12:12:00 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/7] s5p-fimc: Fix data structures documentation and cleanup
 debug trace
In-reply-to: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307009524-1208-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Correct inconsistencies in data structures' documentation.
Remove meaningless debug traces.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    9 ---------
 drivers/media/video/s5p-fimc/fimc-core.c    |    6 ------
 drivers/media/video/s5p-fimc/fimc-core.h    |   25 ++++++++++++-------------
 3 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 7e66455..44fc26f 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -262,12 +262,7 @@ static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
 {
 	if (!fr || plane >= fr->fmt->memplanes)
 		return 0;
-
-	dbg("%s: w: %d. h: %d. depth[%d]: %d",
-	    __func__, fr->width, fr->height, plane, fr->fmt->depth[plane]);
-
 	return fr->f_width * fr->f_height * fr->fmt->depth[plane] / 8;
-
 }
 
 static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
@@ -283,12 +278,8 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
 
 	*num_planes = fmt->memplanes;
 
-	dbg("%s, buffer count=%d, plane count=%d",
-	    __func__, *num_buffers, *num_planes);
-
 	for (i = 0; i < fmt->memplanes; i++) {
 		sizes[i] = get_plane_size(&ctx->d_frame, i);
-		dbg("plane: %u, plane_size: %lu", i, sizes[i]);
 		allocators[i] = ctx->fimc_dev->alloc_ctx;
 	}
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index f1c7119..c427edd 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -231,11 +231,7 @@ static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
 			return 0;
 		}
 	}
-
 	*shift = 0, *ratio = 1;
-
-	dbg("s: %d, t: %d, shift: %d, ratio: %d",
-	    src, tar, *shift, *ratio);
 	return 0;
 }
 
@@ -267,10 +263,8 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 		err("invalid source size: %d x %d", sx, sy);
 		return -EINVAL;
 	}
-
 	sc->real_width = sx;
 	sc->real_height = sy;
-	dbg("sx= %d, sy= %d, tx= %d, ty= %d", sx, sy, tx, ty);
 
 	ret = fimc_get_scaler_factor(sx, tx, &sc->pre_hratio, &sc->hfactor);
 	if (ret)
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 3beb1e5..8f0f168 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -135,9 +135,10 @@ enum fimc_color_fmt {
  * @name: format description
  * @fourcc: the fourcc code for this format, 0 if not applicable
  * @color: the corresponding fimc_color_fmt
- * @depth: per plane driver's private 'number of bits per pixel'
  * @memplanes: number of physically non-contiguous data planes
  * @colplanes: number of physically contiguous data planes
+ * @depth: per plane driver's private 'number of bits per pixel'
+ * @flags: flags indicating which operation mode format applies to
  */
 struct fimc_fmt {
 	enum v4l2_mbus_pixelcode mbus_code;
@@ -171,7 +172,7 @@ struct fimc_dma_offset {
 };
 
 /**
- * struct fimc_effect - the configuration data for the "Arbitrary" image effect
+ * struct fimc_effect - color effect information
  * @type:	effect type
  * @pat_cb:	cr value when type is "arbitrary"
  * @pat_cr:	cr value when type is "arbitrary"
@@ -184,7 +185,6 @@ struct fimc_effect {
 
 /**
  * struct fimc_scaler - the configuration data for FIMC inetrnal scaler
- *
  * @scaleup_h:		flag indicating scaling up horizontally
  * @scaleup_v:		flag indicating scaling up vertically
  * @copy_mode:		flag indicating transparent DMA transfer (no scaling
@@ -220,7 +220,6 @@ struct fimc_scaler {
 
 /**
  * struct fimc_addr - the FIMC physical address set for DMA
- *
  * @y:	 luminance plane physical address
  * @cb:	 Cb plane physical address
  * @cr:	 Cr plane physical address
@@ -234,6 +233,7 @@ struct fimc_addr {
 /**
  * struct fimc_vid_buffer - the driver's video buffer
  * @vb:    v4l videobuf buffer
+ * @list:  linked list structure for buffer queue
  * @paddr: precalculated physical address set
  * @index: buffer index for the output DMA engine
  */
@@ -254,11 +254,10 @@ struct fimc_vid_buffer {
  * @offs_v:	image vertical pixel offset
  * @width:	image pixel width
  * @height:	image pixel weight
- * @paddr:	image frame buffer physical addresses
- * @buf_cnt:	number of buffers depending on a color format
  * @payload:	image size in bytes (w x h x bpp)
- * @color:	color format
+ * @paddr:	image frame buffer physical addresses
  * @dma_offset:	DMA offset in bytes
+ * @fmt:	fimc color format pointer
  */
 struct fimc_frame {
 	u32	f_width;
@@ -390,21 +389,22 @@ struct fimc_ctx;
 
 /**
  * struct fimc_dev - abstraction for FIMC entity
- *
  * @slock:	the spinlock protecting this data structure
  * @lock:	the mutex protecting this data structure
  * @pdev:	pointer to the FIMC platform device
  * @pdata:	pointer to the device platform data
+ * @variant:	the IP variant information
  * @id:		FIMC device index (0..FIMC_MAX_DEVS)
  * @num_clocks: the number of clocks managed by this device instance
- * @clock[]:	the clocks required for FIMC operation
+ * @clock:	clocks required for FIMC operation
  * @regs:	the mapped hardware registers
  * @regs_res:	the resource claimed for IO registers
- * @irq:	interrupt number of the FIMC subdevice
- * @irq_queue:
+ * @irq:	FIMC interrupt number
+ * @irq_queue:	interrupt handler waitqueue
  * @m2m:	memory-to-memory V4L2 device information
  * @vid_cap:	camera capture device information
  * @state:	flags used to synchronize m2m and capture mode operation
+ * @alloc_ctx:	videobuf2 memory allocator context
  */
 struct fimc_dev {
 	spinlock_t			slock;
@@ -427,8 +427,7 @@ struct fimc_dev {
 
 /**
  * fimc_ctx - the device context data
- *
- * @lock:		mutex protecting this data structure
+ * @slock:		spinlock protecting this data structure
  * @s_frame:		source frame properties
  * @d_frame:		destination frame properties
  * @out_order_1p:	output 1-plane YCBCR order
-- 
1.7.5.2

