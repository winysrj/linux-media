Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41629 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123AbbJPPJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 11:09:36 -0400
Message-ID: <562112B7.7090103@xs4all.nl>
Date: Fri, 16 Oct 2015 17:07:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Benoit Parrot <bparrot@ti.com>
CC: linux-media@vger.kernel.org
Subject: Re: [Patch v2 1/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture
 driver
References: <1442865848-19280-1-git-send-email-bparrot@ti.com> <1442865848-19280-2-git-send-email-bparrot@ti.com>
In-Reply-To: <1442865848-19280-2-git-send-email-bparrot@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2015 10:04 PM, Benoit Parrot wrote:
> The Camera Adaptation Layer (CAL) is a block which consists of a dual
> port CSI2/MIPI camera capture engine.
> Port #0 can handle CSI2 camera connected to up to 4 data lanes.
> Port #1 can handle CSI2 camera connected to up to 2 data lanes.
> The driver implements the required API/ioctls to be V4L2 compliant.
> Driver supports the following:
>     - V4L2 API using DMABUF/MMAP buffer access based on videobuf2 api
>     - Asynchronous sensor sub device registration
>     - DT support
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
>  drivers/media/platform/Kconfig           |   12 +
>  drivers/media/platform/Makefile          |    2 +
>  drivers/media/platform/ti-vpe/Makefile   |    4 +
>  drivers/media/platform/ti-vpe/cal.c      | 2161 ++++++++++++++++++++++++++++++
>  drivers/media/platform/ti-vpe/cal_regs.h |  779 +++++++++++
>  5 files changed, 2958 insertions(+)
>  create mode 100644 drivers/media/platform/ti-vpe/cal.c
>  create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index dc75694ac12d..c7f5704c56a2 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -120,6 +120,18 @@ source "drivers/media/platform/s5p-tv/Kconfig"
>  source "drivers/media/platform/am437x/Kconfig"
>  source "drivers/media/platform/xilinx/Kconfig"
>  
> +config VIDEO_TI_CAL
> +	tristate "TI CAL (Camera Adaptation Layer) driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && SOC_DRA7XX
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	depends on VIDEOBUF2_DMA_CONTIG

This should be:

       depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
       depends on SOC_DRA7XX || COMPILE_TEST
       select VIDEOBUF2_DMA_CONTIG

> +	default n
> +	---help---
> +	  Support for the TI CAL (Camera Adaptation Layer) block
> +	  found on DRA72X SoC.
> +	  In TI Technical Reference Manual this module is referred as
> +	  Camera Interface Subsystem (CAMSS).
> +
>  endif # V4L_PLATFORM_DRIVERS
>  
>  menuconfig V4L_MEM2MEM_DRIVERS

By compiling with COMPILE_TEST I found a number of compile warnings and it also no
longer compiled due to vb2 changes. Both are fixed in the patch below.

SoB for the patch: Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

That said, I'll postpone merging this until the remainder of the vb2 split patches
have been merged. When that's done this driver will have to be changed some more.

BTW, I see one 'f->fmt.pix.priv = 0;' line in cal_try_fmt_vid_cap(): this can be removed,
it's no longer needed.

Regards,

	Hans

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 2516756..4d4564d 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -200,7 +200,7 @@ static char *fourcc_to_str(u32 fmt)
 /* buffer for one video frame */
 struct cal_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	const struct cal_fmt	*fmt;
 };
@@ -400,8 +400,8 @@ static struct cm_data *cm_create(struct cal_dev *dev)
 		return cm->base;
 	}
 
-	cal_dbg(1, dev, "ioresource %s at  %x - %x\n",
-		cm->res->name, cm->res->start, cm->res->end);
+	cal_dbg(1, dev, "ioresource %s at %pa - %pa\n",
+		cm->res->name, &cm->res->start, &cm->res->end);
 
 	return cm;
 }
@@ -510,8 +510,8 @@ static struct cc_data *cc_create(struct cal_dev *dev, unsigned int core)
 		return cc->base;
 	}
 
-	cal_dbg(1, dev, "ioresource %s at  %x - %x\n",
-		cc->res->name, cc->res->start, cc->res->end);
+	cal_dbg(1, dev, "ioresource %s at %pa - %pa\n",
+		cc->res->name, &cc->res->start, &cc->res->end);
 
 	return cc;
 }
@@ -565,13 +565,13 @@ static void cal_top_reset(struct cal_dev *dev)
 
 static void cal_quickdump_regs(struct cal_dev *dev)
 {
-	cal_info(dev, "CAL Registers @ 0x%08x:\n", dev->res->start);
+	cal_info(dev, "CAL Registers @ 0x%pa:\n", &dev->res->start);
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
 		       dev->base, (dev->res->end - dev->res->start + 1), false);
 
 	if (!dev->ctx[0]) {
-		cal_info(dev, "CSI2 Core 0 Registers @ 0x%08x:\n",
-			 dev->ctx[0]->cc->res->start);
+		cal_info(dev, "CSI2 Core 0 Registers @ %pa:\n",
+			 &dev->ctx[0]->cc->res->start);
 		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
 			       dev->ctx[0]->cc->base,
 			       (dev->ctx[0]->cc->res->end -
@@ -580,8 +580,8 @@ static void cal_quickdump_regs(struct cal_dev *dev)
 	}
 
 	if (!dev->ctx[1]) {
-		cal_info(dev, "CSI2 Core 1 Registers @ 0x%08x:\n",
-			 dev->ctx[1]->cc->res->start);
+		cal_info(dev, "CSI2 Core 1 Registers @ %pa:\n",
+			 &dev->ctx[1]->cc->res->start);
 		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
 			       dev->ctx[1]->cc->base,
 			       (dev->ctx[1]->cc->res->end -
@@ -589,8 +589,8 @@ static void cal_quickdump_regs(struct cal_dev *dev)
 			       false);
 	}
 
-	cal_info(dev, "CAMERRX_Control Registers @ 0x%08x:\n",
-		 dev->cm->res->start);
+	cal_info(dev, "CAMERRX_Control Registers @ %pa:\n",
+		 &dev->cm->res->start);
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
 		       dev->cm->base,
 		       (dev->cm->res->end - dev->cm->res->start + 1), false);
@@ -995,17 +995,17 @@ static inline void cal_schedule_next_buffer(struct cal_ctx *ctx)
 	ctx->next_frm = buf;
 	list_del(&buf->list);
 
-	addr = vb2_dma_contig_plane_dma_addr(&buf->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
 	cal_wr_dma_addr(ctx, addr);
 }
 
 static inline void cal_process_buffer_complete(struct cal_ctx *ctx)
 {
-	v4l2_get_timestamp(&ctx->cur_frm->vb.v4l2_buf.timestamp);
-	ctx->cur_frm->vb.v4l2_buf.field = ctx->m_fmt.field;
-	ctx->cur_frm->vb.v4l2_buf.sequence = ctx->sequence++;
+	v4l2_get_timestamp(&ctx->cur_frm->vb.timestamp);
+	ctx->cur_frm->vb.field = ctx->m_fmt.field;
+	ctx->cur_frm->vb.sequence = ctx->sequence++;
 
-	vb2_buffer_done(&ctx->cur_frm->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&ctx->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	ctx->cur_frm = ctx->next_frm;
 }
 
@@ -1452,7 +1452,7 @@ static int cal_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int cal_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct cal_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct cal_buffer *buf = container_of(vb, struct cal_buffer, vb);
+	struct cal_buffer *buf = container_of(vb, struct cal_buffer, vb.vb2_buf);
 	unsigned long size;
 
 	BUG_ON(NULL == ctx->fmt);
@@ -1465,14 +1465,14 @@ static int cal_buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 	return 0;
 }
 
 static void cal_buffer_queue(struct vb2_buffer *vb)
 {
 	struct cal_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct cal_buffer *buf = container_of(vb, struct cal_buffer, vb);
+	struct cal_buffer *buf = container_of(vb, struct cal_buffer, vb.vb2_buf);
 	struct cal_dmaqueue *vidq = &ctx->vidq;
 	unsigned long flags = 0;
 
@@ -1506,7 +1506,7 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 	list_del(&buf->list);
 	spin_unlock_irqrestore(&ctx->slock, flags);
 
-	addr = vb2_dma_contig_plane_dma_addr(&ctx->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&ctx->cur_frm->vb.vb2_buf, 0);
 	ctx->sequence = 0;
 
 	ctx_dbg(3, ctx, "enable_irqs\n");
@@ -1543,7 +1543,7 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &dma_q->active, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	return ret;
 }
@@ -1572,14 +1572,14 @@ static void cal_stop_streaming(struct vb2_queue *vq)
 	spin_lock_irqsave(&ctx->slock, flags);
 	list_for_each_entry_safe(buf, tmp, &dma_q->active, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	if (ctx->cur_frm == ctx->next_frm) {
-		vb2_buffer_done(&ctx->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&ctx->cur_frm->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	} else {
-		vb2_buffer_done(&ctx->cur_frm->vb, VB2_BUF_STATE_ERROR);
-		vb2_buffer_done(&ctx->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&ctx->cur_frm->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&ctx->next_frm->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	ctx->cur_frm = NULL;
 	ctx->next_frm = NULL;
@@ -2063,8 +2063,8 @@ static int cal_probe(struct platform_device *pdev)
 	if (IS_ERR(dev->base))
 		return PTR_ERR(dev->base);
 
-	cal_dbg(1, dev, "ioresource %s at  %x - %x\n",
-		dev->res->name, dev->res->start, dev->res->end);
+	cal_dbg(1, dev, "ioresource %s at %pa - %pa\n",
+		dev->res->name, &dev->res->start, &dev->res->end);
 
 	irq = platform_get_irq(pdev, 0);
 	cal_dbg(1, dev, "got irq# %d\n", irq);

