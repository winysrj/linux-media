Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.math.uni-bielefeld.de ([129.70.45.10]:45537 "EHLO
        smtp.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750794AbdKCPVN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Nov 2017 11:21:13 -0400
Subject: Re: [PATCH v2] media: s5p-mfc: Add support for V4L2_MEMORY_DMABUF
 type
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Marian Mihailescu <mihailescu2m@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        JaeChul Lee <jcsing.lee@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
References: <CGME20171103081132eucas1p2212e32d26e7921340336d78d0d92cb1b@eucas1p2.samsung.com>
 <20171103081124.30119-1-m.szyprowski@samsung.com>
 <1509716721.3607.6.camel@ndufresne.ca>
From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Message-ID: <d95ce7de-38cb-00e6-0c8d-a1d6d9f35d69@math.uni-bielefeld.de>
Date: Fri, 3 Nov 2017 16:20:52 +0100
MIME-Version: 1.0
In-Reply-To: <1509716721.3607.6.camel@ndufresne.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nicolas Dufresne wrote:
> Le vendredi 03 novembre 2017 à 09:11 +0100, Marek Szyprowski a écrit :
>> MFC driver supports only MMAP operation mode mainly due to the hardware
>> restrictions of the addresses of the DMA buffers (MFC v5 hardware can
>> access buffers only in 128MiB memory region starting from the base address
>> of its firmware). When IOMMU is available, this requirement is easily
>> fulfilled even for the buffers located anywhere in the memory - typically
>> by mapping them in the DMA address space as close as possible to the
>> firmware. Later hardware revisions don't have this limitations at all.
>>
>> The second limitation of the MFC hardware related to the memory buffers
>> is constant buffer address. Once the hardware has been initialized for
>> operation on given buffer set, the addresses of the buffers cannot be
>> changed.
>>
>> With the above assumptions, a limited support for USERPTR and DMABUF
>> operation modes can be added. The main requirement is to have all buffers
>> known when starting hardware. This has been achieved by postponing
>> hardware initialization once all the DMABUF or USERPTR buffers have been
>> queued for the first time. Once then, buffers cannot be modified to point
>> to other memory area.
> 
> I am concerned about enabling this support with existing userspace.
> Userspace application will be left with some driver with this
> limitation and other drivers without. I think it is harmful to enable
> that feature without providing userspace the ability to know.
I voiced similar concern in my previous mail. I have to admit that I know very
little about V4L2, but when I investigated this some time ago I saw that
previously used/queued DMABUF buffers can be removed again, and, under certain
conditions are 'reacquired', which issues a buf_cleanup() -- which does nothing
atm. My guess is that, in the worst case, one could trigger an IOMMU pagefault
(or simply memory corruption, if not under IOMMU) this way.

Like Marek says, the hw needs to know DMA adresses of all available buffers on
hw init. Hence a proper implementation would need to trigger some
re-initialization once these adresses changes (DMABUFs removed/reacquired/etc.).
These extra constraints which are introduced here, IMO they violate the API then.



> This is specially conflicting with let's say UVC driver providing
> buffers, since UVC driver implementing CREATE_BUFS ioctl. So even if
> userspace start making an effort to maintain the same DMABuf for the
> same buffer index, if a new buffer is created, we won't be able to use
> it.
> 
>>
>> This patch also removes unconditional USERPTR operation mode from encoder
>> video node, because it doesn't work with v5 MFC hardware without IOMMU
>> being enabled.
>>
>> In case of MFC v5 a bidirectional queue flag has to be enabled as a
>> workaround of the strange hardware behavior - MFC performs a few writes
>> to source data during the operation.
> 
> Do you have more information about this ? It is quite terrible, since
> if you enable buffer importation, the buffer might be multi-plex across
> multiple encoder instance. That is another way this feature can be
> harmful to existing userspace.
IIRC the hw stores some "housekeeping" data in the input buffers used during
decoding. So input buffers are not strictly "input", but also output, in the
following sense. If the buffer has total size N, and the data stored inside has
size n (with n < N), then the hw uses the remaining N-n bytes at the end of the
buffer for this housekeeping data. I'm not sure what happens if n equals N, or
if that's even possible.

With best wishes,
Tobias


> 
>>
>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> [mszyprow: adapted to v4.14 code base, rewrote and extended commit message,
>>  added checks for changing buffer addresses, added bidirectional queue
>>  flags and comments]
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>> v2:
>> - fixed copy/paste bug, which broke encoding support (thanks to Marian
>>   Mihailescu for reporting it)
>> - added checks for changing buffers DMA addresses
>> - added bidirectional queue flags
>>
>> v1:
>> - inital version
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c     |  23 +++++-
>>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 111 +++++++++++++++++++--------
>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |  64 +++++++++++----
>>  3 files changed, 147 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index 1839a86cc2a5..f1ab8d198158 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -754,6 +754,7 @@ static int s5p_mfc_open(struct file *file)
>>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>>  	struct s5p_mfc_ctx *ctx = NULL;
>>  	struct vb2_queue *q;
>> +	unsigned int io_modes;
>>  	int ret = 0;
>>  
>>  	mfc_debug_enter();
>> @@ -839,16 +840,25 @@ static int s5p_mfc_open(struct file *file)
>>  		if (ret)
>>  			goto err_init_hw;
>>  	}
>> +
>> +	io_modes = VB2_MMAP;
>> +	if (exynos_is_iommu_available(&dev->plat_dev->dev) || !IS_TWOPORT(dev))
>> +		io_modes |= VB2_USERPTR | VB2_DMABUF;
>> +
>>  	/* Init videobuf2 queue for CAPTURE */
>>  	q = &ctx->vq_dst;
>>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>> +	q->io_modes = io_modes;
>> +	/*
>> +	 * Destination buffers are always bidirectional, they use used as
>> +	 * reference data, which require READ access
>> +	 */
>> +	q->bidirectional = true;
>>  	q->drv_priv = &ctx->fh;
>>  	q->lock = &dev->mfc_mutex;
>>  	if (vdev == dev->vfd_dec) {
>> -		q->io_modes = VB2_MMAP;
>>  		q->ops = get_dec_queue_ops();
>>  	} else if (vdev == dev->vfd_enc) {
>> -		q->io_modes = VB2_MMAP | VB2_USERPTR;
>>  		q->ops = get_enc_queue_ops();
>>  	} else {
>>  		ret = -ENOENT;
>> @@ -869,13 +879,18 @@ static int s5p_mfc_open(struct file *file)
>>  	/* Init videobuf2 queue for OUTPUT */
>>  	q = &ctx->vq_src;
>>  	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>> +	q->io_modes = io_modes;
>> +	/*
>> +	 * MFV v5 performs write operations on source data, so make queue
>> +	 * bidirectional to avoid IOMMU protection fault.
>> +	 */
>> +	if (!IS_MFCV6_PLUS(dev))
>> +		q->bidirectional = true;
>>  	q->drv_priv = &ctx->fh;
>>  	q->lock = &dev->mfc_mutex;
>>  	if (vdev == dev->vfd_dec) {
>> -		q->io_modes = VB2_MMAP;
>>  		q->ops = get_dec_queue_ops();
>>  	} else if (vdev == dev->vfd_enc) {
>> -		q->io_modes = VB2_MMAP | VB2_USERPTR;
>>  		q->ops = get_enc_queue_ops();
>>  	} else {
>>  		ret = -ENOENT;
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> index e3e5c442902a..26ee8315e2cf 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> @@ -551,14 +551,27 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
>>  			goto out;
>>  		}
>>  
>> -		WARN_ON(ctx->dst_bufs_cnt != ctx->total_dpb_count);
>> -		ctx->capture_state = QUEUE_BUFS_MMAPED;
>> +		if (reqbufs->memory == V4L2_MEMORY_MMAP) {
>> +			if (ctx->dst_bufs_cnt == ctx->total_dpb_count) {
>> +				ctx->capture_state = QUEUE_BUFS_MMAPED;
>> +			} else {
>> +				mfc_err("Not all buffers passed to buf_init\n");
>> +				reqbufs->count = 0;
>> +				ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
>> +				s5p_mfc_hw_call(dev->mfc_ops,
>> +						release_codec_buffers, ctx);
>> +				ret = -ENOMEM;
>> +				goto out;
>> +			}
>> +		}
>>  
>>  		if (s5p_mfc_ctx_ready(ctx))
>>  			set_work_bit_irqsave(ctx);
>>  		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> -		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_INIT_BUFFERS_RET,
>> -					  0);
>> +		if (reqbufs->memory == V4L2_MEMORY_MMAP) {
>> +			s5p_mfc_wait_for_done_ctx(ctx,
>> +					 S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
>> +		}
>>  	} else {
>>  		mfc_err("Buffers have already been requested\n");
>>  		ret = -EINVAL;
>> @@ -576,15 +589,19 @@ static int vidioc_reqbufs(struct file *file, void *priv,
>>  {
>>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
>> -
>> -	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
>> -		mfc_debug(2, "Only V4L2_MEMORY_MMAP is supported\n");
>> -		return -EINVAL;
>> -	}
>> +	int ret;
>>  
>>  	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +		ret = vb2_verify_memory_type(&ctx->vq_src, reqbufs->memory,
>> +					     reqbufs->type);
>> +		if (ret)
>> +			return ret;
>>  		return reqbufs_output(dev, ctx, reqbufs);
>>  	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		ret = vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
>> +					     reqbufs->type);
>> +		if (ret)
>> +			return ret;
>>  		return reqbufs_capture(dev, ctx, reqbufs);
>>  	} else {
>>  		mfc_err("Invalid type requested\n");
>> @@ -600,16 +617,20 @@ static int vidioc_querybuf(struct file *file, void *priv,
>>  	int ret;
>>  	int i;
>>  
>> -	if (buf->memory != V4L2_MEMORY_MMAP) {
>> -		mfc_err("Only mmaped buffers can be used\n");
>> -		return -EINVAL;
>> -	}
>>  	mfc_debug(2, "State: %d, buf->type: %d\n", ctx->state, buf->type);
>>  	if (ctx->state == MFCINST_GOT_INST &&
>>  			buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +		ret = vb2_verify_memory_type(&ctx->vq_src, buf->memory,
>> +					     buf->type);
>> +		if (ret)
>> +			return ret;
>>  		ret = vb2_querybuf(&ctx->vq_src, buf);
>>  	} else if (ctx->state == MFCINST_RUNNING &&
>>  			buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		ret = vb2_verify_memory_type(&ctx->vq_dst, buf->memory,
>> +					     buf->type);
>> +		if (ret)
>> +			return ret;
>>  		ret = vb2_querybuf(&ctx->vq_dst, buf);
>>  		for (i = 0; i < buf->length; i++)
>>  			buf->m.planes[i].m.mem_offset += DST_QUEUE_OFF_BASE;
>> @@ -940,10 +961,12 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
>>  		else
>>  			alloc_devs[0] = ctx->dev->mem_dev[BANK_R_CTX];
>>  		alloc_devs[1] = ctx->dev->mem_dev[BANK_L_CTX];
>> +		memset(ctx->dst_bufs, 0, sizeof(ctx->dst_bufs));
>>  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
>>  		   ctx->state == MFCINST_INIT) {
>>  		psize[0] = ctx->dec_src_buf_size;
>>  		alloc_devs[0] = ctx->dev->mem_dev[BANK_L_CTX];
>> +		memset(ctx->src_bufs, 0, sizeof(ctx->src_bufs));
>>  	} else {
>>  		mfc_err("This video node is dedicated to decoding. Decoding not initialized\n");
>>  		return -EINVAL;
>> @@ -959,30 +982,35 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>>  	unsigned int i;
>>  
>>  	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		dma_addr_t luma, chroma;
>> +
>>  		if (ctx->capture_state == QUEUE_BUFS_MMAPED)
>>  			return 0;
>> -		for (i = 0; i < ctx->dst_fmt->num_planes; i++) {
>> -			if (IS_ERR_OR_NULL(ERR_PTR(
>> -					vb2_dma_contig_plane_dma_addr(vb, i)))) {
>> -				mfc_err("Plane mem not allocated\n");
>> -				return -EINVAL;
>> -			}
>> -		}
>> -		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
>> -			vb2_plane_size(vb, 1) < ctx->chroma_size) {
>> -			mfc_err("Plane buffer (CAPTURE) is too small\n");
>> +
>> +		luma = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +		chroma = vb2_dma_contig_plane_dma_addr(vb, 1);
>> +		if (!luma || !chroma) {
>> +			mfc_err("Plane mem not allocated\n");
>>  			return -EINVAL;
>>  		}
>> +
>>  		i = vb->index;
>> +		if ((ctx->dst_bufs[i].cookie.raw.luma &&
>> +		     ctx->dst_bufs[i].cookie.raw.luma != luma) ||
>> +		    (ctx->dst_bufs[i].cookie.raw.chroma &&
>> +		     ctx->dst_bufs[i].cookie.raw.chroma != chroma)) {
>> +			mfc_err("Changing CAPTURE buffer address during straming is not possible\n");
>> +			return -EINVAL;
>> +		}
>> +
>>  		ctx->dst_bufs[i].b = vbuf;
>> -		ctx->dst_bufs[i].cookie.raw.luma =
>> -					vb2_dma_contig_plane_dma_addr(vb, 0);
>> -		ctx->dst_bufs[i].cookie.raw.chroma =
>> -					vb2_dma_contig_plane_dma_addr(vb, 1);
>> +		ctx->dst_bufs[i].cookie.raw.luma = luma;
>> +		ctx->dst_bufs[i].cookie.raw.chroma = chroma;
>>  		ctx->dst_bufs_cnt++;
>>  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> -		if (IS_ERR_OR_NULL(ERR_PTR(
>> -					vb2_dma_contig_plane_dma_addr(vb, 0)))) {
>> +		dma_addr_t stream = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +
>> +		if (!stream) {
>>  			mfc_err("Plane memory not allocated\n");
>>  			return -EINVAL;
>>  		}
>> @@ -992,9 +1020,14 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>>  		}
>>  
>>  		i = vb->index;
>> +		if (ctx->src_bufs[i].cookie.stream &&
>> +		     ctx->src_bufs[i].cookie.stream != stream) {
>> +			mfc_err("Changing OUTPUT buffer address during straming is not possible\n");
>> +			return -EINVAL;
>> +		}
>> +
>>  		ctx->src_bufs[i].b = vbuf;
>> -		ctx->src_bufs[i].cookie.stream =
>> -					vb2_dma_contig_plane_dma_addr(vb, 0);
>> +		ctx->src_bufs[i].cookie.stream = stream;
>>  		ctx->src_bufs_cnt++;
>>  	} else {
>>  		mfc_err("s5p_mfc_buf_init: unknown queue type\n");
>> @@ -1071,6 +1104,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
>>  	struct s5p_mfc_dev *dev = ctx->dev;
>>  	unsigned long flags;
>>  	struct s5p_mfc_buf *mfc_buf;
>> +	int wait_flag = 0;
>>  
>>  	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>>  		mfc_buf = &ctx->src_bufs[vb->index];
>> @@ -1088,12 +1122,25 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
>>  		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
>>  		ctx->dst_queue_cnt++;
>>  		spin_unlock_irqrestore(&dev->irqlock, flags);
>> +		if ((vq->memory == V4L2_MEMORY_USERPTR ||
>> +			vq->memory == V4L2_MEMORY_DMABUF) &&
>> +			ctx->dst_queue_cnt == ctx->total_dpb_count)
>> +			ctx->capture_state = QUEUE_BUFS_MMAPED;
>>  	} else {
>>  		mfc_err("Unsupported buffer type (%d)\n", vq->type);
>>  	}
>> -	if (s5p_mfc_ctx_ready(ctx))
>> +	if (s5p_mfc_ctx_ready(ctx)) {
>>  		set_work_bit_irqsave(ctx);
>> +		if ((vq->memory == V4L2_MEMORY_USERPTR ||
>> +			vq->memory == V4L2_MEMORY_DMABUF) &&
>> +			ctx->state == MFCINST_HEAD_PARSED &&
>> +			ctx->capture_state == QUEUE_BUFS_MMAPED)
>> +			wait_flag = 1;
>> +	}
>>  	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> +	if (wait_flag)
>> +		s5p_mfc_wait_for_done_ctx(ctx,
>> +				S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
>>  }
>>  
>>  static struct vb2_ops s5p_mfc_dec_qops = {
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> index 7b041e5ee4be..33fc3f3ef48a 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> @@ -1125,11 +1125,11 @@ static int vidioc_reqbufs(struct file *file, void *priv,
>>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
>>  	int ret = 0;
>>  
>> -	/* if memory is not mmp or userptr return error */
>> -	if ((reqbufs->memory != V4L2_MEMORY_MMAP) &&
>> -		(reqbufs->memory != V4L2_MEMORY_USERPTR))
>> -		return -EINVAL;
>>  	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		ret = vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
>> +					     reqbufs->type);
>> +		if (ret)
>> +			return ret;
>>  		if (reqbufs->count == 0) {
>>  			mfc_debug(2, "Freeing buffers\n");
>>  			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
>> @@ -1159,6 +1159,10 @@ static int vidioc_reqbufs(struct file *file, void *priv,
>>  			return -ENOMEM;
>>  		}
>>  	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +		ret = vb2_verify_memory_type(&ctx->vq_src, reqbufs->memory,
>> +					     reqbufs->type);
>> +		if (ret)
>> +			return ret;
>>  		if (reqbufs->count == 0) {
>>  			mfc_debug(2, "Freeing buffers\n");
>>  			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
>> @@ -1190,6 +1194,8 @@ static int vidioc_reqbufs(struct file *file, void *priv,
>>  			mfc_err("error in vb2_reqbufs() for E(S)\n");
>>  			return ret;
>>  		}
>> +		if (reqbufs->memory != V4L2_MEMORY_MMAP)
>> +			ctx->src_bufs_cnt = reqbufs->count;
>>  		ctx->output_state = QUEUE_BUFS_REQUESTED;
>>  	} else {
>>  		mfc_err("invalid buf type\n");
>> @@ -1204,11 +1210,11 @@ static int vidioc_querybuf(struct file *file, void *priv,
>>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
>>  	int ret = 0;
>>  
>> -	/* if memory is not mmp or userptr return error */
>> -	if ((buf->memory != V4L2_MEMORY_MMAP) &&
>> -		(buf->memory != V4L2_MEMORY_USERPTR))
>> -		return -EINVAL;
>>  	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		ret = vb2_verify_memory_type(&ctx->vq_dst, buf->memory,
>> +					     buf->type);
>> +		if (ret)
>> +			return ret;
>>  		if (ctx->state != MFCINST_GOT_INST) {
>>  			mfc_err("invalid context state: %d\n", ctx->state);
>>  			return -EINVAL;
>> @@ -1220,6 +1226,10 @@ static int vidioc_querybuf(struct file *file, void *priv,
>>  		}
>>  		buf->m.planes[0].m.mem_offset += DST_QUEUE_OFF_BASE;
>>  	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +		ret = vb2_verify_memory_type(&ctx->vq_src, buf->memory,
>> +					     buf->type);
>> +		if (ret)
>> +			return ret;
>>  		ret = vb2_querybuf(&ctx->vq_src, buf);
>>  		if (ret != 0) {
>>  			mfc_err("error in vb2_querybuf() for E(S)\n");
>> @@ -1828,6 +1838,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
>>  			*buf_count = MFC_MAX_BUFFERS;
>>  		psize[0] = ctx->enc_dst_buf_size;
>>  		alloc_devs[0] = ctx->dev->mem_dev[BANK_L_CTX];
>> +		memset(ctx->dst_bufs, 0, sizeof(ctx->dst_bufs));
>>  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>>  		if (ctx->src_fmt)
>>  			*plane_count = ctx->src_fmt->num_planes;
>> @@ -1849,6 +1860,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
>>  			alloc_devs[0] = ctx->dev->mem_dev[BANK_R_CTX];
>>  			alloc_devs[1] = ctx->dev->mem_dev[BANK_R_CTX];
>>  		}
>> +		memset(ctx->src_bufs, 0, sizeof(ctx->src_bufs));
>>  	} else {
>>  		mfc_err("invalid queue type: %d\n", vq->type);
>>  		return -EINVAL;
>> @@ -1865,25 +1877,47 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>>  	int ret;
>>  
>>  	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		dma_addr_t stream;
>> +
>>  		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
>>  		if (ret < 0)
>>  			return ret;
>> +
>> +		stream = vb2_dma_contig_plane_dma_addr(vb, 0);
>>  		i = vb->index;
>> +		if (ctx->dst_bufs[i].cookie.stream &&
>> +		    ctx->src_bufs[i].cookie.stream != stream) {
>> +			mfc_err("Changing CAPTURE buffer address during straming is not possible\n");
>> +			return -EINVAL;
>> +		}
>> +
>>  		ctx->dst_bufs[i].b = vbuf;
>> -		ctx->dst_bufs[i].cookie.stream =
>> -					vb2_dma_contig_plane_dma_addr(vb, 0);
>> +		ctx->dst_bufs[i].cookie.stream = stream;
>>  		ctx->dst_bufs_cnt++;
>>  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +		dma_addr_t luma, chroma;
>> +
>>  		ret = check_vb_with_fmt(ctx->src_fmt, vb);
>>  		if (ret < 0)
>>  			return ret;
>> +
>> +		luma = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +		chroma = vb2_dma_contig_plane_dma_addr(vb, 1);
>> +
>>  		i = vb->index;
>> +		if ((ctx->src_bufs[i].cookie.raw.luma &&
>> +		     ctx->src_bufs[i].cookie.raw.luma != luma) ||
>> +		    (ctx->src_bufs[i].cookie.raw.chroma &&
>> +		     ctx->src_bufs[i].cookie.raw.chroma != chroma)) {
>> +			mfc_err("Changing OUTPUT buffer address during straming is not possible\n");
>> +			return -EINVAL;
>> +		}
>> +
>>  		ctx->src_bufs[i].b = vbuf;
>> -		ctx->src_bufs[i].cookie.raw.luma =
>> -					vb2_dma_contig_plane_dma_addr(vb, 0);
>> -		ctx->src_bufs[i].cookie.raw.chroma =
>> -					vb2_dma_contig_plane_dma_addr(vb, 1);
>> -		ctx->src_bufs_cnt++;
>> +		ctx->src_bufs[i].cookie.raw.luma = luma;
>> +		ctx->src_bufs[i].cookie.raw.chroma = chroma;
>> +		if (vb->memory == V4L2_MEMORY_MMAP)
>> +			ctx->src_bufs_cnt++;
>>  	} else {
>>  		mfc_err("invalid queue type: %d\n", vq->type);
>>  		return -EINVAL;
