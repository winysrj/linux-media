Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:30871 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932099AbcBQJXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 04:23:15 -0500
Message-ID: <1455700989.3782.7.camel@mtksdaap41>
Subject: Re: [PATCH v4 5/8] [Media] vcodec: mediatek: Add Mediatek V4L2
 Video Encoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
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
Date: Wed, 17 Feb 2016 17:23:09 +0800
In-Reply-To: <56C42FE3.8000105@xs4all.nl>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
	 <56C1B4AF.1030207@xs4all.nl> <1455604653.19396.68.camel@mtksdaap41>
	 <56C2D371.9090805@xs4all.nl> <1455628805.19396.82.camel@mtksdaap41>
	 <56C328AF.5030604@cisco.com> <1455696068.26202.4.camel@mtksdaap41>
	 <56C42FE3.8000105@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2016-02-17 at 09:31 +0100, Hans Verkuil wrote:
> On 02/17/16 09:01, tiffany lin wrote:
> > On Tue, 2016-02-16 at 14:48 +0100, Hans Verkuil wrote:
> >> Hi Tiffany,
> >>
> >>>>>>> +int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
> >>>>>>> +			   struct vb2_queue *dst_vq)
> >>>>>>> +{
> >>>>>>> +	struct mtk_vcodec_ctx *ctx = priv;
> >>>>>>> +	int ret;
> >>>>>>> +
> >>>>>>> +	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> >>>>>>> +	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> >>>>>>
> >>>>>> I recomment dropping VB2_USERPTR. That only makes sense for scatter-gather dma,
> >>>>>> and you use physically contiguous DMA.
> >>>>>>
> >>>>> Now our userspace app use VB2_USERPTR. I need to check if we could drop
> >>>>> VB2_USERPTR.
> >>>>> We use src_vq->mem_ops = &vb2_dma_contig_memops;
> >>>>> And there are
> >>>>> 	.get_userptr	= vb2_dc_get_userptr,
> >>>>> 	.put_userptr	= vb2_dc_put_userptr,
> >>>>> I was confused why it only make sense for scatter-gather.
> >>>>> Could you kindly explain more?
> >>>>
> >>>> VB2_USERPTR indicates that the application can use malloc to allocate buffers
> >>>> and pass those to the driver. Since malloc uses virtual memory the physical
> >>>> memory is scattered all over. And the first page typically does not start at
> >>>> the beginning of the page but at a random offset.
> >>>>
> >>>> To support that the DMA generally has to be able to do scatter-gather.
> >>>>
> >>>> Now, where things get ugly is that a hack was added to the USERPTR support where
> >>>> apps could pass a pointer to physically contiguous memory as a user pointer. This
> >>>> was a hack for embedded systems that preallocated a pool of buffers and needed to
> >>>> pass those pointers around somehow. So the dma-contig USERPTR support is for that
> >>>> 'feature'. If you try to pass a malloc()ed buffer to a dma-contig driver it will
> >>>> reject it. One big problem is that this specific hack isn't signaled anywhere, so
> >>>> applications have no way of knowing if the USERPTR support is the proper version
> >>>> or the hack where physically contiguous memory is expected.
> >>>>
> >>>> This hack has been replaced with DMABUF which is the proper way of passing buffers
> >>>> around.
> >>>>
> >>>> New dma-contig drivers should not use that old hack anymore. Use dmabuf to pass
> >>>> external buffers around.
> >>>>
> >>>> How do you use it in your app? With malloc()ed buffers? Or with 'special' pointers
> >>>> to physically contiguous buffers?
> >>>>
> >>> Understood now. Thanks for your explanation.
> >>> Now our app use malloc()ed buffers and we hook vb2_dma_contig_memops. 
> >>> I don't know why that dma-contig driver do not reject it.
> >>> I will try to figure it out.
> >>
> >> Is there an iommu involved that turns the scatter-gather list into what looks like
> >> contiguous memory for the DMA?
> >>
> > Yes, We have iommu that could make scatter-gather list looks like
> > contiguous memory.
> > 
> >> At the end of vb2_dc_get_userptr() in videobuf2-dma-contig.c there is a check
> >> 'if (contig_size < size)' that verifies that the sg DMA is contiguous. This would
> >> work if there is an iommu involved (if I understand it correctly).
> >>
> > I see. We saw this error before we add iommu support.
> > 
> >> If that's the case, then it's OK to keep VB2_USERPTR because you have real sg
> >> support (although not via the DMA engine, but via iommu mappings).
> >>
> > Got it. We will keep VB2_USERPTR.
> 
> Can you add a comment here mentioning that VB2_USERPTR works with dma-contig because
> there is an iommu? That should clarify this.
> 
Got it. I will add comment before this line.
src_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;.

I will also add out IOMMU patches information in cover letter, like:
The following patches are needed to support VB2_USERPTR works with
dma-contig.
https://patchwork.kernel.org/patch/8335461/
https://patchwork.kernel.org/patch/8335471/
https://patchwork.kernel.org/patch/8335481/
https://patchwork.kernel.org/patch/8335491/
https://patchwork.kernel.org/patch/8335501/
https://patchwork.kernel.org/patch/7596181/


best regards,
Tiffany



> Regards,
> 
> 	Hans


