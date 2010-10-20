Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:41056 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0JTOZ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 10:25:27 -0400
Date: Wed, 20 Oct 2010 16:25:18 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <000201cb6c1e$52002130$f6006390$%oh@samsung.com>
To: jaeryul.oh@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com
Message-id: <000001cb7062$a1e00470$e5a00d50$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
References: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
 <1286968160-10629-4-git-send-email-k.debski@samsung.com>
 <000201cb6c1e$52002130$f6006390$%oh@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>Hi, Kamil
>This is second feedback about the HW op related code. 
>(s5p_mfc_opr.c & s5p_mfc.c)

Hi, Peter

Thanks for the comments. I have replied to them below. I would be grateful
if you could cut out non relevant parts of the code in your replies. It was
difficult to find your comments in such a big email. I hope I have found all
of them.

[...]

>> +			s5p_mfc_set_dec_stream_buffer(ctx, \
>> +			      vb2_plane_paddr(temp_vb, 0), 0, \
>> +			      temp_vb->v4l2_planes[0].bytesused);
>> +			dev->curr_ctx = ctx->num;
>> +			s5p_mfc_clean_ctx_int_flags(ctx);
>> +			s5p_mfc_decode_one_frame(ctx,
>> +				temp_vb->v4l2_planes[0].bytesused == 0);
>> +		} else if (ctx->state == MFCINST_DEC_INIT) {
>> +			/* Preparing decoding - getting instance number */
>> +			mfc_debug("Getting instance number\n");
>> +			dev->curr_ctx = ctx->num;
>> +			s5p_mfc_clean_ctx_int_flags(ctx);
>> +/*			s5p_mfc_set_dec_temp_buffers(ctx);
>> + *			Removed per request by Peter, check if MFC works OK
>*/

>Yes, you don't have to set s5p_mfc_set_dec_temp_buffers(ctx)at this point
>'cause this is only required before parsing header of the stream except for

>setting shared memory, 
>so, I think, separating 'setting S5P_FIMV_SI_CH0_HOST_WR_ADR' from the 
>s5p_mfc_set_dec_temp_buffers() is needed. So I mean
>remove  'setting S5P_FIMV_SI_CH0_HOST_WR_ADR' from 
>s5p_mfc_set_dec_temp_buffers(ctx);, then add 'setting
>S5P_FIMV_SI_CH0_HOST_WR_ADR'
>in the 3 functions (s5p_mfc_set_dec_frame_buffer(),s5p_mfc_init_decode(),
>s5p_mfc_decode_one_frame()) 
>I also commented suggested loc. of 'setting S5P_FIMV_SI_CH0_HOST_WR_ADR'

Right, I've changed this.


>> +			ret = s5p_mfc_open_inst(ctx);
>> +			if (ret) {
>> +				mfc_err("Failed to create a new
instance.\n");
>> +				ctx->state = MFCINST_DEC_ERROR;
>> +			}
>> +		} else if (ctx->state == MFCINST_DEC_RETURN_INST) {
>> +			/* Closing decoding instance  */
>> +			mfc_debug("Returning instance number\n");
>> +			dev->curr_ctx = ctx->num;
>> +			s5p_mfc_clean_ctx_int_flags(ctx);
>> +			ret = s5p_mfc_return_inst_no(ctx);
>> +			if (ret) {
>> +				mfc_err("Failed to return an instance.\n");
>> +				ctx->state = MFCINST_DEC_ERROR;
>> +			}

[...]

>> +	}
>> +	/* Init videobuf2 queue for CAPTURE */
>> +	ret = vb2_queue_init(&ctx->vq_dst, &s5p_mfc_qops,
>> +			       dev->alloc_ctx[0], &dev->irqlock,
>> +			       V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, ctx);
>> +	if (ret) {
>> +		mfc_err("Failed to initialize videobuf2 queue (capture)\n");
>> +		goto out_open_3;
>> +	}
>> +	/* Init videobuf2 queue for OUTPUT */
>> +	ret = vb2_queue_init(&ctx->vq_src, &s5p_mfc_qops,
>> +			       dev->alloc_ctx[1], &dev->irqlock,
>> +			       V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, ctx);
>> +	if (ret) {
>> +		mfc_err("Failed to initialize videobuf2 queue (output)\n");
>> +		goto out_open_3;
>> +	}

>About using dev->irqlock, (spinlock_t *drv_lock) in the vb2_queue_init() is
>removed
>according to the Marek's patch (from the Hans Verkuil request)
> : http://www.spinics.net/lists/linux-media/msg23902.html
>Does it mean that we don't have to use drv_lock in the driver ?
>What actually purpose of drv_lock that you used in the MFC driver ?

I'll remove this when videobuf2 will be merged. The version posted by Marek
is still not final, so it is better to wait until a final version is worked
out in the community.


>> +	vb2_set_alloc_ctx(&ctx->vq_dst, dev->alloc_ctx[1], 1);
>> +	init_waitqueue_head(&ctx->queue);
>> +	mutex_unlock(dev->mfc_mutex);
>> +	mfc_debug("s5p_mfc_open--\n");
>> +	return ret;
>> +	/* Deinit when failure occured */
>> +out_open_3:
>> +	if (atomic_read(&dev->num_inst) == 1) {
>> +		clk_disable(dev->clock1);


[...]

>> +	mfc_debug("s5p_mfc_alloc_dec_temp_buffers++\n");
>> +	mfc_ctx->desc_phys = cma_alloc(mfc_ctx->dev->v4l2_dev.dev,
>> +					MFC_CMA_BANK1, DESC_BUF_SIZE, 2048);
>> +	if (IS_ERR_VALUE(mfc_ctx->desc_phys)) {
>> +		mfc_ctx->desc_phys = 0;
>> +		mfc_err("Allocating DESC buffer failed.\n");
>> +		return -ENOMEM;
>> +	}
>> +	desc_virt = ioremap_nocache(mfc_ctx->desc_phys, DESC_BUF_SIZE);

>In case of ioremap_xx() function, you might meet that msg as below
>"Don't allow RAM to be mapped - this causes problems with ARMv6+ "
>(arch/arm/mm/ioremap.c). so we should not use this function for this case.
>I suggest that you use phys_to_virt() with some cache op. such as 
>cache_clean for writing case(ex> memset) & cache_invalidate for reading
>case.
>(ex>reading shared mem)
>It is necessary for accessing shared memory(DRAM area accessed by ARM &
MFC)

At this moment we are waiting for the final CMA version and we don't know 
whether phys_to_virt will work with it. Now it has been changed from bug to 
a warning by Russel.

>> +	if (desc_virt == NULL) {
>> +		cma_free(mfc_ctx->desc_phys);
>> +		mfc_ctx->desc_phys = 0;
>> +		mfc_err("Remapping DESC buffer failed.\n");
>> +		return -ENOMEM;
>> +	}
>> +	/* Zero content of the allocated memory, in future this might be
>> done
>> +	 * by cma_alloc */
>> +	memset(desc_virt, 0, DESC_BUF_SIZE);
>> +	iounmap(desc_virt);
>> +	mfc_debug("s5p_mfc_alloc_dec_temp_buffers--\n");

[...]

>> +	mfc_debug("s5p_mfc_release_instance_buffer--\n");
>> +}
>> +
>> +/* Set registers for decoding temporary buffers */
>> +void s5p_mfc_set_dec_temp_buffers(struct s5p_mfc_ctx *mfc_ctx)
>> +{
>> +	struct s5p_mfc_dev *dev = mfc_ctx->dev;
>> +	WRITEL(OFFSETA(mfc_ctx->desc_phys), S5P_FIMV_SI_CH0_DESC_ADR);
>> +	WRITEL(CPB_BUF_SIZE, S5P_FIMV_SI_CH0_CPB_SIZE);
>> +	WRITEL(DESC_BUF_SIZE, S5P_FIMV_SI_CH0_DESC_SIZE);
>> +	WRITEL(mfc_ctx->shared_phys - mfc_ctx->dev->port_a,
>> +	       S5P_FIMV_SI_CH0_HOST_WR_ADR);
>> +}

>I mentioned that separating 'setting S5P_FIMV_SI_CH0_HOST_WR_ADR' from
>s5p_mfc_set_dec_temp_buffers() is better in terms of modular design.
>And what about having clear function name ? using 'temp' in the func. Name
>is not specific

What name do you suggest? If I name the function
s5p_mfc_set_dec_desc_buffer()
it will contain no information that other registers are set too.

>> +
>> +/* Set registers for decoding stream buffer */
>> +int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *mfc_ctx, int
>> buf_addr,
>> +		  unsigned int start_num_byte, unsigned int buf_size)
>> +{
>> +	struct s5p_mfc_dev *dev = mfc_ctx->dev;
>> +	mfc_debug("inst_no : %d, buf_addr : 0x%08x, buf_size : 0x%08x
>> (%d)\n",
>> +		  mfc_ctx->inst_no, buf_addr, buf_size, buf_size);
>> +	if (buf_addr & (2048 - 1)) {
>> +		mfc_err("Source stream buffer is not aligned correctly.\n");
>> +		return -EINVAL;
>> +	}

[...]

>> +	buf_size2 = mfc_ctx->port_b_size;
>> +	mfc_debug("Buf1: %p (%d) Buf2: %p (%d)\n", (void *)buf_addr1,
>> buf_size1,
>> +		  (void *)buf_addr2, buf_size2);
>> +	/* Enable generation of extra info */
>> +/*	*(shared_mem_vir_addr + 0x0038) = 63; */
>> +	mfc_debug("Total DPB COUNT: %d\n", mfc_ctx->total_dpb_count);
>> +	mfc_debug("Setting display delay to %d\n", mfc_ctx->display_delay);
>> +	dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) & 0xFFFF0000;
>> +	WRITEL(mfc_ctx->total_dpb_count | dpb,
>> S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
>> +	s5p_mfc_set_dec_temp_buffers(mfc_ctx);

>I think, all reg. set in the s5p_mfc_set_dec_temp_buffers(mfc_ctx)is not
>required
>at this point. 
>What about only adding 'set S5P_FIMV_SI_CH0_HOST_WR_ADR) instead of using 
>s5p_mfc_set_dec_temp_buffers()? 

Done.

>> +	switch (mfc_ctx->codec_mode) {
>> +	case S5P_FIMV_CODEC_H264_DEC:
>> +		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VERT_NB_MV_ADR);
>> +		buf_addr1 += S5P_FIMV_DEC_VERT_NB_MV_SIZE;
>> +		buf_size1 -= S5P_FIMV_DEC_VERT_NB_MV_SIZE;
>> +		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VERT_NB_IP_ADR);
>> +		buf_addr1 += S5P_FIMV_DEC_NB_IP_SIZE;
>> +		buf_size1 -= S5P_FIMV_DEC_NB_IP_SIZE;
>> +		break;
>> +	case S5P_FIMV_CODEC_MPEG4_DEC:
>> +	case S5P_FIMV_CODEC_DIVX311_DEC:
>> +	case S5P_FIMV_CODEC_DIVX412_DEC:
>> +	case S5P_FIMV_CODEC_DIVX502_DEC:

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

