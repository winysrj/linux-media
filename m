Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:41564 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbFWBdp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 21:33:45 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NQD0343AJ067EE0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Jun 2015 10:33:42 +0900 (KST)
Message-id: <5588B775.1080901@samsung.com>
Date: Tue, 23 Jun 2015 10:33:41 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, sangbae90.lee@samsung.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [RFC PATCH 2/3] make struct vb2_queue to common and apply the
 changes related with that.
References: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
 <1433770535-21143-3-git-send-email-jh1009.sung@samsung.com>
 <20150617101658.21bfbbb6@recife.lan>
In-reply-to: <20150617101658.21bfbbb6@recife.lan>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for your review.
I leave a reply to your comment at each lines.
I will rework all these patches to be easier to review.

Regards,
Junghak


On 06/17/2015 10:16 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 08 Jun 2015 22:35:34 +0900
> Junghak Sung <jh1009.sung@samsung.com> escreveu:
>
>> Abstract the v4l2-specific members of the struct vb2_queue,
>> and concrete it in the side of user.
>> For example, the struct vb2_v4l2_buffer can be abstracted by using
>> struct vb2_buffer, and concrete it by using container_of() in a device driver.
>>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> ---
>>   drivers/media/dvb-frontends/rtl2832_sdr.c          |   13 +-
>>   drivers/media/pci/cx23885/cx23885-417.c            |   23 +-
>>   drivers/media/pci/cx23885/cx23885-dvb.c            |   24 +-
>>   drivers/media/pci/cx23885/cx23885-vbi.c            |   27 +-
>>   drivers/media/pci/cx23885/cx23885-video.c          |   27 +-
>>   drivers/media/pci/cx25821/cx25821-video.c          |   28 +-
>>   drivers/media/pci/cx88/cx88-blackbird.c            |   25 +-
>>   drivers/media/pci/cx88/cx88-dvb.c                  |   25 +-
>>   drivers/media/pci/cx88/cx88-vbi.c                  |   27 +-
>>   drivers/media/pci/cx88/cx88-video.c                |   27 +-
>>   drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
>>   drivers/media/pci/saa7134/saa7134-ts.c             |   26 +-
>>   drivers/media/pci/saa7134/saa7134-vbi.c            |   22 +-
>>   drivers/media/pci/saa7134/saa7134-video.c          |   11 +-
>>   drivers/media/pci/saa7134/saa7134.h                |    2 +-
>>   drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   15 +-
>>   drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   11 +-
>>   drivers/media/pci/sta2x11/sta2x11_vip.c            |   32 +-
>>   drivers/media/pci/tw68/tw68-video.c                |   28 +-
>>   drivers/media/platform/am437x/am437x-vpfe.c        |   21 +-
>>   drivers/media/platform/blackfin/bfin_capture.c     |   32 +-
>>   drivers/media/platform/coda/coda-common.c          |   30 +-
>>   drivers/media/platform/davinci/vpbe_display.c      |   19 +-
>>   drivers/media/platform/davinci/vpif_capture.c      |   10 +-
>>   drivers/media/platform/davinci/vpif_display.c      |   10 +-
>>   drivers/media/platform/exynos-gsc/gsc-m2m.c        |   20 +-
>>   drivers/media/platform/exynos4-is/fimc-capture.c   |   25 +-
>>   drivers/media/platform/exynos4-is/fimc-isp-video.c |   29 +-
>>   drivers/media/platform/exynos4-is/fimc-lite.c      |   25 +-
>>   drivers/media/platform/exynos4-is/fimc-m2m.c       |   18 +-
>>   drivers/media/platform/m2m-deinterlace.c           |   24 +-
>>   drivers/media/platform/marvell-ccic/mcam-core.c    |   28 +-
>>   drivers/media/platform/mx2_emmaprp.c               |   24 +-
>>   drivers/media/platform/omap3isp/ispvideo.c         |   18 +-
>>   drivers/media/platform/s3c-camif/camif-capture.c   |   21 +-
>>   drivers/media/platform/s5p-g2d/g2d.c               |   18 +-
>>   drivers/media/platform/s5p-jpeg/jpeg-core.c        |   30 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   42 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   57 +-
>>   drivers/media/platform/s5p-tv/mixer_video.c        |    9 +-
>>   drivers/media/platform/sh_veu.c                    |   25 +-
>>   drivers/media/platform/soc_camera/atmel-isi.c      |   34 +-
>>   drivers/media/platform/soc_camera/mx2_camera.c     |   37 +-
>>   drivers/media/platform/soc_camera/mx3_camera.c     |   36 +-
>>   drivers/media/platform/soc_camera/rcar_vin.c       |   16 +-
>>   .../platform/soc_camera/sh_mobile_ceu_camera.c     |   49 +-
>>   drivers/media/platform/ti-vpe/vpe.c                |   32 +-
>>   drivers/media/platform/vim2m.c                     |   32 +-
>>   drivers/media/platform/vivid/vivid-sdr-cap.c       |   20 +-
>>   drivers/media/platform/vivid/vivid-vbi-cap.c       |   22 +-
>>   drivers/media/platform/vivid/vivid-vbi-out.c       |   22 +-
>>   drivers/media/platform/vivid/vivid-vid-cap.c       |   34 +-
>>   drivers/media/platform/vivid/vivid-vid-out.c       |   27 +-
>>   drivers/media/usb/airspy/airspy.c                  |    9 +-
>>   drivers/media/usb/au0828/au0828-vbi.c              |   25 +-
>>   drivers/media/usb/au0828/au0828-video.c            |   25 +-
>>   drivers/media/usb/em28xx/em28xx-vbi.c              |   23 +-
>>   drivers/media/usb/em28xx/em28xx-video.c            |   28 +-
>>   drivers/media/usb/go7007/go7007-v4l2.c             |   25 +-
>>   drivers/media/usb/hackrf/hackrf.c                  |    9 +-
>>   drivers/media/usb/msi2500/msi2500.c                |    9 +-
>>   drivers/media/usb/pwc/pwc-if.c                     |   30 +-
>>   drivers/media/usb/s2255/s2255drv.c                 |   18 +-
>>   drivers/media/usb/stk1160/stk1160-v4l.c            |   13 +-
>>   drivers/media/usb/usbtv/usbtv-video.c              |    9 +-
>>   drivers/media/usb/uvc/uvc_queue.c                  |   40 +-
>>   drivers/media/v4l2-core/Makefile                   |    2 +-
>>   drivers/media/v4l2-core/v4l2-mem2mem.c             |    6 +-
>>   drivers/media/v4l2-core/videobuf2-core.c           | 3488 +-------------------
>>   drivers/media/v4l2-core/videobuf2-v4l2.c           |  615 ++--
>>   include/media/videobuf2-core.h                     |  249 +-
>>   include/media/videobuf2-dma-contig.h               |    4 +-
>>   include/media/videobuf2-v4l2.h                     |  440 +--
>>   73 files changed, 1227 insertions(+), 5131 deletions(-)
> (driver changes removed - those are consequences of the core changes.
>   Again, a script is the best way to do those driver changes, as it can
>   be easily reviewed and will be needed anyway when applying the changes, as
>   drivers may change or added while this changeset is not merged).
>
>>   static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
>> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
>> index bd9a6ef..15789e9 100644
>> --- a/drivers/media/v4l2-core/Makefile
>> +++ b/drivers/media/v4l2-core/Makefile
>> @@ -28,7 +28,7 @@ obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
>>   obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
>>   obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
>>   
>> -obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-v4l2.o
>> +obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o videobuf2-v4l2.o
>>   obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
>>   obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
>>   obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
>> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> index 3392a58..bce2560 100644
>> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
>> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> @@ -739,13 +739,13 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
>>    *
>>    * Call from buf_queue(), videobuf_queue_ops callback.
>>    */
>> -void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_v4l2_buffer *vb)
>> +void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_v4l2_buffer *cb)
> Why are you renaming it to "cb"? IMHO, we should standardize the namespace
> for those. On the past patch, you were using vb2 and vb.
>
> In any case, this namespace rename could happen on a separate patch, IMHO.
> This one is already big enough without namespace renaming.
The "cb" means "container buffer". I was very confused because the 
struct vb2_buffer uses
"vb" or "vb2" and the struct vb2_v4l2_buffer also uses same name. So, I 
replace it to "cb"
for struct vb2_v4l2_buffer. Is there any idea to remove this confusion?
>>   {
>> -	struct v4l2_m2m_buffer *b = container_of(vb, struct v4l2_m2m_buffer, vb);
>> +	struct v4l2_m2m_buffer *b = container_of(cb, struct v4l2_m2m_buffer, vb);
>>   	struct v4l2_m2m_queue_ctx *q_ctx;
>>   	unsigned long flags;
>>   
>> -	q_ctx = get_queue_ctx(m2m_ctx, vb->vb2.vb2_queue->type);
>> +	q_ctx = get_queue_ctx(m2m_ctx, cb->vb2.vb2_queue->type);
>>   	if (!q_ctx)
>>   		return;
>>   
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 0d8bd9a..5f75937 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1,5 +1,5 @@
>>   /*
>> - * videobuf2-core.c - V4L2 driver helper framework
>> + * videobuf2-core.c - Video Buffer 2 framework
>>    *
>>    * Copyright (C) 2010 Samsung Electronics
>>    *
>> @@ -28,3492 +28,8 @@
>>   #include <media/v4l2-fh.h>
>>   #include <media/v4l2-event.h>
>>   #include <media/v4l2-common.h>
>> -#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-v4l2.h>
>> -static int debug;
> ... (lots of lines removed here
>> -EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
>>   
>>   MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
>>   MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
> Hmm... was most of this file just removed and just the above was
> preserved? This enforces the idea of just renaming it on the
> previous patch (as proposed on patches 0/3 and 1/3) and then
> creating a new one with the new content, moving out the functions
> added here from videobuf2-v4l2.c.
OK, I will rework for that.
>> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> index cd28b4807f..fe07a2b 100644
>> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
>> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> @@ -51,12 +51,12 @@ module_param(debug, int, 0644);
>>   
>>   #define log_memop(vb, op)						\
>>   	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
>> -		(vb)->vb2.vb2_queue, (vb)->v4l2_buf.index, #op,		\
>> -		(vb)->vb2.vb2_queue->mem_ops->op ? "" : " (nop)")
>> +		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
>> +		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
>>   
>>   #define call_memop(vb, op, args...)					\
>>   ({									\
>> -	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
>> +	struct vb2_queue *_q = (vb)->vb2_queue;				\
>>   	int err;							\
>>   									\
>>   	log_memop(vb, op);						\
>> @@ -68,7 +68,7 @@ module_param(debug, int, 0644);
>>   
>>   #define call_ptr_memop(vb, op, args...)					\
>>   ({									\
>> -	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
>> +	struct vb2_queue *_q = (vb)->vb2_queue;				\
>>   	void *ptr;							\
>>   									\
>>   	log_memop(vb, op);						\
>> @@ -80,7 +80,7 @@ module_param(debug, int, 0644);
>>   
>>   #define call_void_memop(vb, op, args...)				\
>>   ({									\
>> -	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
>> +	struct vb2_queue *_q = (vb)->vb2_queue;				\
>>   									\
>>   	log_memop(vb, op);						\
>>   	if (_q->mem_ops->op)						\
>> @@ -113,16 +113,16 @@ module_param(debug, int, 0644);
>>   
>>   #define log_vb_qop(vb, op, args...)					\
>>   	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
>> -		(vb)->vb2.vb2_queue, (vb)->v4l2_buf.index, #op,		\
>> -		(vb)->vb2.vb2_queue->ops->op ? "" : " (nop)")
>> +		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
>> +		(vb)->vb2_queue->ops->op ? "" : " (nop)")
>>   
>>   #define call_vb_qop(vb, op, args...)					\
>>   ({									\
>>   	int err;							\
>>   									\
>>   	log_vb_qop(vb, op);						\
>> -	err = (vb)->vb2.vb2_queue->ops->op ?				\
>> -		(vb)->vb2.vb2_queue->ops->op(args) : 0;			\
>> +	err = (vb)->vb2_queue->ops->op ?				\
>> +		(vb)->vb2_queue->ops->op(args) : 0;			\
>>   	if (!err)							\
>>   		(vb)->cnt_ ## op++;					\
>>   	err;								\
>> @@ -131,25 +131,25 @@ module_param(debug, int, 0644);
>>   #define call_void_vb_qop(vb, op, args...)				\
>>   ({									\
>>   	log_vb_qop(vb, op);						\
>> -	if ((vb)->vb2.vb2_queue->ops->op)					\
>> -		(vb)->vb2.vb2_queue->ops->op(args);				\
>> +	if ((vb)->vb2_queue->ops->op)					\
>> +		(vb)->vb2_queue->ops->op(args);				\
>>   	(vb)->cnt_ ## op++;						\
>>   })
>>   
>>   #else
>>   
>>   #define call_memop(vb, op, args...)					\
>> -	((vb)->vb2.vb2_queue->mem_ops->op ?					\
>> -		(vb)->vb2.vb2_queue->mem_ops->op(args) : 0)
>> +	((vb)->vb2_queue->mem_ops->op ?					\
>> +		(vb)->vb2_queue->mem_ops->op(args) : 0)
>>   
>>   #define call_ptr_memop(vb, op, args...)					\
>> -	((vb)->vb2.vb2_queue->mem_ops->op ?					\
>> -		(vb)->vb2.vb2_queue->mem_ops->op(args) : NULL)
>> +	((vb)->vb2_queue->mem_ops->op ?					\
>> +		(vb)->vb2_queue->mem_ops->op(args) : NULL)
>>   
>>   #define call_void_memop(vb, op, args...)				\
>>   	do {								\
>> -		if ((vb)->vb2.vb2_queue->mem_ops->op)			\
>> -			(vb)->vb2.vb2_queue->mem_ops->op(args);		\
>> +		if ((vb)->vb2_queue->mem_ops->op)			\
>> +			(vb)->vb2_queue->mem_ops->op(args);		\
>>   	} while (0)
>>   
>>   #define call_qop(q, op, args...)					\
>> @@ -162,12 +162,12 @@ module_param(debug, int, 0644);
>>   	} while (0)
>>   
>>   #define call_vb_qop(vb, op, args...)					\
>> -	((vb)->vb2.vb2_queue->ops->op ? (vb)->vb2.vb2_queue->ops->op(args) : 0)
>> +	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
>>   
>>   #define call_void_vb_qop(vb, op, args...)				\
>>   	do {								\
>> -		if ((vb)->vb2.vb2_queue->ops->op)				\
>> -			(vb)->vb2.vb2_queue->ops->op(args);			\
>> +		if ((vb)->vb2_queue->ops->op)				\
>> +			(vb)->vb2_queue->ops->op(args);			\
>>   	} while (0)
>>   
>>   #endif
>> @@ -186,9 +186,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
>>   /**
>>    * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
>>    */
>> -static int __vb2_buf_mem_alloc(struct vb2_v4l2_buffer *vb)
>> +static int __vb2_buf_mem_alloc(struct vb2_v4l2_buffer *cb)
> Why are you called the v4l2 buffer as "cb"? At least for me, "cb" would
> be an alias "common buffer". So, I would be expecting just the reverse ;)
'cb' means 'container buffer'. When vb2_buffer and vb2_v4l2_buffer are 
used together,
I needed new naming rule. So I used 'cb' to refer struct vb2_v4l2_buffer.
But, I will rework this patch.
Let me know if you have more efficient way to do naming these two structure.

>>   {
>> -	struct vb2_queue *q = vb->vb2.vb2_queue;
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +	struct vb2_queue *q = vb->vb2_queue;
>>   	enum dma_data_direction dma_dir =
>>   		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>>   	void *mem_priv;
>> @@ -198,7 +199,7 @@ static int __vb2_buf_mem_alloc(struct vb2_v4l2_buffer *vb)
>>   	 * Allocate memory for all planes in this buffer
>>   	 * NOTE: mmapped areas should be page aligned
>>   	 */
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> +	for (plane = 0; plane < vb->num_planes; ++plane) {
>>   		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
>>   
>>   		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
>> @@ -207,16 +208,16 @@ static int __vb2_buf_mem_alloc(struct vb2_v4l2_buffer *vb)
>>   			goto free;
>>   
>>   		/* Associate allocator private data with this plane */
>> -		vb->vb2.planes[plane].mem_priv = mem_priv;
>> -		vb->v4l2_planes[plane].length = q->plane_sizes[plane];
>> +		vb->planes[plane].mem_priv = mem_priv;
>> +		cb->v4l2_planes[plane].length = q->plane_sizes[plane];
>>   	}
>>   
>>   	return 0;
>>   free:
>>   	/* Free already allocated memory if one of the allocations failed */
>>   	for (; plane > 0; --plane) {
>> -		call_void_memop(vb, put, vb->vb2.planes[plane - 1].mem_priv);
>> -		vb->vb2.planes[plane - 1].mem_priv = NULL;
>> +		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
>> +		vb->planes[plane - 1].mem_priv = NULL;
>>   	}
>>   
>>   	return -ENOMEM;
>> @@ -225,15 +226,16 @@ free:
>>   /**
>>    * __vb2_buf_mem_free() - free memory of the given buffer
>>    */
>> -static void __vb2_buf_mem_free(struct vb2_v4l2_buffer *vb)
>> +static void __vb2_buf_mem_free(struct vb2_v4l2_buffer *cb)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	unsigned int plane;
>>   
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> -		call_void_memop(vb, put, vb->vb2.planes[plane].mem_priv);
>> -		vb->vb2.planes[plane].mem_priv = NULL;
>> +	for (plane = 0; plane < vb->num_planes; ++plane) {
>> +		call_void_memop(vb, put, vb->planes[plane].mem_priv);
>> +		vb->planes[plane].mem_priv = NULL;
>>   		dprintk(3, "freed plane %d of buffer %d\n", plane,
>> -			vb->v4l2_buf.index);
>> +			cb->v4l2_buf.index);
>>   	}
>>   }
>>   
>> @@ -241,14 +243,15 @@ static void __vb2_buf_mem_free(struct vb2_v4l2_buffer *vb)
>>    * __vb2_buf_userptr_put() - release userspace memory associated with
>>    * a USERPTR buffer
>>    */
>> -static void __vb2_buf_userptr_put(struct vb2_v4l2_buffer *vb)
>> +static void __vb2_buf_userptr_put(struct vb2_v4l2_buffer *cb)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	unsigned int plane;
>>   
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> -		if (vb->vb2.planes[plane].mem_priv)
>> -			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
>> -		vb->vb2.planes[plane].mem_priv = NULL;
>> +	for (plane = 0; plane < vb->num_planes; ++plane) {
>> +		if (vb->planes[plane].mem_priv)
>> +			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
>> +		vb->planes[plane].mem_priv = NULL;
>>   	}
>>   }
>>   
>> @@ -256,8 +259,9 @@ static void __vb2_buf_userptr_put(struct vb2_v4l2_buffer *vb)
>>    * __vb2_plane_dmabuf_put() - release memory associated with
>>    * a DMABUF shared plane
>>    */
>> -static void __vb2_plane_dmabuf_put(struct vb2_v4l2_buffer *vb, struct vb2_plane *p)
>> +static void __vb2_plane_dmabuf_put(struct vb2_v4l2_buffer *cb, struct vb2_plane *p)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	if (!p->mem_priv)
>>   		return;
>>   
>> @@ -273,12 +277,13 @@ static void __vb2_plane_dmabuf_put(struct vb2_v4l2_buffer *vb, struct vb2_plane
>>    * __vb2_buf_dmabuf_put() - release memory associated with
>>    * a DMABUF shared buffer
>>    */
>> -static void __vb2_buf_dmabuf_put(struct vb2_v4l2_buffer *vb)
>> +static void __vb2_buf_dmabuf_put(struct vb2_v4l2_buffer *cb)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	unsigned int plane;
>>   
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
>> -		__vb2_plane_dmabuf_put(vb, &vb->vb2.planes[plane]);
>> +	for (plane = 0; plane < vb->num_planes; ++plane)
>> +		__vb2_plane_dmabuf_put(cb, &vb->planes[plane]);
>>   }
>>   
>>   /**
>> @@ -288,15 +293,17 @@ static void __vb2_buf_dmabuf_put(struct vb2_v4l2_buffer *vb)
>>   static void __setup_lengths(struct vb2_queue *q, unsigned int n)
>>   {
>>   	unsigned int buffer, plane;
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   
>>   	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
>>   		vb = q->bufs[buffer];
>>   		if (!vb)
>>   			continue;
>>   
>> -		for (plane = 0; plane < vb->vb2.num_planes; ++plane)
>> -			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
>> +		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>> +		for (plane = 0; plane < vb->num_planes; ++plane)
>> +			cb->v4l2_planes[plane].length = q->plane_sizes[plane];
>>   	}
>>   }
>>   
>> @@ -307,13 +314,15 @@ static void __setup_lengths(struct vb2_queue *q, unsigned int n)
>>   static void __setup_offsets(struct vb2_queue *q, unsigned int n)
>>   {
>>   	unsigned int buffer, plane;
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   	unsigned long off;
>>   
>>   	if (q->num_buffers) {
>>   		struct v4l2_plane *p;
>>   		vb = q->bufs[q->num_buffers - 1];
>> -		p = &vb->v4l2_planes[vb->vb2.num_planes - 1];
>> +		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>> +		p = &cb->v4l2_planes[vb->num_planes - 1];
>>   		off = PAGE_ALIGN(p->m.mem_offset + p->length);
>>   	} else {
>>   		off = 0;
>> @@ -324,13 +333,14 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
>>   		if (!vb)
>>   			continue;
>>   
>> -		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> -			vb->v4l2_planes[plane].m.mem_offset = off;
>> +		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>> +		for (plane = 0; plane < vb->num_planes; ++plane) {
>> +			cb->v4l2_planes[plane].m.mem_offset = off;
>>   
>>   			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
>>   					buffer, plane, off);
>>   
>> -			off += vb->v4l2_planes[plane].length;
>> +			off += cb->v4l2_planes[plane].length;
>>   			off = PAGE_ALIGN(off);
>>   		}
>>   	}
>> @@ -347,35 +357,37 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
>>   			     unsigned int num_buffers, unsigned int num_planes)
>>   {
>>   	unsigned int buffer;
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   	int ret;
>>   
>>   	for (buffer = 0; buffer < num_buffers; ++buffer) {
>>   		/* Allocate videobuf buffer structures */
>> -		vb = kzalloc(q->buf_struct_size, GFP_KERNEL);
>> -		if (!vb) {
>> +		cb = kzalloc(q->buf_struct_size, GFP_KERNEL);
>> +		if (!cb) {
>>   			dprintk(1, "memory alloc for buffer struct failed\n");
>>   			break;
>>   		}
>>   
>> +		vb = &cb->vb2;
>>   		/* Length stores number of planes for multiplanar buffers */
>>   		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
>> -			vb->v4l2_buf.length = num_planes;
>> +			cb->v4l2_buf.length = num_planes;
>>   
>> -		vb->vb2.state = VB2_BUF_STATE_DEQUEUED;
>> -		vb->vb2.vb2_queue = q;
>> -		vb->vb2.num_planes = num_planes;
>> -		vb->v4l2_buf.index = q->num_buffers + buffer;
>> -		vb->v4l2_buf.type = q->type;
>> -		vb->v4l2_buf.memory = memory;
>> +		vb->state = VB2_BUF_STATE_DEQUEUED;
>> +		vb->vb2_queue = q;
>> +		vb->num_planes = num_planes;
>> +		cb->v4l2_buf.index = q->num_buffers + buffer;
>> +		cb->v4l2_buf.type = q->type;
>> +		cb->v4l2_buf.memory = memory;
>>   
>>   		/* Allocate video buffer memory for the MMAP type */
>>   		if (memory == V4L2_MEMORY_MMAP) {
>> -			ret = __vb2_buf_mem_alloc(vb);
>> +			ret = __vb2_buf_mem_alloc(cb);
>>   			if (ret) {
>>   				dprintk(1, "failed allocating memory for "
>>   						"buffer %d\n", buffer);
>> -				kfree(vb);
>> +				kfree(cb);
>>   				break;
>>   			}
>>   			/*
>> @@ -387,8 +399,8 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
>>   			if (ret) {
>>   				dprintk(1, "buffer %d %p initialization"
>>   					" failed\n", buffer, vb);
>> -				__vb2_buf_mem_free(vb);
>> -				kfree(vb);
>> +				__vb2_buf_mem_free(cb);
>> +				kfree(cb);
>>   				break;
>>   			}
>>   		}
>> @@ -412,21 +424,23 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
>>   static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
>>   {
>>   	unsigned int buffer;
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   
>>   	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>>   	     ++buffer) {
>>   		vb = q->bufs[buffer];
>>   		if (!vb)
>>   			continue;
>> +		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   
>>   		/* Free MMAP buffers or release USERPTR buffers */
>>   		if (q->memory == V4L2_MEMORY_MMAP)
>> -			__vb2_buf_mem_free(vb);
>> +			__vb2_buf_mem_free(cb);
>>   		else if (q->memory == V4L2_MEMORY_DMABUF)
>> -			__vb2_buf_dmabuf_put(vb);
>> +			__vb2_buf_dmabuf_put(cb);
>>   		else
>> -			__vb2_buf_userptr_put(vb);
>> +			__vb2_buf_userptr_put(cb);
>>   	}
>>   }
>>   
>> @@ -438,7 +452,7 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
>>   static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>>   {
>>   	unsigned int buffer;
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_buffer *vb;
>>   
>>   	/*
>>   	 * Sanity check: when preparing a buffer the queue lock is released for
>> @@ -450,11 +464,11 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>>   	 */
>>   	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>>   	     ++buffer) {
>> -		vb = (struct vb2_v4l2_buffer *)q->bufs[buffer];
>> +		vb = q->bufs[buffer];
>>   
>>   		if (vb == NULL)
>>   			continue;
>> -		if (vb->vb2.state == VB2_BUF_STATE_PREPARING) {
>> +		if (vb->state == VB2_BUF_STATE_PREPARING) {
>>   			dprintk(1, "preparing buffers, cannot free\n");
>>   			return -EAGAIN;
>>   		}
>> @@ -463,9 +477,9 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>>   	/* Call driver-provided cleanup function for each buffer, if provided */
>>   	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>>   	     ++buffer) {
>> -		vb = (struct vb2_v4l2_buffer *)q->bufs[buffer];
>> +		vb = q->bufs[buffer];
>>   
>> -		if (vb && vb->vb2.planes[0].mem_priv)
>> +		if (vb && vb->planes[0].mem_priv)
>>   			call_void_vb_qop(vb, buf_cleanup, vb);
>>   	}
>>   
>> @@ -498,38 +512,38 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>>   		q->cnt_stop_streaming = 0;
>>   	}
>>   	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
>> -		struct vb2_v4l2_buffer *vb = q->bufs[buffer];
>> -		bool unbalanced = vb->vb2.cnt_mem_alloc != vb->vb2.cnt_mem_put ||
>> -				  vb->vb2.cnt_mem_prepare != vb->vb2.cnt_mem_finish ||
>> -				  vb->vb2.cnt_mem_get_userptr != vb->vb2.cnt_mem_put_userptr ||
>> -				  vb->vb2.cnt_mem_attach_dmabuf != vb->vb2.cnt_mem_detach_dmabuf ||
>> -				  vb->vb2.cnt_mem_map_dmabuf != vb->vb2.cnt_mem_unmap_dmabuf ||
>> -				  vb->vb2.cnt_buf_queue != vb->vb2.cnt_buf_done ||
>> -				  vb->vb2.cnt_buf_prepare != vb->vb2.cnt_buf_finish ||
>> -				  vb->vb2.cnt_buf_init != vb->vb2.cnt_buf_cleanup;
>> +		struct vb2_buffer *vb = q->bufs[buffer];
>> +		bool unbalanced = vb->cnt_mem_alloc != vb->cnt_mem_put ||
>> +				  vb->cnt_mem_prepare != vb->cnt_mem_finish ||
>> +				  vb->cnt_mem_get_userptr != vb->cnt_mem_put_userptr ||
>> +				  vb->cnt_mem_attach_dmabuf != vb->cnt_mem_detach_dmabuf ||
>> +				  vb->cnt_mem_map_dmabuf != vb->cnt_mem_unmap_dmabuf ||
>> +				  vb->cnt_buf_queue != vb->cnt_buf_done ||
>> +				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
>> +				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
>>   
>>   		if (unbalanced || debug) {
>>   			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
>>   				q, buffer, unbalanced ? " UNBALANCED!" : "");
>>   			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
>> -				vb->vb2.cnt_buf_init, vb->vb2.cnt_buf_cleanup,
>> -				vb->vb2.cnt_buf_prepare, vb->vb2.cnt_buf_finish);
>> +				vb->cnt_buf_init, vb->cnt_buf_cleanup,
>> +				vb->cnt_buf_prepare, vb->cnt_buf_finish);
>>   			pr_info("vb2:     buf_queue: %u buf_done: %u\n",
>> -				vb->vb2.cnt_buf_queue, vb->vb2.cnt_buf_done);
>> +				vb->cnt_buf_queue, vb->cnt_buf_done);
>>   			pr_info("vb2:     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
>> -				vb->vb2.cnt_mem_alloc, vb->vb2.cnt_mem_put,
>> -				vb->vb2.cnt_mem_prepare, vb->vb2.cnt_mem_finish,
>> -				vb->vb2.cnt_mem_mmap);
>> +				vb->cnt_mem_alloc, vb->cnt_mem_put,
>> +				vb->cnt_mem_prepare, vb->cnt_mem_finish,
>> +				vb->cnt_mem_mmap);
>>   			pr_info("vb2:     get_userptr: %u put_userptr: %u\n",
>> -				vb->vb2.cnt_mem_get_userptr, vb->vb2.cnt_mem_put_userptr);
>> +				vb->cnt_mem_get_userptr, vb->cnt_mem_put_userptr);
>>   			pr_info("vb2:     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
>> -				vb->vb2.cnt_mem_attach_dmabuf, vb->vb2.cnt_mem_detach_dmabuf,
>> -				vb->vb2.cnt_mem_map_dmabuf, vb->vb2.cnt_mem_unmap_dmabuf);
>> +				vb->cnt_mem_attach_dmabuf, vb->cnt_mem_detach_dmabuf,
>> +				vb->cnt_mem_map_dmabuf, vb->cnt_mem_unmap_dmabuf);
>>   			pr_info("vb2:     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
>> -				vb->vb2.cnt_mem_get_dmabuf,
>> -				vb->vb2.cnt_mem_num_users,
>> -				vb->vb2.cnt_mem_vaddr,
>> -				vb->vb2.cnt_mem_cookie);
>> +				vb->cnt_mem_get_dmabuf,
>> +				vb->cnt_mem_num_users,
>> +				vb->cnt_mem_vaddr,
>> +				vb->cnt_mem_cookie);
>>   		}
>>   	}
>>   #endif
>> @@ -553,8 +567,10 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>>    * __verify_planes_array() - verify that the planes array passed in struct
>>    * v4l2_buffer from userspace can be safely used
>>    */
>> -static int __verify_planes_array(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
>> +static int __verify_planes_array(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +
>>   	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
>>   		return 0;
>>   
>> @@ -565,9 +581,9 @@ static int __verify_planes_array(struct vb2_v4l2_buffer *vb, const struct v4l2_b
>>   		return -EINVAL;
>>   	}
>>   
>> -	if (b->length < vb->vb2.num_planes || b->length > VIDEO_MAX_PLANES) {
>> +	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
>>   		dprintk(1, "incorrect planes array length, "
>> -			   "expected %d, got %d\n", vb->vb2.num_planes, b->length);
>> +			   "expected %d, got %d\n", vb->num_planes, b->length);
>>   		return -EINVAL;
>>   	}
>>   
>> @@ -578,8 +594,9 @@ static int __verify_planes_array(struct vb2_v4l2_buffer *vb, const struct v4l2_b
>>    * __verify_length() - Verify that the bytesused value for each plane fits in
>>    * the plane length and that the data offset doesn't exceed the bytesused value.
>>    */
>> -static int __verify_length(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
>> +static int __verify_length(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	unsigned int length;
>>   	unsigned int bytesused;
>>   	unsigned int plane;
>> @@ -588,11 +605,11 @@ static int __verify_length(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer
>>   		return 0;
>>   
>>   	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
>> -		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> +		for (plane = 0; plane < vb->num_planes; ++plane) {
>>   			length = (b->memory == V4L2_MEMORY_USERPTR ||
>>   				  b->memory == V4L2_MEMORY_DMABUF)
>>   			       ? b->m.planes[plane].length
>> -			       : vb->v4l2_planes[plane].length;
>> +			       : cb->v4l2_planes[plane].length;
>>   			bytesused = b->m.planes[plane].bytesused
>>   				  ? b->m.planes[plane].bytesused : length;
>>   
>> @@ -605,7 +622,7 @@ static int __verify_length(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer
>>   		}
>>   	} else {
>>   		length = (b->memory == V4L2_MEMORY_USERPTR)
>> -		       ? b->length : vb->v4l2_planes[0].length;
>> +		       ? b->length : cb->v4l2_planes[0].length;
>>   		bytesused = b->bytesused ? b->bytesused : length;
>>   
>>   		if (b->bytesused > length)
>> @@ -619,11 +636,12 @@ static int __verify_length(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer
>>    * __buffer_in_use() - return true if the buffer is in use and
>>    * the queue cannot be freed (by the means of REQBUFS(0)) call
>>    */
>> -static bool __buffer_in_use(struct vb2_queue *q, struct vb2_v4l2_buffer *vb)
>> +static bool __buffer_in_use(struct vb2_queue *q, struct vb2_v4l2_buffer *cb)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	unsigned int plane;
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> -		void *mem_priv = vb->vb2.planes[plane].mem_priv;
>> +	for (plane = 0; plane < vb->num_planes; ++plane) {
>> +		void *mem_priv = vb->planes[plane].mem_priv;
>>   		/*
>>   		 * If num_users() has not been provided, call_memop
>>   		 * will return 0, apparently nobody cares about this
>> @@ -642,9 +660,12 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_v4l2_buffer *vb)
>>    */
>>   static bool __buffers_in_use(struct vb2_queue *q)
>>   {
>> +	struct vb2_v4l2_buffer *cb;
>>   	unsigned int buffer;
>> +
>>   	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
>> -		if (__buffer_in_use(q, q->bufs[buffer]))
>> +		cb = container_of(q->bufs[buffer], struct vb2_v4l2_buffer, vb2);
>> +		if (__buffer_in_use(q, cb))
>>   			return true;
>>   	}
>>   	return false;
>> @@ -654,36 +675,37 @@ static bool __buffers_in_use(struct vb2_queue *q)
>>    * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
>>    * returned to userspace
>>    */
>> -static void __fill_v4l2_buffer(struct vb2_v4l2_buffer *vb, struct v4l2_buffer *b)
>> +static void __fill_v4l2_buffer(struct vb2_v4l2_buffer *cb, struct v4l2_buffer *b)
>>   {
>> -	struct vb2_queue *q = vb->vb2.vb2_queue;
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +	struct vb2_queue *q = vb->vb2_queue;
>>   
>>   	/* Copy back data such as timestamp, flags, etc. */
>> -	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
>> -	b->reserved2 = vb->v4l2_buf.reserved2;
>> -	b->reserved = vb->v4l2_buf.reserved;
>> +	memcpy(b, &cb->v4l2_buf, offsetof(struct v4l2_buffer, m));
>> +	b->reserved2 = cb->v4l2_buf.reserved2;
>> +	b->reserved = cb->v4l2_buf.reserved;
>>   
>>   	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
>>   		/*
>>   		 * Fill in plane-related data if userspace provided an array
>>   		 * for it. The caller has already verified memory and size.
>>   		 */
>> -		b->length = vb->vb2.num_planes;
>> -		memcpy(b->m.planes, vb->v4l2_planes,
>> +		b->length = vb->num_planes;
>> +		memcpy(b->m.planes, cb->v4l2_planes,
>>   			b->length * sizeof(struct v4l2_plane));
>>   	} else {
>>   		/*
>>   		 * We use length and offset in v4l2_planes array even for
>>   		 * single-planar buffers, but userspace does not.
>>   		 */
>> -		b->length = vb->v4l2_planes[0].length;
>> -		b->bytesused = vb->v4l2_planes[0].bytesused;
>> +		b->length = cb->v4l2_planes[0].length;
>> +		b->bytesused = cb->v4l2_planes[0].bytesused;
>>   		if (q->memory == V4L2_MEMORY_MMAP)
>> -			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
>> +			b->m.offset = cb->v4l2_planes[0].m.mem_offset;
>>   		else if (q->memory == V4L2_MEMORY_USERPTR)
>> -			b->m.userptr = vb->v4l2_planes[0].m.userptr;
>> +			b->m.userptr = cb->v4l2_planes[0].m.userptr;
>>   		else if (q->memory == V4L2_MEMORY_DMABUF)
>> -			b->m.fd = vb->v4l2_planes[0].m.fd;
>> +			b->m.fd = cb->v4l2_planes[0].m.fd;
>>   	}
>>   
>>   	/*
>> @@ -701,7 +723,7 @@ static void __fill_v4l2_buffer(struct vb2_v4l2_buffer *vb, struct v4l2_buffer *b
>>   		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>>   	}
>>   
>> -	switch (vb->vb2.state) {
>> +	switch (vb->state) {
>>   	case VB2_BUF_STATE_QUEUED:
>>   	case VB2_BUF_STATE_ACTIVE:
>>   		b->flags |= V4L2_BUF_FLAG_QUEUED;
>> @@ -721,7 +743,7 @@ static void __fill_v4l2_buffer(struct vb2_v4l2_buffer *vb, struct v4l2_buffer *b
>>   		break;
>>   	}
>>   
>> -	if (__buffer_in_use(q, vb))
>> +	if (__buffer_in_use(q, cb))
>>   		b->flags |= V4L2_BUF_FLAG_MAPPED;
>>   }
>>   
>> @@ -740,7 +762,8 @@ static void __fill_v4l2_buffer(struct vb2_v4l2_buffer *vb, struct v4l2_buffer *b
>>    */
>>   int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   {
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   	int ret;
>>   
>>   	if (b->type != q->type) {
>> @@ -753,9 +776,10 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   		return -EINVAL;
>>   	}
>>   	vb = q->bufs[b->index];
>> -	ret = __verify_planes_array(vb, b);
>> +	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>> +	ret = __verify_planes_array(cb, b);
>>   	if (!ret)
>> -		__fill_v4l2_buffer(vb, b);
>> +		__fill_v4l2_buffer(cb, b);
>>   	return ret;
>>   }
>>   EXPORT_SYMBOL(vb2_querybuf);
>> @@ -1123,12 +1147,13 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
>>    * This function returns a kernel virtual address of a given plane if
>>    * such a mapping exist, NULL otherwise.
>>    */
>> -void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>> +void *vb2_plane_vaddr(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
>>   {
>> -	if (plane_no > vb->vb2.num_planes || !vb->vb2.planes[plane_no].mem_priv)
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
>>   		return NULL;
>>   
>> -	return call_ptr_memop(vb, vaddr, vb->vb2.planes[plane_no].mem_priv);
>> +	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
>>   
>>   }
>>   EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
>> @@ -1140,16 +1165,17 @@ EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
>>    *
>>    * This function returns an allocator specific cookie for a given plane if
>>    * available, NULL otherwise. The allocator should provide some simple static
>> - * inline funaction, which would convert this cookie to the allocator specific
>> + * inline function, which would convert this cookie to the allocator specific
>>    * type that can be used directly by the driver to access the buffer. This can
>>    * be for example physical address, pointer to scatter list or IOMMU mapping.
>>    */
>> -void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>> +void *vb2_plane_cookie(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
>>   {
>> -	if (plane_no >= vb->vb2.num_planes || !vb->vb2.planes[plane_no].mem_priv)
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
>>   		return NULL;
>>   
>> -	return call_ptr_memop(vb, cookie, vb->vb2.planes[plane_no].mem_priv);
>> +	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
>>   }
>>   EXPORT_SYMBOL_GPL(vb2_plane_cookie);
>>   
>> @@ -1172,13 +1198,14 @@ EXPORT_SYMBOL_GPL(vb2_plane_cookie);
>>    * be started for some reason. In that case the buffers should be returned with
>>    * state QUEUED.
>>    */
>> -void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state)
>> +void vb2_buffer_done(struct vb2_v4l2_buffer *cb, enum vb2_buffer_state state)
>>   {
>> -	struct vb2_queue *q = vb->vb2.vb2_queue;
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +	struct vb2_queue *q = vb->vb2_queue;
>>   	unsigned long flags;
>>   	unsigned int plane;
>>   
>> -	if (WARN_ON(vb->vb2.state != VB2_BUF_STATE_ACTIVE))
>> +	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
>>   		return;
>>   
>>   	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
>> @@ -1191,20 +1218,20 @@ void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state)
>>   	 * Although this is not a callback, it still does have to balance
>>   	 * with the buf_queue op. So update this counter manually.
>>   	 */
>> -	vb->vb2.cnt_buf_done++;
>> +	vb->cnt_buf_done++;
>>   #endif
>>   	dprintk(4, "done processing on buffer %d, state: %d\n",
>> -			vb->v4l2_buf.index, state);
>> +			cb->v4l2_buf.index, state);
>>   
>>   	/* sync buffers */
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
>> -		call_void_memop(vb, finish, vb->vb2.planes[plane].mem_priv);
>> +	for (plane = 0; plane < vb->num_planes; ++plane)
>> +		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
>>   
>>   	/* Add the buffer to the done buffers list */
>>   	spin_lock_irqsave(&q->done_lock, flags);
>> -	vb->vb2.state = state;
>> +	vb->state = state;
>>   	if (state != VB2_BUF_STATE_QUEUED)
>> -		list_add_tail(&vb->vb2.done_entry, &q->done_list);
>> +		list_add_tail(&vb->done_entry, &q->done_list);
>>   	atomic_dec(&q->owned_by_drv_count);
>>   	spin_unlock_irqrestore(&q->done_lock, flags);
>>   
>> @@ -1245,14 +1272,15 @@ EXPORT_SYMBOL_GPL(vb2_discard_done);
>>    * v4l2_buffer by the userspace. The caller has already verified that struct
>>    * v4l2_buffer has a valid number of planes.
>>    */
>> -static void __fill_vb2_buffer(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b,
>> +static void __fill_vb2_buffer(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b,
>>   				struct v4l2_plane *v4l2_planes)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	unsigned int plane;
>>   
>>   	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
>>   		if (b->memory == V4L2_MEMORY_USERPTR) {
>> -			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> +			for (plane = 0; plane < vb->num_planes; ++plane) {
>>   				v4l2_planes[plane].m.userptr =
>>   					b->m.planes[plane].m.userptr;
>>   				v4l2_planes[plane].length =
>> @@ -1260,7 +1288,7 @@ static void __fill_vb2_buffer(struct vb2_v4l2_buffer *vb, const struct v4l2_buff
>>   			}
>>   		}
>>   		if (b->memory == V4L2_MEMORY_DMABUF) {
>> -			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> +			for (plane = 0; plane < vb->num_planes; ++plane) {
>>   				v4l2_planes[plane].m.fd =
>>   					b->m.planes[plane].m.fd;
>>   				v4l2_planes[plane].length =
>> @@ -1280,7 +1308,7 @@ static void __fill_vb2_buffer(struct vb2_v4l2_buffer *vb, const struct v4l2_buff
>>   			 * it's a safe assumption that they really meant to
>>   			 * use the full plane sizes.
>>   			 */
>> -			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> +			for (plane = 0; plane < vb->num_planes; ++plane) {
>>   				struct v4l2_plane *pdst = &v4l2_planes[plane];
>>   				struct v4l2_plane *psrc = &b->m.planes[plane];
>>   
>> @@ -1318,15 +1346,15 @@ static void __fill_vb2_buffer(struct vb2_v4l2_buffer *vb, const struct v4l2_buff
>>   	}
>>   
>>   	/* Zero flags that the vb2 core handles */
>> -	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
>> -	if ((vb->vb2.vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
>> +	cb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
>> +	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
>>   	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
>>   		/*
>>   		 * Non-COPY timestamps and non-OUTPUT queues will get
>>   		 * their timestamp and timestamp source flags from the
>>   		 * queue.
>>   		 */
>> -		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>> +		cb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>>   	}
>>   
>>   	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
>> @@ -1336,46 +1364,48 @@ static void __fill_vb2_buffer(struct vb2_v4l2_buffer *vb, const struct v4l2_buff
>>   		 * The 'field' is valid metadata for this output buffer
>>   		 * and so that needs to be copied here.
>>   		 */
>> -		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
>> -		vb->v4l2_buf.field = b->field;
>> +		cb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
>> +		cb->v4l2_buf.field = b->field;
>>   	} else {
>>   		/* Zero any output buffer flags as this is a capture buffer */
>> -		vb->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
>> +		cb->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
>>   	}
>>   }
>>   
>>   /**
>>    * __qbuf_mmap() - handle qbuf of an MMAP buffer
>>    */
>> -static int __qbuf_mmap(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
>> +static int __qbuf_mmap(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
>>   {
>> -	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +	__fill_vb2_buffer(cb, b, cb->v4l2_planes);
>>   	return call_vb_qop(vb, buf_prepare, vb);
>>   }
>>   
>>   /**
>>    * __qbuf_userptr() - handle qbuf of a USERPTR buffer
>>    */
>> -static int __qbuf_userptr(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
>> +static int __qbuf_userptr(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	struct v4l2_plane planes[VIDEO_MAX_PLANES];
>> -	struct vb2_queue *q = vb->vb2.vb2_queue;
>> +	struct vb2_queue *q = vb->vb2_queue;
>>   	void *mem_priv;
>>   	unsigned int plane;
>>   	int ret;
>>   	enum dma_data_direction dma_dir =
>>   		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>> -	bool reacquired = vb->vb2.planes[0].mem_priv == NULL;
>> +	bool reacquired = vb->planes[0].mem_priv == NULL;
>>   
>> -	memset(planes, 0, sizeof(planes[0]) * vb->vb2.num_planes);
>> +	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
>>   	/* Copy relevant information provided by the userspace */
>> -	__fill_vb2_buffer(vb, b, planes);
>> +	__fill_vb2_buffer(cb, b, planes);
>>   
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> +	for (plane = 0; plane < vb->num_planes; ++plane) {
>>   		/* Skip the plane if already verified */
>> -		if (vb->v4l2_planes[plane].m.userptr &&
>> -		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
>> -		    && vb->v4l2_planes[plane].length == planes[plane].length)
>> +		if (cb->v4l2_planes[plane].m.userptr &&
>> +		    cb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
>> +		    && cb->v4l2_planes[plane].length == planes[plane].length)
>>   			continue;
>>   
>>   		dprintk(3, "userspace address for plane %d changed, "
>> @@ -1392,16 +1422,16 @@ static int __qbuf_userptr(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *
>>   		}
>>   
>>   		/* Release previously acquired memory if present */
>> -		if (vb->vb2.planes[plane].mem_priv) {
>> +		if (vb->planes[plane].mem_priv) {
>>   			if (!reacquired) {
>>   				reacquired = true;
>>   				call_void_vb_qop(vb, buf_cleanup, vb);
>>   			}
>> -			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
>> +			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
>>   		}
>>   
>> -		vb->vb2.planes[plane].mem_priv = NULL;
>> -		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
>> +		vb->planes[plane].mem_priv = NULL;
>> +		memset(&cb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
>>   
>>   		/* Acquire each plane's memory */
>>   		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
>> @@ -1413,15 +1443,15 @@ static int __qbuf_userptr(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *
>>   			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
>>   			goto err;
>>   		}
>> -		vb->vb2.planes[plane].mem_priv = mem_priv;
>> +		vb->planes[plane].mem_priv = mem_priv;
>>   	}
>>   
>>   	/*
>>   	 * Now that everything is in order, copy relevant information
>>   	 * provided by userspace.
>>   	 */
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
>> -		vb->v4l2_planes[plane] = planes[plane];
>> +	for (plane = 0; plane < vb->num_planes; ++plane)
>> +		cb->v4l2_planes[plane] = planes[plane];
>>   
>>   	if (reacquired) {
>>   		/*
>> @@ -1446,12 +1476,12 @@ static int __qbuf_userptr(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *
>>   	return 0;
>>   err:
>>   	/* In case of errors, release planes that were already acquired */
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> -		if (vb->vb2.planes[plane].mem_priv)
>> -			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
>> -		vb->vb2.planes[plane].mem_priv = NULL;
>> -		vb->v4l2_planes[plane].m.userptr = 0;
>> -		vb->v4l2_planes[plane].length = 0;
>> +	for (plane = 0; plane < vb->num_planes; ++plane) {
>> +		if (vb->planes[plane].mem_priv)
>> +			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
>> +		vb->planes[plane].mem_priv = NULL;
>> +		cb->v4l2_planes[plane].m.userptr = 0;
>> +		cb->v4l2_planes[plane].length = 0;
>>   	}
>>   
>>   	return ret;
>> @@ -1460,22 +1490,23 @@ err:
>>   /**
>>    * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
>>    */
>> -static int __qbuf_dmabuf(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
>> +static int __qbuf_dmabuf(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
>>   {
>> +	struct vb2_buffer *vb = &cb->vb2;
>>   	struct v4l2_plane planes[VIDEO_MAX_PLANES];
>> -	struct vb2_queue *q = vb->vb2.vb2_queue;
>> +	struct vb2_queue *q = vb->vb2_queue;
>>   	void *mem_priv;
>>   	unsigned int plane;
>>   	int ret;
>>   	enum dma_data_direction dma_dir =
>>   		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>> -	bool reacquired = vb->vb2.planes[0].mem_priv == NULL;
>> +	bool reacquired = vb->planes[0].mem_priv == NULL;
>>   
>> -	memset(planes, 0, sizeof(planes[0]) * vb->vb2.num_planes);
>> +	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
>>   	/* Copy relevant information provided by the userspace */
>> -	__fill_vb2_buffer(vb, b, planes);
>> +	__fill_vb2_buffer(cb, b, planes);
>>   
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> +	for (plane = 0; plane < vb->num_planes; ++plane) {
>>   		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
>>   
>>   		if (IS_ERR_OR_NULL(dbuf)) {
>> @@ -1497,8 +1528,8 @@ static int __qbuf_dmabuf(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b
>>   		}
>>   
>>   		/* Skip the plane if already verified */
>> -		if (dbuf == vb->vb2.planes[plane].dbuf &&
>> -		    vb->v4l2_planes[plane].length == planes[plane].length) {
>> +		if (dbuf == vb->planes[plane].dbuf &&
>> +		    cb->v4l2_planes[plane].length == planes[plane].length) {
>>   			dma_buf_put(dbuf);
>>   			continue;
>>   		}
>> @@ -1511,8 +1542,8 @@ static int __qbuf_dmabuf(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b
>>   		}
>>   
>>   		/* Release previously acquired memory if present */
>> -		__vb2_plane_dmabuf_put(vb, &vb->vb2.planes[plane]);
>> -		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
>> +		__vb2_plane_dmabuf_put(cb, &vb->planes[plane]);
>> +		memset(&cb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
>>   
>>   		/* Acquire each plane's memory */
>>   		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
>> @@ -1524,30 +1555,30 @@ static int __qbuf_dmabuf(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b
>>   			goto err;
>>   		}
>>   
>> -		vb->vb2.planes[plane].dbuf = dbuf;
>> -		vb->vb2.planes[plane].mem_priv = mem_priv;
>> +		vb->planes[plane].dbuf = dbuf;
>> +		vb->planes[plane].mem_priv = mem_priv;
>>   	}
>>   
>>   	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
>>   	 * really we want to do this just before the DMA, not while queueing
>>   	 * the buffer(s)..
>>   	 */
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> -		ret = call_memop(vb, map_dmabuf, vb->vb2.planes[plane].mem_priv);
>> +	for (plane = 0; plane < vb->num_planes; ++plane) {
>> +		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
>>   		if (ret) {
>>   			dprintk(1, "failed to map dmabuf for plane %d\n",
>>   				plane);
>>   			goto err;
>>   		}
>> -		vb->vb2.planes[plane].dbuf_mapped = 1;
>> +		vb->planes[plane].dbuf_mapped = 1;
>>   	}
>>   
>>   	/*
>>   	 * Now that everything is in order, copy relevant information
>>   	 * provided by userspace.
>>   	 */
>> -	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
>> -		vb->v4l2_planes[plane] = planes[plane];
>> +	for (plane = 0; plane < vb->num_planes; ++plane)
>> +		cb->v4l2_planes[plane] = planes[plane];
>>   
>>   	if (reacquired) {
>>   		/*
>> @@ -1571,7 +1602,7 @@ static int __qbuf_dmabuf(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b
>>   	return 0;
>>   err:
>>   	/* In case of errors, release planes that were already acquired */
>> -	__vb2_buf_dmabuf_put(vb);
>> +	__vb2_buf_dmabuf_put(cb);
>>   
>>   	return ret;
>>   }
>> @@ -1581,7 +1612,6 @@ err:
>>    */
>>   static void __enqueue_in_driver(struct vb2_buffer *vb)
>>   {
>> -	struct vb2_v4l2_buffer *pb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   	struct vb2_queue *q = vb->vb2_queue;
>>   	unsigned int plane;
>>   
>> @@ -1590,17 +1620,18 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>>   
>>   	/* sync buffers */
>>   	for (plane = 0; plane < vb->num_planes; ++plane)
>> -		call_void_memop(pb, prepare, vb->planes[plane].mem_priv);
>> +		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
>>   
>> -	call_void_vb_qop(pb, buf_queue, pb);
>> +	call_void_vb_qop(vb, buf_queue, vb);
>>   }
>>   
>> -static int __buf_prepare(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
>> +static int __buf_prepare(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
>>   {
>> -	struct vb2_queue *q = vb->vb2.vb2_queue;
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +	struct vb2_queue *q = vb->vb2_queue;
>>   	int ret;
>>   
>> -	ret = __verify_length(vb, b);
>> +	ret = __verify_length(cb, b);
>>   	if (ret < 0) {
>>   		dprintk(1, "plane parameters verification failed: %d\n", ret);
>>   		return ret;
>> @@ -1624,22 +1655,22 @@ static int __buf_prepare(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b
>>   		return -EIO;
>>   	}
>>   
>> -	vb->vb2.state = VB2_BUF_STATE_PREPARING;
>> -	vb->v4l2_buf.timestamp.tv_sec = 0;
>> -	vb->v4l2_buf.timestamp.tv_usec = 0;
>> -	vb->v4l2_buf.sequence = 0;
>> +	vb->state = VB2_BUF_STATE_PREPARING;
>> +	cb->v4l2_buf.timestamp.tv_sec = 0;
>> +	cb->v4l2_buf.timestamp.tv_usec = 0;
>> +	cb->v4l2_buf.sequence = 0;
>>   
>>   	switch (q->memory) {
>>   	case V4L2_MEMORY_MMAP:
>> -		ret = __qbuf_mmap(vb, b);
>> +		ret = __qbuf_mmap(cb, b);
>>   		break;
>>   	case V4L2_MEMORY_USERPTR:
>>   		down_read(&current->mm->mmap_sem);
>> -		ret = __qbuf_userptr(vb, b);
>> +		ret = __qbuf_userptr(cb, b);
>>   		up_read(&current->mm->mmap_sem);
>>   		break;
>>   	case V4L2_MEMORY_DMABUF:
>> -		ret = __qbuf_dmabuf(vb, b);
>> +		ret = __qbuf_dmabuf(cb, b);
>>   		break;
>>   	default:
>>   		WARN(1, "Invalid queue type\n");
>> @@ -1648,7 +1679,7 @@ static int __buf_prepare(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b
>>   
>>   	if (ret)
>>   		dprintk(1, "buffer preparation failed: %d\n", ret);
>> -	vb->vb2.state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
>> +	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
>>   
>>   	return ret;
>>   }
>> @@ -1656,6 +1687,8 @@ static int __buf_prepare(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b
>>   static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>>   				    const char *opname)
>>   {
>> +	struct vb2_v4l2_buffer *cb;
>> +
>>   	if (b->type != q->type) {
>>   		dprintk(1, "%s: invalid buffer type\n", opname);
>>   		return -EINVAL;
>> @@ -1677,7 +1710,9 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>>   		return -EINVAL;
>>   	}
>>   
>> -	return __verify_planes_array(q->bufs[b->index], b);
>> +	cb = container_of(q->bufs[b->index], struct vb2_v4l2_buffer, vb2);
>> +
>> +	return __verify_planes_array(cb, b);
>>   }
>>   
>>   /**
>> @@ -1697,7 +1732,8 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>>    */
>>   int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   {
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   	int ret;
>>   
>>   	if (vb2_fileio_is_active(q)) {
>> @@ -1710,18 +1746,19 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   		return ret;
>>   
>>   	vb = q->bufs[b->index];
>> -	if (vb->vb2.state != VB2_BUF_STATE_DEQUEUED) {
>> +	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>> +	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
>>   		dprintk(1, "invalid buffer state %d\n",
>> -			vb->vb2.state);
>> +			vb->state);
>>   		return -EINVAL;
>>   	}
>>   
>> -	ret = __buf_prepare(vb, b);
>> +	ret = __buf_prepare(cb, b);
>>   	if (!ret) {
>>   		/* Fill buffer information for the userspace */
>> -		__fill_v4l2_buffer(vb, b);
>> +		__fill_v4l2_buffer(cb, b);
>>   
>> -		dprintk(1, "prepare of buffer %d succeeded\n", vb->v4l2_buf.index);
>> +		dprintk(1, "prepare of buffer %d succeeded\n", cb->v4l2_buf.index);
>>   	}
>>   	return ret;
>>   }
>> @@ -1741,7 +1778,7 @@ EXPORT_SYMBOL_GPL(vb2_prepare_buf);
>>   static int vb2_start_streaming(struct vb2_queue *q)
>>   {
>>   	struct vb2_buffer *vb;
>> -	struct vb2_v4l2_buffer *pb;
>> +	struct vb2_v4l2_buffer *cb;
>>   	int ret;
>>   
>>   	/*
>> @@ -1775,9 +1812,10 @@ static int vb2_start_streaming(struct vb2_queue *q)
>>   		 * correctly return them to vb2.
>>   		 */
>>   		for (i = 0; i < q->num_buffers; ++i) {
>> -			pb = q->bufs[i];
>> -			if (pb->vb2.state == VB2_BUF_STATE_ACTIVE)
>> -				vb2_buffer_done(pb, VB2_BUF_STATE_QUEUED);
>> +			vb = q->bufs[i];
>> +			cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>> +			if (vb->state == VB2_BUF_STATE_ACTIVE)
>> +				vb2_buffer_done(cb, VB2_BUF_STATE_QUEUED);
>>   		}
>>   		/* Must be zero now */
>>   		WARN_ON(atomic_read(&q->owned_by_drv_count));
>> @@ -1794,16 +1832,18 @@ static int vb2_start_streaming(struct vb2_queue *q)
>>   static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   {
>>   	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   
>>   	if (ret)
>>   		return ret;
>>   
>>   	vb = q->bufs[b->index];
>> +	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   
>> -	switch (vb->vb2.state) {
>> +	switch (vb->state) {
>>   	case VB2_BUF_STATE_DEQUEUED:
>> -		ret = __buf_prepare(vb, b);
>> +		ret = __buf_prepare(cb, b);
>>   		if (ret)
>>   			return ret;
>>   		break;
>> @@ -1813,7 +1853,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   		dprintk(1, "buffer still being prepared\n");
>>   		return -EINVAL;
>>   	default:
>> -		dprintk(1, "invalid buffer state %d\n", vb->vb2.state);
>> +		dprintk(1, "invalid buffer state %d\n", vb->state);
>>   		return -EINVAL;
>>   	}
>>   
>> @@ -1821,10 +1861,10 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   	 * Add to the queued buffers list, a buffer will stay on it until
>>   	 * dequeued in dqbuf.
>>   	 */
>> -	list_add_tail(&vb->vb2.queued_entry, &q->queued_list);
>> +	list_add_tail(&vb->queued_entry, &q->queued_list);
>>   	q->queued_count++;
>>   	q->waiting_for_buffers = false;
>> -	vb->vb2.state = VB2_BUF_STATE_QUEUED;
>> +	vb->state = VB2_BUF_STATE_QUEUED;
>>   	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
>>   		/*
>>   		 * For output buffers copy the timestamp if needed,
>> @@ -1832,10 +1872,10 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   		 */
>>   		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
>>   		    V4L2_BUF_FLAG_TIMESTAMP_COPY)
>> -			vb->v4l2_buf.timestamp = b->timestamp;
>> -		vb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
>> +			cb->v4l2_buf.timestamp = b->timestamp;
>> +		cb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
>>   		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
>> -			vb->v4l2_buf.timecode = b->timecode;
>> +			cb->v4l2_buf.timecode = b->timecode;
>>   	}
>>   
>>   	/*
>> @@ -1843,10 +1883,10 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   	 * If not, the buffer will be given to driver on next streamon.
>>   	 */
>>   	if (q->start_streaming_called)
>> -		__enqueue_in_driver(&vb->vb2);
>> +		__enqueue_in_driver(vb);
>>   
>>   	/* Fill buffer information for the userspace */
>> -	__fill_v4l2_buffer(vb, b);
>> +	__fill_v4l2_buffer(cb, b);
>>   
>>   	/*
>>   	 * If streamon has been called, and we haven't yet called
>> @@ -1861,7 +1901,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>   			return ret;
>>   	}
>>   
>> -	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
>> +	dprintk(1, "qbuf of buffer %d succeeded\n", cb->v4l2_buf.index);
>>   	return 0;
>>   }
>>   
>> @@ -1969,12 +2009,12 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>>    *
>>    * Will sleep if required for nonblocking == false.
>>    */
>> -static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_v4l2_buffer **vb,
>> +static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_v4l2_buffer **cb,
>>   				struct v4l2_buffer *b, int nonblocking)
>>   {
>>   	unsigned long flags;
>>   	int ret;
>> -	struct vb2_buffer *vb2 = NULL;
>> +	struct vb2_buffer *vb = NULL;
>>   
>>   	/*
>>   	 * Wait for at least one buffer to become available on the done_list.
>> @@ -1988,15 +2028,15 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_v4l2_buffer **vb,
>>   	 * is not empty, so no need for another list_empty(done_list) check.
>>   	 */
>>   	spin_lock_irqsave(&q->done_lock, flags);
>> -	vb2 = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
>> -	*vb = container_of(vb2, struct vb2_v4l2_buffer, vb2);
>> +	vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
>> +	*cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   	/*
>>   	 * Only remove the buffer from done_list if v4l2_buffer can handle all
>>   	 * the planes.
>>   	 */
>> -	ret = __verify_planes_array(*vb, b);
>> +	ret = __verify_planes_array(*cb, b);
>>   	if (!ret)
>> -		list_del(&(*vb)->vb2.done_entry);
>> +		list_del(&vb->done_entry);
>>   	spin_unlock_irqrestore(&q->done_lock, flags);
>>   
>>   	return ret;
>> @@ -2027,41 +2067,45 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
>>   /**
>>    * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
>>    */
>> -static void __vb2_dqbuf(struct vb2_v4l2_buffer *vb)
>> +static void __vb2_dqbuf(struct vb2_v4l2_buffer *cb)
>>   {
>> -	struct vb2_queue *q = vb->vb2.vb2_queue;
>> +	struct vb2_buffer *vb = &cb->vb2;
>> +	struct vb2_queue *q = vb->vb2_queue;
>>   	unsigned int i;
>>   
>>   	/* nothing to do if the buffer is already dequeued */
>> -	if (vb->vb2.state == VB2_BUF_STATE_DEQUEUED)
>> +	if (vb->state == VB2_BUF_STATE_DEQUEUED)
>>   		return;
>>   
>> -	vb->vb2.state = VB2_BUF_STATE_DEQUEUED;
>> +	vb->state = VB2_BUF_STATE_DEQUEUED;
>>   
>>   	/* unmap DMABUF buffer */
>>   	if (q->memory == V4L2_MEMORY_DMABUF)
>> -		for (i = 0; i < vb->vb2.num_planes; ++i) {
>> -			if (!vb->vb2.planes[i].dbuf_mapped)
>> +		for (i = 0; i < vb->num_planes; ++i) {
>> +			if (!vb->planes[i].dbuf_mapped)
>>   				continue;
>> -			call_void_memop(vb, unmap_dmabuf, vb->vb2.planes[i].mem_priv);
>> -			vb->vb2.planes[i].dbuf_mapped = 0;
>> +			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
>> +			vb->planes[i].dbuf_mapped = 0;
>>   		}
>>   }
>>   
>>   static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>>   {
>> -	struct vb2_v4l2_buffer *vb = NULL;
>> +	struct vb2_v4l2_buffer *cb = NULL;
>> +	struct vb2_buffer *vb = NULL;
>>   	int ret;
>>   
>>   	if (b->type != q->type) {
>>   		dprintk(1, "invalid buffer type\n");
>>   		return -EINVAL;
>>   	}
>> -	ret = __vb2_get_done_vb(q, &vb, b, nonblocking);
>> +	ret = __vb2_get_done_vb(q, &cb, b, nonblocking);
>>   	if (ret < 0)
>>   		return ret;
>>   
>> -	switch (vb->vb2.state) {
>> +	vb = &cb->vb2;
>> +
>> +	switch (vb->state) {
>>   	case VB2_BUF_STATE_DONE:
>>   		dprintk(3, "returning done buffer\n");
>>   		break;
>> @@ -2076,15 +2120,15 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
>>   	call_void_vb_qop(vb, buf_finish, vb);
>>   
>>   	/* Fill buffer information for the userspace */
>> -	__fill_v4l2_buffer(vb, b);
>> +	__fill_v4l2_buffer(cb, b);
>>   	/* Remove from videobuf queue */
>> -	list_del(&vb->vb2.queued_entry);
>> +	list_del(&vb->queued_entry);
>>   	q->queued_count--;
>>   	/* go back to dequeued state */
>> -	__vb2_dqbuf(vb);
>> +	__vb2_dqbuf(cb);
>>   
>>   	dprintk(1, "dqbuf of buffer %d, with state %d\n",
>> -			vb->v4l2_buf.index, vb->vb2.state);
>> +			cb->v4l2_buf.index, vb->state);
>>   
>>   	return 0;
>>   }
>> @@ -2128,8 +2172,9 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
>>    */
>>   static void __vb2_queue_cancel(struct vb2_queue *q)
>>   {
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   	unsigned int i;
>> -	struct vb2_v4l2_buffer *vb;
>>   
>>   	/*
>>   	 * Tell driver to stop all transactions and release all queued
>> @@ -2147,9 +2192,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>   	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>>   		for (i = 0; i < q->num_buffers; ++i)
>>   		{
>> -			vb = (struct vb2_v4l2_buffer *)q->bufs[i];
>> -			if (vb->vb2.state == VB2_BUF_STATE_ACTIVE)
>> -				vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>> +			vb = q->bufs[i];
>> +			cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>> +			if (vb->state == VB2_BUF_STATE_ACTIVE)
>> +				vb2_buffer_done(cb, VB2_BUF_STATE_ERROR);
>>   		}
>>   		/* Must be zero now */
>>   		WARN_ON(atomic_read(&q->owned_by_drv_count));
>> @@ -2182,13 +2228,14 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>   	 * be changed, so we can't move the buf_finish() to __vb2_dqbuf().
>>   	 */
>>   	for (i = 0; i < q->num_buffers; ++i) {
>> -		struct vb2_v4l2_buffer *vb = q->bufs[i];
>> +		struct vb2_buffer *vb = q->bufs[i];
>> +		struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   
>> -		if (vb->vb2.state != VB2_BUF_STATE_DEQUEUED) {
>> -			vb->vb2.state = VB2_BUF_STATE_PREPARED;
>> +		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
>> +			vb->state = VB2_BUF_STATE_PREPARED;
>>   			call_void_vb_qop(vb, buf_finish, vb);
>>   		}
>> -		__vb2_dqbuf(vb);
>> +		__vb2_dqbuf(cb);
>>   	}
>>   }
>>   
>> @@ -2333,7 +2380,8 @@ EXPORT_SYMBOL_GPL(vb2_streamoff);
>>   static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
>>   			unsigned int *_buffer, unsigned int *_plane)
>>   {
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   	unsigned int buffer, plane;
>>   
>>   	/*
>> @@ -2343,9 +2391,10 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
>>   	 */
>>   	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
>>   		vb = q->bufs[buffer];
>> +		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   
>> -		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
>> -			if (vb->v4l2_planes[plane].m.mem_offset == off) {
>> +		for (plane = 0; plane < vb->num_planes; ++plane) {
>> +			if (cb->v4l2_planes[plane].m.mem_offset == off) {
>>   				*_buffer = buffer;
>>   				*_plane = plane;
>>   				return 0;
>> @@ -2367,7 +2416,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
>>    */
>>   int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
>>   {
>> -	struct vb2_v4l2_buffer *vb = NULL;
>> +	struct vb2_buffer *vb = NULL;
>>   	struct vb2_plane *vb_plane;
>>   	int ret;
>>   	struct dma_buf *dbuf;
>> @@ -2399,7 +2448,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
>>   
>>   	vb = q->bufs[eb->index];
>>   
>> -	if (eb->plane >= vb->vb2.num_planes) {
>> +	if (eb->plane >= vb->num_planes) {
>>   		dprintk(1, "buffer plane out of range\n");
>>   		return -EINVAL;
>>   	}
>> @@ -2409,7 +2458,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
>>   		return -EBUSY;
>>   	}
>>   
>> -	vb_plane = &vb->vb2.planes[eb->plane];
>> +	vb_plane = &vb->planes[eb->plane];
>>   
>>   	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
>>   	if (IS_ERR_OR_NULL(dbuf)) {
>> @@ -2456,7 +2505,8 @@ EXPORT_SYMBOL_GPL(vb2_expbuf);
>>   int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>>   {
>>   	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   	unsigned int buffer = 0, plane = 0;
>>   	int ret;
>>   	unsigned long length;
>> @@ -2497,13 +2547,13 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>>   		return ret;
>>   
>>   	vb = q->bufs[buffer];
>> -
>> +	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   	/*
>>   	 * MMAP requires page_aligned buffers.
>>   	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
>>   	 * so, we need to do the same here.
>>   	 */
>> -	length = PAGE_ALIGN(vb->v4l2_planes[plane].length);
>> +	length = PAGE_ALIGN(cb->v4l2_planes[plane].length);
>>   	if (length < (vma->vm_end - vma->vm_start)) {
>>   		dprintk(1,
>>   			"MMAP invalid, as it would overflow buffer length\n");
>> @@ -2511,7 +2561,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>>   	}
>>   
>>   	mutex_lock(&q->mmap_lock);
>> -	ret = call_memop(vb, mmap, vb->vb2.planes[plane].mem_priv, vma);
>> +	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
>>   	mutex_unlock(&q->mmap_lock);
>>   	if (ret)
>>   		return ret;
>> @@ -2528,8 +2578,9 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>>   				    unsigned long pgoff,
>>   				    unsigned long flags)
>>   {
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   	unsigned long off = pgoff << PAGE_SHIFT;
>> -	struct vb2_v4l2_buffer *vb;
>>   	unsigned int buffer, plane;
>>   	void *vaddr;
>>   	int ret;
>> @@ -2547,8 +2598,9 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>>   		return ret;
>>   
>>   	vb = q->bufs[buffer];
>> +	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   
>> -	vaddr = vb2_plane_vaddr(vb, plane);
>> +	vaddr = vb2_plane_vaddr(cb, plane);
>>   	return vaddr ? (unsigned long)vaddr : -EINVAL;
>>   }
>>   EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
>> @@ -2784,7 +2836,8 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>>   	struct vb2_fileio_data *fileio;
>>   	int i, ret;
>>   	unsigned int count = 0;
>> -	struct vb2_v4l2_buffer *vb;
>> +	struct vb2_v4l2_buffer *cb;
>> +	struct vb2_buffer *vb;
>>   
>>   	/*
>>   	 * Sanity check
>> @@ -2835,8 +2888,8 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>>   	 * Check if plane_count is correct
>>   	 * (multiplane buffers are not supported).
>>   	 */
>> -	vb = (struct vb2_v4l2_buffer *)q->bufs[0];
>> -	if (vb->vb2.num_planes != 1) {
>> +	vb = q->bufs[0];
>> +	if (vb->num_planes != 1) {
>>   		ret = -EBUSY;
>>   		goto err_reqbufs;
>>   	}
>> @@ -2845,12 +2898,13 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>>   	 * Get kernel address of each buffer.
>>   	 */
>>   	for (i = 0; i < q->num_buffers; i++) {
>> -		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
>> +		cb = container_of(q->bufs[i], struct vb2_v4l2_buffer, vb2);
>> +		fileio->bufs[i].vaddr = vb2_plane_vaddr(cb, 0);
>>   		if (fileio->bufs[i].vaddr == NULL) {
>>   			ret = -EINVAL;
>>   			goto err_reqbufs;
>>   		}
>> -		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
>> +		fileio->bufs[i].size = vb2_plane_size(cb, 0);
>>   	}
>>   
>>   	/*
>> @@ -2937,6 +2991,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
>>   static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
>>   		loff_t *ppos, int nonblock, int read)
>>   {
>> +	struct vb2_v4l2_buffer *cb;
>>   	struct vb2_fileio_data *fileio;
>>   	struct vb2_fileio_buf *buf;
>>   	bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
>> @@ -2996,10 +3051,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>>   		/*
>>   		 * Get number of bytes filled by the driver
>>   		 */
>> +		cb = container_of(q->bufs[index], struct vb2_v4l2_buffer, vb2);
>>   		buf->pos = 0;
>>   		buf->queued = 0;
>> -		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
>> -				 : vb2_plane_size(q->bufs[index], 0);
>> +		buf->size = read ? vb2_get_plane_payload(cb, 0)
>> +				 : vb2_plane_size(cb, 0);
>>   		/* Compensate for data_offset on read in the multiplanar case. */
>>   		if (is_multiplanar && read &&
>>   		    fileio->b.m.planes[0].data_offset < buf->size) {
>> @@ -3076,9 +3132,10 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>>   		/*
>>   		 * Buffer has been queued, update the status
>>   		 */
>> +		cb = container_of(q->bufs[index], struct vb2_v4l2_buffer, vb2);
>>   		buf->pos = 0;
>>   		buf->queued = 1;
>> -		buf->size = vb2_plane_size(q->bufs[index], 0);
>> +		buf->size = vb2_plane_size(cb, 0);
>>   		fileio->q_count += 1;
>>   		/*
>>   		 * If we are queuing up buffers for the first time, then
>> @@ -3146,7 +3203,8 @@ static int vb2_thread(void *data)
>>   	set_freezable();
>>   
>>   	for (;;) {
>> -		struct vb2_v4l2_buffer *vb;
>> +		struct vb2_v4l2_buffer *cb;
>> +		struct vb2_buffer *vb;
>>   
>>   		/*
>>   		 * Call vb2_dqbuf to get buffer back.
>> @@ -3169,8 +3227,9 @@ static int vb2_thread(void *data)
>>   		try_to_freeze();
>>   
>>   		vb = q->bufs[fileio->b.index];
>> +		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
>>   		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
>> -			if (threadio->fnc(vb, threadio->priv))
>> +			if (threadio->fnc(cb, threadio->priv))
>>   				break;
>>   		call_void_qop(q, wait_finish, q);
>>   		if (set_timestamp)
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index 3b5df66..24c229d 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -227,27 +227,6 @@ struct vb2_buffer {
>>   };
>>   
>>   /**
>> - * struct vb2_v4l2_buffer - represents a video buffer for v4l2
>> - * @vb2_buf:		common video buffer
>> - * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
>> - *			be read by the driver and relevant entries can be
>> - *			changed by the driver in case of CAPTURE types
>> - *			(such as timestamp)
>> - * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
>> - *			be read by the driver and relevant entries can be
>> - *			changed by the driver in case of CAPTURE types
>> - *			(such as bytesused); NOTE that even for single-planar
>> - *			types, the v4l2_planes[0] struct should be used
>> - *			instead of v4l2_buf for filling bytesused - drivers
>> - *			should use the vb2_set_plane_payload() function for that
>> - */
>> -struct vb2_v4l2_buffer {
>> -	struct vb2_buffer	vb2;
>> -	struct v4l2_buffer	v4l2_buf;
>> -	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
>> -};
>> -
>> -/**
>>    * struct vb2_ops - driver-specific callbacks
>>    *
>>    * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
>> @@ -327,26 +306,24 @@ struct vb2_v4l2_buffer {
>>    *			pre-queued buffers before calling STREAMON.
>>    */
>>   struct vb2_ops {
>> -	int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
>> +	int (*queue_setup)(struct vb2_queue *q, void *fmt,
>>   			   unsigned int *num_buffers, unsigned int *num_planes,
>>   			   unsigned int sizes[], void *alloc_ctxs[]);
> Better to rename "fmt" here to "priv", to indicate that the usage of
> this field is specific to the VB2-variant.
>
OK, I'll modify it.
>>   
>>   	void (*wait_prepare)(struct vb2_queue *q);
>>   	void (*wait_finish)(struct vb2_queue *q);
>>   
>> -	int (*buf_init)(struct vb2_v4l2_buffer *vb);
>> -	int (*buf_prepare)(struct vb2_v4l2_buffer *vb);
>> -	void (*buf_finish)(struct vb2_v4l2_buffer *vb);
>> -	void (*buf_cleanup)(struct vb2_v4l2_buffer *vb);
>> +	int (*buf_init)(struct vb2_buffer *vb);
>> +	int (*buf_prepare)(struct vb2_buffer *vb);
>> +	void (*buf_finish)(struct vb2_buffer *vb);
>> +	void (*buf_cleanup)(struct vb2_buffer *vb);
>>   
>>   	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
>>   	void (*stop_streaming)(struct vb2_queue *q);
>>   
>> -	void (*buf_queue)(struct vb2_v4l2_buffer *vb);
>> +	void (*buf_queue)(struct vb2_buffer *vb);
>>   };
>>   
>> -struct v4l2_fh;
>> -
>>   /**
>>    * struct vb2_queue - a videobuf queue
>>    *
>> @@ -400,7 +377,7 @@ struct v4l2_fh;
>>    * @threadio:	thread io internal data, used only if thread is active
>>    */
>>   struct vb2_queue {
>> -	enum v4l2_buf_type		type;
>> +	unsigned int			type;
>>   	unsigned int			io_modes;
>>   	unsigned int			io_flags;
>>   	struct mutex			*lock;
>> @@ -416,8 +393,8 @@ struct vb2_queue {
>>   
>>   /* private: internal use only */
>>   	struct mutex			mmap_lock;
>> -	enum v4l2_memory		memory;
>> -	void					*bufs[VIDEO_MAX_FRAME];
>> +	unsigned int			memory;
>> +	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
> OK. IMHO, this change (struct vb2_buffer) should be part of
> the first patch.
>
>>   	unsigned int			num_buffers;
>>   
>>   	struct list_head		queued_list;
>> @@ -451,212 +428,4 @@ struct vb2_queue {
>>   	u32				cnt_stop_streaming;
>>   #endif
>>   };
>> -
>> -void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
>> -void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
>> -
>> -void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state);
>> -void vb2_discard_done(struct vb2_queue *q);
>> -int vb2_wait_for_all_buffers(struct vb2_queue *q);
>> -
>> -int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
>> -int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
>> -
>> -int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
>> -int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
>> -
>> -int __must_check vb2_queue_init(struct vb2_queue *q);
>> -
>> -void vb2_queue_release(struct vb2_queue *q);
>> -void vb2_queue_error(struct vb2_queue *q);
>> -
>> -int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
>> -int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
>> -int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
>> -
>> -int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
>> -int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
>> -
>> -int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
>> -#ifndef CONFIG_MMU
>> -unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>> -				    unsigned long addr,
>> -				    unsigned long len,
>> -				    unsigned long pgoff,
>> -				    unsigned long flags);
>> -#endif
>> -unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
>> -size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
>> -		loff_t *ppos, int nonblock);
>> -size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
>> -		loff_t *ppos, int nonblock);
>> -/**
>> - * vb2_thread_fnc - callback function for use with vb2_thread
>> - *
>> - * This is called whenever a buffer is dequeued in the thread.
>> - */
>> -typedef int (*vb2_thread_fnc)(struct vb2_v4l2_buffer *vb, void *priv);
>> -
>> -/**
>> - * vb2_thread_start() - start a thread for the given queue.
>> - * @q:		videobuf queue
>> - * @fnc:	callback function
>> - * @priv:	priv pointer passed to the callback function
>> - * @thread_name:the name of the thread. This will be prefixed with "vb2-".
>> - *
>> - * This starts a thread that will queue and dequeue until an error occurs
>> - * or @vb2_thread_stop is called.
>> - *
>> - * This function should not be used for anything else but the videobuf2-dvb
>> - * support. If you think you have another good use-case for this, then please
>> - * contact the linux-media mailinglist first.
>> - */
>> -int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
>> -		     const char *thread_name);
>> -
>> -/**
>> - * vb2_thread_stop() - stop the thread for the given queue.
>> - * @q:		videobuf queue
>> - */
>> -int vb2_thread_stop(struct vb2_queue *q);
>> -
>> -/**
>> - * vb2_is_streaming() - return streaming status of the queue
>> - * @q:		videobuf queue
>> - */
>> -static inline bool vb2_is_streaming(struct vb2_queue *q)
>> -{
>> -	return q->streaming;
>> -}
>> -
>> -/**
>> - * vb2_fileio_is_active() - return true if fileio is active.
>> - * @q:		videobuf queue
>> - *
>> - * This returns true if read() or write() is used to stream the data
>> - * as opposed to stream I/O. This is almost never an important distinction,
>> - * except in rare cases. One such case is that using read() or write() to
>> - * stream a format using V4L2_FIELD_ALTERNATE is not allowed since there
>> - * is no way you can pass the field information of each buffer to/from
>> - * userspace. A driver that supports this field format should check for
>> - * this in the queue_setup op and reject it if this function returns true.
>> - */
>> -static inline bool vb2_fileio_is_active(struct vb2_queue *q)
>> -{
>> -	return q->fileio;
>> -}
>> -
>> -/**
>> - * vb2_is_busy() - return busy status of the queue
>> - * @q:		videobuf queue
>> - *
>> - * This function checks if queue has any buffers allocated.
>> - */
>> -static inline bool vb2_is_busy(struct vb2_queue *q)
>> -{
>> -	return (q->num_buffers > 0);
>> -}
>> -
>> -/**
>> - * vb2_get_drv_priv() - return driver private data associated with the queue
>> - * @q:		videobuf queue
>> - */
>> -static inline void *vb2_get_drv_priv(struct vb2_queue *q)
>> -{
>> -	return q->drv_priv;
>> -}
>> -
>> -/**
>> - * vb2_set_plane_payload() - set bytesused for the plane plane_no
>> - * @vb:		buffer for which plane payload should be set
>> - * @plane_no:	plane number for which payload should be set
>> - * @size:	payload in bytes
>> - */
>> -static inline void vb2_set_plane_payload(struct vb2_v4l2_buffer *vb,
>> -				 unsigned int plane_no, unsigned long size)
>> -{
>> -	if (plane_no < vb->vb2.num_planes)
>> -		vb->v4l2_planes[plane_no].bytesused = size;
>> -}
>> -
>> -/**
>> - * vb2_get_plane_payload() - get bytesused for the plane plane_no
>> - * @vb:		buffer for which plane payload should be set
>> - * @plane_no:	plane number for which payload should be set
>> - * @size:	payload in bytes
>> - */
>> -static inline unsigned long vb2_get_plane_payload(struct vb2_v4l2_buffer *vb,
>> -				 unsigned int plane_no)
>> -{
>> -	if (plane_no < vb->vb2.num_planes)
>> -		return vb->v4l2_planes[plane_no].bytesused;
>> -	return 0;
>> -}
>> -
>> -/**
>> - * vb2_plane_size() - return plane size in bytes
>> - * @vb:		buffer for which plane size should be returned
>> - * @plane_no:	plane number for which size should be returned
>> - */
>> -static inline unsigned long
>> -vb2_plane_size(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>> -{
>> -	if (plane_no < vb->vb2.num_planes)
>> -		return vb->v4l2_planes[plane_no].length;
>> -	return 0;
>> -}
>> -
>> -/**
>> - * vb2_start_streaming_called() - return streaming status of driver
>> - * @q:		videobuf queue
>> - */
>> -static inline bool vb2_start_streaming_called(struct vb2_queue *q)
>> -{
>> -	return q->start_streaming_called;
>> -}
>> -
>> -/*
>> - * The following functions are not part of the vb2 core API, but are simple
>> - * helper functions that you can use in your struct v4l2_file_operations,
>> - * struct v4l2_ioctl_ops and struct vb2_ops. They will serialize if vb2_queue->lock
>> - * or video_device->lock is set, and they will set and test vb2_queue->owner
>> - * to check if the calling filehandle is permitted to do the queuing operation.
>> - */
>> -
>> -/* struct v4l2_ioctl_ops helpers */
>> -
>> -int vb2_ioctl_reqbufs(struct file *file, void *priv,
>> -			  struct v4l2_requestbuffers *p);
>> -int vb2_ioctl_create_bufs(struct file *file, void *priv,
>> -			  struct v4l2_create_buffers *p);
>> -int vb2_ioctl_prepare_buf(struct file *file, void *priv,
>> -			  struct v4l2_buffer *p);
>> -int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
>> -int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
>> -int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
>> -int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
>> -int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
>> -int vb2_ioctl_expbuf(struct file *file, void *priv,
>> -	struct v4l2_exportbuffer *p);
>> -
>> -/* struct v4l2_file_operations helpers */
>> -
>> -int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
>> -int vb2_fop_release(struct file *file);
>> -int _vb2_fop_release(struct file *file, struct mutex *lock);
>> -ssize_t vb2_fop_write(struct file *file, const char __user *buf,
>> -		size_t count, loff_t *ppos);
>> -ssize_t vb2_fop_read(struct file *file, char __user *buf,
>> -		size_t count, loff_t *ppos);
>> -unsigned int vb2_fop_poll(struct file *file, poll_table *wait);
>> -#ifndef CONFIG_MMU
>> -unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
>> -		unsigned long len, unsigned long pgoff, unsigned long flags);
>> -#endif
>> -
>> -/* struct vb2_ops helpers, only use if vq->lock is non-NULL. */
>> -
>> -void vb2_ops_wait_prepare(struct vb2_queue *vq);
>> -void vb2_ops_wait_finish(struct vb2_queue *vq);
>> -
>>   #endif /* _MEDIA_VIDEOBUF2_CORE_H */
>> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
>> index 3de9111..c2e3476 100644
>> --- a/include/media/videobuf2-dma-contig.h
>> +++ b/include/media/videobuf2-dma-contig.h
>> @@ -17,9 +17,9 @@
>>   #include <linux/dma-mapping.h>
>>   
>>   static inline dma_addr_t
>> -vb2_dma_contig_plane_dma_addr(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>> +vb2_dma_contig_plane_dma_addr(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
>>   {
>> -	dma_addr_t *addr = vb2_plane_cookie(vb, plane_no);
>> +	dma_addr_t *addr = vb2_plane_cookie(cb, plane_no);
>>   
>>   	return *addr;
>>   }
> Just renaming. As said before, the best is to put those renames on
> a separate patch that would be fixing the namespace.
OK, I split the patch into two or more pieces. One of them will be just 
changing
the namespace.
>> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
>> index 80b08cb..cd2b6b9 100644
>> --- a/include/media/videobuf2-v4l2.h
>> +++ b/include/media/videobuf2-v4l2.h
>> @@ -17,214 +17,7 @@
>>   #include <linux/poll.h>
>>   #include <linux/videodev2.h>
>>   #include <linux/dma-buf.h>
>> -
>> -struct vb2_alloc_ctx;
>> -struct vb2_fileio_data;
>> -struct vb2_threadio_data;
>> -
>> -/**
>> - * struct vb2_mem_ops - memory handling/memory allocator operations
>> - * @alloc:	allocate video memory and, optionally, allocator private data,
>> - *		return NULL on failure or a pointer to allocator private,
>> - *		per-buffer data on success; the returned private structure
>> - *		will then be passed as buf_priv argument to other ops in this
>> - *		structure. Additional gfp_flags to use when allocating the
>> - *		are also passed to this operation. These flags are from the
>> - *		gfp_flags field of vb2_queue.
>> - * @put:	inform the allocator that the buffer will no longer be used;
>> - *		usually will result in the allocator freeing the buffer (if
>> - *		no other users of this buffer are present); the buf_priv
>> - *		argument is the allocator private per-buffer structure
>> - *		previously returned from the alloc callback.
>> - * @get_userptr: acquire userspace memory for a hardware operation; used for
>> - *		 USERPTR memory types; vaddr is the address passed to the
>> - *		 videobuf layer when queuing a video buffer of USERPTR type;
>> - *		 should return an allocator private per-buffer structure
>> - *		 associated with the buffer on success, NULL on failure;
>> - *		 the returned private structure will then be passed as buf_priv
>> - *		 argument to other ops in this structure.
>> - * @put_userptr: inform the allocator that a USERPTR buffer will no longer
>> - *		 be used.
>> - * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
>> - *		   used for DMABUF memory types; alloc_ctx is the alloc context
>> - *		   dbuf is the shared dma_buf; returns NULL on failure;
>> - *		   allocator private per-buffer structure on success;
>> - *		   this needs to be used for further accesses to the buffer.
>> - * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
>> - *		   buffer is no longer used; the buf_priv argument is the
>> - *		   allocator private per-buffer structure previously returned
>> - *		   from the attach_dmabuf callback.
>> - * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
>> - *		of dmabuf is informed that this driver is going to use the
>> - *		dmabuf.
>> - * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
>> - *		  that this driver is done using the dmabuf for now.
>> - * @prepare:	called every time the buffer is passed from userspace to the
>> - *		driver, useful for cache synchronisation, optional.
>> - * @finish:	called every time the buffer is passed back from the driver
>> - *		to the userspace, also optional.
>> - * @vaddr:	return a kernel virtual address to a given memory buffer
>> - *		associated with the passed private structure or NULL if no
>> - *		such mapping exists.
>> - * @cookie:	return allocator specific cookie for a given memory buffer
>> - *		associated with the passed private structure or NULL if not
>> - *		available.
>> - * @num_users:	return the current number of users of a memory buffer;
>> - *		return 1 if the videobuf layer (or actually the driver using
>> - *		it) is the only user.
>> - * @mmap:	setup a userspace mapping for a given memory buffer under
>> - *		the provided virtual memory region.
>> - *
>> - * Required ops for USERPTR types: get_userptr, put_userptr.
>> - * Required ops for MMAP types: alloc, put, num_users, mmap.
>> - * Required ops for read/write access types: alloc, put, num_users, vaddr.
>> - * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
>> - *				  unmap_dmabuf.
>> - */
>> -struct vb2_mem_ops {
>> -	void		*(*alloc)(void *alloc_ctx, unsigned long size,
>> -				  enum dma_data_direction dma_dir,
>> -				  gfp_t gfp_flags);
>> -	void		(*put)(void *buf_priv);
>> -	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
>> -
>> -	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
>> -					unsigned long size,
>> -					enum dma_data_direction dma_dir);
>> -	void		(*put_userptr)(void *buf_priv);
>> -
>> -	void		(*prepare)(void *buf_priv);
>> -	void		(*finish)(void *buf_priv);
>> -
>> -	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
>> -					  unsigned long size,
>> -					  enum dma_data_direction dma_dir);
>> -	void		(*detach_dmabuf)(void *buf_priv);
>> -	int		(*map_dmabuf)(void *buf_priv);
>> -	void		(*unmap_dmabuf)(void *buf_priv);
>> -
>> -	void		*(*vaddr)(void *buf_priv);
>> -	void		*(*cookie)(void *buf_priv);
>> -
>> -	unsigned int	(*num_users)(void *buf_priv);
>> -
>> -	int		(*mmap)(void *buf_priv, struct vm_area_struct *vma);
>> -};
>> -
>> -struct vb2_plane {
>> -	void			*mem_priv;
>> -	struct dma_buf		*dbuf;
>> -	unsigned int		dbuf_mapped;
>> -};
>> -
>> -/**
>> - * enum vb2_io_modes - queue access methods
>> - * @VB2_MMAP:		driver supports MMAP with streaming API
>> - * @VB2_USERPTR:	driver supports USERPTR with streaming API
>> - * @VB2_READ:		driver supports read() style access
>> - * @VB2_WRITE:		driver supports write() style access
>> - * @VB2_DMABUF:		driver supports DMABUF with streaming API
>> - */
>> -enum vb2_io_modes {
>> -	VB2_MMAP	= (1 << 0),
>> -	VB2_USERPTR	= (1 << 1),
>> -	VB2_READ	= (1 << 2),
>> -	VB2_WRITE	= (1 << 3),
>> -	VB2_DMABUF	= (1 << 4),
>> -};
>> -
>> -/**
>> - * enum vb2_fileio_flags - flags for selecting a mode of the file io emulator,
>> - * by default the 'streaming' style is used by the file io emulator
>> - * @VB2_FILEIO_READ_ONCE:	report EOF after reading the first buffer
>> - * @VB2_FILEIO_WRITE_IMMEDIATELY:	queue buffer after each write() call
>> - */
>> -enum vb2_fileio_flags {
>> -	VB2_FILEIO_READ_ONCE		= (1 << 0),
>> -	VB2_FILEIO_WRITE_IMMEDIATELY	= (1 << 1),
>> -};
>> -
>> -/**
>> - * enum vb2_buffer_state - current video buffer state
>> - * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
>> - * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
>> - * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver
>> - * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
>> - * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
>> - *				in a hardware operation
>> - * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
>> - *				not yet dequeued to userspace
>> - * @VB2_BUF_STATE_ERROR:	same as above, but the operation on the buffer
>> - *				has ended with an error, which will be reported
>> - *				to the userspace when it is dequeued
>> - */
>> -enum vb2_buffer_state {
>> -	VB2_BUF_STATE_DEQUEUED,
>> -	VB2_BUF_STATE_PREPARING,
>> -	VB2_BUF_STATE_PREPARED,
>> -	VB2_BUF_STATE_QUEUED,
>> -	VB2_BUF_STATE_ACTIVE,
>> -	VB2_BUF_STATE_DONE,
>> -	VB2_BUF_STATE_ERROR,
>> -};
>> -
>> -struct vb2_queue;
>> -
>> -/**
>> - * struct vb2_buffer - represents a common video buffer
>> - * @vb2_queue:		the queue to which this driver belongs
>> - * @num_planes:		number of planes in the buffer
>> - *			on an internal driver queue
>> - * @state:		current buffer state; do not change
>> - * @queued_entry:	entry on the queued buffers list, which holds all
>> - *			buffers queued from userspace
>> - * @done_entry:		entry on the list that stores all buffers ready to
>> - *			be dequeued to userspace
>> - * @planes:		private per-plane information; do not change
>> - */
>> -struct vb2_buffer {
>> -	struct vb2_queue	*vb2_queue;
>> -	unsigned int		num_planes;
>> -
>> -/* Private: internal use only */
>> -	enum vb2_buffer_state	state;
>> -
>> -	struct list_head	queued_entry;
>> -	struct list_head	done_entry;
>> -
>> -	struct vb2_plane	planes[VIDEO_MAX_PLANES];
>> -
>> -#ifdef CONFIG_VIDEO_ADV_DEBUG
>> -	/*
>> -	 * Counters for how often these buffer-related ops are
>> -	 * called. Used to check for unbalanced ops.
>> -	 */
>> -	u32		cnt_mem_alloc;
>> -	u32		cnt_mem_put;
>> -	u32		cnt_mem_get_dmabuf;
>> -	u32		cnt_mem_get_userptr;
>> -	u32		cnt_mem_put_userptr;
>> -	u32		cnt_mem_prepare;
>> -	u32		cnt_mem_finish;
>> -	u32		cnt_mem_attach_dmabuf;
>> -	u32		cnt_mem_detach_dmabuf;
>> -	u32		cnt_mem_map_dmabuf;
>> -	u32		cnt_mem_unmap_dmabuf;
>> -	u32		cnt_mem_vaddr;
>> -	u32		cnt_mem_cookie;
>> -	u32		cnt_mem_num_users;
>> -	u32		cnt_mem_mmap;
>> -
>> -	u32		cnt_buf_init;
>> -	u32		cnt_buf_prepare;
>> -	u32		cnt_buf_finish;
>> -	u32		cnt_buf_cleanup;
>> -	u32		cnt_buf_queue;
>> -
>> -	/* This counts the number of calls to vb2_buffer_done() */
>> -	u32		cnt_buf_done;
>> -#endif
>> -};
>> +#include <media/videobuf2-core.h>
>>   
>>   /**
>>    * struct vb2_v4l2_buffer - represents a video buffer for v4l2
>> @@ -247,215 +40,10 @@ struct vb2_v4l2_buffer {
>>   	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
>>   };
>>   
>> -/**
>> - * struct vb2_ops - driver-specific callbacks
>> - *
>> - * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
>> - *			handlers before memory allocation, or, if
>> - *			*num_planes != 0, after the allocation to verify a
>> - *			smaller number of buffers. Driver should return
>> - *			the required number of buffers in *num_buffers, the
>> - *			required number of planes per buffer in *num_planes; the
>> - *			size of each plane should be set in the sizes[] array
>> - *			and optional per-plane allocator specific context in the
>> - *			alloc_ctxs[] array. When called from VIDIOC_REQBUFS,
>> - *			fmt == NULL, the driver has to use the currently
>> - *			configured format and *num_buffers is the total number
>> - *			of buffers, that are being allocated. When called from
>> - *			VIDIOC_CREATE_BUFS, fmt != NULL and it describes the
>> - *			target frame format (if the format isn't valid the
>> - *			callback must return -EINVAL). In this case *num_buffers
>> - *			are being allocated additionally to q->num_buffers.
>> - * @wait_prepare:	release any locks taken while calling vb2 functions;
>> - *			it is called before an ioctl needs to wait for a new
>> - *			buffer to arrive; required to avoid a deadlock in
>> - *			blocking access type.
>> - * @wait_finish:	reacquire all locks released in the previous callback;
>> - *			required to continue operation after sleeping while
>> - *			waiting for a new buffer to arrive.
>> - * @buf_init:		called once after allocating a buffer (in MMAP case)
>> - *			or after acquiring a new USERPTR buffer; drivers may
>> - *			perform additional buffer-related initialization;
>> - *			initialization failure (return != 0) will prevent
>> - *			queue setup from completing successfully; optional.
>> - * @buf_prepare:	called every time the buffer is queued from userspace
>> - *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
>> - *			perform any initialization required before each
>> - *			hardware operation in this callback; drivers can
>> - *			access/modify the buffer here as it is still synced for
>> - *			the CPU; drivers that support VIDIOC_CREATE_BUFS must
>> - *			also validate the buffer size; if an error is returned,
>> - *			the buffer will not be queued in driver; optional.
>> - * @buf_finish:		called before every dequeue of the buffer back to
>> - *			userspace; the buffer is synced for the CPU, so drivers
>> - *			can access/modify the buffer contents; drivers may
>> - *			perform any operations required before userspace
>> - *			accesses the buffer; optional. The buffer state can be
>> - *			one of the following: DONE and ERROR occur while
>> - *			streaming is in progress, and the PREPARED state occurs
>> - *			when the queue has been canceled and all pending
>> - *			buffers are being returned to their default DEQUEUED
>> - *			state. Typically you only have to do something if the
>> - *			state is VB2_BUF_STATE_DONE, since in all other cases
>> - *			the buffer contents will be ignored anyway.
>> - * @buf_cleanup:	called once before the buffer is freed; drivers may
>> - *			perform any additional cleanup; optional.
>> - * @start_streaming:	called once to enter 'streaming' state; the driver may
>> - *			receive buffers with @buf_queue callback before
>> - *			@start_streaming is called; the driver gets the number
>> - *			of already queued buffers in count parameter; driver
>> - *			can return an error if hardware fails, in that case all
>> - *			buffers that have been already given by the @buf_queue
>> - *			callback are to be returned by the driver by calling
>> - *			@vb2_buffer_done(VB2_BUF_STATE_QUEUED).
>> - *			If you need a minimum number of buffers before you can
>> - *			start streaming, then set @min_buffers_needed in the
>> - *			vb2_queue structure. If that is non-zero then
>> - *			start_streaming won't be called until at least that
>> - *			many buffers have been queued up by userspace.
>> - * @stop_streaming:	called when 'streaming' state must be disabled; driver
>> - *			should stop any DMA transactions or wait until they
>> - *			finish and give back all buffers it got from buf_queue()
>> - *			callback by calling @vb2_buffer_done() with either
>> - *			VB2_BUF_STATE_DONE or VB2_BUF_STATE_ERROR; may use
>> - *			vb2_wait_for_all_buffers() function
>> - * @buf_queue:		passes buffer vb to the driver; driver may start
>> - *			hardware operation on this buffer; driver should give
>> - *			the buffer back by calling vb2_buffer_done() function;
>> - *			it is allways called after calling STREAMON ioctl;
>> - *			might be called before start_streaming callback if user
>> - *			pre-queued buffers before calling STREAMON.
>> - */
>> -struct vb2_ops {
>> -	int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
>> -			   unsigned int *num_buffers, unsigned int *num_planes,
>> -			   unsigned int sizes[], void *alloc_ctxs[]);
>> -
>> -	void (*wait_prepare)(struct vb2_queue *q);
>> -	void (*wait_finish)(struct vb2_queue *q);
>> -
>> -	int (*buf_init)(struct vb2_v4l2_buffer *vb);
>> -	int (*buf_prepare)(struct vb2_v4l2_buffer *vb);
>> -	void (*buf_finish)(struct vb2_v4l2_buffer *vb);
>> -	void (*buf_cleanup)(struct vb2_v4l2_buffer *vb);
>> -
>> -	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
>> -	void (*stop_streaming)(struct vb2_queue *q);
>> -
>> -	void (*buf_queue)(struct vb2_v4l2_buffer *vb);
>> -};
>> -
>> -struct v4l2_fh;
>> -
>> -/**
>> - * struct vb2_queue - a videobuf queue
>> - *
>> - * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
>> - * @io_modes:	supported io methods (see vb2_io_modes enum)
>> - * @io_flags:	additional io flags (see vb2_fileio_flags enum)
>> - * @lock:	pointer to a mutex that protects the vb2_queue struct. The
>> - *		driver can set this to a mutex to let the v4l2 core serialize
>> - *		the queuing ioctls. If the driver wants to handle locking
>> - *		itself, then this should be set to NULL. This lock is not used
>> - *		by the videobuf2 core API.
>> - * @owner:	The filehandle that 'owns' the buffers, i.e. the filehandle
>> - *		that called reqbufs, create_buffers or started fileio.
>> - *		This field is not used by the videobuf2 core API, but it allows
>> - *		drivers to easily associate an owner filehandle with the queue.
>> - * @ops:	driver-specific callbacks
>> - * @mem_ops:	memory allocator specific callbacks
>> - * @drv_priv:	driver private data
>> - * @buf_struct_size: size of the driver-specific buffer structure;
>> - *		"0" indicates the driver doesn't want to use a custom buffer
>> - *		structure type, so sizeof(struct vb2_v4l2_buffer) will is used
>> - * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
>> - *		V4L2_BUF_FLAG_TSTAMP_SRC_*
>> - * @gfp_flags:	additional gfp flags used when allocating the buffers.
>> - *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
>> - *		to force the buffer allocation to a specific memory zone.
>> - * @min_buffers_needed: the minimum number of buffers needed before
>> - *		start_streaming() can be called. Used when a DMA engine
>> - *		cannot be started unless at least this number of buffers
>> - *		have been queued into the driver.
>> - *
>> - * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
>> - * @memory:	current memory type used
>> - * @bufs:	videobuf buffer structures
>> - * @num_buffers: number of allocated/used buffers
>> - * @queued_list: list of buffers currently queued from userspace
>> - * @queued_count: number of buffers queued and ready for streaming.
>> - * @owned_by_drv_count: number of buffers owned by the driver
>> - * @done_list:	list of buffers ready to be dequeued to userspace
>> - * @done_lock:	lock to protect done_list list
>> - * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
>> - * @alloc_ctx:	memory type/allocator-specific contexts for each plane
>> - * @streaming:	current streaming state
>> - * @start_streaming_called: start_streaming() was called successfully and we
>> - *		started streaming.
>> - * @error:	a fatal error occurred on the queue
>> - * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
>> - *		buffers. Only set for capture queues if qbuf has not yet been
>> - *		called since poll() needs to return POLLERR in that situation.
>> - * @fileio:	file io emulator internal data, used only if emulator is active
>> - * @threadio:	thread io internal data, used only if thread is active
>> - */
>> -struct vb2_queue {
>> -	enum v4l2_buf_type		type;
>> -	unsigned int			io_modes;
>> -	unsigned int			io_flags;
>> -	struct mutex			*lock;
>> -	void					*owner;
>> -
>> -	const struct vb2_ops		*ops;
>> -	const struct vb2_mem_ops	*mem_ops;
>> -	void				*drv_priv;
>> -	unsigned int			buf_struct_size;
>> -	u32				timestamp_flags;
>> -	gfp_t				gfp_flags;
>> -	u32				min_buffers_needed;
>> -
>> -/* private: internal use only */
>> -	struct mutex			mmap_lock;
>> -	enum v4l2_memory		memory;
>> -	void					*bufs[VIDEO_MAX_FRAME];
>> -	unsigned int			num_buffers;
>> -
>> -	struct list_head		queued_list;
>> -	unsigned int			queued_count;
>> -
>> -	atomic_t			owned_by_drv_count;
>> -	struct list_head		done_list;
>> -	spinlock_t			done_lock;
>> -	wait_queue_head_t		done_wq;
>> -
>> -	void				*alloc_ctx[VIDEO_MAX_PLANES];
>> -	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
>> -
>> -	unsigned int			streaming:1;
>> -	unsigned int			start_streaming_called:1;
>> -	unsigned int			error:1;
>> -	unsigned int			waiting_for_buffers:1;
>> -
>> -	struct vb2_fileio_data		*fileio;
>> -	struct vb2_threadio_data	*threadio;
>> -
>> -#ifdef CONFIG_VIDEO_ADV_DEBUG
>> -	/*
>> -	 * Counters for how often these queue-related ops are
>> -	 * called. Used to check for unbalanced ops.
>> -	 */
>> -	u32				cnt_queue_setup;
>> -	u32				cnt_wait_prepare;
>> -	u32				cnt_wait_finish;
>> -	u32				cnt_start_streaming;
>> -	u32				cnt_stop_streaming;
>> -#endif
>> -};
>> -
>> -void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
>> -void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
>> +void *vb2_plane_vaddr(struct vb2_v4l2_buffer *cb, unsigned int plane_no);
>> +void *vb2_plane_cookie(struct vb2_v4l2_buffer *cb, unsigned int plane_no);
>>   
>> -void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state);
>> +void vb2_buffer_done(struct vb2_v4l2_buffer *cb, enum vb2_buffer_state state);
>>   void vb2_discard_done(struct vb2_queue *q);
>>   int vb2_wait_for_all_buffers(struct vb2_queue *q);
>>   
>> @@ -495,7 +83,7 @@ size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
>>    *
>>    * This is called whenever a buffer is dequeued in the thread.
>>    */
>> -typedef int (*vb2_thread_fnc)(struct vb2_v4l2_buffer *vb, void *priv);
>> +typedef int (*vb2_thread_fnc)(struct vb2_v4l2_buffer *cb, void *priv);
>>   
>>   /**
>>    * vb2_thread_start() - start a thread for the given queue.
>> @@ -572,11 +160,11 @@ static inline void *vb2_get_drv_priv(struct vb2_queue *q)
>>    * @plane_no:	plane number for which payload should be set
>>    * @size:	payload in bytes
>>    */
>> -static inline void vb2_set_plane_payload(struct vb2_v4l2_buffer *vb,
>> +static inline void vb2_set_plane_payload(struct vb2_v4l2_buffer *cb,
>>   				 unsigned int plane_no, unsigned long size)
>>   {
>> -	if (plane_no < vb->vb2.num_planes)
>> -		vb->v4l2_planes[plane_no].bytesused = size;
>> +	if (plane_no < cb->vb2.num_planes)
>> +		cb->v4l2_planes[plane_no].bytesused = size;
>>   }
>>   
>>   /**
>> @@ -585,11 +173,11 @@ static inline void vb2_set_plane_payload(struct vb2_v4l2_buffer *vb,
>>    * @plane_no:	plane number for which payload should be set
>>    * @size:	payload in bytes
>>    */
>> -static inline unsigned long vb2_get_plane_payload(struct vb2_v4l2_buffer *vb,
>> +static inline unsigned long vb2_get_plane_payload(struct vb2_v4l2_buffer *cb,
>>   				 unsigned int plane_no)
>>   {
>> -	if (plane_no < vb->vb2.num_planes)
>> -		return vb->v4l2_planes[plane_no].bytesused;
>> +	if (plane_no < cb->vb2.num_planes)
>> +		return cb->v4l2_planes[plane_no].bytesused;
>>   	return 0;
>>   }
>>   
>> @@ -599,10 +187,10 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_v4l2_buffer *vb,
>>    * @plane_no:	plane number for which size should be returned
>>    */
>>   static inline unsigned long
>> -vb2_plane_size(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>> +vb2_plane_size(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
>>   {
>> -	if (plane_no < vb->vb2.num_planes)
>> -		return vb->v4l2_planes[plane_no].length;
>> +	if (plane_no < cb->vb2.num_planes)
>> +		return cb->v4l2_planes[plane_no].length;
>>   	return 0;
>>   }
>>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
