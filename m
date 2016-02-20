Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:47375 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946389AbcBTJL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 04:11:28 -0500
Message-ID: <1455959480.12533.11.camel@mtksdaap41>
Subject: Re: [PATCH v4 5/8] [Media] vcodec: mediatek: Add Mediatek V4L2
 Video Encoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Date: Sat, 20 Feb 2016 17:11:20 +0800
In-Reply-To: <56C2D371.9090805@xs4all.nl>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
	 <56C1B4AF.1030207@xs4all.nl> <1455604653.19396.68.camel@mtksdaap41>
	 <56C2D371.9090805@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, 2016-02-16 at 08:44 +0100, Hans Verkuil wrote:
> On 02/16/2016 07:37 AM, tiffany lin wrote:
> >>> +
> >>> +const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
> >>> +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> >>> +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
> >>> +
> >>> +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> >>> +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> >>> +	.vidioc_qbuf			= vidioc_venc_qbuf,
> >>> +	.vidioc_dqbuf			= vidioc_venc_dqbuf,
> >>> +
> >>> +	.vidioc_querycap		= vidioc_venc_querycap,
> >>> +	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
> >>> +	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
> >>> +	.vidioc_enum_framesizes		= vidioc_enum_framesizes,
> >>> +
> >>> +	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
> >>> +	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
> >>> +	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
> >>
> >> Please add vidioc_create_bufs and vidioc_prepare_buf as well.
> >>
> > 
> > Currently we do not support these use cases, do we need to add
> > vidioc_create_bufs and vidioc_prepare_buf now?
> 
> I would suggest you do. The vb2 framework gives it (almost) for free.
> prepare_buf is completely free (just add the helper) and create_bufs
> needs a few small changes in the queue_setup function, that's all.
> 
After try to add vidioc_create_bufs directly using
vb2_ioctl_create_bufs, it will have problem in 
	int res = vb2_verify_memory_type(vdev->queue, p->memory,
			p->format.type);
We do not init our video_device queue in device probe function.

Our vb2_queues for OUTPUT and CAPTURE are initialized in
v4l2_m2m_ctx_init when ctx instance open.
What is queue in video_device for?
If we should init vdev->queue in probe function, this queue format
should be CAPTURE queue or OUTPUT queue?

best regards,
Tiffany

> > 
> > 
> >>> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> >>> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> >>> +
> >>> +	.vidioc_s_parm			= vidioc_venc_s_parm,
> >>> +
> >>> +	.vidioc_s_fmt_vid_cap_mplane	= vidioc_venc_s_fmt,
> >>> +	.vidioc_s_fmt_vid_out_mplane	= vidioc_venc_s_fmt,
> >>> +
> >>> +	.vidioc_g_fmt_vid_cap_mplane	= vidioc_venc_g_fmt,
> >>> +	.vidioc_g_fmt_vid_out_mplane	= vidioc_venc_g_fmt,
> >>> +
> >>> +	.vidioc_g_selection		= vidioc_venc_g_s_selection,
> >>> +	.vidioc_s_selection		= vidioc_venc_g_s_selection,
> >>> +};
> 
> <snip>
> 
> >>> +int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
> >>> +			   struct vb2_queue *dst_vq)
> >>> +{
> >>> +	struct mtk_vcodec_ctx *ctx = priv;
> >>> +	int ret;
> >>> +
> >>> +	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> >>> +	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> >>
> >> I recomment dropping VB2_USERPTR. That only makes sense for scatter-gather dma,
> >> and you use physically contiguous DMA.
> >>
> > Now our userspace app use VB2_USERPTR. I need to check if we could drop
> > VB2_USERPTR.
> > We use src_vq->mem_ops = &vb2_dma_contig_memops;
> > And there are
> > 	.get_userptr	= vb2_dc_get_userptr,
> > 	.put_userptr	= vb2_dc_put_userptr,
> > I was confused why it only make sense for scatter-gather.
> > Could you kindly explain more?
> 
> VB2_USERPTR indicates that the application can use malloc to allocate buffers
> and pass those to the driver. Since malloc uses virtual memory the physical
> memory is scattered all over. And the first page typically does not start at
> the beginning of the page but at a random offset.
> 
> To support that the DMA generally has to be able to do scatter-gather.
> 
> Now, where things get ugly is that a hack was added to the USERPTR support where
> apps could pass a pointer to physically contiguous memory as a user pointer. This
> was a hack for embedded systems that preallocated a pool of buffers and needed to
> pass those pointers around somehow. So the dma-contig USERPTR support is for that
> 'feature'. If you try to pass a malloc()ed buffer to a dma-contig driver it will
> reject it. One big problem is that this specific hack isn't signaled anywhere, so
> applications have no way of knowing if the USERPTR support is the proper version
> or the hack where physically contiguous memory is expected.
> 
> This hack has been replaced with DMABUF which is the proper way of passing buffers
> around.
> 
> New dma-contig drivers should not use that old hack anymore. Use dmabuf to pass
> external buffers around.
> 
> How do you use it in your app? With malloc()ed buffers? Or with 'special' pointers
> to physically contiguous buffers?
> 
> > 
> >>> +	src_vq->drv_priv	= ctx;
> >>> +	src_vq->buf_struct_size = sizeof(struct mtk_video_enc_buf);
> >>> +	src_vq->ops		= &mtk_venc_vb2_ops;
> >>> +	src_vq->mem_ops		= &vb2_dma_contig_memops;
> >>> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> >>> +	src_vq->lock = &ctx->dev->dev_mutex;
> >>> +
> >>> +	ret = vb2_queue_init(src_vq);
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> >>> +	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> >>> +	dst_vq->drv_priv	= ctx;
> >>> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> >>> +	dst_vq->ops		= &mtk_venc_vb2_ops;
> >>> +	dst_vq->mem_ops		= &vb2_dma_contig_memops;
> >>> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> >>> +	dst_vq->lock = &ctx->dev->dev_mutex;
> >>> +
> >>> +	return vb2_queue_init(dst_vq);
> >>> +}
> 
> Regards,
> 
> 	Hans
> 


