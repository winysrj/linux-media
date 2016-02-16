Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46495 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbcBPHpC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 02:45:02 -0500
Subject: Re: [PATCH v4 5/8] [Media] vcodec: mediatek: Add Mediatek V4L2 Video
 Encoder Driver
To: tiffany lin <tiffany.lin@mediatek.com>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
 <56C1B4AF.1030207@xs4all.nl> <1455604653.19396.68.camel@mtksdaap41>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C2D371.9090805@xs4all.nl>
Date: Tue, 16 Feb 2016 08:44:49 +0100
MIME-Version: 1.0
In-Reply-To: <1455604653.19396.68.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2016 07:37 AM, tiffany lin wrote:

<snip>

>>> +static int vidioc_venc_s_parm(struct file *file, void *priv,
>>> +			      struct v4l2_streamparm *a)
>>> +{
>>> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
>>> +
>>> +	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>>> +		ctx->enc_params.framerate_num =
>>> +			a->parm.output.timeperframe.denominator;
>>> +		ctx->enc_params.framerate_denom =
>>> +			a->parm.output.timeperframe.numerator;
>>> +		ctx->param_change |= MTK_ENCODE_PARAM_FRAMERATE;
>>> +	} else {
>>> +		return -EINVAL;
>>> +	}
>>
>> I'd invert the test:
>>
>> 	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> 		return -EINVAL;
>>
>> and now you can just set ctx->enc_params.
>>
> We will fix this in next version.
> 
> 
>>> +	return 0;
>>> +}
>>
>> And if there is an s_parm, then there should be a g_parm as well!
>>
> Now our driver does not support g_parm, our use cases do not use g_parm
> too. 
> Do we need to add g_parm at this moment? Or we could add it when we need
> g_parm?

No, you need it. You can see why if you look at the v4l2-compliance output:

                 test VIDIOC_G/S_PARM: OK (Not Supported)

Why does it think it is unsupported? Because (just like most applications) it
tries to call G_PARM first, and if that succeeds it tries to call S_PARM with
the value it got from G_PARM. Thus ensuring the application doesn't change the
driver state. So you can have a 'get' ioctl without the 'set' ioctl, but if
there is a 'set' ioctl there must always be a 'get' ioctl.

<snip>

>>> +static int vidioc_venc_g_s_selection(struct file *file, void *priv,
>>> +                                struct v4l2_selection *s)
>>
>> Why support s_selection if you can only return the current width and height?
>> And why support g_selection if you can't change the selection?
>>
>> In other words, why implement this at all?
>>
>> Unless I am missing something here, I would just drop this.
>>
> Now our driver do not support these capabilities, but userspace app will
> check whether g/s_crop are implemented when using encoder.
> Because g/s_crop are deprecated as you mentioned in previous v2 review
> comments. We change to use g_s_selection.
> We will check if we could add this capability.

It's true that you should use g/s_selection instead of g/s_crop, but only if
there is actually something to select. As long as you don't offer this capability,
just drop this for now.

When you add the capability later you can just add the g/s_selection functions.

Getting selection right can be tricky. I wouldn't mind if this is done later in a
separate patch.

> 
>>> +{
>>> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
>>> +	struct mtk_q_data *q_data;
>>> +
>>> +	if (V4L2_TYPE_IS_OUTPUT(s->type)) {
>>> +		if (s->target !=  V4L2_SEL_TGT_COMPOSE)
>>> +			return -EINVAL;
>>> +	} else {
>>> +		if (s->target != V4L2_SEL_TGT_CROP)
>>> +			return -EINVAL;
>>> +	}
>>> +
>>> +	if (s->r.left || s->r.top)
>>> +		return -EINVAL;
>>> +
>>> +	q_data = mtk_venc_get_q_data(ctx, s->type);
>>> +	if (!q_data)
>>> +		return -EINVAL;
>>> +
>>> +	s->r.width = q_data->width;
>>> +	s->r.height = q_data->height;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +
>>> +static int vidioc_venc_qbuf(struct file *file, void *priv,
>>> +			    struct v4l2_buffer *buf)
>>> +{
>>> +
>>> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
>>> +
>>> +	if (ctx->state == MTK_STATE_ABORT) {
>>> +		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error\n", ctx->idx);
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
>>> +}
>>> +
>>> +static int vidioc_venc_dqbuf(struct file *file, void *priv,
>>> +			     struct v4l2_buffer *buf)
>>> +{
>>> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
>>> +	if (ctx->state == MTK_STATE_ABORT) {
>>> +		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error\n", ctx->idx);
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
>>> +}
>>> +
>>> +
>>> +const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
>>> +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
>>> +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
>>> +
>>> +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
>>> +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
>>> +	.vidioc_qbuf			= vidioc_venc_qbuf,
>>> +	.vidioc_dqbuf			= vidioc_venc_dqbuf,
>>> +
>>> +	.vidioc_querycap		= vidioc_venc_querycap,
>>> +	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
>>> +	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
>>> +	.vidioc_enum_framesizes		= vidioc_enum_framesizes,
>>> +
>>> +	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
>>> +	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
>>> +	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
>>
>> Please add vidioc_create_bufs and vidioc_prepare_buf as well.
>>
> 
> Currently we do not support these use cases, do we need to add
> vidioc_create_bufs and vidioc_prepare_buf now?

I would suggest you do. The vb2 framework gives it (almost) for free.
prepare_buf is completely free (just add the helper) and create_bufs
needs a few small changes in the queue_setup function, that's all.

> 
> 
>>> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
>>> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>>> +
>>> +	.vidioc_s_parm			= vidioc_venc_s_parm,
>>> +
>>> +	.vidioc_s_fmt_vid_cap_mplane	= vidioc_venc_s_fmt,
>>> +	.vidioc_s_fmt_vid_out_mplane	= vidioc_venc_s_fmt,
>>> +
>>> +	.vidioc_g_fmt_vid_cap_mplane	= vidioc_venc_g_fmt,
>>> +	.vidioc_g_fmt_vid_out_mplane	= vidioc_venc_g_fmt,
>>> +
>>> +	.vidioc_g_selection		= vidioc_venc_g_s_selection,
>>> +	.vidioc_s_selection		= vidioc_venc_g_s_selection,
>>> +};

<snip>

>>> +int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
>>> +			   struct vb2_queue *dst_vq)
>>> +{
>>> +	struct mtk_vcodec_ctx *ctx = priv;
>>> +	int ret;
>>> +
>>> +	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>>> +	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
>>
>> I recomment dropping VB2_USERPTR. That only makes sense for scatter-gather dma,
>> and you use physically contiguous DMA.
>>
> Now our userspace app use VB2_USERPTR. I need to check if we could drop
> VB2_USERPTR.
> We use src_vq->mem_ops = &vb2_dma_contig_memops;
> And there are
> 	.get_userptr	= vb2_dc_get_userptr,
> 	.put_userptr	= vb2_dc_put_userptr,
> I was confused why it only make sense for scatter-gather.
> Could you kindly explain more?

VB2_USERPTR indicates that the application can use malloc to allocate buffers
and pass those to the driver. Since malloc uses virtual memory the physical
memory is scattered all over. And the first page typically does not start at
the beginning of the page but at a random offset.

To support that the DMA generally has to be able to do scatter-gather.

Now, where things get ugly is that a hack was added to the USERPTR support where
apps could pass a pointer to physically contiguous memory as a user pointer. This
was a hack for embedded systems that preallocated a pool of buffers and needed to
pass those pointers around somehow. So the dma-contig USERPTR support is for that
'feature'. If you try to pass a malloc()ed buffer to a dma-contig driver it will
reject it. One big problem is that this specific hack isn't signaled anywhere, so
applications have no way of knowing if the USERPTR support is the proper version
or the hack where physically contiguous memory is expected.

This hack has been replaced with DMABUF which is the proper way of passing buffers
around.

New dma-contig drivers should not use that old hack anymore. Use dmabuf to pass
external buffers around.

How do you use it in your app? With malloc()ed buffers? Or with 'special' pointers
to physically contiguous buffers?

> 
>>> +	src_vq->drv_priv	= ctx;
>>> +	src_vq->buf_struct_size = sizeof(struct mtk_video_enc_buf);
>>> +	src_vq->ops		= &mtk_venc_vb2_ops;
>>> +	src_vq->mem_ops		= &vb2_dma_contig_memops;
>>> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>>> +	src_vq->lock = &ctx->dev->dev_mutex;
>>> +
>>> +	ret = vb2_queue_init(src_vq);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>>> +	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
>>> +	dst_vq->drv_priv	= ctx;
>>> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>>> +	dst_vq->ops		= &mtk_venc_vb2_ops;
>>> +	dst_vq->mem_ops		= &vb2_dma_contig_memops;
>>> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>>> +	dst_vq->lock = &ctx->dev->dev_mutex;
>>> +
>>> +	return vb2_queue_init(dst_vq);
>>> +}

Regards,

	Hans

